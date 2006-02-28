package Myco::Config::Test;

################################################################################
# $Id: Test.pm,v 1.2 2006/02/27 23:03:20 sommerb Exp $
#
# See license and copyright near the end of this file.
################################################################################

=pod

=head1 NAME

Myco::Config::Test - Myco::Config unit tester.

=head1 VERSION

$Revision: 1.2 $

=cut

# Grab the Version Number.
our $VERSION = (qw$Revision: 1.2 $ )[-1];

=pod

=head1 DATE

$Date: 2006/02/27 23:03:20 $

=head1 SYNOPSIS

  use Myco::UI::Cache::Test;
  use Test::Unit::TestRunner;

  my $tr = Test::Unit::TestRunner->new();
  $tr->start('Myco::UI::Cache::Test');

=head1 DESCRIPTION

This class tests the Myco::UI::Cache interface.

=cut

use strict;
use warnings;
use Myco::Config;
use base qw(Test::Unit::TestCase);

sub test_database {
    my $test = shift;
    package Myco::Config::database;
    use Myco::Config qw(:database);
    $test->assert( defined(DB_DSN), "Check DB_DSN" );
    $test->assert( defined(DB_USER), "Check DB_USER" );
    $test->assert( defined(DB_PASSWORD), "Check DB_PASSWORD" );
    eval "EVLOG";
    $test->assert($@, "EVLOG not imported" );
}

sub test_all {
    my $test = shift;
    package Myco::Config::alltest;
    use Myco::Config qw(:all);
    $test->assert( defined(DB_DSN), "Got database group" );
}

1;
__END__

=back

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2006 the myco project. All rights reserved.
This software is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

David Wheeler <david@wheeler.net>

=head1 SEE ALSO

L<Myco::UI::Cache|Myco::UI::Cache>

=cut
