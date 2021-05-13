# Sample: Dialect

An example project which uses the sqldelight rules.

This sample shows using SQLDelight against MySql (though any dialect
supported by SQLDelight should work.

This example will fail, if not run against the release binary package.
The repository presently points at ../.. but this project doesn't contain
all the source-level dependencies needed to use the rules project directly.
Instead, run the following:

```sh
cd <root project workspace>
bazel build //:rules_sqldelight_release
mkdir /tmp/sqldelight_repo
tar -xzf bazel-bin/rules_sqldelight_release.tgz -C /tmp/sqldelight_repo
cd samples/dialect
bazel build --override-repository=rules_sqldelight=/tmp/sqldelight_repo
```

This will build the rules, and execute this trivial example against the packaged rules.

This logic is applied in the CI actions.

> TODO (cgruber): Set up a convenience script to run the samples.
