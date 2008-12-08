#!/usr/bin/perl -w

use Date::Parse;
use File::HomeDir;

use warnings;
use strict;

my %dates = ();
my $library = shift || File::HomeDir->my_home . "/Music/iTunes/iTunes Music Library.xml";
my $total = 0;

foreach (`grep "Date Added" "$library"`)
{
	/^.*e\>(.*)\<.*$/;
	$dates{str2time($1)}++;
}

foreach (sort keys %dates)
{
	print "$_," . ($total += $dates{$_}) . "\n";
}
