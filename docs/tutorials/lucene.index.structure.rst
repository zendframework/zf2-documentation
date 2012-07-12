
Lucene Index Structure
======================

In order to fully utilize ``Zend_Search_Lucene`` 's capabilities with maximum performance, you need to understand it's internal index structure.

Anindexis stored as a set of files within a single directory.

Anindexconsists of any number of independentsegmentswhich store information about a subset of indexed documents. Eachsegmenthas its ownterms dictionary, terms dictionary index, and document storage (stored field values)
Starting with Lucene 2.3, document storage files can be shared between segments; however, ``Zend_Search_Lucene`` doesn't use this capability
. All segment data is stored in ``_xxxxx.cfs`` files, wherexxxxxis a segment name.

Once an index segment file is created, it can't be updated. New documents are added to new segments. Deleted documents are only marked as deleted in an optional ``<segmentname>.del`` file.

Document updating is performed as separate delete and add operations, even though it's done using an ``update()``  *API* call
This call is provided only by Java Lucene now, but it's planned to extend the ``Zend_Search_Lucene``  *API* with similar functionality
. This simplifies adding new documents, and allows updating concurrently with search operations.

On the other hand, using several segments (one document per segment as a borderline case) increases search time:

If the terms dictionary reaches a saturation point, then search through one segment isNtimes faster than search throughNsegments in most cases.

Index optimizationmerges two or more segments into a single new one. A new segment is added to the index segments list, and old segments are excluded.

Segment list updates are performed as an atomic operation. This gives the ability of concurrently adding new documents, performing index optimization, and searching through the index.

Index auto-optimization is performed after each new segment generation. It merges sets of the smallest segments into larger segments, and larger segments into even larger segments, if we have enough segments to merge.

Index auto-optimization is controlled by three options:

If we add one document per script execution, thenMaxBufferedDocsis actually not used (only one new segment with only one document is created at the end of script execution, at which time the auto-optimization process starts).


