.. _learning.lucene.index-structure:

Lucene Index Structure
======================

In order to fully utilize ``Zend\Search\Lucene``'s capabilities with maximum performance, you need to understand
it's internal index structure.

An **index** is stored as a set of files within a single directory.

An **index** consists of any number of independent **segments** which store information about a subset of indexed
documents. Each **segment** has its own **terms dictionary**, terms dictionary index, and document storage (stored
field values) [#]_. All segment data is stored in ``_xxxxx.cfs`` files, where **xxxxx** is a segment name.

Once an index segment file is created, it can't be updated. New documents are added to new segments. Deleted
documents are only marked as deleted in an optional ``<segmentname>.del`` file.

Document updating is performed as separate delete and add operations, even though it's done using an ``update()``
*API* call [#]_. This simplifies adding new documents, and allows updating concurrently with search operations.

On the other hand, using several segments (one document per segment as a borderline case) increases search time:

- retrieving a term from a dictionary is performed for each segment;

- the terms dictionary index is pre-loaded for each segment (this process takes the most search time for simple
  queries, and it also requires additional memory).

If the terms dictionary reaches a saturation point, then search through one segment is **N** times faster than
search through **N** segments in most cases.

**Index optimization** merges two or more segments into a single new one. A new segment is added to the index
segments list, and old segments are excluded.

Segment list updates are performed as an atomic operation. This gives the ability of concurrently adding new
documents, performing index optimization, and searching through the index.

Index auto-optimization is performed after each new segment generation. It merges sets of the smallest segments
into larger segments, and larger segments into even larger segments, if we have enough segments to merge.

Index auto-optimization is controlled by three options:

- **MaxBufferedDocs** (the minimal number of documents required before the buffered in-memory documents are written
  into a new segment);

- **MaxMergeDocs** (the largest number of documents ever merged by an optimization operation); and

- **MergeFactor** (which determines how often segment indices are merged by auto-optimization operations).

If we add one document per script execution, then **MaxBufferedDocs** is actually not used (only one new segment
with only one document is created at the end of script execution, at which time the auto-optimization process
starts).



.. [#] Starting with Lucene 2.3, document storage files can be shared between segments; however,
       ``Zend\Search\Lucene`` doesn't use this capability
.. [#] This call is provided only by Java Lucene now, but it's planned to extend the ``Zend\Search\Lucene`` *API*
       with similar functionality