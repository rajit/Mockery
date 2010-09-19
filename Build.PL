use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name => 'Mockery',
    license => 'perl',
    dist_author => [ 'Rajit B Singh <rajit.b.singh@gmail.com>' ],
    dist_version_from => 'lib/Mockery.pm',
    requires => {
        perl => '5.8.8',
        'Any::Moose' => 0,
    },
    build_requires => {
        'Test::Unit' => 0,
    },
);

$builder->create_build_script;
