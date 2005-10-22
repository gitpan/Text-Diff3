package Text::Diff3::Text;
# a line number scheme free text buffer
use 5.006;
use strict;
use warnings;
our $VERSION = '0.05';

use base qw( Text::Diff3::ListMixin Text::Diff3::Base );

sub text { $_[0]->{text} }
sub list { $_[0]->{text} } # interface to ListMixin

sub first_index { 1 }

sub last_index {
   my $self = shift;
   $#{ $self->{text} } + $self->first_index;
}

sub range {
    my $self = shift;
    ( $self->first_index .. $self->last_index );
}

sub at {
    my( $self, $x ) = @_;
    $x -= $self->first_index;
    $x < 0 ? undef : $x > $#{ $self->{text} } ? undef : $self->{text}[ $x ];
}

sub as_string_at {
    my( $self, $x ) = @_;
    my $line = $self->at( $x );
    defined( $line ) ? $line . "\n" : '';
}

sub eq_at {
    my( $self, $x, $other ) = @_;
    my $this = $self->at( $x );
    ! defined( $this ) && ! defined( $other ) and return 1;
    ! defined( $this ) && defined( $other ) and return 0;
    defined( $this ) && ! defined( $other ) and return 0;
    $this eq $other;
}

sub initialize {
    my $self = shift;
    $self->SUPER::initialize( @_ );
    my( $f, $s ) = @_;
    if ( ref( $s ) eq 'ARRAY' ) {
        $self->{text} = $s;
    } else {
        my $r = ref( $s ) ? $s : \$s;
        $self->{text} = [ split /\n/, $$r ];
    }
}

1;

__END__

=head1 NAME

Text::Diff3::Text - line number scheme free text buffer

=head1 SYNOPSIS

  use Text::Diff3;
  my $f = Text::Diff3::Factory->new;
  my $t0 = $f->create_text([ map{chomp;$_} <F0> ]); # do not dup internally.
  my $t1 = $f->create_text( $string ); # make array references.
  # follows four take same output.
  print $_, "\n" for @{ $t0->text };
  print $t0->as_string_at( $_ ) for $t0->range;
  print $t0->as_string_at( $_ ) for $t0->first_index .. $t0->last_index;
  for ( $t0->first_index .. $t0->last_index ) {
      my $line = $t0->at( $_ );
      print $line, "\n" if defined( $line );
  }
  # string compare
  if ( $t0->eq_at( $i, $string ) ) { .... }
  # get string size
  my $length = $t0->size;
  
=head1 ABSTRACT

This is a wrapper for a Perl's array reference, improving line number
scheme free and limiting fetching from last element by minus index.
Normally line number starts 1 in compatible with diff command tools.
But you can change it another value like as 0 override first index
methods.

=head1 DESCRIPTION

=head2 create

Author recommends you to create an instance of text by using with
a factory as follows.

  use SomeFactory;
  my $f = SomeFactory->new;
  my $t = $f->create_text( string or arrayref );

Text::Diff3::Factory is a class to packaging several classes
for the build-in diff processor.

When pass a string, it is split by /\n/ before store the line buffers.
When pass an array reference, it simply assigned text properties
without duplication. In the later case, the side effects will happen
if you use same reference at another place.

=head2 text

This is a property of the line buffer. It is an array reference.

=head2 list

This is same as the text property, which is an interface property
for ListMixin.

=head2 first_index

This is first-index accessible by the `at' method.

=head2 last_index

This is last-index accessible by the `at' method.

=head2 range

This returns a range between fist-index and last-index.

=head2 at

This returns a line specified by a line number.
If line number is out of range, it returns undef.

=head2 as_string_at

This is short cut for line accessing through `at'.
If line number is out of range, it returns '', in otherwise returns line."\n".

=head2 eq_at

This is short cut for comparison line and other string.

=head1 AUTHOR

MIZUTANI Tociyuki E<lt>tociyuki@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
