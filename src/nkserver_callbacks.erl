%% -------------------------------------------------------------------
%%
%% Copyright (c) 2019 Carlos Gonzalez Florido.  All Rights Reserved.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%% -------------------------------------------------------------------

%% @doc Default plugin callbacks
-module(nkserver_callbacks).
-author('Carlos Gonzalez <carlosj.gf@gmail.com>').
-export([i18n/3, status/1]).
-export([srv_init/2, srv_handle_call/4, srv_handle_cast/3,
         srv_handle_info/3, srv_code_change/4, srv_terminate/3,
         srv_timed_check/2]).
-export([srv_master_init/2, srv_master_handle_call/4, srv_master_handle_cast/3,
         srv_master_handle_info/3, srv_master_code_change/4, srv_master_terminate/3,
         srv_master_timed_check/3, srv_master_become_leader/2]).
-export([trace_create/3, trace_finish/2, trace_event/4, trace_log/6, trace_tags/3]).
-export_type([continue/0]).

-include("nkserver.hrl").


%% ===================================================================
%% Types
%% ===================================================================


-type continue() :: continue | {continue, list()}.
%-type req() :: #nkreq{}.
-type id() :: nkserver:id().
-type user_state() :: map().
-type service() :: nkserver:service().



%% ===================================================================
%% Callbacks
%% ===================================================================


%% Called when the service starts, to update the start options.
-callback config(map()) -> map().


-optional_callbacks([config/1]).


%% ===================================================================
%% Status Callbacks
%% ===================================================================


%% @doc
-spec status(nkserver:status()) ->
    nkserver_status:desc_status() | continue.

