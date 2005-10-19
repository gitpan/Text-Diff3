#!perl
use lib qw( ./lib );
use strict;
use warnings;
binmode STDOUT;
use Text::Diff3::Factory;

my $f = Text::Diff3::Factory->new;
my $p = $f->create_diff3;

my $help_message = <<EOS;
perl $0 --help -m -V myfile original yourfile
    --help  shop help.
    -m      output compatible with diff3 -m command (default)
    -V      output verbose
EOS

my $opt_m = 'm';
my $opt_V = undef;
while ( $ARGV[0] =~ /^-/ ) {
    my $opt = shift @ARGV;
    for ( $opt ) {
    /^-m/ && do { $opt_m = 'm'; last };
    /^-V/ && do { $opt_V = 'V'; last };
    /^--help/ && do { print $help_message; exit };
        die "unknown option\n" . $help_message;
    }
}

@ARGV == 3 or die "usage: perl $0 myfile original yourfile\n";

open F0, '<', $ARGV[0] or die "cannot open $ARGV[0] : $!";
open F2, '<', $ARGV[1] or die "cannot open $ARGV[2] : $!";
open F1, '<', $ARGV[2] or die "cannot open $ARGV[1] : $!";
my $text0 = [ map{chomp;$_} <F0> ]; close F;
my $text2 = [ map{chomp;$_} <F2> ]; close F;
my $text1 = [ map{chomp;$_} <F1> ]; close F;
close F0;
close F2;
close F1;

$text0 = $f->create_text( $text0 );
$text2 = $f->create_text( $text2 );
$text1 = $f->create_text( $text1 );

my $i2 = $text2->first_index;
my $d = $p->diff3( $text0, $text2, $text1 )->each( sub {
    my( $r ) = @_;
    print $text2->as_string_at( $_ ) for $i2 .. $r->lo2 - 1;
    if ( $opt_V ) {
        print "<<<<<<< $ARGV[0] : ", $r->as_string, "\n";
        print $text0->as_string_at( $_ ) for $r->range0;
        print "||||||| $ARGV[1]\n";
        print $text2->as_string_at( $_ ) for $r->range2;
        print "=======\n";
        print $text1->as_string_at( $_ ) for $r->range1;
        print ">>>>>>> $ARGV[2]\n";
   } elsif ( $r->type eq 'A' ) {
        print "<<<<<<< $ARGV[0]\n";
        print $text0->as_string_at( $_ ) for $r->range0;
        print "||||||| $ARGV[1]\n";
        print $text2->as_string_at( $_ ) for $r->range2;
        print "=======\n";
        print $text1->as_string_at( $_ ) for $r->range1;
        print ">>>>>>> $ARGV[2]\n";
    } elsif ( $r->type eq '0' ) {
        print $text0->as_string_at( $_ ) for $r->range0;
    } else {
        print $text1->as_string_at( $_ ) for $r->range1;
    }
    $i2 = $r->hi2 + 1;
} );
print $text2->as_string_at( $_ ) for $i2 .. $text2->last_index;
