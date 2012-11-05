.. _learning.lucene.index-opening:

Index Opening and Creation
==========================

All index operations (e.g., creating a new index, adding a document to the index, deleting a document, searching
through the index) need an index object. One can be obtained using one of the following two methods.

.. _learning.lucene.index-opening.creation:

.. rubric:: Lucene Index Creation

.. code-block:: php
   :linenos:

   $index = Zend\Search\Lucene::create($indexPath);

.. _learning.lucene.index-opening.opening:

.. rubric:: Lucene Index Opening

.. code-block:: php
   :linenos:

   $index = Zend\Search\Lucene::open($indexPath);


