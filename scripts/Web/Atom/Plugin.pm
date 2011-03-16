package Web::Atom::Plugin;
use strict;
use warnings;

use Any::Moose;
has 'author_email' => (is => 'rw', isa => 'Str', default => 'example@example.com');
has 'author_name' => (is => 'rw', isa => 'Str', default => 'John Doe');
has 'body' => (is => 'rw', isa => 'Str', lazy_build => 1);
has 'id' => (is => 'rw', isa => 'Str');
has 'title' => (is => 'rw', isa => 'Str', default => 'Default title');
has 'url' => (is => 'rw', isa => 'Str');

use Carp;
use Encode;
use LWP::UserAgent;
use namespace::autoclean;

sub _build_body {
    my $self = shift;

    my $ua = LWP::UserAgent->new;
    $ua->ssl_opts(verify_hostname => 0);

    my $res = $ua->get($self->url);
    Encode::encode('utf-8', $res->decoded_content);
}

sub entries {
    croak 'Not implemented';
}

__PACKAGE__->meta->make_immutable;

1;
