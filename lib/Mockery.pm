package Mockery;

=head1 NAME

Mockery - A mock framework for OO testing.

=head1 SYNOPSIS

  use Mockery;

  my $date = Mockery->create('DateTime');
  my $to_test = ObjectToTest->new($date);

  # Throws an exception if ->time isn't called
  mock {
      $to_test->method_to_test;
  } expect {
      $date->time;
  };

=cut

our $VERSION = '0.1';

use Any::Moose;
use Mockery::Object;
use Mockery::Recorder;
use Mockery::Expectation;
use base qw(Exporter);
our @EXPORT = qw(mock expect);

sub create {
    my ($class, $to_mock) = @_;

    return Mockery::Object->___create___(
        $to_mock,
        Mockery::Recorder->singleton
    );
}

sub mock (&@) {
    my ($block, @expectations) = @_;

    Mockery::Recorder->singleton->reset;
    Mockery::Recorder->singleton->set_record;

    $_->run for @expectations;

    Mockery::Recorder->singleton->set_expect;

    $block->();

    Mockery::Recorder->singleton->finish;
}

sub expect (&) {
    my ($block) = @_;

    return Mockery::Expectation->new(
        expectation => $block
    );
}

no Any::Moose;
__PACKAGE__->meta->make_immutable;

1;
