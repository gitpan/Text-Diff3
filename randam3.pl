#!perl
use strict;
use warnings;
binmode STDOUT;

my( $fname0, $fname2, $fname1 ) = @ARGV;
$fname0 ||= '0.txt';
$fname2 ||= '2.txt';
$fname1 ||= '1.txt';

my $text0 = [];
my $text1 = [];
my $text2 = [];
for (1..200) {
    push @$text0, sprintf "%3d", $_;
    push @$text1, sprintf "%3d", $_;
    push @$text2, sprintf "%3d", $_;
}
my $m = 201;
for (1..10) {
    my( $i, $a, $d );
    # d
    $i = int(rand( @$text0 ));
    $d = int(rand(4));
    splice @$text0, $i, $d;
    $i = int(rand( @$text1 ));
    $d = int(rand(4));
    splice @$text1, $i, $d;
    # a
    $i = int(rand( @$text0 + 1 ));
    $a = int(rand(4));
    splice @$text0, $i, 0, $m .. $m + $a;
    $m += $a + 1;
    $i = int(rand( @$text1 ));
    $a = int(rand(4));
    splice @$text1, $i, 0, $m .. $m + $a;
    $m += $a + 1;
    # c
    $i = int(rand( @$text0 ));
    $d = int(rand(4));
    $a = int(rand(4));
    splice @$text0, $i, $d, $m .. $m + $a;
    $m += $a + 1;
    $i = int(rand( @$text1 ));
    $d = int(rand(4));
    $a = int(rand(4));
    splice @$text1, $i, $d, $m .. $m + $a;
    $m += $a + 1;
}
open F, '>:raw', $fname0; print F $_, "\n" for @$text0; close F;
open F, '>:raw', $fname2; print F $_, "\n" for @$text2; close F;
open F, '>:raw', $fname1; print F $_, "\n" for @$text1; close F;
