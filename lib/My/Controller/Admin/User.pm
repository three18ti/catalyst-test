package My::Controller::Admin::User;
use Moose;
use namespace::autoclean;

use My::Validate::User;

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

sub find : Chained CaptureArgs(1) {
    my ( $self, $c, $id, ) = @_;

    my $rs = $c->moded('DB')->resultset('User');

    $c->stash->{user} = $rs->find( $id );
    
    return;

}

sub edit : Chained('find') Args(0) FormConfig {
    my ( $self, $c, $id ) = @_;

    my $form = $c->stash->{form};
    my $user = $c->stash->{user};

    if ( $form->submitted_and_valid ) {

        $form->model->update( $user );

        $c->res->redirect( $c->uri_for( "/user/$id" ) );
        return;
    }

    $form->model->default_values( $user )
        if ! $form->submitted;

}

=head2 formfu_create
    
Use HTML::FormFu to create a new user
    
=cut

sub formfu_create :Local :Args(0) :FormConfig {
    my ($self, $c) = @_;
    
    # Get the form that the :FormConfig attribute saved in the stash
    my $form = $c->stash->{form};
    
    # Check if the form has been submitted (vs. displaying the initial
    # form) and if the data passed validation.  "submitted_and_valid"
    # is shorthand for "$form->submitted && !$form->has_errors"
    if ($form->submitted_and_valid) {
        # Create a new book
        my $user = $c->model('DB::User')->new_result({});
        # Save the form data for the book
        $form->model->update($user);
        # Set a status message for the user & return to books list
        $c->response->redirect($c->uri_for($self->action_for('index'),
            {mid => $c->set_status_msg("User created")}));
        $c->detach;    
    } 
    else {
        # Get the Users from the DB
        my @user_objs = $c->model("DB::User")->all();
        
        # Create an array of arrayrefs where each arrayref is an author
        my @users;
        foreach (sort {$a->username cmp $b->username} @user_objs) {
            push @users, [$_->id, $_->username];
        }

        # Get the select added by the config file
        my $select = $form->get_element({type => 'Select'});

        # Add the authors to it
        $select->options(\@users);
    }
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
