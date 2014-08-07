.. EN-Revision: none
.. _zend.form.elements:

Creando elementos de formulario usando Zend\Form\Element
========================================================

Un formulario esta compuesto de elementos, que normalmente corresponden al elemento HTML input.
``Zend\Form\Element`` encapsula elementos de formulario individualmente, con las siguientes áreas de
responsabilidad:

- validación (¿los datos enviados son válidos?)

  - captura de códigos y mensajes de error

- filtrado (¿cómo es escapado y normalizado el elemento para su validación y/o salida?

- generación (¿cómo es mostrado el elemento?)

- metadatos y atributos (¿qué información amplía la definición del elemento?)

La clase base, ``Zend\Form\Element``, funciona por defecto para varios casos, pero es mejor extender la clase para
elementos con fines especiales de uso común. Adicionalmente, Zend Framework contiene un número de elementos
*XHTML* estándar; puede leer de ellos :ref:`en el capítulo Elementos Estándares <zend.form.standardElements>`

.. _zend.form.elements.loaders:

Cargadores de Plugin
--------------------

``Zend\Form\Element`` hace uso de :ref:`Zend\Loader\PluginLoader <zend.loader.pluginloader>` para permitir a los
desarrolladores especificar ubicaciones de validadores, filtros y decoradores alternos. Cada uno tiene su propio
cargador de plugin asociado a él y métodos de acceso generales usados para su recuperación y modificación.

Los siguientes tipos de cargadores son usados con los varios métodos del cargador de plugin: 'validate', 'filter',
y 'decorator'. Los nombres son sensibles a mayúsculas y minúsculas.

Los métodos usados para interactuar con los cargadores de plugin son los siguientes:

- ``setPluginLoader($loader, $type)``: ``$loader`` es el propio objeto cargador, mientras ```` es uno de los tipos
  arriba mencionados. Esto establece el cargador de plugin para el tipo dado en el objeto cargador recién
  especificado.

- ``getPluginLoader()``: obtiene el cargador de plugin asociado con ````.

- ``addPrefixPath($prefix, $path, $type = null)``: agrega una asociación prefijo/ruta para el cargador
  especificado por ``$type``. Si ``$type`` es ``NULL``, se intentará agregar la ruta a todos los cargadores,
  añadiendo el prefijo a cada "\_Validate", "\_Filter" y "\_Decorator"; y agregandole "Validate/", "Filter/" y
  "Decorator/" a la ruta. Si tiene todas sus clases extras para elementos de formulario dentro de una jerarquía
  común, este método es conveniente para establecer el prefijo para todas ellas.

- ``addPrefixPaths(array $spec)``: le permite añadir varias rutas de una sola vez a uno o más cargadores de
  plugin. Se espera cada elemento de la matriz sea un array con claves 'path', 'prefix', y 'type'.

Validadores, filtros y decoradores personalizados son una manera simple de compartir funcionalidad entre
formularios y encapsular funcionalidad personalizada.

.. _zend.form.elements.loaders.customLabel:

.. rubric:: Etiqueta personalizada

Un uso común de los plugins es proveer reemplazos para las clases estándares. Por ejemplo, si desea proveer una
implementación diferente del decorador 'Label' -- por ejemplo, para añadir siempre dos puntos -- puede crear su
propio decorador 'Label' con su propio prefijo de clase, y entonces añadirlo a su prefijo de ruta.

Comencemos con un decorador de etiqueta personalizado. Le daremos el prefijo "My_Decorator", y la clase estará en
el archivo "My/Decorator/Label.php".

.. code-block:: php
   :linenos:

   class My_Decorator_Label extends Zend\Form\Decorator\Abstract
   {
       protected $_placement = 'PREPEND';

       public function render($content)
       {
           if (null === ($element = $this->getElement())) {
               return $content;
           }
           if (!method_exists($element, 'getLabel')) {
               return $content;
           }

           $label = $element->getLabel() . ':';

           if (null === ($view = $element->getView())) {
               return $this->renderLabel($content, $label);
           }

           $label = $view->formLabel($element->getName(), $label);

           return $this->renderLabel($content, $label);
       }

       public function renderLabel($content, $label)
       {
           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'APPEND':
                   return $content . $separator . $label;
               case 'PREPEND':
               default:
                   return $label . $separator . $content;
           }
       }
   }

Ahora diremos al elemento que use esta ruta cuando busque por decoradores:

.. code-block:: php
   :linenos:

   $element->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');

Alternativamente, podemos hacerlo en el formulario para asegurar que todos los decoradores usen esta ruta:

.. code-block:: php
   :linenos:

   $form->addElementPrefixPath('My_Decorator', 'My/Decorator/', 'decorator');

