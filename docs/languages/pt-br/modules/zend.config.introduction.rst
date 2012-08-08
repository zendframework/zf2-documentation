.. EN-Revision: none
.. _zend.config.introduction:

Introdução
==========

``Zend_Config`` é projetado para simplificar o acesso e a utilização dos dados de configuração dentro das
aplicações. Ele fornece uma propriedade do objeto aninhado baseado na interface de usuário para acessar dados de
configuração no código do aplicativo. Os dados de configuração podem vir de uma variedade de meios de suporte
para armazenamento de dados hierárquico. Atualmente ``Zend_Config`` fornece adaptadores para dados de
configuração que são armazenados em arquivos de texto com :ref:`Zend_Config_Ini <zend.config.adapters.ini>` e
:ref:`Zend_Config_Xml <zend.config.adapters.xml>`.

.. _zend.config.introduction.example.using:

.. rubric:: Usando o Zend_Config

Normalmente, espera-se que os usuários usem uma das classes adaptadoras como :ref:`Zend_Config_Ini
<zend.config.adapters.ini>` ou :ref:`Zend_Config_Xml <zend.config.adapters.xml>`, mas se os dados de configuração
estão disponíveis em uma matriz *PHP*, pode-se simplesmente passar os dados para o construtor ``Zend_Config`` a
fim de utilizar uma simples interface orientada a objetos:

.. code-block:: php
   :linenos:

   // Dada uma matriz de dados de configuração
   $configArray = array(
       'webhost'  => 'www.example.com',
       'database' => array(
           'adapter' => 'pdo_mysql',
           'params'  => array(
               'host'     => 'db.example.com',
               'username' => 'dbuser',
               'password' => 'secret',
               'dbname'   => 'mydatabase'
           )
       )
   );

   // Create the object-oriented wrapper upon the configuration data
   $config = new Zend_Config($configArray);

   // Imprimir um dado de configuração (resulta em 'www.example.com')
   echo $config->webhost;

   // Utiliza os dados de configuração para se conectar ao banco de dados
   $db = Zend_Db::factory($config->database->adapter,
                          $config->database->params->toArray());

   // Uso alternativo: simplesmente passar o objeto Zend_Config.
   // A fábrica do Zend_Db sabe como interpretá-lo.
   $db = Zend_Db::factory($config->database);

Como ilustrado no exemplo acima, ``Zend_Config`` fornece a sintaxe da propriedade do objeto aninhado para acessar
os dados de configuração passados para o construtor.

Junto com o acesso orientado a objeto aos valores dos dados, ``Zend_Config`` também tem o ``get()``, que
retornará o valor padrão fornecido se o elemento do dado não existir. Por exemplo:

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

.. rubric:: Usando o Zend_Config com um Arquivo de Configuração em PHP

Muitas vezes é desejável utilizar um arquivo de configuração puramente em *PHP*. O código a seguir ilustra
como isto pode ser realizado facilmente:

.. code-block:: php
   :linenos:

   // config.php
   return array(
       'webhost'  => 'www.example.com',
       'database' => array(
           'adapter' => 'pdo_mysql',
           'params'  => array(
               'host'     => 'db.example.com',
               'username' => 'dbuser',
               'password' => 'secret',
               'dbname'   => 'mydatabase'
           )
       )
   );

.. code-block:: php
   :linenos:

   // Consumo de configuração
   $config = new Zend_Config(require 'config.php');

   // Imprimir um dado de configuração (resulta em 'www.example.com')
   echo $config->webhost;


