package Text::Diff3::List;
# list of difference sets
use 5.006;
use strict;
use warnings;
our $VERSION = '0.05';

use base qw( Text::Diff3::ListMixin Text::Diff3::Base );

sub list { $_[0]->{list} }

sub initialize {
    my $self = shift;
    $self->SUPER::initialize( @_ );
    shift; # drop factory
    $self->{list} = [ @_ ];
}

sub as_array {
    my $self = shift;
    map { [ $_->as_array ] } @{ $self->list };
}

1;

__END__

=head1 NAME

Text::Diff3::List - list of difference sets

=head1 SYNOPSIS

  use Text::Diff3;
  my $f = Text::Diff3::Factory->new;
  my $diff2 = $f->create_list2;
  my $diff3 = $f->create_list3;

=head1 AUTHOR

MIZUTANI Tociyuki E<lt>tociyuki@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
