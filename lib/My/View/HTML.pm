package My::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION  => '.tt',
    render_die          => 1,

    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER               => 0,
    # This is your wrapper template located in the 'root/src'
    WRAPPER             => 'wrapper.tt',
);

=head1 NAME

My::View::HTML - TT View for My

=head1 DESCRIPTION

TT View for My.

=head1 SEE ALSO

L<My>

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
