/****************************************************************

The author of this software is David M. Gay.

Copyright (C) 1998 by Lucent Technologies
All Rights Reserved

Permission to use, copy, modify, and distribute this software and
its documentation for any purpose and without fee is hereby
granted, provided that the above copyright notice appear in all
copies and that both that the copyright notice and this
permission notice and warranty disclaimer appear in supporting
documentation, and that the name of Lucent or any of its entities
not be used in advertising or publicity pertaining to
distribution of the software without specific, written prior
permission.

LUCENT DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
IN NO EVENT SHALL LUCENT OR ANY OF ITS ENTITIES BE LIABLE FOR ANY
SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER
IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF
THIS SOFTWARE.

****************************************************************/

/* Please send bug reports to David M. Gay (dmg at acm dot org,
 * with " at " changed at "@" and " dot " changed to ".").	*/

#ifndef GDTOA_H_INCLUDED
#define GDTOA_H_INCLUDED

#include "arith.h"
#include <stddef.h> /* for size_t */
#include "../export.h"

#ifndef Long
#define Long int
#endif
#ifndef ULong
typedef unsigned Long ULong;
#endif
#ifndef UShort
typedef unsigned short UShort;
#endif

#ifndef ANSI
#ifdef KR_headers
#define ANSI(x) ()
#define Void /*nothing*/
#else
#define ANSI(x) x
#define Void void
#endif
#endif /* ANSI */

#ifndef CONST
#ifdef KR_headers
#define CONST /* blank */
#else
#define CONST const
#endif
#endif /* CONST */

 enum {	/* return values from strtodg */
	STRTOG_Zero	= 0,
	STRTOG_Normal	= 1,
	STRTOG_Denormal	= 2,
	STRTOG_Infinite	= 3,
	STRTOG_NaN	= 4,
	STRTOG_NaNbits	= 5,
	STRTOG_NoNumber	= 6,
	STRTOG_Retmask	= 7,

	/* The following may be or-ed into one of the above values. */

	STRTOG_Neg	= 0x08, /* does not affect STRTOG_Inexlo or STRTOG_Inexhi */
	STRTOG_Inexlo	= 0x10,	/* returned result rounded toward zero */
	STRTOG_Inexhi	= 0x20, /* returned result rounded away from zero */
	STRTOG_Inexact	= 0x30,
	STRTOG_Underflow= 0x40,
	STRTOG_Overflow	= 0x80
	};

 typedef struct
FPI {
	int nbits;
	int emin;
	int emax;
	int rounding;
	int sudden_underflow;
	int int_max;
	} FPI;

enum {	/* FPI.rounding values: same as FLT_ROUNDS */
	FPI_Round_zero = 0,
	FPI_Round_near = 1,
	FPI_Round_up = 2,
	FPI_Round_down = 3
	};

#ifdef __cplusplus
extern "C" {
#endif

PRIVATE extern char* gdtoa__dtoa  ANSI((double d, int mode, int ndigits, int *decpt,
			int *sign, char **rve));
PRIVATE extern char* gdtoa__gdtoa ANSI((FPI *fpi, int be, ULong *bits, int *kindp,
			int mode, int ndigits, int *decpt, char **rve));
PRIVATE extern void gdtoa__freedtoa ANSI((char*));
PRIVATE extern float  gdtoa__strtof ANSI((CONST char *, char **));
PRIVATE extern double gdtoa__strtod ANSI((CONST char *, char **));
PRIVATE extern int gdtoa__strtodg ANSI((CONST char*, char**, FPI*, Long*, ULong*));

PRIVATE extern char*	gdtoa__g_ddfmt   ANSI((char*, double*, int, size_t));
PRIVATE extern char*	gdtoa__g_ddfmt_p ANSI((char*, double*,	int, size_t, int));
PRIVATE extern char*	gdtoa__g_dfmt    ANSI((char*, double*, int, size_t));
PRIVATE extern char*	gdtoa__g_dfmt_p  ANSI((char*, double*,	int, size_t, int));
PRIVATE extern char*	gdtoa__g_ffmt    ANSI((char*, float*,  int, size_t));
PRIVATE extern char*	gdtoa__g_ffmt_p  ANSI((char*, float*,	int, size_t, int));
PRIVATE extern char*	gdtoa__g_Qfmt    ANSI((char*, void*,   int, size_t));
PRIVATE extern char*	gdtoa__g_Qfmt_p  ANSI((char*, void*,	int, size_t, int));
PRIVATE extern char*	gdtoa__g_xfmt    ANSI((char*, void*,   int, size_t));
PRIVATE extern char*	gdtoa__g_xfmt_p  ANSI((char*, void*,	int, size_t, int));
PRIVATE extern char*	gdtoa__g_xLfmt   ANSI((char*, void*,   int, size_t));
PRIVATE extern char*	gdtoa__g_xLfmt_p ANSI((char*, void*,	int, size_t, int));

PRIVATE extern int	gdtoa__strtoId  ANSI((CONST char*, char**, double*, double*));
PRIVATE extern int	gdtoa__strtoIdd ANSI((CONST char*, char**, double*, double*));
PRIVATE extern int	gdtoa__strtoIf  ANSI((CONST char*, char**, float*, float*));
PRIVATE extern int	gdtoa__strtoIQ  ANSI((CONST char*, char**, void*, void*));
PRIVATE extern int	gdtoa__strtoIx  ANSI((CONST char*, char**, void*, void*));
PRIVATE extern int	gdtoa__strtoIxL ANSI((CONST char*, char**, void*, void*));
PRIVATE extern int	gdtoa__strtord  ANSI((CONST char*, char**, int, double*));
PRIVATE extern int	gdtoa__strtordd ANSI((CONST char*, char**, int, double*));
PRIVATE extern int	gdtoa__strtorf  ANSI((CONST char*, char**, int, float*));
PRIVATE extern int	gdtoa__strtorQ  ANSI((CONST char*, char**, int, void*));
PRIVATE extern int	gdtoa__strtorx  ANSI((CONST char*, char**, int, void*));
PRIVATE extern int	gdtoa__strtorxL ANSI((CONST char*, char**, int, void*));
#if 1
PRIVATE extern int	gdtoa__strtodI  ANSI((CONST char*, char**, double*));
PRIVATE extern int	gdtoa__strtopd  ANSI((CONST char*, char**, double*));
PRIVATE extern int	gdtoa__strtopdd ANSI((CONST char*, char**, double*));
PRIVATE extern int	gdtoa__strtopf  ANSI((CONST char*, char**, float*));
PRIVATE extern int	gdtoa__strtopQ  ANSI((CONST char*, char**, void*));
PRIVATE extern int	gdtoa__strtopx  ANSI((CONST char*, char**, void*));
PRIVATE extern int	gdtoa__strtopxL ANSI((CONST char*, char**, void*));
#else
#define gdtoa__strtopd(s,se,x) gdtoa__strtord(s,se,1,x)
#define gdtoa__strtopdd(s,se,x) gdtoa__strtordd(s,se,1,x)
#define gdtoa__strtopf(s,se,x) gdtoa__strtorf(s,se,1,x)
#define gdtoa__strtopQ(s,se,x) gdtoa__strtorQ(s,se,1,x)
#define gdtoa__strtopx(s,se,x) gdtoa__strtorx(s,se,1,x)
#define gdtoa__strtopxL(s,se,x) gdtoa__strtorxL(s,se,1,x)
#endif

#ifdef __cplusplus
}
#endif
#endif /* GDTOA_H_INCLUDED */
