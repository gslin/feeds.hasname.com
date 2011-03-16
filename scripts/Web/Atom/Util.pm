package Web::Atom::Util;
use strict;
use warnings;

# Copy from Plack::Util

sub inline_object {
    my %args = @_;
    bless {%args}, 'Web::Atom::Util::Prototype';
}

package Web::Atom::Util::Prototype;

our $AUTOLOAD;
sub can {
    $_[0]->{$_[1]};
}

sub AUTOLOAD {
    my $self = shift;
    my $attr = $AUTOLOAD;
    $attr =~ s/.*://;
    if (ref($self->{$attr}) eq 'CODE') {
        $self->{$attr}->(@_);
    } else {
        Carp::croak(qq/Can't locate object method "$attr" via package "Web::Atom::Util::Prototype"/);
    }
}

sub DESTROY { }

package Web::Atom::Util;

1;
