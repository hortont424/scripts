#!/usr/bin/perl -Wall

#use Telephone::Lookup::Americom;

#$am = Telephone::Lookup::Americom->new();

my %time;

opendir(DIR,".");
@files = readdir(DIR);

foreach $file (@files)
{
	if(!($file =~ /html/))
	{
		next;
	}
	
	open(DATA,$file);
	while(<DATA>)
	{
		chomp;
		if($_ =~ /[PA]M/)
		{
			my $name = $_;
			$name =~ s/.*\>([^\s]*)\s*\<.*/$1/;
			$name =~ s/:[0-9]{2}//;
			$front = $name;
			$front =~ s/[^0-9]//g;
			if($name =~ /PM/)
			{
				$front += 12;
			}
			
			if($front == 24)
			{
				$front = 0;
			}
			
			my $minutes = <DATA>;
			$minutes = <DATA>;
			chomp $minutes;
			$minutes =~ s/[^0-9]//g;
			$time{$front} += $minutes;
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