#include <core.p4>
#include <psa.p4>
typedef bit<48> EthernetAddress;
header ethernet_t {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}
header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragOffset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}
struct empty_metadata_t {
}
struct fwd_metadata_t {
}
struct metadata {
    fwd_metadata_t fwd_metadata;
}
typedef bit<48> ByteCounter_t;
typedef bit<80> PacketByteCounter_t;
struct headers {
    ethernet_t ethernet;
    ipv4_t     ipv4;
}
parser IngressParserImpl(packet_in buffer, out headers parsed_hdr, inout metadata user_meta, in psa_ingress_parser_input_metadata_t istd, in empty_metadata_t resubmit_meta, in empty_metadata_t recirculate_meta) {
    state start {
        parsed_hdr.ethernet.setInvalid();
        parsed_hdr.ipv4.setInvalid();
        buffer.extract<ethernet_t>(parsed_hdr.ethernet);
        transition select(parsed_hdr.ethernet.etherType) {
            16w0x800: CommonParser_parse_ipv4;
            default: start_0;
        }
    }
    state CommonParser_parse_ipv4 {
        buffer.extract<ipv4_t>(parsed_hdr.ipv4);
        transition start_0;
    }
    state start_0 {
        transition accept;
    }
}
parser EgressParserImpl(packet_in buffer, out headers parsed_hdr, inout metadata user_meta, in psa_egress_parser_input_metadata_t istd, in empty_metadata_t normal_meta, in empty_metadata_t clone_i2e_meta, in empty_metadata_t clone_e2e_meta) {
    state start {
        parsed_hdr.ethernet.setInvalid();
        parsed_hdr.ipv4.setInvalid();
        buffer.extract<ethernet_t>(parsed_hdr.ethernet);
        transition select(parsed_hdr.ethernet.etherType) {
            16w0x800: CommonParser_parse_ipv4_0;
            default: start_1;
        }
    }
    state CommonParser_parse_ipv4_0 {
        buffer.extract<ipv4_t>(parsed_hdr.ipv4);
        transition start_1;
    }
    state start_1 {
        transition accept;
    }
}
control ingress(inout headers hdr, inout metadata user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
    psa_ingress_output_metadata_t meta_2;
    PortId_t egress_port_1;
    psa_ingress_output_metadata_t meta_3;
    @name("ingress.port_bytes_in") Counter<ByteCounter_t, PortId_t>(32w512, 32w1) port_bytes_in_0;
    @name("ingress.per_prefix_pkt_byte_count") DirectCounter<PacketByteCounter_t>(32w2) per_prefix_pkt_byte_count_0;
    @name("ingress.next_hop") action next_hop(PortId_t oport) {
        per_prefix_pkt_byte_count_0.count();
        {
            {
                meta_2.class_of_service = ostd.class_of_service;
                meta_2.clone = ostd.clone;
                meta_2.clone_session_id = ostd.clone_session_id;
                meta_2.drop = ostd.drop;
                meta_2.resubmit = ostd.resubmit;
                meta_2.multicast_group = ostd.multicast_group;
                meta_2.egress_port = ostd.egress_port;
            }
            egress_port_1 = oport;
            meta_2.drop = false;
            meta_2.multicast_group = 32w0;
            meta_2.egress_port = egress_port_1;
            {
                ostd.class_of_service = meta_2.class_of_service;
                ostd.clone = meta_2.clone;
                ostd.clone_session_id = meta_2.clone_session_id;
                ostd.drop = meta_2.drop;
                ostd.resubmit = meta_2.resubmit;
                ostd.multicast_group = meta_2.multicast_group;
                ostd.egress_port = meta_2.egress_port;
            }
        }
    }
    @name("ingress.default_route_drop") action default_route_drop() {
        per_prefix_pkt_byte_count_0.count();
        {
            {
                meta_3.class_of_service = ostd.class_of_service;
                meta_3.clone = ostd.clone;
                meta_3.clone_session_id = ostd.clone_session_id;
                meta_3.drop = ostd.drop;
                meta_3.resubmit = ostd.resubmit;
                meta_3.multicast_group = ostd.multicast_group;
                meta_3.egress_port = ostd.egress_port;
            }
            meta_3.drop = true;
            {
                ostd.class_of_service = meta_3.class_of_service;
                ostd.clone = meta_3.clone;
                ostd.clone_session_id = meta_3.clone_session_id;
                ostd.drop = meta_3.drop;
                ostd.resubmit = meta_3.resubmit;
                ostd.multicast_group = meta_3.multicast_group;
                ostd.egress_port = meta_3.egress_port;
            }
        }
    }
    @name("ingress.ipv4_da_lpm") table ipv4_da_lpm_0 {
        key = {
            hdr.ipv4.dstAddr: lpm @name("hdr.ipv4.dstAddr") ;
        }
        actions = {
            next_hop();
            default_route_drop();
        }
        default_action = default_route_drop();
        psa_direct_counter = per_prefix_pkt_byte_count_0;
    }
    apply {
        port_bytes_in_0.count(istd.ingress_port);
        if (hdr.ipv4.isValid()) {
            ipv4_da_lpm_0.apply();
        }
    }
}
control egress(inout headers hdr, inout metadata user_meta, in psa_egress_input_metadata_t istd, inout psa_egress_output_metadata_t ostd) {
    @name("egress.port_bytes_out") Counter<ByteCounter_t, PortId_t>(32w512, 32w1) port_bytes_out_0;
    apply {
        port_bytes_out_0.count(istd.egress_port);
    }
}
control IngressDeparserImpl(packet_out buffer, out empty_metadata_t clone_i2e_meta, out empty_metadata_t resubmit_meta, out empty_metadata_t normal_meta, inout headers hdr, in metadata meta, in psa_ingress_output_metadata_t istd) {
    apply {
        buffer.emit<ethernet_t>(hdr.ethernet);
        buffer.emit<ipv4_t>(hdr.ipv4);
    }
}
control EgressDeparserImpl(packet_out buffer, out empty_metadata_t clone_e2e_meta, out empty_metadata_t recirculate_meta, inout headers hdr, in metadata meta, in psa_egress_output_metadata_t istd, in psa_egress_deparser_input_metadata_t edstd) {
    apply {
        buffer.emit<ethernet_t>(hdr.ethernet);
        buffer.emit<ipv4_t>(hdr.ipv4);
    }
}
IngressPipeline<headers, metadata, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t>(IngressParserImpl(), ingress(), IngressDeparserImpl()) ip;
EgressPipeline<headers, metadata, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t>(EgressParserImpl(), egress(), EgressDeparserImpl()) ep;
PSA_Switch<headers, metadata, headers, metadata, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t, empty_metadata_t>(ip, PacketReplicationEngine(), ep, BufferingQueueingEngine()) main;