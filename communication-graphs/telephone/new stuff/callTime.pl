#!/usr/bin/perl -Wall

# Somehow, sort the files into alphabetical order by chronology :-) I use:
# YYYY.MM.csv

my %time;

opendir(DIR,".");
@files = readdir(DIR);

my $n = 1;

sub computeName
{
	my $name = shift;
	
	if($name eq "802-999-2400" || $name eq "802-879-5152")
	{
		return "Sarah";
	}
	
	if($name eq "802-879-7802" || $name eq "802-238-7290" || $name eq "802-238-4421" || $name eq "802-769-5797"  || $name eq "802-264-5909")
	{
		return "Home";
	}
	
	if($name eq "706-231-9785" || $name eq "518-276-7572")
	{
		return "Robb";
	}
	
	if($name eq "609-602-9508")
	{
		return "Gino";
	}
	
	if($name eq "518-276-6006" || $name eq "518-276-6000")
	{
		return "RPI";
	}
	
	if($name eq "718-431-4597" || $name eq "914-479-5475")
	{
		return "Anthony";
	}
	
	if($name eq "802-578-3656" || $name eq "000-012-3456")
	{
		return "Robbie";
	}
	
	if($name eq "518-698-6937")
	{
		return "Unknown";
	}
	
	if($name eq "703-577-1791")
	{
		return "DJ";
	}
	
	if($name eq "800-466-4411")
	{
		return "Google 411";
	}
	
	if($name eq "845-888-4481")
	{
		return "Grandma";
	}
	
	if($name eq "518-276-2010")
	{
		return "Eric";
	}
	
	if($name eq "585-760-9224")
	{
		return "Alex";
	}
	
	if($name eq "845-706-0728" || $name eq "845-331-5583" || $name eq "845-706-6660")
	{
		return "Vivian/Margaret";
	}
	
	if($name eq "508-330-2455")
	{
		return "Nate";
	}
	
	if($name eq "845-794-4733")
	{
		return "Flossie";
	}
	
	if($name eq "203-417-4496")
	{
		return "Mike";
	}
	
	if($name eq "845-797-6747" || $name eq "845-798-6747" || $name eq "845-794-3928" || $name eq "772-571-0384")
	{
		return "Pepa";
	}
	
	if($name eq "732-241-8297")
	{
		return "Peter";
	}
	
	if($name eq "802-310-3776")
	{
		return "Kevin";
	}
	
	if($name eq "518-893-3357")
	{
		return "Patrick";
	}
	
	if($name eq "866-895-1099")
	{
		return "AT&T";
	}
	
	if($name eq "800-692-7753")
	{
		return "Apple";
	}
	
	if($name eq "727-510-7397")
	{
		return "Savannah";
	}
	
	if($name eq "585-943-1214")
	{
		return "Connor";
	}
	
	if($name eq "202-683-8658")
	{
		return "Benoit";
	}
	
	if($name eq "315-225-8026")
	{
		return "Carol";
	}
	
	if($name eq "978-761-9324")
	{
	   return "Matt";
	}
	
	if($name eq "352-870-0160")
	{
	   return "Tim";
	}
	
	if($name eq "800-426-4968" || $name eq "800-426-7378")
	{
	   return "IBM";
	}
	
	if($name eq "315-942-3386" || $name eq "315-271-1612")
	{
	   return "Carol's Friends";
	}
	
	return $name;
}

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
		if($_ =~ /0.00,0.00,0.00/ && !($_ =~ /VMAIL/))
		{
			my @data = split(",", $_);
			my $name = computeName($data[4]);
			my $minutes = $data[6];
			
			$time{$name}[$n] += $minutes;
			$time{$name}[0] += $minutes;
		}
	}
	close(DATA);
	
	$n++;
}

sub hashValueDescendingNum
{
	$time{$b}[0] <=> $time{$a}[0];
}

$\="";

open(OUT, ">out.csv");
select OUT;

foreach $file (@files)
{
	if(!($file =~ /html/))
	{
		next;
	}
	$file =~ s/.*[0-9]*-([A-Za-z]*)\.html.*/$1/;
	print ",".$file
}

print "\n";

foreach $key (sort hashValueDescendingNum (keys %time))
{
	print $key;

	for(my $i = 1; $i < $n; $i++)
	{
		if(defined($time{$key}[$i]))
		{
			print ",".$time{$key}[$i];
		}
		else
		{
			print ",".0;
		}
	}
	
	print "\n";
}
close OUT;