.. _zend.db.table.relationships:

Zend_Db_Table Relationships
===========================

.. _zend.db.table.relationships.introduction:

Introduction
------------

Tables have relationships to each other in a relational database. An entity in one table can be linked to one or
more entities in another table by using referential integrity constraints defined in the database schema.

The ``Zend_Db_Table_Row`` class has methods for querying related rows in other tables.

.. _zend.db.table.relationships.defining:

Defining Relationships
----------------------

Define classes for each of your tables, extending the abstract class ``Zend_Db_Table_Abstract``, as described in
:ref:` <zend.db.table.defining>`. Also see :ref:` <zend.db.adapter.example-database>` for a description of the
example database for which the following example code is designed.

Below are the *PHP* class definitions for these tables:

.. code-block:: php
   :linenos:

   class Accounts extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'accounts';
       protected $_dependentTables = array('Bugs');
   }

   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'products';
       protected $_dependentTables = array('BugsProducts');
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'bugs';

       protected $_dependentTables = array('BugsProducts');

       protected $_referenceMap    = array(
           'Reporter' => array(
               'columns'           => 'reported_by',
               'refTableClass'     => 'Accounts',
               'refColumns'        => 'account_name'
           ),
           'Engineer' => array(
               'columns'           => 'assigned_to',
               'refTableClass'     => 'Accounts',
               'refColumns'        => 'account_name'
           ),
           'Verifier' => array(
               'columns'           => array('verified_by'),
               'refTableClass'     => 'Accounts',
               'refColumns'        => array('account_name')
           )
       );
   }

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs_products';

       protected $_referenceMap    = array(
           'Bug' => array(
               'columns'           => array('bug_id'),
               'refTableClass'     => 'Bugs',
               'refColumns'        => array('bug_id')
           ),
           'Product' => array(
               'columns'           => array('product_id'),
               'refTableClass'     => 'Products',
               'refColumns'        => array('product_id')
           )
       );

   }

If you use ``Zend_Db_Table`` to emulate cascading UPDATE and DELETE operations, declare the ``$_dependentTables``
array in the class for the parent table. List the class name for each dependent table. Use the class name, not the
physical name of the *SQL* table.

.. note::

   Skip declaration of ``$_dependentTables`` if you use referential integrity constraints in the *RDBMS* server to
   implement cascading operations. See :ref:` <zend.db.table.relationships.cascading>` for more information.

Declare the ``$_referenceMap`` array in the class for each dependent table. This is an associative array of
reference "rules". A reference rule identifies which table is the parent table in the relationship, and also lists
which columns in the dependent table reference which columns in the parent table.

The rule key is a string used as an index to the ``$_referenceMap`` array. This rule key is used to identify each
reference relationship. Choose a descriptive name for this rule key. It's best to use a string that can be part of
a *PHP* method name, as you will see later.

In the example *PHP* code above, the rule keys in the Bugs table class are: *'Reporter'*, *'Engineer'*,
*'Verifier'*, and *'Product'*.

The value of each rule entry in the ``$_referenceMap`` array is also an associative array. The elements of this
rule entry are described below:

- **columns** => A string or an array of strings naming the foreign key column name(s) in the dependent table.

  It's common for this to be a single column, but some tables have multi-column keys.

- **refTableClass** => The class name of the parent table. Use the class name, not the physical name of the *SQL*
  table.

  It's common for a dependent table to have only one reference to its parent table, but some tables have multiple
  references to the same parent table. In the example database, there is one reference from the *bugs* table to the
  *products* table, but three references from the *bugs* table to the *accounts* table. Put each reference in a
  separate entry in the ``$_referenceMap`` array.

- **refColumns** => A string or an array of strings naming the primary key column name(s) in the parent table.

  It's common for this to be a single column, but some tables have multi-column keys. If the reference uses a
  multi-column key, the order of columns in the *'columns'* entry must match the order of columns in the
  *'refColumns'* entry.

  It is optional to specify this element. If you don't specify the *refColumns*, the column(s) reported as the
  primary key columns of the parent table are used by default.

- **onDelete** => The rule for an action to execute if a row is deleted in the parent table. See :ref:`
  <zend.db.table.relationships.cascading>` for more information.

