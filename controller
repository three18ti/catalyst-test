# lib/My/Controller/Admin/User.pm

sub create :Local {
    my ($self, $c) = @_;
    
    # Just display the form if this isn't a POST request.
    return 1 if $c->req->method ne 'POST';

    # Validate fields
    my $v = My::Validate::User->new();
    
    FIELD:
    for my $field ( qw(name username email password) ) {
        next FIELD if $v->is_valid($field => $c->req->param->{$field});
        
        $c->flash(error => 'The ' . $field . ' you entered is not valid.');
    }

    if ( $c->req->params->{password} ne $c->req->params->{confirm_password} ) {
        $c->flash(error => 'The passwords you entered do not match.');
    }
    
    # If there was a form error, redirect back to the form and end this request.
    if ($c->flash->{error}) {
        # Save some form values.
        $c->flash($_ => $c->req->param->{$_}) for qw(name username email);
        
        $c->res->redirect('/admin/user/create');
        $c->detach();
    }
    
    my $user = $c->model('DB::User')->create({
        name     => $c->req->param->{name},
        username => $c->req->param->{username},
        email    => $c->req->param->{email},
        password => $c->req->param->{password},
    });
    
    $c->res->redirect('/admin/user/' . $user->id . '/read');
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

# lib/My/Validate/User.pm

package My::Validate::User;
use Moose;
use List::MoreUtils qw(all);

# Accept only ASCII inputs for regexes.  Use /u to override.
use re '/aa';

has regexes => (
    is      => 'ro',
    isa     => 'HashRef[ArrayRef]',
    lazy    => 1,
    builder => '_build_regexes',
);

sub _build_regexes {
    my ($self) = @_;

    return {
        name => [
            qr{
                \A
                [a-zA-Z -]{3,50}
                \Z
            },
        ],
        
        username => [
            qr{
                \A
                [a-z]{1}         # Username must start with a letter
                [a-z0-9-_]{2,12} # Rest of the username
                \Z
            }
        ],
        
        email => [
            qr{
                \A
                .+      # Username
                [@]     # Separator
                .+[.].+ # Domain
                \Z
            }
        ],
        
        password => [
            qr{
                \A
                [[:print:]]{6,} # Printable characters
                \Z
            }xms,
            
            qr{ [A-Z] },
            qr{ [a-z] },
            qr{ [0-9] },
            qr{ [^A-Za-z0-9] },
        ],
    };
}

sub is_valid {
    my ($self, $field, $value) = @_;
    
    die 'Invalid field ' . $field
        if !exists $self->regexes->{$field};
    
    # Get the regexes for the field.
    my @regexes = @{ $self->regexes->{$field} };
    
    # The value matches all the regexes
    my $is_valid = all { $value =~ m{$_}xms } @regexes;
    
    return $is_valid;
}

1;
