#!/usr/bin/env perl

use Carp;
use Web::Atom;
use strict;
use warnings;

INIT {
    my $feed = Web::Atom->new(p => 'Bank::Firstbank::Creditcard');
    $feed->id('http://feeds.hasname.com/feed/firstbank.creditcard.atom');

    open FEED, '> /var/www/feeds.hasname.com/webroot/feed/firstbank.creditcard.atom' or croak $!;
    print FEED $feed->as_xml;
    close FEED;
}

__END__
