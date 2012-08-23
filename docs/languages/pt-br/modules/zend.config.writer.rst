.. EN-Revision: none
.. _zend.config.writer.introduction:

Zend_Config_Writer
==================

``Zend_Config_Writer`` lhe dá a capacidade de escrever arquivos de configuração a partir de objetos
``Zend_Config``. Ele funciona com adaptadores separados do sistema e muito fáceis de usar. Por padrão, o
``Zend_Config_Writer`` vêm embarcado com três adaptadores, que são todos baseados em arquivos. Você
instanciará um escritor com opções específicas, que podem ser **filename** e **config**. Em seguida, você irá
chamar o método ``write()`` do escritor e o arquivo de configuração será criado. Você também pode fornecer
``$filename`` e ``$config`` diretamente ao método ``write()``. Atualmente os escritores que se seguem são
fornecidos com ``Zend_Config_Writer``:

- ``Zend_Config_Writer_Array``

- ``Zend_Config_Writer_Ini``

- ``Zend_Config_Writer_Xml``

O escritor *INI* possui dois modos de renderização no que diz respeito às seções. Por padrão, a
configuração de maior nível é sempre escrita em nomes de seção. Chamando
``$writer->setRenderWithoutSections();`` todas as opções estarão escritas em um namespace global do arquivo
*INI* e nenhuma seção será aplicada.

O ``Zend_Config_Writer_Ini`` tem como adicional, a opção de parâmetro **nestSeparator**, que define o caractere
com que os nós são separados. O padrão é um ponto simples, como é o padrão também para ``Zend_Config_Ini``.

Ao modificar ou criar um objeto ``Zend_Config``, há algumas coisas que se deve conhecer. Para criar ou modificar
um valor, basta definir o parâmetro do objeto ``Zend_Config`` através do assessor de parâmetro (**->**). Para
criar uma seção na raiz ou para criar um ramo, você apenas irá criar uma nova matriz ("``$config->branch =
array();``"). Para definir qual seção estende outra, você chamará o método ``setExtend()`` na raiz do objeto
``Zend_Config``.

.. _zend.config.writer.example.using:

.. rubric:: Usando o Zend_Config_Writer

Este exemplo ilustra a utilização básica de ``Zend_Config_Writer_Xml`` para criar um novo arquivo de
configuração:

.. code-block:: php
   :linenos:

   // Cria o objeto de configuração
   $config = new Zend_Config(array(), true);
   $config->production = array();
   $config->staging    = array();

   $config->setExtend('staging', 'production');

   $config->production->db = array();
   $config->production->db->hostname = 'localhost';
   $config->production->db->username = 'production';

   $config->staging->db = array();
   $config->staging->db->username = 'staging';

   // Escreve o arquivo de configuração em uma das seguintes formas:
   // a)
   $writer = new Zend_Config_Writer_Xml(array('config'   => $config,
                                              'filename' => 'config.xml'));
   $writer->write();

   // b)
   $writer = new Zend_Config_Writer_Xml();
   $writer->setConfig($config)
          ->setFilename('config.xml')
          ->write();

   // c)
   $writer = new Zend_Config_Writer_Xml();
   $writer->write('config.xml', $config);

Isso criará um arquivo de configuração *XML* com as seções de produção e de testes, onde testes estende
produção.

.. _zend.config.writer.modifying:

.. rubric:: Modificando uma Configuração Existente

Este exemplo demonstra como editar um arquivo de configuração existente.

.. code-block:: php
   :linenos:

   // Carrega todas as seções de um arquivo de configuração
   // existente, enquanto pula o que é estendido.
   $config = new Zend_Config_Ini('config.ini',
                                 null,
                                 array('skipExtends'        => true,
                                       'allowModifications' => true));

   // Modifica um valor
   $config->production->hostname = 'foobar';

   // Escreve o arquivo de configuração
   $writer = new Zend_Config_Writer_Ini(array('config'   => $config,
                                              'filename' => 'config.ini'));
   $writer->write();

.. note::

   **Carregando um Arquivo de Configuração**

   Ao carregar um arquivo de configuração existente para modificações, é muito importante que se carregue
   todas as seções e que se pule tudo o que é estendido, para que valores não sejam fundidos. Isto é feito
   passando o **skipExtends** como opção para o construtor.

Para todos os escritores baseados em arquivo (*INI*, *XML* e Matriz *PHP*) internamente o ``render()`` é usado
para construir a string de configuração. Este método também pode ser usado externamente caso precise acessar a
string de representação dos dados de configuração.


