#!/usr/bin/perl -w

use GD::Graph::lines;

#my $per = 'Day';
my $per = 'Month';

@dates = ();

opendir(JUNK, "./Junk");
@spam = readdir(JUNK);
closedir(JUNK);
foreach $mail (@spam)
{
    if($mail =~ /.*\.emlx$/)
    {
        open(EMAIL, "./Junk/$mail");
        while(<EMAIL>)
        {
            if($_ =~ /Date: .*/)
            {
                $_ =~ s/.*(.. [A-Za-z]{3} ....).*/$1/;
                $_ =~ s/.*(..)\/(..)\/(....)/$1 $2 $3/;
                $_ =~ s/Jan/1/i;
                $_ =~ s/Feb/2/i;
                $_ =~ s/Mar/3/i;
                $_ =~ s/Apr/4/i;
                $_ =~ s/May/5/i;
                $_ =~ s/Jun/6/i;
                $_ =~ s/Jul/7/i;
                $_ =~ s/Aug/8/i;
                $_ =~ s/Sep/9/i;
                $_ =~ s/Oct/10/i;
                $_ =~ s/Nov/11/i;
                $_ =~ s/Dec/12/i;
                $_ =~ s/^ //;

                $_ =~ s/([0-9]*) ([0-9]*) ([0-9]*)/$3 $2 $1/;
                $_ =~ s/^([0-9]*) ([0-9]) ([0-9]*)$/$1 0$2 $3/;
		$_ =~ s/^([0-9]*) ([0-9]*) ([0-9])$/$1 $2 0$3/;
		$_ =~ s/ //g;
                chop $_;
                if($_ =~ /^[0-9]{8}$/)
                {
                    @dates = (@dates, $_);
                }
		last;
            }
        }
        close(EMAIL);
    }
}

@dates = sort(@dates);

my @outdates;
my @outcounts;

my $olddate = $dates[0];
my $dupecount;

my $firstdate = $dates[0];

my $lastdate = $dates[scalar(@dates) - 1];

foreach $date (@dates)
{
    if($per eq 'Day')
    {
        $newdays = $date;
        $newdays =~ s/([0-9]{4})([0-9]{2})([0-9]{2})/$3/;
        $olddays = $olddate;
        $olddays =~ s/([0-9]{4})([0-9]{2})([0-9]{2})/$3/;
    }
    else
    {
        $newdays = $date;
        $newdays =~ s/([0-9]{4})([0-9]{2})([0-9]{2})/$1 $2/;
        $olddays = $olddate;
        $olddays =~ s/([0-9]{4})([0-9]{2})([0-9]{2})/$1 $2/;
    }

    $specold = $olddays;
    $oneold = $olddays;

    if($newdays ne $specold)
    {
        if($newdays ne ++($oneold) && $per eq 'Day')
        {
            @outdates = (@outdates, ++($olddays));
            @outcounts = (@outcounts, 0);
        }
        @outdates = (@outdates, $specold);
        @outcounts = (@outcounts, $dupecount);
        $dupecount = 1;
        $olddate = $date;
    }
    else
    {
        $dupecount++;
    }
}

@outdates = (@outdates, $olddays);
@outcounts = (@outcounts, $dupecount);

@dataarray = (\@outdates, \@outcounts);

my $graphtitle;

if($per eq 'Day')
{
    $graphtitle = "Spam Messages Per Day ($firstdate to $lastdate)";
}
else
{
    $graphtitle = "Spam Messages Per Month ($firstdate to $lastdate)";
}

my $spamgraph = GD::Graph::lines->new(1200,600);
$spamgraph->set(x_label => 'Dates', y_label => 'Spam Messages', title => $graphtitle, dclrs => ['blue'], values_space => 12, valuesclr => 'red') or warn $spamgraph->error;

if($per ne 'Day')
{
	$spamgraph->set(show_values => \@dataarray);
}
else
{
	$spamgraph->set(x_plot_values => 0);
}

open(OUTIMG, "> spam.png");
print OUTIMG $spamgraph->plot(\@dataarray)->png;
close(OUTIMG);