unit module EG-Richards;

use Text::Utils :strip-comment;

use Gen-Test :mon2num;

# This module contains algorithms from E. G. Richards.

# from Table 25.4 Parameters for calculating the Gregorian correction, p. 320
constant %GC = [
    10 => {
        cal => 'Gregorian',
        J0 => 4716,
        Y0 => 4716,
        g0 => 4716,
        A => 4716,
        B => 4716,
        G => 4716,
    },
];

# from Table 25.1 Parameters for the conversion of dates in regular calendars, p. 311
constant %RC is export = [
    10 => {
        cal => 'Julian Roman',
        y => 4716,
        j => 1401,
        m => 3,
        n => 12,
        r => 4,
        p => 1461,
        q => 0,
        v => 3,
        u => 5,
        s => 153,
        t => 2,
        w => 2,
    },
    11 => {
        cal => 'Gregorian',
        y => 4716,
        j => 1401, # WARNING: one must add 'g' to this value, see p. 319, Equation 25.26
        m => 3,
        n => 12,
        r => 4,
        p => 1461,
        q => 0,
        v => 3,
        u => 5,
        s => 153,
        t => 2,
        w => 2,
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


