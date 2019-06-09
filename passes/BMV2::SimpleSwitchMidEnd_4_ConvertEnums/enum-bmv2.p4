--- before_pass
+++ after_pass
@@ -38,10 +38,10 @@ control deparser(packet_out b, in Header
     }
 }
 control ingress(inout Headers h, inout Meta m, inout standard_metadata_t sm) {
-    Choice c_c;
+    bit<32> c_c;
     apply {
-        c_c = Choice.First;
-        if (c_c == Choice.Second) 
+        c_c = 32w0;
+        if (c_c == 32w1) 
             h.h.c = h.h.a;
         else 
             h.h.c = h.h.b;