Con esta ruta añadida, cuando agregue un decorador, la ruta 'My/Decorator' será consultada primero en búsqueda
de la existencia del decorador en este lugar. Como resultado, 'My_Decorator_Label' ahora será utilizado cuando el
decorador 'Label' sea requerido.

.. _zend.form.elements.filters:

Filters
-------

A menudo es útil y/o necesario realizar alguna normalización en la entrada antes de la validación – por
ejemplo, puede querer eliminar todo el *HTML*, pero realizar las validaciones sobre lo restante para asegurarse que
el envío es válido. O puede eliminar los espacios en blanco al inicio o fin de la entrada para asegurarse de que
un validador StringLength (longitud de la cadena) no regrese un positivo falso. Estas operaciones pueden realizarse
usando ``Zend_Filter``, y ``Zend\Form\Element`` que soportan cadenas de filtros, permitiéndole especificar
múltiples filtros secuenciales a utilizar. El filtrado sucede tanto en la validación como cuando recupera el
valor del elemento vía ``getValue()``:

.. code-block:: php
   :linenos:

   $filtered = $element->getValue();


Los filtros pueden ser agregados a la pila de dos maneras:

- pasándolo en una instancia de filtro específica

- proveyendo un nombre de filtro – el correspondiente nombre corto o completo de la clase

Veamos algunos ejemplos:

.. code-block:: php
   :linenos:

   // Instancia específica del filtro
   $element->addFilter(new Zend\I18n\Filter\Alnum());

   // El correspondiente nombre completo de la clase:
   $element->addFilter('Zend\I18n\Filter\Alnum');

   // Nombre corto del filtro:
   $element->addFilter('Alnum');
   $element->addFilter('alnum');

Los nombres cortos son típicamente el nombre del filtro sin el prefijo. En el caso predeterminado, esto se refiere
a sin el prefijo 'Zend_Filter\_'. Además, la primera letra no necesita estar en mayúscula.

.. note::

   **Usando clases de filtros personalizados**

   Si tiene su propio conjunto de clases de filtro, puede informarle de ellas a ``Zend\Form\Element`` usando
   ``addPrefixPath()``. Por ejemplo, si tiene filtros con el prefijo 'My_Filter', puede indicárselo a
   ``Zend\Form\Element`` de la siguiente manera:

   .. code-block:: php
      :linenos:

      $element->addPrefixPath('My_Filter', 'My/Filter/', 'filter');

   (Recuerde que el tercer argumento indica el cargador de plugin sobre el cual ha de ejecutarse la acción.)

Si en algún momento necesita un valor no filtrado, use el método ``getUnfilteredValue()``:

.. code-block:: php
   :linenos:

   $unfiltered = $element->getUnfilteredValue();

Para mayor información sobre filtros, vea la :ref:`documentación de Zend_Filter <zend.filter.introduction>`.

Métodos asociados con filtros incluyen:

- ``addFilter($nameOfFilter, array $options = null)``

- ``addFilters(array $filters)``

- ``setFilters(array $filters)`` (sobreescribe todos los filtros)

- ``getFilter($name)`` (recupera un objeto filtro por su nombre)

- ``getFilters()`` (recupera todos los filtros)

- ``removeFilter($name)`` (elimina un filtro por su nombre)

- ``clearFilters()`` (elimina todos los filtros)

.. _zend.form.elements.validators:

Validadores
-----------

Si sigue el mantra de seguridad "filtrar la entrada, escapar la salida" querrá validar ("filtrar la entrada") los
datos de los formularios. En ``Zend_Form`` cada elemento contiene su propia cadena de validadores, consistente en
validadores ``Zend\Validate\*``.

Los validadores pueden ser agregados de dos maneras:

- pasándolo en una instancia de validador específica

- proveyendo un nombre de validador – el correspondiente nombre corto o completo de clase

Veamos algunos ejemplos:

.. code-block:: php
   :linenos:

   // Instancia específica del validador:
   $element->addValidator(new Zend\Validate\Alnum());

   // El correspondiente nombre completo de la clase:
   $element->addValidator('Zend\Validate\Alnum');

   // Nombre corto del validador:
   $element->addValidator('Alnum');
   $element->addValidator('alnum');

Los nombres cortos son típicamente el nombre del validador sin el prefijo. En el caso predeterminado, esto se
refiere a sin el prefijo 'Zend_Validate\_'. Además, la primera letra no necesita estar en mayúscula.

.. note::

   **Usando clases de validación personalizadas**

   Si tiene su propio conjunto de clases de validación, puede informarle de ellas a ``Zend\Form\Element`` usando
   ``addPrefixPath()``. Por ejemplo, si tiene validadores con el prefijo 'My_Validator', puede indicárselo a
   ``Zend\Form\Element`` de la siguiente manera:

   .. code-block:: php
      :linenos:

      $element->addPrefixPath('My_Validator', 'My/Validator/', 'validate');

   (Recuerde que el tercer argumento indica el cargador de plugin sobre el cual ha de ejecutarse la acción.)

