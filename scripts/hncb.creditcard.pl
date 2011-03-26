#!/usr/bin/env perl

use Carp;
use Web::Atom;
use strict;
use warnings;

INIT {
    my $feed = Web::Atom->new(p => 'Bank::Hncb::Creditcard');
    $feed->id('http://feeds.hasname.com/feed/hncb.creditcard.atom');

    open FEED, '> /var/www/feeds.hasname.com/webroot/feed/hncb.creditcard.atom' or croak $!;
    print FEED $feed->as_xml;
    close FEED;
}

__END__
