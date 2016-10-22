%%%-------------------------------------------------------------------
%%% @author Vinicius
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. out 2016 16:13
%%%-------------------------------------------------------------------
-module(client).
-author("Vinicius").


%% API
-compile(export_all).

chat(Server, Nick) ->
  receive
    {send, Message} ->
      Server ! {self(), send, Message},
      chat(Server, Nick);
    {new_msg, From, Message} ->
      io:format("[~s] - ~s disse: ~s~n", [Nick, From, Message]),
      chat(Server, Nick);
    {info, Message} ->
      io:format("[~s] - ~s~n", [Nick, Message]),
      chat(Server, Nick);
    _ ->
      io:format("[~s] - Erro - Comando inválido.~n", [Nick]),
      chat(Server, Nick)
  end.

%send() ->
%  {ok, [Message]} = io:fread("Digite a mensagem: ", "~s"),
%  {server_chat, 'server@MacBook-Pro-de-Vinicius'} ! {self(), send, Message}.

join(Nick) ->
  Server = {server_chat, 'server@MacBook-Pro-de-Vinicius'},
  Pid = spawn(client, chat, [Server, Nick]),
  Server ! {Pid, join, Nick},
  Pid.


