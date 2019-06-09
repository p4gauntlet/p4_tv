--- before_pass
+++ after_pass
@@ -24,7 +24,8 @@ header ipv4_t {
     bit<32> dstAddr;
 }
 struct metadata {
-    fwd_metadata_t fwd_metadata;
+    bit<32> _fwd_metadata_l2ptr0;
+    bit<24> _fwd_metadata_out_bd1;
 }
 struct headers {
     ethernet_t ethernet;
@@ -99,14 +100,14 @@ control ingress(inout headers hdr, inout
     @name("ingress.ipv4_da_lpm_stats") direct_counter(CounterType.packets) ipv4_da_lpm_stats_0;
     @name("ingress.set_l2ptr") action set_l2ptr(bit<32> l2ptr) {
         ipv4_da_lpm_stats_0.count();
-        meta.fwd_metadata.l2ptr = l2ptr;
+        meta._fwd_metadata_l2ptr0 = l2ptr;
     }
     @name("ingress.drop_with_count") action drop_with_count() {
         ipv4_da_lpm_stats_0.count();
         mark_to_drop(standard_metadata);
     }
     @name("ingress.set_bd_dmac_intf") action set_bd_dmac_intf(bit<24> bd, bit<48> dmac, bit<9> intf) {
-        meta.fwd_metadata.out_bd = bd;
+        meta._fwd_metadata_out_bd1 = bd;
         hdr.ethernet.dstAddr = dmac;
         standard_metadata.egress_spec = intf;
         hdr.ipv4.ttl = hdr.ipv4.ttl + 8w255;
@@ -128,7 +129,7 @@ control ingress(inout headers hdr, inout
             my_drop();
         }
         key = {
-            meta.fwd_metadata.l2ptr: exact @name("meta.fwd_metadata.l2ptr") ;
+            meta._fwd_metadata_l2ptr0: exact @name("meta.fwd_metadata.l2ptr") ;
         }
         default_action = my_drop();
     }
@@ -199,7 +200,7 @@ control egress(inout headers hdr, inout
             my_drop_0();
         }
         key = {
-            meta.fwd_metadata.out_bd: exact @name("meta.fwd_metadata.out_bd") ;
+            meta._fwd_metadata_out_bd1: exact @name("meta.fwd_metadata.out_bd") ;
         }
         default_action = my_drop_0();
     }
