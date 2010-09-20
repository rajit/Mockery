package Mockery::Test::Basic;

use strict;
use warnings;

use base qw(Test::Unit::TestCase);
use Mockery;

sub set_up {
    my ($self) = @_;
    $self->{obj_name} = 'Testing::Object';
    $self->{mock} = Mockery->create($self->{obj_name});
}

sub tear_down {
    my ($self) = @_;
}

sub test_constructor {
    my ($self) = @_;
    $self->assert($self->{mock}->isa($self->{obj_name}), 'Mockery->create produces a mocked object of the correct isa');
    $self->assert(ref($self->{mock}) eq $self->{obj_name}, 'Mockery->create produces mocked object of the correct ref');
}

sub test_expect {
    my ($self) = @_;
    my $test = MyTest->new($self->{mock});
    mock {
        $test->test;
    } expect {
        $self->{mock}->mock;
    };
}

sub test_expect_not_called {
    my ($self) = @_;
    my $test = MyTest->new($self->{mock});
    $self->assert_exception_thrown(
        sub { mock {
            # no op
        } expect {
            $self->{mock}->mock;
        } }, 'Exception::ExpectedMethodMissing'
    );
}

sub test_expect_in_order {
    my ($self) = @_;
    my $test = MyTest->new($self->{mock});
    mock {
        $test->in_order;
    } expect {
        $self->{mock}->one;
        $self->{mock}->two;
    };
}

sub test_expect_exception_for_out_of_order {
    my ($self) = @_;
    my $test = MyTest->new($self->{mock});
    $self->assert_exception_thrown(
        sub { mock {
            $test->in_order;
        } expect {
            $self->{mock}->two;
            $self->{mock}->one;
        } }, 'Exception::UnexpectedMethod'
    );
}

sub test_expect_many_calls_in_order {
    my ($self) = @_;
    my $test = MyTest->new($self->{mock});
    mock {
        $test->many_calls;
    } expect {
        $self->{mock}->one;
        $self->{mock}->two;
        $self->{mock}->two;
        $self->{mock}->one;
        $self->{mock}->two;
        $self->{mock}->one;
    };
}

sub test_expect_many_calls_out_of_order {
    my ($self) = @_;
    my $test = MyTest->new($self->{mock});
    $self->assert_exception_thrown(
        sub { mock {
            $test->many_calls;
        } expect {
            $self->{mock}->one;
            $self->{mock}->two;
            $self->{mock}->two;
            $self->{mock}->one;
            $self->{mock}->one;
            $self->{mock}->two;
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
