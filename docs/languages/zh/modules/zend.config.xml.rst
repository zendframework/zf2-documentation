.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

*Zend_Config_Xml*
让开发者能够存储配置数据到一个简单XML格式并通过嵌入对象属性语法来读取。XML文件的根元素（root
element）不相关并可以任意命名。顶级的XML元素和配置数据的节相对应。XML格式通过嵌入XML元素到节一级元素（section-level
elements）的下面来支持等级结构组织。叶一级（leaf-level）的XML元素和配置数据的值相对应。节继承通过一个特殊的XML属性名为
*extends*\ 来支持，与之相对应的这个属性的值通过扩展节（extending section）来继承。

.. note::

   **返回类型**

   读入 *Zend_Config_Xml*\
   中的配置数据总是返回字串。数据从字符串到其它类型的转换留给开发者来适应他们特定的需求。

.. _zend.config.adapters.xml.example.using:

.. rubric:: 使用Zend_Config_Xml

这个例子示例了从INI文件加载配置数据的 *Zend_Config_Xml*\
的基本用法。在这个例子中有生产系统（production system）和开发系统（staging
system）的配置数据。因为开发系统配置数据和生产系统的配置数据类似，所以开发系统的节从生产系统的节继承。在这个案例中，结果(decision)是任意的并且它可以反过来做，即生产系统节从开发系统节继承，尽管这不可能用于更复杂的情形。接着，假定下面的配置数据包含在
*/path/to/config.xml*\ 中：

.. code-block::
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
   </configdata>


接着，假定开发者需要从XML文件取开发配置数据。这非常简单，只要指定XML文件和开发系统节就可以加载这些数据了：

.. code-block::
   :linenos:

   $config = new Zend_Config_Xml('/path/to/config.xml', 'staging');

   echo $config->database->params->host;   // 输出 "dev.example.com"
   echo $config->database->params->dbname; // 输出 "dbname"


.. _zend.config.adapters.xml.example.attributes:

.. rubric:: 在 Zend_Config_Xml 使用标签（tag）属性

Zend_Config_Xml 也支持另外两种方法在配置文件里定义节点。它们都利用属性。 因为
*extends* 和 *value*
属性是保留关键字（后者是第二种使用属性的方法），它们可能不被使用。
第一种方法使用属性是把属性添加到父节点，它本身就变成了子节点：

.. code-block::
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production webhost="www.example.com">
           <database adapter="pdo_mysql">
               <params host="db.example.com" username="dbuser" password="secret" dbname="dbname"/>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params host="dev.example.com" username="devuser" password="devsecret"/>
           </database>
       </staging>
   </configdata>


另一种方法也不会使配置文件变小，但使维护变得容易，是因为你需要要写标签名两次。你可以创建一个空标签，它在
*value* 属性里包含它的值：

.. code-block::
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



