package My::Controller::Admin::User;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

My::Controller::Admin::User - Catalyst Controller for user admin

=head1 DESCRIPTION

Catalyst Controller for user admin

=head1 METHODS

=cut

=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        users => $c->model('DB')->resultset('User')->search_rs,
    );
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
