package Text::Diff3::Factory;
# Factory for packages
use 5.006;
use strict;
use warnings;
our $VERSION = '0.07';

use Text::Diff3::Diff3;
use Text::Diff3::DiffHeckel;
use Text::Diff3::Text;
use Text::Diff3::Range2;
use Text::Diff3::Range3;
use Text::Diff3::List;

sub create_test { Text::Diff3::Base->new(@_) }
# for user
sub new { $_[0] }
sub create_text { Text::Diff3::Text->new(@_) }
sub create_diff3 { Text::Diff3::Diff3->new(@_) }
sub create_diff { Text::Diff3::DiffHeckel->new(@_) }

# for internally
sub create_list3 { Text::Diff3::List->new(@_) }
# Text::Diff3::Range3 included in Text::Diff3::Range3List
sub create_range3 { Text::Diff3::Range3->new(@_) }
sub create_null_range3 {
    Text::Diff3::Range3->new($_[0], undef, 0,0, 0,0, 0,0)
}
sub create_list2 { Text::Diff3::List->new(@_) }
# Text::Diff3::Range2 included in Text::Diff3::Range2List
sub create_range2 { Text::Diff3::Range2->new(@_) }

1;

__END__

=head1 NAME

Text::Diff3::Factory - Factory for packages.

=head1 SYNOPSIS

  use Text::Diff3;
  my $f = Text::Diff3::Factory->new;
  my $p = $f->create_diff3;
  my $mytext = $f->create_text([ map{chomp;$_} <F0> ]);

=head1 ABSTRACT

This is the factory for the Text::Diff3 module. It provides you
to make data and processing instances, such as text, diff3,
and diff. If you need to use some data or processor class, you
replace this as your like.

=head1 DESCRIPTION

=head2 new

Return a factory instance. In current, the factory does not create
instance but returns class of it.

=head2 create_text

Create a text buffer object from parameters.

=head2 create_diff3

Create a diff3 processor.

=head2 create_diff

Create a two-way diff processor.

=head2 create_list3

Create a diff3 sets instance (internally used).

=head2 create_range3

Create a diff3 range container (internally used).

=head2 create_null_range

Create a diff3 range container but it has null values (internally used).

=head2 create_list2

Create a diff sets instance (internally used).

=head2 create_range2

Create a two-way diff range container (internally used).

=head1 AUTHOR

MIZUTANI Tociyuki C<< <tociyuki@gmail.com> >>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
