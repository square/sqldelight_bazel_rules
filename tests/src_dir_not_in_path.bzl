load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")
load(":sqldelight.bzl", "sqldelight_codegen")
load(":tests/setup.bzl", "test_case")

def _test_impl(ctx):
    env = analysistest.begin(ctx)
    asserts.expect_failure(
        env,
        "Source file \"foo/bar/blah.sq\" does not contain source dir \"/blah/\" in its path.",
    )
    return analysistest.end(env)

_test = analysistest.make(_test_impl, expect_failure = True)

def setup():
    return test_case(
        name = "src_dir_not_in_path",
        tested_rule = sqldelight_codegen,
        test_rule = _test,
        srcs = ["foo/bar/blah.sq"],
        src_dir = "/blah/",
        package_name = "foo.bar.baz",
    )
