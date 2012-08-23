.. EN-Revision: none
.. _zend.db.adapter:

Zend_Db_Adapter
===============

``Zend_Db`` e suas classes relacionadas provêem uma interface de banco de dados *SQL* simples para Zend Framework.
``Zend_Db_Adapter`` é a classe básica que você usa para conectar sua aplicação *PHP*\ a um *SGBDR*. Há uma
classe adaptadora diferente para cada marca de *SGBDR*.

Os adaptadores ``Zend_Db`` criam uma ponte entre extensões *PHP* específicas de cada fabricante para uma
interface comum que ajuda você a escrever aplicações *PHP* uma vez e distribui-las com múltiplas marcas de
*SGBDR* com muito pouco esforço.

A interface da classe adaptadora é similar à interface da extensão `PHP Data Objects`_. ``Zend_Db`` provê
classes adaptadoras para drivers *PDO* das seguintes marcas de *SGBDR*:

- *IBM* *DB2* e Informix Dynamic Server (*IDS*), usando a extensão *PHP* `pdo_ibm`_

- MySQL, usando a extensão *PHP* `pdo_mysql`_

- Microsoft *SQL* Server, usando a extensão *PHP* `pdo_dblib`_

- Oracle, usando a extensão *PHP* `pdo_oci`_

- PostgreSQL, usando a extensão *PHP* `pdo_pgsql`_

- SQLite, usando a extensão *PHP* `pdo_sqlite`_

Além disso, ``Zend_Db`` provê classes adaptadoras que utilizam extensões de bancos de dados *PHP* para as
seguintes marcas de *SGBDR*:

- MySQL, usando a extensão *PHP* `mysqli`_

- Oracle, usando a extensão *PHP* `oci8`_

- *IBM* *DB2* e *DB2* I5, usando a extensão *PHP* `ibm_db2`_

- Firebird (Interbase), usando a extensão *PHP* `php_interbase`_

.. note::

   Cada classe adaptadora ``Zend_Db`` usa uma extensão *PHP*. Você deve ter a respectiva extensão *PHP*
   habilitada em seu ambiente *PHP* para usar uma classe adaptadora ``Zend_Db``. Por exemplo, se você usa qualquer
   uma das classes adaptadoras *PDO* do ``Zend_Db``, você precisa habilitar tanto a extensão *PDO* quanto o
   driver *PDO* para a marca de *SGBDR* que você usa.

.. _zend.db.adapter.connecting:

Conectando-se a um Banco de Dados Usando uma Adaptadora
-------------------------------------------------------

Esta seção descreve como criar uma instância de uma classe adaptadora de banco de dados. Isso corresponde a
fazer uma conexão com seu servidor *SGBDR* a partir de sua aplicação *PHP*.

.. _zend.db.adapter.connecting.constructor:

Usando um Construtor de Adaptadora Zend_Db
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Você pode criar uma instância de uma classe adaptadora usando seu construtor. Um construtor de classe adaptadora
leva um argumento, que é um matriz de parâmetros usado para declarar a conexão.

.. _zend.db.adapter.connecting.constructor.example:

.. rubric:: Usando um Construtor de Adaptadora

.. code-block:: php
   :linenos:

   $db = new Zend_Db_Adapter_Pdo_Mysql(array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

.. _zend.db.adapter.connecting.factory:

Usando a Fábrica Zend_Db
^^^^^^^^^^^^^^^^^^^^^^^^

Como uma alternativa ao uso direto do construtor da classe adaptadora, você pode criar uma instância de uma
adaptadora usando o método estático ``Zend_Db::factory()``. Este método carrega dinamicamente o arquivo da
classe adaptadora sob demanda usando o método :ref:`Zend_Loader::loadClass() <zend.loader.load.class>`.

O primeiro argumento é um string que identifica o nome base da classe adaptadora. Por exemplo, a string
'``Pdo_Mysql``' corresponde à classe ``Zend_Db_Adapter_Pdo_Mysql``. O segundo argumento é a mesma matriz de
parâmetros que você teria passado para o construtor da adaptadora.

.. _zend.db.adapter.connecting.factory.example:

.. rubric:: Using the Adapter Factory Method

.. code-block:: php
   :linenos:

   // Nós não precisamos seguir a declaração a seguir porque o
   // arquivo Zend_Db_Adapter_Pdo_Mysql será carregado para nós pelo método Zend_Db
   // factory.

   // require_once 'Zend/Db/Adapter/Pdo/Mysql.php';

   // Carrega automaticamente a classe Zend_Db_Adapter_Pdo_Mysql
   // e cria uma instância dela.
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

Se você criar sua própria classe que estende ``Zend_Db_Adapter_Abstract``, mas não nomear sua classe com o
prefixo de pacote "``Zend_Db_Adapter``", você pode usar o método ``factory()`` para carregar sua adaptadora se
você especificar a parte principal da classe adaptadora com a chave 'adapterNamespace' na matriz de parâmetros.

.. _zend.db.adapter.connecting.factory.example2:

.. rubric:: Usando o Método de Fábrica da Adaptadora para uma Classe Adaptadora Personalizada

.. code-block:: php
   :linenos:

   // Nós não precisamos carregar o arquivo da classe adaptadora
   // porque ele será carregado para nós pelo método de fábrica do Zend_Db.

   // Carrega automaticamente a classe MyProject_Db_Adapter_Pdo_Mysql e cria
   // uma instância dela.
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'             => '127.0.0.1',
       'username'         => 'webuser',
       'password'         => 'xxxxxxxx',
       'dbname'           => 'test',
       'adapterNamespace' => 'MyProject_Db_Adapter'
   ));

.. _zend.db.adapter.connecting.factory-config:

Usando Zend_Config com Zend_Db Factory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Opcionalmente, você pode especificar cada argumento do método ``factory()`` como um objeto do tipo
:ref:`Zend_Config <zend.config>`.

Se o primeiro argumento é um objeto de configuração, espera-se que ele contenha uma propriedade chamada
``adapter``, contendo uma string que designa a base do nome da classe adaptadora. Opcionalmente, o objeto pode
conter uma propriedade chamada ``params``, com subpropriedades correspondentes aos nomes de parâmetro da
adaptadora. Isso é usado somente se o segundo argumento do método ``factory()`` for omitido.

.. _zend.db.adapter.connecting.factory.example1:

.. rubric:: Usando o Método de Fábrica da Adaptadora com um Objeto Zend_Config

No exemplo abaixo, um objeto ``Zend_Config`` é criado a partir de um matriz. Você pode também carregar dados a
partir de um arquivo externo usando classes tais como :ref:`Zend_Config_Ini <zend.config.adapters.ini>` e
:ref:`Zend_Config_Xml <zend.config.adapters.xml>`.

.. code-block:: php
   :linenos:

   $config = new Zend_Config(
       array(
           'database' => array(
               'adapter' => 'Mysqli',
               'params'  => array(
                   'host'     => '127.0.0.1',
                   'dbname'   => 'test',
                   'username' => 'webuser',
                   'password' => 'secret',
               )
           )
       )
   );

   $db = Zend_Db::factory($config->database);

O segundo argumento do método ``factory()`` pode ser um matriz associativo contendo entradas correspondentes aos
parâmetros da adaptadora. Esse argumento é opcional. Se o primeiro argumento é do tipo ``Zend_Config``, é
assumido que ele contém todos os parâmetros, e o segundo argumento é ignorado

.. _zend.db.adapter.connecting.parameters:

Parâmetros da Adaptadora
^^^^^^^^^^^^^^^^^^^^^^^^

A seguinte lista explica parâmetros comuns reconhecidos pelas classes adaptadoras ``Zend_Db``.

- **host**: uma string contendo um hostname ou endereço IP do servidor de banco de dados. Se o banco de dados
  está rodando no mesmo servidor anfitrião da aplicação *PHP*, você pode usar 'localhost' ou '127.0.0.1'.

- **username**: identificador da conta para autenticar uma conexão com o servidor *SGBDR*.

- **password**: credencial de senha para autenticar uma conexão com o servidor *SGBDR*.

- **dbname**: nome da instância do banco de dados no servidor *SGBDR*.

- **port**: alguns servidores *SGBDR* podem aceitar conexões de rede em um número de porta especificado pelo
  administrador. O parâmetro port permite que você especifique a porta a qual sua aplicação *PHP* se conecta,
  para casar com a porta configurada no servidor *SGBDR*.

