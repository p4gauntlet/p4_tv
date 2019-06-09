--- before_pass
+++ after_pass
@@ -4,13 +4,26 @@ control c(inout bit<32> x) {
     bit<32> tmp_1;
     bit<32> tmp_2;
     bit<32> tmp_3;
+    bit<32> a_0;
+    bit<32> b_0;
+    bool hasReturned;
+    bit<32> retval;
+    bit<32> tmp_4;
+    bit<32> a_1;
+    bit<32> b_1;
+    bool hasReturned_1;
+    bit<32> retval_1;
+    bit<32> tmp_11;
+    bit<32> a_2;
+    bit<32> b_2;
+    bool hasReturned_2;
+    bit<32> retval_2;
+    bit<32> tmp_12;
     apply {
         {
-            bit<32> a_0 = x;
-            bit<32> b_0 = x + 32w1;
-            bool hasReturned = false;
-            bit<32> retval;
-            bit<32> tmp_4;
+            a_0 = x;
+            b_0 = x + 32w1;
+            hasReturned = false;
             if (a_0 > b_0) 
                 tmp_4 = b_0;
             else 
@@ -21,11 +34,9 @@ control c(inout bit<32> x) {
         }
         tmp_0 = tmp;
         {
-            bit<32> a_1 = x;
-            bit<32> b_1 = x + 32w4294967295;
-            bool hasReturned_1 = false;
-            bit<32> retval_1;
-            bit<32> tmp_11;
+            a_1 = x;
+            b_1 = x + 32w4294967295;
+            hasReturned_1 = false;
             if (a_1 > b_1) 
                 tmp_11 = b_1;
             else 
@@ -36,11 +47,9 @@ control c(inout bit<32> x) {
         }
         tmp_2 = tmp_1;
         {
-            bit<32> a_2 = tmp_0;
-            bit<32> b_2 = tmp_2;
-            bool hasReturned_2 = false;
-            bit<32> retval_2;
-            bit<32> tmp_12;
+            a_2 = tmp_0;
+            b_2 = tmp_2;
+            hasReturned_2 = false;
             if (a_2 > b_2) 
                 tmp_12 = b_2;
             else 
