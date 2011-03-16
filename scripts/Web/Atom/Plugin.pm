package Web::Atom::Plugin;
use strict;
use warnings;

use Any::Moose;
has 'author_email' => (is => 'rw', isa => 'Str', default => 'example@example.com');
has 'author_name' => (is => 'rw', isa => 'Str', default => 'John Doe');
has 'id' => (is => 'rw', isa => 'Str');
has 'title' => (is => 'rw', isa => 'Str', default => 'Default title');
has 'url' => (is => 'rw', isa => 'Str');

use Carp;

sub entries {
    croak 'Not implemented';
}

1;
