# Decimal
# Copyright (c) 2018 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

import decimal_lowlevel

type 
    DecimalType* = ref[ptr mpd_t]
    DecimalError* = object of Exception

const
    DEFAULT_PREC = MPD_RDIGITS * 2
    DEFAULT_EMAX = when (sizeof(int) == 8): 999999999999999999 else: 425000000
    DEFAULT_EMIN = when (sizeof(int) == 8): -999999999999999999 else: -425000000

var CTX: mpd_context_t
var CTX_ADDR = addr CTX
mpd_defaultcontext(CTX_ADDR)

proc setPrec*(prec: mpd_ssize_t) =
    if 0 < prec:
        let success = mpd_qsetprec(CTX_ADDR, prec)
        if success == 0:
            raise newException(DecimalError, "Couldn't set precision")

proc `$`*(s: DecimalType): string =
    $mpd_to_sci(s[], 0)

proc newDecimal*(): DecimalType = 
    new result
    result[] = mpd_qnew()

proc newDecimal*(s: string): DecimalType =
    new result
    result[] = mpd_qnew()
    mpd_set_string(result[], s, CTX_ADDR)

proc newDecimal*(s: int64): DecimalType =
    new result
    result[] = mpd_qnew()
    mpd_set_i64(result[], s, CTX_ADDR)

proc newDecimal*(s: int32): DecimalType =
    new result
    result[] = mpd_qnew()
    mpd_set_i32(result[], s, CTX_ADDR)

