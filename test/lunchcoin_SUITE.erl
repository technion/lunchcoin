-module(lunchcoin_SUITE).

-include_lib("common_test/include/ct.hrl").
-export([all/0]).
-export([created_genesis/1,
         add_blocks/1,
         corrupt_chain/1,
         init_per_suite/1,
         end_per_suite/1
        ]).

init_per_suite(Config) ->
    application:ensure_all_started(lunchcoin),
    Config.

all() -> [created_genesis, add_blocks, corrupt_chain].

created_genesis(_Config) ->
    1 = length(ets:tab2list(blockchain)).

add_blocks(_Config) ->
    ok = blockchain:makeblock("Adding a block"),
    ok = blockchain:makeblock("Adding a third block"),
    3 = length(ets:tab2list(blockchain)).

corrupt_chain(_Config) ->
    ets:delete(blockchain, 1),
    compromised_chain = blockchain:makeblock("This should fail").

end_per_suite(_Config) ->
    application:stop(lunchcoin).
