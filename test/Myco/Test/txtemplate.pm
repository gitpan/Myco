# $Id: txtemplate.pm,v 1.1.1.1 2004/11/22 19:16:05 owensc Exp $
#
# module - Myco::Test::txtemplate
#
#     include in all transaction test classes (via 'use')

use Myco::Test::Fodder;

sub test_new_empty {
	my $self = shift;
	$self->assert(defined $txclass->new);
}

sub test_new_bogus_args {
	my $self = shift;
	eval { $txclass->new(foo => "blah"); };
	$self->assert($@);
}

sub test_create {
    my $self = shift;
    my $Tx = $txclass->new;
    my ($id, $obj2);
    {
	$self->assert(my $obj = $Tx->create($simple_accessor => "XMPG"));
	eval { $id = Myco->storage->id($obj); };
    }
    $self->assert($id);
    $self->assert(! exists Myco->storage->{classes}{$id});
    eval { $obj2 = Myco->storage->load($id); };
    $self->assert($obj2);
    $self->assert($obj2->$simple_accessor eq "XMPG");
    push @{ $self->{erase_targets} }, $obj2;
}

1;
