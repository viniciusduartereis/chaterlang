%%%-------------------------------------------------------------------
%%% @author Vinicius
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. out 2016 16:13
%%%-------------------------------------------------------------------
-module(server).
-author("Vinicius").

%% API
-compile(export_all).

chat(Users) ->
  process_flag(trap_exit, true),
  receive
    {Pid, join, Nick} ->
      link(Pid),
      io:format("cliente: ~s conectado~n", [Nick]),
      broadcast(join, Users, {Nick}),
      chat([{Nick, Pid} | Users]);
    {Pid, send, Message} ->
      From = find(Pid, Users),
      io:format("~s: ~s~n", [From, Message]),
      broadcast(new_message, Users, {From, Message}),
      chat(Users);
    {'EXIT', Pid, _} ->
      Nick = find(Pid, Users),
      io:format("cliente: ~s saiu~n", [Nick]),
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
  broadcast({info, Nick ++ " conectado."}, Users);
broadcast(new_message, Users, {Nick, Message}) ->
  broadcast({new_message, Nick, Message}, Users);
broadcast(disconnect, Users, {Nick}) ->
  broadcast({info, Nick ++ " saiu."}, Users).

broadcast(Message, [{_, Pid} | Users]) ->
  Pid ! Message,
  broadcast(Message, Users);
broadcast(_, []) ->
  true.

start() ->
  register(server_chat, spawn(server, chat, [[]])).
