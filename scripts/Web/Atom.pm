package Web::Atom;
use strict;
use warnings;

use Any::Moose;
has 'feed' => (is => 'rw', isa => 'XML::Atom::Feed', lazy_build => 1);
has 'p' => (is => 'ro', isa => 'Str', required => 1);
has 'plugin' => (is => 'rw', isa => 'Web::Atom::Plugin', lazy_build => 1);

use XML::Atom::Entry;
use XML::Atom::Feed;
use XML::Atom::Link;
use XML::Atom::Person;

sub _build_feed {
    my $self = shift;

    my $plugin = $self->plugin;

    my $author = XML::Atom::Person->new;
    $author->email($plugin->author_email);
    $author->name($plugin->author_name);

    my $link = XML::Atom::Link->new;
    $link->type('text/html');
    $link->rel('alternative');
    $link->href($plugin->url);

    my $feed = XML::Atom::Feed->new;
    $feed->add_link($link);
    $feed->author($author);
    $feed->id($plugin->id);
    $feed->title($plugin->title);

    foreach my $e (@$plugin->entries) {
	my $entry = XML::Atom::Entry->new;

	if (defined $entry->author) {
	    my $entryAuthor = XML::Atom::Author->new;
	    $entryAuthor->email($e->author_email);
	    $entryAuthor->name($e->author_name);
	    $entry->author($entryAuthor);
	} else {
	    $entry->author($author);
	}

	$entry->content($e->content);

	my $link = XML::Atom::Link->new;
	$link->type('text/html');
	$link->rel('alternative');
	$link->href($e->url);
	$entry->add_link($link);

	$feed->add_entry($entry);
    }

    return $feed;
}

sub _build_plugin {
    my $self = shift;

    my $p = $self->p;
    my $pname = "Web::Atom::$p";

    require $pname;
    my $plugin;
    eval "\$plugin = $pname->new;";

    return $plugin;
}

1;
