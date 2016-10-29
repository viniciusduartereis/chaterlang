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

%% API
-export([start/0,chat/1]).
%%-compile(export_all).

-include("chat.hrl").

start() ->
  register(server_chat, spawn(server, chat, [[]])).


chat(Users) ->
  process_flag(trap_exit, true),
  receive
    {Pid, join, Nick} ->
      link(Pid),
      io:format("client: ~s connected.~n", [Nick]),
      broadcast(join, Users, {Nick}),
      chat([{Nick, Pid} | Users]);
    {Pid, send, Message} ->
      From = find(Pid, Users),
      io:format("~s: ~s~n", [From, Message]),
      broadcast(new_message, Users, {From, Message}),
      chat(Users);
    {'EXIT', Pid, _} ->
      Nick = find(Pid, Users),
      io:format("client: ~s left.~n", [Nick]),
      broadcast(disconnect, Users, {Nick}),
      chat(remove({Nick, Pid}, Users));
    _ ->
      chat(Users)

  end.

find(From, [{Nick, Pid} | _]) when From == Pid ->
  Nick;
find(From, [_ | T]) ->
  find(From, T).

remove(From, Users) ->
  [T || T <- Users, T /= From].

broadcast(join, Users, {Nick}) ->
  broadcast({info, Nick ++ " connected."}, Users);
broadcast(new_message, Users, {Nick, Message}) ->
  broadcast({new_message, Nick, Message}, Users);
broadcast(disconnect, Users, {Nick}) ->
  broadcast({info, Nick ++ " left."}, Users).

broadcast(Message, [{_, Pid} | Users]) ->
  Pid ! Message,
  broadcast(Message, Users);
broadcast(_, []) ->
  true.



start1() ->
  {ok, ServerSocket} = gen_tcp:listen(?PORT, ?TCP_OPTIONS),
  chat1(ServerSocket, []).

chat1(Server, Users) ->
  case gen_tcp:accept(Server) of
    {ok, Client} ->
      Client ! {join, Client},
      chat1(Server, Users ++ [Client] );
    _ ->
      io:format("\n")
  end.

