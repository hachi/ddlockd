package DDLockd::Client::DLMFS;

use base 'DDLockd::Client';
use Fcntl;
use Errno qw(EEXIST ETXTBSY);

sub FLAGS () { O_NONBLOCK | O_RDWR | O_CREAT | O_EXCL }
sub PATH () { "/dlm/ddlockd" };

sub _setup {
    -d "/dlm" or die( "DLMFS mount at /dlm not found\n" );
    mkdir PATH;
}

sub _trylock {
    my DDLockd::Client::Internal $self = shift;
    my $lock = shift;

    return $self->err_line("empty_lock") unless length($lock);

    if (sysopen( my $handle, PATH . "/$lock", FLAGS )) {
        $self->{locks}{$lock} = 1;
        return $self->ok_line();
    }
    else {
        if ($! == EEXIST) {
            return $self->err_line( "local taken" );
        }
        elsif( $! == ETXTBSY) {
            unlink( PATH . "/$lock" );
            return $self->err_line( "remote taken" );
        }
        else {
            return $self->err_line( "unknown: $!" );
        }
    }
}

sub _release_lock {
    my DDLockd::Client::Internal $self = shift;
    my $lock = shift;

    # TODO: notify waiters
    delete $self->{locks}{$lock};
    unlink( PATH . "/$lock" );
    return 1;
}

sub _get_locks {
# TODO
#    return map { "  $_ = " . $holder{$_}->as_string } (sort keys %holder);
}

1;
