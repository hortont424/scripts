#!/usr/bin/perl -w
use strict;
use sigtrap;
use IO::Socket::INET;
use Net::AIM;

my $sock = new IO::Socket::INET(LocalPort => '9876', Type => SOCK_STREAM, Listen => 10, Reuse => 1);

my $aim = new Net::AIM;
$aim->newconn(Screenname => 'hortont424pl', Password => 'perlisthebest') or die "Unable to open AIM connection.\n";

my $conn = $aim->getconn();

my $ready = 0;

$conn->set_handler(config => sub {$ready = 1});

while(not $ready)
{
	$aim->do_one_loop;
};

my $client;

while($client = $sock->accept())
{
	while(<$client>)
	{
		(my $to = $_) =~ s/(.*)\|{3}(.*)/$1/;
		(my $message = $_) =~ s/(.*)\|{3}(.*)/$2/;
		$aim->send_im($to, $message);
	}
}
