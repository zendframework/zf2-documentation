.. _zend.view.introduction:

Introdução
==========

``Zend_View`` é uma classe para trabalhar com a parte de visualização do padrão de projeto MVC. Basicamente ela
existe para separar o script de visualização dos controladores e modelos. Ela fornece um sistema de assistentes,
filtros de saída e escape de variáveis.

``Zend_View`` é um sistema de template agnóstico; você pode usar o *PHP* como sua linguagem de template, ou
criar instâncias de outros sistemas de template e manipulá-las dentro do seu script de visualização.

Essencialmente, o funcionamento do ``Zend_View`` acontece em duas etapas principais: 1. Seu script controlador cria
uma instância de ``Zend_View``, atribuindo-lhe variáveis. 2. O controlador instrui o ``Zend_View`` a renderizar
uma determinada visualização, passando o controle ao script de visualização, responsável pela geração da
saída a ser visualizada.

.. _zend.view.introduction.controller:

Script Controlador
------------------

Neste exemplo simples, suponhamos que seu controlador tenha uma listagem contendo dados sobre livros, que queremos
renderizar para uma visualização. O controlador poderia ser algo como isto:

.. code-block:: php
   :linenos:

   // use a model to get the data for book authors and titles.
   $data = array(
       array(
           'author' => 'Hernando de Soto',
           'title' => 'The Mystery of Capitalism'
       ),
       array(
           'author' => 'Henry Hazlitt',
           'title' => 'Economics in One Lesson'
       ),
       array(
           'author' => 'Milton Friedman',
           'title' => 'Free to Choose'
       )
   );

   // now assign the book data to a Zend_View instance
   Zend_Loader::loadClass('Zend_View');
   $view = new Zend_View();
   $view->books = $data;

   // and render a view script called "booklist.php"
   echo $view->render('booklist.php');

.. _zend.view.introduction.view:

Script Visualizador
-------------------

Agora necessitaremos do script de visualização associado, "booklist.php". Trata-se de um script *PHP* como
qualquer outro, com uma exceção: ele executa dentro do escopo da instância de ``Zend_View``, o que implica que
as referências a $this apontam para as propriedades e métodos da instância ``Zend_View``. (Variáveis
atribuídas à instância pelo controlador são propriedades públicas da instância de ``Zend_View``). Deste modo,
um script de visualização muito básico poderia se parecer com isto:

.. code-block:: php
   :linenos:

    if ($this->books): ?>

       <!-- Uma tabela contendo alguns livros. -->
       <table>
           <tr>
               <th>Autor</th>
               <th>Título</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>Não existem livros a serem exibidos.</p>

   <?php endif;?>

Observe a forma como empregamos o método "escape()" para escapar o conteúdo das variáveis para a saída.

.. _zend.view.introduction.options:

Options
-------

``Zend_View`` has several options that may be set to configure the behaviour of your view scripts.

- ``basePath``: indicate a base path from which to set the script, helper, and filter path. It assumes a directory
  structure of:

  .. code-block:: php
     :linenos:

     base/path/
         helpers/
         filters/
         scripts/

  This may be set via ``setBasePath()``, ``addBasePath()``, or the ``basePath`` option to the constructor.

- ``encoding``: indicate the character encoding to use with ``htmlentities()``, ``htmlspecialchars()``, and other
  operations. Defaults to ISO-8859-1 (latin1). May be set via ``setEncoding()`` or the ``encoding`` option to the
  constructor.

- ``escape``: indicate a callback to be used by ``escape()``. May be set via ``setEscape()`` or the ``escape``
  option to the constructor.

- ``filter``: indicate a filter to use after rendering a view script. May be set via ``setFilter()``,
  ``addFilter()``, or the ``filter`` option to the constructor.

- ``strictVars``: force ``Zend_View`` to emit notices and warnings when uninitialized view variables are accessed.
  This may be set by calling ``strictVars(true)`` or passing the ``strictVars`` option to the constructor.

.. _zend.view.introduction.shortTags:

Short Tags with View Scripts
----------------------------

In our examples, we make use of *PHP* long tags: **<?php**. We also favor the use of `alternate syntax for control
structures`_. These are convenient shorthands to use when writing view scripts, as they make the constructs more
terse, keep statements on single lines, and eliminate the need to hunt for brackets within *HTML*.

In previous versions, we often recommended using short tags (**<?** and **<?=**), as they make the view scripts
slightly less verbose. However, the default for the ``php.ini`` ``short_open_tag`` setting is typically off in
production or on shared hosts -- making their use not terribly portable. If you use template *XML* in view scripts,
short open tags will cause the templates to fail validation. Finally, if you use short tags when ``short_open_tag``
is off, the view scripts will either cause errors or simply echo *PHP* code back to the viewer.

If, despite these warnings, you wish to use short tags but they are disabled, you have two options:

- Turn on short tags in your ``.htaccess`` file:

  .. code-block:: apache
     :linenos:

     php_value "short_open_tag" "on"

  This will only be possible if you are allowed to create and utilize ``.htaccess`` files. This directive can also
  be added to your ``httpd.conf`` file.

- Enable an optional stream wrapper to convert short tags to long tags on the fly:

  .. code-block:: php
     :linenos:

     $view->setUseStreamWrapper(true);

  This registers ``Zend_View_Stream`` as a stream wrapper for view scripts, and will ensure that your code
  continues to work as if short tags were enabled.

.. warning::

   **View Stream Wrapper Degrades Performance**

   Usage of the stream wrapper **will** degrade performance of your application, though actual benchmarks are
   unavailable to quantify the amount of degradation. We recommend that you either enable short tags, convert your
   scripts to use full tags, or have a good partial and/or full page content caching strategy in place.

.. _zend.view.introduction.accessors:

Utility Accessors
-----------------

Typically, you'll only ever need to call on ``assign()``, ``render()``, or one of the methods for setting/adding
filter, helper, and script paths. However, if you wish to extend ``Zend_View`` yourself, or need access to some of
its internals, a number of accessors exist:

- ``getVars()`` will return all assigned variables.

- ``clearVars()`` will clear all assigned variables; useful when you wish to re-use a view object, but want to
  control what variables are available.

- ``getScriptPath($script)`` will retrieve the resolved path to a given view script.

- ``getScriptPaths()`` will retrieve all registered script paths.

- ``getHelperPath($helper)`` will retrieve the resolved path to the named helper class.

- ``getHelperPaths()`` will retrieve all registered helper paths.

- ``getFilterPath($filter)`` will retrieve the resolved path to the named filter class.

- ``getFilterPaths()`` will retrieve all registered filter paths.



.. _`alternate syntax for control structures`: http://us.php.net/manual/en/control-structures.alternative-syntax.php
