#!/usr/bin/perl -Wall

use DBI;
my $dbh = DBI->connect("dbi:SQLite:dbname=pk.db","","");
$dbh->do("delete from amo;");

use Date::Manip;
use LWP;
use LWP::UserAgent;

$ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/418.8 (KHTML, like Gecko) Safari/419.3");

$now = ParseDate("now");

my @ids;
my %data;

sub cutDecimals
{
	my $num=shift;
	my $decs=shift;
	
	if ($num=~/\d+\.(\d){$decs,}/)
	{
		$num=sprintf("%.".($decs-1)."f", $num);
	}
	return $num;
}

sub getStatusForId
{
	my $id = shift;
	my $req = HTTP::Request->new(POST => "https://addons.mozilla.org/firefox/$id/history/");
	my $res = $ua->request($req);
	return 0 if ($res->content =~ /\<dl\>\n\<\/dl\>/);
	return 1;
}

my $name;
my $date;
my $isNew;
my $id;

open(MOUP, "<moup.html");
while($line = <MOUP>)
{
	if($line =~ /listmanager\.php/)
	{
		$id = $line; $id =~ s/.*id=([0-9]+)&.*\n/$1/;
		$name = $line; $name =~ s/.*\"\>([^\<]*)\<.*\n/$1/;
	}
	
	if($line =~ /Requested by:\</)
	{
		$date = $line; $date =~ s/.*\/a\> on ([^\<]*).*\n/$1/;
		$ddate = Delta_Format(DateCalc($date, $now), 0, "%dt");
		$date = cutDecimals($ddate,1);
		$isNew = getStatusForId($id);
		$dbh->do("INSERT INTO amo VALUES ('$name', $id, $date, $isNew, null);");
	}
}

close MOUP;