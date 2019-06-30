# Decimal
# Copyright (c) 2018 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

import decimal_lowlevel

type 
    DecimalType = ref[ptr mpd_t]
    DecimalError = object of Exception

const
    DEFAULT_PREC = MPD_RDIGITS * 2
    DEFAULT_EMAX = when (sizeof(int) == 8): 999999999999999999 else: 425000000
    DEFAULT_EMIN = when (sizeof(int) == 8): -999999999999999999 else: -425000000

var CTX: mpd_context_t
var CTX_ADDR = addr CTX
mpd_defaultcontext(CTX_ADDR)

proc setPrec*(prec: int) =
    if 0 < prec:
        let success = mpd_qsetprec(CTX_ADDR, prec)
        if success == 0:
            raise newException(DecimalError, "Couldn't set precision")

proc `$`*(s: DecimalType): cstring = mpd_to_sci(s[], 0)

proc newDecimal*(): DecimalType = 
    new[ptr mpd_t](result)
    result[] = mpd_qnew()

proc newDecimal*(s: string): DecimalType =
    new[ptr mpd_t](result)
    result[] = mpd_qnew()
    mpd_set_string(result[], s, CTX_ADDR)

proc newDecimal*(s: int64): DecimalType =
    new[ptr mpd_t](result)
    result[] = mpd_qnew()
    mpd_set_i64(result[], s, CTX_ADDR)

proc newDecimal*(s: int32): DecimalType =
    result[] = mpd_qnew()
    mpd_set_i32(result[], s, CTX_ADDR)

proc clone*(b: DecimalType): DecimalType =
    result = newDecimal()
    var status: uint32
    let success = mpd_qcopy(result[], b[], addr status)
    if success == 0:
        raise newException(DecimalError, "Decimal failed to copy")

proc `+`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qadd(result[], a[], b[], CTX_ADDR, addr status)

proc `+=`*(a, b: DecimalType) =
    var status: uint32
    mpd_qadd(a[], a[], b[], CTX_ADDR, addr status)

proc `-`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qsub(result[], a[], b[], CTX_ADDR, addr status)

proc `-=`*(a, b: DecimalType) =
    var status: uint32
    mpd_qsub(a[], a[], b[], CTX_ADDR, addr status)

proc `*`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qmul(result[], a[], b[], CTX_ADDR, addr status)

proc `*=`*(a, b: DecimalType) =
    var status: uint32
    mpd_qmul(a[], a[], b[], CTX_ADDR, addr status)

proc `/`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qdiv(result[], a[], b[], CTX_ADDR, addr status)

proc `/=`*(a, b: DecimalType) =
    var status: uint32
    mpd_qdiv(a[], a[], b[], CTX_ADDR, addr status)

proc `^`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qpow(result[], a[], b[], CTX_ADDR, addr status)

proc divint*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qdivint(result[], a[], b[], CTX_ADDR, addr status)

proc `//`*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qdivint(result[], a[], b[], CTX_ADDR, addr status)

proc rem*(a, b: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qrem(result[], a[], b[], CTX_ADDR, addr status)

proc divmod*(a, b: DecimalType): (DecimalType, DecimalType) =
    var status: uint32
    var q = newDecimal()
    var r = newDecimal()
    mpd_qdivmod(q[], r[], a[], b[], CTX_ADDR, addr status)
    result = (q, r)


proc exp*(a: DecimalType): DecimalType =
    var status: uint32
    result = newDecimal()
    mpd_qexp(result[], a[], CTX_ADDR, addr status)

