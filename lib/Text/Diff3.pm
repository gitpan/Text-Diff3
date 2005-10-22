package Text::Diff3;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.06';

use Text::Diff3::Factory;

1;

__END__

=head1 NAME

Text::Diff3 - compute three-way differences between texts.

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

This is a Perl module to compute difference sets between three texts
ported from GNU diff3.c written by Randy Smith.

=head1 DESCRIPTION

To build some applications to arbitrate manipulations under concurrent
works, it is necessary to compare three texts line by line. This diff3
code into Perl language has ported from GNU diff3.c widely used.

=head2 create

Author recommends you to create an instance of diff processor
by using with a factory as follows.

  use SomeFactory;
  my $f = SomeFactory->new;
  my $p = $f->create_diff3;

Text::Diff3::Factory is a class to packaging several classes
for the build-in diff processor.

=head2 diff3

Performing the diff3 process, we send a `diff3' message with three
text instances to the receiver, 

  my $diff3 = $p->diff3( $mytest, $origial, $yourtext );

where the parameters of text might be a kind have as follows.

=over 2

=item *

Scalar string separated by "\n".

=item *

Unblessed or blessed one-dimensional array references,
or scalar string separated by "\n".

=item *

An already blessed instance by Text::Diff3::Text
or an equivalent type as one.

=back

After the process, the receiver returns the list as difference sets.

  case $range3->type
  when 0: changes occured in my text ($text0).
  when 1: changes occured in your text ($text1).
  when 2: changes occured in original ($text2).
  when 'A': confict!
  end

Additionally, GNU diff3.c treats as conflict when delete lines both
my text and your text.

=head1 SEE ALSO

GNU/diffutils/2.8/diff3.c written by Randy Smith

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
