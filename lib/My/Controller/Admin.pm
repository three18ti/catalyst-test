package My::Controller::Admin;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

My::Controller::Admin - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash( 
        users => $c->model('DB')->resultset('User')->search_rs,
        template => 'admin.tt',
    );
}

sub add :Local {
    my ( $self, $c) = @_;

    return 1 if $c->req->method ne 'POST';

    $c->model('DB')->resultset('User')->create(
        {
            name        => $c->req->params->{'name'},
            username    => $c->req->params->{'username'},
            email       => $c->req->params->{'email'},
            password    => $c->req->params->{'password'},
        }
    );
}


=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
