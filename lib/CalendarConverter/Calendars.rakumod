unit module CalendarConverter::Calendars;
 
#| Class used to contain data needed for a
#| specific calendar in Richards' calendar
#| conversion algorithms.
class Cal is export {
    has $.name   is rw;
    has $.number is rw;
    has $.key    is rw;
    has $.era    is rw;
    has %.GC     is rw;
    has %.RC     is rw;
}

#| Map of alpha keys to calendar number
constant %cals is export = [
    egy => 1,
    arm => 2,
    khw => 3,
    per => 4,
    eth => 5,
    cop => 6,
    rep => 7,
    mac => 8,
    syr => 9,
    jul => 10,
    gre => 11,
    isa => 12,
    isb => 13,
    bah => 14,
    sak => 15,
];

