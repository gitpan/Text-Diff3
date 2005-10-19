use Test::More tests => 9;
BEGIN { use_ok('Text::Diff3') };

# If you test another Factory or Diff2Processor change this
my $Factory = 'Text::Diff3::Factory';

can_ok( $Factory, 'new' );
my $f = $Factory->new;
can_ok( $f, 'create_diff' );
my $p2 = $f->create_diff;

my( $ta, $tb, $d );

$ta = $f->create_text([qw(a b c     f g h i j)]);
$tb = $f->create_text([qw(a B c d e f       j)]);
$d = $p2->diff( $ta, $tb );
is_deeply( [$d->as_array], [[qw(c 2 2 2 2)],[qw(a 4 3 4 5)],[qw(d 5 7 7 6)]],
    'diff 2,2c2,2; 4,3a4,5; 5,7d7,6');

$ta = $f->create_text([qw(a b c  )]);
$tb = $f->create_text([qw(A a b c)]);
$d = $p2->diff( $ta, $tb );
is_deeply( [$d->as_array], [[qw(a 1 0 1 1)]], 'diff 1,0a1,1');

$ta = $f->create_text([qw(a b c)]);
$tb = $f->create_text([qw(a b c D)]);
$d = $p2->diff( $ta, $tb );
is_deeply( [$d->as_array], [[qw(a 4 3 4 4)]], 'diff 4,3a4,4');

$ta = $f->create_text([qw(A b c)]);
$tb = $f->create_text([qw(b c)]);
$d = $p2->diff( $ta, $tb );
is_deeply( [$d->as_array], [[qw(d 1 1 1 0)]], 'diff 1,1d1,0');

$ta = $f->create_text([qw(a B c)]);
$tb = $f->create_text([qw(a c)]);
$d = $p2->diff( $ta, $tb );
is_deeply( [$d->as_array], [[qw(d 2 2 2 1)]], 'diff 2,2d2,1');

$ta = $f->create_text([qw(a b C)]);
$tb = $f->create_text([qw(a b)]);
$d = $p2->diff( $ta, $tb );
is_deeply( [$d->as_array], [[qw(d 3 3 3 2)]], 'diff 3,3d3,2');
