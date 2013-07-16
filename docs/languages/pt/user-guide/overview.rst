.. _user-guide.overview:

Iniciando com Zend Framework 2
==============================

Esse tutorial pretende fornecer uma introdução ao desenvolvimento com Zend Framework 2 
atraves da criação de uma simples aplicação guiada por banco de dados usando o padrão
Model-View-Controller. Ao final desse tutorial você terá uma aplicação funcional com 
Zend Framework 2 e poderá analisar o código para saber mais sobre como tudo funciona de 
forma conjunta.

.. _user-guide.overview.assumptions:

Algumas Suposições
------------------

Esse tutorial assume que você tenha pelo menos um servidor apache com PHP 5.3.3 rodando
e um servidor MySQL, acessível pela extensão PDO. Sua configuração do Apache deve ter a 
extensão mod_rewrite instalada e habilitada.

Você também deve se certificar que o Apache esteja configurado para suportar arquivos 
``.htaccess``. Para isso geralmente é necessário apenas alterar a seguinte configuração:

.. code-block:: apache

    AllowOverride None

para

.. code-block:: apache

    AllowOverride FileInfo

no seu arquivo ``httpd.conf``. Verifique na documentação da sua distribuição para detalhes 
mais precisos. Você não poderá navegar para nenhuma página além da página inicial desse 
tutoria se não tiver configurado corretamente o uso de mod_rewrite e .htaccess.

A Aplicação Tutorial
--------------------

A aplicação que você está prestes a desenvolver é uma simples biblioteca para exibir quais
albuns de música você possui. A página principal ira exibir uma lista de sua coleção e permitir
que você adicione, edite e delete albuns. Para isso nós vamos precisar de quatro páginas:

+--------------------+------------------------------------------------------------+
| Pagina             | Descrição                                                  |
+====================+============================================================+
| Lista de Albuns    | Ess página ira exibir a lista de albuns e possuir links    |
|                    | para edição e exclusão deles. também conterá um link para  |
|                    | a inclusão de um novo album.                               |
+--------------------+------------------------------------------------------------+
| Inclusão de Albuns | Conterá um formulário para inclusão de um novo album.      |
+--------------------+------------------------------------------------------------+
| Edição de Albuns   | Conterá um formulário para edição de um album.             |
+--------------------+------------------------------------------------------------+
| Exclusão de Albuns | Essa página irá confirmar se você realmente deseja         |
|                    | excluir um album e então realizará a exclusão.             |
+--------------------+------------------------------------------------------------+

Nós também iremos precisar armazenar os dados em um banco de dados. Iremos precisar apenas de uma
tabela para isso com as seguintes colunas:

+------------+--------------+-------+----------------------------------+
| Coluna     | Tipo         | Null? | Notas                            |
+============+==============+=======+==================================+
| id         | integer      | Não   | Chave primaria, auto incremental |
+------------+--------------+-------+----------------------------------+
| artist     | varchar(100) | Não   |                                  |
+------------+--------------+-------+----------------------------------+
| title      | varchar(100) | Não   |                                  |
+------------+--------------+-------+----------------------------------+

