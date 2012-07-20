.. _zend.view.helpers:

Assistentes de Visualização
===========================

Em seus scripts de visualização, frequentemente é necessário a execução de certas tarefas complexas repetidas
vezes: p. ex.: formatar uma data, gerar um elemento de formulário, ou exibir links de acionamento. Você pode
empregar classes assistentes para executar estas tarefas para você.

A helper is simply a class. Let's say we want a helper named 'fooBar'. By default, the class is prefixed with
'Zend_View_Helper\_' (you can specify a custom prefix when setting a helper path), and the last segment of the
class name is the helper name; this segment should be TitleCapped; the full class name is then:
``Zend_View_Helper_FooBar``. This class should contain at the minimum a single method, named after the helper, and
camelCased: ``fooBar()``.

.. note::

   **Watch the Case**

   Helper names are always camelCased, i.e., they never begin with an uppercase character. The class name itself is
   MixedCased, but the method that is actually executed is camelCased.

.. note::

   **Default Helper Path**

   The default helper path always points to the Zend Framework view helpers, i.e., 'Zend/View/Helper/'. Even if you
   call ``setHelperPath()`` to overwrite the existing paths, this path will be set to ensure the default helpers
   work.

Para usar um assistente em seu script de visualização, chame-o usando ``$this->helperName()``. Em segundo plano,
``Zend_View`` irá carregar a classe ``Zend_View_Helper_HelperName``, instanciá-la e chamar seu método
``helperName()``. O objeto criado é persistente dentro do escopo da instância ``Zend_View``, e será reutilizado
por todas as chamadas futuras a ``$this->helperName()``.

.. _zend.view.helpers.initial:

Assistentes Padrão
------------------

``Zend_View`` vem com um conjunto padrão de assistentes, a maioria deles dedicados à geração de elementos de
formulários e automaticamente escapar a saída apropriada. Além disso, existem assistentes para criar *URL*\ s
baseadas em rotas e listas de *HTML*, bem como declarar variáveis. Os assistentes atualmente embarcados incluem:

- ``declareVars()``: Primarily for use when using ``strictVars()``, this helper can be used to declare template
  variables that may or may not already be set in the view object, as well as to set default values. Arrays passed
  as arguments to the method will be used to set default values; otherwise, if the variable does not exist, it is
  set to an empty string.

- ``fieldset($name, $content, $attribs)``: Creates an *XHTML* fieldset. If ``$attribs`` contains a 'legend' key,
  that value will be used for the fieldset legend. The fieldset will surround the ``$content`` as provided to the
  helper.

- ``form($name, $attribs, $content)``: Generates an *XHTML* form. All ``$attribs`` are escaped and rendered as
  *XHTML* attributes of the form tag. If ``$content`` is present and not a boolean ``FALSE``, then that content is
  rendered within the start and close form tags; if ``$content`` is a boolean ``FALSE`` (the default), only the
  opening form tag is generated.

- ``formButton($name, $value, $attribs)``: Cria um elemento <button />.

- ``formCheckbox($name, $value, $attribs, $options)``: Cria um elemento <input type="checkbox" />.

  By default, when no $value is provided and no $options are present, '0' is assumed to be the unchecked value, and
  '1' the checked value. If a $value is passed, but no $options are present, the checked value is assumed to be the
  value passed.

  $options should be an array. If the array is indexed, the first value is the checked value, and the second the
  unchecked value; all other values are ignored. You may also pass an associative array with the keys 'checked' and
  'unChecked'.

  If $options has been passed, if $value matches the checked value, then the element will be marked as checked. You
  may also mark the element as checked or unchecked by passing a boolean value for the attribute 'checked'.

  The above is probably best summed up with some examples:

  .. code-block:: php
     :linenos:

     // '1' and '0' as checked/unchecked options; not checked
     echo $this->formCheckbox('foo');

     // '1' and '0' as checked/unchecked options; checked
     echo $this->formCheckbox('foo', null, array('checked' => true));

     // 'bar' and '0' as checked/unchecked options; not checked
     echo $this->formCheckbox('foo', 'bar');

     // 'bar' and '0' as checked/unchecked options; checked
     echo $this->formCheckbox('foo', 'bar', array('checked' => true));

     // 'bar' and 'baz' as checked/unchecked options; unchecked
     echo $this->formCheckbox('foo', null, null, array('bar', 'baz'));

     // 'bar' and 'baz' as checked/unchecked options; unchecked
     echo $this->formCheckbox('foo', null, null, array(
         'checked' => 'bar',
         'unChecked' => 'baz'
     ));

     // 'bar' and 'baz' as checked/unchecked options; checked
     echo $this->formCheckbox('foo', 'bar', null, array('bar', 'baz'));
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => true),
                              array('bar', 'baz'));

     // 'bar' and 'baz' as checked/unchecked options; unchecked
     echo $this->formCheckbox('foo', 'baz', null, array('bar', 'baz'));
     echo $this->formCheckbox('foo',
                              null,
                              array('checked' => false),
                              array('bar', 'baz'));

  In all cases, the markup prepends a hidden element with the unchecked value; this way, if the value is unchecked,
  you will still get a valid value returned to your form.

