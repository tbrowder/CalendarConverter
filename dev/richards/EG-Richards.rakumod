unit module EG-Richards;

use Text::Utils :strip-comment;

use Gen-Test :mon2num;

# This module contains algorithms from E. G. Richards.

# From Table 25.4 Parameters for calculating the Gregorian correction, p. 320
# (keyed by calendar number):
constant %GC = [
     7 => {
        cal => 'Rebublican',
        J0  => 2375475,
        Y0  => 0,
        g0  => 0,
        A   => 396,
        B   => 578797,
        G   => -51,
    },
    11 => {
        cal => 'Gregorian',
        J0  => 2305508,
        Y0  => 1600,
        g0  => 10,
        A   => 184,
        B   => 274277,
        G   => -38,
    },
    14 => {
        cal => 'Bahai',
        J0  => 2451606,
        Y0  => 156,
        g0  => 1,
        A   => 184,
        B   => 274273,
        G   => -50,
    },
    15 => {
        cal => 'Saka',
        J0  => 1867268,
        Y0  => 322,
        g0  => 3,
        A   => 184,
        B   => 274073,
        G   => -36,
    },
];

# From Table 25.1 Parameters for the conversion of dates in regular calendars, p. 311
# (keyed by calendar number):
constant %RC is export = [
     1 => {
        cal => 'Egyptian',
        y   => 3968,
        j   => 47,
    },
     2 => {
        cal => 'Armenian',
        y   => 5268,
    },
     3 => {
        cal => 'Khwarizmian',
        y   => 5348,
    },
     4 => {
        cal => 'Persian',
        y   => 5348,
    },
     5 => {
        cal => 'Ethiopian',
        y   => 4720,
    },
     6 => {
        cal => 'Coptic',
        y   => 4996,
    },
     7 => {
        cal => 'Republican',
        y   => 6504,
        j   => 111, # WARNING: one must add 'g' to this value, see p. 319, Equation 25.26
    },
     8 => {
        cal => 'Macedonian',
        y   => 4405,
    },
     9 => {
        cal => 'Syrian',
        y   => 4405,
    },
    10 => {
        cal => 'Julian Roman',
        y   => 4716,
        j   => 1401,
        m   => 3,
        n   => 12,
        r   => 4,
        p   => 1461,
        q   => 0,
        v   => 3,
        u   => 5,
        s   => 153,
        t   => 2,
        w   => 2,
    },
    11 => {
        cal => 'Gregorian',
        y   => 4716,
        j   => 1401, # WARNING: one must add 'g' to this value, see p. 319, Equation 25.26
        m   => 3,
        n   => 12,
        r   => 4,
        p   => 1461,
        q   => 0,
        v   => 3,
        u   => 5,
        s   => 153,
        t   => 2,
        w   => 2,
    },
    12 => {
        cal => 'Islamic A',
        y   => 5519,
    },
    13 => {
        cal => 'Islamic B',
        y   => 5519,
    },
    14 => {
        cal => 'Bahai',
        y   => 6560,
        j   => 1412, # WARNING: one must add 'g' to this value, see p. 319, Equation 25.26
    },
    15 => {
        cal => 'Saka',
        y   => 4794,
        j   => 1348, # WARNING: one must add 'g' to this value, see p. 319, Equation 25.26
    },
];

sub g-for-input-Yp(\Yp) is export {
    # See Equation 25.26 on p. 319
}

sub g-for-input-J(\J) is export {
    # See Equation 25.34 on p. 320
}

sub day-frac2hms(Real $x, :$debug --> List) is export {
    # Converts the fraction of a day into hours, minutes,
    # and seconds"
    my $hours   = $x * 24;
    my $hour    = $hours.Int;
    my $minutes = ($hours - $hour) * 60;
    my $minute  = $minutes.Int;
    my $second  = ($minutes - $minute) * 60;
    $hour, $minute, $second
}

sub day-frac(DateTime:D $dt, :$debug --> Real) is export {
    # Converts the hours, minutes, and seconds of an
    # instant into the decimal fraction of a 24-hour day.
    constant sec-per-day = 24 * 60 * 60;
    # get seconds in this day
    my $frac = $dt.hour * 60 * 60;
    $frac += $dt.minute * 60;
    $frac += $dt.second;
    # the day fraction
    $frac /= sec-per-day;
}

sub cal2jd(\Y, \M, $D, :$input where /:i g|j/, :$output where /:i g|j/, :$debug --> Real) is export {
    # Using Richards' Algorithm E, p. 323

    my \D = $D.Int;
    my $day-frac = $D - D;

    # convert to the intermediate calendar form using equations ?

    # convert to the Gregorian calendar

    # convert to the Julian calendar
    my $jd = 0;
    # add the day fraction back
    $jd += $day-frac;
} # sub cal2jd

sub jd2cal($JD, :$gregorian = True, :$debug --> List) is export {
    # Using Richards' Algorithm F, p. 324
    my \JD = $JD.Int;
    my $day-frac = $JD - JD;

    my $da = 0;
    # add the day fraction back
    $da += $day-frac;
} # sub jd2cal

sub gregorian2jd($y, $m, $d, :$debug --> Real) {
}

sub julian2jd($y, $m, $d, :$debug --> Real) {
}

sub jd2gregorian($jd, :$debug --> List) {
}

sub jd2julian($jd, :$debug --> List) {
}


