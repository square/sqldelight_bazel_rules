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
