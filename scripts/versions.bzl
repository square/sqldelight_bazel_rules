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
#
# VERSIONS for specific rule sets or groups of dependnecies.
#
# This file will not contain every maven artifact version. See maven.bzl.
# This file must have no load() dependencies on any other file.

SQLDELIGHT_VERSION = "1.4.0"

KOTLIN_VERSION = "1.4.32"

KOTLINC_RELEASE_SHA = "dfef23bb86bd5f36166d4ec1267c8de53b3827c446d54e82322c6b6daad3594c"

KOTLINC_RELEASE_URL = "https://github.com/JetBrains/kotlin/releases/download/v{v}/kotlin-compiler-{v}.zip".format(v = KOTLIN_VERSION)

RULES_KOTLIN_VERSION = "1.5.0-alpha-3"

RULES_KOTLIN_SHA = "eeae65f973b70896e474c57aa7681e444d7a5446d9ec0a59bb88c59fc263ff62"

MAVEN_REPOSITORY_RULES_VERSION = "2.0.0-alpha-4"

MAVEN_REPOSITORY_RULES_SHA = "a6484fec8d1aebd4affff7ae1ee9b59141858b2c636222bdb619526ccd8b3358"

RULES_PKG_VERSION = "0.2.4"

RULES_PKG_SHA = "4ba8f4ab0ff85f2484287ab06c0d871dcb31cc54d439457d28fd4ae14b18450a"

RULES_PKG_URL = "https://github.com/bazelbuild/rules_pkg/releases/download/{v}/rules_pkg-{v}.tar.gz".format(
    v = RULES_PKG_VERSION,
)
