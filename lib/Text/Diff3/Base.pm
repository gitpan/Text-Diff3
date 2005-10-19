package Text::Diff3::Base;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.05';

INIT{ __PACKAGE__->mk_attr_accessor( 'factory' ); }

sub new {
    my $class = shift;
    my $self = bless {}, $class;
    $self->initialize( @_ );
    $self;
}

sub initialize {
    my( $self, $f ) = @_;
    $self->factory( $f );
}

sub mk_attr_accessor {
    my $o = shift;
    my $class = ref $o ? ref $o : $o;
    no strict 'refs';
    for my $field ( @_ ) {
        *{ "$class\::$field" } =
            sub { $_[0]->{$field} = $_[1] if @_>1; $_[0]->{$field} };
    }
}

1;

__END__

=head1 NAME

Text::Diff3::Base - plugin base class

=head1 AUTHOR

MIZUTANI Tociyuki E<lt>tociyuki@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
