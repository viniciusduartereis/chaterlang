%%%-------------------------------------------------------------------
%%% @author Vinicius
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. out 2016 11:20
%%%-------------------------------------------------------------------
-module(database).
-author("Vinicius <viniciusduartereis@gmail.com>").

-include("user.hrl").
-include("message.hrl").

%% API
-export([init/0]).

-include("user.hrl").
-include("message.hrl").

init()->
  mnesia:create_schema([node()]),
  mnesia:start(),
  %%mnesia:clear_table(message),
  %%mnesia:clear_table(user),

  %MESSAGE
  mnesia:delete_table(message),
  mnesia:create_table(message,
    [{attributes, record_info(fields, message)},
      {index, [#message.nick,#message.type]}]),
  %%USER
  mnesia:delete_table(user),
  mnesia:create_table(user,
    [{attributes, record_info(fields, user)},
      {index,[#user,[#user.nick]]}]).


