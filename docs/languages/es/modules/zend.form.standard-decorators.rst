.. _zend.form.standardDecorators:

Decoradores de Formulario (Form Decorartors) estándar contenidos en Zend Framework
==================================================================================

``Zend_Form`` se distribuye con distintos decoradores estándar. Para más información sobre el uso de decoradores
en general, vea :ref:`la sección sobre decoradores <zend.form.decorators>`.

.. _zend.form.standardDecorators.callback:

Zend_Form_Decorator_Callback
----------------------------

El decorador Callback (llamada de retorno) permite ejecutar una llamada de retorno para mostrar el contenido. Las
llamadas de retorno deben especificarse a través de la opción 'callback' pasada en la configuración del
decorador, y pueden ser de cualquier valor de llamada de retorno *PHP*. Los Callbacks deben aceptar tres
argumentos: ``$content`` (el contenido original enviado al decorador), ``$element`` (el objeto que se está
decorando), y un array de ``$options``. Un callback de ejemplo sería:

.. code-block:: php
   :linenos:

   class Util
   {
       public static function label($content, $element, array $options)
       {
           return '<span class="label">' . $element->getLabel() . "</span>";
       }
   }

Esta llamada de retorno se especificaría como ``array('Util', 'label')``, y generaría un (mal) código HTML para
la etiqueta. El decorador Callback reemplazará, antepondrá o postpondrá el contenido original con el que
devuelva.

El decorador Callback permite especificar un valor ``NULL`` para la opción placement (colocación), que
reemplazará el contenido original con el valor devuelto de la llamada de retorno; 'prepend' (anteponer) y 'append'
(postponer) siguen siendo válidas.

.. _zend.form.standardDecorators.captcha:

Zend_Form_Decorator_Captcha
---------------------------

El decorador Captcha se usa junto con el :ref:`elemento de formulario Captcha
<zend.form.standardElements.captcha>`. Utiliza el método ``render()`` del adaptador del captcha para generar la
salida.

Una variante del decorador Captcha, 'Captcha_Word', es usada frecuentemente, y crea dos elementos, un id y una
entrada (input). El id indica el identificador de sesión que hay que comparar, y la entrada es para la
verificación de usuario del captcha. Éstos elementos son validados como un sólo elemento.

.. _zend.form.standardDecorators.description:

Zend_Form_Decorator_Description
-------------------------------

El decorador Description puede ser usado para mostrar un conjunto de descripciones de un elemento ``Zend_Form``,
``Zend_Form_Element``, o ``Zend_Form_DisplayGroup``; toma la descripción usando el método ``getDescription()``
del objeto.

Por defecto, si no se encuentra la descripción, no se genera ninguna salida. Si la descripción está presente,
entonces se envolverá en una etiqueta ``p`` *HTML* por defecto, aunque tiene la posibilidad de especificar una
etiqueta pasando una opción ``tag`` al crear el decorador, o llamando a ``setTag()``. También puede especificar
una clase para el tag usando la opción ``class`` o llamando a ``setClass()``; por defecto, se usa la clase 'hint'.

La descripción es escapada utilizando los mecanismos de escapado por defecto del objeto de vista. Puede desactivar
esto pasando un valor ``FALSE`` a la opción 'escape' del decorador o el método ``setEscape()``.

.. _zend.form.standardDecorators.dtDdWrapper:

Zend_Form_Decorator_DtDdWrapper
-------------------------------

Los decoradores por defecto utilizan listas de definición (``<dl>``) para generar elementos de formulario (form).
Dato que los elementos de formulario pueden aparecer en cualquier orden, grupos de visualización y subformularios
pueden ser encapsulados dentro de otros elementos de formulario. Para mantener estos tipos de elemento particulares
dentro de la lista de definición, DtDdWrapper crea una nuevo término de definición vacío (definition
term)(``<dt>``) y encapsula su contenido en un nuevo dato de definición (``<dd>``). La salida queda como sigue:

.. code-block:: html
   :linenos:

   <dt></dt>
   <dd><fieldset id="subform">
       <legend>Información de Usuario</legend>
       ...
   </fieldset></dd>

