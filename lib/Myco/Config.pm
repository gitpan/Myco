package Myco::Config;

################################################################################
# $Id: Config.pm,v 1.2 2006/02/17 18:22:38 sommerb Exp $
#
# See license and copyright near the end of this file.
################################################################################

=pod

=head1 NAME

Myco::Config - Myco Configuration Module

=head1 VERSION

=over 4

=item Release

0.01

=cut

our $VERSION = 1.0;

=item Repository

$Revision: 1.2 $ $Date: 2006/02/17 18:22:38 $

=back

=head1 SYNOPSIS

  # In myco.conf:
  foobar  => {
              FOOBAR_PORT_NUM   => 6288,
              FOOBAR_HOST   => 'localhost'
            },
  barbaz  => {
              BARBAZ_USER => 'bazdude',
              BARBAZ_PROFILE => { uid => 1999,
                                  gid => 1999, },
            },

  # In a Myco entity class:
  use Myco::Config qw(:foobar);

  # In another Myco entity class:
  use Myco::Config qw(:barbaz);

  # To get all constants:
  use Myco::Config qw(:all);

=head1 DESCRIPTION

This module reads in a configuration file and sets up a bunch of constants
that can be used in Myco. The configuration file consists of Perl code that,
when C<eval>ed by Myco::Config, generates a hash of hash references. Each hash
reference is turned into a series of constants, one for each key/value pair.
The keys in the main hash are turned into labels under which the constants
generated from the hash reference in the keys' values are listed. This makes
it very simple to create export tags that can be used in modules to import
only the constants associated with a given label.

While no constants are exported by Myco::Config by default, the special
C<all> tag can be used to export I<all> of the constants created from the
configuration file:

  use Myco::Config qw(:all);


=cut

use strict;
use warnings;
use Myco::Exceptions;
use File::Spec::Functions qw(catfile);
use base qw(Exporter);
our (@EXPORT_OK,  %EXPORT_TAGS);

BEGIN {
    # Load the configuration file.
    my $conf_file = $ENV{MYCO_ROOT} || '/usr/local/etc/myco';
    $conf_file = catfile($conf_file, 'conf', 'myco.conf');
    Myco::Exception::Stat->throw
      (error => "No such configuration file '$conf_file'")
      unless -f $conf_file;
    local $/;
    open CONF, $conf_file or
      Myco::Exception::IO->throw(error => "Cannot open $conf_file: $!");
    my %conf = eval <CONF>;
    close CONF;
    while (my ($label, $set) = each %conf) {
        my @export;
        while (my ($const, $val) = each %$set) {
	  eval "use constant $const => \$val";
	  push @EXPORT_OK, $const;
	  push @export, $const;
        }
        $EXPORT_TAGS{$label} = \@export;
    }
    $EXPORT_TAGS{all} = \@EXPORT_OK;
}

1;
__END__

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2004 the myco project. All rights reserved.
This software is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

David Wheeler <david@wheeler.net>

=cut
