package t::Cheater;

use Test::Base -Base;

#use Smart::Comments;
use lib 'lib';
use Cheater;

#$::RD_HINT = 1;
#$::RD_TRACE = 1;

our @EXPORT = qw(
    run_test run_tests
);

our $RandSeed = 0;

sub rand_seed ($) {
    $RandSeed = shift;
}

sub bail_out (@) {
    Test::More::BAIL_OUT(@_);
}

sub run_test ($) {
    my $block = shift;
    my $name = $block->name;

    srand($RandSeed);

    my $parser = Cheater::Parser->new;

    my $src = $block->src or
        bail_out("$name - No --- src specified");

    my $expected = $block->out;
    if (!defined $expected && !defined $block->err) {
        bail_out("$name - No --- out specified");
    }

    write_user_files($block);

    my $parse_tree = $parser->spec($src) or
        bail_out("$name - Failed to parse --- src due to grammatic errors");

    my $ast = Cheater::AST->new($parse_tree) or
        bail_out("$name - Cannot construct the AST");

    my $eval = Cheater::Eval->new(ast => $ast);

    my $computed;

    eval {
        $computed  = $eval->go or
            bail_out("$name - Failed to evaluate a random data base instance");
    };
    if (defined $block->err) {
        if ($@) {
            is $block->err, $@, "$name - err ok";
        } else {
            fail "$name - err ok";
        }
        return;
    }
    if ($@) {
        bail_out("$name - Failed to evaluate a random data base instance: $@");
    }

    my $got = $eval->to_string($computed);
    ### $got
    $got =~ s/ {2,}/\t/g;
    $expected =~ s/ {2,}/\t/g;
    is($got, $expected, "$name - output db ok");
}

sub run_tests () {
    for my $block (blocks()) {
        run_test($block);
    }
}

sub write_user_files ($) {
    my $block = shift;

    my $name = $block->name;

    if ($block->user_files) {
        if (!-d 't/tmp/') {
            mkdir 't/tmp/', 0700 or bail_out "Failed to create t/tmp/: $!";
        }

        my $raw = $block->user_files;

        open my $in, '<', \$raw;

        my @files;
        my ($fname, $body);
        while (<$in>) {
            if (/>>> (\S+)/) {
                if ($fname) {
                    push @files, [$fname, $body];
                }

                $fname = $1;
                undef $body;
            } else {
                $body .= $_;
            }
        }

        if ($fname) {
            push @files, [$fname, $body];
        }

        for my $file (@files) {
            my ($fname, $body) = @$file;
            #warn "write file $fname with content [$body]\n";

            if (!defined $body) {
                $body = '';
            }

            open my $out, ">t/tmp/$fname" or
                die "$name - Cannot open tmp/$fname for writing: $!\n";
            print $out $body;
            close $out;
        }
    }
}


