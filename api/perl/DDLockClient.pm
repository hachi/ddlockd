#!/usr/bin/perl
#

package DDLockClient;
use strict;

use fields qw(
	      'servers',  # arrayref of lock servers
	      );
sub new {
    my DDLockClient $self = shift;
    my %args = @_;

    $self = fields::new($self) unless ref $self;    

    die "Need 'servers' arrayref parameter to DDLockClient constructor" 
	unless ref $args{servers} eq "ARRAY" && @$args{servers};

    $self->{servers} = $args{servers};
    return $self;
}

sub trylock {
    my DDLockClient $self = shift;
    my $lockname = shift;

    
}

package DDLock;





1;
