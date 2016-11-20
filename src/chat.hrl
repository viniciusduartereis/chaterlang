%%%-------------------------------------------------------------------
%%% @author Vinicius
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. out 2016 11:12
%%%-------------------------------------------------------------------
-author("Vinicius <viniciusduartereis@gmail.com>").

%% CONFIG
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]).
-define(PORT, 5483).


%% MODELS
-record(message,{nick,type,text,date}).
-record(message_type,{info,join,new_message,disconnect}).
%%-record(user,{node,pid,nick}).
-record(user,{node,pid,nick,on,messages = []}).



