.. _zend.view.scripts:

Scripts de Visualização
=======================

Uma vez que seu controlador tenha atribuido as variáveis e chamado o método ``render()``, ``Zend_View`` incluirá
o script de visualização requerido e o executará "dentro" do escopo da instância de ``Zend_View``. Portanto, em
seus scripts de visualização, as referências a $this apontarão para a própria instância de ``Zend_View``.

Variáveis atribuídas à visualização pelo controlador são referidas como propriedades de instância. Por
exemplo, se o controlador atribuir a variável 'algumacoisa', você deve referir-se a ela como $this->algumacoisa
em seu script de visualização. (Isto permite um rastreamento dos valores que foram atribuidos ao script, e que
são internos ao mesmo).

A fim de lembrar, aqui está um exemplo de script de visualização originado da introdução do ``Zend_View``.

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>

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

.. _zend.view.scripts.escaping:

Escapando a Saída
-----------------

Uma das tarefas mais importantes a ser executada por scripts de visualização é assegurar que a saída seja
corretamente escapada; entre outras coisas, isto ajuda a evitar ataques do tipo site-cruzado. A menos que você
esteja usando uma função, método, ou assistente que realize o escape, você sempre deverá escapar o conteúdo
das variáveis antes de exibí-lo.

``Zend_View`` implementa um método chamado escape() que realiza corretamente o escape para você.

.. code-block:: php
   :linenos:

   // maneira ruim:
   echo $this->variable;

   // maneira recomendada:
   echo $this->escape($this->variable);

Por padrão, o método escape() usa a função htmlspecialchars() do *PHP* para fazer o escape. Mas, dependendo do
seu ambiente, você pode desejar um comportamento diferente para o escape. Use o método setEscape() no nível do
controlador para instruir o ``Zend_View`` sobre qual função de callback utilizar para fazer o escape.

.. code-block:: php
   :linenos:

   // cria uma instância de Zend_View
   $view = new Zend_View();

   // instrui o uso de htmlentities como método de escape
   $view->setEscape('htmlentities');

   // ou instrui o uso de um método estático de classe
   $view->setEscape(array('SomeClass', 'methodName'));

   // ou mesmo um método de instância
   $obj = new SomeClass();
   $view->setEscape(array($obj, 'methodName'));

   // e renderiza a visualização
   echo $view->render(...);

A função ou método de callback deverá tomar o valor a ser escapado como seu primeiro parâmetro, e os demais
parâmetros deverão ser opcionais.

.. _zend.view.scripts.templates:

Usando Sistemas de Template Alternativos
----------------------------------------

Embora o *PHP* em si seja um poderoso sistema de template, muitos desenvolvedores sentiram que ele é muito potente
ou complexo para seus designers de templates e acabam usando um motor de template alternativo. ``Zend_View``
fornece para isso dois mecanismos, o primeiro através de scripts de visualização, e o segundo implementando
``Zend_View_Interface``.

.. _zend.view.scripts.templates.scripts:

Template Systems Using View Scripts
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A view script may be used to instantiate and manipulate a separate template object, such as a PHPLIB-style
template. The view script for that kind of activity might look something like this:

