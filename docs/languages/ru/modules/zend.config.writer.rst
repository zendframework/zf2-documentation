.. EN-Revision: none
.. _zend.config.writer.introduction:

Zend_Config_Writer
==================

``Zend_Config_Writer`` позволяет создавать конфигурационные файлы из
объектов ``Zend_Config``. Он работает и без использования адаптеров и,
таким образом, очень прост в использовании. По умолчанию
``Zend_Config_Writer`` поставляется с тремя адаптерами, которые
используются одинаково. Вы инстанцируете класс для записи с
опциями, которыми могут быть **filename** (имя файла) и **config**
(конфигурационные данные). Затем вы вызываете метод ``write()``
объекта, и он создает конфигурационный файл. Вы можете также
передавать ``$filename`` и ``$config`` непосредственно методу ``write()``. В
настоящее время вместе с ``Zend_Config_Writer`` поставляются следующие
адаптеры:

- ``Zend_Config_Writer_Array``

- ``Zend_Config_Writer_Ini``

- ``Zend_Config_Writer_Xml``

В качестве исключения ``Zend_Config_Writer_Ini`` имеет еще один
опциональный параметр **nestSeparator**, через который указывается
символ-разделитель для узлов. По умолчанию это точка, как и в
``Zend_Config_Ini``.

При изменении или создании объекта ``Zend_Config`` следует знать
следующее. Для того, чтобы создать или изменить значение,
устанавливайте параметр объекта ``Zend_Config`` через аксессор (**->**).
Для того, чтобы создать раздел в корне или ветку, создавайте
новый массив ("``$config->branch = array()``"). Для того, чтобы указать, от
какого раздела наследует другой, вызывайте метод ``setExtend()`` в
корне объекта ``Zend_Config``.

.. _zend.config.writer.example.using:

.. rubric:: Использование Zend_Config_Writer

Этот пример демонстрирует использование ``Zend_Config_Writer_Xml`` для
создания нового конфигурационного файла:

.. code-block:: php
   :linenos:

   // Создание объекта конфигурации
   $config = new Zend_Config(array(), true);
   $config->production = array();
   $config->staging    = array();

   $config->setExtend('staging', 'production');

   $config->production->db = array();
   $config->production->db->hostname = 'localhost';
   $config->production->db->username = 'production';

   $config->staging->db = array();
   $config->staging->db->username = 'staging';

   // Вы можете записать конфигурационный файл одним из следующих способов:
   // а)
   $writer = new Zend_Config_Writer_Xml(array('config'   => $config,
                                              'filename' => 'config.xml'));
   $writer->write();

   // б)
   $writer = new Zend_Config_Writer_Xml();
   $writer->setConfig($config)
          ->setFilename('config.xml')
          ->write();

   // в)
   $writer = new Zend_Config_Writer_Xml();
   $writer->write('config.xml', $config);

В этом примере создается конфигурационный *XML*-файл с
"промежуточным" (staging) и "производственным" (production) разделами, в
котором первый раздел наследует от второго.

.. _zend.config.writer.modifying:

.. rubric:: Изменение существующего конфигурационного файла

Этот пример демонстрирует редактирование существующего
конфигурационного файла.

.. code-block:: php
   :linenos:

   // Загрузка всех разделов из существующего конфигурационного файла с
   // пропуском "расширений"
   $config = new Zend_Config_Ini('config.ini',
                                 null,
                                 array('skipExtends'        => true,
                                       'allowModifications' => true));

   // Изменение значения
   $config->production->hostname = 'foobar';

   // Сохранение
   $writer = new Zend_Config_Writer_Ini(array('config'   => $config,
                                              'filename' => 'config.ini'));
   $writer->write();

.. note::

   **Загрузка конфигурационного файла**

   При загрузке существующего файла для последующих изменений
   важно загрузить все разделы с пропуском расширений с тем,
   чтобы значения не объединялись. Это достигается путем
   передачи опции **skipExtends** конструктору.


