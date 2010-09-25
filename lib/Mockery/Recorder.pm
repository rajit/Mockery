package Mockery::Recorder;

use Any::Moose;
use Exception::Class qw(
    Exception::UnknownState
    Exception::ExpectedMethodMissing
    Exception::UnexpectedMethod);

has expectations => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
);

has state => (
    is => 'rw',
    isa => 'Str',
    default => 'record',
);

my $SINGLETON;

sub reset {
    my ($self) = @_;
    @{$self->expectations} = ();
}

sub singleton {
    my ($class) = @_;
    $SINGLETON = $class->new
        unless $SINGLETON;
    return $SINGLETON;
}

sub call {
    my $self = shift;

    if($self->state eq 'record') {
        return $self->record(@_);
    } elsif($self->state eq 'expect') {
        return $self->expect(@_);
    } else {
        Exception::UnknownState->throw(
            error => 'Unknown state: '.$self->state);
    }
}

sub record {
    my ($self, $package, $method) = @_;
    push @{$self->expectations}, {
        'package' => $package,
        method => $method,
    };
}

sub expect {
    my ($self, $package, $method) = @_;
    my $expectation = shift @{$self->expectations}
        or Exception::UnexpectedMethod->throw(error => "Unexpected method called: $package->$method");
    Exception::UnexpectedMethod->throw(error => "Unexpected method called: $package->$method\n")
        unless $expectation->{package} eq $package and $expectation->{method} eq $method;
}

sub finish {
    my ($self) = @_;

    if(my ($expectation) = @{$self->expectations}) {
        Exception::ExpectedMethodMissing->throw(
            error => "Expected method not called: $expectation->{package}\->$expectation->{method}\n");
    }
}

sub set_record {
    my ($self) = @_;
    $self->state('record');
}

sub set_expect {
    my ($self) = @_;
    $self->state('expect');
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;

1;
