control p(out bit<1> y) {
    bit<1> x;
    bit<1> z;
    bit<1> x_3;
    @name("b") action b(in bit<1> x_2, out bit<1> y_0) {
        {
            bit<1> x0_0 = x_2;
            bit<1> y0_0;
            x = x0_0;
            y0_0 = x0_0 & x;
            z = y0_0;
        }
        {
            bit<1> x0_2 = z & z;
            bit<1> y0_2;
            x = x0_2;
            y0_2 = x0_2 & x;
            y_0 = y0_2;
        }
    }
    apply {
        x_3 = 1w1;
        b(x_3, y);
    }
}
control simple(out bit<1> y);
package m(simple pipe);
m(p()) main;