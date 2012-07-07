package My::Controller::Admin;
use Moose;
use namespace::autoclean;

use My::Validate::User;

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

sub create :Local {
    my ($self, $c) = @_;
    
    # Just display the form if this isn't a POST request.
    return 1 if $c->req->method ne 'POST';

    # Validate fields
    my $v = My::Validate::User->new();
    
#    FIELD:
#    for my $field ( qw(name username email password) ) {
#        next FIELD if $v->is_valid($field => $c->req->param->{$field});
#        
#        $c->flash(error => 'The ' . $field . ' you entered is not valid.');
#    }

    if ( $c->req->params->{password} ne $c->req->params->{confirm_password} ) {
        $c->flash(error => 'The passwords you entered do not match.');
    }
    
    # If there was a form error, redirect back to the form and end this request.
    if ($c->flash->{error}) {
        # Save some form values.
        $c->flash($_ => $c->req->param->{$_}) for qw(name username email);
        
        $c->res->redirect('/admin/create');
        $c->detach();
    }
    
    my $user = $c->model('DB')->resultset('User')->create({
        name     => $c->req->param->{name},
        username => $c->req->param->{username},
        email    => $c->req->param->{email},
        password => $c->req->param->{password},
    });
    
    $c->res->redirect('/admin/user/' . $user->id . '/read');
}

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
