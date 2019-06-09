--- before_pass
+++ after_pass
@@ -65,7 +65,11 @@ control egress(inout headers hdr, inout
 }
 control DeparserImpl(packet_out packet, in headers hdr) {
     apply {
-        packet.emit<headers>(hdr);
+        {
+            packet.emit<S>(hdr.base);
+            packet.emit<O1>(hdr.u[0].byte);
+            packet.emit<O2>(hdr.u[0].short);
+        }
     }
 }
 control verifyChecksum(inout headers hdr, inout metadata meta) {
