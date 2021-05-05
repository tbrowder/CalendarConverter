unit class CalendarConverter:ver<0.0.1>:auth<cpan:TBROWDER>;

use CalendarConverter::Calendars :ALL;

has $.in is required;  # calendar key for input
has $.out is required; # calendar key for output

# attributes to be filled by TWEAK
has Cal $in-cal;
has Cal $out-cal;

submethod TWEAK {
}

#| Converts the date from the input calendar's date
#| to that of the output calendar's date.
method convert(:$year!, 
               :$month = 1,
               :$day = 1,
              ) {
    $ye, $mo, $da
}


