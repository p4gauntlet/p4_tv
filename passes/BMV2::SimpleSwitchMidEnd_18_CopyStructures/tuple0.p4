--- before_pass
+++ after_pass
@@ -8,7 +8,10 @@ package top(proto _p);
 control c() {
     tuple_0 x_0;
     apply {
-        x_0 = { 32w10, false };
+        {
+            x_0.field = 32w10;
+            x_0.field_0 = false;
+        }
         f(x_0);
         f({ 32w20, true });
     }
