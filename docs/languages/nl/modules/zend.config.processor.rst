.. EN-Revision: 01d6e43f5acc181bb078d8b40ca6c56c6a247cc3
.. _zend.config.processor:

Zend\\Config\\Processor
=======================

``Zend\Config\Processor`` biedt je de mogelijkheid om bepaalde handelingen uit voeren op een ``Zend\Config\Config`` object.
De ``Zend\Config\Processor`` is een interface die twee methoden definieert: ``process()`` en ``processValue()``.
Deze handelingen zijn beschikbaar in de volgende concrete implementaties:

- ``Zend\Config\Processor\Constant``: beheer waarden van PHP constanten;

- ``Zend\Config\Processor\Filter``: filter configuratiegegevens met ``Zend\Filter``;

- ``Zend\Config\Processor\Queue``: beheer een wachtrij van operaties om configuratiegegevens toe te passen;

- ``Zend\Config\Processor\Token``: zoek en vervang specifieke tokens;

- ``Zend\Config\Processor\Translator``: vertaal configuratiegegevens met ``Zend\I18n\Translator``;

Hieronder volgen enkele voorbeelden met de verschillende processors.

.. _zend.config.processor.constant:

Zend\\Config\\Processor\\Constant
---------------------------------

.. _zend.config.processor.constant.example:

.. rubric:: Gebruik Zend\\Config\\Processor\\Constant

Dit voorbeeld illustreert het gebruik van ``Zend\Config\Processor\Constant``:

.. code-block:: php
   :linenos:

   define ('TEST_CONST', 'bar');
   // set true to Zend\Config\Config to allow modifications
   $config = new Zend\Config\Config(array('foo' => 'TEST_CONST'), true);
   $processor = new Zend\Config\Processor\Constant();

   echo $config->foo . ',';
   $processor->process($config);
   echo $config->foo;

Geeft als output: ``TEST_CONST, bar.``.

.. _zend.config.processor.filter:

Zend\\Config\\Processor\\Filter
-------------------------------

.. _zend.config.processor.filter.example:

.. rubric:: Gebruik Zend\\Config\\Processor\\Filter

Dit voorbeeld illustreert het gebruik van ``Zend\Config\Processor\Filter``:

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

Geeft als output: ``bar,BAR``.

.. _zend.config.processor.queue:

Zend\\Config\\Processor\\Queue
------------------------------

.. _zend.config.processor.queue.example:

.. rubric:: Gebruik Zend\\Config\\Processor\\Queue

Dit voorbeeld illustreert het gebruik van ``Zend\Config\Processor\Queue``:

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

Geeft als output: ``bar``. De filters in de wachtrij worden afgehandeld in *FIFO* volgorde (First In, First Out).

.. _zend.config.processor.token:

Zend\\Config\\Processor\\Token
------------------------------

.. _zend.config.processor.token.example:

.. rubric:: Gebruik Zend\\Config\\Processor\\Token

Dit voorbeeld illustreert het gebruik van ``Zend\Config\Processor\Token``:

.. code-block:: php
   :linenos:

   // set the Config to true to allow modifications
   $config = new Config(array('foo' => 'Value is TOKEN'), true);
   $processor = new TokenProcessor();

   $processor->addToken('TOKEN', 'bar');
   echo $config->foo . ',';
   $processor->process($config);
   echo $config->foo;

Geeft als output: ``Value is TOKEN,Value is bar``.

.. _zend.config.processor.translator:

Zend\\Config\\Processor\\Translator
-----------------------------------

.. _zend.config.processor.translator.example:

.. rubric:: Gebruik Zend\\Config\\Processor\\Translator

Dit voorbeeld illustreert het gebruik van ``Zend\Config\Processor\Translator``:

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

Geeft als output: ``English: dog, Italian: cane``.


