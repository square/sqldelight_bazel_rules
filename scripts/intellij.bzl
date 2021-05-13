# Copyright (C) 2020 Square, Inc.
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
_URL = "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/idea/ideaIU/{version}/ideaIU-{version}.zip"

_BUILD_FILE = """
load("@rules_java//java:defs.bzl", "java_import")

java_import(
    name = "idea",
    jars = [
        "lib/extensions.jar",
        "lib/jdom.jar",
        "lib/guava-28.2-jre.jar",
        "lib/platform-api.jar",
        "lib/platform-impl.jar",
        "lib/openapi.jar",
        "lib/testFramework.jar",
        "lib/trove4j.jar",
        "lib/util.jar",
    ],
    visibility = ["//visibility:public"],
)
"""

def _intellij_respository_impl(repo_ctx):
    repo_ctx.download_and_extract(
        url = _URL.format(version = repo_ctx.attr.version),
        sha256 = repo_ctx.attr.sha256,
        type = "zip",
        output = ".",
    )

    repo_ctx.file("BUILD.bazel", _BUILD_FILE)

intellij_core_repository = repository_rule(
    implementation = _intellij_respository_impl,
    attrs = {
        "version": attr.string(mandatory = True, doc = "Intellij version."),
        "sha256": attr.string(mandatory = True, doc = "Intellij arcive sha"),
    },
)
