
-module(user_service).
-author("Vinicius <viniciusduartereis@gmail.com>").

-include("chat.hrl").
-include_lib("stdlib/include/qlc.hrl").

%% API
-compile(export_all).

%% -record(user,{node,pid,nick,on = false,messages = []}).

add(Node, Pid, Nick, On, Messages) ->
  Item = #user{node=Node, pid = Pid,nick = Nick, on = On, messages = Messages},
  F = fun() ->
    mnesia:write(Item)
      end,
  mnesia:transaction(F).

add_record(U) ->
  %%Item = #user{node = U#user.node, pid = U#user.pid,nick = U#user.nick, on = U#user.on, messages = U#user.messages},
  F = fun() ->
    mnesia:write(U)
      end,
  mnesia:transaction(F).

select()->
  F = fun() ->
    Query = qlc:q([ X || X <- mnesia:table(user)]),
    qlc:e(Query)
      end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

get(U)->
  F = fun() ->
    Query = qlc:q([ X || X <- mnesia:table(user), X#user.nick =:= U#user.nick andalso X#user.node =:= U#user.node  ]),
    qlc:e(Query)
      end,
  {atomic, Val} = mnesia:transaction(F),
  Val.

getOff()->
  F = fun() ->
    Query = qlc:q([ X || X <- mnesia:table(user), X#user.on =:= false ]),
    qlc:e(Query)
      end,
  {atomic, Val} = mnesia:transaction(F),
  Val.