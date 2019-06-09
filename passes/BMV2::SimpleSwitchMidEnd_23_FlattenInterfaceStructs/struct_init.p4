--- before_pass
+++ after_pass
@@ -2,12 +2,12 @@ struct PortId_t {
     bit<9> _v;
 }
 struct metadata_t {
-    PortId_t foo;
+    bit<9> _foo__v0;
 }
 control I(inout metadata_t meta) {
     apply {
-        if (true && meta.foo._v == 9w192) 
-            meta.foo._v = meta.foo._v + 9w1;
+        if (true && meta._foo__v0 == 9w192) 
+            meta._foo__v0 = meta._foo__v0 + 9w1;
     }
 }
 control C<M>(inout M m);
