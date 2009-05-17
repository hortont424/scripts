#!/usr/bin/perl -Wall

open(OUT, ">filesPerDay.csv");

@people=("robb","dj","carol","alex","sarah","amy");

foreach $person (@people)
{
	@nums = ();
	
	for($count = 1; $count <= 31; $count++)
	{
		my $j = $count - 1;
		my $files = `mdfind -onlyin ~/ \"((kMDItemContentCreationDate>\\\$time.today(-$count)) && (kMDItemContentCreationDate<\\\$time.today(-$j)))\"`; # | grep -i \"$person\" | wc -l`);
		my $filect = `mdfind -onlyin ~/ \"((kMDItemContentCreationDate>\\\$time.today(-$count)) && (kMDItemContentCreationDate<\\\$time.today(-$j)))\" | wc -l`; # | grep -i \"$person\" | wc -l`);
		$filect =~ s/[^0-9]//g;
		chomp $filect;
		my $num = 0;
		
		#my $current = 0;
		
		foreach $filename (split("\n", $files))
		{
			#$current++;
			chomp $filename;			
			
			my $perfile = `grep -i \"$person\" \"$filename\" | wc -l`;
			$perfile =~ s/[^0-9]//g;
			chomp $perfile;
			
			if($perfile > 0)
			{
				$num += $perfile;
			}
			
			#if($current % 100 == 0)
			#{
			#	print $current . "/" . $filect . "(" . (($current/$filect)*100) . ")";
			#}
		}
		
		@nums=(@nums,$num);
	}
	
	print OUT "$person".join(',',@nums)."\n";
}

close(OUT);