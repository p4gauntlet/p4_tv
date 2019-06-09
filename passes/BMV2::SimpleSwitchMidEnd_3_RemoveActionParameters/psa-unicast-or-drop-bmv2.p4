--- before_pass
+++ after_pass
@@ -20,18 +20,26 @@ parser IngressParserImpl(packet_in pkt,
     }
 }
 control cIngress(inout headers_t hdr, inout metadata_t user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
-    @name(".send_to_port") action send_to_port(inout psa_ingress_output_metadata_t meta_2, in PortId_t egress_port_1) {
+    psa_ingress_output_metadata_t meta_2;
+    PortId_t egress_port_1;
+    @name(".send_to_port") action send_to_port() {
+        meta_2 = ostd;
+        egress_port_1 = (PortIdUint_t)hdr.ethernet.dstAddr[1:0];
         meta_2.drop = false;
         meta_2.multicast_group = 32w0;
         meta_2.egress_port = egress_port_1;
+        ostd = meta_2;
     }
-    @name(".ingress_drop") action ingress_drop(inout psa_ingress_output_metadata_t meta_3) {
+    psa_ingress_output_metadata_t meta_3;
+    @name(".ingress_drop") action ingress_drop() {
+        meta_3 = ostd;
         meta_3.drop = true;
+        ostd = meta_3;
     }
     apply {
-        send_to_port(ostd, (PortIdUint_t)hdr.ethernet.dstAddr[1:0]);
+        send_to_port();
         if (hdr.ethernet.dstAddr[1:0] == 2w0) 
-            ingress_drop(ostd);
+            ingress_drop();
     }
 }
 parser EgressParserImpl(packet_in buffer, out headers_t hdr, inout metadata_t user_meta, in psa_egress_parser_input_metadata_t istd, in empty_metadata_t normal_meta, in empty_metadata_t clone_i2e_meta, in empty_metadata_t clone_e2e_meta) {
