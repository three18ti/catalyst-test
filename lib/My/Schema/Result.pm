package My::Schema::Result;
use Moose;

extends 'DBIx::Class::Core';

# Handy shortcut
sub schema { shift->result_source->schema }

1;