- ``formErrors($errors, $options)``: Generates an *XHTML* unordered list to show errors. ``$errors`` should be a
  string or an array of strings; ``$options`` should be any attributes you want placed in the opening list tag.

  You can specify alternate opening, closing, and separator content when rendering the errors by calling several
  methods on the helper:

  - ``setElementStart($string)``; default is '<ul class="errors"%s"><li>', where %s is replaced with the attributes
    as specified in ``$options``.

  - ``setElementSeparator($string)``; default is '</li><li>'.

  - ``setElementEnd($string)``; default is '</li></ul>'.

- ``formFile($name, $attribs)``: Cria um elemento <input type="file" />.

- ``formHidden($name, $value, $attribs)``: Cria um elemento <input type="hidden" />.

- ``formLabel($name, $value, $attribs)``: Creates a <label> element, setting the ``for`` attribute to ``$name``,
  and the actual label text to ``$value``. If **disable** is passed in ``attribs``, nothing will be returned.

- ``formMultiCheckbox($name, $value, $attribs, $options, $listsep)``: Creates a list of checkboxes. ``$options``
  should be an associative array, and may be arbitrarily deep. ``$value`` may be a single value or an array of
  selected values that match the keys in the ``$options`` array. ``$listsep`` is an *HTML* break ("<br />") by
  default. By default, this element is treated as an array; all checkboxes share the same name, and are submitted
  as an array.

- ``formPassword($name, $value, $attribs)``: Cria um elemento <input type="password" />.

- ``formRadio($name, $value, $attribs, $options)``: Cria uma série de elementos <input type="radio" />, um para
  cada elemento em $options. Na matriz $options, a chave e seu valor estão associados ao valor do controle e seu
  rótulo, respectivamente. O conteúdo de $value será pré-selecionado.

- ``formReset($name, $value, $attribs)``: Cria um elemento <input type="reset" />.

- ``formSelect($name, $value, $attribs, $options)``: Cria um bloco <select>...</select>, com um <option> para cada
  elemento em $options. Na matriz $options, a chave e seu valor estão associados ao valor do controle e seu
  rótulo. O conteúdo de $value será pré-selecionado.

- ``formSubmit($name, $value, $attribs)``: Cria um elemento <input type="submit" />.

- ``formText($name, $value, $attribs)``: Cria um elemento <input type="text" />.

- ``formTextarea($name, $value, $attribs)``: Cria um bloco <textarea>...</textarea>.

- ``url($urlOptions, $name, $reset)``: Creates a *URL* string based on a named route. ``$urlOptions`` should be an
  associative array of key/value pairs used by the particular route.

- ``htmlList($items, $ordered, $attribs, $escape)``: generates unordered and ordered lists based on the ``$items``
  passed to it. If ``$items`` is a multidimensional array, a nested list will be built. If the ``$escape`` flag is
  ``TRUE`` (default), individual items will be escaped using the view objects registered escaping mechanisms; pass
  a ``FALSE`` value if you want to allow markup in your lists.

Utilizar estes assistentes em seus scripts de visualização é muito fácil, aqui está um exemplo. Note que tudo
que você necessita fazer é chamá-los; eles carregam e instanciam a sí próprios a medida que tornam-se
necessários.

