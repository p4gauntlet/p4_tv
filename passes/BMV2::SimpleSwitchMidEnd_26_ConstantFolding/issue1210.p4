--- before_pass
+++ after_pass
@@ -16,9 +16,9 @@ parser ParserImpl(packet_in packet, out
 }
 control IngressImpl(inout parsed_headers_t hdr, inout metadata_t meta, inout standard_metadata_t standard_metadata) {
     apply {
-        if (true && meta._foo__v0 == meta._bar__v1) 
+        if (meta._foo__v0 == meta._bar__v1) 
             meta._foo__v0 = meta._foo__v0 + 9w1;
-        if (true && meta._foo__v0 == 9w192) 
+        if (meta._foo__v0 == 9w192) 
             meta._foo__v0 = meta._foo__v0 + 9w1;
     }
 }