Si el fallo de un validador debe evitar validaciones posteriores, pase el boleano ``TRUE`` como segundo parámetro:

.. code-block:: php
   :linenos:

   $element->addValidator('alnum', true);

Si está usando la cadena nombre para añadir el validador, y la clase del validador acepta argumentos para su
constructor, puede pasarlos a el tercer parámetro de ``addValidator()`` como un array:

.. code-block:: php
   :linenos:

   $element->addValidator('StringLength', false, array(6, 20));

Los argumentos pasados de esta manera deben estar en el orden en el cual son definidos en el constructor. El
ejemplo de arriba instanciará la clase ``Zend\Validate\StringLenth`` con los parámetros ``$min`` y ``$max``:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(6, 20);

.. note::

   **Estipulando mensajes de error de validación personalizados**

   Algunos desarrolladores querrán estipular mensajes de error personalizados para un validador. El argumento
   ``$options`` de ``Zend\Form\Element::addValidator()`` le permite hacerlo proporcionando la clave 'messages' y
   estableciendolos en un array de pares clave/valor para especificar las plantillas de mensaje. Necesitará
   conocer los códigos de error de los diferentes tipos de error de un validador en particular.

   Una opción mejor es usar ``Zend\Translator\Adapter`` con su formulario. Los códigos de error son
   automáticamente pasados al adaptador por el decorador Errors por defecto; puede especificar su propias cadenas
   de mensaje de error mediante la creación de traducciones para los varios códigos de error de sus validadores.

Puede también establecer varios validadores a la vez, usando ``addValidators()``. Su uso básico es pasar una
matriz de arrays, donde cada array contenga de 1 a 3 valores, correspondientes al constructor de
``addValidator()``:

.. code-block:: php
   :linenos:

   $element->addValidators(array(
       array('NotEmpty', true),
       array('alnum'),
       array('stringLength', false, array(6, 20)),
   ));

Si quiere ser más detallado o explícito, puede utilizar las claves 'validator', 'breakChainOnFailure', y
'options' en el array:

.. code-block:: php
   :linenos:

   $element->addValidators(array(
       array(
           'validator'           => 'NotEmpty',
           'breakChainOnFailure' => true),
       array('validator' => 'alnum'),
       array(
           'validator' => 'stringLength',
           'options'   => array(6, 20)),
   ));

Este uso es bueno para ilustrar cómo puede configurar validadores en un archivo de configuración:

.. code-block:: ini
   :linenos:

   element.validators.notempty.validator = "NotEmpty"
   element.validators.notempty.breakChainOnFailure = true
   element.validators.alnum.validator = "Alnum"
   element.validators.strlen.validator = "StringLength"
   element.validators.strlen.options.min = 6
   element.validators.strlen.options.max = 20

Note que cada elemento tiene una clave, la necesite o no; esta es una limitación del uso de archivos de
configuración -- pero también ayuda a hacer más explicito el para qué son usados los argumentos. Sólo recuerde
que cualesquiera opciones del validador deben ser especificadas en orden.

Para validar un elemento, pase el valor a ``isValid()``:

.. code-block:: php
   :linenos:

   if ($element->isValid($value)) {
       // válido
   } else {
       // no válido
   }

.. note::

   **Validación operando en valores filtrados**

   ``Zend\Form\Element::isValid()``> siempre filtra los valores antes de la validación a través de la cadena de
   filtros. Vea :ref:`la sección de filtros <zend.form.elements.filters>` para más información.

.. note::

   **Contexto de validación**

   ``Zend\Form\Element::isValid()``> soporta un argumento adicional, ``$context``. ``Zend\Form\Form::isValid()`` pasa
   todo el conjunto de datos procesados a ``$context`` cuando valida un formulario, y
   ``Zend\Form\Element::isValid()``>, a su vez, lo pasa a cada validador. Esto significa que puede escribir
   validadores que son conscientes de los datos pasados a otros elementos del formulario. Como ejemplo, considere
   un formulario de registro estándar que tiene campos para la contraseña y la confirmación de la contraseña;
   una validación sería que los dos campos coincidan. Este validador puede tener un aspecto como el siguiente:

   .. code-block:: php
      :linenos:

      class My_Validate_PasswordConfirmation extends Zend\Validate\Abstract
      {
          const NOT_MATCH = 'notMatch';

          protected $_messageTemplates = array(
              self::NOT_MATCH => 'Password confirmation does not match'
          );

          public function isValid($value, $context = null)
          {
              $value = (string) $value;
              $this->_setValue($value);

              if (is_array($context)) {
                  if (isset($context['password_confirm'])
                      && ($value == $context['password_confirm']))
                  {
                      return true;
                  }
              } elseif (is_string($context) && ($value == $context)) {
                  return true;
              }

              $this->_error(self::NOT_MATCH);
              return false;
          }
      }

