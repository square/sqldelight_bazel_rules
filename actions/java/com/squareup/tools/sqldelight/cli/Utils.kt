package com.squareup.tools.sqldelight.cli

import java.lang.IllegalStateException

// General types

internal class SqlDelightException(message: String) : IllegalStateException(message)
