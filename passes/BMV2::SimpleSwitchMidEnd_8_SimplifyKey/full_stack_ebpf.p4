#include <core.p4>
#include <ebpf_model.p4>
@ethernetaddress typedef bit<48> EthernetAddress;
@ipv4address typedef bit<32> IPv4Address;
header Ethernet_h {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16>         etherType;
}
header IPv4_h {
    bit<4>      version;
    bit<4>      ihl;
    bit<8>      diffserv;
    bit<16>     totalLen;
    bit<16>     identification;
    bit<3>      flags;
    bit<13>     fragOffset;
    bit<8>      ttl;
    bit<8>      protocol;
    bit<16>     hdrChecksum;
    IPv4Address srcAddr;
    IPv4Address dstAddr;
}
struct Headers_t {
    Ethernet_h ethernet;
    IPv4_h[2]  ipv4;
}
parser prs(packet_in p, out Headers_t headers) {
    state start {
        p.extract<Ethernet_h>(headers.ethernet);
        transition select(headers.ethernet.etherType) {
            16w0x800: ip;
            default: reject;
        }
    }
    state ip {
        p.extract<IPv4_h>(headers.ipv4[0]);
        p.extract<IPv4_h>(headers.ipv4[1]);
        transition accept;
    }
}
control pipe(inout Headers_t headers, out bool pass) {
    @name(".NoAction") action NoAction_0() {
    }
    @name("pipe.Reject") action Reject(IPv4Address add) {
        pass = false;
        headers.ipv4[0].srcAddr = add;
    }
    bit<32> key_0;
    @name("pipe.Check_src_ip") table Check_src_ip_0 {
        key = {
            key_0: exact @name("headers.ipv4[0].srcAddr") ;
        }
        actions = {
            Reject();
            NoAction_0();
        }
        implementation = hash_table(32w1024);
        const default_action = NoAction_0();
    }
    apply {
        pass = true;
        {
            key_0 = headers.ipv4[0].srcAddr;
            switch (Check_src_ip_0.apply().action_run) {
                Reject: {
                    pass = false;
                }
                NoAction_0: {
                }
            }
        }
    }
}
ebpfFilter<Headers_t>(prs(), pipe()) main;