Los validadores son procesados en orden. Cada validador es procesado, a menos que un validador creado con un valor
true para ``breakChainOnFailure`` falle su validación. Asegúrese de especificar sus validadores en un orden
razonable.

Después de una validación fallida, puede recuperar los códigos y mensajes de error de la cadena del validador:

.. code-block:: php
   :linenos:

   $errors   = $element->getErrors();
   $messages = $element->getMessages();

(Nota: los mensajes de error retornados son un array asociativo de pares código / mensaje de error.)

En adición a los validadores, puede especificar que un elemento es necesario, usando ``setRequired(true)``. Por
defecto, esta bandera es ``FALSE``, lo que significa que pasará su cadena de validadores si ningún valor es
pasado a ``isValid()``. Puede modificar este comportamiento en un número de maneras:

- Por defecto, cuando un elemento es requerido, una bandera, 'allowEmpty', también es true. Esto quiere decir que
  si un valor empty es evaluado pasándolo a ``isValid()``, los validadores serán saltados. Puede intercalar esta
  bandera usando el método de acceso ``setAllowEmpty($flag)``; cuando la bandera es false, si un valor es pasado,
  los validadores seguirán ejecutándose.

- Por defecto, si un elemento es requerido, pero no contiene un validador 'NotEmpty', ``isValid()`` añadirá uno
  en la cima de la pila, con la bandera ``breakChainOnFailure`` establecido. Esto hace que la bandera requerida
  tenga un significado semántico: si ningún valor es pasado, inmediatamente invalidamos el envío y se le
  notifica al usuario, e impedimos que otros validadores se ejecuten en lo que ya sabemos son datos inválidos.

  Si no quiere este comportamiento, puede desactivarlo pasando un valor false a
  ``setAutoInsertNotEmptyValidator($flag)``; esto prevendrá a ``isValid()`` de colocar un validador 'NotEmpty' en
  la cadena de validaciones.

Para mayor información sobre validadores, vea la :ref:`documentación de Zend_Validate
<zend.validate.introduction>`.

.. note::

   **Usando Zend\Form\Elements como validador de propósito general**

   ``Zend\Form\Element`` implementa ``Zend\Validate\Interface``, significando un elemento puede también usarse
   como un validador en otro, cadenas de validación no relacionadas al formulario.

Métodos asociados con validación incluyen:

- ``setRequired($flag)`` y ``isRequired()`` permiten establecer y recuperar el estado de la bandera 'required'.
  Cuando se le asigna un booleano ``TRUE``, esta bandera requiere que el elemento esté presente en la información
  procesada por ``Zend_Form``.

- ``setAllowEmpty($flag)`` y ``getAllowEmpty()`` permiten modificar el comportamiento de elementos opcionales
  (p.e., elementos donde la bandera required es ``FALSE``). Cuando la bandera 'allow empty' es ``TRUE``, valores
  vacíos no pasarán la cadena de validadores.

- ``setAutoInsertNotEmptyValidator($flag)`` permite especificar si realmente un validador 'NotEmpty' será añadido
  el inicio de la cadena de validaciones cuando un elemento es requerido. Por defecto, esta bandera es ``TRUE``.

- ``addValidator($nameOrValidator, $breakChainOnFailure = false, array $options = null)``

- ``addValidators(array $validators)``

- ``setValidators(array $validators)`` (sobreescribe todos los validadores)

- ``getValidator($name)`` (recupera un objeto validador por nombre)

- ``getValidators()`` (recupera todos los validadores)

- ``removeValidator($name)`` (elimina un validador por nombre)

- ``clearValidators()`` (elimina todos los validadores)

.. _zend.form.elements.validators.errors:

Errores de mensaje personalizados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Alguna veces, querrá especificar uno o más mensajes de error para usarlos en lugar de los mensajes de error
generados por los validadores adjuntos a los elementos. Adicionalmente, algunas veces usted mismo querrá marcar al
elemento como inválido. A partir de 1.6.0, esta funcionalidad es posible vía los siguientes métodos.

- ``addErrorMessage($message)``: añade un mensaje de error para mostrarlos en forma de errores de validación.
  Puede llamarlo más de una vez, y los nuevos mensajes nuevos son añadidos a la pila.

- ``addErrorMessages(array $messages)``: añade múltiples mensajes de error para mostrarlos en forma de errores de
  validación.

