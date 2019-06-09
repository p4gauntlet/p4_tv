#include <core.p4>
header Header {
    bit<32> data;
}
parser p0(packet_in p, out Header h) {
    bool b_0;
    state start {
        b_0 = true;
        p.extract<Header>(h);
        transition select(h.data, (bit<1>)b_0) {
            (default, (bit<1>)true): next;
            (default, default): reject;
        }
    }
    state next {
        p.extract<Header>(h);
        transition select(h.data, (bit<1>)b_0) {
            (default, (bit<1>)true): accept;
            (default, default): reject;
            default: reject;
        }
    }
}
parser proto(packet_in p, out Header h);
package top(proto _p);
top(p0()) main;
