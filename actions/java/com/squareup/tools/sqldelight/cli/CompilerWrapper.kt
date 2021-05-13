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

import com.alecstrong.sql.psi.core.DialectPreset
import com.squareup.sqldelight.core.SqlDelightDatabaseProperties
import com.squareup.sqldelight.core.SqlDelightEnvironment
import java.io.File
import java.nio.file.Files
import java.nio.file.Path
import java.util.logging.Logger
import java.util.stream.Collectors.toList

class CompilerWrapper(
  packageName: String,
  private val outputDirectory: File,
  private val moduleName: String,
  databaseName: String,
  databaseDialect: DialectPreset
) {
  private val logger = Logger.getLogger(CompilerWrapper::class.java.name)
  private val defaultProperties = SqlDelightDatabaseProperties(
    packageName = packageName,
    compilationUnits = emptyList(),
    outputDirectory = outputDirectory.toString(),
    className = databaseName,
    dialectPreset = databaseDialect,
    dependencies = emptyList()
  )

  fun generate(srcFolders: List<File>): List<Path> {
    val environment = SqlDelightEnvironment(
      sourceFolders = srcFolders,
      dependencyFolders = emptyList(),
      properties = defaultProperties,
      outputDirectory = outputDirectory,
      moduleName = moduleName
    )

    when (val generationStatus = environment.generateSqlDelightFiles(logger::info)) {
      is SqlDelightEnvironment.CompilationStatus.Failure -> {
        generationStatus.errors.forEach { logger.severe(it) }
        throw SqlDelightException("Generation failed; see the generator error output for details.")
      }
    }
    val outPath = outputDirectory.toPath()
    return Files
      .walk(outPath)
      .filter { Files.isRegularFile(it) }
      .collect(toList())
  }
}
