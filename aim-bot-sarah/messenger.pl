#!/usr/bin/perl -Wall

use Net::OSCAR qw(:standard);
use AI::MegaHAL;

srand( time ^ ($$ + ($$ << 15)) );

$oscar = Net::OSCAR->new(capabilities => [qw(extended_status typing_status)], rate_manage => OSCAR_RATE_MANAGE_MANUAL);
$oscar->set_callback_im_in(\&im_in);
$oscar->set_callback_signon_done(\&signon_done);
$oscar->set_callback_extended_status(\&extended_status);

my $chatter = new AI::MegaHAL('AutoSave' => 1);

sub im_in
{
	my($oscar, $sender, $message, $is_away) = @_;
	$message =~ s/\<[^\>]*\>//g;
	
	if($sender =~ /AOL/)
	{
		return;
	}
	
	if($sender =~ /hortont424/ || $sender =~ /bbmandelbrot/)
	{
		if($message =~ /^ONLINE$/)
		{
			$oscar->set_away();
			return;
		}
		
		`echo "$message" > /tmp/awaymessage`;
		$oscar->set_away($message);
		return;
	}
	
	sleep(rand(2)+.5);
	$oscar->send_typing_status($sender, TYPINGSTATUS_STARTED);
	sleep(2 + rand(5));
	send_im($oscar, $sender, $message, $is_away);
}

sub send_im
{
	my($oscar, $sender, $message, $is_away) = @_;
	my $reply = $chatter->do_reply($message);
	$reply =~ s/\<[^\>]*\>//g;
	$reply =~ s/\<\/html//;
	$reply =~ s/&lt;/\</ig;
	$reply =~ s/&gt;/\>/ig;
	$reply =~ s/&amp;/\>/ig;
	$reply =~ s/gt/\>/ig;
	$reply =~ s/lt/\>/ig;
	
	$oscar->send_im($sender,$reply);
	$oscar->send_typing_status($sender, TYPINGSTATUS_FINISHED);
	$chatter->_cleanup();
	print $sender . ": " . $message;
	print "Reply: " . $reply;
}

sub signon_done
{
	$oscar->set_away(`cat /tmp/awaymessage`);
}

sub extended_status
{
	$oscar->set_away(`cat /tmp/awaymessage`);
}

print "Make sure you edit the file and insert a password!"

$oscar->signon(screenname => "bbmandelbrot", password => "");

while(1)
{	
	$oscar->do_one_loop();
}