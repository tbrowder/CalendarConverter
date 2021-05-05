#!/usr/bin/env raku
#
use Text::Utils :strip-comment;

use lib <../lib ./.>;
use Gen-Test :mon2num;
use EG-Richards;

my $ifil   = '../meeus/test-data.txt';
my $ifil2  = '../baum/test-data.txt';
my $ofil  = 'meeus-baum-data.t';
my $debug = 0;
if not @*ARGS {
    say qq:to/HERE/;
    Ugage: {$*PROGRAM.basename} go [debug]

    Tests Richards' subs jd2cal and cal2jd against Meeus's test data in
    file '$ifil' and Baum's in
    file '$ifil2'.
    HERE

    exit;
}

for @*ARGS {
    when /^:i d/ {++$debug}
}

my @t;
my $nd = 0;
for $ifil.IO.lines -> $line is copy {
    $line = strip-comment $line;
    next if $line !~~ /\S/;
    note "DEBUG: line: '$line'" if $debug;
    ++$nd;
    my @w = $line.words;
    my $y = @w.shift;
    my $M = @w.shift;
    my $m = mon2num $M;
    my $d = @w.shift;
    my $j = @w.shift;    
    my $gregorian = True;
    if @w.elems {
        my $s = @w.shift;
        $gregorian = False if $s ~~ /^:i j/;
        note "DEBUG: gregorian = '{$gregorian}'" if $debug;
    }

    note "    DEBUG: y/m/d ($M) (Gregorian == $gregorian) => jd : $y $m $d => $j" if $debug;

    my ($ye, $mo, $da) = jd2cal $j, :$gregorian, :$debug;
    say "JD $j ($y/$m/$d) => $ye/$mo/$da";

    # load the test array with the test data
    @t.push: [$j, $y, $m, $d, $M, $gregorian];
}
say "Normal end. Found $nd data points (expected 16).";

my $d0 = DateTime.new: :year(-4712), :month(1), :day(1), :hour(12);
my $d1 = DateTime.new: :year(2000), :month(1), :day(1), :hour(12);
my $ds = $d1 - $d0;
my $dd = $ds/86400;
say "cmp DateTime instants, does test JD days (2451545) == $dd ?";

my $days0 = $d0.daycount;
my $days1 = $d1.daycount;
my $ddays = $days1 - $days0;
say "cmp DateTime daycounts, does test JD (2451545) == $ddays ?";

# output the hash into a txt file
my $fh = open $ofil, :w;
my $ndp = @t.elems;
$fh.print: qq:to/HERE/;
use Test;
use lib <../lib ./.>;
use EG-Richards;

plan 183;

my \@meeus-test-data = [
    # $ndp data points
    # Julian-date   Y   M  D      m    Gregorian?
HERE

for @t -> $arr {
    my @v = @($arr);
    $fh.say: "    [{@v[0]}, {@v[1]}, {@v[2]}, {@v[3]}, '{@v[4].tc}', {@v[5]}],"; 
}

$fh.say: q:to/HERE/;
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
HERE

$fh.close;
say "See outout file '$ofil'";
