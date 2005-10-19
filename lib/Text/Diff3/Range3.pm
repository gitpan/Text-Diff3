package Text::Diff3::Range3;
# three way difference container
use 5.006;
use strict;
use warnings;
our $VERSION = '0.05';

use base qw( Text::Diff3::Base );

__PACKAGE__->mk_attr_accessor( qw( type lo0 hi0 lo1 hi1 lo2 hi2 ) );

sub as_array {
    my $self = shift;
    @{ $self }{ qw( type lo0 hi0 lo1 hi1 lo2 hi2 ) };
}

sub as_string {
    my $self = shift;
    sprintf "%s %d,%d %d,%d %d,%d",
        @{ $self }{ qw( type lo0 hi0 lo1 hi1 lo2 hi2 ) };
}

sub set_type_diff0 { $_[0]->type( 0 ); $_[0] }
sub set_type_diff1 { $_[0]->type( 1 ); $_[0] }
sub set_type_diff2 { $_[0]->type( 2 ); $_[0] }
sub set_type_diffA { $_[0]->type( 'A' ); $_[0] }
sub range0 { ( $_[0]->lo0 .. $_[0]->hi0 ) }
sub range1 { ( $_[0]->lo1 .. $_[0]->hi1 ) }
sub range2 { ( $_[0]->lo2 .. $_[0]->hi2 ) }

sub initialize {
    my $self = shift;
    $self->SUPER::initialize( @_ );
    @{ $self }{ qw( type lo0 hi0 lo1 hi1 lo2 hi2 ) } = @_[1..7];
}

1;

__END__

=head1 NAME

Text::Diff3::Range3 - three way difference container

=head1 SYNOPSIS

  use Text::Diff3;
  my $f = Text::Diff3::Factory;
  my $range3 = $f->create_range3( 1, 2,3, 4,5, 6,7 );
  $type = $range3->type;    # 1
  $line_no = $range3->lo0;  # 2
  $line_no = $range3->hi0;  # 3
  $line_no = $range3->lo1;  # 4
  $line_no = $range3->hi1;  # 5
  $line_no = $range3->lo2;  # 6
  $line_no = $range3->hi2;  # 7
  print $range3->as_string, "\n"; # 1 2,3 4,5 6,7

=head1 AUTHOR

MIZUTANI Tociyuki E<lt>tociyuki@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
