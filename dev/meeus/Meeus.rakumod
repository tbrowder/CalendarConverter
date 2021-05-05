unit module Meeus;

use Text::Utils :strip-comment;

#use lib <../lib>;
use Gen-Test :mon2num;

sub day-frac2hms(Real $x, :$debug --> List) is export {
    my $hours   = $x * 24;
    my $hour    = $hours.Int;
    my $minutes = ($hours - $hour) * 60;
    my $minute  = $minutes.Int;
    my $second  = ($minutes - $minute) * 60;
    $hour, $minute, $second
}

sub day-frac(DateTime:D $dt, :$debug --> Real) is export {
    constant sec-per-day = 24 * 60 * 60;
    # get seconds in this day
    my $frac = $dt.hour * 60 * 60;
    $frac += $dt.minute * 60;
    $frac += $dt.second;
    # the day fraction
    $frac /= sec-per-day;
}

sub modf($x) is export {
    # splits $x into integer and fractional parts
    # note the sign of $x is applied to BOTH parts
    my $int-part  = $x.Int;
    my $frac-part = $x - $int-part;
    $frac-part, $int-part;
}

sub jd0($year, :$gregorian = True, :$debug) is export {
    # from p. 62 in 1998 edition
    my \Y = $year - 1;
    my \A = floor(Y/100);
    my \JD0 = floor(365.25 * Y) - A + floor(A/4) + 1_721_424.5;
    JD0
}

sub cal2jd($y is copy, $m is copy, $d, :$gregorian = True, :$debug --> Real) is export {
    # from p. 60 in 1998 edition
    if $m == 1 or $m == 2 {
        $y -= 1;
        $m += 12;
    }
    my \Y = $y;
    my \M = $m;
    my \D = $d;

    my $b;
    if $gregorian {
        my $A = floor(Y/100);
        $b = 2 - $A + floor($A/4);
    }
    else {
        $b = 0;
    }
    my \B = $b;

    my \JD = floor(365.25 * (Y + 4_716)) + floor(30.6001 * (M + 1)) + D + B - 1_524.5;
    JD
} # sub cal2jd

sub jd2cal($jd is copy, :$gregorian = True, :$debug --> List) is export {
    # from p. 63 in 1998 edition
    # valid only for positive JD

    $jd += 0.5;
    my ($frac-part, $int-part) = modf $jd;
    my \F = $frac-part;
    my \Z = $int-part;

    note "DEBUG: input to modf: {$jd + 0.5} => F ({F}), Z ({Z})" if $debug;

    my $A;
    #if Z >= 2_291_161 { # errata, 2ed, Feb 16, 2004
    if Z >= 2_299_161 {
        my $alpha = floor( (Z - 1_867_216.25) / 36_524.25 );
        $A = Z + 1 + $alpha - floor( $alpha / 4 );
    }
    else {
        $A = Z;
    }
    my \A = $A;

    my \B = A + 1524;
    my \C  = floor( (B - 122.1) / 365.25 );
    my \D = floor( 365.25 * C );
    my \E  = floor( (B -D) / 30.6001 );

    my $da = B - D - floor(30.6001 * E) + F;
    my $mo = E - ( E < 14 ?? 1 !! 13 );
    my $ye = C - ( $mo > 2 ?? 4716 !! 4715 );
    
    # Note $da is a Real number
    $ye, $mo, $da;
} # sub jd2cal
