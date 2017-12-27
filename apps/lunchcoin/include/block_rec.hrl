
-record(block, {index :: non_neg_integer(),
                timestamp :: integer(),
                data :: string(),
                previousHash :: binary(),
                hash :: binary() | undefined}).

