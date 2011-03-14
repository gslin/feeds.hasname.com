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

use constant WEBURL => 'http://www.hncb.com.tw/news/newslist_credit_1.shtml';

BEGIN {
    $XML::Atom::DefaultVersion = '1.0';
};

main();

sub main {
    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts(verify_hostname => 0);

    my $res = $ua->get(WEBURL);
    my $body = Encode::encode('utf-8', $res->decoded_content);

    my $h = HTML::TreeBuilder->new_from_content($body);
    my $h_o = Object::Destroyer->new($h, 'delete');

    my $link = XML::Atom::Link->new;
    $link->type('text/html');
    $link->rel('alternate');
    $link->href(WEBURL);

    my $feed = XML::Atom::Feed->new;
    $feed->id('http://feeds.hasname.com/feed/hncb.creditcard.atom');
    $feed->title('最新消息 :: 信用卡 :: 華南銀行');
    $feed->add_link($link);

    my $baseUri = URI->new(WEBURL);

    foreach my $link ($h->look_down('class' => qr/content12(rd|gy)/)) {
	next unless defined $link;
	my $link_o = Object::Destroyer->new($link, 'delete');

	my $a = $link->look_down('_tag', 'a');
	next unless defined $a;
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

    open FEED, '> /var/www/feeds.hasname.com/webroot/feed/hncb.creditcard.atom' or croak $!;
    print FEED $feed->as_xml;
    close FEED;
}

__END__
