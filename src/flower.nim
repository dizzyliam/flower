## A pure Nim bloom filter.

import hashes
import bitops
import math

# The number of bits used to represent an integer.
let IntSize = (sizeof(int) * 8).uint

type

    BitArray = object
        ## An array of bits of any size, stored as a sequence of ints.
        size, ints: uint
        intSeq: seq[int]
    
    Bloom* = object
        ## A bloom filter, representing a set.
        capacity, k, bits: uint
        errorRate: float
        bitArray: BitArray

proc newBitArray(size: uint): BitArray =
    ## Initializes a bit array of a given size.
    result.size = size
    result.ints = 1 + size div IntSize
    result.intSeq = newSeq[int](result.ints)

proc getLocation(index: uint): tuple[address, offset: uint] =
    ## Get the location of a given bit in a bit array's int sequence.
    return (address: index div IntSize, offset: index mod IntSize)

proc setBit(bitArray: var BitArray, index: uint) =
    ## Set a bit in a bit array to 1.
    let l = getLocation(index)
    bitArray.intSeq[l.address].setBit(l.offset)

proc clearBit(bitArray: var BitArray, index: uint) =
    ## Set a bit in a bit array to 0.
    let l = getLocation(index)
    bitArray.intSeq[l.address].clearBit(l.offset)

proc testBit(bitArray: BitArray, index: uint): bool =
    ## Retutns true if a bit in a bit array is 1.
    let l = getLocation(index)
    return bitArray.intSeq[l.address].testBit(l.offset)

proc newBloom*(capacity: int, errorRate: float): Bloom =
    ## Initializes a bloom filter for a given error rate at a given capacity.
    result.capacity = capacity.uint
    result.bits = abs((capacity.float*ln(errorRate)) / pow(ln(2.0), 2)).uint
    result.k = abs(ln(errorRate) / ln(2.0)).uint
    result.bitArray = newBitArray(result.bits)

iterator hashes[T](x: T, k: uint): uint =
    ## Iterate over k hashes of x.
    var cHash = hash(x)
    for i in 0..<k:
        if i != 0:
            cHash = hash(cHash)
        yield cHash.uint

proc add*[T](bloom: var Bloom, x: T) =
    ## Add an item to the set represented by a bloom filter.
    for h in x.hashes(bloom.k):
        let n = h mod bloom.bitArray.size
        bloom.bitArray.setBit(n)

proc contains*[T](bloom: Bloom, x: T): bool =
    ## Test if an item is in the set represented by a bloom filter.
    ## If false, it's definately not in the set.
    ## If true, there's a `1 - errorRate` chance it's in the set.
    var cHash = hash(x)
    for h in x.hashes(bloom.k):
        let n = h mod bloom.bitArray.size
        
        if bloom.bitArray.testBit(n):
            continue
        else:
            return false

    return true

proc merge*(x: var Bloom, y: Bloom) =
    ## Merge the set represented a bloom filter into another.
    for index, i in y.bitArray.intSeq:
        x.bitArray.intSeq[index] = x.bitArray.intSeq[index] or i

proc union*(x, y: Bloom): Bloom =
    ## Merge the sets represented by two bloom filters in place.
    result = x
    result.merge(y)