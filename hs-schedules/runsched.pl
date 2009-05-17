use IO::File;

@totallist = split(" ", `ls`);

foreach $sched (@totallist)
{
    if($sched =~ /^.*\.xml$/)
    {
        $newname = $sched;
        $newname =~ s/\.xml/\.html/;
        `perl schedule.pl $sched > $newname`;
    }
}