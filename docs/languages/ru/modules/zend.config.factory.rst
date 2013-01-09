.. EN-Revision: 9e6907f
.. _zend.config.factory:

Фабрика
=======

Фабрика дает вам возможность загружать конфигурационные файлы в массив или в объект ``Zend\Config\Config``.
Фабрика имеет два назначения:

- Загрузка конфигурационного файла(ов)
- Сохранение конфигурационного файла

.. note::

   Сохранение конфигурации будет выполнено для *одного* файла. Фабрике не известно об объединении двух и
   более конфигураций, поэтому не может сохранить их в несколько файлов. Если вы хотите сохранить определенные
   разделы конфигурации в отдельный файл, вы должны выделить их самостоятельно.

Загрузка файла конфигурации
---------------------------

Следующий пример демонстрирует как загрузить один файл конфигурации

.. code-block:: php
   :linenos:

   //Загружить файл как php-массив
   $config = Zend\Config\Factory::fromFile(__DIR__.'/config/my.config.php');

   //Загрузить xml-файл как объект Config
   $config = Zend\Config\Factory::fromFile(__DIR__.'/config/my.config.xml', true);

Для объединения нескольких файлов конфигураций

.. code-block::php
   :linenos:

    $config = Zend\Config\Factory::fromFiles(
        array(
            __DIR__.'/config/my.config.php',
            __DIR__.'/config/my.config.xml',
        )
    );

Сохранение файла конфигурации
-----------------------------

Иногда вы хотите сохранить конфигурацию в файл. Что ж, это действительно легко сделать.

.. code-block::php
   :linenos:

   $config = new Zend\Config\Config(array(), true);
   $config->settings = array();
   $config->settings->myname = 'framework';
   $config->settings->date	 = '2012-12-12 12:12:12';

   //Сохранение конфигурации
   Zend\Config\Factory::toFile(__DIR__.'/config/my.config.php', $config);

   //Сохранение массива
   $config = array(
       'settings' => array(
           'myname' => 'framework',
           'data'   => '2012-12-12 12:12:12',
       ),
    );

    Zend\Config\Factory::toFile(__DIR__.'/config/my.config.php', $config);


