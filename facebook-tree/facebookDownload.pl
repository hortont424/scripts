use WWW::Mechanize;
use Term::ReadKey;

open(OUT,">outfriends.dot");

my $fblogin = "http://www.facebook.com/";

print "Password: ";

ReadMode('noecho');
my $password = ReadLine(0);
ReadMode('restore');
chomp $password;

print "\n";

writeAllFriendsOfToDegree(643318486, 3, "rpi");

sub writeAllFriendsOfToDegree
{
	local $myid = $_[0];
	local $degree = $_[1];
	local $network = $_[2];

	if($degree == 0)
	{
		return;
	}
	
	local $mech = WWW::Mechanize->new(autocheck=>1);
	$mech->get($fblogin);
	$mech->submit_form(form_number=>1, fields=>{"email"=>"hortot2\@rpi.edu","pass"=>$password});

	$mech->get("http://$network.facebook.com/friends.php?id=$myid");
	local @links = $mech->find_all_links(tag=>"a",text_regex=> qr/View Friends/i );
	
	foreach $link (@links)
	{
		local $id = $link->url();
		$id =~ s/^.*id=([0-9]*)$/$1/;
		chomp $id;
		
		local $newnetwork = $mech->content();
		$newnetwork =~ s/[\n\r]//g;
		$newnetwork =~ s/.*http:\/\/([^\.]*)\.facebook\.com\/friends\.php\?id=$id.*/$1/;
		chomp $newnetwork;
		
		print OUT "\"" . $myid . "\"->\"" . $id . "\",\n";

		writeAllFriendsOfToDegree($id,$degree-1,$newnetwork);
	}
}

close OUT;