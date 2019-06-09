--- before_pass
+++ after_pass
@@ -79,8 +79,8 @@ control ingress(inout headers hdr, inout
     psa_ingress_output_metadata_t meta_2;
     PortId_t egress_port_1;
     psa_ingress_output_metadata_t meta_3;
-    @name("ingress.port_bytes_in") Counter<ByteCounter_t, PortId_t>(32w512, PSA_CounterType_t.BYTES) port_bytes_in_0;
-    @name("ingress.per_prefix_pkt_byte_count") DirectCounter<PacketByteCounter_t>(PSA_CounterType_t.PACKETS_AND_BYTES) per_prefix_pkt_byte_count_0;
+    @name("ingress.port_bytes_in") Counter<ByteCounter_t, PortId_t>(32w512, 32w1) port_bytes_in_0;
+    @name("ingress.per_prefix_pkt_byte_count") DirectCounter<PacketByteCounter_t>(32w2) per_prefix_pkt_byte_count_0;
     @name("ingress.next_hop") action next_hop(PortId_t oport) {
         per_prefix_pkt_byte_count_0.count();
         {
@@ -118,7 +118,7 @@ control ingress(inout headers hdr, inout
     }
 }
 control egress(inout headers hdr, inout metadata user_meta, in psa_egress_input_metadata_t istd, inout psa_egress_output_metadata_t ostd) {
-    @name("egress.port_bytes_out") Counter<ByteCounter_t, PortId_t>(32w512, PSA_CounterType_t.BYTES) port_bytes_out_0;
+    @name("egress.port_bytes_out") Counter<ByteCounter_t, PortId_t>(32w512, 32w1) port_bytes_out_0;
     apply {
         port_bytes_out_0.count(istd.egress_port);
     }
