package Text::Diff3::Range3;
# three-way difference container
use 5.006;
use strict;
use warnings;
our $VERSION = '0.07';

use base qw(Text::Diff3::Base);

__PACKAGE__->mk_attr_accessor(qw(type lo0 hi0 lo1 hi1 lo2 hi2));

sub as_array {
    my($self) = @_;
    return @{$self}{qw(type lo0 hi0 lo1 hi1 lo2 hi2)};
}

sub as_string {
    my($self) = @_;
    return sprintf "%s %d,%d %d,%d %d,%d",
        @{$self}{qw( type lo0 hi0 lo1 hi1 lo2 hi2 )};
}

sub set_type_diff0 { shift->set_type('0') }
sub set_type_diff1 { shift->set_type('1') }
sub set_type_diff2 { shift->set_type('2') }
sub set_type_diffA { shift->set_type('A') }
sub range0 { return ($_[0]->lo0 .. $_[0]->hi0) }
sub range1 { return ($_[0]->lo1 .. $_[0]->hi1) }
sub range2 { return ($_[0]->lo2 .. $_[0]->hi2) }

sub set_type {
    my($self, $x) = @_;
    $self->{type} = $x;
    return $self;
}

sub initialize {
    my($self, @arg) = @_;
    $self->SUPER::initialize(@arg);
    @{$self}{qw(type lo0 hi0 lo1 hi1 lo2 hi2)} = @arg[1 .. 7];
    return $self;
}

1;

__END__

=head1 NAME

Text::Diff3::Range3 - three-way difference container

=head1 SYNOPSIS

  use Text::Diff3;
  my $f = Text::Diff3::Factory;
  my $range3 = $f->create_range3(1, 2,3, 4,5, 6,7);
  $type = $range3->type;    # 1
  $line_no = $range3->lo0;  # 2
  $line_no = $range3->hi0;  # 3
  $line_no = $range3->lo1;  # 4
  $line_no = $range3->hi1;  # 5
  $line_no = $range3->lo2;  # 6
  $line_no = $range3->hi2;  # 7
  print $range3->as_string, "\n"; # 1 2,3 4,5 6,7

=head1 AUTHOR

MIZUTANI Tociyuki C<< <tociyuki@gmail.com> >>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
