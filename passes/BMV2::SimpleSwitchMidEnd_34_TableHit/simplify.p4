--- before_pass
+++ after_pass
@@ -27,11 +27,17 @@ control c(out bool x) {
     }
     apply {
         x = true;
-        tmp = t1_0.apply().hit;
+        if (t1_0.apply().hit) 
+            tmp = true;
+        else 
+            tmp = false;
         if (!tmp) 
             tmp_0 = false;
         else {
-            tmp_1 = t2_0.apply().hit;
+            if (t2_0.apply().hit) 
+                tmp_1 = true;
+            else 
+                tmp_1 = false;
             tmp_0 = tmp_1;
         }
         if (tmp_0) 
