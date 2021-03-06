package Web::Atom;
use strict;
use warnings;

use Any::Moose;
has 'feed' => (is => 'rw', isa => 'XML::Atom::Feed', lazy_build => 1, handles => {as_xml => 'as_xml', id => 'id'});
has 'p' => (is => 'ro', isa => 'Str', required => 1);
has 'plugin' => (is => 'rw', isa => 'Web::Atom::Plugin', lazy_build => 1);

use XML::Atom::Entry;
use XML::Atom::Feed;
use XML::Atom::Link;
use XML::Atom::Person;

sub _build_feed {
    my $self = shift;

    my $plugin = $self->plugin;

    my $author = XML::Atom::Person->new(Version => 1.0);
    $author->email($plugin->author_email);
    $author->name($plugin->author_name);

    my $link = XML::Atom::Link->new(Version => 1.0);
    $link->type('text/html');
    $link->rel('alternate');
    $link->href($plugin->url);

    my $feed = XML::Atom::Feed->new(Version => 1.0);
    $feed->add_link($link);
    $feed->author($author);
    $feed->title($plugin->title);

    foreach my $e (@{$plugin->entries}) {
	my $entry = XML::Atom::Entry->new(Version => 1.0);

	if (defined $entry->author) {
	    my $entryAuthor = XML::Atom::Author->new(Version => 1.0);
	    $entryAuthor->email($e->author_email);
	    $entryAuthor->name($e->author_name);
	    $entry->author($entryAuthor);
	} else {
	    $entry->author($author);
	}

	$entry->id($e->id);
	$entry->content($e->content);
	$entry->title($e->title);

	my $link = XML::Atom::Link->new(Version => 1.0);
	$link->type('text/html');
	$link->rel('alternate');
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

    eval "require $pname;";
    $pname->new;
}

1;
