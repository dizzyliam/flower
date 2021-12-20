import flower
import times

# Create a new bloom filter.
var bloom = newBloom(10000000, 0.001)

# Add a bunch of items to it.
var startTime = cpuTime()
for i in 0..<10000000:
    bloom.add(i)

# See how long that took.
echo "10M Insertions: ", cpuTime() - startTime

# Now query a bunch of items.
startTime = cpuTime()
for i in 0..<10000000:
    discard i in bloom

# See how long that took.
echo "10M Queries: ", cpuTime() - startTime

# Empty that bloom filter and create a new one.
bloom = newBloom(10000000, 0.001)
var bloom1 = newBloom(10000000, 0.001)

# Add a littler bunch of items to both.
for i in 0..<(10000000 div 2):
    bloom.add(i)
    bloom1.add(i+(10000000 div 2))

# Nerge them together
startTime = cpuTime()
bloom.merge(bloom1)

# See how long that took.
echo "Merged 5M: ", cpuTime() - startTime