.. _zend.di.debugging-and-complex-use-cases:

Zend\\Di Debugging & Casi d'uso complessi
=========================================

.. _zend.di.zend.di.debugging-and-complex-use-cases.debugging:

Debugging di un DiC
-------------------

E' possibile eseguire un dump delle informazioni contenute dentro un Definition ed un InstanceManager per una
istanza Di.

Il modo più semplice per fare questo:

.. code-block:: php
   :linenos:

       Zend\Di\Display\Console::export($di);

Se stai utilizzando una RuntimeDefinition dove ti aspetti che una definizione specifica venga risolta alla prima
chiamata, puoi vedere questa informazione forzando il display della console a leggere quella classe:

.. code-block:: php
   :linenos:

           Zend\Di\Display\Console::export($di, array('A\ClassIWantTo\GetTheDefinitionFor'));

.. _zend.di.zend.di.debugging-and-complex-use-cases.complex-use-cases:

Casi d'uso complessi
--------------------

.. _zend.di.zend.di.debugging-and-complex-use-cases.complex-use-cases.interface-injection:

Interface Injection (Inziezione delle interfacce)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   namespace Foo\Bar {
       class Baz implements BamAwareInterface {
           public $bam;
           public function setBam(Bam $bam){
               $this->bam = $bam;
           }
       }
       class Bam {
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

Iniezione di un Setter con il Class Definition
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   namespace Foo\Bar {
       class Baz {
           public $bam;
           public function setBam(Bam $bam){
               $this->bam = $bam;
           }
       }
       class Bam {
       }
   }

   namespace {
       $di = new Zend\Di\Di;
       $di->configure(new new Zend\Di\Config(array(
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

Multiple iniezioni su un singolo punto
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   namespace Application {
       class Page {
           public $blocks;
           public function addBlock(Block $block){
               $this->blocks[] = $block;
           }
       }
       interface Block {
       }
   }

   namespace MyModule {
       class BlockOne implements \Application\Block {}
       class BlockTwo implements \Application\Block {}
   }

   namespace {
       include 'zf2bootstrap.php';
       $di = new Zend\Di\Di;
       $di->configure(new new Zend\Di\Config(array(
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


