.. _zend.di.debugging-and-complex-use-cases:

Zend\\Di Debugging & Complex Use Cases
======================================

.. _zend.di.zend.di.debugging-and-complex-use-cases.debugging:

Debugging a DiC
---------------

It is possible to dump the information contained within both the Definition and InstanceManager for a Di instance.

The easiest way is to do the following:

.. code-block:: php
   :linenos:

       Zend\Di\Display\Console::export($di);

If you are using a RuntimeDefinition where upon you expect a particular definition to be resolve at the first-call,
you can see that information to the console display to force it to read that class:

.. code-block:: php
   :linenos:

           Zend\Di\Display\Console::export($di, array('A\ClassIWantTo\GetTheDefinitionFor'));

.. _zend.di.zend.di.debugging-and-complex-use-cases.complex-use-cases:

Complex Use Cases
-----------------

.. _zend.di.zend.di.debugging-and-complex-use-cases.complex-use-cases.interface-injection:

Interface Injection
^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   namespace Foo\Bar {
       class Baz implements BamAwareInterface
       {
           public $bam;
           
           public function setBam(Bam $bam)
           {
               $this->bam = $bam;
           }
       }
       class Bam
       {
       }
       interface BamAwareInterface
       {
           public function setBam(Bam $bam);
       }
   }

   namespace {
       include 'zf2bootstrap.php';
       $di = new Zend\Di\Di;
       $baz = $di->get('Foo\Bar\Baz');
   }

.. _zend.di.zend.di.debugging-and-complex-use-cases.complex-use-cases.setter-injection-with-class-definition:

Setter Injection with Class Definition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   namespace Foo\Bar {
       class Baz
       {
           public $bam;
           
           public function setBam(Bam $bam)
           {
               $this->bam = $bam;
           }
       }
       class Bam {
       }
   }

   namespace {
       $di = new Zend\Di\Di;
       $di->configure(new Zend\Di\Config(array(
           'definition' => array(
               'class' => array(
                   'Foo\Bar\Baz' => array(
                       'setBam' => array('required' => true)
                   )
               )
           )
       )));
       $baz = $di->get('Foo\Bar\Baz');
   }

.. _zend.di.zend.di.debugging-and-complex-use-cases.complex-use-cases.multiple-injections:

Multiple Injections To A Single Injection Point
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   namespace Application {
       class Page
       {
           public $blocks;
           
           public function addBlock(Block $block)
           {
               $this->blocks[] = $block;
           }
       }
       interface Block
       {
       }
   }

   namespace MyModule {
       class BlockOne implements \Application\Block {}
       class BlockTwo implements \Application\Block {}
   }

   namespace {
       include 'zf2bootstrap.php';
       $di = new Zend\Di\Di;
       $di->configure(new Zend\Di\Config(array(
           'definition' => array(
               'class' => array(
                   'Application\Page' => array(
                       'addBlock' => array(
                           'block' => array('type' => 'Application\Block', 'required' => true)
                       )
                   )
               )
           ),
           'instance' => array(
               'Application\Page' => array(
                   'injections' => array(
                       'MyModule\BlockOne',
                       'MyModule\BlockTwo'
                   )
               )
           )
       )));
       $page = $di->get('Application\Page');
   }


