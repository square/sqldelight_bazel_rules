# Copyright (C) 2021 Square, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
# in compliance with the License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions and limitations under
# the License.
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
