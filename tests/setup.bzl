load(":sqldelight.bzl", "sqldelight_codegen")

# Macro to setup the test.
def test_case(
        name,
        tested_rule,
        test_rule,
        **kwargs):
    tested_rule(
        name = "%s_test_rule" % name,
        tags = ["manual"],
        **kwargs
    )
    test_rule_name = "%s_test" % name
    test_rule(
        name = test_rule_name,
        target_under_test = ":%s_test_rule" % name,
    )
    return test_rule_name