- **onUpdate** => The rule for an action to execute if values in primary key columns are updated in the parent
  table. See :ref:` <zend.db.table.relationships.cascading>` for more information.

.. _zend.db.table.relationships.fetching.dependent:

Fetching a Dependent Rowset
---------------------------

If you have a Row object as the result of a query on a parent table, you can fetch rows from dependent tables that
reference the current row. Use the method:

.. code-block:: php
   :linenos:

   $row->findDependentRowset($table, [$rule]);

This method returns a ``Zend_Db_Table_Rowset_Abstract`` object, containing a set of rows from the dependent table
``$table`` that refer to the row identified by the ``$row`` object.

The first argument ``$table`` can be a string that specifies the dependent table by its class name. You can also
specify the dependent table by using an object of that table class.

.. _zend.db.table.relationships.fetching.dependent.example:

.. rubric:: Fetching a Dependent Rowset

This example shows getting a Row object from the table *Accounts*, and finding the *Bugs* reported by that account.

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();

   $bugsReportedByUser = $user1234->findDependentRowset('Bugs');

The second argument ``$rule`` is optional. It is a string that names the rule key in the ``$_referenceMap`` array
of the dependent table class. If you don't specify a rule, the first rule in the array that references the parent
table is used. If you need to use a rule other than the first, you need to specify the key.

In the example code above, the rule key is not specified, so the rule used by default is the first one that matches
the parent table. This is the rule *'Reporter'*.

.. _zend.db.table.relationships.fetching.dependent.example-by:

.. rubric:: Fetching a Dependent Rowset By a Specific Rule

This example shows getting a Row object from the table *Accounts*, and finding the *Bugs* assigned to be fixed by
the user of that account. The rule key string that corresponds to this reference relationship in this example is
*'Engineer'*.

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();

   $bugsAssignedToUser = $user1234->findDependentRowset('Bugs', 'Engineer');

You can also add criteria, ordering and limits to your relationships using the parent row's select object.





      .. _zend.db.table.relationships.fetching.dependent.example-by-select:

      .. rubric:: Fetching a Dependent Rowset using a Zend_Db_Table_Select

      This example shows getting a Row object from the table *Accounts*, and finding the *Bugs* assigned to be
      fixed by the user of that account, limited only to 3 rows and ordered by name.

      .. code-block:: php
         :linenos:

         $accountsTable = new Accounts();
         $accountsRowset = $accountsTable->find(1234);
         $user1234 = $accountsRowset->current();
         $select = $accountsTable->select()->order('name ASC')
                                           ->limit(3);

         $bugsAssignedToUser = $user1234->findDependentRowset('Bugs',
                                                              'Engineer',
                                                              $select);

Alternatively, you can query rows from a dependent table using a special mechanism called a "magic method".
``Zend_Db_Table_Row_Abstract`` invokes the method: ``findDependentRowset('<TableClass>', '<Rule>')`` if you invoke
a method on the Row object matching either of the following patterns:



- *$row->find<TableClass>()*

- *$row->find<TableClass>By<Rule>()*

In the patterns above, *<TableClass>* and *<Rule>* are strings that correspond to the class name of the dependent
table, and the dependent table's rule key that references the parent table.

.. note::

   Some application frameworks, such as Ruby on Rails, use a mechanism called "inflection" to allow the spelling of
   identifiers to change depending on usage. For simplicity, ``Zend_Db_Table_Row`` does not provide any inflection
   mechanism. The table identity and the rule key named in the method call must match the spelling of the class and
   rule key exactly.

.. _zend.db.table.relationships.fetching.dependent.example-magic:

.. rubric:: Fetching Dependent Rowsets using the Magic Method

This example shows finding dependent Rowsets equivalent to those in the previous examples. In this case, the
application uses the magic method invocation instead of specifying the table and rule as strings.

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();

   // Use the default reference rule
   $bugsReportedBy = $user1234->findBugs();

   // Specify the reference rule
   $bugsAssignedTo = $user1234->findBugsByEngineer();

.. _zend.db.table.relationships.fetching.parent:

Fetching a Parent Row
---------------------

