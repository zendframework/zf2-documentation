.. EN-Revision: none
.. _zend.config.writer.introduction:

Zend\Config\Writer
==================

``Zend\Config\Writer`` позволяет создавать конфигурационные файлы из
объектов ``Zend_Config``. Он работает и без использования адаптеров и,
таким образом, очень прост в использовании. По умолчанию
``Zend\Config\Writer`` поставляется с тремя адаптерами, которые
используются одинаково. Вы инстанцируете класс для записи с
опциями, которыми могут быть **filename** (имя файла) и **config**
(конфигурационные данные). Затем вы вызываете метод ``write()``
объекта, и он создает конфигурационный файл. Вы можете также
передавать ``$filename`` и ``$config`` непосредственно методу ``write()``. В
настоящее время вместе с ``Zend\Config\Writer`` поставляются следующие
адаптеры:

- ``Zend\Config_Writer\Array``

- ``Zend\Config_Writer\Ini``

- ``Zend\Config_Writer\Xml``

В качестве исключения ``Zend\Config_Writer\Ini`` имеет еще один
опциональный параметр **nestSeparator**, через который указывается
символ-разделитель для узлов. По умолчанию это точка, как и в
``Zend\Config\Ini``.

При изменении или создании объекта ``Zend_Config`` следует знать
следующее. Для того, чтобы создать или изменить значение,
устанавливайте параметр объекта ``Zend_Config`` через аксессор (**->**).
Для того, чтобы создать раздел в корне или ветку, создавайте
новый массив ("``$config->branch = array()``"). Для того, чтобы указать, от
какого раздела наследует другой, вызывайте метод ``setExtend()`` в
корне объекта ``Zend_Config``.

.. _zend.config.writer.example.using:

.. rubric:: Использование Zend\Config\Writer

Этот пример демонстрирует использование ``Zend\Config_Writer\Xml`` для
создания нового конфигурационного файла:

.. code-block:: php
   :linenos:

   // Создание объекта конфигурации
   $config = new Zend\Config\Config(array(), true);
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
   $writer = new Zend\Config_Writer\Xml(array('config'   => $config,
                                              'filename' => 'config.xml'));
   $writer->write();

   // б)
   $writer = new Zend\Config_Writer\Xml();
   $writer->setConfig($config)
          ->setFilename('config.xml')
          ->write();

   // в)
   $writer = new Zend\Config_Writer\Xml();
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
   $config = new Zend\Config\Ini('config.ini',
                                 null,
                                 array('skipExtends'        => true,
                                       'allowModifications' => true));

   // Изменение значения
   $config->production->hostname = 'foobar';

   // Сохранение
   $writer = new Zend\Config_Writer\Ini(array('config'   => $config,
                                              'filename' => 'config.ini'));
   $writer->write();

.. note::

   **Загрузка конфигурационного файла**

   При загрузке существующего файла для последующих изменений
   важно загрузить все разделы с пропуском расширений с тем,
   чтобы значения не объединялись. Это достигается путем
   передачи опции **skipExtends** конструктору.


