load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load(":sqldelight.bzl", "sqldelight_codegen")
load(":tests/setup.bzl", "test_case")

def _test_impl(ctx):
    env = analysistest.begin(ctx)
    asserts.expect_failure(env, "Module name may only contain mixed-case alphanumeric characters")
    asserts.expect_failure(env, "contained [\"-\", \"/\"]: \"blah-/Foo9Blah\"")
    return analysistest.end(env)

_test = analysistest.make(_test_impl, expect_failure = True)

def setup():
    return test_case(
        name = "manual_module_bad_input",
        tested_rule = sqldelight_codegen,
        test_rule = _test,
        srcs = ["foo/bar/blah.sq"],
        src_dir = "/blah/",
        package_name = "foo.bar.baz",
        module_name = "blah-/Foo9Blah",
    )
