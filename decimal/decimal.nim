# Decimal
# Copyright (c) 2018 Status Research & Development GmbH
# Licensed and distributed under either of
#   * MIT license (license terms in the root directory or at http://opensource.org/licenses/MIT).
#   * Apache v2 license (license terms in the root directory or at http://www.apache.org/licenses/LICENSE-2.0).
# at your option. This file may not be copied, modified, or distributed except according to those terms.

import decimal_lowlevel

type 
    DecimalType = ref[ptr mpd_t]

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
            echo "Bad prec" 

proc `$`*(s: DecimalType): cstring = mpd_to_sci(s, 0)

proc newDecimal*(): DecimalType = mpd_new(CTX_ADDR)

proc newDecimal*(s: string): DecimalType =
    result = mpd_new(CTX_ADDR)
    mpd_set_string(result, s, CTX_ADDR)

proc newDecimal*(s: int64): DecimalType =
    result = mpd_new(CTX_ADDR)
    mpd_set_i64(result, s, CTX_ADDR)

proc newDecimal*(s: int32): DecimalType =
    result = mpd_new(CTX_ADDR)
    mpd_set_i32(result, s, CTX_ADDR)

proc clone*(b: DecimalType): DecimalType =
    result = newDecimal()
    mpd_copy(result, b, CTX_ADDR)

proc `+`*(a, b: DecimalType): DecimalType =
    result = newDecimal()
    mpd_add(result, a, b, CTX_ADDR)

proc `+=`*(a, b: DecimalType) =
    mpd_add(a, a, b, CTX_ADDR)

proc `-`*(a, b: DecimalType): DecimalType =
    result = newDecimal()
    mpd_sub(result, a, b, CTX_ADDR)

proc `-=`*(a, b: DecimalType) =
    mpd_sub(a, a, b, CTX_ADDR)

proc `*`*(a, b: DecimalType): DecimalType =
    result = newDecimal()
    mpd_mul(result, a, b, CTX_ADDR)

proc `*=`*(a, b: DecimalType) =
    mpd_mul(a, a, b, CTX_ADDR)

proc `/`*(a, b: DecimalType): DecimalType =
    result = newDecimal()
    mpd_div(result, a, b, CTX_ADDR)

proc `/=`*(a, b: DecimalType) =
    mpd_div(a, a, b, CTX_ADDR)

proc `^`*(a, b: DecimalType): DecimalType =
    result = newDecimal()
    mpd_pow(result, a, b, CTX_ADDR)

proc divint*(a, b: DecimalType): DecimalType =
    result = newDecimal()
    mpd_divint(result, a, b, CTX_ADDR)

proc `//`*(a, b: DecimalType): DecimalType =
    result = newDecimal()
    mpd_divint(result, a, b, CTX_ADDR)

proc rem*(a, b: DecimalType): DecimalType =
    result = newDecimal()
    mpd_rem(result, a, b, CTX_ADDR)

proc divmod*(a, b: DecimalType): (DecimalType, DecimalType) =
    let q = newDecimal()
    let r = newDecimal()
    mpd_divmod(q, r, a, b, CTX_ADDR)
    result = (q, r)


proc exp*(a: DecimalType): DecimalType =
    result = newDecimal()
    mpd_exp(result, a, CTX_ADDR)

