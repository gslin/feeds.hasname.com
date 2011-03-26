#!/usr/bin/env perl

use Carp;
use Web::Atom;
use strict;
use warnings;

INIT {
    my $feed = Web::Atom->new(p => 'Bank::Megabank::Creditcard');
    $feed->id('http://feeds.hasname.com/feed/megabank.creditcard.atom');

    open FEED, '> /var/www/feeds.hasname.com/webroot/feed/megabank.creditcard.atom' or croak $!;
    print FEED $feed->as_xml;
    close FEED;
}

__END__
