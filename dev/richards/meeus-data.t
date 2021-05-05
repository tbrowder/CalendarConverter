use Test;
use lib <../lib ./.>;
use EG-Richards;

plan 183;

my @meeus-test-data = [
    # 23 data points
    # Julian-date   Y   M  D      m    Gregorian?
    [2_451_545.0, 2000, 1, 1.5, 'Jan', True],
    [2_451_179.5, 1999, 1, 1.0, 'Jan', True],
    [2_446_822.5, 1987, 1, 27.0, 'Jan', True],
    [2_446_966.0, 1987, 6, 19.5, 'Jun', True],
    [2_447_187.5, 1988, 1, 27.0, 'Jan', True],
    [2_447_332.0, 1988, 6, 19.5, 'Jun', True],
    [2_415_020.5, 1900, 1, 1.0, 'Jan', True],
    [2_305_447.5, 1600, 1, 1.0, 'Jan', True],
    [2_305_812.5, 1600, 12, 31.0, 'Dec', True],
    [2_026_871.8, 837, 4, 10.3, 'Apr', False],
    [1_676_496.5, -123, 12, 31.0, 'Dec', False],
    [1_676_497.5, -122, 1, 1.0, 'Jan', False],
    [1_356_001.0, -1000, 7, 12.5, 'Jul', False],
    [1_355_866.5, -1000, 2, 29.0, 'Feb', False],
    [1_355_671.4, -1001, 8, 17.9, 'Aug', False],
    [0.0, -4712, 1, 1.5, 'Jan', False],
    [2_436_116.31, 1957, 10, 4.81, 'Oct', True],
    [1_842_713.0, 333, 1, 27.5, 'Jan', False],
    [2_436_116.31, 1957, 10, 4.81, 'Oct', True],
    [1_842_713.0, 333, 1, 27.5, 'Jan', False],
    [1_507_900.13, -584, 5, 28.63, 'May', False],
    [2_418_781.5, 1910, 4, 20.0, 'Apr', True],
    [2_446_470.5, 1986, 2, 9.0, 'Feb', True],
];

# use the data and check for round-tripping
my $tnum = 0;
for @meeus-test-data -> $arr {
    ++$tnum;
    my $jd  = $arr[0];
    my $ye  = $arr[1];
    my $mo  = $arr[2];
    my $da  = $arr[3]; # a real number
    my $mon = $arr[4];
    my $gregorian = $arr[5];

    my $day = $da.Int;
    my $day-frac = $da - $day;
    my ($ho, $mi, $se) = day-frac2hms $day-frac;
 
    # The official start date for the Gregorian calendar
    # was October 15, 1582.
    constant GC = DateTime.new: :1582year, :10month, :15day;

    # check the Richards implementations
    my $JD = cal2jd $ye, $mo, $da, :$gregorian;
    my ($Y, $M, $D) = jd2cal $jd, :$gregorian;
    # we may need proleptic Gregorian values from Meeus' data
    my ($JDg, $Yg, $Mg, $Dg);
    if not $gregorian {
        $JDg = cal2jd $ye, $mo, $da, :gregorian(True);
        ($Yg, $Mg, $Dg) = jd2cal $jd, :gregorian(True);
    }

    is $JD, $jd, "== data point $tnum: cmp JD, Gregorian: $gregorian"; 
    is $Y, $ye, "cmp Y, Gregorian: $gregorian";
    is $M, $mo, "cmp M, Gregorian: $gregorian";
    is $D, $da, "cmp D, Gregorian: $gregorian";

    # check the Raku implementations

    # Given the Julian Date (JD) of an instant, determine its Gregorian UTC
    constant POS0 = 2_440_587.5;    # the POSIX epoch in terms of JD
    # use the test value $jd
    my $days = $jd - POS0;          # days from the POSIX epoch to the desired JD
    my $psec = $days * 86_400;      # days x seconds-per-day
    my $date = DateTime.new($psec); # the desired UTC

    is $date.hour, $ho, "cmp JD to DateTime hour";
    is $date.minute, $mi, "cmp JD to DateTime minute";
    is $date.second, $se, "cmp JD to DateTime second";
    if $gregorian {
        is $date.year, $Y, "cmp JD to DateTime year";
        is $date.month, $M, "cmp JD to DateTime month";
        is $date.day, $D.Int, "cmp JD to DateTime day";
    }
    else {
        is $date.year, $Yg, "cmp JD to DateTime year, special handling for pre-Gregorian date";
        is $date.month, $Mg, "cmp JD to DateTime month, special handling for pre-Gregorian date";
        is $date.day, $Dg.Int, "cmp JD to DateTime day, special handling for pre-Gregorian date";
    }

    # Given a Gregorian instant (UTC), determine its Julian Date (JD)
    if $gregorian {
        my $d   = DateTime.new: :year($Y), :month($M), :day($D.Int), :hour($ho), :minute($mi), :second($se);

        my $psec = $d.Instant.tai;
        my $pdays = $psec/86_400;
        my $jd = $pdays + POS0;

        =begin comment
        # daycount is bad
        my $mjd = $d.daycount;
        $mjd   += day-frac $d;
        my $jd  = $mjd + 2_400_00.5; # from the relationship: MJD = JD - 240000.5
        =end comment

        is-approx $jd, $JD, "cmp JD from DateTime";
    }
#=begin comment
    else {
        my $d   = DateTime.new: :year($Yg), :month($Mg), :day($Dg.Int), :hour($ho), :minute($mi), :second($se);

        my $psec = $d.Instant.tai;
        my $pdays = $psec/86_400;
        my $jd = $pdays + POS0;

        =begin comment
        my $mjd = $d.daycount;
        $mjd   += day-frac $d;
        my $jd  = $mjd + 2_400_00.5; # from the relationship: MJD = JD - 240000.5
        =end comment

        is-approx $jd, $JD, "cmp JD, special handling for pre-Gregorian date";
    }
#=end comment
}

