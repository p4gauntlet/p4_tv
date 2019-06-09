#include <core.p4>
#include <v1model.p4>
struct metadata {
}
header ethernet_t {
    bit<48> dstAddr;
    bit<48> srcAddr;
    bit<16> etherType;
}
struct headers {
    ethernet_t ethernet;
}
parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    state start {
        packet.extract<ethernet_t>(hdr.ethernet);
        transition accept;
    }
}
control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    bit<16> tmp_0;
    standard_metadata_t smeta;
    @name(".my_drop") action my_drop() {
        smeta.ingress_port = standard_metadata.ingress_port;
        smeta.egress_spec = standard_metadata.egress_spec;
        smeta.egress_port = standard_metadata.egress_port;
        smeta.clone_spec = standard_metadata.clone_spec;
        smeta.instance_type = standard_metadata.instance_type;
        smeta.drop = standard_metadata.drop;
        smeta.recirculate_port = standard_metadata.recirculate_port;
        smeta.packet_length = standard_metadata.packet_length;
        smeta.enq_timestamp = standard_metadata.enq_timestamp;
        smeta.enq_qdepth = standard_metadata.enq_qdepth;
        smeta.deq_timedelta = standard_metadata.deq_timedelta;
        smeta.deq_qdepth = standard_metadata.deq_qdepth;
        smeta.ingress_global_timestamp = standard_metadata.ingress_global_timestamp;
        smeta.egress_global_timestamp = standard_metadata.egress_global_timestamp;
        smeta.lf_field_list = standard_metadata.lf_field_list;
        smeta.mcast_grp = standard_metadata.mcast_grp;
        smeta.resubmit_flag = standard_metadata.resubmit_flag;
        smeta.egress_rid = standard_metadata.egress_rid;
        smeta.recirculate_flag = standard_metadata.recirculate_flag;
        smeta.checksum_error = standard_metadata.checksum_error;
        smeta.parser_error = standard_metadata.parser_error;
        smeta.priority = standard_metadata.priority;
        mark_to_drop(smeta);
        standard_metadata.ingress_port = smeta.ingress_port;
        standard_metadata.egress_spec = smeta.egress_spec;
        standard_metadata.egress_port = smeta.egress_port;
        standard_metadata.clone_spec = smeta.clone_spec;
        standard_metadata.instance_type = smeta.instance_type;
        standard_metadata.drop = smeta.drop;
        standard_metadata.recirculate_port = smeta.recirculate_port;
        standard_metadata.packet_length = smeta.packet_length;
        standard_metadata.enq_timestamp = smeta.enq_timestamp;
        standard_metadata.enq_qdepth = smeta.enq_qdepth;
        standard_metadata.deq_timedelta = smeta.deq_timedelta;
        standard_metadata.deq_qdepth = smeta.deq_qdepth;
        standard_metadata.ingress_global_timestamp = smeta.ingress_global_timestamp;
        standard_metadata.egress_global_timestamp = smeta.egress_global_timestamp;
        standard_metadata.lf_field_list = smeta.lf_field_list;
        standard_metadata.mcast_grp = smeta.mcast_grp;
        standard_metadata.resubmit_flag = smeta.resubmit_flag;
        standard_metadata.egress_rid = smeta.egress_rid;
        standard_metadata.recirculate_flag = smeta.recirculate_flag;
        standard_metadata.checksum_error = smeta.checksum_error;
        standard_metadata.parser_error = smeta.parser_error;
        standard_metadata.priority = smeta.priority;
    }
    @name("ingress.set_port") action set_port(bit<9> output_port) {
        standard_metadata.egress_spec = output_port;
    }
    @name("ingress.mac_da") table mac_da_0 {
        key = {
            hdr.ethernet.dstAddr: exact @name("hdr.ethernet.dstAddr") ;
        }
        actions = {
            set_port();
            my_drop();
        }
        default_action = my_drop();
    }
    apply {
        mac_da_0.apply();
        tmp_0 = hdr.ethernet.srcAddr[15:0];
        if (hdr.ethernet.srcAddr[15:0] > 16w5) 
            tmp_0 = hdr.ethernet.srcAddr[15:0] + 16w65535;
        hdr.ethernet.srcAddr = hdr.ethernet.srcAddr & ~48w0xffff | (bit<48>)tmp_0 << 0 & 48w0xffff;
    }
}
control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    apply {
    }
}
control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit<ethernet_t>(hdr.ethernet);
    }
}
control verifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}
control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}
V1Switch<headers, metadata>(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;
