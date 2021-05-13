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
load(":tests/auto_module.bzl", module1 = "setup")
load(":tests/manual_module.bzl", module2 = "setup")
load(":tests/manual_module_bad_input.bzl", module3 = "setup")
load(":tests/src_dir_not_in_path.bzl", srcdir1 = "setup")

def sqldelight_test_suite(name):
    setup_functions = [srcdir1, module1, module2, module3]
    test_targets = []
    for setup in setup_functions:
        test_targets.append(setup())
    native.test_suite(
        name = name,
        tests = test_targets,
    )
