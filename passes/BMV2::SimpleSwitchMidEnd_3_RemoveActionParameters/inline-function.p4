--- before_pass
+++ after_pass
@@ -1,19 +1,25 @@
 control c(inout bit<32> x) {
     bit<32> tmp;
+    bit<32> a_0;
+    bit<32> b_0;
+    bool hasReturned;
+    bit<32> retval;
+    bit<32> tmp_0;
+    bit<32> tmp_1;
+    bit<32> a_1;
+    bit<32> b_1;
+    bool hasReturned_0;
+    bit<32> retval_0;
+    bit<32> tmp_2;
     apply {
         {
-            bit<32> a_0 = x;
-            bit<32> b_0 = x;
-            bool hasReturned = false;
-            bit<32> retval;
-            bit<32> tmp_0;
-            bit<32> tmp_1;
+            a_0 = x;
+            b_0 = x;
+            hasReturned = false;
             {
-                bit<32> a_1 = a_0;
-                bit<32> b_1 = b_0;
-                bool hasReturned_0 = false;
-                bit<32> retval_0;
-                bit<32> tmp_2;
+                a_1 = a_0;
+                b_1 = b_0;
+                hasReturned_0 = false;
                 if (a_1 > b_1) 
                     tmp_2 = b_1;
                 else 
