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
