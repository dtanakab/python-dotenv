abstract sig Name {}
abstract sig Value {}

abstract sig RawValue extends Value {}
abstract sig RefValue extends Value { ref: one Name }

sig EnvVar {
    key: one Name,
    value: one Value
}

sig Environment {
    vars: set EnvVar
}

fact UniqueKeys {
    all e: Environment | 
        all v1, v2: e.vars | 
        (v1 != v2) => (v1.key != v2.key)
}

pred expand[e: Environment, v: EnvVar, result: Value] {
    result = v.value or 
    (some w: e.vars | v.value in RefValue and w.key = v.value.ref and result = w.value)
}

fact VariableExpansion {
    all e: Environment, v: e.vars |
        v.value in RefValue implies some w: e.vars | w.key = v.value.ref
}

some sig NameInstance extends Name {}
some sig RawValueInstance extends RawValue {}
some sig RefValueInstance extends RefValue {}

assert CorrectExpansion {
    all e: Environment, v: e.vars | 
        some result: Value | expand[e, v, result] implies
        (v.value in RawValue or (some w: e.vars | w.key = v.value.ref and result = w.value))
}

check CorrectExpansion