- ``setErrorMessages(array $messages)``: añade múltiples mensajes de error para mostrarlos en forma de errores de
  validación, sobreescribiendo todos los mensajes de error previamente establecidos.

- ``getErrorMessages()``: recupera la lista de mensajes de error personalizados que fueron definidos.

- ``clearErrorMessages()``: remueve todos los mensajes de error personalizados que hayan sido definidos.

- ``markAsError()``: marca al elemento como que falló la validación.

- ``hasErrors()``: determina si el elemento ha fallado la validación o ha sido marcado como inválido.

- ``addError($message)``: añade un mensaje a la pila de mensaje de error personalizados y marca al elemento como
  inválido.

- ``addErrors(array $messages)``: añade varios mensajes a la pila de mensajes de error personalizados y marca al
  elemento como inválido.

- ``setErrors(array $messages)``: sobreescribe el mensaje de error personalizado en la pila con los mensajes
  previstos y marca al elemento como inválido.

Todos los errores establecidos de este modo pueden ser traducidos. Adicionalmente, puede insertar el marcador
"%value%" para representar el valor del elemento; este valor actual del elemento será sustituido cuando el mensaje
de error sea recuperado.

.. _zend.form.elements.decorators:

Decoradores
-----------

Una dolencia particular para muchos desarrolladores web es la creación del *XHTML* para formularios por ellos
mismos. Para cada elemento, el desarrollador necesita crear la marcación para el elemento mismo, comúnmente una
etiqueta (label), y, si son amables con sus usuarios, la marcación para mostrar mensajes de errores de
validación. Cuanto más elementos en una página, menos trivial se convierte esta tarea.

``Zend\Form\Element`` intenta resolver este problema mediante el uso de "decoradores". Los decoradores son clases
simples que tienen métodos de acceso al elemento y métodos para generar el contenido. Para obtener mayor
información sobre cómo trabajan los decoradores, consulte por favor la sección sobre :ref:`Zend\Form\Decorator
<zend.form.decorators>`.

Los decoradores usados por defecto por ``Zend\Form\Element`` son:

- **ViewHelper**: especifica un view helper que usar para general el elemento. El atributo 'helper' del elemento
  puede usarse para especificar qué auxiliar vista usar. Por defecto, ``Zend\Form\Element`` especifica el auxiliar
  vista 'formText', pero cada subclase especifica diferentes auxiliares.

- **Errors**: añade mensajes de error al elemento usando ``Zend\View\Helper\FormErrors``. Si no está presente, no
  se añade nada.

- **Description**: añade la descripción del elemento. Si no está presente, no se añade nada. Por defecto, la
  descripción es generada dentro de una etiqueta <p> con un class 'description'.

- **HtmlTag**: envuelve el elemento y los errores en una etiqueta HTML <dd>.

- **Label**: añade al comienzo una etiqueta al elemento usando ``Zend\View\Helper\FormLabel``, y envolviéndola en
  una etiqueta <dt>. Si ninguna etiqueta es provista, solo la etiqueta de la definición es generada.

.. note::

   **Decoradores por defecto no necesitan ser cargados**

   Por defecto, los decoradores por defecto son cargados durante la inicialización del objeto. Puede deshabilitar
   esto pasando la opción 'disableLoadDefaultDecorators' al constructor:

   .. code-block:: php
      :linenos:

      $element = new Zend\Form\Element('foo',
                                       array('disableLoadDefaultDecorators' =>
                                            true)
                                      );

   Esta opción puede ser combinada junto con cualquier otra opción que pase, ya sea como un array de opciones o
   en un objeto ``Zend_Config``.

Ya que el orden en el cual los decoradores son registrados importa -- el primer decorador registrado es ejecutado
primero -- necesitará estar seguro de registrar sus decoradores en el orden apropiado, o asegurarse de que
estableció las opciones de colocación en el modo apropiado. Por dar un ejemplo, aquí esta el código que
registran los decoradores por defecto:

.. code-block:: php
   :linenos:

   $this->addDecorators(array(
       array('ViewHelper'),
       array('Errors'),
       array('Description', array('tag' => 'p', 'class' => 'description')),
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));

El contenido inicial es creado por el decorador 'ViewHelper', que crea el propio elemento. En seguida, el decorador
'Errors' consulta los mensajes de error del elemento, y, si hay alguno presente, los pasa al auxiliar vista
'FormErrors' para mostrarlos. Si una descripción está presente, el decorador 'Description' añadirá un párrafo
con class 'description' conteniendo el texto descriptivo para el contenido agregado. El siguiente decorador,
'HtmlTag', envuelve al elemento, los errores, y la descripción en una etiqueta HTML <dd>. Finalmente, el último
decorador, 'label', recupera la etiqueta del elemento y la pasa al auxiliar vista 'FormLabel', envolviéndolo en
una etiqueta <dt>; por default el valor es añadido al inicio del contenido. El resultado de la salida básicamente
se ve así:

