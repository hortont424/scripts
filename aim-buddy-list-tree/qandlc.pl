# quote and lc

use IO;

$filename = "sbinnebo.txt";

open(FILE, "< $filename");
open(OUTFILE, " > $filename.out");
while($line = <FILE>)
{
    $line =~ s/[^a-zA-Z0-9\-\> \"]//g;
    $line = lc($line);
    $line .= "\";";
    print OUTFILE $line . "\n";
}
