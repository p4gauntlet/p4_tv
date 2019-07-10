from z3 import *


''' SOLVER '''
s = Solver()

''' HEADERS '''
# The input headers of the control pipeline
hdr = Datatype('hdr')
hdr.declare('mk_hdr', ('a', BitVecSort(32)), ('b', BitVecSort(32)))
hdr = hdr.create()


''' TABLES '''
''' The table constant we are matching with.
 Actually this should be a match action tuple that picks the next action
 How to implement that? Some form of array?
 Right now, we have a hacky version of integer values which mimic an enum.
 Each integer value corresponds to a specific action PER table. The number of
 available integer values is constrained. '''
ma_c_t = Datatype('ma_c_t')
ma_c_t.declare('mk_ma_c_t', ('key_0', BitVecSort(32)), ('action', IntSort()))
ma_c_t = ma_c_t.create()


''' OUTPUT '''

# the final output of the control pipeline in a single data type
p4_output = Datatype('p4_output')
p4_output.declare('mk_output',
                  ('hdr', hdr),
                  ('egress_spec', BitVecSort(9)))
p4_output = p4_output.create()


''' INPUT VARIABLES AND MATCH-ACTION ENTRIES'''

# Initialize the header and match-action constraints
# These are our inputs
# Think of it as the header inputs after they have been parsed
h = Const('h', hdr)
h_valid = Const('ethernet_valid', BoolSort())

# The possible table entries
c_t_m = Const('c_t_m', ma_c_t)
# reduce the range of action outputs to the total number of actions
# in this case we only have 2 actions
s.add(0 < ma_c_t.action(c_t_m), ma_c_t.action(c_t_m) < 3)


def step(func_list, rets, assignments):
    rets = list(rets)  # do not propagate the list per step
    if func_list:
        next_fun = func_list[0]
        func_list = func_list[1:]
        assignments.append(next_fun(func_list, rets))
    else:
        assignments.append(True)
    return And(assignments)


def control_ingress_0():
    ''' This is the initial version of the program. '''

    # The output header, one variable per modification
    ret_0 = Const("ret_0", p4_output)

    def c_a_0(func_list, rets):
        # This action creates a new header type where b is set to a
        assignments = []
        new_ret = len(rets)
        prev_ret = len(rets) - 1
        rets.append(Const("ret_%d" % new_ret, p4_output))
        assign = p4_output.mk_output(hdr.mk_hdr(
            hdr.a(p4_output.hdr(rets[prev_ret])),
            hdr.a(p4_output.hdr(rets[prev_ret]))),
            p4_output.egress_spec(rets[prev_ret]))
        assignments.append(rets[new_ret] == assign)
        return step(func_list, rets, assignments)

    def NoAction_0(func_list, rets):
        ''' This is an action '''
        # NoAction just returns the current header as is
        # This action creates a new header type where b is set to a
        assignments = []
        assignments.append(True)
        return step(func_list, rets, assignments)

    def c_t(func_list, rets):
        ''' This is a table '''

        def default():
            ''' The default action '''
            # It is set to NoAction in this case
            return NoAction_0(func_list, rets)

        def select_action():
            ''' This is a special macro to define action selection. We treat
            selection as a chain of implications. If we match, then the clause
            returned by the action must be valid.
            This might become really ugly with many actions.'''
            actions = []
            actions.append(Implies(ma_c_t.action(c_t_m) == 1,
                                   c_a_0(func_list, rets)))
            actions.append(Implies(ma_c_t.action(c_t_m) == 2,
                                   NoAction_0(func_list, rets)))
            return Xor(*actions)
        # The key of the table. In this case it is a single value
        c_t_key_0 = hdr.a(h) + hdr.a(h)
        # This is a table match where we look up the provided key
        # If we match select the associated action, else use the default action
        return If(hdr.a(h) + hdr.a(h) == ma_c_t.key_0(c_t_m),
                  select_action(), default())

    def apply():
        func_list = []

        func_list.append(c_t)

        def assign(func_list, rets):
            assignments = []
            new_ret = len(rets)
            prev_ret = new_ret - 1
            rets.append(Const("ret_%d" % new_ret, p4_output))
            assign = p4_output.mk_output(
                p4_output.hdr(rets[prev_ret]), BitVecVal(0, 9))
            assignments.append(rets[new_ret] == assign)
            return step(func_list, rets, assignments)
        # The list of assignments during the execution of the pipeline
        func_list.append(assign)
        return func_list
    # return the apply function as sequence of logic clauses
    func_chain = apply()
    return step(func_chain, assignments=[], rets=[ret_0])


