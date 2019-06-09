--- before_pass
+++ after_pass
@@ -100,6 +100,21 @@ control egress(inout headers hdr, inout
         send_frame_0.apply();
     }
 }
+struct tuple_0 {
+    bit<32> field;
+    bit<32> field_0;
+    bit<8>  field_1;
+    bit<16> field_2;
+    bit<16> field_3;
+    bit<16> field_4;
+}
+struct tuple_1 {
+    bit<32> field_5;
+    bit<32> field_6;
+    bit<8>  field_7;
+    bit<16> field_8;
+    bit<16> field_9;
+}
 control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
     @name(".NoAction") action NoAction_1() {
     }
@@ -123,7 +138,7 @@ control ingress(inout headers hdr, inout
         mark_to_drop(standard_metadata);
     }
     @name("ingress.set_ecmp_select") action set_ecmp_select(bit<8> ecmp_base, bit<8> ecmp_count) {
-        hash<bit<14>, bit<10>, tuple<bit<32>, bit<32>, bit<8>, bit<16>, bit<16>, bit<16>>, bit<20>>(meta.ingress_metadata.ecmp_offset, HashAlgorithm.crc16, (bit<10>)ecmp_base, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol, hdr.tcp.srcPort, hdr.tcp.dstPort, meta.ingress_metadata.flowlet_id }, (bit<20>)ecmp_count);
+        hash<bit<14>, bit<10>, tuple_0, bit<20>>(meta.ingress_metadata.ecmp_offset, HashAlgorithm.crc16, (bit<10>)ecmp_base, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol, hdr.tcp.srcPort, hdr.tcp.dstPort, meta.ingress_metadata.flowlet_id }, (bit<20>)ecmp_count);
     }
     @name("ingress.set_nhop") action set_nhop(bit<32> nhop_ipv4, bit<9> port) {
         meta.ingress_metadata.nhop_ipv4 = nhop_ipv4;
@@ -131,7 +146,7 @@ control ingress(inout headers hdr, inout
         hdr.ipv4.ttl = hdr.ipv4.ttl + 8w255;
     }
     @name("ingress.lookup_flowlet_map") action lookup_flowlet_map() {
-        hash<bit<13>, bit<13>, tuple<bit<32>, bit<32>, bit<8>, bit<16>, bit<16>>, bit<26>>(meta.ingress_metadata.flowlet_map_index, HashAlgorithm.crc16, 13w0, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol, hdr.tcp.srcPort, hdr.tcp.dstPort }, 26w13);
+        hash<bit<13>, bit<13>, tuple_1, bit<26>>(meta.ingress_metadata.flowlet_map_index, HashAlgorithm.crc16, 13w0, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol, hdr.tcp.srcPort, hdr.tcp.dstPort }, 26w13);
         flowlet_id_0.read(meta.ingress_metadata.flowlet_id, (bit<32>)meta.ingress_metadata.flowlet_map_index);
         meta.ingress_metadata.flow_ipg = (bit<32>)standard_metadata.ingress_global_timestamp;
         flowlet_lasttime_0.read(meta.ingress_metadata.flowlet_lasttime, (bit<32>)meta.ingress_metadata.flowlet_map_index);
@@ -213,14 +228,27 @@ control DeparserImpl(packet_out packet,
         packet.emit<tcp_t>(hdr.tcp);
     }
 }
+struct tuple_2 {
+    bit<4>  field_10;
+    bit<4>  field_11;
+    bit<8>  field_12;
+    bit<16> field_13;
+    bit<16> field_14;
+    bit<3>  field_15;
+    bit<13> field_16;
+    bit<8>  field_17;
+    bit<8>  field_18;
+    bit<32> field_19;
+    bit<32> field_20;
+}
 control verifyChecksum(inout headers hdr, inout metadata meta) {
     apply {
-        verify_checksum<tuple<bit<4>, bit<4>, bit<8>, bit<16>, bit<16>, bit<3>, bit<13>, bit<8>, bit<8>, bit<32>, bit<32>>, bit<16>>(hdr.ipv4.isValid(), { hdr.ipv4.version, hdr.ipv4.ihl, hdr.ipv4.diffserv, hdr.ipv4.totalLen, hdr.ipv4.identification, hdr.ipv4.flags, hdr.ipv4.fragOffset, hdr.ipv4.ttl, hdr.ipv4.protocol, hdr.ipv4.srcAddr, hdr.ipv4.dstAddr }, hdr.ipv4.hdrChecksum, HashAlgorithm.csum16);
+        verify_checksum<tuple_2, bit<16>>(hdr.ipv4.isValid(), { hdr.ipv4.version, hdr.ipv4.ihl, hdr.ipv4.diffserv, hdr.ipv4.totalLen, hdr.ipv4.identification, hdr.ipv4.flags, hdr.ipv4.fragOffset, hdr.ipv4.ttl, hdr.ipv4.protocol, hdr.ipv4.srcAddr, hdr.ipv4.dstAddr }, hdr.ipv4.hdrChecksum, HashAlgorithm.csum16);
     }
 }
 control computeChecksum(inout headers hdr, inout metadata meta) {
     apply {
-        update_checksum<tuple<bit<4>, bit<4>, bit<8>, bit<16>, bit<16>, bit<3>, bit<13>, bit<8>, bit<8>, bit<32>, bit<32>>, bit<16>>(hdr.ipv4.isValid(), { hdr.ipv4.version, hdr.ipv4.ihl, hdr.ipv4.diffserv, hdr.ipv4.totalLen, hdr.ipv4.identification, hdr.ipv4.flags, hdr.ipv4.fragOffset, hdr.ipv4.ttl, hdr.ipv4.protocol, hdr.ipv4.srcAddr, hdr.ipv4.dstAddr }, hdr.ipv4.hdrChecksum, HashAlgorithm.csum16);
+        update_checksum<tuple_2, bit<16>>(hdr.ipv4.isValid(), { hdr.ipv4.version, hdr.ipv4.ihl, hdr.ipv4.diffserv, hdr.ipv4.totalLen, hdr.ipv4.identification, hdr.ipv4.flags, hdr.ipv4.fragOffset, hdr.ipv4.ttl, hdr.ipv4.protocol, hdr.ipv4.srcAddr, hdr.ipv4.dstAddr }, hdr.ipv4.hdrChecksum, HashAlgorithm.csum16);
     }
 }
 V1Switch<headers, metadata>(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;
