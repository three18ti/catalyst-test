#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

use lib 'lib';
#use My;
use My::Model::DB;

my $schema = My::Model::DB->new;

foreach my $user ($schema->resultset('User')->all) {
    $user->update({ password => 'test123' });

    $user->check_password('test123') or warn 'Password check failed. for user ' . $user->name;
}

foreach my $user ($schema->resultset('User')->all) {
    $user->add_role('User');
}


my $user1 = $schema->resultset('User')->single({ id => 1 });

say "User1 roles: ", join(' ', map { $_->name } $user1->roles->all);

