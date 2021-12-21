# f l o w e r

*A pure Nim bloom filter.*

> A Bloom filter is a space-efficient probabilistic data structure, conceived by Burton Howard Bloom in 1970, that is used to test whether an element is a member of a set. False positive matches are possible, but false negatives are not – in other words, a query returns either "possibly in set" or "definitely not in set".  *-- Wikipedia*

```Nim
import flower

let bloom = newBloom(capacity = 1e7.int, errorRate = 0.001)

bloom.add("string")
bloom.add(12345678)

assert "string" in bloom
assert "not" notin bloom
```

## p a r a m e t e r s
The two arguments passed when creating a bloom filter are used to decide the best parameters for the filter, so that the false-positive rate will equal `errorRate` when the number of added items is `capacity`. If excess items are added, the filter will continue to function, but the false-positive rate will increase.

## d a t a t y p e s
Flower uses [std/hashes](https://nim-lang.org/docs/hashes.html) for creating the k-hashes, so all built-in types are supported, and it's easy to add support for your own.

## p r o c s

* `proc newBloom(capacity: int, errorRate: float): Bloom`
* `proc add[T](bloom: var Bloom, x: T)`
* `proc contains[T](bloom: var Bloom, x: T): bool`
* `proc union(x, y: Bloom): Bloom`
* `proc merge(x: var Bloom, y: Bloom)`
