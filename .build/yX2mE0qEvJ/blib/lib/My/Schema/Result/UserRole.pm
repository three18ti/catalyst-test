package My::Schema::Result::UserRole;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'My::Schema::Result';

__PACKAGE__->table('user_role');

__PACKAGE__->add_columns( 
                    user_id =>
                      {
                        data_type => "integer",
                        is_foreign_key => 1,
                        is_nullable => 0
                      },
                    role_id =>
                      {
                        data_type => "integer",
                        is_foreign_key => 1,
                        is_nullable => 0
                      },
);

__PACKAGE__->set_primary_key("user_id", "role_id");

__PACKAGE__->belongs_to( user => 'My::Schema::Result::User', 'user_id' );
__PACKAGE__->belongs_to( role => 'My::Schema::Result::Role', 'role_id' );

__PACKAGE__->meta->make_immutable;
1;

