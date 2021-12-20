import hashes
import bitops
import math

# The number of bits used to represent an integer.
let IntSize = (sizeof(int) * 8).uint

type

    # An array of bits of any size, stored as a sequence of ints.
    BitArray = object
        size, ints: uint
        intSeq: seq[int]
    
    # The one and only.
    Bloom* = object
        capacity, k, bits: uint
        errorRate: float
        bitArray: BitArray

# Initializes a bit array of a given size.
proc newBitArray(size: uint): BitArray =
    result.size = size
    result.ints = 1 + size div IntSize
    result.intSeq = newSeq[int](result.ints)

# Get the location of a given bit in a bit array's int sequence.
proc getLocation(index: uint): tuple[address, offset: uint] =
    return (address: index div IntSize, offset: index mod IntSize)

# Set a bit in a bit array to 1.
proc setBit(bitArray: var BitArray, index: uint) =
    let l = getLocation(index)
    bitArray.intSeq[l.address].setBit(l.offset)

# Set a bit in a bit array to 0.
proc clearBit(bitArray: var BitArray, index: uint) =
    let l = getLocation(index)
    bitArray.intSeq[l.address].clearBit(l.offset)

# Retutns true if a bit in a bit array is 1.
proc testBit(bitArray: BitArray, index: uint): bool =
    let l = getLocation(index)
    return bitArray.intSeq[l.address].testBit(l.offset)

# Initializes a bloom filter for a given error rate for a given capacity.
proc newBloom*(capacity: int, errorRate: float): Bloom =
    result.capacity = capacity.uint
    result.bits = abs((capacity.float*ln(errorRate)) / pow(ln(2.0), 2)).uint
    result.k = abs(ln(errorRate) / ln(2.0)).uint
    result.bitArray = newBitArray(result.bits)

# Iterate over k hashes of x.
iterator hashes[T](x: T, k: uint): uint =
    var cHash = hash(x)
    for i in 0..<k:
        if i != 0:
            cHash = hash(cHash)
        yield cHash.uint

# Add an item to the bloom filter, never to be retrieved >:).
proc add*[T](bloom: var Bloom, x: T) =
    for h in x.hashes(bloom.k):
        let n = h mod bloom.bitArray.size
        bloom.bitArray.setBit(n)

# Find if a bloom filter contains an item.
proc contains*[T](bloom: Bloom, x: T): bool =
    var cHash = hash(x)
    for h in x.hashes(bloom.k):
        let n = h mod bloom.bitArray.size
        
        if bloom.bitArray.testBit(n):
            continue
        else:
            return false

    return true

# Merge two bloom filters.
proc merge*(x: var Bloom, y: Bloom) =
  for index, i in y.bitArray.intSeq:
      x.bitArray.intSeq[index] = x.bitArray.intSeq[index] or i

# Another syntax.
proc union*(x, y: Bloom): Bloom =
  result = x
  result.merge(y)