proc clone*(b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    let success = mpd_qcopy(result[], b[], addr status)
    if success == 0:
        raise newException(DecimalError, "Decimal failed to copy")

# Operators

proc `+`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qadd(result[], a[], b[], CTX_ADDR, addr status)

template `+`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a + newDecimal($b)

template `+`*[T: SomeNumber](a: T, b: DecimalType): untyped =
    newDecimal($a) + b

proc `+=`*(a, b: DecimalType) =
    var status: uint32
    mpd_qadd(a[], a[], b[], CTX_ADDR, addr status)

template `+=`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a += newDecimal($b)
    


proc `-`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qsub(result[], a[], b[], CTX_ADDR, addr status)

template `-`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a - newDecimal($b)

template `-`*[T: SomeNumber](a: T, b: DecimalType): untyped =
    newDecimal($a) - b

proc `-=`*(a, b: DecimalType) =
    var status: uint32
    mpd_qsub(a[], a[], b[], CTX_ADDR, addr status)

template `-=`*[T: SomeNumber](a: DecimalType, b: T) =
    a -= newDecimal($b)


proc `*`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qmul(result[], a[], b[], CTX_ADDR, addr status)

template `*`*[T: SomeNumber](a: T, b: DecimalType): untyped =
    newDecimal($a) * b

template `*`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    newDecimal($b) * a

proc `*=`*(a, b: DecimalType) =
    var status: uint32
    mpd_qmul(a[], a[], b[], CTX_ADDR, addr status)

template `*=`*[T: SomeNumber](a: DecimalType, b: T) =
    a *= newDecimal($b)



proc `/`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qdiv(result[], a[], b[], CTX_ADDR, addr status)

template `/`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a / newDecimal($b)

proc `/=`*(a, b: DecimalType) =
    var status: uint32
    mpd_qdiv(a[], a[], b[], CTX_ADDR, addr status)

template `/=`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a /= newDecimal($b)



proc `//`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qdivint(result[], a[], b[], CTX_ADDR, addr status)

template `//`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a // newDecimal($b)

proc `^`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qpow(result[], a[], b[], CTX_ADDR, addr status)

template `^`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a ^ newDecimal($b)

proc `==`*(a, b: DecimalType): bool =
    var status: uint32
    let cmp = mpd_qcmp(a[], b[], addr status)
    if cmp == 0:
        return true
    else:
        return false

template `==`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a == newDecimal($b)

template `==`*[T: SomeNumber](a: T, b: DecimalType): untyped =
    newDecimal($a) == b

proc `<`*(a, b: DecimalType): bool =
    var status: uint32
    let cmp = mpd_qcmp(a[], b[], addr status)
    if cmp == -1:
        return true
    else:
        return false

template `<`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a < newDecimal($b)
template `<`*[T: SomeNumber](a: T, b: DecimalType): untyped =
    newDecimal($a) < b

proc `<=`*(a, b: DecimalType): bool =
    let less_cmp = a < b
    if less_cmp: return true
    let equal_cmp = a == b
    if equal_cmp: return true
    return false
template `<=`*[T: SomeNumber](a: DecimalType, b: T): untyped =
    a <= newDecimal($b)
template `<=`*[T: SomeNumber](a: T, b: DecimalType): untyped =
    newDecimal($a) <= b



proc divint*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qdivint(result[], a[], b[], CTX_ADDR, addr status)

proc rem*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qrem(result[], a[], b[], CTX_ADDR, addr status)

proc rem_near*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qrem_near(result[], a[], b[], CTX_ADDR, addr status)

proc divmod*(a, b: DecimalType): (DecimalType, DecimalType) =
    var status: uint32
    var q = newDecimal()
    var r = newDecimal()
    mpd_qdivmod(q[], r[], a[], b[], CTX_ADDR, addr status)
    result = (q, r)

proc fma*(a, b, c: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qfma(result[], a[], b[], c[], CTX_ADDR, addr status)


# Math functions

proc exp*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qexp(result[], a[], CTX_ADDR, addr status)

proc ln*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qln(result[], a[], CTX_ADDR, addr status)

proc log10*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qlog10(result[], a[], CTX_ADDR, addr status)

proc sqrt*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qsqrt(result[], a[], CTX_ADDR, addr status)

proc invroot*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qinvroot(result[], a[], CTX_ADDR, addr status)



proc `-`*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qminus(result[], a[], CTX_ADDR, addr status)

proc plus*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qplus(result[], a[], CTX_ADDR, addr status)

proc abs*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qabs(result[], a[], CTX_ADDR, addr status)



proc max*(a,b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qmax(result[], a[], b[], CTX_ADDR, addr status)

proc max_mag*(a,b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qmax_mag(result[], a[], b[], CTX_ADDR, addr status)

proc min*(a,b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qmin(result[], a[], b[], CTX_ADDR, addr status)

proc min_mag*(a,b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qmin_mag(result[], a[], b[], CTX_ADDR, addr status)

proc next_plus*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qnext_plus(result[], a[], CTX_ADDR, addr status)

proc next_minus*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qnext_minus(result[], a[], CTX_ADDR, addr status)

proc next_toward*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qnext_toward(result[], a[], b[], CTX_ADDR, addr status)

proc quantize*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qquantize(result[], a[], b[], CTX_ADDR, addr status)

proc rescale*(a: DecimalType, b: mpd_ssize_t): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qrescale(result[], a[], b, CTX_ADDR, addr status)

proc same_quantum*(a, b: DecimalType): bool =
    let cmp = mpd_same_quantum(a[], b[])
    if cmp == 1:
        return true
    else:
        return false

proc reduce*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qreduce(result[], a[], CTX_ADDR, addr status)

proc round_to_intx*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qround_to_intx(result[], a[], CTX_ADDR, addr status)

proc round_to_int*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qround_to_int(result[], a[], CTX_ADDR, addr status)

proc floor*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qfloor(result[], a[], CTX_ADDR, addr status)

proc ceil*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qceil(result[], a[], CTX_ADDR, addr status)

proc truncate*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qtrunc(result[], a[], CTX_ADDR, addr status)

proc logb*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qlogb(result[], a[], CTX_ADDR, addr status)

proc scaleb*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qscaleb(result[], a[], b[], CTX_ADDR, addr status)

proc powmod*(base, exp, modulus: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qpowmod(result[], base[], exp[], modulus[], CTX_ADDR, addr status)