Este decorador reemplaza el contenido que se le provee envolviéndolo dentro del elemento ``<dd>``.

.. _zend.form.standardDecorators.errors:

Zend_Form_Decorator_Errors
--------------------------

Los errores de elemento obtienen su propio decorador con el decorador de errores. Este decorador sustituye al view
helper FormErrors, que genera mensajes de error en una lista no ordenada (``<ul>``) como elementos de lista (li).
El elemento ``<ul>`` recibe una clase de "errores".

El decorador de Errores puede anteponerse o postponerse al contenido que se le provee.

.. _zend.form.standardDecorators.fieldset:

Zend_Form_Decorator_Fieldset
----------------------------

Por defecto, los grupos de visualización y subformularios generan sus contenidos dentro de fieldsets, EL decorador
Fieldset busca la opción 'legend' o bien el método ``getLegend()`` en el elemento registrado, y lo usa como campo
"legend" si no es vacío. Cualquier contenido pasado es envuelto en el fieldset *HTML*, reemplazando al contenido
original. Cualquier atributo pasado al elemento decorado será generado como atributo del fieldset *HTML*.

.. _zend.form.standardDecorators.file:

Zend_Form_Decorator_File
------------------------

Los elementos de tipo "File" (upload de ficheros) tienen una notación especial cuando se usan múltiples elementos
file o subformularios. El decorador File es usado por ``Zend_Form_Element_File`` y permite fijar múltiples
elementos file con una única llamada al método. Se usa automáticamente y fija el nombre de cada elemento.

.. _zend.form.standardDecorators.form:

Zend_Form_Decorator_Form
------------------------

Los objetos ``Zend_Form`` normalmente necesitan generar una etiqueta *HTML*"form". El decorador Form utiliza la
ayuda del view helper Form. Encapsula cualquier contenido provista en un elemento *HTML* form, usando la acción y
el método del objeto Zend Form, y cualquier atributo como atributo *HTML*.

.. _zend.form.standardDecorators.formElements:

Zend_Form_Decorator_FormElements
--------------------------------

Los formularios(forms), grupos de visualización y subformularios son colecciones de elementos. Para poder generar
estos elementos, utilizan el decorador FormElements, el cual itera sobre todos los elementos, llamando a
``render()`` en cada uno de ellos y uniéndolos con el separador indicado. Puede anteponer o postponer al contenido
que se le envía.

.. _zend.form.standardDecorators.formErrors:

Zend_Form_Decorator_FormErrors
------------------------------

Algunos desarrolladores y diseñadores prefieren agrupar todos los mensajes de error en la parte superior del
formulario. El decorador FormErrors le permite hacer esto.

Por defecto, la lista de errores generada tiene el siguiente marcado:

