#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'WebService::E4SE' ) || print "Bail out!\n";
}

diag( "Testing WebService::E4SE $WebService::E4SE::VERSION, Perl $], $^X" );
