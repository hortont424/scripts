#!/usr/local/bin/perl -w

use XML::Parser;

system("wget -q http://weather.gov/data/current_obs/KBTV.xml");

my $temperature = "", $dewpoint = "", $weather = "", $station_id = "", $location = "", $wind = "", $windchill = "", $visibility = "";

my $parser = new XML::Parser(ErrorContext => 2);

$parser->setHandlers(Char => \&char_handler);

$parser->parsefile("KBTV.xml");

print "Weather for ", $location, " ($station_id)\n\n";
print "Temperature: ", $temperature, "\n";
print "Dewpoint: ", $dewpoint, "\n";
print "Windchill: ", $windchill, "\n";
print "Wind: ", $wind, "\n";
print "Visibility: ", $visibility, "\n";

sub char_handler
{
    my ($p, $element_data) = @_;
    my $element_name = $p->current_element;

    if($element_name eq "temperature_string")
    {
        $temperature = $element_data;
    }
    elsif($element_name eq "dewpoint_string")
    {
        $dewpoint = $element_data;
    }
    elsif($element_name eq "weather")
    {
        $weather = $element_data;
    }
    elsif($element_name eq "station_id")
    {
        $station_id = $element_data;
    }
    elsif($element_name eq "location")
    {
        $location = $element_data;
    }
    elsif($element_name eq "wind_string")
    {
        $wind = $element_data;
    }
    elsif($element_name eq "windchill_string")
    {
        $windchill = $element_data;
    }
    elsif($element_name eq "visibility")
    {
        $visibility = $element_data;
    }
}

system("rm KBTV.xml");
