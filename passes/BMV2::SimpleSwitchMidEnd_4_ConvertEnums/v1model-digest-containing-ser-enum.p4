--- before_pass
+++ after_pass
@@ -30,9 +30,9 @@ enum MyPacketTypes {
     Other
 }
 struct test_digest_t {
-    macAddr_t     in_mac_srcAddr;
-    error         my_parser_error;
-    MyPacketTypes pkt_type;
+    macAddr_t in_mac_srcAddr;
+    error     my_parser_error;
+    bit<32>   pkt_type;
 }
 struct test_digest2_t {
     macAddr_t in_mac_dstAddr;
@@ -110,7 +110,7 @@ control MyIngress(inout headers hdr, ino
     @name("MyIngress.send_digest") action send_digest() {
         meta.test_digest.in_mac_srcAddr = hdr.ethernet.srcAddr;
         meta.test_digest.my_parser_error = error.PacketTooShort;
-        meta.test_digest.pkt_type = MyPacketTypes.IPv4;
+        meta.test_digest.pkt_type = 32w0;
         digest<test_digest_t>(32w1, meta.test_digest);
         meta.test_digest2.in_mac_dstAddr = hdr.ethernet.dstAddr;
         meta.test_digest2.my_thing = 8w42;
