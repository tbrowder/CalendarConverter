[![Actions Status](https://github.com/tbrowder/CalendarConverter/workflows/test/badge.svg)](https://github.com/tbrowder/CalendarConverter/actions)

NAME
====

CalendarConverter - Allows converting Y/M/D dates between any pair of a set of 15 *regular* calendars

SYNOPSIS
========

```raku
use CalendarConverter;
my $c = CalendarConverter.new: :in<gregorian>, :out<julian>;
say $c.convert: :2021year; # OUTPUT: yyyy/m/d
say $c.convert: :2021year, :10month, :15day; # OUTPUT: yyyy/m/d
```

DESCRIPTION
===========

CalendarConverter uses the algorithms of E. G. Richards to convert dates, in Y/M/D form, between any two of 15 *regular* calendars.

Calendars and name keys (from Ref. 1, Table 22.1):

<table class="pod-table">
<caption>Egyptian calendars</caption>
<thead><tr>
<th>No.</th> <th>Calendar name</th> <th>Key</th> <th>Era</th>
</tr></thead>
<tbody>
<tr> <td>1</td> <td>Macedonian</td> <td>mac</td> <td>Alexander</td> </tr> <tr> <td>2</td> <td>Syrian</td> <td>syr</td> <td>Alexander</td> </tr> <tr> <td>3</td> <td>Julian Roman</td> <td>jul</td> <td>Christian</td> </tr> <tr> <td>4</td> <td>Gregorian</td> <td>gre</td> <td>Christian</td> </tr>
</tbody>
</table>

<table class="pod-table">
<caption>Alexandrian calendars</caption>
<thead><tr>
<th>No.</th> <th>Calendar name</th> <th>Key</th> <th>Era</th>
</tr></thead>
<tbody>
<tr> <td>5</td> <td>Macedonian</td> <td>mac</td> <td>Alexander</td> </tr> <tr> <td>6</td> <td>Syrian</td> <td>syr</td> <td>Alexander</td> </tr> <tr> <td>7</td> <td>Julian Roman</td> <td>jul</td> <td>Christian</td> </tr>
</tbody>
</table>

<table class="pod-table">
<caption>Julian calendars</caption>
<thead><tr>
<th>No.</th> <th>Calendar name</th> <th>Key</th> <th>Era</th>
</tr></thead>
<tbody>
<tr> <td>8</td> <td>Macedonian</td> <td>mac</td> <td>Alexander</td> </tr> <tr> <td>9</td> <td>Syrian</td> <td>syr</td> <td>Alexander</td> </tr> <tr> <td>10</td> <td>Julian Roman</td> <td>jul</td> <td>Christian</td> </tr> <tr> <td>11</td> <td>Gregorian</td> <td>gre</td> <td>Christian</td> </tr>
</tbody>
</table>

<table class="pod-table">
<caption>Islamic calendars</caption>
<thead><tr>
<th>No.</th> <th>Calendar name</th> <th>Key</th> <th>Era</th>
</tr></thead>
<tbody>
<tr> <td>12</td> <td>Macedonian</td> <td>mac</td> <td>Alexander</td> </tr> <tr> <td>13</td> <td>Syrian</td> <td>syr</td> <td>Alexander</td> </tr>
</tbody>
</table>

<table class="pod-table">
<caption>Modern calendars</caption>
<thead><tr>
<th>No.</th> <th>Calendar name</th> <th>Key</th> <th>Era</th>
</tr></thead>
<tbody>
<tr> <td>14</td> <td>Macedonian</td> <td>mac</td> <td>Alexander</td> </tr> <tr> <td>15</td> <td>Syrian</td> <td>syr</td> <td>Alexander</td> </tr>
</tbody>
</table>

Planned features
----------------

  * subclass Raku Date for a Date::Calendar for any of the 15 calendars

References
----------

1. *Mapping Time: The Calendar and Its History*, E. G. Richards, The Oxford University Press, 2000.

AUTHOR
======

Tom Browder <tbrowder@cpan.org>

COPYRIGHT and LICENSE
=====================

Copyright © 2021 Tom Browder

This library is free software; you can redistribute it or modify it under the Artistic License 2.0.

