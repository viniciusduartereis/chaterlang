%%%-------------------------------------------------------------------
%%% @author Vinicius
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. out 2016 11:33
%%%-------------------------------------------------------------------
-module(message_service).
-author("Vinicius <viniciusduartereis@gmail.com>").

%% API
-export([]).

-include("message.hrl").

add(Nick, Text,Type) ->
  F = fun() -> mnesia:write(#message{nick=Nick, text = Text,type = Type, date = calendar:local_time()}) end,
  mnesia:transaction(F).

delete(Nick)->
  F = fun() -> mnesia:delete({message, Nick}) end,
  mnesia:activity(transaction, F).

find(Nick) ->
  Match = ets:fun2ms(
    fun(#message{nick=From, text=To,type=T,date=D})
      when From =:= Nick ->
      {From, To, T,D}
    end
  ),
  mnesia:select(mafiapp_services, Match).

find(Type) ->
  Match = ets:fun2ms(
    fun(#message{nick=From, text=To,type=T,date=D})
      when T =:= Type ->
      {From, To, T,D}
    end
  ),
  mnesia:select(mafiapp_services, Match).

find_by_nick(Nick) ->
  F = fun() -> mnesia:read({message, Nick}) end,
  case mnesia:activity(transaction, F) of
    [] -> undefined;
    [#message{nick = N, text = M,type = T,date = D}] -> {N,M,T,D}
  end.