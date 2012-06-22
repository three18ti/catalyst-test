package My::Schema::Result::Profile;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
use List::MoreUtils qw(any none);
extends 'My::Schema::Result';

__PACKAGE__->table('profile'); 

__PACKAGE__->add_columns(
                    user_id =>
                      {
                        data_type => "integer",
                        is_foreign_key => 1,
                        is_nullable => 0,
                      },
                    f_name =>
                      {
                        data_type => 'varchar',
                        size        => '50',
                        is_nullable => 1,
                      },
                    l_name =>
                      {
                        data_type => 'varchar',
                        size        => '50',
                        is_nullable => 1,
                      },
);

__PACKAGE__->set_primary_key('user_id');


