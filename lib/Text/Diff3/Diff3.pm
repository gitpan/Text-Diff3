package Text::Diff3::Diff3;
# diff3 plugin
use 5.006;
use strict;
use warnings;
our $VERSION = '0.05';

use base qw( Text::Diff3::Base );

# the three way diff procedure based on the GNU diff3.c by Randy Smith.
sub diff3 {
    my $self = shift;
    my( $text0, $text2, $text1 ) = @_;
    my $f = $self->factory;
    $text0 = $f->create_text( $text0 ) unless $self->_type_check( $text0 );
    $text2 = $f->create_text( $text2 ) unless $self->_type_check( $text2 );
    $text1 = $f->create_text( $text1 ) unless $self->_type_check( $text1 );
    my $diffp = $f->create_diff;
    my @diff2;
    $diff2[0] = $diffp->diff( $text2, $text0 );
    $diff2[1] = $diffp->diff( $text2, $text1 );
    my $diff3 = $f->create_list3;
    my $range3 = $f->create_null_range3;
    until ( $diff2[0]->is_empty && $diff2[1]->is_empty ) {
        # find a continual range in text2 $lo2..$hi2
        # changed by text0 or by text1.
        #
        #  diff02     222    222222222
        #   text2  ...l!!!!!!!!!!!!!!!!!!!!h...
        #  diff12       222222   22  2222222
        my @range2 = ( [], [] );
        my $i = my $j = $diff2[0]->is_empty ? 1 : $diff2[1]->is_empty ? 0 :
            $diff2[0]->first->loA <= $diff2[1]->first->loA ? 0 : 1;
        my $k = $j ^ 1;
        my $hi = $diff2[ $j ]->first->hiA;
        push @{ $range2[ $j ] }, $diff2[ $j ]->shift;
        while ( ! $diff2[ $k ]->is_empty
               && $diff2[ $k ]->first->loA <= $hi + 1
        ) {
            my $hi_k = $diff2[ $k ]->first->hiA;
            push @{ $range2[ $k ] }, $diff2[ $k ]->shift;
            if ( $hi < $hi_k ) {
                $hi = $hi_k;
                $j = $k;
                $k = $j ^ 1;
            }
        }
        my $lo2 = $range2[ $i ][ 0]->loA;
        my $hi2 = $range2[ $j ][-1]->hiA;
        # take the corresponding ranges in text0 $lo0..$lo1
        # and in text1 $lo1..$hi1.
        #
        #   text0     l!!!!!!!!!!!!!!!!!!!!!!!11111h...
        #  diff02     222    222222222
        #   text2  ...00!1111!000!!00!111111...
        #  diff12       222222   22  2222222
        #   text1     l0!!!!!!!!!!!!!!!!!h...
        my( $lo0, $hi0 );
        if ( @{ $range2[0] } ) {
            $lo0 = $range2[0][ 0]->loB - $range2[0][ 0]->loA + $lo2;
            $hi0 = $range2[0][-1]->hiB - $range2[0][-1]->hiA + $hi2;
        } else {
            $lo0 = $range3->hi0 - $range3->hi2 + $lo2;
            $hi0 = $range3->hi0 - $range3->hi2 + $hi2;
        }
        my( $lo1, $hi1 );
        if ( @{ $range2[1] } ) {
            $lo1 = $range2[1][ 0]->loB - $range2[1][ 0]->loA + $lo2;
            $hi1 = $range2[1][-1]->hiB - $range2[1][-1]->hiA + $hi2;
        } else {
            $lo1 = $range3->hi1 - $range3->hi2 + $lo2;
            $hi1 = $range3->hi1 - $range3->hi2 + $hi2;
        }
        $range3 = $f->create_range3(
            undef, $lo0, $hi0, $lo1, $hi1, $lo2, $hi2 );
        # detect type of changes.
        if ( ! @{ $range2[0] } ) {
            $range3->set_type_diff1;
        } elsif ( ! @{ $range2[1] } ) {
            $range3->set_type_diff0;
        } elsif ( $hi0 - $lo0 != $hi1 - $lo1 ) {
            $range3->set_type_diffA;
        } else {
            $range3->set_type_diff2;
            for ( ; $lo0 <= $hi0; ++$lo0, ++$lo1 ) {
                unless ( $text0->eq_at( $lo0, $text1->at( $lo1 ) ) ) {
                    $range3->set_type_diffA;
                    last;
                }
            }
        }
        $diff3->push( $range3 );
    }
    $diff3;
}

sub _type_check {
    my( $self, $x ) = @_;
    UNIVERSAL::can( $x, 'at' ) && UNIVERSAL::can( $x, 'eq_at' );
}

1;

__END__

=head1 NAME

Text::Diff3::Diff3 - diff3 plugin

=head1 SYNOPSYS

  use Text::Diff3;
  my $f = Text::Diff3::Factory->new;
  my $mytext   = $f->create_text([ map{chomp;$_} <F0> ]);
  my $original = $f->create_text([ map{chomp;$_} <F1> ]);
  my $yourtext = $f->create_text([ map{chomp;$_} <F2> ]);
  my $p = $f->create_diff3;
  my $diff3 = $p->diff3( $mytext, $origial, $yourtext );

=head1 ABSTRACT

This is a plugin to compute differnce sets between three text
buffers ported from GNU diff3.c written by Randy Smith.

=head1 DESCRIPTION

Please see how to use this plugin through a factory in a Text::Diff3
document.

=head1 WORK WITH diff

diff3 processor needs to support of a two way diff plugin module.
There are two requirements for a diff plugin module.

First, it must independ upon the policy of line numbers in text buffers.
Not only line numbers may start zero normally Perl's array, but also it
start one  diff(1) command output. In this module, any line number scheme
is hidden in the capsul of text buffer class. 

Second, it must adapt line number parameters in a delete range and an
append one due to the numbers of lines treatments in diff3 processor. 
For instanse, diff plugin modifies the ranges in a same scheme of line
number started from 1 such as diff(1) command as follows.

  diff(1) to modified; # original   changed text
  1c1 to 1,1c1,1; # [ qw( a b ) ]   [ qw( A b ) ]
  0a1 to 1,0a1,1; # [ qw( a b ) ]   [ qw( A a b ) ]
  1a2 to 2,1a2,2; # [ qw( a b ) ]   [ qw( a B b ) ]
  2a3 to 3,2a3,3; # [ qw( a b ) ]   [ qw( a b C ) ]
  1d0 to 1,1d1,0; # [ qw( A b c ) ] [ qw( b c ) ]
  2d1 to 2,2d2,1; # [ qw( a B c ) ] [ qw( a c ) ]
  3d2 to 3,3d3,2; # [ qw( a b C ) ] [ qw( a b ) ]

In change case at first one, do not happen modification.
In append cases from second to 4th one, increment low line number
for the original text side.
In delete cases from 5th to 7th one, increment low line number
for the modified text side.

Their line numbers are normally droped in the diff(1) command.
So that you do their modifications simply adding success value
from the output one if you make a plugin diff(1) command invoker.

=head1 SEE ALSO

GNU/diffutils/2.7/diff3.c

   Three way file comparison program (diff3) for Project GNU.
   Copyright (C) 1988, 1989, 1992, 1993, 1994 Free Software Foundation, Inc.
   Written by Randy Smith

Text::Diff3

=head1 AUTHOR

MIZUTANI Tociyuki E<lt>tociyuki@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
