%%%-------------------------------------------------------------------
%%% @author Vinicius
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. out 2016 16:13
%%%-------------------------------------------------------------------
-module(client).
-author("Vinicius <viniciusduartereis@gmail.com>").

%% API
-export([join/1,chat/2]).
%%-compile(export_all).

-include("user.hrl").
-include("message.hrl").


join(Nick) ->
  Server = {server_chat, 'server@MacBook-Pro-de-Vinicius'},
  Pid = spawn(client, chat, [Server, Nick]),
  Server ! {Pid, join, Nick},
  Pid.

chat(Server, Nick) ->
  receive
    {send, Message} ->
      Server ! {self(), send, Message},
      chat(Server, Nick);
    {new_message, From, Message} ->
      io:format("[~s] - ~s said: ~s~n", [Nick, From, Message]),
      chat(Server, Nick);
    {info, Message} ->
      io:format("[~s] - ~s~n", [Nick, Message]),
      chat(Server, Nick);
    _ ->
      io:format("[~s] - Error - invalid command.~n", [Nick]),
      chat(Server, Nick)
  end.