.. code-block:: html
   :linenos:

   <dt><label for="foo" class="optional">Foo</label></dt>
   <dd>
       <input type="text" name="foo" id="foo" value="123" />
       <ul class="errors">
           <li>"123" is not an alphanumeric value</li>
       </ul>
       <p class="description">
           This is some descriptive text regarding the element.
       </p>
   </dd>

Para más información sobre decoradores, lea la :ref:`sección de Zend\Form\Decorator <zend.form.decorators>`.

.. note::

   **Usando múltiples decoradores al mismo tiempo**

   Internamente, ``Zend\Form\Element`` utiliza una clase decorador como mecanismo de búsqueda para la
   recuperación de decoradores. Como resultado, no puede registrar múltiples decoradores del mismo tipo;
   decoradores subsecuentes simplemente sobreescribirán aquellos que ya existían.

   Para evitar esto, puede usar **alias**. En lugar de pasar un decorador o nombre de decorador como primer
   argumento a ``addDecorator()``, pase una matriz con un solo elemento, con el alias apuntando al nombre o objeto
   decorador:

   .. code-block:: php
      :linenos:

      // Alias a 'FooBar':
      $element->addDecorator(array('FooBar' => 'HtmlTag'),
                             array('tag' => 'div'));

      // Y recuperandolo posteriormente:
      $decorator = $element->getDecorator('FooBar');

   En los métodos ``addDecorators()`` y ``setDecorators()``, necesitará pasar la opción 'decorator' en la matriz
   representando el decorador:

   .. code-block:: php
      :linenos:

      // Y dos decoradores 'HtmlTag', 'FooBar' como alias:
      $element->addDecorators(
          array('HtmlTag', array('tag' => 'div')),
          array(
              'decorator' => array('FooBar' => 'HtmlTag'),
              'options' => array('tag' => 'dd')
          ),
      );

      // Y recuperándolos posteriormente:
      $htmlTag = $element->getDecorator('HtmlTag');
      $fooBar  = $element->getDecorator('FooBar');

Métodos asociados con decoradores incluyen:

- ``addDecorator($nameOrDecorator, array $options = null)``

- ``addDecorators(array $decorators)``

- ``setDecorators(array $decorators)`` (sobreescribe todos los decoradores)

- ``getDecorator($name)`` (recupera un objeto decorador por su nombre)

- ``getDecorators()`` (recupera todos los decoradores)

- ``removeDecorator($name)`` (elimina un decorador por su nombre)

- ``clearDecorators()`` (elimina todos los decoradores)

``Zend\Form\Element`` también utiliza la sobrecarga para permitir generar decoradores específicos. ``__call()``
interceptará métodos que comiencen con el texto 'render' y utilizará el resto del nombre del método para buscar
un decorador; si se encuentra, entonces será generado **sólo ese** decorador. Cualquier argumento pasado al
llamado del método será usado como contenido para pasar al método ``render()`` del decorador. Como ejemplo:

.. code-block:: php
   :linenos:

   // Genera solo el decorador ViewHelper:
   echo $element->renderViewHelper();

   // Genera solo el decorador HtmlTag, pasándole contenido:
   echo $element->renderHtmlTag("This is the html tag content");

Si el decorador no existe, una excepción es lanzada.

.. _zend.form.elements.metadata:

Metadatos y atributos
---------------------

``Zend\Form\Element`` manipula una variedad de atributos y medatados del elemento. Atributos básicos incluyen:

- **name**: el nombre del elemento. Emplea los métodos de acceso ``setName()`` y ``getName()``.

- **label**: la etiqueta del elemento. Emplea los métodos de acceso ``setLabel()`` y ``getLabel()``.

- **order**: el índice en el cual los elementos deben ir mostrándose en el formulario. Emplea los métodos de
  acceso ``setOrder()`` y ``getOrder()``.

- **value**: El valor del elemento actual. Emplea los métodos de acceso ``setValue()`` y ``getValue()``.

- **description**: una descripción del elemento; a menudo utilizada para proveer un tooltip o ayuda contextual con
  javascript describiendo el propósito del elemento. Emplea los métodos de acceso ``setDescription()`` y
  ``getDescription()``.

- **required**: bandera que indica si un elemento es requerido o no cuando se efectúa la validación del
  formulario. Emplea los métodos de acceso ``setRequired()`` y ``getRequired()``. Esta bandera es ``FALSE`` por
  defecto.