.. code-block:: php
   :linenos:

   // dentro do seu script de visualização,
   // $this aponta para a instância de Zend_View.
   //
   // digamos que você já atribuiu uma série de valores a matriz
   // $countries = array('us' => 'United States', 'il' =>
   // 'Israel', 'de' => 'Germany').
   ?>
   <form action="action.php" method="post">
       <p><label>Your Email:
   <?php echo $this->formText('email', 'you@example.com', array('size' => 32)) ?>
       </label></p>
       <p><label>Your Country:
   <?php echo $this->formSelect('country', 'us', null, $this->countries) ?>
       </label></p>
       <p><label>Would you like to opt in?
   <?php echo $this->formCheckbox('opt_in', 'yes', null, array('yes', 'no')) ?>
       </label></p>
   </form>

A saída resultante do script de visualização deverá se parecer com isto:

.. code-block:: php
   :linenos:

   <form action="action.php" method="post">
       <p><label>Your Email:
           <input type="text" name="email" value="you@example.com" size="32" />
       </label></p>
       <p><label>Your Country:
           <select name="country">
               <option value="us" selected="selected">United States</option>
               <option value="il">Israel</option>
               <option value="de">Germany</option>
           </select>
       </label></p>
       <p><label>Would you like to opt in?
           <input type="hidden" name="opt_in" value="no" />
           <input type="checkbox" name="opt_in" value="yes" checked="checked" />
       </label></p>
   </form>

.. include:: zend.view.helpers.action.rst
.. include:: zend.view.helpers.base-url.rst
.. include:: zend.view.helpers.currency.rst
.. include:: zend.view.helpers.cycle.rst
.. include:: zend.view.helpers.partial.rst
.. include:: zend.view.helpers.placeholder.rst
.. include:: zend.view.helpers.doctype.rst
.. include:: zend.view.helpers.head-link.rst
.. include:: zend.view.helpers.head-meta.rst
.. include:: zend.view.helpers.head-script.rst
.. include:: zend.view.helpers.head-style.rst
.. include:: zend.view.helpers.head-title.rst
.. include:: zend.view.helpers.html-object.rst
.. include:: zend.view.helpers.inline-script.rst
.. include:: zend.view.helpers.json.rst
.. include:: zend.view.helpers.navigation.rst
.. include:: zend.view.helpers.translator.rst
.. _zend.view.helpers.paths:

Localizando os Assistentes
--------------------------

Assim como os scripts de visualização, seu controlador pode especificar uma lista de caminhos onde o
``Zend_View`` deve procurar pelas classes assistentes. Por padrão, ``Zend_View`` procura pelas classes assistentes
em "Zend/View/Helper/\*". Você pode instruir o ``Zend_View`` a procurar em outros locais usando os métodos
``setHelperPath()`` e ``addHelperPath()``. Além disso, você pode indicar um prefixo da classe a ser usado para os
assistentes no caminho fornecido, permitindo o uso de namespaces em suas classes assistentes. Por padrão, se
nenhum prefixo da classe for fornecido, 'Zend_View_Helper\_' é assumido.

.. code-block:: php
   :linenos:

   $view = new Zend_View();

   // Set path to /path/to/more/helpers, with prefix 'My_View_Helper'
   $view->setHelperPath('/path/to/more/helpers', 'My_View_Helper');

De fato, você pode "empilhar" caminhos usando o método ``addHelperPath()``. A medida que você adiciona caminhos
à pilha, ``Zend_View`` procurará no caminho mais recentemente adicionado. Isto permite a você incrementar o
conjunto original de assistentes (ou susbstituir) com os seus próprios personalizados.

.. code-block:: php
   :linenos:

   $view = new Zend_View();
   // Add /path/to/some/helpers with class prefix 'My_View_Helper'
   $view->addHelperPath('/path/to/some/helpers', 'My_View_Helper');
   // Add /other/path/to/helpers with class prefix 'Your_View_Helper'
   $view->addHelperPath('/other/path/to/helpers', 'Your_View_Helper');

   // now when you call $this->helperName(), Zend_View will look first for
   // "/path/to/some/helpers/HelperName" using class name
   // "Your_View_Helper_HelperName", then for
   // "/other/path/to/helpers/HelperName.php" using class name
   // "My_View_Helper_HelperName", and finally for
   // "Zend/View/Helper/HelperName.php" using class name
   // "Zend_View_Helper_HelperName".

.. _zend.view.helpers.custom:

Escrevendo Assistentes Personalizados
-------------------------------------

Escrever assistentes personalizados é fácil; basta seguir estas regras:

