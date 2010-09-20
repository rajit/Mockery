package Mockery::Test::Suite;

use strict;
use warnings;

use base qw(Test::Unit::TestSuite);

sub name { 'Mockery test suite' };
sub include_tests { qw/
    Mockery::Test::Basic
    Mockery::Test::Object
    Mockery::Test::Recorder/ };

1;