status(auth_invalid) 	            -> {"Auth token is not valid", #{code=>400}};
status(bad_request)                 -> {"Bad Request", #{code=>400}};
status(conflict)                    -> {"Conflict", #{code=>409}};
status(content_type_invalid)        -> {"ContentType is invalid", #{code=>400}};
status({field_invalid, F})          -> {"Field '~s' is invalid", [F], #{code=>400, data=>#{field=>F}}};
status({field_missing, F})          -> {"Field '~s' is missing", [F], #{code=>400, data=>#{field=>F}}};
status({field_unknown, F})          -> {"Field '~s' is unknown", [F], #{code=>400, data=>#{field=>F}}};
status(file_too_large)              -> {"File too large", #{code=>400}};
status(forbidden)                   -> {"Forbidden", #{code=>403}};
status(gone)                        -> {"Gone", #{code=>410}};
status(internal_error)              -> {"Internal error", #{code=>500}};
status({internal_error, Ref})	    -> {"Internal error: ~s", [Ref], #{code=>500, data=>#{ref=>Ref}}};
status(invalid_parameters) 		    -> "Invalid parameters";
status(leader_is_down)              -> "Service leader is down";
status({method_not_allowed, M})      -> {"Method not allowed: '~s'", [M], #{code=>405}};
status({module_failed, M})          -> {"Module '~s' failed", [M]};
status({namespace_invalid, N})      -> {"Namespace '~s' is invalid", [N]};
status({namespace_not_found, N})    -> {"Namespace '~s' not found", [N]};
status(not_allowed)                 -> {"Not allowed", #{code=>409}};
status(normal_termination) 		    -> "Normal termination";
status(not_found)                   -> {"Not found", #{code=>404}};
status(not_implemented) 		    -> "Not implemented";
status(nkdomain)                    -> {"DNS Domain", #{code=>422}};
status(ok)                          -> "OK";
status(operation_invalid) 	        -> "Invalid operation";
status(operation_token_invalid) 	-> "Operation token is invalid";
status({parameter_invalid, T})      -> {"Invalid parameter '~s'", [T], #{code=>400, data=>#{parameter=>T}}};
status({parameter_missing, T})      -> {"Missing parameter '~s'", [T], #{code=>400, data=>#{parameter=>T}}};
status(parse_error)   		        -> "Object parse error";
status(password_valid)              -> {"Password is valid", #{code=>200}};
status(password_invalid) 	        -> {"Password is not valid", #{code=>200}};
status(process_down)  			    -> "Process failed";
status(process_not_found) 		    -> "Process not found";
status(redirect)                    -> {"Redirect", #{code=>307}};
status(request_body_invalid)        -> {"The request body is invalid", #{code=>400}};
status(resource_invalid)            -> {"Invalid resource", #{code=>404}};
status({resource_invalid, R})       -> {"Invalid resource '~s'", [R], #{code=>200, data=>#{resource=>R}}};
status({resource_invalid, G, R})    -> {"Invalid resource '~s' (~s)", [R, G], #{code=>200, data=>#{resource=>R, group=>G}}};
status(service_not_found) 		    -> {"Service not found", #{code=>409}};
status({service_not_found, S}) 	    -> {"Service '~s' not found", [S], #{code=>409}};
status(service_down)                -> "Service is down";
status({service_not_available, S})  -> {"Service '~s' not available", [S], #{code=>422, data=>#{service=>S}}};
status({syntax_error, F})           -> {"Syntax error: '~s'", [F], #{code=>400, data=>#{field=>F}}};
status({tls_alert, Txt}) 			-> {"Error TTL: ~s", [Txt]};
status(timeout)                     -> {"Timeout", #{code=>504}};
status(too_many_records)            -> {"Too many records", #{code=>504}};
status(too_many_requests)           -> {"Too many requests", #{code=>429}};
status(unauthorized)                -> {"Unauthorized", #{code=>401}};
status(unprocessable)               -> {"Unprocessable", #{code=>422}};
status(utf8_error)                  -> {"UTF8 error", #{code=>400}};
status(verb_not_allowed)            -> {"Verb is not allowed", #{code=>405}};
status(version_not_allowed)         -> {"Version not allowed", #{code=>422}};
status(_)   		                 -> continue.



%% ===================================================================
%% i18n
%% ===================================================================


%% @doc
-spec i18n(id(), nklib_i18n:key(), nklib_i18n:lang()) ->
    <<>> | binary().

i18n(SrvId, Key, Lang) ->
    nklib_i18n:get(SrvId, Key, Lang).



%% ===================================================================
%% Service Server Callbacks
%% ===================================================================

%% @doc Called when a new service starts, first for the top-level plugin
-spec srv_init(service(), user_state()) ->
	{ok, user_state()} | {stop, term()}.

srv_init(_Service, UserState) ->
	{ok, UserState}.


%% @doc Called when the service process receives a handle_call/3.
-spec srv_handle_call(term(), {pid(), reference()}, id(), user_state()) ->
	{reply, term(), user_state()} | {noreply, user_state()} | continue().

srv_handle_call(_Msg, _From, _Service, _State) ->
    continue.


%% @doc Called when the NkApp process receives a handle_cast/3.
-spec srv_handle_cast(term(), service(), user_state()) ->
	{noreply, user_state()} | continue().

srv_handle_cast(_Msg, _Service, _State) ->
    continue.


%% @doc Called when the NkApp process receives a handle_info/3.
-spec srv_handle_info(term(), service(), user_state()) ->
	{noreply, user_state()} | continue().

srv_handle_info({'EXIT', _, normal}, _Service, State) ->
	{noreply, State};

srv_handle_info(_Msg, _Service, _State) ->
    continue.


-spec srv_code_change(term()|{down, term()}, service(), user_state(), term()) ->
    ok | {ok, service()} | {error, term()} | continue().

srv_code_change(OldVsn, _Service, State, Extra) ->
	{continue, [OldVsn, State, Extra]}.


%% @doc Called when a service is stopped
-spec srv_terminate(term(), service(), service()) ->
	{ok, service()}.

srv_terminate(_Reason, _Service, State) ->
	{ok, State}.


%% @doc Called periodically
-spec srv_timed_check(service(), user_state()) ->
    {ok, user_state()}.

srv_timed_check(_Service, State) ->
    {ok, State}.



%% ===================================================================
%% Service Server MASTER Callbacks
%% ===================================================================

%% @doc Called when a new service starts, first for the top-level plugin
-spec srv_master_init(id(), user_state()) ->
    {ok, user_state()} | {stop, term()} | continue().

srv_master_init(_SrvId, UserState) ->
    {ok, UserState}.


%% @doc Called when the service process receives a handle_call/3.
-spec srv_master_handle_call(term(), {pid(), reference()}, id(), user_state()) ->
    {reply, term(), user_state()} | {noreply, user_state()} | continue().

srv_master_handle_call(_Msg, _From, _SrvId, _State) ->
    continue.


%% @doc Called when the NkApp process receives a handle_cast/3.
-spec srv_master_handle_cast(term(), id(), user_state()) ->
    {noreply, user_state()} | continue().

srv_master_handle_cast(_Msg, _SrvId, _State) ->
    continue.


%% @doc Called when the NkApp process receives a handle_info/3.
-spec srv_master_handle_info(term(), id(), user_state()) ->
    {noreply, user_state()} | continue().

srv_master_handle_info({'EXIT', _, normal}, _SrvId, State) ->
    {noreply, State};

srv_master_handle_info(_Msg, _SrvId, _State) ->
    continue.


-spec srv_master_code_change(term()|{down, term()}, id(), user_state(), term()) ->
    ok | {ok, service()} | {error, term()} | continue().

srv_master_code_change(OldVsn, _SrvId, State, Extra) ->
    {continue, [OldVsn, State, Extra]}.


%% @doc Called when a service is stopped
-spec srv_master_terminate(term(), service(), service()) ->
    {ok, service()}.

srv_master_terminate(_Reason, _SrvId, State) ->
    {ok, State}.


%% @doc Called periodically
-spec srv_master_timed_check(IsMaster::boolean(), id(), user_state()) ->
    {ok, user_state()}.

srv_master_timed_check(_IsMaster, _SrvId, State) ->
    {ok, State}.


%% @doc Called when this node tries to become leader
-spec srv_master_become_leader(id(), user_state()) ->
    {yes|no, user_state()}.

srv_master_become_leader(SrvId, State) ->
    {nkserver_master:strategy_min_nodes(SrvId), State}.




%% ===================================================================
%% Trace callbacks
%% ===================================================================

%% @doc Called when nkserver_trace:run/4 is run, to initialize
%% a new trace. Must return a trace identification, that will be used
%% when calling the fun
%% By default it returns a trace {nkserver_trace, Name} that is
%% showed on screen with nkserver_trace:log/2,3

-spec trace_create(id(), nkserver_trace:name(), nkserver_trace:run_opts()) ->
    {ok, nkserver_trace:id()}.

trace_create(_SrvId, TraceId, _Opts) ->
    {ok, TraceId}.


%% @doc Called when nkserver_trace:finish/1 is called, to finishes a started trace.
-spec trace_finish(id(), nkserver_trace:id()) -> any().

trace_finish(SrvId, TraceId) ->
    trace_log(SrvId, TraceId, debug, "trace finished", [], #{}).


%% @doc Called when nkserver_trace:event/2,3 is called
-spec trace_event(id(), nkserver_trace:id(), nkserver_trace:event_type(), nkserver_trace:data()) ->
    any().

trace_event(SrvId, TraceId, Type, _Meta) ->
    lager:info("Service '~s' (trace ~p) EVT ~s", [SrvId, TraceId, Type]).



%% @doc Called when nkserver_trace:log/2,3 is called
%% It can do any processing

-spec trace_log(id(), nkserver_trace:id(), nkserver_trace:level(), string(), list(), nkserver_trace:data()) ->
    any().

trace_log(SrvId, TraceId, Level, Txt, Args, _Meta) ->
    lager:log(Level, [], "Service '~s' (trace ~p) LOG "++Txt, [SrvId, TraceId|Args]).


%% @doc Adds a number of tags to a trace
-spec trace_tags(id(), nkserver_trace:id(), map()) -> any().

trace_tags(SrvId, TraceId, Tags) ->
    lager:debug("Service '~s' (trace ~p) TAGS ~p", [SrvId, TraceId, Tags]).


