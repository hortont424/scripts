# Schedule Access Code (derived from LifeArchive Story Access Code)
# Copyright (C) 2005 Tim Horton

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

package storyaccess;

do 'config.pl';

struct(schoolclass => { id => '$', teacher => '$', room => '$', name => '$', grade => '$'});
struct(semester => { name => '$', day1 => '$', day2 => '$' });
struct(mod => { id => '$'});

our @EXPORT = ('schoolclass', 'semester', 'mod');

use XML::LibXML;
use Class::Struct;

my $filename;
my $username;
my $years;
my @mods;
my @classes;

sub new {
    my($class) = @_;        # Class name is in the first parameter
    my $self = { username => $username };  # Anonymous hash reference holds instance attributes
    bless($self, $class);          # Say: $self is a $class
    return $self;
}

sub getData
{
	$filename = shift;
	$filename = shift; # Why twice?? something ELSE comes in the first time
	
	my $parser = XML::LibXML->new();
	my $tree = $parser->parse_file($filename);
	my $proot = $tree->getDocumentElement;
	
	my $sa = new storyaccess;
	
	my @modElements;
	my @classElements;
	
	$username = "";
	$years = "";
	@mods = ();
	@classes = ();
	
	eval
	{
		$username = $proot->findvalue("name");
		$years = $proot->findvalue("years");
		@modElements = $proot->findnodes("semester/day/mod");
		@classElements = $proot->findnodes("class");
	};
	
	#eval
	#{
		foreach $emod (@modElements)
		{
			#eval
			#{
				@mods[scalar(@mods)] = new mod;
				@mods[scalar(@mods) - 1]->id($emod->findvalue('@id'));
			#}
		}
	#};
	
	#eval
	#{
		foreach $eclass (@classElements)
		{
			#eval
			#{
                @classes[scalar(@classes)] = new schoolclass;
                @classes[scalar(@classes) - 1]->id($eclass->findvalue('@id'));
                @classes[scalar(@classes) - 1]->teacher($eclass->findvalue('@teacher'));
                @classes[scalar(@classes) - 1]->room($eclass->findvalue('@room'));
                @classes[scalar(@classes) - 1]->grade($eclass->findvalue('@grade'));
                @classes[scalar(@classes) - 1]->name($eclass->findvalue('@name'));
			#}
		}
	#};
}

sub getUsername
{
	return $username;
}

sub getYears
{
	return $years;
}

sub getMods
{
	return @mods;
}

sub getClasses
{
	return @classes;
}

1;