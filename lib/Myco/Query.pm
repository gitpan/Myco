package Myco::Query;

###############################################################################
# $Id: Query.pm,v 1.3 2006/02/17 18:22:38 sommerb Exp $
###############################################################################

=head1 NAME

Myco::Query - a Myco entity class

=head1 VERSION

=over 4

=item Release

0.01

=cut

our $VERSION = 1.0;

=item Repository

$Revision: 1.3 $ $Date: 2006/02/17 18:22:38 $

=back

=head1 SYNOPSIS

  use Myco::Query;

  # Constructors, accessors, etc - see Myco::QueryTemplate for more.

=head1 DESCRIPTION

A class to prepare and store Tangram Query objects used to generate lists.
See L<Myco::QueryTemplate|Myco::QueryTemplate> for full info.

=cut

##############################################################################
# Dependencies
##############################################################################
# Module Dependencies and Compiler Pragma
use warnings;
use strict;
use Myco::Exceptions;


##############################################################################
# Inheritance & Introspection
##############################################################################
use base qw( Myco::Entity
             Myco::QueryTemplate );
my $md = Myco::Entity::Meta->new
  ( name => __PACKAGE__,
    tangram => { table => 'query', },
    ui => {
           displayname => sub { shift->get_name },
           list => {
                    layout => [ qw(__DISPLAYNAME__) ],
                   },
          },
  );

##############################################################################
# Object Schema Activation and Metadata Finalization
##############################################################################
$md->activate_class;

1;
__END__
