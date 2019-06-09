--- before_pass
+++ after_pass
@@ -24,28 +24,44 @@ control cIngress(inout headers hdr, inou
     headers hdr_0;
     bit<8> op_0;
     apply {
-        tmp = hdr;
+        {
+            tmp.h1 = hdr.h1;
+        }
         tmp_0 = hdr.h1.op1;
-        hdr_0 = tmp;
+        {
+            hdr_0.h1 = tmp.h1;
+        }
         op_0 = tmp_0;
         if (op_0 == 8w0x0) 
             ;
         else 
             if (op_0[7:4] == 4w1) 
                 hdr_0.h1.out1 = 8w4;
-        tmp = hdr_0;
-        hdr = tmp;
-        tmp_1 = hdr;
+        {
+            tmp.h1 = hdr_0.h1;
+        }
+        {
+            hdr.h1 = tmp.h1;
+        }
+        {
+            tmp_1.h1 = hdr.h1;
+        }
         tmp_2 = hdr.h1.op2;
-        hdr_0 = tmp_1;
+        {
+            hdr_0.h1 = tmp_1.h1;
+        }
         op_0 = tmp_2;
         if (op_0 == 8w0x0) 
             ;
         else 
             if (op_0[7:4] == 4w1) 
                 hdr_0.h1.out1 = 8w4;
-        tmp_1 = hdr_0;
-        hdr = tmp_1;
+        {
+            tmp_1.h1 = hdr_0.h1;
+        }
+        {
+            hdr.h1 = tmp_1.h1;
+        }
     }
 }
 control cEgress(inout headers hdr, inout metadata meta, inout standard_metadata_t stdmeta) {
