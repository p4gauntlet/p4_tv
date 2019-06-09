--- before_pass
+++ after_pass
@@ -22,14 +22,14 @@ parser IngressParserImpl(packet_in pkt,
 control cIngress(inout headers_t hdr, inout metadata_t user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
     @name(".send_to_port") action send_to_port(inout psa_ingress_output_metadata_t meta_2, in PortId_t egress_port_1) {
         meta_2.drop = false;
-        meta_2.multicast_group = (MulticastGroup_t)32w0;
+        meta_2.multicast_group = 32w0;
         meta_2.egress_port = egress_port_1;
     }
     @name(".ingress_drop") action ingress_drop(inout psa_ingress_output_metadata_t meta_3) {
         meta_3.drop = true;
     }
     apply {
-        send_to_port(ostd, (PortId_t)(PortIdUint_t)hdr.ethernet.dstAddr[1:0]);
+        send_to_port(ostd, (PortIdUint_t)hdr.ethernet.dstAddr[1:0]);
         if (hdr.ethernet.dstAddr[1:0] == 2w0) 
             ingress_drop(ostd);
     }
