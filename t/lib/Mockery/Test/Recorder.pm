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

sub test_call_expected_method {
    my ($self) = @_;

    my $recorder = Mockery::Recorder->new;

    $recorder->set_record;
    $recorder->call('PKG', 'METHOD');
    $recorder->set_expect;
    $recorder->call('PKG', 'METHOD');
    $recorder->finish;
}

sub test_call_unexpected_method {
    my ($self) = @_;

    my $recorder = Mockery::Recorder->new;

    $recorder->set_record;
    $recorder->call('PKG', 'METHOD');
    $recorder->set_expect;
    $self->assert_exception_thrown(sub {
        $recorder->call('PKG', 'WRONG');
    }, 'Exception::UnexpectedMethod');
}

sub test_call_missing_method {
    my ($self) = @_;

    my $recorder = Mockery::Recorder->new;

    $recorder->set_record;
    $recorder->call('PKG', 'METHOD');
    $recorder->set_expect;
    $self->assert_exception_thrown(sub {
        $recorder->finish
    }, 'Exception::ExpectedMethodMissing');
}

sub assert_exception_thrown {
    my ($self, $code, $exception) = @_;

    eval { $code->() };
    $self->assert(Exception::Class->caught($exception));
}

1;
