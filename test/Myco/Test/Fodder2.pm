# $Id: Fodder2.pm,v 1.1.1.1 2005/12/09 18:08:47 sommerb Exp $
#
#     global test Fodder...

package Myco::Test::Fodder2;

use strict;
use warnings;

use base qw(Test::Unit::TestCase);

use Myco;

# Generate stack backtrace on exception if asked
$SIG{__DIE__} = \&Carp::confess if ($ENV{MYCO_TESTCONFESS});


### Fixture Handling
# Override at will in test or testtemplate classes

sub init_fixture {
    my $self = shift()->SUPER::new(@_);
    $self->_config_fixture;
    return $self;
}

sub help_set_up {
    $_[0]->_help_set_up;
}

sub help_tear_down {
    $_[0]->_help_tear_down;
}

sub DESTROY {
    $_[0]->_destroy_fixture;
}




## Default _do_the_work_ methods
sub _config_fixture {
    unless (defined Myco->storage) {

        use Myco::Config qw(:database);
        
        my $user = DB_USER;
        my $pw = DB_PASSWORD;
        my $dsn = DB_DSN;
        
        Myco->db_connect("dbi:Pg:dbname=$db", $user, $pw);
    }
}

sub _help_set_up {}

sub _help_tear_down {
    while (my $obj = shift @{ $_[0]->{erase_targets} }) {
	Myco->erase($obj);
    }
}

sub _destroy_fixture {
}

1;
