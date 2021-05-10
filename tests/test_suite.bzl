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
