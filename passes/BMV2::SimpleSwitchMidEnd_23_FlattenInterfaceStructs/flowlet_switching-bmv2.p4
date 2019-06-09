--- before_pass
+++ after_pass
@@ -41,8 +41,12 @@ header tcp_t {
     bit<16> urgentPtr;
 }
 struct metadata {
-    @name("ingress_metadata") 
-    ingress_metadata_t ingress_metadata;
+    bit<32> _ingress_metadata_flow_ipg0;
+    bit<13> _ingress_metadata_flowlet_map_index1;
+    bit<16> _ingress_metadata_flowlet_id2;
+    bit<32> _ingress_metadata_flowlet_lasttime3;
+    bit<14> _ingress_metadata_ecmp_offset4;
+    bit<32> _ingress_metadata_nhop_ipv45;
 }
 struct headers {
     @name("ethernet") 
@@ -138,27 +142,27 @@ control ingress(inout headers hdr, inout
         mark_to_drop(standard_metadata);
     }
     @name("ingress.set_ecmp_select") action set_ecmp_select(bit<8> ecmp_base, bit<8> ecmp_count) {
-        hash<bit<14>, bit<10>, tuple_0, bit<20>>(meta.ingress_metadata.ecmp_offset, HashAlgorithm.crc16, (bit<10>)ecmp_base, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol, hdr.tcp.srcPort, hdr.tcp.dstPort, meta.ingress_metadata.flowlet_id }, (bit<20>)ecmp_count);
+        hash<bit<14>, bit<10>, tuple_0, bit<20>>(meta._ingress_metadata_ecmp_offset4, HashAlgorithm.crc16, (bit<10>)ecmp_base, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol, hdr.tcp.srcPort, hdr.tcp.dstPort, meta._ingress_metadata_flowlet_id2 }, (bit<20>)ecmp_count);
     }
     @name("ingress.set_nhop") action set_nhop(bit<32> nhop_ipv4, bit<9> port) {
-        meta.ingress_metadata.nhop_ipv4 = nhop_ipv4;
+        meta._ingress_metadata_nhop_ipv45 = nhop_ipv4;
         standard_metadata.egress_spec = port;
         hdr.ipv4.ttl = hdr.ipv4.ttl + 8w255;
     }
     @name("ingress.lookup_flowlet_map") action lookup_flowlet_map() {
-        hash<bit<13>, bit<13>, tuple_1, bit<26>>(meta.ingress_metadata.flowlet_map_index, HashAlgorithm.crc16, 13w0, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol, hdr.tcp.srcPort, hdr.tcp.dstPort }, 26w13);
-        flowlet_id_0.read(meta.ingress_metadata.flowlet_id, (bit<32>)meta.ingress_metadata.flowlet_map_index);
-        meta.ingress_metadata.flow_ipg = (bit<32>)standard_metadata.ingress_global_timestamp;
-        flowlet_lasttime_0.read(meta.ingress_metadata.flowlet_lasttime, (bit<32>)meta.ingress_metadata.flowlet_map_index);
-        meta.ingress_metadata.flow_ipg = meta.ingress_metadata.flow_ipg - meta.ingress_metadata.flowlet_lasttime;
-        flowlet_lasttime_0.write((bit<32>)meta.ingress_metadata.flowlet_map_index, (bit<32>)standard_metadata.ingress_global_timestamp);
+        hash<bit<13>, bit<13>, tuple_1, bit<26>>(meta._ingress_metadata_flowlet_map_index1, HashAlgorithm.crc16, 13w0, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol, hdr.tcp.srcPort, hdr.tcp.dstPort }, 26w13);
+        flowlet_id_0.read(meta._ingress_metadata_flowlet_id2, (bit<32>)meta._ingress_metadata_flowlet_map_index1);
+        meta._ingress_metadata_flow_ipg0 = (bit<32>)standard_metadata.ingress_global_timestamp;
+        flowlet_lasttime_0.read(meta._ingress_metadata_flowlet_lasttime3, (bit<32>)meta._ingress_metadata_flowlet_map_index1);
+        meta._ingress_metadata_flow_ipg0 = meta._ingress_metadata_flow_ipg0 - meta._ingress_metadata_flowlet_lasttime3;
+        flowlet_lasttime_0.write((bit<32>)meta._ingress_metadata_flowlet_map_index1, (bit<32>)standard_metadata.ingress_global_timestamp);
     }
     @name("ingress.set_dmac") action set_dmac(bit<48> dmac) {
         hdr.ethernet.dstAddr = dmac;
     }
     @name("ingress.update_flowlet_id") action update_flowlet_id() {
-        meta.ingress_metadata.flowlet_id = meta.ingress_metadata.flowlet_id + 16w1;
-        flowlet_id_0.write((bit<32>)meta.ingress_metadata.flowlet_map_index, meta.ingress_metadata.flowlet_id);
+        meta._ingress_metadata_flowlet_id2 = meta._ingress_metadata_flowlet_id2 + 16w1;
+        flowlet_id_0.write((bit<32>)meta._ingress_metadata_flowlet_map_index1, meta._ingress_metadata_flowlet_id2);
     }
     @name("ingress.ecmp_group") table ecmp_group_0 {
         actions = {
@@ -179,7 +183,7 @@ control ingress(inout headers hdr, inout
             NoAction_8();
         }
         key = {
-            meta.ingress_metadata.ecmp_offset: exact @name("meta.ingress_metadata.ecmp_offset") ;
+            meta._ingress_metadata_ecmp_offset4: exact @name("meta.ingress_metadata.ecmp_offset") ;
         }
         size = 16384;
         default_action = NoAction_8();
@@ -198,7 +202,7 @@ control ingress(inout headers hdr, inout
             NoAction_10();
         }
         key = {
-            meta.ingress_metadata.nhop_ipv4: exact @name("meta.ingress_metadata.nhop_ipv4") ;
+            meta._ingress_metadata_nhop_ipv45: exact @name("meta.ingress_metadata.nhop_ipv4") ;
         }
         size = 512;
         default_action = NoAction_10();
@@ -213,7 +217,7 @@ control ingress(inout headers hdr, inout
     apply {
         @atomic {
             flowlet_0.apply();
-            if (meta.ingress_metadata.flow_ipg > 32w50000) 
+            if (meta._ingress_metadata_flow_ipg0 > 32w50000) 
                 new_flowlet_0.apply();
         }
         ecmp_group_0.apply();
