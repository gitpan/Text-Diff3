package Text::Diff3::Range2;
# two way difference container
use 5.006;
use strict;
use warnings;
our $VERSION = '0.05';

use base qw( Text::Diff3::Base );

__PACKAGE__->mk_attr_accessor( qw( type loA hiA loB hiB ) );

sub set_type_a { $_[0]->type( 'a' ); $_[0] }
sub set_type_c { $_[0]->type( 'c' ); $_[0] }
sub set_type_d { $_[0]->type( 'd' ); $_[0] }
sub rangeA { ( $_[0]->loA .. $_[0]->hiA ) }
sub rangeB { ( $_[0]->loB .. $_[0]->hiB ) }

sub as_array {
    my $self = shift;
    @{ $self }{ qw( type loA hiA loB hiB ) };
}

sub as_string {
    my $self = shift;
    $self->_as_line_range( $self->loA, $self->hiA )
    . $self->type
    . $self->_as_line_range( $self->loB, $self->hiB );
}

sub initialize {
    my $self = shift;
    $self->SUPER::initialize( @_ );
    @{ $self }{ qw( type loA hiA loB hiB ) } = @_[1..5];
}

sub _as_line_range {
    my $self = shift;
    my( $lo, $hi ) = @_;
    $lo >= $hi ? $hi : $lo . ',' . $hi;
}

1;

__END__

=head1 NAME

Text::Diff3::Range2 - two way difference container

=head1 SYNOPSIS

  use Text::Diff3;
  my $f = Text::Diff3::Factory;
  my $range2 = $f->create_range2( 'c', 100,102, 104,110 );
  $type = $range2->type;    # 'c'
  $line_no = $range2->loA;  # 100
  $line_no = $range2->hiA;  # 102
  $line_no = $range2->loB;  # 104
  $line_no = $range2->hiB;  # 110
  print $range2->as_string, "\n"; # 100,102c104,110

=head1 AUTHOR

MIZUTANI Tociyuki E<lt>tociyuki@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
