#!/usr/bin/perl -w
use strict;
use sigtrap;
use IO::Socket::INET;
use Getopt::Std;

my $sock = new IO::Socket::INET->new(PeerAddr => 'neonetwork.sytes.net', PeerPort => '9876', Proto => 'tcp', Type => SOCK_STREAM);

my %opts;
getopts("u:m:", \%opts);

my $username = "hortont424";
my $message = "Your task has completed.";

if(defined($opts{"u"}))
{
	$username = $opts{"u"};
}

if(defined($opts{"m"}))
{
	$message = $opts{"m"};
}

print $sock "$username|||$message";
close($sock);
