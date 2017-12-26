lunchcoin
=====

A blockchain designed to managing lunch and coffee orders.

All blockchain algorithms are implemented internally.

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
