#include <core.p4>
#include <ebpf_model.p4>
struct Headers_t {
}
parser prs(packet_in p, out Headers_t headers) {
    state start {
        transition accept;
    }
}
control pipe(inout Headers_t headers, out bool pass) {
    apply {
        pass = true != false;
    }
}
ebpfFilter<Headers_t>(prs(), pipe()) main;