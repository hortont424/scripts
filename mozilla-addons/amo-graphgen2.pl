#!/usr/bin/perl -Wall

my $green = "#84CA82";
my $blue = "#ADC8DC";

open(OUT, ">amo.html");

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

print OUT <<EOF;
<html>
<head>
<style>
.nbar
{
	position: fixed;
	bottom: 20px;
	background: $blue;
	width: 15px;
}

.obar
{
	position: fixed;
	bottom: 20px;
	background: $green;
	width: 15px;
}

.xlabel
{
	position: fixed;
	bottom: 0px;
	width: 15px;
	text-align: center;
}

#data
{
	position: fixed;
	right: 20px;
	top: 20px;
	width: 350px;
	border: 1px solid lightgray;
	padding: 10px;
	background: white;
}

h1
{
	font-size: 18px;
	text-align: center;
	margin-top: 0px;
}

#key
{
	font-size: 18px;
	font-weight: bold;
}

.line
{
	width: 100px;
	height: 1px;
	background: lightgray;
	position: fixed;
	bottom: 0px;
	left: 20px;
}

.newitem
{
	display: inline;
	color: $blue;
}

.olditem
{
	display: inline;
	color: $green;
}

.olditem>a
{
	color: $green;
}

#info
{
	font-weight: normal;
	font-size: 16px;
	padding-top: 5px;
	color: gray;
}

</style>
<script>
function setData(newData)
{
	document.getElementById('data').innerHTML=newData;
}
</script>
</head>
<body>
<div id='key'><div style='color: $blue;'>New</div><div style='color: $green;'>Update</div><div id='info'></div></div>
EOF

use DBI;
my $dbh = DBI->connect("dbi:SQLite:dbname=pk.db","","");

my $all = $dbh->selectall_arrayref("SELECT * FROM amo");

my @histi;
my @histn;
my @histo;

my $maxdate = 0;
my $avgnewdate = 0;
my $avgolddate = 0;

foreach my $row (@$all)
{
	my ($name, $id, $date, $isNew) = @$row;
	
	$isNew = !$isNew;
	
	if($date > $maxdate)
	{
		$maxdate = $date;
	}
	
	if($isNew == 1)
	{
		$histn[$date]++;
		$avgnewdate += $date;
	}
	else
	{
		$histo[$date]++;
		$avgolddate += $date;
	}
	
	if($isNew == 1)
	{
		$name = "<div class=\\\"newitem\\\">$name</div>";
	}
	else
	{
		$name = "<div class=\\\"olditem\\\"><a href=\\\"https://addons.mozilla.org/firefox/$id/\\\">$name</a></div>";
	}
	
	if(defined($histi[$date]))
	{
		$histi[$date] .= "|$name";
	}
	else
	{
		$histi[$date] = "$name";
	}
}

$avgolddate /= $#histo;
$avgnewdate /= $#histn;

$avgolddate = cutDecimals($avgolddate, 2);
$avgnewdate = cutDecimals($avgnewdate, 2);

print OUT <<EOF;
<script>
document.getElementById('info').innerHTML = "Max. Time: $maxdate days<br>Avg. Updated Time: $avgolddate days<br>Avg. New Time: $avgnewdate days<br>";
</script>
EOF

for(my $linenum = 0; $linenum < 20; $linenum++)
{
	my $bottom = 20 + (20*$linenum);
	my $width = (20 * ($maxdate + 1)) - 5;
	print OUT "<div class='line' style='bottom: ${bottom}px; width: ${width}px;'></div>";
}

my $x = 0;

print OUT "<div id='data'></div>";

for(my $histe = 0; $histe <= $#histi; $histe++)
{
	if(!defined($histn[$histe]))
	{
		$histn[$histe] = 0;
	}
	
	if(!defined($histo[$histe]))
	{
		$histo[$histe] = 0;
	}
	
	if(!defined($histi[$histe]))
	{
		$histi[$histe] = "";
	}
	
	$histi[$histe] =~ s/\|/\<br\/\>/g;
	
	my $nheight = 20 * $histn[$histe];
	my $oheight = 20 * $histo[$histe] + $nheight;
	my $left = ($x * 20) + 20;
	print OUT "<div class='obar' style='height: ${oheight}px; left:${left}px;' onmouseover='setData(\"<h1>" . ($x+1) . " days</h1>" . $histi[$histe] . "\");'></div>";
	print OUT "<div class='nbar' style='height: ${nheight}px; left:${left}px;' onmouseover='setData(\"<h1>" . ($x+1) . " days</h1>" . $histi[$histe] . "\");'></div>";
	
	print OUT "<div class='xlabel' style='left:${left}px;'>".($x+1)."</div>";
	$x++;
}

print OUT <<EOF;
</body>
</html>
EOF

close OUT;
