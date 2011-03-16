package Web::Atom::Bank::Cathaybk::Creditcard;
use strict;
use warnings;

use Any::Moose;
extends 'Web::Atom::Plugin';

use Encode;
use HTML::TreeBuilder;
use LWP::UserAgent;
use Object::Destroyer;
use URI;
use Web::Atom::Util;
use namespace::autoclean;

sub BUILD {
    my $self = shift;

    $self->author_email('cathaybk_domain@cathaybk.com.tw');
    $self->author_name('www.cathaybk.com.tw');
    $self->id('http://feeds.hasname.com/feed/cathaybk.creditcard.atom');
    $self->title('最新消息 :: 信用卡服務 :: 國泰世華銀行');
    $self->url('https://www.cathaybk.com.tw/cathaybk/news_card.asp');
}

sub entries {
    my $self = shift;

    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts(verify_hostname => 0);

    my $res = $ua->get($self->url);
    my $body = Encode::encode('utf-8', $res->decoded_content);

    my $baseUri = URI->new($self->url);

    my $h = HTML::TreeBuilder->new_from_content($body);
    my $h_o = Object::Destroyer->new($h, 'delete');

    my @entries;

    foreach my $link ($h->look_down('_tag' => 'td', 'class' => 'links')) {
	next unless defined $link;
	my $link_o = Object::Destroyer->new($link, 'delete');

	my $a = $link->look_down('_tag', 'a');
	next unless defined $a;
	my $a_o = Object::Destroyer->new($a, 'delete');

	my $uri = URI->new_abs($a->attr('href'), $baseUri);

	my $entry = Web::Atom::Util::inline_object(content => sub {''}, url => sub {$uri->as_string});
	push @entries, $entry;
    }

    return [@entries];
}

__PACKAGE__->meta->make_immutable;

1;
