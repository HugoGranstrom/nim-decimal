# Decimal
# Copyright (c) 2018 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

import  unittest,
        ../decimal/decimal

suite "Basic Arithmetic":
  test "init Decimal":
    var d = newDecimal()
  test "Set Decimal from string":
    let s = "1.23456"
    var d = newDecimal(s)
    check $d == s
  test "Set Decimal from int":
    let s = 123456
    var d = newDecimal(s)
    let correct = "123456"
    check $d == correct
  test "Decimal Addition":
    var a = newDecimal("1.2")
    var b = newDecimal("3.5")
    var c = a + b
    let correct = "4.7"
    check $c == correct
  test "Decimal Subtraction":
    var a = newDecimal("1.2")
    var b = newDecimal("3.5")
    var c = a - b
    let correct = "-2.3"
    check $c == correct
  test "Decimal Multiplication":
    var a = newDecimal("1.2")
    var b = newDecimal("3.5")
    var c = a * b
    let correct = "4.20"
    check $c == correct
  test "Decimal Division":
    var a = newDecimal("6.25")
    var b = newDecimal("2.5")
    var c = a / b
    let correct = "2.5"
    check $c == correct
