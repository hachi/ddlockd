#!/usr/bin/perl -w

use strict;
use Test::More;

use DDLockClient;

BEGIN { plan tests => 8 }

my $cl = DDLockClient->new( servers => [ 'localhost' ] );
ok($cl, "Got a client object");

{
    my $lock = $cl->trylock('test_a');
    ok($lock, "Got a lock for 'test_a'");
}

{
    my $lock = $cl->trylock('test_a');
    ok($lock, "Got a lock for 'test_a' again.");
}

{
    my $lock = $cl->trylock('test_b');
    ok($lock, "Got a lock for 'test_b'");
    my $rv = $lock->release();
    ok($rv, "Lock release succeeded");
    my $lock2 = $cl->trylock('test_b');
    ok($lock, "Got a lock for 'test_b' again");
}

{
    my $lock = $cl->trylock('test_c');
    ok($lock, "Got a lock for 'test_c'");
    my $lock2 = $cl->trylock('test_c');
    ok(!defined($lock2), "Got no lock for 'test_c' again without release");
    diag "Error was '$DDLockClient::Error'";
}

# vim: filetype=perl
