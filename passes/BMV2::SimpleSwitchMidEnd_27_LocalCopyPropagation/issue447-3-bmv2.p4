--- before_pass
+++ after_pass
@@ -14,11 +14,9 @@ struct Parsed_packet {
 struct Metadata {
 }
 parser parserI(packet_in pkt, out Parsed_packet hdr, inout Metadata meta, inout standard_metadata_t stdmeta) {
-    bit<32> size_0;
     state start {
         pkt.extract<S>(hdr.s1);
-        size_0 = hdr.s1.size;
-        pkt.extract<H>(hdr.h, size_0);
+        pkt.extract<H>(hdr.h, hdr.s1.size);
         pkt.extract<S>(hdr.s2);
         transition accept;
     }
