# SBBT
 Self Balancing Binary Tree for PureBasic.
 
A self-balancing binary tree based on the AA-Tree data structure as defined by Arne Andersson.
https://en.wikipedia.org/wiki/Search_tree
http://en.wikipedia.org/wiki/AA_tree
A self-balancing tree keeps its height to the minimum, so its lookup operations are faster and it does not degenerate into a list in case it's feeded with a sorted input.

Insertions and deletions are costly operations compared to other data structures, anyway it has some advantages:

Its height is constantly optimized so lookups are very vast and require few iterations.
It is kept in a constantly sorted state.
The whole tree can be traversed in ascending or descending order.
It's possibile to enumerate in a orderly fashion the keys before or after the current one, for example after a lookup operation.
Its lowest and highest keys are immediately accessible.

This implementation supports insertion, search, deletion, enumeration in ascending/descending order and manual navigation. 
Can be used with just the key (a string or an integer) or with an optional value associated to the key. 
You can use that value to store a pointer to a complex data structure, or use it as a counter or anything else.
All the keys must be UNIQUE.

