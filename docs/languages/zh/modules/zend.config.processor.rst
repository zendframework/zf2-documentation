.. _zend.config.processor:

Zend\\Config\\Processor
=======================

``Zend\Config\Processor`` gives you the ability to perform some operations on a ``Zend\Config\Config`` object. The
``Zend\Config\Processor`` is an interface that defines two methods: ``process()`` and ``processValue()``. These
operations are provided by the following concrete implementations:

- ``Zend\Config\Processor\Constant``: manage PHP constant values;

- ``Zend\Config\Processor\Filter``: filter the configuration data using ``Zend\Filter``;

- ``Zend\Config\Processor\Queue``: manage a queue of operations to apply to configuration data;

- ``Zend\Config\Processor\Token``: find and replace specific tokens;

- ``Zend\Config\Processor\Translator``: translate configuration values in other languages using
  ``Zend\I18n\Translator``;

Below we reported some examples for each type of processor.

.. _zend.config.processor.constant:

Zend\\Config\\Processor\\Constant
---------------------------------

.. _zend.config.processor.constant.example:

.. rubric:: Using Zend\\Config\\Processor\\Constant

This example illustrates the basic use of ``Zend\Config\Processor\Constant``:

.. code-block:: php
   :linenos:

   define ('TEST_CONST', 'bar');
   // set true to Zend\Config\Config to allow modifications
   $config = new Zend\Config\Config(array('foo' => 'TEST_CONST'), true);
   $processor = new Zend\Config\Processor\Constant();

   echo $config->foo . ',';
   $processor->process($config);
   echo $config->foo;

This example returns the output: ``TEST_CONST, bar.``.

.. _zend.config.processor.filter:

Zend\\Config\\Processor\\Filter
-------------------------------

.. _zend.config.processor.filter.example:

.. rubric:: Using Zend\\Config\\Processor\\Filter

This example illustrates the basic use of ``Zend\Config\Processor\Filter``:

.. code-block:: php
   :linenos:

   use Zend\Filter\StringToUpper;
   use Zend\Config\Processor\Filter as FilterProcessor;
   use Zend\Config\Config;

   $config = new Config(array ('foo' => 'bar'), true);
   $upper = new StringToUpper();

   $upperProcessor = new FilterProcessor($upper);

   echo $config->foo . ',';
   $upperProcessor->process($config);
   echo $config->foo;

This example returns the output: ``bar,BAR``.

.. _zend.config.processor.queue:

Zend\\Config\\Processor\\Queue
------------------------------

.. _zend.config.processor.queue.example:

.. rubric:: Using Zend\\Config\\Processor\\Queue

This example illustrates the basic use of ``Zend\Config\Processor\Queue``:

.. code-block:: php
   :linenos:

   use Zend\Filter\StringToLower;
   use Zend\Filter\StringToUpper;
   use Zend\Config\Processor\Filter as FilterProcessor;
   use Zend\Config\Processor\Queue;
   use Zend\Config\Config;

   $config = new Config(array ('foo' => 'bar'), true);
   $upper  = new StringToUpper();
   $lower  = new StringToLower();

   $lowerProcessor = new FilterProcessor($lower);
   $upperProcessor = new FilterProcessor($upper);

   $queue = new Queue();
   $queue->insert($upperProcessor);
   $queue->insert($lowerProcessor);
   $queue->process($config);

   echo $config->foo;

This example returns the output: ``bar``. The filters in the queue are applied with a *FIFO* logic (First In, First
Out).

.. _zend.config.processor.token:

Zend\\Config\\Processor\\Token
------------------------------

.. _zend.config.processor.token.example:

.. rubric:: Using Zend\\Config\\Processor\\Token

This example illustrates the basic use of ``Zend\Config\Processor\Token``:

.. code-block:: php
   :linenos:

   // set the Config to true to allow modifications
   $config = new Config(array('foo' => 'Value is TOKEN'), true);
   $processor = new TokenProcessor();

   $processor->addToken('TOKEN', 'bar');
   echo $config->foo . ',';
   $processor->process($config);
   echo $config->foo;

This example returns the output: ``Value is TOKEN,Value is bar``.

.. _zend.config.processor.translator:

Zend\\Config\\Processor\\Translator
-----------------------------------

.. _zend.config.processor.translator.example:

.. rubric:: Using Zend\\Config\\Processor\\Translator

This example illustrates the basic use of ``Zend\Config\Processor\Translator``:

.. code-block:: php
   :linenos:

   use Zend\Config\Config;
   use Zend\Config\Processor\Translator as TranslatorProcessor;
   use Zend\I18n\Translator\Translator;

   $config = new Config(array('animal' => 'dog'), true);

   /*
    * The following mapping would exist for the translation
    * loader you provide to the translator instance
    * $italian = array(
    *     'dog' => 'cane'
    * );
    */

   $translator = new Translator();
   // ... configure the translator ...
   $processor = new TranslatorProcessor($translator);

   echo "English: {$config->animal}, ";
   $processor->process($config);
   echo "Italian: {$config->animal}";

This example returns the output: ``English: dog, Italian: cane``.


