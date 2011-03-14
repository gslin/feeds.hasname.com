#!/usr/bin/env perl

use Carp;
use Encode;
use HTML::TreeBuilder;
use Object::Destroyer;
use LWP::UserAgent;
use URI;
use XML::Atom::Entry;
use XML::Atom::Feed;
use XML::Atom::Link;
use utf8;

use strict;
use warnings;

use constant WEBURL => 'http://www.scsb.com.tw/card.jsp';

BEGIN {
    $XML::Atom::DefaultVersion = '1.0';
};

main();

sub main {
    my $ua = LWP::UserAgent->new;

    my $res = $ua->get(WEBURL);
    my $body = Encode::encode('utf-8', $res->decoded_content);

    my $h = HTML::TreeBuilder->new_from_content($body);
    my $h_o = Object::Destroyer->new($h, 'delete');

    my $link = XML::Atom::Link->new;
    $link->type('text/html');
    $link->rel('alternate');
    $link->href(WEBURL);

    my $feed = XML::Atom::Feed->new;
    $feed->title('HOT NEWS :: 信用卡 :: 上海商業儲蓄銀行');
    $feed->add_link($link);

    my $baseUri = URI->new(WEBURL);

    foreach my $a ($h->look_down('_tag' => 'a', 'class' => 'unnamed4')) {
	next unless defined $link;
	my $a_o = Object::Destroyer->new($a, 'delete');

	my $uri = URI->new_abs($a->attr('href'), $baseUri);

	my $link = XML::Atom::Link->new;
	$link->type('text/html');
	$link->rel('alternate');
	$link->href($uri->as_string);

	my $entry = XML::Atom::Entry->new;
	$entry->title($a->as_text);
	$entry->add_link($link);
	$feed->add_entry($entry);
    }

    open FEED, '> /var/www/feeds.hasname.com/webroot/feed/scsb.creditcard.atom' or croak $!;
    print FEED $feed->as_xml;
    close FEED;
}

__END__
