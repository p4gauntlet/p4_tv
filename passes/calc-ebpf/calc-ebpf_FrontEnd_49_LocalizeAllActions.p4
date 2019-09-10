#include <core.p4>
#include <ebpf_model.p4>
header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}
header p4calc_t {
    bit<8>  p;
    bit<8>  four;
    bit<8>  ver;
    bit<8>  op;
    bit<32> operand_a;
    bit<32> operand_b;
    bit<32> res;
}
struct headers {
    ethernet_t ethernet;
    p4calc_t   p4calc;
}
parser Parser(packet_in packet, out headers hdr) {
    p4calc_t tmp_3;
    p4calc_t tmp_4;
    p4calc_t tmp_5;
    state start {
        packet.extract<ethernet_t>(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            16w0x1234: check_p4calc;
            default: accept;
        }
    }
    state check_p4calc {
        tmp_3 = packet.lookahead<p4calc_t>();
        tmp_4 = packet.lookahead<p4calc_t>();
        tmp_5 = packet.lookahead<p4calc_t>();
        transition select(tmp_3.p, tmp_4.four, tmp_5.ver) {
            (8w0x50, 8w0x34, 8w0x1): parse_p4calc;
            default: accept;
        }
    }
    state parse_p4calc {
        packet.extract<p4calc_t>(hdr.p4calc);
        transition accept;
    }
}
control Ingress(inout headers hdr, out bool xout) {
    bit<48> tmp_6;
    @name("operation_add") action operation_add_0() {
        tmp_6 = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
        hdr.ethernet.srcAddr = tmp_6;
        hdr.p4calc.res = hdr.p4calc.operand_a + hdr.p4calc.operand_b;
    }
    @name("operation_sub") action operation_sub_0() {
        tmp_6 = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
        hdr.ethernet.srcAddr = tmp_6;
        hdr.p4calc.res = hdr.p4calc.operand_a - hdr.p4calc.operand_b;
    }
    @name("operation_and") action operation_and_0() {
        tmp_6 = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
        hdr.ethernet.srcAddr = tmp_6;
        hdr.p4calc.res = hdr.p4calc.operand_a & hdr.p4calc.operand_b;
    }
    @name("operation_or") action operation_or_0() {
        tmp_6 = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
        hdr.ethernet.srcAddr = tmp_6;
        hdr.p4calc.res = hdr.p4calc.operand_a | hdr.p4calc.operand_b;
    }
    @name("operation_xor") action operation_xor_0() {
        tmp_6 = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = hdr.ethernet.srcAddr;
        hdr.ethernet.srcAddr = tmp_6;
        hdr.p4calc.res = hdr.p4calc.operand_a ^ hdr.p4calc.operand_b;
    }
    @name("operation_drop") action operation_drop_0() {
        xout = false;
    }
    @name("operation_drop") action operation_drop_1() {
        xout = false;
    }
    @name("calculate") table calculate {
        key = {
            hdr.p4calc.op: exact @name("hdr.p4calc.op") ;
        }
        actions = {
            operation_add_0();
            operation_sub_0();
            operation_and_0();
            operation_or_0();
            operation_xor_0();
            operation_drop_0();
        }
        const default_action = operation_drop_0();
        const entries = {
                        8w0x2b : operation_add_0();
                        8w0x2d : operation_sub_0();
                        8w0x26 : operation_and_0();
                        8w0x7c : operation_or_0();
                        8w0x5e : operation_xor_0();
        }
        implementation = hash_table(32w8);
    }
    apply {
        xout = true;
        if (hdr.p4calc.isValid()) {
            calculate.apply();
        } else {
            operation_drop_1();
        }
    }
}
ebpfFilter<headers>(Parser(), Ingress()) main;