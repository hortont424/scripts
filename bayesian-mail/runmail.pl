opendir(DIR, "/Users/hortont/Library/Mail/Mailboxes/Junk.mbox/Messages/");
foreach $file (readdir(DIR))
{
    system("perl bayes.pl add junk /Users/hortont/Library/Mail/Mailboxes/Junk.mbox/Messages/$file");
}

opendir(DIR, "/Users/hortont/Library/Mail/Mailboxes/Archives.mbox/Messages/");
foreach $file (readdir(DIR))
{
    system("perl bayes.pl add good /Users/hortont/Library/Mail/Mailboxes/Archives.mbox/Messages/$file");
}