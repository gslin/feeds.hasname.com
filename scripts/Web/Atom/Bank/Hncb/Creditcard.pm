package Web::Atom::Bank::Hncb::Creditcard;
use strict;
use warnings;

use Any::Moose;
extends 'Web::Atom::Plugin';

use Encode;
use HTML::TreeBuilder;
use LWP::UserAgent;
use Object::AutoAccessor;
use Object::Destroyer;
use URI;
use namespace::autoclean;

sub BUILD {
    my $self = shift;

    $self->author_email('bansonlin@ms1.hncb.com.tw');
    $self->author_name('www.hncb.com.tw');
    $self->id('http://feeds.hasname.com/feed/hncb.creditcard.atom');
    $self->title('最新消息 :: 信用卡 :: 華南銀行');
    $self->url('http://www.hncb.com.tw/news/newslist_credit_1.shtml');
}

sub entries {
    my $self = shift;

    my $baseUri = URI->new($self->url);

    my $h = HTML::TreeBuilder->new_from_content($self->body);
    my $h_o = Object::Destroyer->new($h, 'delete');

    my @entries;

    foreach my $link ($h->look_down('class' => qr/content12(rd|gy)/)) {
	next unless defined $link;
	my $link_o = Object::Destroyer->new($link, 'delete');

	my $a = $link->look_down('_tag', 'a');
	next unless defined $a;
	my $a_o = Object::Destroyer->new($a, 'delete');

	my $title = $a->as_text;
	my $uri = URI->new_abs($a->attr('href'), $baseUri)->as_string;

	my $entry = Object::AutoAccessor->new;
	$entry->content('');
	$entry->id($uri);
	$entry->title($title);
	$entry->url($uri);

	push @entries, $entry;
    }

    return [@entries];
}

__PACKAGE__->meta->make_immutable;

1;