def control_ingress_1():
    ''' This is the initial version of the program. '''
    ret_0 = Const("ret_0", p4_output)
    # The output header, one variable per modification

    def c_a_0(func_list, rets):
        # This action creates a new header type where b is set to a
        assignments = []
        new_ret = len(rets)
        prev_ret = new_ret - 1
        rets.append(Const("ret_%d" % new_ret, p4_output))
        assign = p4_output.mk_output(hdr.mk_hdr(
            hdr.a(p4_output.hdr(rets[prev_ret])),
            hdr.a(p4_output.hdr(rets[prev_ret]))),
            p4_output.egress_spec(rets[prev_ret]))
        assignments.append(rets[new_ret] == assign)
        return step(func_list, rets, assignments)

    def NoAction_0(func_list, rets):
        ''' This is an action '''
        # NoAction just returns the current header as is
        # This action creates a new header type where b is set to a
        assignments = []
        assignments.append(True)
        return step(func_list, rets, assignments)

    # the key is defined in the control function
    key_0 = BitVecVal(0, 32)

    def c_t(func_list, rets):
        ''' This is a table '''

        def default():
            ''' The default action '''
            # It is set to NoAction in this case
            return NoAction_0(func_list, rets)

        def select_action():
            ''' This is a special macro to define action selection. We treat
            selection as a chain of implications. If we match, then the clause
            returned by the action must be valid.
            This might become really ugly with many actions.'''
            actions = []
            actions.append(Implies(ma_c_t.action(c_t_m) == 1,
                                   c_a_0(func_list, rets)))
            actions.append(Implies(ma_c_t.action(c_t_m) == 2,
                                   NoAction_0(func_list, rets)))
            return Xor(*actions)
        # The key of the table. In this case it is a single value
        nonlocal key_0  # we refer to a variable in the outer scope
        c_t_key_0 = key_0
        # This is a table match where we look up the provided key
        # If we match select the associated action, else use the default action
        return If(c_t_key_0 == ma_c_t.key_0(c_t_m),
                  select_action(), default())

    def apply():
        func_list = []

        def assign(func_list, rets):
            assignments = []
            nonlocal key_0  # we refer to a variable in the outer scope
            key_0 = hdr.a(h) + hdr.a(h)
            assignments.append(True)
            return step(func_list, rets, assignments)
        func_list.append(assign)

        func_list.append(c_t)

        def assign(func_list, rets):
            assignments = []
            new_ret = len(rets)
            prev_ret = new_ret - 1
            rets.append(Const("ret_%d" % new_ret, p4_output))
            assign = p4_output.mk_output(
                p4_output.hdr(rets[prev_ret]), BitVecVal(0, 9))
            assignments.append(rets[new_ret] == assign)
            return step(func_list, rets, assignments)
        func_list.append(assign)

        return func_list
    # return the apply function as sequence of logic clauses
    func_chain = apply()
    return step(func_chain, assignments=[], rets=[ret_0])


def z3_check():
    # The equivalence check of the solver
    # For all input packets and possible table matches the programs should
    # be the same

    bounds = [h, c_t_m]
    # the equivalence equation
    tv_equiv = (simplify(control_ingress_0()) !=
                simplify(control_ingress_1()))
    s.add(tv_equiv)

    print(tv_equiv)
    s.add(tv_equiv)

    # print (s.sexpr())
    ret = s.check()
    if ret == sat:
        print (ret)
        print (s.model())
    else:
        print (ret)


if __name__ == '__main__':
    z3_check()
