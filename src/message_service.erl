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

%% Nó UNICO node() ao entrar
%% Armazenar as mensagens quando usuario estiver desconectado.
%% Receber as mensagens pendentes ao entrar

-include("chat.hrl").
-include_lib("stdlib/include/qlc.hrl").

add(Nick, Text,Type) ->
  Item = #message{nick=Nick, text = Text,type = Type, date = calendar:local_time()},
  F = fun() ->
    mnesia:write(Item)
      end,
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
  mnesia:select(message, Match).

find(Type) ->
  Match = ets:fun2ms(
    fun(#message{nick=From, text=To,type=T,date=D})
      when T =:= Type ->
      {From, To, T,D}
    end
  ),
  mnesia:select(message, Match).

find_by_nick(Nick) ->
  F = fun() -> mnesia:read({message, Nick}) end,
  case mnesia:activity(transaction, F) of
    [] -> undefined;
    [#message{nick = N, text = M,type = T,date = D}] -> {N,M,T,D}
  end.

select_messages()->
  F = fun() ->
    Query = qlc:q([X || X <- mnesia:table(message)]),
    qlc:e(Query)
      end,
  {atomic, Val} = mnesia:transaction(F),
  Val.
    