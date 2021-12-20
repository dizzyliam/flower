import flower

# Create a bloom filter.
var bloom = newBloom(1000, 0.001)

# Add two items to it.
bloom.add("string")
bloom.add(12345678)

# Make sure those two items are in it.
assert bloom.contains("string")
assert 12345678 in bloom

# Make sure these other items aren't in it.
assert not bloom.contains("other string")
assert @[01, 2, 3, 4] notin bloom