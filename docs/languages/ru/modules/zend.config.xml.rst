.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

``Zend_Config_Xml`` дает разработчикам возможность хранить
конфигурационные данные в простом формате *XML* и читать их
посредством синтаксиса вложенных свойств объектов. Корневой
элемент в файле или строке с *XML* не имеет значения и ему может
быть дано любое имя. Первый уровень элементов *XML*
соответствует разделам конфигурационных данных. Формат *XML*
поддерживает иерархическую организацию данных через
вложенность элементов ниже элементов уровня разделов.
Содержимое конечного элемента соответствует значению
элемента конфигурационных данных. Наследование разделов
поддерживается через специальный атрибут **extends**, значение
атрибута соответствует разделу, данные которого наследуются в
раздел с этим атрибутом.

.. note::

   **Тип возвращаемых данных**

   Конфигурационные данные, прочитанные в ``Zend_Config_Xml``, всегда
   возвращаются как строки. Приведение данных из строк к
   требуемым типам предоставляется разработчикам.

.. _zend.config.adapters.xml.example.using:

.. rubric:: Использование Zend_Config_Xml

Данный пример демонстрирует основы использования ``Zend_Config_Xml``
для загрузки конфигурационных данных из файла *XML*. В этом
примере используются конфигурационные данные для
производственной и промежуточной систем. Поскольку
конфигурационные данные промежуточной системы очень похожи
на конфигурационные данные для производственной системы, то
"промежуточный" (staging) раздел наследует от "производственного"
(production) раздела. В данном случае выбор произвольный, т.е. может
быть и наоборот — "производственный" раздел наследует от
"промежуточного", хотя это может не подходить в более сложных
случаях. Допустим, конфигурационные данные находятся в файле
``/path/to/config.xml``:

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter>pdo_mysql</adapter>
               <params>
                   <host>db.example.com</host>
                   <username>dbuser</username>
                   <password>secret</password>
                   <dbname>dbname</dbname>
               </params>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params>
                   <host>dev.example.com</host>
                   <username>devuser</username>
                   <password>devsecret</password>
               </params>
           </database>
       </staging>

Далее предположим, что разработчику приложения нужны
"промежуточные" конфигурационные данные из файла *XML*.
Загрузить эти данные, указав файл *XML* и нужный раздел, довольно
просто:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Xml('/path/to/config.xml', 'staging');

   echo $config->database->params->host;   // выведет "dev.example.com"
   echo $config->database->params->dbname; // выведет "dbname"

.. _zend.config.adapters.xml.example.attributes:

.. rubric:: Использование тегов в ``Zend_Config_Xml``

``Zend_Config_Xml`` также поддерживает два дополнительных способа
определения узлов в конфигурации. В обоих способах
используются атрибуты. Поскольку атрибуты **extends** и **value**
являются зарезервированными ключевыми словами (**value**
используется во втором способе с применением атрибутов), то
они не должны использоваться здесь. Первый способ с
использованием атрибутов состоит в добавлении атрибутов в
родительский узел, они потом будут преобразованы в потомки
этого узла:

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production webhost="www.example.com">
           <database adapter="pdo_mysql">
               <params host="db.example.com" username="dbuser" password="secret"
                       dbname="dbname"/>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params host="dev.example.com" username="devuser"
                       password="devsecret"/>
           </database>
       </staging>
   </configdata>

Другой способ не делает конфигурацию заметно короче, но
облегчает ее поддержку благодаря тому, что не нужно писать
имена тегов дважды. Вы просто создаете пустой тег, значение
которого содержится в атрибуте **value**:

.. code-block:: xml
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter value="pdo_mysql"/>
               <params>
                   <host value="db.example.com"/>
                   <username value="dbuser"/>
                   <password value="secret"/>
                   <dbname value="dbname"/>
               </params>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params>
                   <host value="dev.example.com"/>
                   <username value="devuser"/>
                   <password value="devsecret"/>
               </params>
           </database>
       </staging>
   </configdata>

.. note::

   **Передача строки с XML**

   ``Zend_Config_Xml`` также может загружать *XML* непосредственно из
   строки, которая может быть получена, например, из базы данных.
   Строка передается конструктору в качестве первого параметра
   и должна начинаться с символов **'<?xml'**:

   .. code-block:: xml
      :linenos:

      $string = <<<EOT
      <?xml version="1.0"?>
      <config>
          <production>
              <db>
                  <adapter value="pdo_mysql"/>
                  <params>
                      <host value="db.example.com"/>
                  </params>
              </db>
          </production>
          <staging extends="production">
              <db>
                  <params>
                      <host value="dev.example.com"/>
                  </params>
              </db>
          </staging>
      </config>
      EOT;

      $config = new Zend_Config_Xml($string, 'staging');


