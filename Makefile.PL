
# $Id: Makefile.PL,v 1.15 2006/02/28 18:25:23 sommerb Exp $

use ExtUtils::MakeMaker;

my $DEBUG = 1;

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


#use CPAN();
#my $prereqs = module_prereqs();
#if ($DEBUG) { use Data::Dumper; print Dumper $prereqs; }
#for $mod (keys %$prereqs) {
#  my $obj = CPAN::Shell->expand('Module', $mod);
#  warn "checking if $mod is installed\n" if $DEBUG;
#  next unless $obj && ! $obj->inst_file;
#  my $req_version = $prereqs->{$mod} || '';
#  if ($req_version) {
#    warn "checking $mod version\n" if $DEBUG;
#    my $version = $obj->inst_version || '';
#    if ($req_version != $version) {
#      warn "version $version of $mod installed - we need $req_version\n";
#      next;
#    }
#  }
#  $obj->install;
#}


#
# Some Install dialog
#

use lib '.';

my $skip_tests;

do { $skip_tests = 1; goto NOTESTS } if $skip_tests or $bomb_out;

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
  # add new tests here
    my @tests = qw(
		   test_unit_testcase.t
		  );
    $tests = join '', map {"t/$_ "} @tests;
}

# copy myco.conf over to /etc on install
sub MY::postamble {
  my $conf_dir = '';
  my $os = $^O;
  if ($os =~ /\w+bsd$/) {
    $conf_dir = '/usr/local/etc';
  } elsif ($os eq 'linux' || $os =~ m/cygwin/g) {
    $conf_dir = '/etc';
  } else {
    return '';
  }

  my $moveit = -f "$conf_dir/myco.conf" ?
    "mv $conf_dir/myco.conf $conf_dir/myco.conf.old && "
      : '';

  return "
install ::
\t" . $moveit . "cp conf/myco.conf $conf_dir";

}

WriteMakefile(
	      NAME	   => 'Myco',
	      VERSION_FROM => 'lib/Myco.pm', # finds $VERSION
	      PREREQ_PM    => module_prereqs(),
	      PREREQ_FATAL => 0,
	      test => { TESTS => $tests },
);
