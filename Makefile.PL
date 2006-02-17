
# $Id: Makefile.PL,v 1.12 2006/02/17 20:31:05 sommerb Exp $

use ExtUtils::MakeMaker;

#
# Helpful Subroutines
#

sub module_prereqs {
  # adapted from modules.pl from Bricolage
  # using this code, we record module dependencies
  # in one place - Myco::Admin

  my $prereqs;
  my @mod;
  open(ADM, "lib/Myco/Admin.pod")
    or die "Unable to open lib/Myco/Admin.pod : $!";
  # seek to start of modules
  while (<ADM>) {
    last if /START MODULE LIST/;
  }
  # read in modules
  while (<ADM>) {
    if (/^=item\s+(\S+)(?:\s+([\d\.]+))?(?:\s+(\(optional\)))?/) {
      $prereqs->{$1} = $2 || 0;
    } elsif (/END MODULE LIST/) {
      last;
    }
  }
  close ADM;
  return $prereqs;
}


#
# Some Install dialog
#

my $skip_tests;

do { $skip_tests = 1; goto NOTESTS } if $skip_tests or $bomb_out;

use lib '.';

sub yes {
  print ' (Y/n) ';
  return <STDIN> =~ /^(Y(e(s)?)?|A(YE|II+!*))?\n?$/i;
}

print q{
Do you plan to run the test suite?
(Myco only provides explicit support for PostreSQL)};

do { $skip_tests = 1; goto NOTESTS } unless yes();

my ($cs, $user, $passwd);

print q{Please give me the login and password for accessing the test database.
I must be able to create and drop tables in that database.};

print "\n1) DBI connect string (include the \'DBI:\' part): ";
$cs = <STDIN>;
chop $cs;

unless ($cs =~ m/:pg:/) {
    print "Please note: only the PostreSQL is support\n";
}

print "2) Login: ";
$user = <STDIN>;
chop $user;

print "3) Password: ";
$passwd = <STDIN>;
chop $passwd;

print <<'MSG';

Thank you. I am going to use this information to generate 'conf/myco.conf' 
from conf/myco.conf-dist. If you have given me sensitive information, 
make sure to empty out _just_ this sensitive data only when the tests have 
been completed.
MSG

sleep 1;

my %config_replacements = ( DB_DSN => $cs,
			    DB_USER => $user,
			    DB_PASSWORD => $pass, );

my $dbname = $cs;
$dbname =~ s/^.[^=]*=(.*)/$1/;

if ($cs =~ m/:pg:/i) {

  $config_replacements{DB_DROP_CMD} =
    '[qw(dropdb -U ' . $user . ' ' . $dbname . ')]';
  $config_replacements{DB_CREATE_CMD} =
    '[qw(createdb -U ' . $user . ' ' . $dbname . ')]';

}

open CONF_DIST, 'conf/myco.conf-dist';
my $conf_dist;
$conf_dist .= $_ for <CONF_DIST>;
close CONF_DIST;

while (my ($label, $value) = each(%config_replacements) ) {
  if ($label =~ /create|drop/i) {
    # inserting an un-stringified perl data structure here
    $conf_dist =~ s/
		    (.*$label\s\=\>\s)
		    \'\s*\'
		    (,\n.*)
		   /$1$value$2/sx;
  } else {
    $conf_dist =~ s/
		    (.*$label\s\=\>\s\')
		    \s*
		    (\',\n.*)
		   /$1$value$2/sx;
  }
}


# now create working myco.conf file
open CONF_WORKING, '>conf/myco.conf';
print CONF_WORKING $conf_dist;
close CONF_WORKING;

use Cwd;
$ENV{MYCO_ROOT} = cwd unless $ENV{MYCO_ROOT};

print <<'MSG';

Now creating and deploying the database...
MSG

system 'bin/deploy';


###################################################
# NO TESTS
###################################################

NOTESTS:
my $tests;
if ($skip_tests) {
    print "TEST SUITE IS DISABLED\n";
    $tests = "t/no_tests.t";
} else {
    $tests = "t/test_unit_testcase.t";
}

WriteMakefile(
	      NAME	   => 'Myco',
	      VERSION_FROM => 'lib/Myco.pm', # finds $VERSION
	      PREREQ_PM    => module_prereqs(),
	      PREREQ_FATAL => 0,
	      test => { TESTS => $tests },
);
