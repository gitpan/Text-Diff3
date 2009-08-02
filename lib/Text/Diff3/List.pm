package Text::Diff3::List;
# list of difference sets
use 5.006;
use strict;
use warnings;
our $VERSION = '0.07';

use base qw(Text::Diff3::ListMixin Text::Diff3::Base);

sub list { return $_[0]->{list} }

sub initialize {
    my($self, @arg) = @_;
    $self->SUPER::initialize(@arg);
    shift @arg; # drop factory
    $self->{list} = \@arg;
    return $self;
}

sub as_array {
    my($self) = @_;
    return map { [$_->as_array] } @{$self->list};
}

1;

__END__

=head1 NAME

Text::Diff3::List - a list of difference sets

=head1 SYNOPSIS

  use Text::Diff3;
  my $f = Text::Diff3::Factory->new;
  my $diff2 = $f->create_list2;
  my $diff3 = $f->create_list3;

=head1 AUTHOR

MIZUTANI Tociyuki C<< <tociyuki@gmail.com> >>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
