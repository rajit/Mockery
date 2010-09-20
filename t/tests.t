#!/usr/bin/perl

use warnings;
use strict;

use Test::Unit::HarnessUnit;

use lib qw(t/lib);

my $r = Test::Unit::HarnessUnit->new;
$r->start('Mockery::Test::Suite');
