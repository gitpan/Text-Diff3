package Text::Diff3::ListMixin;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.07';

sub at {
    my($self, $x) = @_;
    return $self->list->[$x];
}

sub push {
    my($self, @arg) = @_;
    return CORE::push @{$self->list}, @arg;
}

sub pop {
    my($self) = @_;
    return CORE::pop @{$self->list};
}

sub unshift {
    my($self, @arg) = @_;
    return CORE::unshift @{$self->list}, @arg;
}

sub shift  {
    my($self) = @_;
    return CORE::shift @{$self->list};
}

sub is_empty {
    my($self) = @_;
    return ! scalar(@{$self->list});
}

sub size {
    my($self) = @_;
    return scalar(@{$self->list});
}

sub first {
    my($self) = @_;
    return $self->list->[0];
}

sub last {
    my($self) = @_;
    return $self->list->[-1];
}

sub each {
    my($self, $yield) = @_;
    ref $yield eq 'CODE' or die "requires coderef";
    for (@{$self->list}) {
        $yield->($_);
    }
    return $self;
}

1;

__END__

=head1 NAME

Text::Diff3::ListMixin - List mix-in.

=head1 SYNOPSIS

  package AnyList;
  use base qw(Text::Diff3::ListMixin Text::Diff3::Base);
  sub list { return $_[0]->buffer }

  package AnyListUser;
  use SomeFactory;
  my $list = SomeFactory->new->create_anylist;
  $list->push($x, $y);
  $x = $list->pop;
  $list->unshift($x, $y);
  $x = $list->shift;
  until ($list->is_empty) {
     $x = $list->shift;
     $x = $list->first->foo;
     $y = $list->last->bar;
  }
  $list->size == 3 or die "excepts \$list->size == 3".
  $list->each(sub{
      my($x) = @_;
      print $x, "\n";
  });
  
=head1 ABSTRACT

This is a mix-in class derived delegates to the list properties.

=head1 AUTHOR

MIZUTANI Tociyuki C<< <tociyuki@gmail.com> >>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
