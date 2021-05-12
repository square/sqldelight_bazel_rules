package com.squareup.tools.sqldelight.cli

import com.alecstrong.sql.psi.core.DialectPreset
import com.alecstrong.sql.psi.core.DialectPreset.SQLITE_3_18
import com.xenomachina.argparser.ArgParser
import com.xenomachina.argparser.SystemExitException
import com.xenomachina.argparser.default
import java.io.File
import java.util.Locale

class Args(parser: ArgParser) {
  val srcJar by parser.storing(
    "--output_srcjar", "-o",
    help = "Path to generated sources jar"
  ) { File(this) }

  val srcDirs by parser.adding(
    "--src_dir",
    help = "Directory containing SQL source files"
  ) { File(this) }

  val packageName by parser.storing(
    "--package_name",
    help = "Package into which the code will be generated"
  )

  val moduleName by parser.storing(
    "--module_name",
    help = "Module Name for Kotlin compilation"
  )

  val databaseName by parser.storing(
    "--database_name",
    help = "Database Name for Kotlin compilation (not required for legacy). Default as `Database`."
  ).default("Database")

  val dialect by parser.storing(
    "--database_dialect",
    argName = "DIALECT",
    help = "One of the supported SQL dialects: ${DialectPreset.values().joinToString(", ")}"
  ) {
    try {
      DialectPreset.valueOf(this.toUpperCase(Locale.ROOT))
    } catch (e: IllegalArgumentException) {
      throw SystemExitException(
        "Invalid dialect \"$this\". Should be one of: ${DialectPreset.values().joinToString(", ")}",
        2
      )
    }
  }.default(SQLITE_3_18)

  val fileNames by parser.positionalList(help = "<list of SQL files to process>")
}
