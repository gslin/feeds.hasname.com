#!/usr/bin/env perl

use Carp;
use Web::Atom;
use strict;
use warnings;

main();

sub main {
    my $feed = Web::Atom->new(p => 'Bank::Scsb::Creditcard');
    $feed->id('http://feeds.hasname.com/feed/scsb.creditcard.atom');

    open FEED, '> /var/www/feeds.hasname.com/webroot/feed/scsb.creditcard.atom' or croak $!;
    print FEED $feed->as_xml;
    close FEED;
}

__END__
