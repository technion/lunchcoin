%%%-------------------------------------------------------------------
%% @doc lunchcoin public API
%% @end
%%%-------------------------------------------------------------------

-module(lunchcoin_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    {ok, _Pid} = blockchain:start_link(),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/api/[...]", api_handler, []}
        ]}
    ]),
    {ok, Port} = application:get_env(lunchcoin, bind_port),
    {ok, _Pid2} = cowboy:start_clear(http,
            [{ip, {127, 0, 0, 1}}, {port, Port}],
            #{ env => #{dispatch => Dispatch}}
    ),

    lunchcoin_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
