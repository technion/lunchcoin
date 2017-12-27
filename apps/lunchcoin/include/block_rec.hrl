
-record(block, {index :: non_neg_integer(),
                timestamp :: integer(),
                data :: binary(),
                previousHash :: binary(),
                hash :: binary() | undefined}).

