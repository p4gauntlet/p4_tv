--- before_pass
+++ after_pass
@@ -201,12 +201,12 @@ control ingress(inout headers_t hdr, ino
     }
     apply {
         if (standard_metadata.instance_type == 32w6) {
-            hdr.ipv4.srcAddr = 8w10 ++ 8w252 ++ 8w129 ++ 8w2;
+            hdr.ipv4.srcAddr = 32w184320258;
             meta._fwd_l2ptr0 = 32w0xe50b;
         }
         else 
             if (standard_metadata.instance_type == 32w4) {
-                hdr.ipv4.srcAddr = 8w10 ++ 8w199 ++ 8w86 ++ 8w99;
+                hdr.ipv4.srcAddr = 32w180835939;
                 meta._fwd_l2ptr0 = 32w0xec1c;
             }
             else 
