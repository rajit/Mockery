package Mockery::Test::Recorder;

use strict;
use warnings;

use base qw(Test::Unit::TestCase);
use Mockery::Recorder;

sub set_up {
    my ($self) = @_;
}

sub tear_down {
    my ($self) = @_;
}

sub test_constructor {
    my ($self) = @_;

    my $recorder = Mockery::Recorder->new;
    $self->assert($recorder->isa('Mockery::Recorder'));
}

1;
