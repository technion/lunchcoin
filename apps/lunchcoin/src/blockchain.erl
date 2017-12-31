-module(blockchain).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-include_lib("stdlib/include/ms_transform.hrl").
-include("block_rec.hrl").
%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-export([makeblock/1, gettoday/0]).
%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------
-define(INTERVAL, 2000).

init(_Args) ->
    blockchain = ets:new(blockchain, [public, ordered_set, named_table, {keypos, #block.index}]),
    Genesis = block:genesis(),
    true = ets:insert_new(blockchain, Genesis),
    {ok, []}.

handle_call({makeblock, Data}, _From, State) ->
    % Insert a new block only if the chain is intact
    [Last| _Cannot] = ets:lookup(blockchain, ets:last(blockchain)),
    try block:verify_chain(Last, Last#block.hash) of
    ok ->
        NewBlock = block:make_block(Data, Last),
        true = ets:insert_new(blockchain, NewBlock),
        {reply, ok, State}
    catch
    error:_Error ->
        {reply, compromised_chain, State}
    end;

handle_call(gettoday, _From, State) ->
    % Verify the chain before proceeding
    [Last| _Cannot] = ets:lookup(blockchain, ets:last(blockchain)),
    try block:verify_chain(Last, Last#block.hash) of
    ok ->
        T = erlang:monotonic_time(second),
        K = ets:fun2ms(
            fun(_B = #block{timestamp = Timestamp, data = Data})
                when Timestamp > (T - 3600) -> Data
            end),
        Orders = ets:select(blockchain, K),
        {reply, Orders, State}
    catch
    error:_Error ->
        {reply, compromised_chain, State}
    end;

handle_call(terminate, _From, State) ->
    {stop, normal, ok, State};

handle_call(_Data, _From, State) ->
    {reply, unhandled, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ets:delete(blockchain),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

makeblock(Data) ->
    % Utilise local process registry to access registered name of this gen_server
    gen_server:call(?SERVER, {makeblock, Data}).

gettoday() ->
    gen_server:call(?SERVER, gettoday).
