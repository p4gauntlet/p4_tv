--- before_pass
+++ after_pass
@@ -15,7 +15,10 @@ control c(inout bit<16> p) {
         }
         void g(inout data x) {
             data ix_0;
-            ix_0 = x;
+            {
+                ix_0.a = x.a;
+                ix_0.b = x.b;
+            }
             if (ix_0.a < ix_0.b) 
                 x.a = ix_0.a + 16w1;
             if (ix_0.a > ix_0.b) 
