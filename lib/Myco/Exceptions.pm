package Myco::Exceptions;

################################################################################
# $Id: Exceptions.pm,v 1.3 2006/02/17 18:22:38 sommerb Exp $
#
# See license and copyright near the end of this file.
################################################################################

=pod

=head1 NAME

Myco::Exceptions - Myco Exception classes defined

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

  use Myco::Exceptions;


=head1 DESCRIPTION

Myco::Exceptions provides a straight-forward way to define different classes of
exceptions for various pieces of myco.

=cut

################################################################################
# Dependencies
################################################################################
# Standard Dependencies
use strict;
use warnings;

################################################################################
# Programmatic Dependences
################################################################################
use Exception::Class ( 'Myco::Exception' => { description =>
                                      'Generic Myco exception base class.'},

		       'Myco::Exception::DB' => { description =>
                                                  'Database exception.',
                                                  isa => 'Myco::Exception' },

                       'Myco::Exception::DataValidation' =>
                                 { description => 'Data validation exception.',
                                   isa => 'Myco::Exception' },

                       'Myco::Exception::ObjectSave' =>
                       { description => 'Error-on-object-save exception',
                         isa => 'Myco::Exception' },

                       'Myco::Exception::ObjectRelation' =>
                             { description => 'Object relationship exception.',
                               isa => 'Myco::Exception' },

                       'Myco::Exception::Caching' =>
                                     { description => 'Caching exception.',
                                       isa => 'Myco::Exception' },

                       'Myco::Exception::Session' =>
                                     { description => 'Session exception.',
                                       isa => 'Myco::Exception' },

                       'Myco::Exception::MNI' =>
                          { description => 'Method not implemented exception.',
                            isa => 'Myco::Exception' },

                       'Myco::Exception::IO' =>
                                              { description => 'IO exception.',
                                                isa => 'Myco::Exception' },

                       'Myco::Exception::Authz' =>
                                   { description => 'Authorization exception.',
                                     isa => 'Myco::Exception' },

                       'Myco::Exception::MalformedPassword' =>
                                   { description => 'Malformed Password.',
                                     isa => 'Myco::Exception' },

                       'Myco::Exception::Stat' =>
                                     { description => 'File status exception.',
                                       isa => 'Myco::Exception' },

                       'Myco::Exception::DataProcessing' =>
                                 { description => 'Data processing exception.',
                                   isa => 'Myco::Exception' },

                       'Myco::Exception::NoSuchClass' =>
                                  { description => 'No such class exception.',
                                    isa => 'Myco::Exception' },

                       'Myco::Exception::Meta' =>
                                      { description => 'Meta data exception.',
                                        isa => 'Myco::Exception' },

                       'Myco::Exception::MVC' =>
                           { description => 'Model-View-Controller exception.',
                             isa => 'Myco::Exception' },

                       'Myco::Exception::MVC::PostAction' =>
                           { description =>
			       'Model-View-Controller PostAction exception.',
                             isa => 'Myco::Exception::MVC' },

                       'Myco::Exception::Query' =>
                           { description => 'Query exception.',
                             isa => 'Myco::Exception' },
                       'Myco::Exception::Query::Clause' =>
                           { description => 'Query Clause exception.',
                             isa => 'Myco::Exception::Query' },

                       'Myco::Exception::Query::Filter' =>
                           { description => 'Query Filter exception.',
                             isa => 'Myco::Exception::Query' },

                       'Myco::Exception::Query::Init' =>
                           { description => 'Query initialization exception.',
                             isa => 'Myco::Exception::Query' },
                       'Myco::Exception::Query::Params' =>
                           { description => 'Query Params exception.',
                             isa => 'Myco::Exception::Query' },
                       'Myco::Exception::Query::Filter' =>
                           { description => 'Missing Query Filter exception.',
                             isa => 'Myco::Exception::Query' },

                     );

package Myco::Exception;

use strict;
use warnings;

################################################################################
# Inheritance
################################################################################

################################################################################
# Function and Closure Prototypes
################################################################################
# None.

################################################################################
# Constants
################################################################################

################################################################################
# Private class variables
################################################################################
# None.

##############################################################################
# Constructor
##############################################################################
# See Exception::Class.

################################################################################
# Instance methods.
################################################################################
# See Exception::Class.

1;
__END__

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2004 the myco project. All rights reserved.
This software is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

David Wheeler <david@wheeler.net>

=head1 SEE ALSO

L<Myco|Myco>
L<Math::Random|Math::Random>

=cut