If you have a Row object as the result of a query on a dependent table, you can fetch the row in the parent to
which the dependent row refers. Use the method:

.. code-block:: php
   :linenos:

   $row->findParentRow($table, [$rule]);

There always should be exactly one row in the parent table referenced by a dependent row, therefore this method
returns a Row object, not a Rowset object.

The first argument ``$table`` can be a string that specifies the parent table by its class name. You can also
specify the parent table by using an object of that table class.

.. _zend.db.table.relationships.fetching.parent.example:

.. rubric:: Fetching the Parent Row

This example shows getting a Row object from the table *Bugs* (for example one of those bugs with status 'NEW'),
and finding the row in the *Accounts* table for the user who reported the bug.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->fetchAll(array('bug_status = ?' => 'NEW'));
   $bug1 = $bugsRowset->current();

   $reporter = $bug1->findParentRow('Accounts');

The second argument ``$rule`` is optional. It is a string that names the rule key in the ``$_referenceMap`` array
of the dependent table class. If you don't specify a rule, the first rule in the array that references the parent
table is used. If you need to use a rule other than the first, you need to specify the key.

In the example above, the rule key is not specified, so the rule used by default is the first one that matches the
parent table. This is the rule *'Reporter'*.

.. _zend.db.table.relationships.fetching.parent.example-by:

.. rubric:: Fetching a Parent Row By a Specific Rule

This example shows getting a Row object from the table *Bugs*, and finding the account for the engineer assigned to
fix that bug. The rule key string that corresponds to this reference relationship in this example is *'Engineer'*.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->fetchAll(array('bug_status = ?', 'NEW'));
   $bug1 = $bugsRowset->current();

   $engineer = $bug1->findParentRow('Accounts', 'Engineer');

Alternatively, you can query rows from a parent table using a "magic method". ``Zend_Db_Table_Row_Abstract``
invokes the method: ``findParentRow('<TableClass>', '<Rule>')`` if you invoke a method on the Row object matching
either of the following patterns:

- *$row->findParent<TableClass>([Zend_Db_Table_Select $select])*

- *$row->findParent<TableClass>By<Rule>([Zend_Db_Table_Select $select])*

In the patterns above, *<TableClass>* and *<Rule>* are strings that correspond to the class name of the parent
table, and the dependent table's rule key that references the parent table.

.. note::

   The table identity and the rule key named in the method call must match the spelling of the class and rule key
   exactly.

.. _zend.db.table.relationships.fetching.parent.example-magic:

.. rubric:: Fetching the Parent Row using the Magic Method

This example shows finding parent Rows equivalent to those in the previous examples. In this case, the application
uses the magic method invocation instead of specifying the table and rule as strings.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->fetchAll(array('bug_status = ?', 'NEW'));
   $bug1 = $bugsRowset->current();

   // Use the default reference rule
   $reporter = $bug1->findParentAccounts();

   // Specify the reference rule
   $engineer = $bug1->findParentAccountsByEngineer();

.. _zend.db.table.relationships.fetching.many-to-many:

Fetching a Rowset via a Many-to-many Relationship
-------------------------------------------------

If you have a Row object as the result of a query on one table in a many-to-many relationship (for purposes of the
example, call this the "origin" table), you can fetch corresponding rows in the other table (call this the
"destination" table) via an intersection table. Use the method:

.. code-block:: php
   :linenos:

   $row->findManyToManyRowset($table,
                              $intersectionTable,
                              [$rule1,
                                  [$rule2,
                                      [Zend_Db_Table_Select $select]
                                  ]
                              ]);

This method returns a ``Zend_Db_Table_Rowset_Abstract`` containing rows from the table ``$table``, satisfying the
many-to-many relationship. The current Row object ``$row`` from the origin table is used to find rows in the
intersection table, and that is joined to the destination table.

The first argument ``$table`` can be a string that specifies the destination table in the many-to-many relationship
by its class name. You can also specify the destination table by using an object of that table class.

The second argument ``$intersectionTable`` can be a string that specifies the intersection table between the two
tables in the many-to-many relationship by its class name. You can also specify the intersection table by using an
object of that table class.

.. _zend.db.table.relationships.fetching.many-to-many.example:

