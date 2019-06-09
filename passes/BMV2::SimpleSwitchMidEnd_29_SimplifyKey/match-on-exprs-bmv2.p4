--- before_pass
+++ after_pass
@@ -32,9 +32,10 @@ control ingressImpl(inout headers_t hdr,
         hdr.ethernet.dstAddr[22:18] = hdr.ethernet.srcAddr[5:1];
         stdmeta.egress_spec = out_port;
     }
+    bit<5> key_0;
     @name("ingressImpl.t1") table t1_0 {
         key = {
-            hdr.ethernet.srcAddr[22:18]            : exact @name("ethernet.srcAddr.slice") ;
+            key_0                                  : exact @name("ethernet.srcAddr.slice") ;
             hdr.ethernet.dstAddr & 48w0x10101010101: exact @name("dstAddr_lsbs") ;
             key_1                                  : exact @name("etherType_less_10") ;
         }
@@ -48,7 +49,10 @@ control ingressImpl(inout headers_t hdr,
     apply {
         {
             key_1 = hdr.ethernet.etherType + 16w65526;
-            t1_0.apply();
+            {
+                key_0 = hdr.ethernet.srcAddr[22:18];
+                t1_0.apply();
+            }
         }
     }
 }
