package Web::Atom::Bank::Scsb::Creditcard;
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

    $self->author_email('cykuo@scsb.com.tw');
    $self->author_name('www.scsb.com.tw');
    $self->title('HOT NEWS :: 信用卡 :: 上海商業儲蓄銀行');
    $self->url('http://www.scsb.com.tw/card.jsp');
}

sub entries {
    my $self = shift;

    my $baseUri = URI->new($self->url);

    my $h = HTML::TreeBuilder->new_from_content($self->body);
    my $h_o = Object::Destroyer->new($h, 'delete');

    my @entries;

    foreach my $a ($h->look_down(_tag => 'a', class => 'unnamed4')) {
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
