--- before_pass
+++ after_pass
@@ -164,7 +164,26 @@ control PROTComputeChecksum(inout header
 }
 control PROTDeparser(packet_out packet, in headers hdr) {
     apply {
-        packet.emit<headers>(hdr);
+        {
+            packet.emit<preamble_t>(hdr.preamble);
+            packet.emit<prot_common_t>(hdr.prot_common);
+            packet.emit<prot_addr_common_t>(hdr.prot_addr_common);
+            packet.emit<prot_host_addr_ipv4_t>(hdr.prot_host_addr_dst.ipv4);
+            packet.emit<prot_host_addr_ipv4_t>(hdr.prot_host_addr_src.ipv4);
+            packet.emit<prot_host_addr_padding_t>(hdr.prot_host_addr_padding);
+            packet.emit<prot_i_t>(hdr.prot_inf_0);
+            packet.emit<prot_h_t>(hdr.prot_h_0[0]);
+            packet.emit<prot_h_t>(hdr.prot_h_0[1]);
+            packet.emit<prot_h_t>(hdr.prot_h_0[2]);
+            packet.emit<prot_h_t>(hdr.prot_h_0[3]);
+            packet.emit<prot_h_t>(hdr.prot_h_0[4]);
+            packet.emit<prot_h_t>(hdr.prot_h_0[5]);
+            packet.emit<prot_h_t>(hdr.prot_h_0[6]);
+            packet.emit<prot_h_t>(hdr.prot_h_0[7]);
+            packet.emit<prot_h_t>(hdr.prot_h_0[8]);
+            packet.emit<prot_h_t>(hdr.prot_h_0[9]);
+            packet.emit<prot_i_t>(hdr.prot_inf_1);
+        }
     }
 }
 V1Switch<headers, metadata>(PROTParser(), PROTVerifyChecksum(), PROTIngress(), PROTEgress(), PROTComputeChecksum(), PROTDeparser()) main;
