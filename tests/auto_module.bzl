load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load(":sqldelight.bzl", "SqlDelightInfo", "sqldelight_codegen")
load(":tests/setup.bzl", "test_case")

def _test_impl(ctx):
    env = analysistest.begin(ctx)
    target_under_test = analysistest.target_under_test(env)
    asserts.equals(env, "//:auto_module_test_rule", target_under_test[SqlDelightInfo].module_name)
    return analysistest.end(env)

_test = analysistest.make(_test_impl)

def setup():
    return test_case(
        name = "auto_module",
        tested_rule = sqldelight_codegen,
        test_rule = _test,
        srcs = ["foo/bar/baz/blah.sq"],
        src_dir = "/bar",
        package_name = "baz",
    )
