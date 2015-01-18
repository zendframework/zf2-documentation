.. _migration.namespacing-old-classes:

Namespacing Old Classes
=======================

One of the major changes in ZF2 has been the introduction of namespaces. 
A namespace is a feature that has been introduced in PHP 5.3 and is extensively
used within ZF2. The addition of namespaces to PHP has greatly improved the
readability of long class names and has helped better organize code into modules 
and components.  This transition has also given birth to some naming best 
practices that help developers organize their code bases consisting of classes, 
components, and modules in a consistent and clean fashion.

Converting an older code base that follows the original PEAR/ZF underscore
separated class naming convention into a properly namespaced codebase is one
of the easier strategies to employ in both modernizing your code base as well
as getting ready to ZF2-ify your ZF1 application.

We've created a tool to help in this endeavor, it is located here:

    https://github.com/zendframework/Namespacer
    
This tool will take a wholesale approach to converting older code like the
following:

.. code-block:: php

    class My_Long_NestedComponent_ClassName 
    {
        // methods that use other classes
    }

into:

.. code-block:: php

    namespace My\Long\NestedComponent;
    
    use Other\Classes;
    use Something\ElseConsumed;
    
    class ClassName 
    {
        // methods with classes converted to short name from use statement.
    }

Some IDEs have this capability to some degree.  That said, a good approach might
be to use the command line ``Namespacer`` to do a full sweep of your codebase,
then use the IDE to make more specific naming changes that might makes more
sense to your application.

.. _namespacing-zf1-applications:

Namespacing a ZF1 Application
-----------------------------

The above ``Namespacer`` is a generalized tool.  It does not understand the
structure and naming conventions of a ZF1 application.  As such, you'll need to
address the problem of converting your classes according to their role, and
which classes you find you can convert without affecting the way the framework
interoperates with your code.

For example, in ZF1, the naming convention of application and module layer classes
does not directly match up with same well-defined library class/file conventions of
the PEAR/ZF namings.  For a standard ZF1 application, in the ``application/`` directory,
controller classes are not prefixed, yet model and form classes are prefixed with
``Application_``.  Moreover, they exist inside of lowercased directories, such as
``models`` or ``forms``, and their file to class name segment matching picks up only
after the first segment.  As an example, you might have this directory structure
with the class names on the right:

::

    application/
        ├── Bootstrap.php
        ├── configs
        │   ├── application.ini
        │   └── application.ini.dist
        ├── controllers
        │   ├── IndexController.php         [class IndexController]
        │   └── PurchaseOrderController.php [class PurchaseOrderController]
        ├── forms
        │   └── PurchaseOrder
        │       └── Payment.php             [class Application_Form_PurchaseOrder_Payment]
        ├── layouts
        │   └── scripts
        │       ├── main.phtml
        │       └── subpage.phtml
        ├── models
        │   ├── DbTable
        │   │   └── Invoice.php             [Application_Model_DbTable_Invoice]
        │   ├── Invoice.php                 [Application_Model_Invoice]
        │   ├── InvoiceRepository.php       [Application_Model_InvoiceRepository]
        │   ├── Payment                     
        │   │   └── Paypal
        │   │       └──  DirectPayment.php  [Application_Model_Payment_Paypal_DirectPayment]
        │   └── PurchaseOrder.php           [Application_Model_PurchaseOrder]
        └── views
            └── scripts
                ├── error
                │   └── error.phtml
                ├── index
                │   └── index.phtml
                └── purchase-order
                    ├── index.phtml
                    └── purchaser.phtml

It would not be a good strategy to attempt to do a wholesale namespacing of this kind
of project for a number of reasons:

#. ZF1 has special, context-aware autoloaders that will assist loading a class of
   a particular context from a special location on disk.  For example, ZF1
   understands controllers will be located in the ``controllers`` directory and
   will not be prefixed unless they are inside of a named module's
   ``controllers`` directory.
  
#. Attempting to apply namespacing to controller classes would generally render
   a ZF1 application useless.  ZF1, beyond loading files from disk, assumes
   controllers will have a very specific naming convention so that they can be
   invoked by the framework upon routing and dispatching.
  