.. code-block:: html
   :linenos:

   <ul class="form-errors">
       <li><b>[etiqueta de elemento o nombre]</b><ul>
               <li>[mensaje de error]</li>
               <li>[mensaje de error]</li>
           </ul>
       </li>
       <li><ul>
           <li><b>[etiqueta o nombre de elemento subformulario</b><ul>
                   <li>[mensaje de error]</li>
                   <li>[mensaje de error]</li>
               </ul>
           </li>
       </ul></li>
   </ul>

Puede pasar como parámetro varias opciones para configurar la salida generada:

- ``ignoreSubForms``: se desactiva o no la recursividad en los subformularios. Por defecto: ``FALSE`` (i.e.,
  permitir recursividad).

- ``markupElementLabelEnd``: Marcado para postponer las etiquetas de elementos. Por defecto: '</b>'

- ``markupElementLabelStart``: Marcado para anteponer las etiquetas de elementos. Por defecto'<b>'

- ``markupListEnd``: Marcado para postponer listas de mensajes de error. Por defecto: '</ul>'.

- ``markupListItemEnd``: Marcado para postponer mensajes de error individuales. Por defecto: '</li>'

- ``markupListItemStart``: Marcado para anteponer mensajes de error individuales. Por defecto: '<li>'

- ``markupListStart``: Marcado para anteponer listas de mensajes de error. Por defecto: '<ul class="form-errors">'

El decorador FormErrors puede anteponerse o postponerse al contenido que se le provee.

.. _zend.form.standardDecorators.htmlTag:

Zend_Form_Decorator_HtmlTag
---------------------------

El decorador HtmlTag le permite utilizar etiquetas *HTML* para decorador el contenido; la etiqueta utiliza es
pasada en la opción 'tag' , y cualquier otra opción es usada como atributo *HTML* de esa etiqueta. Por defecto,
el contenido generado reemplaza al contenido envolviéndolo en la etiqueta dada. De cualquier forma, se permite
especificar una localización de tipo 'append' (postponer) o 'prepend' (anteponer).

.. _zend.form.standardDecorators.image:

Zend_Form_Decorator_Image
-------------------------

El decorador Image le permite crear un input *HTML* de tipo image (``<input type="image" ... />``), y opcionalmente
mostrarlo dentro de otro tag *HTML*.

Por defecto, el decorador usa la propiedad src del elemento, que puede fijarse con el método ``setImage()``, como
la ruta de la imagen ('src'). Adicionalmente, la etiqueta del elemento será usada como la etiqueta 'alt', y
``imageValue`` (manipulado con los métodos ``setImageValue()`` y ``getImageValue()``) será usada como el campo
'value'.

Para especificar una etiqueta *HTML* que utilizar con el elemento, pase la opción 'tag' al decorador, o llame
explícitamente a ``setTag()``.

.. _zend.form.standardDecorators.label:

Zend_Form_Decorator_Label
-------------------------

Comúnmente, los elementos de formulario tienen etiquetas (labels) y se usa el decorador Label para generar esas
etiquetas. Utiliza la ayuda del view helper FormLabel, y toma la etiqueta del elemento mediante el método
``getLabel()`` de ese elemento. Si no se encuentra la etiqueta, no se genera. Por defecto, las etiquetas se
traducen cuando existe un adaptador de traducciones y existe una traducción para la etiqueta.

Opcionalmente, se puede especificar la opción 'tag'; si se suministra, encapsula la etiqueta en la etiqueta *HTML*
en cuestión. Si la opción está presenta pero no hay etiqueta, la etiqueta será generada sin contenido. Puede
especificar la clase que usar con la etiqueta mediante la opción 'class' o llamando a ``setClass()``.

Adicionalmente, se pueden especificar prefijos o sufijos que usar al mostrar en pantalla los elementos, basados en
si la etiqueta es para un elemento opcional o requerido. Por ejemplo, podríamos querer añadir ':' a la etiqueta o
un '\*', indicando que el elemento es requerido. Se puede realizar con las siguientes opciones y métodos:

- ``optionalPrefix``: fija el texto antepuesto a la etiqueta cuando el elemento es opcional. Utilice los accesores
  ``setOptionalPrefix()`` y ``getOptionalPrefix()`` para manipularlo.

- ``optionalSuffix``: fija el texto pospuesto a la etiqueta cuando el elemento es opcional. Utilice los accesores
  ``setOptionalSuffix()`` y ``getOptionalSuffix()`` para manipularlo.

- ``requiredPrefix``: fija el texto antepuesto a la etiqueta cuando el elemento es requerido. Utilice los accesores
  ``setRequiredPrefix()`` y ``getRequiredPrefix()`` para manipularlo.

- ``requiredSuffix``: fija el texto antepuesto a la etiqueta cuando el elemento es requerido. Utilice los accesores
  ``setRequiredSuffix()`` y ``getRequiredSuffix()`` para manipularlo.

Por defecto, el decorador Label antecede al contenido provisto; especifique la opción 'placement' (colocación)
como 'append' para colocarlo después del contenido.

.. _zend.form.standardDecorators.prepareElements:

Zend_Form_Decorator_PrepareElements
-----------------------------------

Formularios, grupos de visualización, y subformularios son colecciones de elementos. Al usar el decorador
:ref:`ViewScript <zend.form.standardDecorators.viewScript>` con un formulario o subformulario, resulta útil el
poder fijar recursívamente el objeto de vista, el traductor (translator)y todos los nombres relacionados
(determinados por la notiación de tabla del subformulario). Esta tarea puede realizarse gracias al decorador
'PrepareElements'. Normalmente, se indicará como el primer decorador en al lista.

.. code-block:: php
   :linenos:

   $form->setDecorators(array(
       'PrepareElements',
       array('ViewScript', array('viewScript' => 'form.phtml')),
   ));

.. _zend.form.standardDecorators.viewHelper:

Zend_Form_Decorator_ViewHelper
------------------------------

La mayoría de los elementos utiliza helpers ``Zend_View`` para generar el contenido, y esto se realiza con el
decorador ViewHelper. Con él, se puede especificar una etiqueta 'helper' para fijar explicitamente el view helper
que utilizar; si no se suministra ninguno, utiliza el último segmento del nombre de clase del elemento para
determinar el helper, anteponiéndole la cadena 'form': e.g., 'Zend_Form_Element_Text' buscaría un view helper del
tipo 'formText'.

Cualquier atributo del elemento suministrado es pasado al view helper como atributo del elemento.

Por defecto, este decorador postpone el contenido; utilice la opción 'placement' para especificar una
localización distinta.

.. _zend.form.standardDecorators.viewScript:

Zend_Form_Decorator_ViewScript
------------------------------

A veces es necesario usar un view script para crear elementos; De esta forma, se puede tener un control preciso
sobre los elementos; entregar el view script a un diseñador, o simplemente crear una forma fácil de sobreescribir
basado en el módulo que se esté usando. El decorador ViewScript soluciona este problema.

El decorador ViewScript requiere una opción 'viewScript', o bien suministrada al decorador, o bien como atributo
del elemento. Entonces genera ese script de vista como un script parcial, lo que significa que cada llamada a él
tiene su propio espacio de variables; Ninguna variable de la vista será rellenada, aparte del elemento en sí.
Distintas variables son entonces rellenadas:

- ``element``: el elemento decorado

- ``content``: el contenido pasado al decorador

- ``decorator``: el propio objeto decorador

- Del mismo modo, todas las opciones pasadas al decorador a través de ``setOptions()`` que no son usadas
  internamente (tales como placement, separator, etc.) son pasadas como variables de vista.

Como ejemplo, se pueden tener el siguiente elemento:

.. code-block:: php
   :linenos:

   // Fija un decorador ViewScript a un único elemento ,
   // especificando como opción el script de vista (obligatorio) y algunas opciones extra
   $element->setDecorators(array(array('ViewScript', array(
       'viewScript' => '_element.phtml',
       'class'      => 'form element'
   ))));

   // o especificando el viewScript como un atributo del elemento:
   $element->viewScript = '_element.phtml';
   $element->setDecorators(array(array('ViewScript',
                                       array('class' => 'form element'))));

Un view script puede tener el siguiente aspecto:

.. code-block:: php
   :linenos:

   <div class="<?php echo  $this->class ?>">
       <?php echo  $this->formLabel($this->element->getName(),
                            $this->element->getLabel()) ?>
       <?php echo  $this->{$this->element->helper}(
           $this->element->getName(),
           $this->element->getValue(),
           $this->element->getAttribs()
       ) ?>
       <?php echo  $this->formErrors($this->element->getMessages()) ?>
       <div class="hint"><?php echo  $this->element->getDescription() ?></div>
   </div>

.. note::

   **Reemplazar contenido con un script de vista (view script)**

   Resulta interesante que el script de vista reemplace el contenido provisto por el decorador -- por ejemplo, si
   desea encapsularlo. Puede hacer esto especificando un valor booleano ``FALSE`` en la opción 'placement' del
   decorador:

   .. code-block:: php
      :linenos:

      // En la creación del decorador:
      $element->addDecorator('ViewScript', array('placement' => false));

      // Aplicado a una instancia de un decorador ya existente:
      $decorator->setOption('placement', false);

      // Aplicado a un decorador ya asociado a un elemento:
      $element->getDecorator('ViewScript')->setOption('placement', false);

      // Dentro de un view script usado por un decorador:
      $this->decorator->setOption('placement', false);

Se recomienda usar el decorador ViewScript cuando necesite un control muy preciso sobre cómo generados sus
elementos.


