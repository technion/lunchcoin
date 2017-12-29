lunchcoin
=====

A blockchain designed to managing lunch and coffee orders.

All blockchain algorithms are implemented internally.

API
---

The application is designed with a decoupled frontend/backend. The API is managed with the OpenAPI standard on [Swaggerhub](https://app.swaggerhub.com/apis/Lolware/Lunchcoin/1.0.0) where it can be interacted with and tested.

Build
-----

    $ rebar3 compile

Testing
-------

Several Erlang test utilities are in use. All functions are annotated for static analysis with dialyzer:

    $ rebar3 dialyzer

You may also run unit tests:

    $ rebar3 eunit

And Common Test for functional tests:

    $ rebar3 ct

Code style strictly meets the Inaka coding guidelines. This can be linted using the Elvis utility:

    $ elvis rock
