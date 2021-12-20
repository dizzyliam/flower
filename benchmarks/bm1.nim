import flower
import times

# Create a new bloom filter.
var bloom = newBloom(10000000, 0.001)

# Add a bunch of items to it.
var startTime = cpuTime()
for i in 0..<1e7.int:
    bloom.add(i)

# See how long that took.
echo "10M Insertions: ", cpuTime() - startTime

# Now query a bunch of items.
startTime = cpuTime()
for i in 0..<1e7.int:
    discard i in bloom

# See how long that took.
echo "10M Queries: ", cpuTime() - startTime

# Empty that bloom filter and create a new one.
bloom = newBloom(1e7.int, 0.001)
var bloom1 = newBloom(1e7.int, 0.001)

# Add a littler bunch of items to both.
for i in 0..<0.5e7.int:
    bloom.add(i)
    bloom1.add(i+0.5e7.int)

# Nerge them together
startTime = cpuTime()
bloom.merge(bloom1)

# See how long that took.
echo "Merged 5M: ", cpuTime() - startTime