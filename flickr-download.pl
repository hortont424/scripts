for($i = 1; $i < 108; $i++)
{
	system("wget -q http://flickr.com/photos/tags/roflcon/?page=$i");
	open(HTML,"<index.html?page=$i");
	while(<HTML>)
	{
		if(/photo_container/)
		{
			$_ =~ s/.*pc_t\"\>\<a href=\"([^"]*)\".*/$1/;
			#print "http://flickr.com" . $1 . "sizes/o/\n";
			
			$id = $1;
			$t = $1;
			$t =~ s/\///g;
			
			system("curl " . "http://flickr.com" . $id . "sizes/l/ > $t");
			open(SECOND,"<$t");
			while(<SECOND>)
			{
				if(/static.flickr.com.*_b\.jpg/)
				{
					$_ =~ s/.*src="([^"]*)".*/$1/;
					chomp $_;
					system("curl $_ > pictures/$t.jpg");
				}
			}
		}
	}
}