- **charset**: especifica o conjunto de caracteres usado para a conexão.

- **options**: este parâmetro é um matriz associativo de opções que são genéricas para todas as classes
  ``Zend_Db_Adapter``.

- **driver_options**: este parâmetro é um matriz associativo de opções adicionais que são específicas para
  uma dada extensão de banco de dados. Um uso típico deste parâmetro é para configurar atributos de um driver
  *PDO*.

- **adapterNamespace**: nomeia a parte inicial do nome da classe para a adaptadora, em vez de
  '``Zend_Db_Adapter``'. Use isto se você precisar do método ``factory()`` para carregar uma classe adaptadora de
  banco de dados não-Zend.

.. _zend.db.adapter.connecting.parameters.example1:

.. rubric:: Passando a Opção Case-Folding para a Fábrica

Você pode especificar essa opção pela constante ``Zend_Db::CASE_FOLDING``. Ela corresponde ao atributo
``ATTR_CASE`` nos drivers de banco de dados *PDO* e *IBM* *DB2*, ajustando a caixa das chaves de string nos
conjuntos de resultado de consulta. A opção leva os valores ``Zend_Db::CASE_NATURAL`` (padrão),
``Zend_Db::CASE_UPPER``, e ``Zend_Db::CASE_LOWER``.

.. code-block:: php
   :linenos:

   $options = array(
       Zend_Db::CASE_FOLDING => Zend_Db::CASE_UPPER
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Db2', $params);

.. _zend.db.adapter.connecting.parameters.example2:

.. rubric:: Passando a Opção Auto-Quoting para a Fábrica

Você pode especificar essa opção pela constante ``Zend_Db::AUTO_QUOTE_IDENTIFIERS``. Se o valor é ``TRUE``
(padrão), identificadores como nomes de tabela, nomes de coluna, e mesmo apelidos são delimitados em toda sintaxe
*SQL* gerada pelo objeto adaptador. Isso torna simples usar identificadores que contêm palavras-chave *SQL*, ou
caracteres especiais. Se o valor é ``FALSE``, identificadores não são delimitados automaticamente. Se você
precisa delimitar identificadores, você deve fazer por conta própria usando o método ``quoteIdentifier()``.

.. code-block:: php
   :linenos:

   $options = array(
       Zend_Db::AUTO_QUOTE_IDENTIFIERS => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.parameters.example3:

.. rubric:: Passando Opções de Driver PDO para a a Fábrica

.. code-block:: php
   :linenos:

   $pdoParams = array(
       PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'driver_options' => $pdoParams
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

   echo $db->getConnection()
           ->getAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY);

.. _zend.db.adapter.connecting.parameters.example4:

.. rubric:: Passando Opções de Serialização para a Fábrica

.. code-block:: php
   :linenos:

   $options = array(
       Zend_Db::ALLOW_SERIALIZATION => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.getconnection:

Gerenciando Conexões Preguiçosas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Criar uma instância de uma classe adaptadora não abre uma conexão com o servidor *SGBDR* imediatamente. A
adaptadora guarda os parâmetros de conexão, e a estabelece por demanda, na primeira vez que você precisar
executar uma consulta. Isso garante que criar um objeto adaptador é rápido é barato. Você pode criar uma
instância de uma adaptadora mesmo se não estiver certo que precisa rodar quaisquer consultas de banco de dados
durante a requisição atual que sua aplicação está servindo.

Se você precisa forçar a adaptador a se conectar ao *SGBDR*, use o método ``getConnection()``. Esse método
retorna um objeto para a conexão como representado pela respectiva extensão de banco de dados *PHP*. Por exemplo,
se você usar qualquer uma das classes adaptadoras para drivers *PDO*, então ``getConnection()`` retorna o objeto
*PDO*, depois de iniciá-lo como uma conexão ativa para o banco de dados especificado.

Pode ser útil forçar a conexão se você quer capturar quaisquer exceções que ela lançar como resultado de
credenciais de conta inválidas, ou outra falha ao conectar-se ao servidor *SGBDR*. Essas exceções não são
lançadas até que a conexão seja feita, assim isso pode ajudar a simplificar o código de sua aplicação se
você manipular as exceções em um lugar, em vez de fazê-lo na primeira consulta ao banco de dados.

Adicionalmente, uma adaptadora pode ser serializada para armazená-la, por exemplo, em uma variável de sessão.
Isso pode ser muito útil não somente para a própria adaptadora, mas para outros objetos que a agreguem, como um
objeto ``Zend_Db_Select``. Por padrão, adaptadoras têm permissão de serem serializadas, se você não quiser
isso, deve considerar passar a opção ``Zend_Db::ALLOW_SERIALIZATION`` com ``FALSE``, veja o exemplo abaixo. Em
respeito ao princípio de conexões preguiçosas, a adaptadora não reconectará a si própria depois de ser
revertida sua serialização. Você deve então chamar ``getConnection()`` por conta própria. Você pode fazer a
adaptadora se autorreconectar pela passagem de ``Zend_Db::AUTO_RECONNECT_ON_UNSERIALIZE`` com ``TRUE`` como uma
opção da adaptadora.

.. _zend.db.adapter.connecting.getconnection.example:

.. rubric:: Manipulando Exceções de Conexão

.. code-block:: php
   :linenos:

   try {
       $db = Zend_Db::factory('Pdo_Mysql', $parameters);
       $db->getConnection();
   } catch (Zend_Db_Adapter_Exception $e) {
       // talvez uma credencial de login falhou, ou talvez o SGBDR não está rodando
   } catch (Zend_Exception $e) {
       // talvez factory() falhou em carregar a classe adaptadora especificada
   }

.. _zend.db.adapter.example-database:

Banco de Dados de Exemplo
-------------------------

Na documentação para classes ``Zend_Db``, nós usamos um conjunto de tabelas simples para ilustrar o uso de
classes e métodos. Estas tabelas de exemplo podem armazenar informações sobre rastreamento de bugs em um projeto
de desenvolvimento de software. O banco de dados contém quatro tabelas:

- **accounts** armazena informação sobre cada usuário do banco de dados de rastreamento de bugs.

- **products** armazena informação sobre cada produto para o qual um bug pode ser registrado.

- **bugs** armazena informação sobre bugs, incluindo o estado atual do bug, a pessoa que o reportou, a pessoa que
  se encarregou de corrigí-lo e a pessoa que se encarregou de verificar a correção.

- **bugs_products** armazena um relacionamento entre bugs e produtos. Ela implementa um relacionamento
  muitos-para-muitos, porque para um dado bug pode ter relevância para múltiplos produtos, e, obviamente, um dado
  produto pode ter múltiplos bugs.

O seguinte pseudocódigo de linguagem de definição de dados *SQL* descreve as tabelas neste banco de dados de
exemplo. Estas tabelas de exemplo são extensivamente usadas pelos testes unitários automatizados de ``Zend_Db``.

.. code-block:: sql
   :linenos:

   CREATE TABLE accounts (
     account_name      VARCHAR(100) NOT NULL PRIMARY KEY
   );

   CREATE TABLE products (
     product_id        INTEGER NOT NULL PRIMARY KEY,
     product_name      VARCHAR(100)
   );

   CREATE TABLE bugs (
     bug_id            INTEGER NOT NULL PRIMARY KEY,
     bug_description   VARCHAR(100),
     bug_status        VARCHAR(20),
     reported_by       VARCHAR(100) REFERENCES accounts(account_name),
     assigned_to       VARCHAR(100) REFERENCES accounts(account_name),
     verified_by       VARCHAR(100) REFERENCES accounts(account_name)
   );

   CREATE TABLE bugs_products (
     bug_id            INTEGER NOT NULL REFERENCES bugs,
     product_id        INTEGER NOT NULL REFERENCES products,
     PRIMARY KEY       (bug_id, product_id)
   );

Note também que a tabela 'bugs' contém múltiplas referências de chave estrangeira para a tabela 'accounts'.
Cada uma das chaves estrangeiras pode referenciar uma linha diferente na tabela 'accounts' para um dado bug.

O diagrama abaixo ilustra o modelo físico de dados do banco de dados de exemplo.

.. image:: ../images/zend.db.adapter.example-database.png
   :width: 387
   :align: center

.. _zend.db.adapter.select:

Lendo Resultados de Consulta
----------------------------

Esta seção descreve métodos da classe adaptadora com os quais você pode rodar consultas *SELECT* e recuperar
seus resultados.

.. _zend.db.adapter.select.fetchall:

Buscando um Conjunto Completo de Resultados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Você pode rodar uma consulta *SQL* *SELECT* e recuperar seus resultados em um passo usando o método
``fetchAll()``.

O primeiro argumento para este método é uma string contendo uma declaração *SELECT*. Como alternativa, o
primeiro argumento pode ser um objeto da classe :ref:`Zend_Db_Select <zend.db.select>`. A classe adaptadora
converte automaticamente esse objeto em uma representação de string da declaração *SELECT*.

O segundo argumento para ``fetchAll()`` é um matriz de valores para substituir por curingas de parâmetro na
declaração *SQL*.

.. _zend.db.adapter.select.fetchall.example:

.. rubric:: Usando fetchAll()

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE bug_id = ?';

   $result = $db->fetchAll($sql, 2);

.. _zend.db.adapter.select.fetch-mode:

Alterando o Modo de Busca
^^^^^^^^^^^^^^^^^^^^^^^^^

Por padrão, ``fetchAll()`` retorna um matriz de linhas, cada uma das quais é um matriz associativo. As chaves do
matriz associativo são as colunas ou apelidos de coluna dados na consulta de seleção.

Você pode especificar um estilo diferente de resultados de busca usando o método ``setFetchMode()``. Os modos
suportados são identificados por constantes:

- **Zend_Db::FETCH_ASSOC**: retorna dados em um matriz de matrizs associativos. As chaves de matriz são nomes de
  coluna, como strings. Este é o modo padrão de busca para classes ``Zend_Db_Adapter``.

  Note que se sua lista de seleção contém mais de uma coluna com o mesmo nome, por exemplo se elas são de duas
  tabelas diferentes em um *JOIN*, pode haver somente uma entrada na matriz associativa para o nome dado. Se você
  usa o modo ``FETCH_ASSOC``, deve especificar apelidos de coluna em sua consulta *SELECT* para garantir que os
  nomes resultem em chaves de matriz únicas.

  Por padrão, essas strings são devolvidas como foram devolvidas pelo driver de banco de dados. Isso é
  tipicamente a leitura da coluna no servidor *SGBDR*. Você pode especificar a caixa para essas strings, usando a
  opção ``Zend_Db::CASE_FOLDING``. Especifique isso quando instanciar a adaptadora. Veja :ref:`este exemplo
  <zend.db.adapter.connecting.parameters.example1>`.

- **Zend_Db::FETCH_NUM**: retorna dados em um matriz de matrizs. Os matrizs são indexados por inteiros,
  correspondendo à posição do respectivo campo na lista de seleção da consulta.

- **Zend_Db::FETCH_BOTH**: retorna dados em um matriz de matrizs. As chaves de matriz são tanto strings como as
  usadas no modo ``FETCH_ASSOC``, como inteiros como os usados no modo ``FETCH_NUM``. Note que o número de
  elementos na matriz é o dobro do que seria se você usasse ``FETCH_ASSOC`` ou ``FETCH_NUM``.

- **Zend_Db::FETCH_COLUMN**: retorna dados em um matriz de valores. O valor em cada matriz é o valor retornado
  pela coluna do conjunto de resultados. Por padrão, essa é a primeira coluna, indexada por 0.

- **Zend_Db::FETCH_OBJ**: retorna dados em um matriz de objetos. A classe padrão é a classe interna *PHP*
  stdClass. Colunas do conjunto de resultados estão disponíveis como propriedades públicas do objeto.

.. _zend.db.adapter.select.fetch-mode.example:

.. rubric:: Usando setFetchMode()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAll('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result é um matriz de objetos
   echo $result[0]->bug_description;

.. _zend.db.adapter.select.fetchassoc:

Buscando um Conjunto de Resultados como um matriz Associativo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

O método ``fetchAssoc()`` retorna dados em uma matriz de matrizes associativas, independente de qual valor você
tenha configurado para o modo de busca, utilizando a primeira coluna como índice da matriz.

.. _zend.db.adapter.select.fetchassoc.example:

.. rubric:: Usando fetchAssoc()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAssoc(
       'SELECT bug_id, bug_description, bug_status FROM bugs'
   );

   // $result é uma matriz de matrizes associativas, conforme o modo de busca
   echo $result[2]['bug_description']; // Descrição do Bug #2
   echo $result[1]['bug_description']; // Descrição do Bug #1

.. _zend.db.adapter.select.fetchcol:

Buscando uma Única Coluna a partir de um Conjunto de Resultados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

O método ``fetchCol()`` retorna dados em um matriz de valores, independente do valor que você tenha configurado
para o modo de busca Ele devolve somente a primeira coluna devolvida pela consulta. Quaisquer outras colunas
devolvidas pela consulta são descartadas. Se você precisar devolver uma outra coluna que não seja a primeira,
veja :ref:`esta seção <zend.db.statement.fetching.fetchcolumn>`.

.. _zend.db.adapter.select.fetchcol.example:

.. rubric:: Usando fetchCol()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchCol(
       'SELECT bug_description, bug_id FROM bugs WHERE bug_id = ?', 2);

   // contém bug_description; bug_id não é devolvida
   echo $result[0];

.. _zend.db.adapter.select.fetchpairs:

Buscando Pares Chave-Valor a partir de um Conjunto de Resultados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

O método ``fetchPairs()`` retorna dados em um matriz de pares chave-valor, como um matriz associativo com uma
entrada única por linha. A chave desse matriz associativo é tomada da primeira coluna devolvida pela consulta
*SELECT*. O valor é tomado da segunda coluna devolvida pela consulta *SELECT*. Quaisquer outras colunas devolvidas
pela consulta são descartadas.

Você deve projetar a conuslta *SELECT* de modo que a primeira coluna devolvida tenha valores únicos. Se há
valores duplicados na primeira coluna, entradas na matriz associativo serão sobrescritas.

.. _zend.db.adapter.select.fetchpairs.example:

.. rubric:: Usando fetchPairs()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchPairs('SELECT bug_id, bug_status FROM bugs');

   echo $result[2];

.. _zend.db.adapter.select.fetchrow:

Buscando uma Linha Única a partir de um Conjunto de Resultados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

O método ``fetchRow()`` retorna dados usando o modo de busca atual, mas retorna somente a primeira linha buscada a
partir do conjunto de resultados.

.. _zend.db.adapter.select.fetchrow.example:

.. rubric:: Using fetchRow()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchRow('SELECT * FROM bugs WHERE bug_id = 2');

   // note que $result é um único objeto, não um matriz de objetos
   echo $result->bug_description;

.. _zend.db.adapter.select.fetchone:

Buscando um Escalar Único a partir de um Conjunto de Resultados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

O método ``fetchOne()`` é como uma combinação do método ``fetchRow()`` com o método ``fetchCol()``, no que
ele retorna dados somente para a primeira linha buscada a partir do conjunto de resultados, e retorna somente o
valor da primeira coluna naquela linha. Portanto ele retorna somente um único valor escalar, nem um matriz nem um
objeto.

.. _zend.db.adapter.select.fetchone.example:

.. rubric:: Usando fetchOne()

.. code-block:: php
   :linenos:

   $result = $db->fetchOne('SELECT bug_status FROM bugs WHERE bug_id = 2');

   // este é um valor string único
   echo $result;

.. _zend.db.adapter.write:

Gravando Mudanças no Banco de Dados
-----------------------------------

Você pode usar a classe adaptadora para gravar novos dados ou alterar dados existentes em seu banco de dados. Esta
seção descreve métodos para fazer essas operações.

.. _zend.db.adapter.write.insert:

Incluindo Dados
^^^^^^^^^^^^^^^

Você pode adicionar novas linhas em uma tabela de seu banco de dados usando o método ``insert()``. O primeiro
argumento é uma string que denomina a tabela, e o segundo argumento é um matriz associativo, mapeando nomes de
coluna para valores de dados.

.. _zend.db.adapter.write.insert.example:

.. rubric:: Incluindo em uma Tabela

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

Colunas que você excluir da matriz de dados não serão especificadas para o banco de dados. Portanto, elas seguem
as mesmas regras que uma declaração *SQL* *INSERT* segue: se a coluna tem uma cláusula *DEFAULT*, a coluna leva
o valor na linha criada, caso contrário é deixado em um estado ``NULL``.

Por padrão, os valores em seu matriz de dados são incluídos usando parâmetros. ISso reduz o risco de alguns
tipos de problemas de segurança. Você não precisa aplicar escaping ou quoting para valores na matriz de dados.

Você pode precisar que valores na matriz de dados sejam tratados como expressões *SQL*, caso no qual elas não
devam sofrer quoting. Por padrão, todos os valores de dados passados como strings são tratados como literais
string. Para especificar que o valor é uma expressão *SQL* e portanto não deve sofrer quoting, passe o valor na
matriz de dados como um objeto do tipo ``Zend_Db_Expr`` em vez de texto claro.

.. _zend.db.adapter.write.insert.example2:

.. rubric:: Incluindo Expressões em uma Tabela

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => new Zend_Db_Expr('CURDATE()'),
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

.. _zend.db.adapter.write.lastinsertid:

Recuperando um Valor Gerado
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Algumas marcas de *SGBDR* suportam autoincremento de chaves primárias. Uma tabela definida desse modo gera um
valor de chave primária automaticamente durante um *INSERT* de uma nova linha. O valor de retorno do método
``insert()`` **não** é o último ID incluído, porque a tabela pode não ter uma coluna de autoincremento. Em vez
disso, o valor de retorno é o número de linhas afetadas (geralmente 1).

Se sua tabela é definida com uma chave primária de autoincremento você pode chamar o método ``lastInsertId()``
depois da inclusão. Esse método retonra o último valor gerado no escopo da conexão atual com o banco de dados.

.. _zend.db.adapter.write.lastinsertid.example-1:

.. rubric:: Usando lastInsertId() para uma Chave de Autoincremento

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // retorna o último valor gerado por uma coluna de autoincremento
   $id = $db->lastInsertId();

Algumas marcas de *SGBDR* suportam um objeto de sequencia, que gera valores únicos para servir como valores da
chave primária. Para suportar sequencias, o método ``lastInsertId()`` aceita dois argumentos string opcionais.
Esses argumentos denominam a tabela e a coluna, assumindo que você tenha seguido a convenção de que uma
sequencias é denominada usando os nomes de tabela e coluna para os quais a sequencia gera valores, e um sufixo
"\_seq". Isso é baseado na convenção usada pelo PostgreSQL quando nomeia sequencias para colunas ``SERIAL``. Por
exemplo, uma tabela "bugs" com a coluna de chave primária "bug_id" usaria uma sequencia denominada
"bugs_bug_id_seq".

.. _zend.db.adapter.write.lastinsertid.example-2:

.. rubric:: Usando lastInsertId() para uma Sequencia

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // retorna o último valor gerado pela sequencia 'bugs_bug_id_seq'.
   $id = $db->lastInsertId('bugs', 'bug_id');

   // alternativamente, retorna o último valor gerado pela sequencia 'bugs_seq'.
   $id = $db->lastInsertId('bugs');

Se o nome de seu objeto de sequencia não seguir essa convenção de nomes, use o método ``lastSequenceId()`` em
seu lugar. Esse método leva um único argumento string, nomeando literalmente a sequencia.

.. _zend.db.adapter.write.lastinsertid.example-3:

.. rubric:: Usando lastSequenceId()

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // retorna o último valor gerado pela sequencia 'bugs_id_gen'.
   $id = $db->lastSequenceId('bugs_id_gen');

Para as marcas de *SGBDR* que não suportam sequencias, incluindo MySQL, Microsoft *SQL* Server, e SQLite, os
argumentos para o método ``lastInsertId()`` são ignorados, e o valor devolvido é o valor mais recente gerado
para qualquer tabela por operações *INSERT* durante a conexão atual. Para essas marcas de *SGBDR*, o método
``lastSequenceId()`` sempre devolve ``NULL``.

.. note::

   **Porque Não Usar "SELECT MAX(id) FROM table"?**

   Algumas essa consulta retorna valor de chave primária mais recente incluído em uma tabela. Entretanto, essa
   técnica não é segura para ser usada em um ambiente onde múltiplos clientes estão incluindo registros no
   banco de dados. É possível, e portanto pode acontecer eventualmente, que outro cliente inclua outra linha no
   instante entre a inclusão executada por sua aplicação cliente e sua consulta para o valor de ``MAX(id)``.
   Assim o valor devolvido não identifica a linha que você incluiu, mas sim a linha incluída por algum outro
   cliente. Não há um modo de saber quando isso aconteceu.

   Usar um modo de isolamento de transação forte tal como "repeatable read" pode mitigar esse risco, mas algumas
   marcas de *SGBDR* não suportam o isolamento de transação necessário para isso, ou sua aplicação pode usar
   um modo de isolamento de transação baixo por projeto.

   Além disso, usar uma expressão como "``MAX(id)+1``" para gerar um novo valor para uma chave primária não é
   seguro, porque dois clientes poderiam fazer esta consulta simultanamente, e em seguida, ambos usariam o mesmo
   valor calculado para sua próxima operação *INSERT*.

   Todas as marcas de *SGBDR* fornecem mecanismos para gerar valores únicos e retornar o último valor gerado.
   Esses mecanismos necessariamente trabalham fora do escopo de isolamento da transação, portanto, não há
   chance de dois clientes gerarem o mesmo valor, e não há chance de que o valor gerado por um outro cliente
   possa ser informado à sua conexão de cliente como o último valor gerado.

.. _zend.db.adapter.write.update:

Updating Data
^^^^^^^^^^^^^

Você pode atualizar linhas em uma tabela de banco de dados usando o método ``update()`` de uma adaptadora. Esse
método leva três argumentos: o primeiro é o nome da tabela, o segundo é um matriz associativo mapeando as
colunas a serem alteradas para os novos valores a serem atribuídos a essas colunas.

Os valores na matriz de dados são tratados como sequências de caracteres. Veja :ref:`esta seção
<zend.db.adapter.write.insert>` para obter informações sobre como utilizar expressões *SQL* na matriz de dados.

O terceiro argumento é uma string contendo uma expressão *SQL* que é usada como critério para as linhas a serem
alteradas. Os valores e identificadores nesse argumento não são citados ou escapados. Você é responsável por
garantir que o conteúdo dinâmico seja interpolados para essa sequência de forma segura. Veja :ref:`esta seção
<zend.db.adapter.quoting>` para métodos que o ajudam a fazer isso.

O valor de retorno é o número de linhas afetadas pela operação de atualização.

.. _zend.db.adapter.write.update.example:

.. rubric:: Atualizando Linhas

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $n = $db->update('bugs', $data, 'bug_id = 2');

Se você omitir o terceiro argumento, então todas as linhas na tabela do banco de dados são atualizadas com os
valores especificados no matriz de dados.

Se você fornecer um matriz de strings como terceiro argumento, essas strings são unidas como termos em uma
expressão separada por operadores ``AND``.

Se você fornecer um matriz de matrizs como terceiro argumento, os valores serão automaticamente citados dentro
das chaves. Esses serão então unidos como termos, separados por operadores ``AND``.

.. _zend.db.adapter.write.update.example-array:

.. rubric:: Atualizando Linhas Usando um matriz de Expressões

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where[] = "reported_by = 'goofy'";
   $where[] = "bug_status = 'OPEN'";

   $n = $db->update('bugs', $data, $where);

   // A SQL resultante é:
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.update.example-arrayofarrays:

.. rubric:: Atualizando Linhas Usando um matriz de matrizs

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where['reported_by = ?'] = 'goofy';
   $where['bug_status = ?']  = 'OPEN';

   $n = $db->update('bugs', $data, $where);

   // A SQL resultante é:
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.delete:

Excluindo Dados
^^^^^^^^^^^^^^^

Você pode excluir linhas de uma tabela de banco de dados usando o método ``delete()``\ methodName>. Esse método
leva dois argumentos: O primeiro é uma string com o nome da tabela.

O segundo argumento é uma string contendo uma expressão *SQL* que é usada como critério para as linhas a
eliminar. Os valores e identificadores nesse argumento não são citados ou escapado. Você é responsável por
garantir que o conteúdo dinâmico seja interpolado para esta seqüência de forma segura. Veja :ref:`esta seção
<zend.db.adapter.quoting>` para métodos que o ajudam a fazer isso.

O valor de retorno é o número de linhas afetadas pela operação de exclusão.

.. _zend.db.adapter.write.delete.example:

.. rubric:: Excluindo Linhas

.. code-block:: php
   :linenos:

   $n = $db->delete('bugs', 'bug_id = 3');

Se você omitir o segundo argumento, o resultado é que todas as linhas na tabela do banco de dados são
eliminadas.

Se você fornecer um matriz de strings como o segundo argumento, essas strings são unidas como termos em uma
expressão separada por operadores ``AND``.

Se você fornecer um matriz de matrizs como segundo argumento, os valores serão automaticamente citados dentro das
chaves. Esses serão então unidos como termos, separados por operadores ``AND``.

.. _zend.db.adapter.quoting:

Citando Valores e Identificadores
---------------------------------

Quando você monta consultas *SQL*, muitas vezes é o caso de você precisar incluir os valores de variáveis *PHP*
em expressões *SQL*. Isso é arriscado, porque se o valor em uma string *PHP* contém certos símbolos, como o
símbolo de citação, isso pode resultar em *SQL* inválido. Por exemplo, observe os apóstrofos não balanceados
na seguinte consulta:

.. code-block:: php
   :linenos:

   $name = "O'Reilly";
   $sql = "SELECT * FROM bugs WHERE reported_by = '$name'";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O'Reilly'

Ainda pior é o risco de tais erros de código possam ser explorados deliberadamente por uma pessoa que está
tentando manipular a função de sua aplicação web. Se eles podem especificar o valor de uma variável *PHP*
através do uso de um parâmetro *HTTP* ou outro mecanismo, eles podem ser capazes de fazer suas consultas *SQL*
fazerem coisas que você não pretendia que elas fizessem, tais retornar dados para a pessoa que não deveria ter o
privilégio de lê-los. Essa é uma técnica grave e generalizada para violar a segurança do aplicativo, conhecido
como "SQL Injection" (veja `http://en.wikipedia.org/wiki/SQL_Injection`_).

A classe adaptadora ``Zend_Db`` fornece funções convenientes para ajudar a reduzir as vulnerabilidades para
ataques de Injeção de *SQL* em seu código *PHP*. A solução é escapar caracteres especiais tais como
apóstrofos em valores *PHP* antes deles serem interpolados em suas strings *SQL*. Isso protege tanto contra
manipulação acidental quanto deliberada de strings *SQL* por variáveis *PHP* que contém caracteres especiais.

.. _zend.db.adapter.quoting.quote:

Usando quote()
^^^^^^^^^^^^^^

O método ``quote()`` aceita um único argumento, um valor string escalar. Ele retorna o valor com caracteres
especiais de uma forma adequada para o *SGBDR* que você está usando, e rodeado por delimitadores de valor de
string. O delimitador de valor de string padrão *SQL* é o apóstrofo ( ').

.. _zend.db.adapter.quoting.quote.example:

.. rubric:: Usando quote()

.. code-block:: php
   :linenos:

   $name = $db->quote("O'Reilly");
   echo $name;
   // 'O\'Reilly'

   $sql = "SELECT * FROM bugs WHERE reported_by = $name";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Note que o valor de retorno de ``quote()`` inclui os delimitadores de citação em torno da cadeia. Isso é
diferente de algumas funções que escapam caracteres especiais, mas não adicionam os delimitadores de citação,
por exemplo `mysql_real_escape_string()`_.

Os valores podem precisar ser citados ou não citados de acordo com o contexto de tipo de dados *SQL* em que eles
são usados. Por exemplo, em algumas marcas de *SGBDR*, um valor inteiro não deve ser citado como uma string se
for comparado a uma coluna ou expressão do tipo inteiro. Em outras palavras, o código seguinte é um erro em
algumas implementações *SQL*, assumindo que ``intColumn`` tem um tipo de dados *SQL* ``INTEGER``

.. code-block:: php
   :linenos:

   SELECT * FROM atable WHERE intColumn = '123'

Você pode usar o segundo argumento opcional para o método ``quote()`` para aplicar citação seletivamente para o
tipo de dados *SQL* que você especificar.

.. _zend.db.adapter.quoting.quote.example-2:

.. rubric:: Usando quote() com um Tipo SQL

.. code-block:: php
   :linenos:

   $value = '1234';
   $sql = 'SELECT * FROM atable WHERE intColumn = '
        . $db->quote($value, 'INTEGER');

Cada classe ``Zend_Db_Adapter`` tem codificada os nomes de tipos de dados *SQL* numéricos para a respectiva marca
de *SGBDR*. Você também pode usar as constantes ``Zend_Db::INT_TYPE``, ``Zend_Db::BIGINT_TYPE``, e
``Zend_Db::FLOAT_TYPE`` para escrever código de uma forma mais independente de *SGBDR*.

``Zend_Db_Table`` especifica *SQL* para ``quote()`` automaticamente ao gerar consultas *SQL* que referenciam
colunas-chave de uma tabela.

.. _zend.db.adapter.quoting.quote-into:

Usando quoteInto()
^^^^^^^^^^^^^^^^^^

O uso mais típico de citação é para interpolar uma variável *PHP* em uma expressão ou declaração *SQL*.
Você pode usar o método ``quoteInto()`` para fazer isso em uma única etapa. Esse método leva dois argumentos: o
primeiro argumento é uma string contendo um símbolo marcador (?), e o segundo argumento é um valor ou variável
*PHP* que deve ser substituída pelo marcador.

O símbolo marcador é o mesmo símbolo usado por muitas marcas de *SGBDR* para parâmetros posicionais, mas o
método ``quoteInto()`` apenas emula parâmetros de consulta. O método simplesmente interpola o valor para a
string, escapa caracteres especiais, e aplica apóstrofos em torno dele. Parâmetros de consulta verdadeiros
mantêm a separação entre a string *SQL* e os parâmetros assim que a declaração é analisada no servidor
*SGBDR*.

.. _zend.db.adapter.quoting.quote-into.example:

.. rubric:: Usando quoteInto()

.. code-block:: php
   :linenos:

   $sql = $db->quoteInto("SELECT * FROM bugs WHERE reported_by = ?", "O'Reilly");

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Você pode usar o terceiro parâmetro opcional de ``quoteInto()`` para especificar o tipo de dados *SQL*. Tipos de
dados numéricos não são citados, e outros tipos são citados.

.. _zend.db.adapter.quoting.quote-into.example-2:

.. rubric:: Using quoteInto() with a SQL Type

.. code-block:: php
   :linenos:

   $sql = $db
       ->quoteInto("SELECT * FROM bugs WHERE bug_id = ?", '1234', 'INTEGER');

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 1234

.. _zend.db.adapter.quoting.quote-identifier:

Usando quoteIdentifier()
^^^^^^^^^^^^^^^^^^^^^^^^

Os valores não são a única parte da sintaxe *SQL* que pode precisar ser variável. Se você usar variáveis
*PHP* para nomear tabelas, colunas, ou outros identificadores em suas declarações *SQL*, pode ser necessário
citar essas strings também. Por padrão, identificadores *SQL* têm regras de sintaxe como *PHP* e a maioria das
outras linguagens de programação. Por exemplo, os identificadores não devem conter espaços, certas pontuações
ou caracteres especiais, ou ainda caracteres internacionais. Certas palavras também são reservadas para a sintaxe
*SQL*, e não devem ser usadas como identificadores.

No entanto, *SQL* tem um recurso chamado **identificadores delimitados**, que permite escolhas mais amplas para a
grafia de identificadores. Se você colocar um identificador *SQL* no tipo adequado de aspas, pode usar
identificadores com dados que seriam inválidos sem as aspas. Identificadores delimitados podem conter espaços,
pontuação, ou caracteres internacionais. Você também pode usar palavras reservadas da *SQL* se colocá-las em
identificadores delimitados.

O método ``quoteIdentifier()`` trabalha como ``quote()``, mas ele aplica caracteres delimitadores de identificador
para a string de acordo com o tipo de adaptador que você usar. Por exemplo, a *SQL* padrão usa aspas duplas (")
para delimitadores de identificador, e a maioria das marcas de *SGBDR* marcas usam esse símbolo. O MySQL usa crase
(\`) por padrão. O método ``quoteIdentifier()`` também escapa caracteres especiais dentro do argumento string.

.. _zend.db.adapter.quoting.quote-identifier.example:

.. rubric:: Usando quoteIdentifier()

.. code-block:: php
   :linenos:

   // podemos deter um nome de tabela que é uma palavra reservada SQL
   $tableName = $db->quoteIdentifier("order");

   $sql = "SELECT * FROM $tableName";

   echo $sql
   // SELECT * FROM "order"

Identificadores delimitados *SQL* são sensíveis à caixa, ao contrário de identificadores não citados.
Portanto, se você usar identificadores delimitados, você deve usar a ortografia do identificador exatamente como
ela é armazenada no seu esquema, incluindo a caixa das letras.

Na maioria dos casos onde *SQL* é gerada dentro de classes ``Zend_Db``, o padrão é que todos os identificadores
sejam delimitados automaticamente. Você pode alterar esse comportamento com a opção
``Zend_Db::AUTO_QUOTE_IDENTIFIERS``. Especifique essa opção ao instanciar o adaptador. Veja :ref:`este exemplo
<zend.db.adapter.connecting.parameters.example2>`.

.. _zend.db.adapter.transactions:

Controlando Transações de Banco de Dados
----------------------------------------

Bases de dados definem as operações como unidades lógicas de trabalho que podem ser confirmadas ou revertidas
como uma única mudança, mesmo que operem em várias tabelas. Todas as consultas ao banco de dados são executadas
no no contexto de uma transação, mesmo se o driver de banco de dados as gerencia implicitamente. Isso é chamado
modo **auto-commit**, no qual o driver de banco cria uma transação para cada declaração que você executa, e
confirma essa transação após sua declaração *SQL* ser executada. Por padrão, todas as classes adaptadoras
``Zend_Db`` operam em modo auto-commit.

De forma alternativa, você pode especificar o início e resolução de uma transação, e assim controlar quantas
consultas *SQL* estão incluídas em um único grupo que é confirmado (ou revertido) como uma única transação.
Use o método ``beginTransaction()`` para iniciar uma transação. Posteriormente declarações *SQL* são
executadas no contexto da mesma transação, até que você o resolva explicitamente.

Para resolver a transação, use o método ``commit()`` ou ``rollBack()``. O método ``commit()`` altera marcas
feitas durante a sua transação como confirmadas, o que significa que os efeitos dessas mudanças são mostrados
em consultas executadas em outras transações.

O método ``rollBack()`` faz o oposto: ele descarta as alterações feitas durante a transação. As mudanças são
efetivamente desfeitas, e o estado dos dados retorna a como estava antes de você começar sua transação. No
entanto, a reversão de sua transação não tem efeito sobre as mudanças feitas por outras transações
executadas simultaneamente.

Depois de resolver essa operação, ``Zend_Db_Adapter`` retorna ao modo auto-commit, até que você chame
``beginTransaction()`` novamente.

.. _zend.db.adapter.transactions.example:

.. rubric:: Gerenciando uma Transação para Garantir Consistência

.. code-block:: php
   :linenos:

   // Inicie uma transação explicitamente.
   $db->beginTransaction();

   try {
       // Tenta executar uma ou mais consultas:
       $db->query(...);
       $db->query(...);
       $db->query(...);

       // Se todas tem sucesso, confirma a transação e todas as mudanças
       // são confirmadas de uma vez.
       $db->commit();

   } catch (Exception $e) {
       // Se qualquer uma das consultas falhar e lançar uma exceção
       // nós queremos desfazer a transação inteira, revertendo
       // mudanças feitas na transação, mesmo aquelas que tiveram sucesso
       // Assim todas as mudanças são confirmadas juntas, ou nenhuma é.
       $db->rollBack();
       echo $e->getMessage();
   }

.. _zend.db.adapter.list-describe:

Listando e Descrevendo Tabelas
------------------------------

O método ``listTables()`` retorna uma matriz de strings, com os nomes de todas as tabelas do banco de dados atual.

O método ``describeTable()`` retorna uma matriz associativa de metadados sobre uma tabela. Especifique o nome da
tabela como uma string no primeiro argumento para este método. O segundo argumento é opcional, e identifica o
esquema no qual a tabela existe.

As chaves da matriz associativa retornada são os nomes das colunas da tabela. O valor correspondente a cada coluna
é também uma matriz associativa, com as seguintes chaves e valores:

.. _zend.db.adapter.list-describe.metadata:

.. table:: Campos de Metadados Devolvidos por describeTable()

   +----------------+---------+-------------------------------------------------------------------------------+
   |Key             |Type     |Description                                                                    |
   +================+=========+===============================================================================+
   |SCHEMA_NAME     |(string) |Nome do esquema do banco de dados no qual essa tabela existe.                  |
   +----------------+---------+-------------------------------------------------------------------------------+
   |TABLE_NAME      |(string) |Nome da tabela a qual esta coluna pertence.                                    |
   +----------------+---------+-------------------------------------------------------------------------------+
   |COLUMN_NAME     |(string) |Nome da coluna.                                                                |
   +----------------+---------+-------------------------------------------------------------------------------+
   |COLUMN_POSITION |(integer)|Posição ordinal da coluna na tabela.                                           |
   +----------------+---------+-------------------------------------------------------------------------------+
   |DATA_TYPE       |(string) |Nome do tipo de dados do SGBDR da coluna.                                      |
   +----------------+---------+-------------------------------------------------------------------------------+
   |DEFAULT         |(string) |Valor padrão para a coluna, se houver.                                         |
   +----------------+---------+-------------------------------------------------------------------------------+
   |NULLABLE        |(boolean)|TRUE se a coluna aceita SQLNULL's, FALSE se a coluna tem uma restrição NOTNULL.|
   +----------------+---------+-------------------------------------------------------------------------------+
   |LENGTH          |(integer)|Comprimento ou tamanho da coluna como informado pelo SGBDR.                    |
   +----------------+---------+-------------------------------------------------------------------------------+
   |SCALE           |(integer)|Escala de tipo SQLNUMERIC ou DECIMAL.                                          |
   +----------------+---------+-------------------------------------------------------------------------------+
   |PRECISION       |(integer)|Precisão de tipo SQLNUMERIC ou DECIMAL.                                        |
   +----------------+---------+-------------------------------------------------------------------------------+
   |UNSIGNED        |(boolean)|TRUE se um tipo baseado em inteiro for informado como UNSIGNED.                |
   +----------------+---------+-------------------------------------------------------------------------------+
   |PRIMARY         |(boolean)|TRUE se a coluna é parte da chave primária dessa tabela.                       |
   +----------------+---------+-------------------------------------------------------------------------------+
   |PRIMARY_POSITION|(integer)|Posição ordinal (baseada em 1) da coluna na chave primária.                    |
   +----------------+---------+-------------------------------------------------------------------------------+
   |IDENTITY        |(boolean)|TRUE se a coluna usa um valor autogerado.                                      |
   +----------------+---------+-------------------------------------------------------------------------------+

.. note::

   **Como o Campo de Metadados IDENTITY Relaciona-se com SGBDRs Específicos**

   O campo de metadados ``IDENTITY`` foi escolhido como um termo 'idiomático' para representar uma relação de
   chaves substitutas. Este campo pode ser vulgarmente conhecido pelos seguintes valores: --

   - ``IDENTITY``-*DB2*, *MSSQL*

   - ``AUTO_INCREMENT``- MySQL

   - ``SERIAL``- PostgreSQL

   - ``SEQUENCE``- Oracle

Se não houver nenhum tabela que se encaixe com o nome da tabela e nome de esquema opcional especificado, então
``describeTable()`` retorna uma matriz vazia.

.. _zend.db.adapter.closing:

Fechando uma Conexão
--------------------

Normalmente não é necessário fechar uma conexão de dados. *PHP* limpa automaticamente todos os recursos ao
final de uma requisição. Extensões de Banco de Dados são projetadas para fechar a conexão assim que a
referência para o objeto do recurso é eliminada.

No entanto, se você tem um script de longa duração *PHP* que inicia muitas conexões de banco de dados, talvez
seja necessário encerrar a conexão, para evitar um esgotamento da capacidade de seu servidor *SGBDR*. Você pode
usar o método ``closeConnection()`` da classe adaptadora fechar explicitamente a conexão de dados subjacente.

Desde a versão 1.7.2, você pode verificar se está conectado ao servidor *SGBDR* com o método ``isConnected()``.
Isso significa que um recurso de conexão foi iniciado e não foi fechado. Essa função não é atualmente capaz
de testar, por exemplo, um fechamento do lado servidor da conexão. Ela é usada internamente para fechar a
conexão. Isso permite que você feche a conexão várias vezes sem erros. Já era o caso antes de 1.7.2 para
adaptadores *PDO*, mas não para os outros.

.. _zend.db.adapter.closing.example:

.. rubric:: Fechando uma Conexão com o Banco de Dados

.. code-block:: php
   :linenos:

   $db->closeConnection();

.. note::

   **Zend_Db Suporta Conexões Persistentes?**

   Sim, a persistência é suportada através da adição da propriedade ``persistent`` definida como ``TRUE`` na
   configuração (não em driver_configuration) de um adaptador em ``Zend_Db``.

   .. _zend.db.adapter.connecting.persistence.example:

   .. rubric:: Usando a Propriedade Persistence com o Adaptador Oracle

   .. code-block:: php
      :linenos:

      $db = Zend_Db::factory('Oracle', array(
          'host'       => '127.0.0.1',
          'username'   => 'webuser',
          'password'   => 'xxxxxxxx',
          'dbname'     => 'test',
          'persistent' => true
      ));

   Por favor, note que o uso de conexões persistentes pode causar um excesso de conexões inativas no servidor
   *SGBDR*, o que leva a mais problemas do que qualquer ganho de desempenho que você possa obter por reduzir a
   sobrecarga de fazer conexões.

   Conexões de banco de dados tem estado. Isto é, alguns objetos no servidor *SGBDR* existem no escopo de
   sessão. Exemplos são bloqueios, variáveis de usuário, tabelas temporárias, e informações sobre as
   consultas mais recentemente executadas, tais como linhas afetadas e o último valor gerado de id. Se você usa
   conexões persistentes, a sua aplicação pode acessar dados inválidos ou privilegiadas que foram criado em uma
   solicitação *PHP* anterior.

   Atualmente, apenas Oracle, *DB2*, e os adaptadores *PDO* (onde especificado pelo *PHP*) suportam persistência
   em ``Zend_Db``.

.. _zend.db.adapter.other-statements:

Rodando Outras Declarações de Banco de Dados
--------------------------------------------

Pode haver casos em que você precisa acessar o objeto de conexão diretamente, como provido pela extensão de
banco de dados *PHP*. Algumas dessas extensões podem oferecer recursos que não são cobertos por métodos de
``Zend_Db_Adapter_Abstract``.

Por exemplo, todas as declarações *SQL* rodadas por ``Zend_Db`` são preparadas, então executadas. No entanto,
algumas funções de banco de dados são incompatíveis com declarações preparadas. Instruções ``DDL`` como
``CREATE`` e ``ALTER`` não podem ser preparadas no MySQL. Além disso, declarações *SQL* não se beneficiam do
`MySQL Query Cache`_, antes do MySQL 5.1.17.

A maioria das extensões de banco de dados *PHP* fornecem um método para executar declarações *SQL* sem
prepará-los. Por exemplo, em *PDO*, esse método é ``exec()``. Você pode acessar o objeto de conexão na
extensão *PHP* diretamente usando ``getConnection()``.

.. _zend.db.adapter.other-statements.example:

.. rubric:: Rodando uma Declaração Não Preparada em um Adaptador PDO

.. code-block:: php
   :linenos:

   $result = $db->getConnection()->exec('DROP TABLE bugs');

A maioria das extensões de banco de dados *PHP* fornecem um método para executar declarações *SQL* sem
prepará-los. Por exemplo, em *PDO*, esse método é ``exec()``. Você pode acessar o objeto de conexão na
extensão *PHP* diretamente usando ``getConnection()``.

Em versões futuras de ``Zend_Db``, haverá oportunidades de adicionar pontos de entrada de método para
funcionalidades que são comuns às extensões de banco de dados *PHP* suportadas . Isso não afetará
compatibilidade com versões anteriores.

.. _zend.db.adapter.server-version:

Recuperanco a Versão do Servidor
--------------------------------

Desde a versão 1.7.2, você pode recuperar a versão do servidor no estilo de sintaxe *PHP* para ser capaz de usar
``version_compare()``. Se a informação não estiver disponível, você receberá ``NULL``.

.. _zend.db.adapter.server-version.example:

.. rubric:: Verificando a versão do servidor antes de rodar uma consulta

.. code-block:: php
   :linenos:

   $version = $db->getServerVersion();
   if (!is_null($version)) {
       if (version_compare($version, '5.0.0', '>=')) {
           // faz alguma coisa
       } else {
           // faz alguma outra coisa
       }
   } else {
       // impossível ler a versão do servidor
   }

.. _zend.db.adapter.adapter-notes:

Notas sobre Adaptadores Específicos
-----------------------------------

Esta seção lista diferenças entre as classes adaptadoras sobre as quais você deve ficar atento.

.. _zend.db.adapter.adapter-notes.ibm-db2:

IBM DB2
^^^^^^^

- Especifique esse adaptador para o método ``factory()`` com o nome 'Db2'.

- Este adaptador usa a extensão *PHP* ``IBM_DB2``.

- *IBM* *DB2* suporta tanto seqüências quanto chaves de autoincremento. Portanto os argumentos para
  ``lastInsertId()`` são opcionais. Se você não fornecer argumentos, o adaptador retorna o último valor gerado
  para uma chave de autoincremento. Se você fornecer argumentos, o adaptador retorna o último valor gerado pela
  seqüência nomeada de acordo com a convenção '**table**\ _ **column**\ _seq'.

.. _zend.db.adapter.adapter-notes.mysqli:

MySQLi
^^^^^^

- Especifique esse adaptador para o método ``factory()`` com o nome 'Mysqli'.

- Este adaptador utiliza a extensão *PHP*.

- O MySQL não suporta sequências, assim ``lastInsertId()`` ignora seus argumentos e sempre retorna o último
  valor gerado para uma chave de autoincremento. O método ``lastSequenceId()`` retorna ``NULL``.

.. _zend.db.adapter.adapter-notes.oracle:

Oracle
^^^^^^

- Especifique esse adaptador para o método ``factory()`` com o nome de 'Oracle'.

- Esse adaptador usa a extensão *PHP* oci8.

- Oracle não suporta chaves de autoincremento, assim você deve especificar o nome de uma sequência de
  ``lastInsertId()`` ou ``lastSequenceId()``.

- A extensão da Oracle não suporta parâmetros posicionais. Você deve usar parâmetros nomeados.

- Atualmente, a opção ``Zend_Db::CASE_FOLDING`` não é suportada pelo adaptador Oracle. Para utilizar essa
  opção com a Oracle, você deve usar o adaptador *PDO* *OCI*.

- Por padrão, os campos *LOB* são devolvidos como objetos *OCI*-Lob. Você pode recuperá-los como string para
  todas as solicitações, utilizando as opções do driver '``lob_as_string``' ou para uma solicitação
  particular, usando ``setLobAsString(boolean)`` no adaptador ou na declaração.

.. _zend.db.adapter.adapter-notes.sqlsrv:

Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^

- Especifique esse adaptador para o método ``factory()`` com o nome 'Sqlsrv'.

- Esse adaptador usa a extensão *PHP* sqlsrv.

- Somente o Microsoft *SQL* Server 2005 ou superior é suportado.

- Microsoft *SQL* Server não suporta sequências, assim ``lastInsertId()`` ignora o argumento de chave primária e
  retorna o último valor gerado para uma chave de autoincremento se um nome de tabela for especificado ou o
  último id retornado por uma consulta de inserção. O método ``lastSequenceId()`` retorna ``NULL``.

- ``Zend_Db_Adapter_Sqlsrv`` configura ``QUOTED_IDENTIFIER`` ON imediatamente após conectar-se a um servidor
  *SQL*. Isso faz com que o driver utilize o o símbolo delimitador de identificador da *SQL* padrão (**"**) em
  vez dos colchetes que a sintaxe do *SQL* Server usa para delimitar identificadores.

- Você pode especificar ``driver_options`` como uma chave na matriz de opções. O valor pode ser uma coisa
  qualquer coisa daqui `http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx`_.

- Você pode usar ``setTransactionIsolationLevel()`` para definir nível de isolamento para a conexão atual. O
  valor pode ser ``SQLSRV_TXN_READ_UNCOMMITTED``, ``SQLSRV_TXN_READ_COMMITTED``, ``SQLSRV_TXN_REPEATABLE_READ``,
  ``SQLSRV_TXN_SNAPSHOT`` ou ``SQLSRV_TXN_SERIALIZABLE``.

- A partir de Zend Framework 1.9, a distribuição mínima suportada da extesnão *PHP* para *SQL* Server da
  Microsoft é a 1.0.1924.0. e o *MSSQL* Server Native Client versão 9.00.3042.00.

.. _zend.db.adapter.adapter-notes.pdo-ibm:

PDO para IBM DB2 e Informix Dynamic Server (IDS)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Especifique esse adaptador o método ``factory()`` com o nome '``Pdo_Ibm``'.

- Esse adaptador usa as extensões *PHP* *PDO* e ``PDO_IBM``.

- Você deve usar pelo menos a versão da extensão ``PDO_IBM`` 1.2.2. Se você tiver uma versão anterior desta
  extensão, você deve atualizar a extensão ``PDO_IBM`` a partir da *PECL*.

.. _zend.db.adapter.adapter-notes.pdo-mssql:

PDO Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^^^^^

- Especifique este adaptador para o método ``factory()`` com o nome '``Pdo_Mssql``'.

- Esse adaptador usa as extensões *PHP* pdo e pdo_dblib.

- Microsoft *SQL* Server não suporta sequências, assim ``lastInsertId()`` ignora seus argumentos e sempre retorna
  o último valor gerado para uma chave de autoincremento. O método ``lastSequenceId()`` retorna ``NULL``.

- Se você está trabalhando com strings Unicode em uma codificação diferente de *UCS*-2 (tal como *UTF*-8),
  você pode ter que realizar uma conversão no código de sua aplicação ou armazenar os dados em uma coluna
  binária. Por favor, consulte a `Base de Conhecimento da Microsoft`_ para mais informações.

- ``Zend_Db_Adapter_Pdo_Mssql`` configura ``QUOTED_IDENTIFIER`` ON imediatamente depois de conectar-se a um banco
  de dados *SQL* Server. Isso faz com que o driver utilize o símbolo delimitador de identificador da *SQL* padrão
  ( ") em vez dos colchetes que a sintaxe *SQL* Server utiliza para delimitar identificadores.

- Você pode especificar ``pdoType`` como uma chave na matriz de opções. O valor pode ser "mssql" (o padrão),
  "dblib", "FreeTDS", ou "Sybase". Essa opção afeta o prefixo *DSN* que o adaptador usa quando constrói a string
  *DSN*. Tanto "FreeTDS" quanto "sybase" implicam um prefixo de "sybase:", que é usado para o conjunto de
  bibliotecas `FreeTDS`_. Veja também `http://www.php.net/manual/en/ref.pdo-dblib.connection.php`_ Para obter mais
  informações sobre os prefixos *DSN* utilizados neste driver.

.. _zend.db.adapter.adapter-notes.pdo-mysql:

PDO MySQL
^^^^^^^^^

- Especifique este adaptador para o método ``factory()`` com o nome '``Pdo_Mysql``'.

- Este adaptador usa as extensões *PHP* pdo e pdo_mysql.

- MySQL não suporta sequencias, assim ``lastInsertId()`` ignora seus argumentos e sempre retorna o último valor
  gerado para uma chave de autoincremento. O método ``lastSequenceId()`` retorna ``NULL``.

.. _zend.db.adapter.adapter-notes.pdo-oci:

PDO Oracle
^^^^^^^^^^

- Especifique este adaptador para o método ``factory()`` com o nome '``Pdo_Oci``'.

- Este adaptador usa as extensões *PHP* pdo e pdo_oci.

- Oracle não suporta chaves de autoincremento, assim você deve especificar o nome de uma sequencia para
  ``lastInsertId()`` ou ``lastSequenceId()``.

.. _zend.db.adapter.adapter-notes.pdo-pgsql:

PDO PostgreSQL
^^^^^^^^^^^^^^

- Especifique este adaptador para o método ``factory()`` com o nome '``Pdo_Pgsql``'.

- Este adaptador usa as extensões *PHP* pdo e pdo_pgsql.

- PostgreSQL supporta tanto sequencias quanto chaves de autoincremento. Portanto os argumentos para
  ``lastInsertId()`` são opcionais. Se você não fornecer argumentos, o adaptador retorna o último valor gerado
  para uma chave de autoincremento. Se você fornecer argumentos, o adaptador retorna o último valor gerado pela
  sequencia nomeado de acordo com a convenção '**table**\ _ **column**\ _seq'.

.. _zend.db.adapter.adapter-notes.pdo-sqlite:

PDO SQLite
^^^^^^^^^^

- Especifique este adaptador para o método ``factory()`` com o nome '``Pdo_Sqlite``'.

- Este adaptador usa as extensões *PHP* pdo e pdo_sqlite.

- SQLite não suporta sequencias, assim ``lastInsertId()`` ignora seus argumentos e sempre retorna o último valor
  gerado para uma chave de autoincremento. O método ``lastSequenceId()`` retorna ``NULL``.

- Para conectar-se com um banco de dados SQLite2, especifique ``'sqlite2' => true`` na matriz de parâmetros quando
  criar uma instância do adaptador ``Pdo_Sqlite``.

- Para conectar-se com um banco de dados SQLite em memória, especifique ``'dbname' => ':memory:'`` na matriz de
  parâmetros quando criar uma instância do adaptador ``Pdo_Sqlite``.

- Versões antigas do driver SQLite para *PHP* parecem não suportar os comandos *PRAGMA* necessários para
  garantir que nomes de coluna curtos sejam usados em conjuntos de resultados. Se você tem problemas que seus
  conjuntos de resultados são retornados com chaves da forma "tablename.columnname" quando você faz uma consulta
  com junção, então você deve atualizar para a versão atual do *PHP*.

.. _zend.db.adapter.adapter-notes.firebird:

Firebird (Interbase)
^^^^^^^^^^^^^^^^^^^^

- Este adaptador usa a extensão *PHP* php_interbase.

- Firebird (Interbase) não suporta chaves de autoincremento, portanto, você deve especificar o nome de uma
  sequência para ``lastInsertId()`` ou ``lastSequenceId()``.

- Atualmente, a opção ``Zend_Db::CASE_FOLDING`` não é suportada pelo adaptador Firebird (Interbase).
  Identificadores não citadas são automaticamente devolvidos em maiúsculas.

- O nome do adaptador é ``ZendX_Db_Adapter_Firebird``.

  Lembre-se de usar o parâmetro adapterNamespace com o valor ``ZendX_Db_Adapter``.

  Recomendamos a atualização de ``gds32.dll`` (ou equivalente Linux) empacotado junto com *PHP*, para a mesma
  versão do servidor. Para Firebird o equivalente de ``gds32.dll`` é ``fbclient.dll``.

  Por padrão todos os identificadores (nomes de tabela, campos) são devolvidos em caixa alta.



.. _`PHP Data Objects`: http://www.php.net/pdo
.. _`pdo_ibm`: http://www.php.net/pdo-ibm
.. _`pdo_mysql`: http://www.php.net/pdo-mysql
.. _`pdo_dblib`: http://www.php.net/pdo-dblib
.. _`pdo_oci`: http://www.php.net/pdo-oci
.. _`pdo_pgsql`: http://www.php.net/pdo-pgsql
.. _`pdo_sqlite`: http://www.php.net/pdo-sqlite
.. _`mysqli`: http://www.php.net/mysqli
.. _`oci8`: http://www.php.net/oci8
.. _`ibm_db2`: http://www.php.net/ibm_db2
.. _`php_interbase`: http://www.php.net/ibase
.. _`http://en.wikipedia.org/wiki/SQL_Injection`: http://en.wikipedia.org/wiki/SQL_Injection
.. _`mysql_real_escape_string()`: http://www.php.net/mysqli_real_escape_string
.. _`MySQL Query Cache`: http://dev.mysql.com/doc/refman/5.1/en/query-cache-how.html
.. _`http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx`: http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx
.. _`Base de Conhecimento da Microsoft`: http://support.microsoft.com/kb/232580
.. _`FreeTDS`: http://www.freetds.org/
.. _`http://www.php.net/manual/en/ref.pdo-dblib.connection.php`: http://www.php.net/manual/en/ref.pdo-dblib.connection.php
