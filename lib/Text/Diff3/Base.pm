package Text::Diff3::Base;
use 5.006;
use strict;
use warnings;
our $VERSION = '0.07';

__PACKAGE__->mk_attr_accessor('factory');

sub new {
    my($class, @arg) = @_;
    my $self = bless {}, $class;
    $self->initialize(@arg);
    return $self;
}

sub initialize {
    my($self, $f) = @_;
    $self->factory($f);
    return $self;
}

sub mk_attr_accessor {
    my($class, @fields) = @_;
    $class = ref $class ? ref $class : $class;
    for my $field (@fields) {
        my $accessor = $class->_accessor($field);
        no strict 'refs';
        *{"${class}::${field}"} = $accessor;
    }
}

sub _accessor {
    my($class, $field) = @_;
    return sub{
        my($self, @arg) = @_;
        if (@arg) {
            $self->{$field} = $arg[0];
        }
        return $self->{$field};
    };
}

1;

__END__

=head1 NAME

Text::Diff3::Base - plugin base class

=head1 AUTHOR

MIZUTANI Tociyuki C<< <tociyuki@gmail.com> >>.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009 MIZUTANI Tociyuki

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

=cut
