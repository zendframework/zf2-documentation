.. _zend.config.adapters.ini:

Zend_Config_Ini
===============

``Zend_Config_Ini`` permite aos desenvolvedores armazenar os dados de configuração em um formato *INI* conhecido
e lê-los no aplicativo através de uma sintaxe de propriedade de objeto aninhado. O formato *INI* é especializado
em proporcionar tanto a capacidade de ter uma hierarquia de chaves de dados de configuração quanto de herança
entre as seções de dados de configuração. Hierarquias de dados de configuração são suportadas através da
separação das chaves com o ponto ou caractere de período ("**.**"). Uma seção pode estender ou herdar de outra
seção, seguindo o nome da seção, com um caractere dois pontos ("**:**") e o nome da seção a partir do qual os
dados devem ser herdados.

.. note::

   **Analisando o Arquivo INI**

   ``Zend_Config_Ini`` utiliza a função `parse_ini_file()`_ do *PHP*. Por favor reveja esta documentação para
   estar ciente de seus comportamentos característicos, que conduzem o ``Zend_Config_Ini``, tais como os valores
   especiais "``TRUE``", "``FALSE``", "sim", "não", e "``NULL``" são manipulados.

.. note::

   **Separador de Chave**

   Por padrão, o caractere separador de chave é o caractere de período ("**.**"). Isso pode ser alterado, de
   qualquer modo, alterando a chave ``nestSeparator`` de ``$options`` na construção do objeto
   ``Zend_Config_Ini``. Por exemplo:

   .. code-block:: php
      :linenos:

      $options['nestSeparator'] = ':';
      $config = new Zend_Config_Ini('/path/to/config.ini',
                                    'staging',
                                    $options);

.. _zend.config.adapters.ini.example.using:

.. rubric:: Usando o Zend_Config_Ini

Este exemplo ilustra uma utilização básica de ``Zend_Config_Ini`` para carregar dados de configuração de um
arquivo *INI*. Neste exemplo, existem dados de configuração, tanto para um sistema de produção como para um
sistema de testes. Pois os dados de configuração de um sistema de testes são muito semelhantes aos de
produção, a seção de testes herda da seção de produção. Neste caso, a decisão é arbitrária e poderia ter
sido escrita de modo inverso, com a seção de produção herdando da seção de testes, embora isso possa não ser
o caso em situações mais complexas. Suponha-se, então, que os dados de configuração a seguir estão contidos
em ``/path/to/config.ini``:

.. code-block:: ini
   :linenos:

   ; Dados de configuração da seção de produção
   [production]
   webhost                  = www.example.com
   database.adapter         = pdo_mysql
   database.params.host     = db.example.com
   database.params.username = dbuser
   database.params.password = secret
   database.params.dbname   = dbname

   ; Os dados de configuração da seção de testes são herdados
   ; da produção e substitui os valores conforme necessário
   [staging : production]
   database.params.host     = dev.example.com
   database.params.username = devuser
   database.params.password = devsecret

Em seguida, suponha que o desenvolvedor do aplicativo necessite dos dados de configuração de testes do arquivo
*INI*. É o simples caso de carregar esses dados especificando o arquivo *INI* e a seção de testes:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('/path/to/config.ini', 'staging');

   echo $config->database->params->host;   // imprime "dev.example.com"
   echo $config->database->params->dbname; // imprime "dbname"

.. note::

   .. _zend.config.adapters.ini.table:

   .. table:: Parâmetros do Construtor Zend_Config_Ini

      +-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |Parâmetro              |Notas                                                                                                                                                                                                                                                                                       |
      +=======================+============================================================================================================================================================================================================================================================================================+
      |$filename              |O arquivo INI a ser carregado.                                                                                                                                                                                                                                                              |
      +-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$section               |A [seção] no arquivo INI que está sendo carregado. Definir este parâmetro como NULL irá carregar todas as seções. Alternativamente, uma matriz de nomes de seção pode ser fornecida para carregar várias seções.                                                                            |
      +-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$options (padrão FALSE)|Matriz de opções. As seguintes chaves são suportadas: allowModifications: Defina como TRUE para permitir a alteração subsequente dos dados de configuração carregados na memória. O padrão é NULLnestSeparator: Define o caractere a ser usado como separador de aninhamento. O padrão é "."|
      +-----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`parse_ini_file()`: http://php.net/parse_ini_file
