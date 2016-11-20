%%%-------------------------------------------------------------------
%%% @author Vinicius
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. out 2016 16:13
%%%-------------------------------------------------------------------
-module(server).
-author("Vinicius <viniciusduartereis@gmail.com>").

%%  erl -sname no -run modulo funcao -run init stop -noshell

%% API
-export([start/0,chat/1]).
%%-compile(export_all).

-include("chat.hrl").

start() ->
  database:init(),
  register(server_chat, spawn(server, chat, [[]])).


chat(Users) ->
  process_flag(trap_exit, true),
  receive
    {Node, Pid, join, Nick} ->
      link(Pid),
      io:format("client: ~s connected.~n", [Nick]),
      broadcast(join, Users, {Nick}),
      User = #user{node = Node,pid = Pid ,nick = Nick, on = true, messages = [] },
      %% SE ESTIVER JA NO BANCO, RECEBER AS MENSAGENS ARMAZENAS QUANDO OFFLINE E APAGAR AS MENSAGENS
      user_service:add_record(User),
      chat([User]++ Users);

    {Node, _, send, Message} ->
      User = findNode(Node, Users),
      io:format("~s: ~s~n", [User#user.nick, Message]),
      broadcast(new_message, Users, {User#user.nick, Message}),
      Message = #message{nick=User#user.nick, text = Message,type = new_message, date = calendar:local_time()},
      %% SE ESTIVER ON == FALSE, ARMAZENAR AS MENSAGENS !!!!!!!!!!
      message_service:add_record(Message),
      chat(Users);
    {'EXIT', Pid, _} ->
      User = findPid(Pid, Users),
      io:format("client: ~s left.~n", [User#user.nick]),
      broadcast(disconnect, Users, {User#user.nick}),
      UserAdd = #user{node = User#user.node,pid = User#user.pid ,nick = User#user.nick, on = false, messages = User#user.messages },
      user_service:add_record(UserAdd),
      chat(remove(User, Users));
    _ ->
      chat(Users)

  end.

findNode(From, [ User | _]) when From == User#user.node ->
  User;
findNode(From, [_ | User]) ->
  findNode(From, User).

findPid(From, [ User | _]) when From == User#user.pid ->
  User;
findPid(From, [_ | User]) ->
  findPid(From, User).

remove(From, Users) ->
  [T || T <- Users, T /= From].

broadcast(join, Users, {Nick}) ->
  broadcast({info, Nick ++ " connected."}, Users);
broadcast(new_message, Users, {Nick, Message}) ->
  broadcast({new_message, Nick, Message}, Users);
broadcast(disconnect, Users, {Nick}) ->
  broadcast({info, Nick ++ " left."}, Users).

broadcast(Message, [ User | Users ]) ->
  User#user.pid ! Message,
  broadcast(Message, Users);
broadcast(_, []) ->
  true.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%	TCP SOCKET TEST
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% start1() ->
%   {ok, ServerSocket} = gen_tcp:listen(?PORT, ?TCP_OPTIONS),
%   chat1(ServerSocket, []).
% 
% chat1(Server, Users) ->
%   case gen_tcp:accept(Server) of
%     {ok, Client} ->
%       Client ! {join, Client},
%       chat1(Server, Users ++ [Client] );
%     _ ->
%       io:format("\n")
%   end.

