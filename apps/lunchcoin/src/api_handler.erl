-module(api_handler).
-behaviour(cowboy_handler).

-export([init/2]).

-spec binary_join([binary()], binary()) -> binary().
% Largely taken from https://coderwall.com/p/nmajna/joining-a-list-of-binaries-in-erlang
binary_join([], _Sep) ->
    <<>>;
binary_join([Part], _Sep) ->
    Part;
binary_join(List, Sep) ->
    lists:foldr(fun (A, B) ->
        case bit_size(B) > 0 of
        true -> 
            <<A/binary, Sep/binary, B/binary>>;
        _ -> A
    end
  end, <<>>, List).

init(Req0 = #{method:=<<"GET">>, path:=<<"/api/orders">>}, State) ->
    Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain; charset=utf-8">>},
        binary_join(blockchain:gettoday(), <<$\n>>),
        Req0),
    {ok, Req, State};

init(Req0 = #{method:=<<"GET">>, path:=<<"/api/blockchain">>}, State) ->
    Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain; charset=utf-8">>},
        io_lib:format("~p", [ets:tab2list(blockchain)]), Req0),
    {ok, Req, State};

init(Req0 = #{method:=<<"POST">>, path:=<<"/api/new">>}, State) ->
    Req2 = case cowboy_req:has_body(Req0) of
    true ->
        {ok, PostBody, Req1} = cowboy_req:read_body(Req0),
        ok = blockchain:makeblock(PostBody),
        cowboy_req:reply(200,
            #{<<"content-type">> => <<"text/plain; charset=utf-8">>},
            PostBody, Req1);
    _ ->
        cowboy_req:reply(400, #{}, <<"Bad Request">>, Req0)
    end,
    {ok, Req2, State}.
