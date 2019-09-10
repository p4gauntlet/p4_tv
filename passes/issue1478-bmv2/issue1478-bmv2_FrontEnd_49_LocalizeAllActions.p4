#include <core.p4>
#include <v1model.p4>
header hdr {
}
struct Headers {
}
struct Meta {
}
parser p(packet_in b, out Headers h, inout Meta m, inout standard_metadata_t sm) {
    state start {
        transition accept;
    }
}
control vrfy(inout Headers h, inout Meta m) {
    apply {
    }
}
control update(inout Headers h, inout Meta m) {
    apply {
    }
}
control egress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    apply {
    }
}
control deparser(packet_out b, in Headers h) {
    apply {
    }
}
control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
    @name(".NoAction") action NoAction_1() {
    }
    @name(".NoAction") action NoAction_2() {
    }
    @name("t1") table t1 {
        size = 3;
        actions = {
            NoAction_1();
        }
        const default_action = NoAction_1();
    }
    @name("t2") table t2 {
        key = {
            sm.ingress_port: exact @name("sm.ingress_port") ;
        }
        actions = {
            NoAction_2();
        }
        const entries = {
                        9w0 : NoAction_2();
        }
        size = 10;
        default_action = NoAction_2();
    }
    apply {
        t1.apply();
        t2.apply();
    }
}
V1Switch<Headers, Meta>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;