.. rubric:: Fetching a Rowset with the Many-to-many Method

This example shows getting a Row object from the origin table *Bugs*, and finding rows from the destination table
*Products*, representing products related to that bug.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->find(1234);
   $bug1234 = $bugsRowset->current();

   $productsRowset = $bug1234->findManyToManyRowset('Products',
                                                    'BugsProducts');

The third and fourth arguments ``$rule1`` and ``$rule2`` are optional. These are strings that name the rule keys in
the ``$_referenceMap`` array of the intersection table.

The ``$rule1`` key names the rule for the relationship from the intersection table to the origin table. In this
example, this is the relationship from *BugsProducts* to *Bugs*.

The ``$rule2`` key names the rule for the relationship from the intersection table to the destination table. In
this example, this is the relationship from *Bugs* to *Products*.

Similarly to the methods for finding parent and dependent rows, if you don't specify a rule, the method uses the
first rule in the ``$_referenceMap`` array that matches the tables in the relationship. If you need to use a rule
other than the first, you need to specify the key.

In the example code above, the rule key is not specified, so the rules used by default are the first ones that
match. In this case, ``$rule1`` is *'Reporter'* and ``$rule2`` is *'Product'*.

.. _zend.db.table.relationships.fetching.many-to-many.example-by:

.. rubric:: Fetching a Rowset with the Many-to-many Method By a Specific Rule

This example shows geting a Row object from the origin table *Bugs*, and finding rows from the destination table
*Products*, representing products related to that bug.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->find(1234);
   $bug1234 = $bugsRowset->current();

   $productsRowset = $bug1234->findManyToManyRowset('Products',
                                                    'BugsProducts',
                                                    'Bug');

Alternatively, you can query rows from the destination table in a many-to-many relationship using a "magic
method."``Zend_Db_Table_Row_Abstract`` invokes the method: *findManyToManyRowset('<TableClass>',
'<IntersectionTableClass>', '<Rule1>', '<Rule2>')* if you invoke a method matching any of the following patterns:

- *$row->find<TableClass>Via<IntersectionTableClass> ([Zend_Db_Table_Select $select])*

- *$row->find<TableClass>Via<IntersectionTableClass>By<Rule1> ([Zend_Db_Table_Select $select])*

- *$row->find<TableClass>Via<IntersectionTableClass>By<Rule1>And<Rule2> ([Zend_Db_Table_Select $select])*

In the patterns above, *<TableClass>* and *<IntersectionTableClass>* are strings that correspond to the class names
of the destination table and the intersection table, respectively. *<Rule1>* and *<Rule2>* are strings that
correspond to the rule keys in the intersection table that reference the origin table and the destination table,
respectively.

.. note::

   The table identities and the rule keys named in the method call must match the spelling of the class and rule
   key exactly.

.. _zend.db.table.relationships.fetching.many-to-many.example-magic:

.. rubric:: Fetching Rowsets using the Magic Many-to-many Method

This example shows finding rows in the destination table of a many-to-many relationship representing products
related to a given bug.

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->find(1234);
   $bug1234 = $bugsRowset->current();

   // Use the default reference rule
   $products = $bug1234->findProductsViaBugsProducts();

   // Specify the reference rule
   $products = $bug1234->findProductsViaBugsProductsByBug();

.. _zend.db.table.relationships.cascading:

Cascading Write Operations
--------------------------

.. note::

   **Declare DRI in the database:**

   Declaring cascading operations in ``Zend_Db_Table`` is intended **only** for *RDBMS* brands that do not support
   declarative referential integrity (DRI).

   For example, if you use MySQL's MyISAM storage engine, or SQLite, these solutions do not support DRI. You may
   find it helpful to declare the cascading operations with ``Zend_Db_Table``.

   If your *RDBMS* implements DRI and the *ON DELETE* and *ON UPDATE* clauses, you should declare these clauses in
   your database schema, instead of using the cascading feature in ``Zend_Db_Table``. Declaring cascading DRI rules
   in the *RDBMS* is better for database performance, consistency, and integrity.

   Most importantly, do not declare cascading operations both in the *RDBMS* and in your ``Zend_Db_Table`` class.

