use Test::More tests => 24;
BEGIN { use_ok('Text::Diff3') };

my($t0, $t2, $t1, $d);
my $f = Text::Diff3::Factory->new;
my $p = $f->create_diff3;

# until() { while () { } } loop count
$t0 = $f->create_text([qw(a B C d e f)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 1, '0 only x 1');

$t0 = $f->create_text([qw(a b C d e f)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a B c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 1, '1 only x 1');

$t0 = $f->create_text([qw(a B c D e F)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 3, '0 only x 3');

$t0 = $f->create_text([qw(a b c d e f)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a B c D e F)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 3, '1 only x 3');

$t0 = $f->create_text([qw(a B c d e F)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c D e f)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 3, '1 and 2 x 3');

$t0 = $f->create_text([qw(a b c d e f)]);
$t2 = $f->create_text([qw(a B c D e F)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 3, '2 only x 3');

# continual pickup
$t0 = $f->create_text([qw(a B C d E f g h)]);
$t2 = $f->create_text([qw(a b c d e f g h)]);
$t1 = $f->create_text([qw(a b C D E F G h)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 1, 'continual one block cc;c');

$t0 = $f->create_text([qw(a B C d E f g h)]);
$t2 = $f->create_text([qw(a b c d e f g h)]);
$t1 = $f->create_text([qw(a b C D E f G h)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 2, 'continual two block cc;cc');

$t0 = $f->create_text([qw(a B C d E f g h)]);
$t2 = $f->create_text([qw(a b c d e F g h)]);
$t1 = $f->create_text([qw(a b C D E f G h)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 1, 'continual one block ccc;ccc');

$t0 = $f->create_text([qw(a B d E f g h)]);
$t2 = $f->create_text([qw(a b c d e g h)]);
$t1 = $f->create_text([qw(a b C D E f G h)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 1, 'continual one block cdca;cac');

$t0 = $f->create_text([qw(a f F F F g h)]);
$t2 = $f->create_text([qw(a b c d e f g h)]);
$t1 = $f->create_text([qw(a b c d E F G h)]);
$d = $p->diff3($t0, $t2, $t1);
ok($d->size == 1, 'continual one block da;ca');

# lo0 hi0 lo1 hi1 lo2 hi2 calcuration
$t0 = $f->create_text([qw(a B C D e f)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [[0, 2,4, 2,4, 2,4 ]],
    '0 only lo0 hi0 lo1 hi1 lo2 hi2 calcuration');

$t0 = $f->create_text([qw(a b c d e f)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b C D E f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [[1, 3,5, 3,5, 3,5 ]],
    '1 only lo0 hi0 lo1 hi1 lo2 hi2 calcuration');

$t0 = $f->create_text([qw(a b c d e f)]);
$t2 = $f->create_text([qw(a B C D E f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [[2, 2,5, 2,5, 2,5 ]],
    '2 only lo0 hi0 lo1 hi1 lo2 hi2 calcuration');

# conflict detection
$t0 = $f->create_text([qw(a w x y z f)]);
$t2 = $f->create_text([qw(a B C D E f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [['A', 2,5, 2,5, 2,5 ]], 'conflict same length');

$t0 = $f->create_text([qw(a w x y z f)]);
$t2 = $f->create_text([qw(a B C D E f)]);
$t1 = $f->create_text([qw(a b c d f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [['A', 2,5, 2,4, 2,5 ]], 'conflict diffent length');

# delete detection
$t0 = $f->create_text([qw(a c e f)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [[0, 2,1, 2,2, 2,2 ], [0, 3,2, 4,4, 4,4 ]], 'twice delete');

$t0 = $f->create_text([qw(c d e f)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [[0, 1,0, 1,2, 1,2 ]], 'delete at top');

$t0 = $f->create_text([qw(a b c d)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [[0, 5,4, 5,6, 5,6 ]], 'delete at last');

# append detection
$t0 = $f->create_text([qw(a B B b c D D D d e f)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [[0, 2,3, 2,1, 2,1 ], [0, 6,8, 4,3, 4,3 ]], 'twice append');

$t0 = $f->create_text([qw(A A a b c d e f)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [[0, 1,2, 1,0, 1,0 ]], 'append at top');

$t0 = $f->create_text([qw(a b c d e f G G)]);
$t2 = $f->create_text([qw(a b c d e f)]);
$t1 = $f->create_text([qw(a b c d e f)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [[0, 7,8, 7,6, 7,6 ]], 'append at last');

$t0 = $f->create_text([qw(A A b c f g h i j K l m n O p Q R s)]);
$t2 = $f->create_text([qw(a b c d e f g h i j k l m n o p q r s)]);
$t1 = $f->create_text([qw(a b c d f j K l M n o p 1 2 s t u)]);
$d = $p->diff3($t0, $t2, $t1);
is_deeply([$d->as_array], [
    [0,    1, 2,  1, 1,  1, 1],
    ['A',  5, 4,  4, 4,  4, 5],
    [1,    6, 8,  6, 5,  7, 9],
    [2,   10,10,  7, 7, 11,11],
    [1,   12,12,  9, 9, 13,13],
    [0,   14,14, 11,11, 15,15],
    ['A', 16,17, 13,14, 17,18],
    [1,   19,18, 16,17, 20,19],
], 'complex combination');
