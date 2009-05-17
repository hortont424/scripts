#!/usr/bin/perl

# For use with: http://www.batchgeocode.com/

use Text::vCard::Addressbook;
my $address_book = Text::vCard::Addressbook->load(["addresses.vcf"]);
my @vcards = $address_book->vcards();

print "Name\tAddress\tCity\tState\tZipcode\n";

foreach my $vcard (@vcards)
{
	@addresses = @{$vcard->get({ 'node_type' => 'addresses' })};
	
	foreach my $address (@addresses)
	{
		next if $address->street() eq "" || $address->city() eq "";
		my $region = $address->region();
		if($address->country() ne "USA" && $address->country() ne "")
		{
			$region = $address->country();
		}
		$addr = $address->street() . "\t" . $address->city() . "\t" . $region . "\t" . $address->post_code();
		$addr =~ s/\\n/ /;
		$addr =~ s/\\(.)/$1/;
		print $vcard->fullname() . "\t" . $addr . "\n";
	}
}