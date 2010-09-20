package Mockery::Object;

use Any::Moose;
use Class::MOP;

has ___recorder___ => (
    required => 1,
    is => 'rw',
    isa => 'Mockery::Recorder',
);

has ___package___ => (
    required => 1,
    is => 'ro',
    isa => 'Str',
);

our $AUTOLOAD;

sub AUTOLOAD {
    my $self = shift;
    my $sub = $AUTOLOAD;
    $sub =~ s/^.*:://;
    $self->___recorder___->call($self->___package___, $sub);
}

sub ___create___ {
    my ($class, $to_create, $recorder) = @_;

    Class::MOP::Class->create(
        $to_create => (superclasses => [$class]));
    return $to_create->new(
        ___recorder___ => $recorder,
        ___package___ => $to_create,
    );
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;

1;
