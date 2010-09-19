package Mockery::Expectation;

use Any::Moose;

has expectation => (is => 'ro', required => 1);

sub run {
    my ($self) = @_;
    $self->expectation->();
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;

1;
