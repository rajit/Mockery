package Mockery::Test::Expectation;

use strict;
use warnings;

use base 'Test::Unit::TestCase';
use Mockery::Expectation;

sub test_code_is_run {
    my ($self) = @_;
    my $i = 0;
    my $expectation = Mockery::Expectation->new(expectation => sub { $i++ });
    $expectation->run;
    $self->assert($i == 1, 'Code was run by expectation');
}

sub test_code_returns_correct_value {
    my ($self) = @_;
    my $i = 0;
    my $expectation = Mockery::Expectation->new(expectation => sub { $i++; 999 });
    my $result = $expectation->run;
    $self->assert($i == 1 && $result == 999, 'Code was run and result returned');
}

1;
