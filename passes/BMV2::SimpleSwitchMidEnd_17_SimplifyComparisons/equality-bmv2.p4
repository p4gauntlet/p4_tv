--- before_pass
+++ after_pass
@@ -32,11 +32,11 @@ control ingress(inout headers hdr, inout
             hdr.same.same = hdr.same.same | 8w1;
         if (hdr.h.v == hdr.a[0].v) 
             hdr.same.same = hdr.same.same | 8w2;
-        if (hdr.h == hdr.a[0]) 
+        if (!hdr.h.isValid() && !hdr.a[0].isValid() || hdr.h.isValid() && hdr.a[0].isValid() && hdr.h.s == hdr.a[0].s && hdr.h.v == hdr.a[0].v) 
             hdr.same.same = hdr.same.same | 8w4;
         tmp_0[0] = hdr.h;
         tmp_0[1] = hdr.a[0];
-        if (tmp_0 == hdr.a) 
+        if (true && (!tmp_0[0].isValid() && !hdr.a[0].isValid() || tmp_0[0].isValid() && hdr.a[0].isValid() && tmp_0[0].s == hdr.a[0].s && tmp_0[0].v == hdr.a[0].v) && (!tmp_0[1].isValid() && !hdr.a[1].isValid() || tmp_0[1].isValid() && hdr.a[1].isValid() && tmp_0[1].s == hdr.a[1].s && tmp_0[1].v == hdr.a[1].v)) 
             hdr.same.same = hdr.same.same | 8w8;
     }
 }
