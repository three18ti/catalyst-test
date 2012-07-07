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
