.. _zend.form.decorators:

Creando un personalizado marcado de formulario usando Zend_Form_Decorator
=========================================================================

Representar un objeto form es completamente opcional -- no está obligado a usar los métodos ``Zend_Form``
render() en absoluto. Sin embargo, si lo hace, los decoradores se usan para representar distintos objetos form.

Un número arbitrario de decoradores pueden estar junto a cada elemento (elements, display groups, sub forms o el
objeto form por si mismo); Sin embargo, solo un decorador de un tipo dado puede estar al lado de cada elemento. Los
decoradores son llamados en el orden en que han sido introducidos. Dependiendo del decorador, puede reemplazar el
contenido que se ha pasado, postponerlo o anteponerlo.

El estado del objeto es determinado a través de las opciones de configuración pasadas al constructor o el método
decorador ``setOptions()``. Cuando se crean decoradores mediante funciones ``addDecorator()`` o métodos
relacionados, las opciones pueden ser pasadas como argumentos al método. Esto puese ser usado para una ubicación
especifica, un separador se usa entre el contenido pasado y el nuevo contenido generado y cualquier opción que el
decorador soporte.

Antes de que el ``render()`` de cada decorador sea llamado, el item actual es determinado en el decorador usando
``setElement()``, dando al decorador conocimiento del item representado. Esto permite crear decoradores que sólo
representan porciones especificas del item -- tal como etiquetas, el valor, mensajes de error, etc. Encadenando
muchos decoradores que representan especificos segmentos, puede construir marcados complejos representando al item
entero.

.. _zend.form.decorators.operation:

Operación
---------

Para configurar un decorador, pase un array de opciones o un objeto ``Zend_Config`` a este constructor, a un array
``setOptions()``, o a un objeto ``Zend_Config`` ``setConfig()``.

Opciones estándar incluyen:

- ``placement``: La ubicación puede ser cualquiera de los dos 'append' o 'prepend' (caso insensitivo) e indica
  cualquier contenido pasado a ``render()`` será postpuesto o antepuesto respectivamente. En el caso de que el
  decorador reemplace el contenido, esta configuración es ignorada. La configuración por defecto es adjuntada.

- ``separator``: El separator es usado entre el contenido pasado a ``render()`` y el nuevo contenido generado por
  el decorador, o entre items generados por el decorador (ejemplo FormElements usa el separador entre cada item
  generado). En el caso que un decorador reemplace el contenido, esta configuración puede ser ignorada. El valor
  por defecto es ``PHP_EOL``.

La interface del decorador especifica los métodos para interactuar con las opciones. Esto incluye:

- ``setOption($key, $value)``: determina una sola opción.

- ``getOption($key)``: recuperar un solo valor de opción.

- ``getOptions()``: recuperar todas las opciones.

- ``removeOption($key)``: eliminar una sola opción.

- ``clearOptions()``: eliminar todas las opciones.

Decoradores son diseñados para interactuar con varios tipos de clases ``Zend_Form``: ``Zend_Form``,
``Zend_Form_Element``, ``Zend_Form_DisplayGroup``, y todas las clases derivan de ellas. El método ``setElement()``
permite determinar el objeto del decorador que esta actualmente trabajando con, y ``getElement()`` es usado para
recuperarlo.

Cada método decorador ``render()`` acepta una cadena ``$content``. Cuando el primer decorador es llamado, esta
cadena esta tipicamente vacía, mientras las subsecuentes llamadas serán puestas. Basados en el tipo de decorador
y en las opciones pasadas, el decorador ya sea reemplazará la cadena, antenpodrá la cadena o adjuntará la
cadena; una separador opcional será usado en las dos últimas situaciones.

.. _zend.form.decorators.standard:

Decoradores estándar
--------------------

``Zend_Form`` entrega muchos decoradores estándar; ver :ref:`el capítulo Decoradores estándar
<zend.form.standardDecorators>` para detalles.

.. _zend.form.decorators.custom:

Decoradores personalizados
--------------------------

Si encuentra que sus necesidades son complejas o necesita una enorme personalización, debería considerar crear un
decorador personalizado.

Los decoradores necesitan implementar sólo ``Zend_Form_Decorator_Interface``. La interface especifica lo
siguiente:

.. code-block:: php
   :linenos:

   interface Zend_Decorator_Interface
   {
       public function __construct($options = null);
       public function setElement($element);
       public function getElement();
       public function setOptions(array $options);
       public function setConfig(Zend_Config $config);
       public function setOption($key, $value);
       public function getOption($key);
       public function getOptions();
       public function removeOption($key);
       public function clearOptions();
       public function render($content);
   }

Para hacerlo mas simple, simplemente puede extender ``Zend_Form_Decorator_Abstract``, el cual implementa todos los
métodos excepto ``render()``.

Como ejemplo, digamos que quiere reducir el número de decoradores que utiliza, y construir un decorador compuesto
que se encargó de renderizar la etiqueta generadora, el elemento, cualquier mensaje de error, y descripción en un
``div`` HTML. Puede construir como un decorador compuesto como sigue:

