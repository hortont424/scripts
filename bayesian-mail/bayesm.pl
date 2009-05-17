use strict;
use DB_File;

my %words;
tie %words, 'DB_File', 'words.db';

sub parse_file
{
    my ($file) = @_;
    my %word_counts;
    
    open FILE, "<$file";
    while(my $line = <FILE>)
    {
        while($line =~ s/([[:alpha:]]{3,44})[ \t\n\r]//)
        {
            $word_counts{lc($1)}++;
        }
    }
    close FILE;
    return %word_counts;
}

sub add_words
{
    my ($category, %words_in_file) = @_;
    foreach my $word (keys %words_in_file)
    {
        $words{"$category-$word"} += $words_in_file{$word};
    }
}

sub classify
{
    my (%words_in_file) = @_;
    my %count;
    
    my $total = 0;
    foreach my $entry (keys %words)
    {
        $entry =~ /^(.+)-(.+)$/;
        $count{$1} += $words{$entry};
        $total += $words{$entry};
    }
    
    my %score;
    foreach my $word (keys %words_in_file)
    {
        foreach my $category (keys %count)
        {
            if(defined($words{"$category-$word"}))
            {
                $score{$category} += log($words{"$category-$word"} / $count{$category});
            }
            else
            {
                $score{$category} += log(0.01 / $count{$category});
            }
        }
    }
    
    foreach my $category (keys %count)
    {
        $score{$category} += log($count{$category} / $total);
    }
    
    foreach my $category (sort { $score{$b} <=> $score{$a} } keys %count)
    {
        print "$category $score{$category}\n";
    }
}

opendir(DIR, "/Users/hortont/Library/Mail/Mailboxes/Junk.mbox/Messages/");

my $i = 0;

foreach my $filein (readdir(DIR))
{
    if(($i % 100) == 0.0)
    {
        print "$i\n";
    }
    add_words( "junk", parse_file("/Users/hortont/Library/Mail/Mailboxes/Junk.mbox/Messages/$filein"));
    $i++;
}

print "Done junk.\n";

opendir(DIRT, "/Users/hortont/Library/Mail/Mailboxes/Archives.mbox/Messages/");

$i = 0;

foreach my $filein (readdir(DIRT))
{
    if(($i % 100) == 0.0)
    {
        print "$i\n";
    }
    add_words( "good", parse_file("/Users/hortont/Library/Mail/Mailboxes/Archives.mbox/Messages/$filein"));
    $i++;
}

print "Done good.\n";

untie %words;