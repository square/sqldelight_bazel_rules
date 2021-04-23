load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load(
    "@rules_sqldelight//scripts:versions.bzl",
    "KOTLINC_RELEASE_SHA",
    "KOTLINC_RELEASE_URL",
    "MAVEN_REPOSITORY_RULES_SHA",
    "MAVEN_REPOSITORY_RULES_VERSION",
    "RULES_KOTLIN_SHA",
    "RULES_KOTLIN_VERSION",
    "RULES_PKG_SHA",
    "RULES_PKG_URL",
)

# Register repository rules for those using this from the repo source, and not the release package
def register_developer_rules():
    maybe(
        http_archive,
        name = "io_bazel_rules_kotlin",
        sha256 = RULES_KOTLIN_SHA,
        urls = ["https://github.com/bazelbuild/rules_kotlin/releases/download/v%s/rules_kotlin_release.tgz" % RULES_KOTLIN_VERSION],
    )

    maybe(
        http_archive,
        name = "maven_repository_rules",
        sha256 = MAVEN_REPOSITORY_RULES_SHA,
        strip_prefix = "bazel_maven_repository-%s" % MAVEN_REPOSITORY_RULES_VERSION,
        type = "zip",
        url = "https://github.com/square/bazel_maven_repository/archive/%s.zip" % MAVEN_REPOSITORY_RULES_VERSION,
    )

    maybe(
        http_archive,
        name = "rules_pkg",
        sha256 = RULES_PKG_SHA,
        url = RULES_PKG_URL,
    )
