--- before_pass
+++ after_pass
@@ -98,9 +98,25 @@ parser IngressParserImpl(packet_in buffe
 control ingress(inout headers hdr, inout metadata user_meta, in psa_ingress_input_metadata_t istd, inout psa_ingress_output_metadata_t ostd) {
     psa_ingress_output_metadata_t meta_1;
     @name(".ingress_drop") action ingress_drop() {
-        meta_1 = ostd;
+        {
+            meta_1.class_of_service = ostd.class_of_service;
+            meta_1.clone = ostd.clone;
+            meta_1.clone_session_id = ostd.clone_session_id;
+            meta_1.drop = ostd.drop;
+            meta_1.resubmit = ostd.resubmit;
+            meta_1.multicast_group = ostd.multicast_group;
+            meta_1.egress_port = ostd.egress_port;
+        }
         meta_1.drop = true;
-        ostd = meta_1;
+        {
+            ostd.class_of_service = meta_1.class_of_service;
+            ostd.clone = meta_1.clone;
+            ostd.clone_session_id = meta_1.clone_session_id;
+            ostd.drop = meta_1.drop;
+            ostd.resubmit = meta_1.resubmit;
+            ostd.multicast_group = meta_1.multicast_group;
+            ostd.egress_port = meta_1.egress_port;
+        }
     }
     @name("ingress.parser_error_counts") DirectCounter<PacketCounter_t>(32w0) parser_error_counts_0;
     @name("ingress.set_error_idx") action set_error_idx(ErrorIndex_t idx) {
