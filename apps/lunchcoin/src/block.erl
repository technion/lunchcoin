-module(block).
-compile([export_all]).

-define(EMPTYHASH, <<14,87,81,192,38,229,67,178,232,171,46,176,96,153,
      218,161,209,229,223,71,119,143,119,135,250,171,69,
      205,241,47,227,168>>). % Hash of empty string

-record(block, {index, timestamp, data, previousHash, hash}).

inittable() ->
    blockchain = ets:new(blockchain, [public, ordered_set, named_table, {keypos, #block.index}]).

genesis() ->
    Genesis = #block{timestamp = erlang:monotonic_time(),
        index = 0,
        data = "This is a genesis block", % TODO: What should this say?
        previousHash = ?EMPTYHASH }, 
    HashGenesis = Genesis#block{hash = blockhash(Genesis)},
    true = ets:insert_new(blockchain, HashGenesis),
    genesis.

makeBlock(Data) ->
    [Prev| _Cannot] = ets:lookup(blockchain, ets:last(blockchain)),
    AddBlock = #block{timestamp = erlang:monotonic_time(),
        index = Prev#block.index + 1,
        data = Data,
        previousHash = Prev#block.hash },
    true = ets:insert_new(blockchain, AddBlock#block{hash = blockhash(AddBlock)}).

blockhash(Block) ->
    HashData = [Block#block.index, Block#block.timestamp, Block#block.previousHash],
    {ok, Hash} = enacl:generichash(32, term_to_binary(HashData)),
    Hash.

verifyChain(#block{index = 0, previousHash = PrevHash, hash = Hash}, VerifyHash) ->
    % Genesis block
    Hash = VerifyHash,
    PrevHash = ?EMPTYHASH,
    ok;

verifyChain(Block = #block{index = BlockIndex, hash = BlockHash}, VerifyHash) ->
    % Retrieve the previous block.
    % Note lookup/2 returns a list guaranteed to have on element on an ordered_set
    [Prev| _Cannot] = ets:lookup(blockchain, ets:prev(blockchain, BlockIndex)),
    % Verify the block's recorded hash is as recorded on the next block
    VerifyHash = BlockHash,
    % Verify the recorded hash is the actual hash
    VerifyHash = blockhash(Block),
    % Verify the index is in order
    BlockIndex = Prev#block.index + 1,
    verifyChain(Prev, Block#block.previousHash).
