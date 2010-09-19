package Mockery::Test::Object;

use strict;
use warnings;

use base qw(Test::Unit::TestCase);
use Mockery::Object;

sub set_up {
    my ($self) = @_;

    $self->{obj_name} = 'A::Test::Object';
    $self->{mock} = Mockery::Object->___create___($self->{obj_name}, Recorder->new);
}

sub tear_down {
    my ($self) = @_;
}

sub test_constructor {
    my ($self) = @_;
    $self->assert($self->{mock}->isa($self->{obj_name}), 'Mockery::Object->___create___ returns object of correct isa');
    $self->assert(ref($self->{mock}) eq $self->{obj_name}, 'Mockery::Object->___create___ returns object of correct ref');
}

sub test_any_method_can_be_called {
    my ($self) = @_;

    $self->{mock}->something;
    $self->{mock}->something_else;
    $self->{mock}->blah;
    $self->{mock}->crazy_method;
}

sub test_recorder_is_called {
    my ($self) = @_;

    $self->{mock}->blahblahblah;
    my ($called) = @{$self->{mock}->___recorder___->calls};
    $self->assert($called->[0] eq $self->{obj_name});
    $self->assert($called->[1] eq 'blahblahblah');
}

package Recorder;

use Any::Moose;

extends 'Mockery::Recorder';

has calls => (is => 'rw', isa => 'ArrayRef', default => sub { [] });

sub call {
    my $self = shift;
    push @{$self->calls}, \@_;
}

1;
