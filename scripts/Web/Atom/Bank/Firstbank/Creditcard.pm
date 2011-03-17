package Web::Atom::Bank::Firstbank::Creditcard;
use strict;
use warnings;

use Any::Moose;
extends 'Web::Atom::Plugin';

use HTML::TreeBuilder;
use Object::AutoAccessor;
use Object::Destroyer;
use URI;
use namespace::autoclean;

sub BUILD {
    my $self = shift;

    $self->author_email('fcb@mail.firstbank.com.tw');
    $self->author_name('www.firstbank.com.tw');
    $self->title('最新訊息 :: 信用卡專區 :: 第一銀行');
    $self->url('http://www.firstcard.com.tw/newentry/morenews_cf.asp');
    $self->url_encoding('big5');
}

sub entries {
    my $self = shift;

    my $baseUri = URI->new($self->url);

    my $h = HTML::TreeBuilder->new_from_content($self->body);
    my $h_o = Object::Destroyer->new($h, 'delete');

    my @entries;

    foreach my $a ($h->look_down(_tag => 'a', href => qr/^http/)) {
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
