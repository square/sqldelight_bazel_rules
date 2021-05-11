load("@maven_repository_rules//maven:maven.bzl", "maven_repository_specification")
load("@rules_sqldelight//scripts:versions.bzl", "KOTLIN_VERSION", "SQLDELIGHT_VERSION")

def register_jarjar_deps():
    maven_repository_specification(
        name = "maven_sqldelight_tooling",
        artifacts = {
            "org.ow2.asm:asm-analysis:7.0": {"insecure": True},
            "org.ow2.asm:asm-commons:7.0": {"insecure": True},
            "org.ow2.asm:asm-tree:7.0": {"insecure": True},
            "org.ow2.asm:asm:7.0": {"insecure": True},
            "org.pantsbuild:jarjar:1.7.2": {
                "insecure": True,
                "exclude": [
                    "org.apache.ant:ant",
                    "org.apache.maven:maven-plugin-api",
                ],
            },
        },
    )

def register_action_deps():
    maven_repository_specification(
        name = "maven_sqldelight",
        artifacts = {
            "com.xenomachina:kotlin-argparser:2.0.7": {"insecure": True},
            "com.xenomachina:xenocom:0.0.7": {"insecure": True},
            "com.beust:jcommander:1.78": {"insecure": True},
            "com.squareup.sqldelight:core:%s" % SQLDELIGHT_VERSION: {"insecure": True},
            "org.antlr:antlr4-runtime:4.5.3": {"insecure": True},

            # Transitive
            "androidx.annotation:annotation:1.1.0": {"insecure": True},
            "androidx.collection:collection-ktx:1.1.0": {"insecure": True},
            "androidx.collection:collection:1.1.0": {"insecure": True},
            "com.alecstrong:sqlite-psi-core:0.3.4": {"insecure": True},
            "com.squareup.moshi:moshi:1.9.2": {"insecure": True},
            "com.squareup.okio:okio:1.16.0": {"insecure": True},
            "com.squareup:kotlinpoet:1.5.0": {"insecure": True},
            "org.jetbrains.kotlin:kotlin-reflect:%s" % KOTLIN_VERSION: {"insecure": True},
            "org.jetbrains.kotlin:kotlin-stdlib-common:%s" % KOTLIN_VERSION: {"insecure": True},
            "org.jetbrains.kotlin:kotlin-stdlib-jdk7:%s" % KOTLIN_VERSION: {"insecure": True},
            "org.jetbrains.kotlin:kotlin-stdlib-jdk8:%s" % KOTLIN_VERSION: {"insecure": True},
            "org.jetbrains.kotlin:kotlin-stdlib:%s" % KOTLIN_VERSION: {"insecure": True},
            "org.jetbrains:annotations:13.0": {"insecure": True},
            "org.xerial:sqlite-jdbc:3.21.0.1": {"insecure": True},
        },
        fetch_threads = 20,
        repository_urls = {
            "central": "https://repo1.maven.org/maven2",
            "android": "https://maven.google.com",
        },
    )
