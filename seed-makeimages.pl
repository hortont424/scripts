use GD;

my $asdf = 0;

for(my $a = 1; $a < 1097; $a++)
{
	makeimg("seed-$a.tar", "seed-".($a+1).".tar");
}

sub makeimg
{
	$first = shift;
	$second = shift;
	
	$a = `diff -U 150000 -a $first $second | grep -a -v "staff"`;
	@d = split("\n",$a);
	
	$im = new GD::Image(500,500);

	$white = $im->colorAllocate(255,255,255);
	$black = $im->colorAllocate(0,0,0);
	$red = $im->colorAllocate(255,0,0);
	$green = $im->colorAllocate(0,255,0);

	$x = 0;
	$y = 0;

	foreach $e (@d)
	{
		if($e =~ /^\+/)
		{
			$im->setPixel($x, $y, $green);
			$im->setPixel($x + 1, $y, $green);
			$im->setPixel($x, $y + 1, $green);
			$im->setPixel($x + 1, $y + 1, $green);
		}
		elsif($e =~ /^-/)
		{
			$im->setPixel($x, $y, $red);
			$im->setPixel($x + 1, $y, $red);
			$im->setPixel($x, $y + 1, $red);
			$im->setPixel($x + 1, $y + 1, $red);
		}
		elsif($e =~ /^ /)
		{
			$im->setPixel($x, $y, $black);
			$im->setPixel($x + 1, $y, $black);
			$im->setPixel($x, $y + 1, $black);
			$im->setPixel($x + 1, $y + 1, $black);
		}
		else
		{
			$im->setPixel($x, $y, $white);
			$im->setPixel($x + 1, $y, $white);
			$im->setPixel($x, $y + 1, $white);
			$im->setPixel($x + 1, $y + 1, $white);
		}
	
		$x += 2;
	
		if($x == 500)
		{
			$x = 0;
			$y += 2;
		}
	}

	open(OUT, ">" . (1100 - $asdf) . ".png");
	binmode OUT;
	select OUT;
	print $im->png;

	$asdf++;
}
