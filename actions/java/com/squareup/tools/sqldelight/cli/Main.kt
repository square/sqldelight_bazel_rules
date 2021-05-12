package com.squareup.tools.sqldelight.cli

import com.xenomachina.argparser.ArgParser
import com.xenomachina.argparser.mainBody
import java.io.BufferedOutputStream
import java.nio.file.Files
import java.nio.file.StandardOpenOption
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

fun main(rawArgs: Array<String>) = mainBody {
  realMain(rawArgs)
}

/** Extracted to allow testing without xenomachina [mainBody] auto-handling errors */
internal fun realMain(rawArgs: Array<String>) {
  val args = ArgParser(rawArgs).parseInto(::Args)
  val tmpOut = Files.createTempDirectory("sqldelight")
  val files = CompilerWrapper(
          args.packageName,
          tmpOut.toFile(),
          args.moduleName,
          args.databaseName,
          args.dialect)
    .generate(args.srcDirs)

  val srcJar = args.srcJar.toPath()
    .also { Files.createDirectories(it.parent) }
  ZipOutputStream(
    BufferedOutputStream(Files.newOutputStream(srcJar, StandardOpenOption.CREATE_NEW))
  ).use { zos ->
    for (p in files) {
      zos.putNextEntry(
        ZipEntry(
          tmpOut.relativize(p).toString()
        )
      )
      zos.write(Files.readAllBytes(p))
      zos.closeEntry()
    }
  }
}
