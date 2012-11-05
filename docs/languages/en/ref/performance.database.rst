.. _performance.database:

Zend_Db Performance
===================

``Zend_Db`` is a database abstraction layer, and is intended to provide a common *API* for *SQL* operations.
``Zend\Db\Table`` is a Table Data Gateway, intended to abstract common table-level database operations. Due to
their abstract nature and the "magic" they do under the hood to perform their operations, they can sometimes
introduce performance overhead.

.. _performance.database.tableMetadata:

How can I reduce overhead introduced by Zend\Db\Table for retrieving table metadata?
------------------------------------------------------------------------------------

In order to keep usage as simple as possible, and also to support constantly changing schemas during development,
``Zend\Db\Table`` does some magic under the hood: on first use, it fetches the table schema and stores it within
object members. This operation is typically expensive, regardless of the database -- which can contribute to
bottlenecks in production.

Fortunately, there are techniques for improving the situation.

.. _performance.database.tableMetadata.cache:

Use the metadata cache
^^^^^^^^^^^^^^^^^^^^^^

``Zend\Db\Table`` can optionally utilize ``Zend_Cache`` to cache table metadata. This is typically faster to access
and less expensive than fetching the metadata from the database itself.

The :ref:`Zend\Db\Table documentation includes information on metadata caching <zend.db.table.metadata.caching>`.

.. _performance.database.tableMetadata.hardcoding:

Hardcode your metadata in the table definition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As of 1.7.0, ``Zend\Db\Table`` also provides :ref:`support for hardcoding metadata in the table definition
<zend.db.table.metadata.caching.hardcoding>`. This is an advanced use case, and should only be used when you know
the table schema is unlikely to change, or that you're able to keep the definitions up-to-date.

.. _performance.database.select:

SQL generated with Zend\Db\Select s not hitting my indexes; how can I make it better?
-------------------------------------------------------------------------------------

``Zend\Db\Select`` is relatively good at its job. However, if you are performing complex queries requiring joins or
sub-selects, it can often be fairly naive.

.. _performance.database.select.writeyourown:

Write your own tuned SQL
^^^^^^^^^^^^^^^^^^^^^^^^

The only real answer is to write your own *SQL*; ``Zend_Db`` does not require the usage of ``Zend\Db\Select``, so
providing your own, tuned *SQL* select statements is a perfectly legitimate approach,

Run ``EXPLAIN`` on your queries, and test a variety of approaches until you can reliably hit your indices in the
most performant way -- and then hardcode the *SQL* as a class property or constant.

If the *SQL* requires variable arguments, provide placeholders in the *SQL*, and utilize a combination of
``vsprintf()`` and ``array_walk()`` to inject the values into the *SQL*:

.. code-block:: php
   :linenos:

   // $adapter is the DB adapter. In Zend\Db\Table, retrieve
   // it using $this->getAdapter().
   $sql = vsprintf(
       self::SELECT_FOO,
       array_walk($values, array($adapter, 'quoteInto'))
   );


