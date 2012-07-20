.. _zend.config.adapters.ini:

Zend_Config_Ini
===============

*Zend_Config_Ini*\ 允许开发者通过嵌套的对象属性语法在应用程序中用熟悉的 INI
格式存储和读取配置数据。INI
格式在提供拥有配置数据键的等级结构和配置数据节之间的继承能力方面具有专长。配置数据等级结构通过用点或者句号
(*.*)分离键值。一个节可以扩展或者通过在节的名称之后带一个冒号(*:*)和被继承的配置数据的节的名称来从另一个节继承。

.. note::

   **parse_ini_file**

   *Zend_Config_Ini* 使用 `parse_ini_file()`_\ PHP
   函数。请复习这个文档了解它的特定行为，它在 *Zend_Config_Ini*\ 中使用，例如 *true*,
   *false*, *yes*, *no* 和 *null* 这些特殊的值如何操作。

.. note::

   **键分离器**

   缺省地，键分离器字符是句号(*.*)。然而，这个可以通过当构造 *Zend_Config_Ini*\
   对象时修改 *$options* key *'nestSeparator'* 被修改。例如：

      .. code-block::
         :linenos:

         $options['nestSeparator'] = ':';
         $config = new Zend_Config_Ini('/path/to/config.ini',
                                       'staging',
                                       $options);




.. _zend.config.adapters.ini.example.using:

.. rubric:: 使用 Zend_Config_Ini

这个例子示例了从 INI 文件加载配置数据的 *Zend_Config_Ini*\
的基本用法。在这个例子中有生产系统（production system）和开发系统（staging
system）的配置数据。因为开发系统配置数据和生产系统的配置数据类似，所以开发系统的节从生产系统的节继承。在这个案例中，结果(decision)是任意的并且它可以反过来做，即生产系统节从开发系统节继承，尽管这不可能用于更复杂的情形。接着，假定下面的配置数据包含在
*/path/to/config.ini*\ 中：

.. code-block::
   :linenos:

   ; 生产站点配置数据
   [production]
   webhost                  = www.example.com
   database.adapter         = pdo_mysql
   database.params.host     = db.example.com
   database.params.username = dbuser
   database.params.password = secret
   database.params.dbname   = dbname

   ; 开发站点配置数据从生产站点配置数据集成并如果需要可以重写
   [staging : production]
   database.params.host     = dev.example.com
   database.params.username = devuser
   database.params.password = devsecret


接着，假定开发者需要从INI文件取开发配置数据。这非常简单，只要指定INI文件和开发系统节就可以加载这些数据了：

.. code-block::
   :linenos:

   $config = new Zend_Config_Ini('/path/to/config.ini', 'staging');

   echo $config->database->params->host;   // 输出 "dev.example.com"
   echo $config->database->params->dbname; // 输出 "dbname"


.. note::

   .. _zend.config.adapters.ini.table:

   .. table:: Zend_Config_Ini 构造器参数

      +----------------+-----------------------------------------------------------------------------------------+
      |参数              |注释                                                                                       |
      +================+=========================================================================================+
      |$filename       |要加载的 INI 文件。                                                                             |
      +----------------+-----------------------------------------------------------------------------------------+
      |$section        |在INI文件中 [section] （节）将被加载。把这个参数设置为null，所有的节将被加载。另外，一个节名称的数组被提供给加载多个节。                    |
      +----------------+-----------------------------------------------------------------------------------------+
      |$options = false|选项数组。下面的键被支持： allowModifications：设置为true 允许随后加载文件更改。缺省为false nestSeparator: 设置嵌套字符。缺省为"."|
      +----------------+-----------------------------------------------------------------------------------------+



.. _`parse_ini_file()`: http://php.net/parse_ini_file
