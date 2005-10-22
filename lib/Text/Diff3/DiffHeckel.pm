package Text::Diff3::DiffHeckel;
# two-way diff plug-in
use 5.006;
use strict;
use warnings;
our $VERSION = '0.05';

use base qw( Text::Diff3::Base );

sub diff {
    my $self = shift;
    my( $A, $B ) = @_;
    my $f = $self->factory;
    $A = $f->create_text( $A ) unless $self->_type_check( $A );
    $B = $f->create_text( $B ) unless $self->_type_check( $B );
    my $diff = $f->create_list2;
    my @Auniq = (
        [ $A->first_index - 1, $B->first_index - 1 ],
        [ $A->last_index  + 1, $B->last_index  + 1 ]
    );
    my( %Freq, %Ap, %Bp, $s, $x );
    for $x ( $A->range ) {
        $s = $A->at( $x ); $Freq{ $s } += 2; $Ap{ $s } = $x;
    }
    for $x ( $B->range ) {
        $s = $B->at( $x ); $Freq{ $s } += 3; $Bp{ $s } = $x;
    }
    while ( ( $s, $x ) = each %Freq ) {
        push @Auniq, [ $Ap{ $s }, $Bp{ $s } ] if $x == 5;
    }
    @Auniq = sort { $$a[0] <=> $$b[0] } @Auniq;
    my( $AL, $BL ) = ( $A->last_index,  $B->last_index );
    my( $ax, $bx ) = ( $A->first_index, $B->first_index );
    my( $an, $bn ) = ( $ax - 1, $bx - 1 );
    while ( $ax <= $AL && $bx <= $BL && $A->eq_at( $ax, $B->at( $bx )) ) {
        $ax++; $bx++;
    }
    my( $loA, $loB ) = ( $ax, $bx );
    for ( @Auniq ) {
        ( $an, $bn ) = @$_;
        next if $an < $loA || $bn < $loB;
        ( $ax, $bx ) = ( $an - 1, $bn - 1 );
        while ( $ax >= $loA && $bx >= $loB && $A->eq_at( $ax, $B->at( $bx )) ) {
            $ax--; $bx--;
        }
        if ( $ax >= $loA && $bx >= $loB ) {
            $diff->push( $f->create_range2( 'c', $loA, $ax, $loB, $bx ) );
        } elsif ( $ax >= $loA ) {
            $diff->push( $f->create_range2( 'd', $loA, $ax, $loB, $loB-1 ) );
        } elsif ( $bx >= $loB ) {
            $diff->push( $f->create_range2( 'a', $loA, $loA-1, $loB, $bx ) );
        }
        ( $ax, $bx ) = ( $an + 1, $bn + 1 );
        while ( $ax <= $AL && $bx <= $BL && $A->eq_at( $ax, $B->at( $bx )) ) {
            $ax++; $bx++;
        }
        ( $loA, $loB ) = ( $ax, $bx );
    }
    $diff;
}

sub _type_check {
    my( $self, $x ) = @_;
       UNIVERSAL::can( $x, 'first_index' )
    && UNIVERSAL::can( $x, 'last_index' )
    && UNIVERSAL::can( $x, 'range' )
    && UNIVERSAL::can( $x, 'at' )
    && UNIVERSAL::can( $x, 'eq_at' );
}

1;

__END__

=head1 NAME

Text::Diff3::DiffHeckel - two-way diff plug-in

=head1 SYNOPSIS

  use Text::Diff3;
  my $f = Text::Diff3::Factory->new;
  my $p = $f->create_diff;
  my $mytext   = $f->create_text([ map{chomp;$_} <F0> ]);
  my $original = $f->create_text([ map{chomp;$_} <F1> ]);
  my $diff2 = $p->diff( $origial, $mytext );
  $diff2->each(sub{
      my( $r ) = @_;
      print $r->as_string, "\n";
      if ( $r->type ne 'd' ) {
          print '-', $original->as_string_at( $_ ) for $r->rangeB;
      }
      if ( $r->type ne 'a' ) {
          print '+', $mytext->as_string_at( $_ ) for $r->rangeA;
      }
  });

=head1 ABSTRACT

This is a package for Text::Diff3 to compute difference sets between
two text buffers based on the P. Heckel's algorithm.
Anyone may change this to an another diff or a its wrapper module
by a your custom Factory instance.

=head1 DESCRIPTION

Text::Diff3 needs a support of computing difference sets between
two text buffers (diff). As the diff(1) command, the required diff
module creates a list of tipples recorded an information set of a
change type (such as a, c, or d) and a range of line numbers
between two text buffers.

Since there are several algorithms and their implementations for
the diff computation, Text::Diff3 makes a plan independent on any
specific diff routine. It calls a pluggable diff processor instance
specified in a factory commonly used in Text::Diff3. Anyone may
change diff plug-in according to text properties.

For users convenience, Text::Diff3 includes small diff based on the
P. Heckel's algorithm. On the other hands, many other systems use
the popular Least Common Sequence (LCS) algorithm. The merits for
each algorithm are case by case. In author's experience, two algorithms
generate almost same results for small local changes in the text.
In some cases, such as moving blocks of lines, it happened quite
differences in results.


=head2 create

Author recommends you to create an instance of diff processor
by using with a factory as follows.

  use SomeFactory;
  my $f = SomeFactory->new;
  my $p = $f->create_diff;

Text::Diff3::Factory is a class to packaging several classes
for the building diff processor.

=head2 diff

Performing the diff process, we send a `diff' message with two
text instances to the receiver,

  my $diff2 = $p->diff( $origial, $mytext );

where the parameters of text are a kind as follows.

=over 2

=item *

Scalar string separated by "\n".

=item *

References of a one-dimensional array.

=item *

An already blessed instance by Text::Diff3::Text or an equivalent
type as one.

=back

After the process, the receiver returns the list as difference sets.

=head1 SEE ALSO

P. Heckel. ``A technique for isolating differences between files.''
Communications of the ACM, Vol. 21, No. 4, page 264, April 1978.

Text::Diff3::Diff3

=head1 AUTHOR

MIZUTANI Tociyuki E<lt>tociyuki@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
