# SQLDelight Bazel Rules

***Latest:** [v1.0-alpha-3](https://github.com/square/sqldelight_bazel_rules/releases/tag/v1.0-alpha-3)*
> Up-to-date instructions at the linked release.

## Overview

Sqldelight generates kotlin classes that provide a type-safe builder for a SQL query. It doesn't
presently have a CLI or non-gradle entry point, so the tooling here will supply this front-end
until it can be upgraded. 

## Usage

Assuming you are using rules_jvm_external, your targets might look something like this.

```
load("@rules_sqldelight//:sqldelight.bzl", "sqldelight_codegen")
load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_android_library")

kt_android_library(
    name = "lib",
    srcs = glob(["src/main/java/**/*.java"]) + [":gen"],
    deps = [
        "@maven//:androidx_sqlite",
        "@maven//androidx_sqlite_sqlite-ktx",
        "@maven//com_squareup_sqldelight_android-driver",
        "@maven//com_squareup_sqldelight_core",
    ],
)

sqldelight_codegen(
    name = "gen",
    package_name = "my.package",
    srcs = ["src/main/sqldelight/sqldelight/bazel/rules/samples/oneFourZero.sq"],
    database_dialect = "MYSQL",
    src_dir = "src/main/sqldelight",
)
```

### Non-Android Projects
You can use SQLDelight with non-android projects, you would specify a different
maven dependency (specifically `com.squareup.sqldelight:jdbc-driver:<version>`)
and you would set the *dialect* to your preferred SQL dialect, like so:

```
load("@rules_sqldelight//:sqldelight.bzl", "sqldelight_codegen")
load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_library")

kt_jvm_library(
    name = "lib",
    srcs = glob(["src/main/java/**/*.java"]) + [":gen"],
    deps = [
        "@maven//com_squareup_sqldelight_jdbc_driver",
    ],
)

sqldelight_codegen(
    name = "gen",
    package_name = "my.package",
    srcs = ["src/main/sqldelight/sqldelight/bazel/rules/samples/oneFourZero.sq"],
    database_dialect = "MYSQL",
    src_dir = "src/main/sqldelight",
)
```

### Database class name.

SQLDelight generates a Database and DatabaseImpl class. You can tweak that name like so:

```
sqldelight_codegen(
    ...
    database_name = "MyDatabase",
)
```

### Module

SQLDelight generates its DatabaseImpl class in a sub-package in order to avoid namespace collisions.
By default, the **sqldelight_bazel_rules** will generate that sub-package name based on the bazel
package and target. In case it needs to be manually set, which should be exceedingly rare, it can be
done via the following:

```
sqldelight_codegen(
    ...
    module_name = "someModuleName",
)
```

> Note: This is strictly a no-punctuation, no-spaces, alpha-numeric name to ensure what you specify
> here is what SQLDelight will use (under the hood it mangles names which do not abide by those
> constraints). 

# Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md)
