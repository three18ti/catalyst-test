use strict;
use warnings;

use My;

my $app = My->apply_default_middlewares(My->psgi_app);
$app;

