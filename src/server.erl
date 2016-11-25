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
      User = #user{node = Node,pid = Pid ,nick = Nick, on = true, messages = []},
      [T | _ ] = user_service:get(User),
      io:format("select: ~w\n",[T]),
      io:format("before messages: ~w\n",[User#user.messages]),
      User#user.messages ++ T#user.messages,
      io:format("after messages: ~w\n",[User#user.messages]),
      io:format("client: ~s connected.~n", [Nick]),
      broadcast(join, Users, {Nick}),


      %% SE ESTIVER JA NO BANCO, RECEBER AS MENSAGENS ARMAZENAS QUANDO OFFLINE E APAGAR AS MENSAGENS

      user_service:add_record(User),
      chat([User]++ Users);

    {Node, _, send, Message} ->
      User = findNode(Node, Users),
      io:format("~s: ~s~n", [User#user.nick, Message]),
      broadcast(new_message, Users, {User#user.nick, Message}),
      %% {{Y,MON,D},{H,MIN,S}} = calendar:local_time(),
      M = #message{nick = User#user.nick,type = new_message, text = Message, date = erlang:system_time()},
      message_service:add_record(M),
      UsersOff = user_service:getOff(),
      %% SE ESTIVER ON == FALSE, ARMAZENAR AS MENSAGENS !!!!!!!!!!

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

msToDate(Milliseconds) ->
  BaseDate      = calendar:datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}}),
  Seconds       = BaseDate + (Milliseconds div 1000),
  { Date,_Time} = calendar:gregorian_seconds_to_datetime(Seconds),
  Date.

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

