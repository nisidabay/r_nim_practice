# 13 Niche Modules — Test It
# RunningStat: how mean and stddev change with extreme values.

import std/stats

var s: RunningStat

# Add a tight cluster
for x in [2.0, 3.0, 3.0, 4.0, 3.0, 2.0, 3.0]:
  s.push(x)

echo "After 7 values (2-4 range):"
echo "  Mean: ", s.mean
echo "  StdDev: ", s.standardDeviation

# Add an extreme outlier
s.push(100.0)
echo "\nAfter adding 100.0:"
echo "  Mean: ", s.mean
echo "  StdDev: ", s.standardDeviation

# Add another on the other side
s.push(-50.0)
echo "\nAfter adding -50.0:"
echo "  Mean: ", s.mean
echo "  StdDev: ", s.standardDeviation

# Try pushing 1000 random values and see the stats.