- **allowEmpty**: bandera indicando si un elemento no-requerido (opcional) debe intentar validar o no valores
  vacíos. Cuando es ``TRUE``, y la bandera required es ``FALSE``, valores vacíos no pasarán la cadena de
  validación, y se supone verdadero. Emplea los métodos de acceso ``setAllowEmpty()`` y ``getAllowEmpty()``. Esta
  bandera es ``TRUE`` por defecto.

- **autoInsertNotEmptyValidator**: bandera indicando insertar o no un validador 'NotEmpty' cuando un elemento es
  requerido. Por defecto, esta bandera es ``TRUE``. Establezca la bandera con
  ``setAutoInsertNotEmptyValidator($flag)`` y determine el valor con ``autoInsertNotEmptyValidator()``.

Los elementos del formulario pueden requerir metainformación adicional. Para elementos *XHTML* del formuladio, por
ejemplo, puede querer especificar atributos como el class o id. Para facilitar esto hay un conjunto de métodos de
acceso:

- **setAttrib($name, $value)**: añade un atributo

- **setAttribs(array $attribs)**: como addAttribs(), pero sobreescribiendo

- **getAttrib($name)**: recupera el valor de solo un atributo

- **getAttribs()**: recupera todos los atributos como pares clave/valor

La mayoría de las veces, como sea, puede simplemente acceder a ellos como propiedades de objeto, ya que
``Zend\Form\Element`` utiliza la sobrecarga para facilitar el acceso a ellos:

.. code-block:: php
   :linenos:

   // Equivalente a $element->setAttrib('class', 'text'):
   $element->class = 'text;

Por defecto, todos los atributos son pasados al auxiliar vista usado por el elemento durante la generación, y
generados como atributos de la etiqueta del elemento.

.. _zend.form.elements.standard:

Elementos Estándar
------------------

``Zend_Form`` contiene un buen número de elementos estándar; por favor lea el capítulo :ref:`Elementos Estándar
<zend.form.standardElements>` para todos los detalles.

.. _zend.form.elements.methods:

Métodos de Zend\Form\Element
----------------------------

``Zend\Form\Element`` tiene muchos, muchos métodos. Lo que sigue es un sumario de sus funciones, agrupados por
tipo:

- Configuración:

  - ``setOptions(array $options)``

  - ``setConfig(Zend_Config $config)``

- I18n:

  - ``setTranslator(Zend\Translator\Adapter $translator = null)``

  - ``getTranslator()``

  - ``setDisableTranslator($flag)``

  - ``translatorIsDisabled()``

- Propiedades:

  - ``setName($name)``

  - ``getName()``

  - ``setValue($value)``

  - ``getValue()``

  - ``getUnfilteredValue()``

  - ``setLabel($label)``

  - ``getLabel()``

  - ``setDescription($description)``

  - ``getDescription()``

  - ``setOrder($order)``

  - ``getOrder()``

  - ``setRequired($flag)``

  - ``getRequired()``

  - ``setAllowEmpty($flag)``

  - ``getAllowEmpty()``

  - ``setAutoInsertNotEmptyValidator($flag)``

  - ``autoInsertNotEmptyValidator()``

  - ``setIgnore($flag)``

  - ``getIgnore()``

  - ``getType()``

  - ``setAttrib($name, $value)``

  - ``setAttribs(array $attribs)``

  - ``getAttrib($name)``

  - ``getAttribs()``

- Cargadores y rutas de plugin:

  - ``setPluginLoader(Zend\Loader\PluginLoader\Interface $loader, $type)``

  - ``getPluginLoader($type)``

  - ``addPrefixPath($prefix, $path, $type = null)``

  - ``addPrefixPaths(array $spec)``

- Validación:

  - ``addValidator($validator, $breakChainOnFailure = false, $options = array())``

  - ``addValidators(array $validators)``

  - ``setValidators(array $validators)``

  - ``getValidator($name)``

  - ``getValidators()``

  - ``removeValidator($name)``

  - ``clearValidators()``

  - ``isValid($value, $context = null)``

  - ``getErrors()``

  - ``getMessages()``

- Filtros:

  - ``addFilter($filter, $options = array())``

  - ``addFilters(array $filters)``

  - ``setFilters(array $filters)``

  - ``getFilter($name)``

  - ``getFilters()``

  - ``removeFilter($name)``

  - ``clearFilters()``

- Generación:

  - ``setView(Zend\View\Interface $view = null)``

  - ``getView()``

  - ``addDecorator($decorator, $options = null)``

  - ``addDecorators(array $decorators)``

  - ``setDecorators(array $decorators)``

  - ``getDecorator($name)``

  - ``getDecorators()``

  - ``removeDecorator($name)``

  - ``clearDecorators()``

  - ``render(Zend\View\Interface $view = null)``

.. _zend.form.elements.config:

Configuración
-------------