You can declare cascading operations to execute against a dependent table when you apply an ``UPDATE`` or a
``DELETE`` to a row in a parent table.

.. _zend.db.table.relationships.cascading.example-delete:

.. rubric:: Example of a Cascading Delete

This example shows deleting a row in the *Products* table, which is configured to automatically delete dependent
rows in the *Bugs* table.

.. code-block:: php
   :linenos:

   $productsTable = new Products();
   $productsRowset = $productsTable->find(1234);
   $product1234 = $productsRowset->current();

   $product1234->delete();
   // Automatically cascades to Bugs table
   // and deletes dependent rows.

Similarly, if you use ``UPDATE`` to change the value of a primary key in a parent table, you may want the value in
foreign keys of dependent tables to be updated automatically to match the new value, so that such references are
kept up to date.

It's usually not necessary to update the value of a primary key that was generated by a sequence or other
mechanism. But if you use a **natural key** that may change value occasionally, it is more likely that you need to
apply cascading updates to dependent tables.

To declare a cascading relationship in the ``Zend_Db_Table``, edit the rules in the ``$_referenceMap``. Set the
associative array keys *'onDelete'* and *'onUpdate'* to the string 'cascade' (or the constant ``self::CASCADE``).
Before a row is deleted from the parent table, or its primary key values updated, any rows in the dependent table
that refer to the parent's row are deleted or updated first.

.. _zend.db.table.relationships.cascading.example-declaration:

.. rubric:: Example Declaration of Cascading Operations

In the example below, rows in the *Bugs* table are automatically deleted if the row in the *Products* table to
which they refer is deleted. The *'onDelete'* element of the reference map entry is set to ``self::CASCADE``.

No cascading update is done in the example below if the primary key value in the parent class is changed. The
*'onUpdate'* element of the reference map entry is ``self::RESTRICT``. You can get the same result by omitting the
*'onUpdate'* entry.

.. code-block:: php
   :linenos:

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       ...
       protected $_referenceMap = array(
           'Product' => array(
               'columns'           => array('product_id'),
               'refTableClass'     => 'Products',
               'refColumns'        => array('product_id'),
               'onDelete'          => self::CASCADE,
               'onUpdate'          => self::RESTRICT
           ),
           ...
       );
   }

.. _zend.db.table.relationships.cascading.notes:

Notes Regarding Cascading Operations
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Cascading operations invoked by Zend_Db_Table are not atomic.**

This means that if your database implements and enforces referential integrity constraints, a cascading ``UPDATE``
executed by a ``Zend_Db_Table`` class conflicts with the constraint, and results in a referential integrity
violation. You can use cascading ``UPDATE`` in ``Zend_Db_Table`` **only** if your database does not enforce that
referential integrity constraint.

Cascading ``DELETE`` suffers less from the problem of referential integrity violations. You can delete dependent
rows as a non-atomic action before deleting the parent row that they reference.

However, for both ``UPDATE`` and ``DELETE``, changing the database in a non-atomic way also creates the risk that
another database user can see the data in an inconsistent state. For example, if you delete a row and all its
dependent rows, there is a small chance that another database client program can query the database after you have
deleted the dependent rows, but before you delete the parent row. That client program may see the parent row with
no dependent rows, and assume this is the intended state of the data. There is no way for that client to know that
its query read the database in the middle of a change.

The issue of non-atomic change can be mitigated by using transactions to isolate your change. But some *RDBMS*
brands don't support transactions, or allow clients to read "dirty" changes that have not been committed yet.

**Cascading operations in Zend_Db_Table are invoked only by Zend_Db_Table .**

Cascading deletes and updates defined in your ``Zend_Db_Table`` classes are applied if you execute the ``save()``
or ``delete()`` methods on the Row class. However, if you update or delete data using another interface, such as a
query tool or another application, the cascading operations are not applied. Even when using ``update()`` and
``delete()`` methods in the ``Zend_Db_Adapter`` class, cascading operations defined in your ``Zend_Db_Table``
classes are not executed.

**No Cascading INSERT .**

There is no support for a cascading ``INSERT``. You must insert a row to a parent table in one operation, and
insert row(s) to a dependent table in a separate operation.


