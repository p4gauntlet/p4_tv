--- before_pass
+++ after_pass
@@ -31,11 +31,13 @@ control ingressImpl(inout headers_t hdr,
         hdr.ethernet.dstAddr[22:18] = hdr.ethernet.srcAddr[5:1];
         stdmeta.egress_spec = out_port;
     }
+    bit<5> key_0;
+    bit<16> key_1;
     @name("ingressImpl.t1") table t1_0 {
         key = {
-            hdr.ethernet.srcAddr[22:18]            : exact @name("ethernet.srcAddr.slice") ;
+            key_0                                  : exact @name("ethernet.srcAddr.slice") ;
             hdr.ethernet.dstAddr & 48w0x10101010101: exact @name("dstAddr_lsbs") ;
-            hdr.ethernet.etherType + 16w65526      : exact @name("etherType_less_10") ;
+            key_1                                  : exact @name("etherType_less_10") ;
         }
         actions = {
             foo();
@@ -45,7 +47,11 @@ control ingressImpl(inout headers_t hdr,
         const default_action = NoAction_0();
     }
     apply {
-        t1_0.apply();
+        {
+            key_0 = hdr.ethernet.srcAddr[22:18];
+            key_1 = hdr.ethernet.etherType + 16w65526;
+            t1_0.apply();
+        }
     }
 }
 control egressImpl(inout headers_t hdr, inout metadata_t meta, inout standard_metadata_t stdmeta) {
