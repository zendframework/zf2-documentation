.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

``Zend_Config_Xml`` permite aos desenvolvedores armazenarem os dados de configuração em um formato *XML* simples
e lê-los através de uma sintaxe de propriedade de objeto aninhado. O nome do elemento raiz do arquivo ou string
*XML* é irrelevante e pode ser escolhido. O primeiro nível dos elementos *XML* corresponde às seções de dados
de configuração. O formato *XML* suporta organização hierárquica para o aninhamento dos elementos *XML* abaixo
dos elementos de seção-nível. O conteúdo de uma folha de elemento *XML* (leaf) corresponde ao valor de um dado
de configuração. Herança de seção é suportada por um atributo *XML* especial chamado **extends**, e o valor
deste atributo corresponde à seção a que a informação deve ser herdada.

.. note::

   **Tipo de Retorno**

   Os dados de configuração lidos em ``Zend_Config_Xml`` são sempre retornados como strings. A conversão de
   dados de strings para outros tipos é deixado para os desenvolvedores de acordo com suas necessidades
   específicas.

.. _zend.config.adapters.xml.example.using:

.. rubric:: Usando o Zend_Config_Xml

Este exemplo ilustra uma utilização básica de ``Zend_Config_Xml`` para carregar dados de configuração de um
arquivo *XML*. Neste exemplo, existem dados de configuração, tanto para um sistema de produção como para um
sistema de testes. Pois os dados de configuração de um sistema de testes são muito semelhantes aos de
produção, a seção de testes herda da seção de produção. Neste caso, a decisão é arbitrária e poderia ter
sido escrita de modo inverso, com a seção de produção herdando da seção de testes, embora isso possa não ser
o caso em situações mais complexas. Suponha-se, então, que os dados de configuração a seguir estão contidos
em ``/path/to/config.xml``:

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
   </configdata>

Em seguida, suponha que o desenvolvedor do aplicativo necessite dos dados de configuração de testes do arquivo
*XML*. É o simples caso de carregar esses dados especificando o arquivo *XML* e a seção de testes:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Xml('/path/to/config.xml', 'staging');

   echo $config->database->params->host;   // prints "dev.example.com"
   echo $config->database->params->dbname; // prints "dbname"

.. _zend.config.adapters.xml.example.attributes:

.. rubric:: Usando os Atributos de Tag no Zend_Config_Xml

``Zend_Config_Xml`` também suporta outras duas maneiras para definir os nós na configuração. Ambas fazem uso de
atributos. A partir do momento que os atributos **extends** e **value** são palavras-chaves reservadas (o último
através segunda maneira de uso dos atributos), eles não poderão ser utilizados. A primeira maneira usar os
atributos é adicionar um nó pai, assim eles serão interpretados como um filho deste nó:

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

A outra maneira não encurta realmente a configuração, mas a torna mais fácil para manter, pois você não tem
que escrever o nome da tag duas vezes. Você simplesmente cria uma tag vazia com o valor no atributo **value**:

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

   **Strings XML**

   ``Zend_Config_Xml`` é capaz de carregar uma string *XML* diretamente, por exemplo, uma que foi recuperada de um
   banco de dados. A string é passada como primeiro parâmetro para o construtor e deve começar com os caracteres
   **'<?xml'**:

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

.. note::

   **Namespace XML do Zend_Config**

   ``Zend_Config`` vem com sua próprio namespace *XML*, que adiciona funcionalidade adicional ao processo de
   análise. Para aproveitá-la, você tem que definir um namespace com o namespace *URI*
   ``http://framework.zend.com/xml/zend-config-xml/1.0/`` em seu nó raiz de configuração.

   Com o namespace habilitado, você pode usar constantes do *PHP* dentro de arquivos de configuração. Além
   disso, o atributo **extends** foi transferido para um novo namespace e está depreciado no namespace ``NULL``.
   Ele será completamente removido no Zend Framework 2.0.

   .. code-block:: xml
      :linenos:

      $string = <<<EOT
      <?xml version="1.0"?>
      <config xmlns:zf="http://framework.zend.com/xml/zend-config-xml/1.0/">
          <production>
              <includePath>
                  <zf:const zf:name="APPLICATION_PATH"/>/library</includePath>
              <db>
                  <adapter value="pdo_mysql"/>
                  <params>
                      <host value="db.example.com"/>
                  </params>
              </db>
          </production>
          <staging zf:extends="production">
              <db>
                  <params>
                      <host value="dev.example.com"/>
                  </params>
              </db>
          </staging>
      </config>
      EOT;

      define('APPLICATION_PATH', dirname(__FILE__));
      $config = new Zend_Config_Xml($string, 'staging');

      echo $config->includePath; // Prints "/var/www/something/library"


