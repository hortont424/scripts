#!/usr/bin/perl

use Date::Manip;
use GD::Graph::bars;
use GD;
use GD::Text::Align;
use LWP;
use LWP::UserAgent;

$ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en) AppleWebKit/418.8 (KHTML, like Gecko) Safari/419.3");

$now = ParseDate("now");

my @ids;
my @deltas;
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

open(MOUP, "<moup.html");
while($line = <MOUP>)
{
	if($line =~ /listmanager\.php/)
	{
		$id = $line; $id =~ s/.*id=([0-9]+)&.*\n/$1/;
		$name = $line; $name =~ s/.*\"\>([^\<]*)\<.*\n/$1/;
		
		@ids = (@ids, $id);
		$data{"$id-name"} = $name;
	}
	
	if($line =~ /Requested by:\</)
	{
		$date = $line; $date =~ s/.*\/a\> on ([^\<]*).*\n/$1/;
		$ddate = Delta_Format(DateCalc($date, $now), 0, "%dt");
		$data{"$id-date"} = cutDecimals($ddate,1);
		@deltas = (@deltas, cutDecimals($ddate,1));
	}
}

close MOUP;

my $maxdelta = 0;
my $maxid;
my $avgdelta;
my $cntdelta;
my $oldandlate;
my $newandlate;
my $overmax;

foreach(@ids)
{
	$id = $_;
	
	$_ = $data{"$id-date"};
	
	if($_ > $maxdelta)
	{
		$maxdelta = $_;
		$maxid = $id;
	}
	$avgdelta += $_;
	$cntdelta++;
	
	if($_ > 10)
	{
		$overmax++;
		
		if(getStatusForId($id) == 1)
		{
			$oldandlate++;
		}
		else
		{
			$newandlate++;
		}
	}
}

my $newandlateper = cutDecimals((($newandlate / $overmax) * 100), 2);

$avgdelta = cutDecimals($avgdelta / $cntdelta, 2);

sub generateHistogram
{
	$mygraph = GD::Graph::bars->new(800, 600);

	$mygraph->set(
		x_label     => 'Days in Queue',
		y_label     => 'Number of Extensions',
		title       => 'Histogram of Extension Wait Time',
		show_values => 1,
		bgclr		=> "white",
		transparent => 0,
		dclrs		=> ["red"],
	);

	my @histo;
	
	foreach(@deltas)
	{
		$histo[$_]++;
	}
	
	my @graphData = ([1..scalar(@histo)], [@histo]);
	my $graphImage = $mygraph->plot(\@graphData);
	$black = $graphImage->colorAllocate(0,0,0);
	
	my $align = GD::Text::Align->new($graphImage,
		valign => 'top',
		halign => 'right',
	);
	$align->set_font('arial', 12);
	
	$align->set_text("$cntdelta extensions, $avgdelta days avg., $maxdelta days max. time-in-queue");
	$align->draw(785, 25, PI/3);
	
	$align->set_text("$overmax extensions over 10 days in queue, $newandlateper\% of these are new");
	$align->draw(785, 39, PI/3);
	
	$align->set_text("As of " . localtime());
	$align->draw(785, 53, PI/3);
	
	open (MOUT, ">amo-overall.png");
	print MOUT $graphImage->png;
	close MOUT;
}

generateHistogram();