.. code-block:: php
   :linenos:

   include_once 'template.inc';
   $tpl = new Template();

   if ($this->books) {
       $tpl->setFile(array(
           "booklist" => "booklist.tpl",
           "eachbook" => "eachbook.tpl",
       ));

       foreach ($this->books as $key => $val) {
           $tpl->set_var('author', $this->escape($val['author']);
           $tpl->set_var('title', $this->escape($val['title']);
           $tpl->parse("books", "eachbook", true);
       }

       $tpl->pparse("output", "booklist");
   } else {
       $tpl->setFile("nobooks", "nobooks.tpl")
       $tpl->pparse("output", "nobooks");
   }

Estes seriam os arquivos de template relacionados:

.. code-block:: html
   :linenos:

   <!-- booklist.tpl -->
   <table>
       <tr>
           <th>Autor</th>
           <th>Título</th>
       </tr>
       {books}
   </table>

   <!-- eachbook.tpl -->
       <tr>
           <td>{author}</td>
           <td>{title}</td>
       </tr>

   <!-- nobooks.tpl -->
   <p>Não existem livros a serem exibidos.</p>

.. _zend.view.scripts.templates.interface:

Template Systems Using Zend_View_Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Some may find it easier to simply provide a ``Zend_View``-compatible template engine. ``Zend_View_Interface``
defines the minimum interface needed for compatability:

.. code-block:: php
   :linenos:

   /**
    * Return the actual template engine object
    */
   public function getEngine();

   /**
    * Set the path to view scripts/templates
    */
   public function setScriptPath($path);

   /**
    * Set a base path to all view resources
    */
   public function setBasePath($path, $prefix = 'Zend_View');

   /**
    * Add an additional base path to view resources
    */
   public function addBasePath($path, $prefix = 'Zend_View');

   /**
    * Retrieve the current script paths
    */
   public function getScriptPaths();

   /**
    * Overloading methods for assigning template variables as object
    * properties
    */
   public function __set($key, $value);
   public function __isset($key);
   public function __unset($key);

   /**
    * Manual assignment of template variables, or ability to assign
    * multiple variables en masse.
    */
   public function assign($spec, $value = null);

   /**
    * Unset all assigned template variables
    */
   public function clearVars();

   /**
    * Render the template named $name
    */
   public function render($name);

Using this interface, it becomes relatively easy to wrap a third-party template engine as a
``Zend_View``-compatible class. As an example, the following is one potential wrapper for Smarty:

.. code-block:: php
   :linenos:

   class Zend_View_Smarty implements Zend_View_Interface
   {
       /**
        * Smarty object
        * @var Smarty
        */
       protected $_smarty;

       /**
        * Constructor
        *
        * @param string $tmplPath
        * @param array $extraParams
        * @return void
        */
       public function __construct($tmplPath = null, $extraParams = array())
       {
           $this->_smarty = new Smarty;

           if (null !== $tmplPath) {
               $this->setScriptPath($tmplPath);
           }

           foreach ($extraParams as $key => $value) {
               $this->_smarty->$key = $value;
           }
       }

       /**
        * Return the template engine object
        *
        * @return Smarty
        */
       public function getEngine()
       {
           return $this->_smarty;
       }

       /**
        * Set the path to the templates
        *
        * @param string $path The directory to set as the path.
        * @return void
        */
       public function setScriptPath($path)
       {
           if (is_readable($path)) {
               $this->_smarty->template_dir = $path;
               return;
           }

           throw new Exception('Invalid path provided');
       }

       /**
        * Retrieve the current template directory
        *
        * @return string
        */
       public function getScriptPaths()
       {
           return array($this->_smarty->template_dir);
       }

       /**
        * Alias for setScriptPath
        *
        * @param string $path
        * @param string $prefix Unused
        * @return void
        */
       public function setBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Alias for setScriptPath
        *
        * @param string $path
        * @param string $prefix Unused
        * @return void
        */
       public function addBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Assign a variable to the template
        *
        * @param string $key The variable name.
        * @param mixed $val The variable value.
        * @return void
        */
       public function __set($key, $val)
       {
           $this->_smarty->assign($key, $val);
       }

       /**
        * Allows testing with empty() and isset() to work
        *
        * @param string $key
        * @return boolean
        */
       public function __isset($key)
       {
           return (null !== $this->_smarty->get_template_vars($key));
       }

       /**
        * Allows unset() on object properties to work
        *
        * @param string $key
        * @return void
        */
       public function __unset($key)
       {
           $this->_smarty->clear_assign($key);
       }

       /**
        * Assign variables to the template
        *
        * Allows setting a specific key to the specified value, OR passing
        * an array of key => value pairs to set en masse.
        *
        * @see __set()
        * @param string|array $spec The assignment strategy to use (key or
        * array of key => value pairs)
        * @param mixed $value (Optional) If assigning a named variable,
        * use this as the value.
        * @return void
        */
       public function assign($spec, $value = null)
       {
           if (is_array($spec)) {
               $this->_smarty->assign($spec);
               return;
           }

           $this->_smarty->assign($spec, $value);
       }

       /**
        * Clear all assigned variables
        *
        * Clears all variables assigned to Zend_View either via
        * {@link assign()} or property overloading
        * ({@link __get()}/{@link __set()}).
        *
        * @return void
        */
       public function clearVars()
       {
           $this->_smarty->clear_all_assign();
       }

       /**
        * Processes a template and returns the output.
        *
        * @param string $name The template to process.
        * @return string The output.
        */
       public function render($name)
       {
           return $this->_smarty->fetch($name);
       }
   }

In this example, you would instantiate the ``Zend_View_Smarty`` class instead of ``Zend_View``, and then use it in
roughly the same fashion as ``Zend_View``:

.. code-block:: php
   :linenos:

   //Example 1. In initView() of initializer.
   $view = new Zend_View_Smarty('/path/to/templates');
   $viewRenderer =
       Zend_Controller_Action_HelperBroker::getStaticHelper('ViewRenderer');
   $viewRenderer->setView($view)
                ->setViewBasePathSpec($view->_smarty->template_dir)
                ->setViewScriptPathSpec(':controller/:action.:suffix')
                ->setViewScriptPathNoControllerSpec(':action.:suffix')
                ->setViewSuffix('tpl');

   //Example 2. Usage in action controller remains the same...
   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           $this->view->book   = 'Zend PHP 5 Certification Study Guide';
           $this->view->author = 'Davey Shafik and Ben Ramsey'
       }
   }

   //Example 3. Initializing view in action controller
   class FooController extends Zend_Controller_Action
   {
       public function init()
       {
           $this->view   = new Zend_View_Smarty('/path/to/templates');
           $viewRenderer = $this->_helper->getHelper('viewRenderer');
           $viewRenderer->setView($this->view)
                        ->setViewBasePathSpec($view->_smarty->template_dir)
                        ->setViewScriptPathSpec(':controller/:action.:suffix')
                        ->setViewScriptPathNoControllerSpec(':action.:suffix')
                        ->setViewSuffix('tpl');
       }


