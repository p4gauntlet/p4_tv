--- before_pass
+++ after_pass
@@ -1,6 +1,6 @@
 #include <core.p4>
 typedef bit<32> B32;
-type bit<32> N32;
+typedef bit<32> N32;
 struct S {
     B32 b;
     N32 n;
@@ -27,10 +27,10 @@ control c(out B32 x) {
     }
     apply {
         b_0 = 32w0;
-        n_0 = (N32)b_0;
+        n_0 = b_0;
         k_0 = n_0;
         x = (B32)n_0;
-        n1_0 = (N32)32w1;
+        n1_0 = 32w1;
         if (n_0 == n1_0) 
             x = 32w2;
         s_0.b = b_0;
