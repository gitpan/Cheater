# vi:ft=

use strict;
use warnings;

use t::Cheater;

plan tests => 1 * blocks();
no_diff;

run_tests;

__DATA__

=== TEST 1: time
--- src
table cats (
    birthday time;
)

5 cats;
--- out
cats
      birthday
      17:59:51
      NULL
      13:51:19
      16:36:45
      20:58:25



=== TEST 2: time (not null)
--- src
table cats (
    birthday time not null;
)

5 cats;
--- out
cats
      birthday
      04:05:59
      17:59:51
      02:18:46
      20:53:28
      13:51:19



=== TEST 3: time (not null, asc)
--- src
table cats (
    birthday time asc not null;
)

5 cats;
--- out
cats
      birthday
      02:18:46
      04:05:59
      13:51:19
      17:59:51
      20:53:28



=== TEST 4: time (not null, desc)
--- src
table cats (
    birthday time desc not null;
)

5 cats;
--- out
cats
      birthday
      20:53:28
      17:59:51
      13:51:19
      04:05:59
      02:18:46



=== TEST 5: time range domain
--- src
table cats (
    birthday time 05:30..08:45 not null;
)

5 cats;
--- out
cats
      birthday
      07:56:14
      08:19:45
      08:03:14
      06:41:54
      07:55:18



=== TEST 6: time range domain (sec?)
--- src
table cats (
    birthday time 05:30:01 .. 05:30:03 unique not null;
)

3 cats;
--- out
cats
      birthday
      05:30:03
      05:30:02
      05:30:01



=== TEST 7: bad time from domain definition
--- src
table cats (
    birthday time 'abc';
)

3 cats;
--- err
table cats, column birthday: Bad domain value "abc" for the column type.

