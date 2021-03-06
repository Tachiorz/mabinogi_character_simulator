#!/usr/bin/python

## a C -> python translation of MT19937, original license below ##

##  A C-program for MT19937: Real number version
##    genrand() generates one pseudorandom real number (double)
##  which is uniformly distributed on [0,1]-interval, for each
##  call. sgenrand(seed) set initial values to the working area
##  of 624 words. Before genrand(), sgenrand(seed) must be
##  called once. (seed is any 32-bit integer except for 0).
##  Integer generator is obtained by modifying two lines.
##    Coded by Takuji Nishimura, considering the suggestions by
##  Topher Cooper and Marc Rieffel in July-Aug. 1997.

##  This library is free software; you can redistribute it and/or
##  modify it under the terms of the GNU Library General Public
##  License as published by the Free Software Foundation; either
##  version 2 of the License, or (at your option) any later
##  version.
##  This library is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##  See the GNU Library General Public License for more details.
##  You should have received a copy of the GNU Library General
##  Public License along with this library; if not, write to the
##  Free Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
##  02111-1307  USA

##  Copyright (C) 1997 Makoto Matsumoto and Takuji Nishimura.
##  Any feedback is very welcome. For any question, comments,
##  see http://www.math.keio.ac.jp/matumoto/emt.html or email
##  matumoto@math.keio.ac.jp

# Period parameters
N = 624
M = 397
MATRIX_A = 0x9908b0dfL   # constant vector a
UPPER_MASK = 0x80000000L # most significant w-r bits
LOWER_MASK = 0x7fffffffL # least significant r bits

# Tempering parameters
TEMPERING_MASK_B = 0x9d2c5680L
TEMPERING_MASK_C = 0xefc60000L

def TEMPERING_SHIFT_U(y):
    return (y >> 11)

def TEMPERING_SHIFT_S(y):
    return (y << 7)

def TEMPERING_SHIFT_T(y):
    return (y << 15)

def TEMPERING_SHIFT_L(y):
    return (y >> 18)

mt = []   # the array for the state vector
mti = N+1 # mti==N+1 means mt[N] is not initialized

# initializing the array with a NONZERO seed
def sgenrand(seed):
    # setting initial seeds to mt[N] using
    # the generator Line 25 of Table 1 in
    # [KNUTH 1981, The Art of Computer Programming
    #    Vol. 2 (2nd Ed.), pp102]

    global mt, mti

    mt = list()

    mt.append(seed & 0xffffffffL)
    i = 0
    for i in xrange(1, N + 1):
        mt.append((0x6C078965L * (mt[i-1] ^ (mt[i-1] >> 30)) + i ) & 0xffffffffL)
    mti = i
# end sgenrand


def genrand():
    global mt, mti

    mag01 = [0x0L, MATRIX_A]
    # mag01[x] = x * MATRIX_A  for x=0,1

    if mti >= N: # generate N words at one time
        if mti == N+1:   # if sgenrand() has not been called,
            sgenrand(5489) # a default initial seed is used
        kk = 0
        for kk in xrange((N-M)):
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK)
            mt[kk] = mt[kk+M] ^ (y >> 1) ^ mag01[y & 0x1]

        for kk in xrange(kk+1, N-1):
            y = (mt[kk]&UPPER_MASK)|(mt[kk+1]&LOWER_MASK)
            mt[kk] = mt[kk+(M-N)] ^ (y >> 1) ^ mag01[y & 0x1]

        y = (mt[N-1]&UPPER_MASK)|(mt[0]&LOWER_MASK)
        mt[N-1] = mt[M-1] ^ (y >> 1) ^ mag01[y & 0x1]

        mti = 0

    y = mt[mti]
    mti += 1
    y ^= TEMPERING_SHIFT_U(y)
    y ^= TEMPERING_SHIFT_S(y) & TEMPERING_MASK_B
    y ^= TEMPERING_SHIFT_T(y) & TEMPERING_MASK_C
    y ^= TEMPERING_SHIFT_L(y)

    return y