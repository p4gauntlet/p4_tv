--- before_pass
+++ after_pass
@@ -29,7 +29,8 @@ struct mystruct1_t {
     bool    hash_drop;
 }
 struct metadata {
-    mystruct1_t mystruct1;
+    bit<16> _mystruct1_hash10;
+    bool    _mystruct1_hash_drop1;
 }
 parser parserI(packet_in pkt, out headers hdr, inout metadata meta, inout standard_metadata_t stdmeta) {
     state start {
@@ -53,8 +54,8 @@ control cIngress(inout headers hdr, inou
     @name(".NoAction") action NoAction_0() {
     }
     @name("cIngress.hash_drop_decision") action hash_drop_decision() {
-        hash<bit<16>, bit<16>, tuple_0, bit<32>>(meta.mystruct1.hash1, HashAlgorithm.crc16, 16w0, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol }, 32w0xffff);
-        meta.mystruct1.hash_drop = meta.mystruct1.hash1 < 16w0x8000;
+        hash<bit<16>, bit<16>, tuple_0, bit<32>>(meta._mystruct1_hash10, HashAlgorithm.crc16, 16w0, { hdr.ipv4.srcAddr, hdr.ipv4.dstAddr, hdr.ipv4.protocol }, 32w0xffff);
+        meta._mystruct1_hash_drop1 = meta._mystruct1_hash10 < 16w0x8000;
     }
     @name("cIngress.guh") table guh_0 {
         key = {
@@ -67,8 +68,8 @@ control cIngress(inout headers hdr, inou
     }
     @name("cIngress.debug_table") table debug_table_0 {
         key = {
-            meta.mystruct1.hash1    : exact @name("meta.mystruct1.hash1") ;
-            meta.mystruct1.hash_drop: exact @name("meta.mystruct1.hash_drop") ;
+            meta._mystruct1_hash10    : exact @name("meta.mystruct1.hash1") ;
+            meta._mystruct1_hash_drop1: exact @name("meta.mystruct1.hash_drop") ;
         }
         actions = {
             NoAction_0();
@@ -79,10 +80,10 @@ control cIngress(inout headers hdr, inou
         if (hdr.ipv4.isValid()) {
             guh_0.apply();
             debug_table_0.apply();
-            if (meta.mystruct1.hash_drop) 
-                hdr.ethernet.dstAddr = meta.mystruct1.hash1 ++ 7w0 ++ (bit<1>)meta.mystruct1.hash_drop ++ 8w0 ++ 16w0xdead;
+            if (meta._mystruct1_hash_drop1) 
+                hdr.ethernet.dstAddr = meta._mystruct1_hash10 ++ 7w0 ++ (bit<1>)meta._mystruct1_hash_drop1 ++ 8w0 ++ 16w0xdead;
             else 
-                hdr.ethernet.dstAddr = meta.mystruct1.hash1 ++ 7w0 ++ (bit<1>)meta.mystruct1.hash_drop ++ 8w0 ++ 16w0xc001;
+                hdr.ethernet.dstAddr = meta._mystruct1_hash10 ++ 7w0 ++ (bit<1>)meta._mystruct1_hash_drop1 ++ 8w0 ++ 16w0xc001;
         }
     }
 }
