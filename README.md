# SBBT
 Self Balancing Binary Tree (1.20) for PureBasic.
 
A self-balancing binary tree based on the AA-Tree data structure as defined by Arne Andersson.<br>
http://en.wikipedia.org/wiki/AA_tree<br>

A self-balancing tree keeps its height to the minimum, so its lookup operations are faster and it does not degenerate into a list in case it has been fed with a sorted input.<br>
Insertions and deletions are costly operations compared to other data structures, anyway it has some advantages:<br>

- Its height is constantly optimized so lookups are very fast and require few iterations.<br>
- It is kept in a constantly sorted state.<br>
- The whole tree can be traversed in ascending or descending order.<br>
- It's possibile to enumerate in a orderly fashion the keys before or after the current one, for example after a lookup operation.<br>
- Its lowest and highest keys are immediately accessible.<br>

This implementation supports insertion, search, deletion, enumeration in ascending/descending order and manual navigation. <br>
Can be used with just the key (a string or an integer) or with an optional value associated to the key.<br>
You can use that value to store a pointer to a complex data structure, or use it as a counter or anything else.<br>
All the keys must be UNIQUE.<br>

