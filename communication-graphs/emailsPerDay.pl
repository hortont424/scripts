#!/usr/bin/perl -Wall

use Date::Manip;

my %emaildates;

opendir(JUNK, '/Users/hortont/Library/Mail/IMAP-hortont424@imap.gmail.com/[Gmail]/All Mail.imapmbox/Messages/');
@spam = readdir(JUNK);
closedir(JUNK);
foreach $mail (@spam)
{
    if($mail =~ /.*\.emlx$/)
    {
        open(EMAIL, '/Users/hortont/Library/Mail/IMAP-hortont424@imap.gmail.com/[Gmail]/All Mail.imapmbox/Messages/'.$mail);
        while(<EMAIL>)
        {
            if($_ =~ /Date: .*/)
            {
				$_ =~ s/Date: //;
				$_ =~ s/\>* //;
				$_ =~ s/TueDec/Tue Dec/;
				$_ =~ s/Last-Attempt-//;
				$_ =~ s/Wed,33/Mon,3/;
				$_ =~ s/qui/Thu/;
				$_ =~ s/Ago/Aug/;
				$_ =~ s/mai/may/;
				$_ =~ s/Tue,35 Aug/Tue,4 Sep/;
				$_ =~ s/FriMay/Fri,May/;
				$_ =~ s/TueMar/Tue,Mar/;
				$_ =~ s/X-Mail-Created-//;
				$_ =~ s/sam.,//;
				
                chomp $_;
				
				if($_ eq "")
				{
					last;
				}
				
				print $_;
				
				eval
				{
					$date = ParseDate($_);
					$date = Date_SetTime($date,0,0,0);
					$date = UnixDate($date,"%s");
					$emaildates{$date}++;
				};
				
				last;
            }
        }
        close(EMAIL);
    }
}

open(OUT,">out.csv");
select OUT;

for my $mydate (sort { $a <=> $b } keys %emaildates)
{
	print $mydate . "," . $emaildates{$mydate};
}

close OUT;
