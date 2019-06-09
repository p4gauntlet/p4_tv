--- before_pass
+++ after_pass
@@ -25,10 +25,12 @@ parser parserI(packet_in pkt, out Parsed
     }
 }
 control cIngress(inout Parsed_packet hdr, inout mystruct1 meta, inout standard_metadata_t stdmeta) {
+    bool hasReturned;
+    bool hasReturned_0;
     @name(".NoAction") action NoAction_0() {
     }
     @name("cIngress.foo") action foo(bit<16> bar) {
-        bool hasReturned = false;
+        hasReturned = false;
         if (bar == 16w0xf00d) {
             hdr.ethernet.srcAddr = 48w0xdeadbeeff00d;
             hasReturned = true;
@@ -46,7 +48,7 @@ control cIngress(inout Parsed_packet hdr
         default_action = NoAction_0();
     }
     apply {
-        bool hasReturned_0 = false;
+        hasReturned_0 = false;
         tbl1_0.apply();
         hasReturned_0 = true;
     }
