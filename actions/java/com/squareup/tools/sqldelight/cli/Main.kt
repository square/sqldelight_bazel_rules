/*
 * Copyright (C) 2020 Square, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 *
 */
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
