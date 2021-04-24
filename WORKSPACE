workspace(name = "rules_sqldelight")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@rules_sqldelight//scripts:repositories.bzl", "register_developer_rules")
load("@rules_sqldelight//scripts:versions.bzl", "KOTLINC_RELEASE_SHA", "KOTLINC_RELEASE_URL")

register_developer_rules()

load("@rules_sqldelight//scripts:maven.bzl", "register_action_deps", "register_jarjar_deps")

register_jarjar_deps()

register_action_deps()

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kotlin_repositories", "kt_register_toolchains")

kotlin_repositories(compiler_release = {
    "urls": [KOTLINC_RELEASE_URL],
    "sha256": KOTLINC_RELEASE_SHA,
})

register_toolchains("//:kotlin_toolchain")

load("@rules_sqldelight//scripts:intellij.bzl", "intellij_core_repository")

intellij_core_repository(
    name = "intellij",
    sha256 = "2500339706e2951ae63a3c6e82e31a1da26adeee41a79724079420c2f29e18bb",
    version = "201.8743.12",
)

android_sdk_repository(
    name = "androidsdk",
    api_level = 29,
    build_tools_version = "29.0.3",
)
