--- before_pass
+++ after_pass
@@ -56,7 +56,9 @@ control Eg(inout Headers hdrs, inout Met
     bit<32> tmp;
     bit<32> tmp_0;
     @name("Eg.test") action test() {
-        val_0 = { 32w0 };
+        {
+            val_0.field1 = 32w0;
+        }
         _pred_0 = val_0.field1 != 32w0;
         if (_pred_0) 
             tmp = 32w1;
