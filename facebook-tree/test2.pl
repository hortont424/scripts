#!/usr/bin/perl -Wall

open(USER,"<friends.php.html");
open(OUTPUT,">>out");

select OUTPUT;

my $myname = "";

while(<USER>)
{
	if(/\<title\>/)
	{
		$myname = $_;
		$myname =~ s/\<title\>Facebook \| (.*)\'s Friends\<\/title\>/$1/;
		chomp $myname;
	}
	if(/td class="name"/)
	{
		$name = $_;
		$name =~ s/.*td class="name"\>\<span\>([^\<]*)\<.*/$1/;
		$name =~ s/&highlight//g;
		$name =~ s/.*td class="name"\>\<a href="http:\/\/[a-z]*\.facebook\.com\/profile\.php\?id=[0-9]*"\>([^\<]*)\<.*/$1/;
		chomp $name;
		print "\'$myname\'->\'$name\',";
	}
}

close(USER);
close(OUTPUT);
system("rm friends.php.html");