#!/usr/bin/perl -w

use lib "blib/lib";
use DDLockClient ();
use Data::Dumper ();

$Data::Dumper::Terse = 1;
$Data::Dumper::Indent = 1;

$| = 1;

DDLockClient->DebugLevel( 5 );

my $servers =  [
	'localhost:7003',
	'localhost:7004',
	'localhost:7002',
   ];

print "Creating client...";
my $cl = new DDLockClient ( servers => $servers )
	or die $DDLockClient::Error;
print "done:\n", Data::Dumper->Dumpxs( [$cl], [qw{cl}] ), "\n";

print "Creating a 'foo' lock...";
my $lock = $cl->trylock( "foo" )
	or die $DDLockClient::Error;
print "done:.\n", Data::Dumper->Dumpxs( [$lock], [qw{lock}] ), "\n";

print "Trying to create a second 'foo' lock...";
my $lock2 = $cl->trylock( "foo" );
print "done:\n$DDLockClient::Error\n";

print "Releasing the 'foo' lock...";
$lock->release or die;
print "done.\n\n";



