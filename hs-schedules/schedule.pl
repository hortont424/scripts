use XML::LibXML;
use IO::File;
use schedule;

print "<html>
<head>
<style>
body {
    font-family: Helvetica, Arial, san-serif;
    margin: 0;
    background-color: white;
}

#banner {
    background-color: rgb(81,118,236);
    background-repeat: repeat-x;
    background-position: top left;
    padding: 6px 0 0 8px;
    margin: 0px;
    height: 36px;
    font-family: Helvetica, sans-serif;
    font-size: 24px;
    letter-spacing: 0.07em;
    cursor: default;
    color: #FFFFFF;
    margin-right: 0px;
    text-align: center;
}

#semester {
    border: dashed 2px;
    border-top: 0px;
    border-left: 0px;
    border-right: 0px;
    width: 45%;
    margin: 5px;
    padding: 3px 0px 3px 0px;
    text-align: center;
    font-size: 20pt;
}

#aday {
    border: none;
    width: 25%;
    margin: 5px 0px 0px 0px;
    padding: 3px;
    font-size: 16pt;
    text-align: center;
}

#bday {
    border: none;
    width: 25%;
    margin: 5px 0px 0px 0px;
    padding: 3px;
    font-size: 16pt;
    text-align: center;
}

#mod {
    text-decoration: none;
    font-size: 14pt;
    font-weight: bold;
    background-color: rgb(81,118,236);
    margin: 5px;
    padding: 5px;
    text-align: center;
    height: 20%;
}

#lmod {
    text-decoration: none;
    font-size: 14pt;
    font-weight: bold;
    background-color: rgb(141,178,255);
    margin: 5px;
    padding: 5px;
    text-align: center;
    height: 20%;
}

#teacher {
    font-weight: normal;
    font-style: italic;
    font-size: 10pt;
    text-align: right;
    margin: 3px 0px 0px 0px;
}

#room {
    font-weight: normal;
    font-size: 10pt;
    text-align: left;
    margin: 3px 0px 0px 0px;
    display: inline;
    float: left;
}

#grade {
    font-weight: bold;
    font-size: 10pt;
    text-align: left;
    margin: 3px 0px 0px 0px;
    display: inline;
    float: left;
}

#matches {
    font-weight: normal;
    font-size: 10pt;
    text-align: right;
    margin: 3px 0px 0px 0px;
}
</style>
</head>
<body>";

$name = shift;

@totallist = split(" ", `ls`);

@otherscheds = ();

foreach $sched (@totallist)
{
    if($sched =~ /.*\.xml$/ && not $sched eq $name)
    {
        @otherscheds = (@otherscheds, $sched);
    }
}

my $schedule = storyaccess->new();
$schedule->getData("$name");

print "<div id='banner'>" . $schedule->getUsername() . "'s " . $schedule->getYears() . " Schedule</div>";

print "<table width='95%' align='center'>
    <tr>
        <td colspan='2' id='semester'>Fall Semester</td>
        <td></td>
        <td colspan='2' id='semester'>Spring Semester</td>
    </tr>
    <tr>
        <td id='aday'>A Day</td>
        <td id='bday'>B Day</td>
        <td></td>
        <td id='aday'>A Day</td>
        <td id='bday'>B Day</td>
    ";

#my %roomnumber, %teacher, %classname, %grade;

#foreach $class ($root->findnodes("class"))
#{
#    $id = $class->findvalue('@id');
#    $roomnumber{$id} = $class->findvalue('@room');
#    $teacher{$id} = $class->findvalue('@teacher');
#    $classname{$id} = $class->findvalue('@name');
#    $grade{$id} = $class->findvalue('@grade');
#}

#my %secondroomnumber, %secondname;

#foreach $class ($secondroot->findnodes("class"))
#{
#    $id = $class->findvalue('@id');
#    $secondroomnumber{$id} = $class->findvalue('@room');
#    $secondname{$id} = $secondroot->findvalue('/schedule/name');
#    $secondname{$id} =~ s/(.).*/$1/;
#}

my @classes = $schedule->getClasses();
my @mods = $schedule->getMods();
my %classbyid;

foreach $class (@classes)
{
    $classbyid{$class->id} = $class;
}

$classnum = 0;

for($class = 1; $class <= 5; $class++)
{
    print "</tr><tr>";
    for($sem = 1; $sem <= 2; $sem++)
    {
        if($sem == 2)
        {
            print "<td></td>";
        }
        
        for($dia = 1; $dia <= 2; $dia++)
        {

            if($class % 2)
            {
                print "<td id='mod'><div id='room'>";
            }
            else
            {
                print "<td id='lmod'><div id='room'>";
            }
            
            $currentmod = @mods[(((($dia - 1) * 5) + ($class - 1)) + (($sem - 1) * 10))];
            $id = $currentmod->id;
            $room = $classbyid{$id}->room;
            $classname = $classbyid{$id}->name;
            $grade = $classbyid{$id}->grade;
            $teacher = $classbyid{$id}->teacher;
            $matches = "&nbsp;";
            
            #$matches = "TAAS";
            
            foreach $csched (@otherscheds)
            {
                my $mparser = XML::LibXML->new();
                my $mtree = $mparser->parse_file($csched);
                my $mproot = $mtree->getDocumentElement;
                
                my $msa = new storyaccess;
                
                my @mmodElements;
                my @mclassElements;
                
                $musername = "";
                $myears = "";
                @mmods = ();
                @mclasses = ();
                
                eval
                {
                    $musername = $mproot->findvalue("name");
                    $musername =~ s/([a-zA-Z])[^ ]* ([a-zA-Z])[^ ]*/$1$2/;
                    @mmodElements = $mproot->findnodes("semester/day/mod");
                };
                
                $i = 0;
                
                foreach $memod (@mmodElements)
                {
                    $myid = $memod->findvalue('@id');
                    if($i == (((($dia - 1) * 5) + ($class - 1)) + (($sem - 1) * 10)))
                    {
                        if($myid eq $id)
                        {
                            $matches .= "$musername ";
                        }
                    }
                    $i++;
                }
            }
            
            if($classname ne "TA" || $teacher ne "???")
            {
                if($room eq "???")
                {
                    $matches = "&nbsp;";
                    $room = "<span style='color: red;'>$room</span>";
                }
                
                if($teacher eq "???")
                {
                    $teacher = "<span style='color: red;'>$teacher</span>";
                }
        
                print "$room</div><div id='matches'>$matches</div>$classname<br><div id='grade'></div><div id='teacher'>$teacher</div></td>";
            }
            else
            {
                print "</div><div id='matches'></div>$classname<br><div id='grade'></div><div id='teacher'></div></td>";
            }
        }
    }
}

