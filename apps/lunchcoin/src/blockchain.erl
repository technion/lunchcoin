-module(blockchain).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

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

-export([makeblock/2]).
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
    try block:verifyChain(Last, Last#block.hash) of
    ok ->
        NewBlock = block:makeBlock(Data, Last),
        true = ets:insert_new(blockchain, NewBlock),
        {reply, ok, State}
    catch
    error:_Error ->
        {reply, "Invalid or Compromised Chain", State}
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

makeblock(Pid, Data) ->
    gen_server:call(Pid, {makeblock, Data}).
