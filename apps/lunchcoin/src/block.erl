-module(block).
-export([
         genesis/0,
         make_block/2,
         verify_chain/2
        ]).


-include("block_rec.hrl").

-define(EMPTYHASH, <<14, 87, 81, 192, 38, 229, 67, 178, 232, 171, 46, 176, 96, 153,
      218, 161, 209, 229, 223, 71, 119, 143, 119, 135, 250, 171, 69,
      205, 241, 47, 227, 168>>). % Hash of empty string

-spec genesis() -> block().
genesis() ->
    Genesis = #block{timestamp = erlang:monotonic_time(second) - 4320,
        index = 0,
        data = <<"This is a genesis block">>, % TODO: What should this say?
        previousHash = ?EMPTYHASH },
    Genesis#block{hash = blockhash(Genesis)}.

-spec make_block(binary(), block()) -> block().
make_block(Data, Prev) ->
    AddBlock = #block{timestamp = erlang:monotonic_time(second),
        index = Prev#block.index + 1,
        data = Data,
        previousHash = Prev#block.hash },
    AddBlock#block{hash = blockhash(AddBlock)}.

-spec blockhash(block()) -> binary().
blockhash(Block) ->
    HashData = [Block#block.index,
        Block#block.timestamp,
        Block#block.data,
        Block#block.previousHash
        ],
    {ok, Hash} = enacl:generichash(32, term_to_binary(HashData)),
    Hash.

-spec verify_chain(block(), binary()) -> ok.
verify_chain(#block{index = 0, previousHash = PrevHash, hash = Hash}, VerifyHash) ->
    % Genesis block
    Hash = VerifyHash,
    PrevHash = ?EMPTYHASH,
    ok;

verify_chain(Block = #block{index = BlockIndex, hash = BlockHash}, VerifyHash) ->
    % Retrieve the previous block.
    % Note lookup/2 returns a list guaranteed to have on element on an ordered_set
    [Prev| _Cannot] = ets:lookup(blockchain, ets:prev(blockchain, BlockIndex)),
    % Verify the block's recorded hash is as recorded on the next block
    VerifyHash = BlockHash,
    % Verify the recorded hash is the actual hash
    VerifyHash = blockhash(Block),
    % Verify the index is in order
    BlockIndex = Prev#block.index + 1,
    verify_chain(Prev, Block#block.previousHash).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

create_genesis_test() ->
    Genesis = genesis(),
    ?assertEqual(verify_chain(Genesis, Genesis#block.hash), ok).

blockhash_test() ->
    Genesis = genesis(),
    Block2 = make_block("a new block", Genesis),
    ?assertEqual(blockhash(Block2), Block2#block.hash),
    ?assertNotEqual(Genesis#block.hash, Block2#block.hash).

-endif.
