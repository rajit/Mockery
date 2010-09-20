package Mockery::Test::Basic;

use strict;
use warnings;

use base qw(Test::Unit::TestCase);
use Mockery;

sub set_up {
    my ($self) = @_;
}

sub tear_down {
    my ($self) = @_;
}

sub test_constructor {
    my ($self) = @_;
    my $mock = Mockery->create('Testing::Object');
    $self->assert($mock->isa('Testing::Object'), 'Mockery->create produces a mocked object of the correct isa');
    $self->assert(ref($mock) eq 'Testing::Object', 'Mockery->create produces mocked object of the correct ref');
}

sub test_expect {
    my ($self) = @_;
    my $mock = Mockery->create('Testing::Object');
    my $test = MyTest->new($mock);
    mock {
        $test->test;
    } expect {
        $mock->mock;
    };
}

sub test_expect_not_called {
    my ($self) = @_;
    my $mock = Mockery->create('Testing::Object');
    my $test = MyTest->new($mock);
    $self->assert_exception_thrown(
        sub { mock {
            # no op
        } expect {
            $mock->mock;
        } }, 'Exception::ExpectedMethodMissing'
    );
}

sub test_expect_in_order {
    my ($self) = @_;
    my $mock = Mockery->create('Testing::Object');
    my $test = MyTest->new($mock);
    mock {
        $test->in_order;
    } expect {
        $mock->one;
        $mock->two;
    };
}

sub test_expect_exception_for_out_of_order {
    my ($self) = @_;
    my $mock = Mockery->create('Testing::Object');
    my $test = MyTest->new($mock);
    $self->assert_exception_thrown(
        sub { mock {
            $test->in_order;
        } expect {
            $mock->two;
            $mock->one;
        } }, 'Exception::UnexpectedMethod'
    );
}

sub test_expect_many_calls_in_order {
    my ($self) = @_;
    my $mock = Mockery->create('Testing::Object');
    my $test = MyTest->new($mock);
    mock {
        $test->many_calls;
    } expect {
        $mock->one;
        $mock->two;
        $mock->two;
        $mock->one;
        $mock->two;
        $mock->one;
    };
}

sub test_expect_many_calls_out_of_order {
    my ($self) = @_;
    my $mock = Mockery->create('Testing::Object');
    my $test = MyTest->new($mock);
    $self->assert_exception_thrown(
        sub { mock {
            $test->many_calls;
        } expect {
            $mock->one;
            $mock->two;
            $mock->two;
            $mock->one;
            $mock->one;
            $mock->two;
        } }, 'Exception::UnexpectedMethod'
    );
}

sub assert_exception_thrown {
    my ($self, $code, $exception) = @_;

    eval { $code->() };
    $self->assert(Exception::Class->caught($exception));
}

package MyTest;

sub new {
    my ($class, $arg) = @_;
    my $self = {arg => $arg};
    bless $self, $class;
    return $self;
}

sub test {
    my ($self) = @_;
    $self->{arg}->mock;
}

sub in_order {
    my ($self) = @_;
    $self->{arg}->one;
    $self->{arg}->two;
}

sub many_calls {
    my ($self) = @_;
    $self->{arg}->one;
    $self->{arg}->two;
    $self->{arg}->two;
    $self->{arg}->one;
    $self->{arg}->two;
    $self->{arg}->one;
}

1;
