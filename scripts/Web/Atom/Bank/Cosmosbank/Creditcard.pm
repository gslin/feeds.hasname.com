package Web::Atom::Bank::Cosmosbank::Creditcard;
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

    $self->author_email('sally.lu@cosmosbank.com.tw');
    $self->author_name('www.cosmosbank.com.tw');
    $self->title('優惠速報 :: 信用卡 :: 萬泰商業銀行');
    $self->url('http://card888.cosmosbank.com.tw/card-new_feature-index.htm');
}

sub entries {
    my $self = shift;

    my $baseUri = URI->new($self->url);

    my $h = HTML::TreeBuilder->new_from_content($self->body);
    my $h_o = Object::Destroyer->new($h, 'delete');

    my @entries;

    foreach my $table ($h->look_down(_tag => 'table', height => '68')) {
	next unless defined $table;
	my $table_o = Object::Destroyer->new($table, 'delete');

	my $p = $table->look_down(_tag => 'p');
	next unless defined $p;
	my $p_o = Object::Destroyer->new($p, 'delete');

	my $a = $table->look_down(_tag => 'a', target => 'new');
	next unless defined $a;
	my $a_o = Object::Destroyer->new($a, 'delete');

	my $title = $p->as_text;
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