.. code-block:: php
   :linenos:

   class My_Decorator_Composite extends Zend_Form_Decorator_Abstract
   {
       public function buildLabel()
       {
           $element = $this->getElement();
           $label = $element->getLabel();
           if ($translator = $element->getTranslator()) {
               $label = $translator->translate($label);
           }
           if ($element->isRequired()) {
               $label .= '*';
           }
           $label .= ':';
           return $element->getView()
                          ->formLabel($element->getName(), $label);
       }

       public function buildInput()
       {
           $element = $this->getElement();
           $helper  = $element->helper;
           return $element->getView()->$helper(
               $element->getName(),
               $element->getValue(),
               $element->getAttribs(),
               $element->options
           );
       }

       public function buildErrors()
       {
           $element  = $this->getElement();
           $messages = $element->getMessages();
           if (empty($messages)) {
               return '';
           }
           return '<div class="errors">' .
                  $element->getView()->formErrors($messages) . '</div>';
       }

       public function buildDescription()
       {
           $element = $this->getElement();
           $desc    = $element->getDescription();
           if (empty($desc)) {
               return '';
           }
           return '<div class="description">' . $desc . '</div>';
       }

       public function render($content)
       {
           $element = $this->getElement();
           if (!$element instanceof Zend_Form_Element) {
               return $content;
           }
           if (null === $element->getView()) {
               return $content;
           }

           $separator = $this->getSeparator();
           $placement = $this->getPlacement();
           $label     = $this->buildLabel();
           $input     = $this->buildInput();
           $errors    = $this->buildErrors();
           $desc      = $this->buildDescription();

           $output = '<div class="form element">'
                   . $label
                   . $input
                   . $errors
                   . $desc
                   . '</div>';

           switch ($placement) {
               case (self::PREPEND):
                   return $output . $separator . $content;
               case (self::APPEND):
               default:
                   return $content . $separator . $output;
           }
       }
   }

Puede entonces ubicarlo en el directorio del decorador:

.. code-block:: php
   :linenos:

   // para un elemento:
   $element->addPrefixPath('My_Decorator',
                           'My/Decorator/',
                           'decorator');

   // para todos los elementos:
   $form->addElementPrefixPath('My_Decorator',
                               'My/Decorator/',
                               'decorator');

Puede especificar este decorador como compuesto (composite) y adjuntarlo a un elemento:

.. code-block:: php
   :linenos:

   // Sobreescribe los decoradores existentes con este otro:
   $element->setDecorators(array('Composite'));

Mientras este ejemplo mostró cómo crear un decorador que genera salidas complejas de muchas propiedades de
elementos, puede también crear decoradores que manejen un solo aspecto de un elemento; los decoradores 'Decorator'
y 'Label' son excelentes ejemplos para esta práctica. Hacerlo le permite mezclar y combinar decoradores para
llegar a complejas salidas -- y también anular aspectos de decoración para personalizar sus necesidades.

Por ejemplo, si quiere simplemente desplegar que un error ha ocurrido cuando validábamos un elemento, pero no
desplegar individualmente cada uno de los mensajes de error, usted podría crear su propio decorador 'Errores':

.. code-block:: php
   :linenos:

   class My_Decorator_Errors
   {
       public function render($content = '')
       {
           $output = '<div class="errors">El valor que proporcionó no es válido;
               please try again</div>';

           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'PREPEND':
                   return $output . $separator . $content;
               case 'APPEND':
               default:
                   return $content . $separator . $output;
           }
       }
   }

En este ejemplo particular, debido al segmento del decorador final, 'Errors', se combina como
``Zend_Form_Decorator_Errors``, será generado **en lugar de** el decorador -- significa que no necesitará cambiar
ningún decorador para modificar la salida. Nombrando sus decoradores después de los decoradores existentes
estándar, usted puede modificar decoradores sin necesitad de modificar sus elementos decoradores.

.. _zend.form.decorators.individual:

Generando decoradores individuales
----------------------------------

Desde que los decoradores pueden capturar distintos metadatos del elemento o formulario que ellos decoran, es a
menudo útil generar un decorador individual. Afortunadamente, esta caracteristica es posible inicializando el
método en cada tipo de clase form (forms, sub form, display group, element).

Para hacer eso, simplemente ``render[DecoratorName]()``, cuando "[DecoratorName]" es el "nombre corto" de su
decorador; opcionalmente, puede pasar en el contenido lo que usted quiera. Por ejemplo:

.. code-block:: php
   :linenos:

   // genera el elemento decorador label:
   echo $element->renderLabel();

   // genera sólo el campo display group, con algún contenido:
   echo $group->renderFieldset('fieldset content');

   // genera sólo el formulario HTML, con algún contenido:
   echo $form->renderHtmlTag('wrap this content');

Si el decorador no existe, una excepción es inicializada.

Esto puede ser útil particularmente cuando se genera un formulario con el decorador ViewScript; cada elemento
puede usar sus decoradores adjuntos para generar contenido, pero con un control minucioso.


