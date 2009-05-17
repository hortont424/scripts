#!/usr/bin/perl -Wall

use Date::Manip;
use LWP;
use LWP::UserAgent;

open(OUT, ">out.html");
select OUT;

print <<EOF;
<html>
<head>
<script type="text/javascript" src="MochiKit/MochiKit.js"></script>
<script type="text/javascript" src="PlotKit/Base.js"></script>
<script type="text/javascript" src="PlotKit/Layout.js"></script>
<script type="text/javascript" src="PlotKit/Canvas.js"></script>
<script type="text/javascript" src="PlotKit/SweetCanvas.js"></script>
<script>

var options = {
   "IECanvasHTC": "/plotkit/iecanvas.htc",
   "colorScheme": PlotKit.Base.palette(PlotKit.Base.baseColors()[0]),
   "xNumberOfTicks": 100
};

function drawGraph() {
    var layout = new PlotKit.Layout("bar", options);
EOF


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
	my $id = $_;
	
	$mydate = $data{"$id-date"};
	
	if($mydate > $maxdelta)
	{
		$maxdelta = $mydate;
		$maxid = $id;
	}
	$avgdelta += $mydate;
	$cntdelta++;
	
	if(getStatusForId($id) == 1)
	{
		$data{"$id-new"} = "0";
		if($mydate > 10)
		{
			$oldandlate++;
		}
	}
	else
	{
		$data{"$id-new"} = "1";
		if($mydate > 10)
		{
			$oldandlate++;
		}
	}
	
	if($mydate > 10)
	{
		$overmax++;
	}
}

#my $newandlateper = cutDecimals((($newandlate / $overmax) * 100), 2);

$avgdelta = cutDecimals($avgdelta / $cntdelta, 2);

sub generateHistogram
{
	my @histoNew;
	my @histoOld;
	
	foreach(@ids)
	{
		my $id = $_;
		#if($data{"$id-new"} eq "0")
		#{
			$histoOld[$data{"$id-date"}]++;
		#}
		#else
		#{
		#	$histoNew[$data{"$id-date"}]++;
		#}
	}
	
	#my @graphData = ([1..scalar(@histo)], [@histo]);
	#my $graphImage = $mygraph->plot(\@graphData);
	
	my $x = 1;
	print "layout.addDataset('old', [";
	foreach(@histoOld)
	{
		if(!defined($_) || $_ eq "")
		{
			$_ = 0;
		}
		print "[$x, $_], ";
		$x++;
	}	
	print "]);";
	$x = 1;
	print "layout.addDataset('new', [";
	foreach(@histoNew)
	{
		if(!defined($_) || $_ eq "")
		{
			$_ = 0;
		}
		print "[$x, $_], ";
		$x++;
	}
	print "]);";
}

generateHistogram();

print <<EOF
    layout.evaluate();
    var canvas = MochiKit.DOM.getElement("graph");
    var plotter = new PlotKit.SweetCanvasRenderer(canvas, layout, options);
    plotter.render();
}
MochiKit.DOM.addLoadEvent(drawGraph);
</script>
</head>
<body>
<div><canvas id="graph" height="500" width="700"></canvas></div>
</body>
</html>
EOF
