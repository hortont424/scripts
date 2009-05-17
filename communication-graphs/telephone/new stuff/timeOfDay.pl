#!/usr/bin/perl -Wall

# Same rules as the other file!

my %time;

opendir(DIR,".");
@files = readdir(DIR);

foreach $file (@files)
{
	if(!($file =~ /csv/) || $file eq "out.csv")
	{
		next;
	}
	
	open(DATA,$file);
	while(<DATA>)
	{
		chomp;
		if($_ =~ /0.00,0.00,0.00/)
		{
			my @data = split(",", $_);
			my $time = $data[3];
			my $minutes = $data[6];
			
			my $hour = $time;
			$hour =~ s/:.*$//g;
			$hour = int($hour);
			if($time =~ /PM/)
			{
				$hour += 12;
			}
			
			if($hour == 24)
			{
				$hour = 0;
			}
			
			$time{$hour} += $minutes;
		}
	}
	close(DATA);
}

$\="";

open(OUT, ">out.csv");
select OUT;

sub hashKeyDescendingNum
{
	$a <=> $b;
}

foreach $key (sort hashKeyDescendingNum keys %time)
{
	print $key.",".$time{$key}."\n";
}
close OUT;