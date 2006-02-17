#
# $Id: ui.pm,v 1.1.1.1 2005/12/09 18:08:47 sommerb Exp $

package Myco::UI::Foo;

sub new {
    my $class = shift;
    return bless { @_ }, $class;
}

1;

