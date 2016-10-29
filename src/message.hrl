%%%-------------------------------------------------------------------
%%% @author Vinicius
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. out 2016 11:12
%%%-------------------------------------------------------------------
-author("Vinicius <viniciusduartereis@gmail.com>").

-record(message,{nick,type,text,date}).
-record(message_type,{info,join,new_message}).