#. Beyond dispatching, ZF1 uses the class name to identify and map the proper view
   script to automatically execute.  By naming the controller something non-standard,
   views will no longer this this 1:1 mapping of controllers by name to controller action
   named view scripts.
  
A better solution would be to start by namespacing the parts of your ZF1 application that
have fewer tie-ins with the ZF1 architecture.  The place to start with this is models
and forms.

Since models and forms do not touch controller and view classes (which make heavy use
of ZF1 classes by way of inheritance), model and form classes might not have the same
level of coupling.

.. _namespacing-models:

HOWTO Namespace Your Models
---------------------------

First, ensure your classes are under version control. The namespacer tool will
make modification to classes in place. You can then use your version control
system as a diffing utility afterwards .

To run the tool, download the phar.  Optionally you can place the
``namespacer.phar`` into a directory in your ``PATH``.

Namespacing is a 2 part process:

#. Create a map of all the old files, new files, old classes and new classes.
#. Make the transformations according to the map file.

Change into your ``models/`` directory and execute the map function:

.. code-block:: bash

    namespacer.phar map --mapfile model-map.php --source models/

This will produce a file called ``model-map.php`` with entries like this:

.. code-block:: php
    :linenos:

    <?php return array (
        array (
          'root_directory' => '/realpath/to/project/application/models',
          'original_class' => 'Application_Model_Invoice',
          'original_file' => '/realpath/to/project/application/models/Invoice.php',
          'new_namespace' => 'Application\\Model',
          'new_class' => 'Invoice',
          'new_file' => '/realpath/to/project/application/models/Application/Model/Invoice.php',
        ),
        ...
    );

This gives you an opportunity to manually edit the transformations if you so desire.
While you can modify this file, you also might find it to be easier to go with the default
transformations, and do the remaining changes with your IDE's refactoring utility.

Once you are happy with the map file, run the transformations:

.. code-block:: bash

    namespacer.phar transform --mapfile model-map.php
    
At this point, you can use your version control system's ``status`` command to
see how the directory has transformed. As an example, in a sample project of
mine, ``git`` reports the following:

::

    renamed:  models/DbTable/Invoice.php -> models/Application/Model/DbTable/Invoice.php
    new file: models/Application/Model/DbTable/Transaction.php
    renamed:  models/Invoice.php -> models/Application/Model/Invoice.php
    renamed:  models/Payment/Paypal/DirectPayment.php -> models/Application/Model/Payment/Paypal/DirectPayment.php
    renamed:  models/PurchaseOrder.php -> models/Application/Model/PurchaseOrder.php
    renamed:  models/PurchaseOrderRepository.php -> models/Application/Model/PurchaseOrderRepository.php
    new file: models/Application/Model/PurchaseOrderService.php
    renamed:  models/Purchaser.php -> models/Application/Model/Purchaser.php
    renamed:  models/Ticket.php -> models/Application/Model/Ticket.php
    renamed:  models/Transaction.php -> models/Application/Model/Transaction.php
    renamed:  models/TransactionRepository.php -> models/Application/Model/TransactionRepository.php
    deleted:  models/DbTable/Transaction.php
    deleted:  models/PurchaseOrderService.php
    
You'll notice that the resulting files have treated the ``models/`` directory as the autoloader root
directory.  That means that from this root, class files follow the strict PEAR/ZF2 classfile
naming convention.  The contents of one of the files will look like this:

.. code-block:: php
    :linenos:

    namespace Application\Model;

    use Application\Model\PurchaseOrder;
    use Application\Model\Transaction;
    use Zend_Filter_Alnum;

    class Invoice
    {

        protected $tickets;
        protected $transaction;
    
        ...
    }
    
Things to notice here:

- A namespace has been created for this class.
- The namespacer has created PHP ``use`` statements for classes known in the map file.
- Unknown classes are also included (for example, ``Zend`` classes) in ``use``
  statements.
    
By keeping the old ZF1 classes, your models should continue to work if they
consume ZF1 classes.  This will allow you to, at your own pace, transition your
codebase to ZF2.

This same procedure can largely be adapted to forms and independent library
code as well.