El constructor de ``Zend\Form\Element`` acepta tanto una matriz de opciones como un objeto ``Zend_Config``
conteniendo opciones, y esto puede configurarse usando ``setOptions()`` o ``setConfig()``. Hablando de manera
general, las claves son nombradas de la siguiente manera:

- Si 'set' + clave se refiere a un método de ``Zend\Form\Element``, entonces el valor provisto será pasado a el
  método.

- De otra manera, el valor será usado para establecer un atributo.

Excepciones a la regla incluyen las siguientes:

- ``prefixPath`` será pasado a ``addPrefixPaths()``

- Los siguientes setters no pueden establecerse de esta manera:

  - ``setAttrib`` (aunque ``setAttribs`` **funcionará**

  - ``setConfig``

  - ``setOptions``

  - ``setPluginLoader``

  - ``setTranslator``

  - ``setView``

Como ejemplo, aquí esta un archivo de configuración pasado para cada tipo de dato configurable:

.. code-block:: ini
   :linenos:

   [element]
   name = "foo"
   value = "foobar"
   label = "Foo:"
   order = 10
   required = true
   allowEmpty = false
   autoInsertNotEmptyValidator = true
   description = "Foo elements are for examples"
   ignore = false
   attribs.id = "foo"
   attribs.class = "element"
   ; sets 'onclick' attribute
   onclick = "autoComplete(this, '/form/autocomplete/element')"
   prefixPaths.decorator.prefix = "My_Decorator"
   prefixPaths.decorator.path = "My/Decorator/"
   disableTranslator = 0
   validators.required.validator = "NotEmpty"
   validators.required.breakChainOnFailure = true
   validators.alpha.validator = "alpha"
   validators.regex.validator = "regex"
   validators.regex.options.pattern = "/^[A-F].*/$"
   filters.ucase.filter = "StringToUpper"
   decorators.element.decorator = "ViewHelper"
   decorators.element.options.helper = "FormText"
   decorators.label.decorator = "Label"

.. _zend.form.elements.custom:

Elementos personalizados
------------------------

Usted puede crear sus propios elementos personalizados simplemente extendiendo la clase ``Zend\Form\Element``. Las
razones comunes para hacer esto incluyen:

- Elementos que comparten validadores y/o filtros comunes

- Elementos que tienen decoradores con funcionalidad personalizada

Hay dos métodos típicamente usados para extender un elemento: ``init()``, el cual puede usarse para añadir una
lógica de inicialización personalizada a su elemento, y ``loadDefaultDecorators()``, el cual puede usarse para
establecer una lista de decoradores usados por su elemento de manera predeterminada.

Como un ejemplo, digamos que todos los elementos de tipo texto en un formulario que está creando, necesitan ser
filtrados con ``StringTrim``, validados con una expresión regular, y que quiere usar un decorador personalizado
que ha creado para mostrarlos, 'My_Decorator_TextItem'; adicionalmente, tiene un número de atributos estándars,
incluyendo 'size', 'maxLength', y 'class' que quisiera especificar. Puede definir un elemento tal como sigue:

.. code-block:: php
   :linenos:

   class My_Element_Text extends Zend\Form\Element
   {
       public function init()
       {
           $this->addPrefixPath('My_Decorator', 'My/Decorator/', 'decorator')
                ->addFilters('StringTrim')
                ->addValidator('Regex', false, array('/^[a-z0-9]{6,}$/i'))
                ->addDecorator('TextItem')
                ->setAttrib('size', 30)
                ->setAttrib('maxLength', 45)
                ->setAttrib('class', 'text');
       }
   }

Entonces puede informar a su objeto formulario acerca del prefijo de ruta para elementos de ese tipo, y comenzar
creando elementos:

.. code-block:: php
   :linenos:

   $form->addPrefixPath('My_Element', 'My/Element/', 'element')
        ->addElement('foo', 'text');

El elemento 'foo' será ahora del tipo ``My_Element_Text``, y mostrará el comportamiento que ha especificado.

Otro método que puede querer sobreescribir cuando extienda ``Zend\Form\Element`` es el método
``loadDefaultDecorators()``. Este método carga condicionalmente un grupo de decoradores predefinidos para su
elemento; puede querer sustituir su propio decorador en su clase extendida:

.. code-block:: php
   :linenos:

   class My_Element_Text extends Zend\Form\Element
   {
       public function loadDefaultDecorators()
       {
           $this->addDecorator('ViewHelper')
                ->addDecorator('DisplayError')
                ->addDecorator('Label')
                ->addDecorator('HtmlTag',
                               array('tag' => 'div', 'class' => 'element'));
       }
   }

Hay muchas maneras de personalizar elementos; asegúrese de leer la documentación de la *API* de
``Zend\Form\Element`` para conocer todos los métodos disponibles.


