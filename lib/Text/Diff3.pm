package Text::Diff3;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.05';

use Text::Diff3::Factory;

1;

__END__

=head1 NAME

Text::Diff3 - compute three way differences between text.

=head1 SYNOPSYS

  use Text::Diff3;
  my $f = Text::Diff3::Factory->new;
  my $mytext   = $f->create_text([ map{chomp;$_} <F0> ]);
  my $mytext   = $f->create_text( $string );
  my $original = $f->create_text([ map{chomp;$_} <F1> ]);
  my $yourtext = $f->create_text([ map{chomp;$_} <F2> ]);
  my $p = $f->create_diff3;
  my $diff3 = $p->diff3( $mytext, $origial, $yourtext );
  $diff3->each(sub{
      my( $r ) = @_;
      print $r->as_string, "\n";
      print $mytext->as_string_at( $_ ) for $r->range0;
      print $original->as_string_at( $_ ) for $r->range2;
      print $yourtext->as_string_at( $_ ) for $r->range1;
  });

=head1 ABSTRACT

This is a Perl module to compute differnce sets between three text
buffers ported from GNU diff3.c written by Randy Smith.

=head1 DESCRIPTION

The three way diff procedure (diff3) might be required building
an application to arbitrate manipulations under concurrent works.
This diff3 code into Perl language has ported from GNU diff3.c
widely used.

=head2 create

Author recommends you to create an instanse of diff prosessor by using
with a factory as follows.

  use SomeFactory;
  my $f = SomeFactory->new;
  my $p = $f->create_diff3;

Text::Diff3::Factory is a class to packaging several classes
for the buildin diff processor.

=head2 diff3

Performing the diff3 process, we send a `diff3' message with three text
instanses to the receiver

  my $diff3 = $p->diff3( $mytest, $origial, $yourtext );

Where the parameters of text might be a kind of as follows.

=over 2

=item *

Scalar string separated by "\n".

=item *

Unblessed or blessed one dimentional array refs.

=item *

An already blessed instanse by Text::Diff3::Text or an another the
equivalent type as one (not required descendant class of one).

=back

After the process, the receiver returns the list as difference sets.

  case $range3->type
  when 0: changes occured in mytext ($text0).
  when 1: changes occured in yourtext ($text1).
  when 2: changes occured in original ($text2).
  when 'A': confict!
  end

Additionally, GNU diff3.c treats as conflict when delete same lines both
mytext and yourtext (why?).

=head1 SEE ALSO

GNU/diffutils/2.7/diff3.c

   Three way file comparison program (diff3) for Project GNU.
   Copyright (C) 1988, 1989, 1992, 1993, 1994 Free Software Foundation, Inc.
   Written by Randy Smith

P. Heckel. ``A technique for isolating differences between files.''
Communications of the ACM, Vol. 21, No. 4, page 264, April 1978.

=head1 AUTHOR

MIZUTANI Tociyuki E<lt>tociyuki@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