- While not strictly necessary, we recommend either implementing ``Zend_View_Helper_Interface`` or extending
  ``Zend_View_Helper_Abstract`` when creating your helpers. Introduced in 1.6.0, these simply define a
  ``setView()`` method; however, in upcoming releases, we plan to implement a strategy pattern that will simplify
  much of the naming schema detailed below. Building off these now will help you future-proof your code.

- The class name must, at the very minimum, end with the helper name itself, using MixedCaps. E.g., if you were
  writing a helper called "specialPurpose", the class name would minimally need to be "SpecialPurpose". You may,
  and should, give the class name a prefix, and it is recommended that you use 'View_Helper' as part of that
  prefix: "My_View_Helper_SpecialPurpose". (You will need to pass in the prefix, with or without the trailing
  underscore, to ``addHelperPath()`` or ``setHelperPath()``).

- A classe deve ter um método público que coincida com o nome do assistente; este é o método que será chamado
  quando o seu template chamar "$this->specialPurpose()". Em nosso exemplo "specialPurpose", o método requerido
  deverá ser declarado como "public function specialPurpose()".

- Em geral, a classe não deve ecoar ou imprimir a saída gerada. Em lugar disso, ela deve retornar os valores a
  serem impressos. Os valores retornados deverão estar devidamente escapados.

- A classe deve estar em um arquivo chamado após a classe assistente. Voltando ao exemplo "specialPurpose", o
  arquivo recebeu o nome "SpecialPurpose.php".

Localize o arquivo com a classe assistente em algum dos caminhos armazenados na pilha, e o ``Zend_View``
automaticamente irá carregar, instanciar, persistir, e executar o código para você.

Aqui está um exemplo do assistente ``SpecialPurpose``:

.. code-block:: php
   :linenos:

   class My_View_Helper_SpecialPurpose extends Zend_View_Helper_Abstract
   {
       protected $_count = 0;
       public function specialPurpose()
       {
           $this->_count++;
           $output = "I have seen 'The Jerk' {$this->_count} time(s).";
           return htmlspecialchars($output);
       }
   }

Em um script de visualização, você pode chamar o assistente ``SpecialPurpose`` quantas vezes desejar; ele será
instanciado apenas uma vez; e persistirá durante todo o tempo de vida da instância de ``Zend_View``.

.. code-block:: php
   :linenos:

   // remember, in a view script, $this refers to the Zend_View instance.
   echo $this->specialPurpose();
   echo $this->specialPurpose();
   echo $this->specialPurpose();

A saída deverá se parecer com isto:

.. code-block:: php
   :linenos:

   I have seen 'The Jerk' 1 time(s).
   I have seen 'The Jerk' 2 time(s).
   I have seen 'The Jerk' 3 time(s).

Sometimes you will need access to the calling ``Zend_View`` object -- for instance, if you need to use the
registered encoding, or want to render another view script as part of your helper. To get access to the view
object, your helper class should have a ``setView($view)`` method, like the following:

.. code-block:: php
   :linenos:

   class My_View_Helper_ScriptPath
   {
       public $view;

       public function setView(Zend_View_Interface $view)
       {
           $this->view = $view;
       }

       public function scriptPath($script)
       {
           return $this->view->getScriptPath($script);
       }
   }

If your helper class has a ``setView()`` method, it will be called when the helper class is first instantiated, and
passed the current view object. It is up to you to persist the object in your class, as well as determine how it
should be accessed.

If you are extending ``Zend_View_Helper_Abstract``, you do not need to define this method, as it is defined for
you.

.. _zend.view.helpers.registering-concrete:

Registering Concrete Helpers
----------------------------

Sometimes it is convenient to instantiate a view helper, and then register it with the view. As of version 1.10.0,
this is now possible using the ``registerHelper()`` method, which expects two arguments: the helper object, and the
name by which it will be registered.

.. code-block:: php
   :linenos:

   $helper = new My_Helper_Foo();
   // ...do some configuration or dependency injection...

   $view->registerHelper($helper, 'foo');

If the helper has a ``setView()`` method, the view object will call this and inject itself into the helper on
registration.

.. note::

   **Helper name should match a method**

   The second argument to ``registerHelper()`` is the name of the helper. A corresponding method name should exist
   in the helper; otherwise, ``Zend_View`` will call a non-existent method when invoking the helper, raising a
   fatal *PHP* error.


