#include <core.p4>
#include <v1model.p4>
typedef bit<48> EthernetAddress;
header ethernet_t {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}
struct headers_t {
    ethernet_t ethernet;
}
struct metadata_t {
}
parser parserImpl(packet_in packet, out headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
    state start {
        packet.extract<ethernet_t>(hdr.ethernet);
        transition accept;
    }
}
control verifyChecksum(inout headers_t hdr, inout metadata_t meta) {
    apply {
    }
}
control ingressImpl(inout headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
    bit<16> key_1;
    bit<5> key_0;
    @name(".NoAction") action NoAction_0() {
    }
    @name("ingressImpl.my_drop") action my_drop() {
        mark_to_drop(stdmeta);
    }
    @name("ingressImpl.foo") action foo(bit<9> out_port) {
        hdr.ethernet.dstAddr = hdr.ethernet.dstAddr & ~48w0x7c0000 | (bit<48>)hdr.ethernet.srcAddr[5:1] << 18 & 48w0x7c0000;
        stdmeta.egress_spec = out_port;
    }
    @name("ingressImpl.t1") table t1_0 {
        key = {
            key_0                                  : exact @name("ethernet.srcAddr.slice") ;
            hdr.ethernet.dstAddr & 48w0x10101010101: exact @name("dstAddr_lsbs") ;
            key_1                                  : exact @name("etherType_less_10") ;
        }
        actions = {
            foo();
            my_drop();
            NoAction_0();
        }
        const default_action = NoAction_0();
    }
    apply {
        key_1 = hdr.ethernet.etherType + 16w65526;
        key_0 = hdr.ethernet.srcAddr[22:18];
        t1_0.apply();
    }
}
control egressImpl(inout headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
    apply {
    }
}
control updateChecksum(inout headers_t hdr, inout metadata_t meta) {
    apply {
    }
}
control deparserImpl(packet_out packet, in headers_t hdr) {
    apply {
        packet.emit<ethernet_t>(hdr.ethernet);
    }
}
V1Switch<headers_t, metadata_t>(parserImpl(), verifyChecksum(), ingressImpl(), egressImpl(), updateChecksum(), deparserImpl()) main;
