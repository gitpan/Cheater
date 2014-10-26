# vi:ft=

use strict;
use warnings;

use t::Cheater;

plan tests => 1 * blocks();

$Cheater::Eval::NowDate = '2010-07-23';

no_diff;

run_tests;

__DATA__

=== TEST 1: date
--- src
table cats (
    birthday date;
)

5 cats;
--- out
cats
      birthday
      2011-04-23
      NULL
      2011-02-19
      2011-04-02
      2011-06-07



=== TEST 2: date (not null)
--- src
table cats (
    birthday date not null;
)

5 cats;
--- out
cats
      birthday
      2010-09-23
      2011-04-23
      2010-08-27
      2011-06-06
      2011-02-19



=== TEST 3: date (not null, asc)
--- src
table cats (
    birthday date asc not null;
)

5 cats;
--- out
cats
      birthday
      2010-08-27
      2010-09-23
      2011-02-19
      2011-04-23
      2011-06-06



=== TEST 4: date (not null, desc)
--- src
table cats (
    birthday date desc not null;
)

5 cats;
--- out
cats
      birthday
      2011-06-06
      2011-04-23
      2011-02-19
      2010-09-23
      2010-08-27



=== TEST 5: date range domain
--- src
table cats (
    birthday date 2010-02-01..2010-02-03;
)

5 cats;
--- out
cats
      birthday
      2010-02-01
      2010-02-03
      2010-02-03
      2010-02-02
      2010-02-02



=== TEST 6: date range domain (spanning two months)
--- src
table cats (
    birthday date 2010-01-25..2010-02-03;
)

5 cats;
--- out
cats
      birthday
      2010-01-25
      2010-02-01
      2010-02-02
      2010-01-28
      2010-01-28



=== TEST 7: bad date from domain definition
--- src
table cats (
    birthday time /\d+/;
)

3 cats;
--- err
table cats, column birthday: Bad domain value "7638743723" for the column type.

