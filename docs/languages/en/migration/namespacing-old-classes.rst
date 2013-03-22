.. _migration.namespacing-old-classes:

Namespacing Old Classes
=======================

ZF2's minimal version is PHP 5.3.  The most notable feature of PHP 5.3 is
the addition of namespaces with ZF2 fully embraces.  Moreover, new projects
built on ZF2 also fully embrace PHP namespaces.  The additional of namespaces
to PHP has greatly improved the readability of long class names and additionally,
it has helped better organize code into modules and components.  This transition
has also given birth to some naming best practices that help developers organize
their code bases consisting of classes, components and modules in a consistent
and clean fashion.

Convering an older code base that follows the original PEAR/ZF underscore
separated class naming convention into a properly namespaced codebase is one
of the easier strategies to employ in both modernizing your code base as well
as getting ready to ZF2-ify your ZF1 application.

We've created a tool to help in this endeavor, it is located here:

    https://github.com/zendframework/Namespacer
    
This tool will take a wholesale approach to converting older

    class My_Long_NestedComponent_ClassName {
        // methods that use other classes
    }

into

    namespace My\Long\NestedComponent;
    
    use Other\Classes;
    use Something\ElseConsumed;
    
    class ClassName {
        // methods with classes converted to short name from use statement.
    }

Some IDE's have this capability as well to some degree or another.  That said,
a good approach might be to use the command line Namespacer to do a full
sweep of your codebase, then use the IDE to make more specific naming changes
that might makes more sense to your application.

Namespacing a ZF1 Application
=============================

The above Namespacer is a generalized tool.  It does not understand the structure
and naming conventions of a ZF1 application.  As such, you'll need to address
the problem of converting your classes according to their role, and which classes
you find you can convert without affecting the way the framework interoperates with
your code.

For example, in ZF1, the naming convention of application and module layer classes
does not directly match up with same well-defined library class/file conventions of
the PEAR/ZF namings.  For a standard ZF1 application, in the applicaiton/ directory
controller classes are not prefixed, yet model and form classes are prefixed with
'Application_'.  Moreover, they exist inside of lower cased directories such as
'models' or 'forms' and their file to class name segment matching picks up only
after the first segment.  So for example, you might have this directory structure
with the class names on the right:

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

  1) ZF1 has special context aware autoloaders that will assist loading a class of a
  particular context from a special location on disk.  For example, ZF1 understand
  controllers will be located in the "controllers" directory, and will not be prefixed
  unless they are inside of a modules controllers directory.
  
  2)  Attempting to apply namespacing to controller classes would generally render a ZF1
  application useless.  ZF1, beyond loading files from disk, assumes controllers will
  have a very specific naming convention so that they can be invoked by the framework
  upon routing and dispatching.
  
  3) Beyond dispatching, ZF1 uses the class name to identify and map the proper view
  script to automatically execute.  By naming the controller something non-standard,
  views will no longer this this 1-1 mapping of controllers by name to controller action
  named view scripts.
  
A better solution would be to start by namespacing the parts of your ZF1 application that
have fewer tie-ins with the ZF1 architecture.  This place to start with this is models
and forms.

Since models and forms do not touch controller and view classes (which make heavy use
of ZF1 classes by way of inheritance), model and form classes might not have the same
level of coupling.

HOWTO namespace your Models
===========================

First, ensure your classes are under version control, git is ideal.  The namespacer
tool will make modification to classes in place.  This is ideal since you can then
use git as a diffing utility after the fact.

To run the tool, simply download the phar.  Optionally you can place the namespacer.phar
into a directory in your PATH.

Namespacing is a 2 part process:

    1) create a map of all the old files, new files, old classes and new classes.
    2) make the transformations according to the map file

Change into your models/ directory and execute the map function:

    namespacer.phar map --mapfile model-map.php --source models/

This will produce a file called model-map.php that has entries like this:

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

This give you an opportunity to hand-tweak the transformations if you so desire.
While you can tweak this file, you also might find it to be easier to go with the default
transformations, and do the remaining tweaking with your IDE's refactoring utility.

Once you are happy with the map file, run the transformations:

    namespacer.phar transform --mapfile model-map.php
    
At this point, if you are using git, you can utilize git status to see how the models
directory has transformed.  In a sample project, my git commit looks like this:

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
    
You'll notice that the resulting files have treated the models/ directory as the autoloader root
directory.  That means that from this root, class files follow the strict PEAR/ZF2 class-file
naming convention.  The contents of one of the files will look like this:

    <?php
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

    * A namespace has been created for this class
    * The namespacer has created php use statements for classes known in the map file.
    * Unknown classes are also included (for example, Zend classes).
    
By keeping the old ZF1 classes, your models should continue to work if they consume ZF1 classes.  This will
allow you to, at your own pace, transition your codebase to ZF2.

This same procedure can largely be adapted to Forms as and independent library code
as well.