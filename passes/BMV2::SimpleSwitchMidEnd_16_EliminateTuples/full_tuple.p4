struct S {
    bit<32> f;
    bool    s;
}
control proto();
package top(proto _p);
struct tuple_0 {
    bit<32> field;
    bool    field_0;
}
control c() {
    tuple_0 x_0;
    apply {
        x_0 = { 32w10, false };
    }
}
top(c()) main;
