unit class Math::FractionalPart:ver<0.0.5>:auth<cpan:TBROWDER>;

method frac($x) {
    self.frac
}

method afrac($x) {
    self.afrac
}

method ofrac($x) {
    self.ofrac
}

method frac-part-digits($x) {
    self.frac-part-digits
}
method decimal-places($x) {
    self.frac-part-digits
}
method ndp($x) {
    self.frac-part-digits
}

multi sub frac-part-digits($x) is export(:frac-part-digits) {
    my $f = frac $x;
    $f == 0 ?? 0
            !! ($f.chars-2)
}
multi sub decimal-places($x) is export(:decimal-places) {
    frac-part-digits $x
}
multi sub ndp($x) is export(:ndp) {
    frac-part-digits $x
}

# using notation from Wikipedia:
multi sub frac($x) is export(:frac) {
    $x - floor($x)
}
multi sub afrac($x) is export(:afrac) {
    abs($x) - floor(abs($x))
}
multi sub ofrac($x) is export(:ofrac) {
    $x - floor(abs($x)) * sign($x)
}

# complex versions
# Note that Ref. 3 shows I<frac> operating in the I<complex plane> as C<frac(x + i y) = frac(x) + i frac(y)>.
multi sub frac(Complex $x --> Complex) is export(:frac) {
    my $re = $x.re - floor($x.re);
    my $im = $x.im - floor($x.im);
    Complex.new($re, $im)
}
multi sub afrac(Complex $x --> Complex) is export(:afrac) {
    my $re = abs($x.re) - floor(abs($x.re));
    my $im = abs($x.im) - floor(abs($x.im));
    Complex.new($re, $im)
}
multi sub ofrac(Complex $x --> Complex) is export(:ofrac) {
    my $re = $x.re - floor(abs($x.re)) * sign($x.re);
    my $im = $x.im - floor(abs($x.im)) * sign($x.im);
    Complex.new($re, $im)
}



