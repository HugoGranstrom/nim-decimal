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
  test "Decimal Power 1":
    var a = newDecimal("2.5")
    var b = newDecimal("2")
    var c = a ^ b
    check $c == "6.25"
  test "Decimal Power 2":
    var a = newDecimal("81")
    var b = newDecimal("0.5")
    var c = a ^ b
    check $c == "9.0000000000000000000000000000000000000"
  test "Decimal divint":
    let a = newDecimal("11")
    let b = newDecimal("3")
    let c = a // b
    check $c == "3"
  test "Decimal rem":
    let a = newDecimal("11")
    let b = newDecimal("3")
    let c = rem(a, b)
    check $c == "2"
  test "Decimal divmod":
    let a = newDecimal("11")
    let b = newDecimal("3")
    let (q, r) = divmod(a, b)
    check $q == "3"
    check $r == "2"
  test "Decimal exp":
    let a = newDecimal("2")
    let c = exp(a)
    check $c == "7.3890560989306502272304274605750078132"

