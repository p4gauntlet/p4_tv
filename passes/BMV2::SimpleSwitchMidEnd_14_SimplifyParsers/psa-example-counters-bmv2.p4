--- before_pass
+++ after_pass
@@ -37,9 +37,6 @@ parser IngressParserImpl(packet_in buffe
     state start {
         parsed_hdr.ethernet.setInvalid();
         parsed_hdr.ipv4.setInvalid();
-        transition CommonParser_start;
-    }
-    state CommonParser_start {
         buffer.extract<ethernet_t>(parsed_hdr.ethernet);
         transition select(parsed_hdr.ethernet.etherType) {
             16w0x800: CommonParser_parse_ipv4;
@@ -58,9 +55,6 @@ parser EgressParserImpl(packet_in buffer
     state start {
         parsed_hdr.ethernet.setInvalid();
         parsed_hdr.ipv4.setInvalid();
-        transition CommonParser_start_0;
-    }
-    state CommonParser_start_0 {
         buffer.extract<ethernet_t>(parsed_hdr.ethernet);
         transition select(parsed_hdr.ethernet.etherType) {
             16w0x800: CommonParser_parse_ipv4_0;
