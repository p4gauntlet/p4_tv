#include <core.p4>
#define V1MODEL_VERSION 20180101
#include <v1model.p4>

header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> eth_type;
}

struct Meta {
}

struct Headers {
    ethernet_t eth_hdr;
}

parser p(packet_in pkt, out Headers hdr, inout Meta m, inout standard_metadata_t sm) {
    state start {
        pkt.extract<ethernet_t>(hdr.eth_hdr);
        transition accept;
    }
}

control reset_ctrl(out bit<48> reset) {
    apply {
    }
}

control ingress(inout Headers hdr, inout Meta m, inout standard_metadata_t sm) {
    @name("reset") reset_ctrl() reset_0;
    @name("set_mac") action set_mac_0(bit<48> dst_mac) {
        hdr.eth_hdr.dst_addr = dst_mac;
    }
    @name("simple_tbl") table simple_tbl_0 {
        key = {
            hdr.eth_hdr.src_addr: exact @name("hdr.eth_hdr.src_addr") ;
        }
        actions = {
            NoAction();
            set_mac_0();
        }
        default_action = NoAction();
    }
    apply {
        reset_0.apply(hdr.eth_hdr.src_addr);
        simple_tbl_0.apply();
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
        b.emit<Headers>(h);
    }
}

V1Switch<Headers, Meta>(p(), vrfy(), ingress(), egress(), update(), deparser()) main;

