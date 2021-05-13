/*
 * Copyright (C) 2021 Square, Inc.
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

import com.xenomachina.argparser.ShowHelpException
import com.xenomachina.argparser.SystemExitException
import org.junit.Assert.assertThrows
import org.junit.Test

class ArgsTest {
  @Test
  fun help() {
    val args = arrayOf("--help")
    assertThrows(ShowHelpException::class.java) {
      realMain(args)
    }
  }

  @Test
  fun badDialect() {
    val args = arrayOf("--database_dialect=FOOSQL")
    val e = assertThrows(SystemExitException::class.java) {
      realMain(args)
    }
    assert(e.message!!.contains("Invalid dialect \"FOOSQL\". Should be one of: SQLITE_3_18"))
  }
}
