package com.squareup.tools.sqldelight.cli

import com.xenomachina.argparser.ArgParser
import com.xenomachina.argparser.default
import java.io.File

class Args(parser: ArgParser) {
  val srcJar by parser.storing(
    "--output_srcjar", "-o",
    help = "Srcjar of generated code."
  ) { File(this) }

  val srcDirs by parser.adding(
    "--src_dir",
    help = "Directories containing all srcs"
  ) { File(this) }

  val packageName by parser.storing(
    "--package_name",
    help = "Package into which the code will be generated"
  )

  val moduleName by parser.storing(
    "--module_name",
    help = "Module Name for Kotlin compilation (not required for legacy)"
  )

  val databaseName by parser.storing(
    "--database_name",
    help = "Database Name for Kotlin compilation (not required for legacy). Default as `Database`."
  ).default("Database")

  val fileNames by parser.positionalList(help = "<list of SQL files to process>")
}
