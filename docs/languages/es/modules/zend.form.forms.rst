.. _zend.form.forms:

Creando formularios usando Zend_Form
====================================

La clase ``Zend_Form`` es usada para agregar elementos de formulario, desplegar grupos y subformularios. Éstos
pueden ejecutar las siguientes acciones en estos elementos:

- Validación, incluyendo la recuperación de código y mensajes de error

- Agregación de valor, incluyendo el llenado de elementos y recuperación de valores tanto filtrados como no
  filtrados para todos los elementos

- Iteración sobre todos los elementos, en el orden en el cual han sido introducidos o basados en el orden
  recuperado de cada elemento

- Generando el formulario entero, ya sea por un simple decorador que ejecuta un muestreo personalizado o por
  iteración sobre cada elemento del formulario

Mientras los formularios creados con ``Zend_Form`` pueden ser complejos, probablemente su mejor uso es para
formularios simples; es mejor utilizarlo para desarrollar aplicaciones rápidas (RAD) y de prototipado.

En lo más básico, simplemente instancie el objeto formulario:

.. code-block:: php
   :linenos:

   // Objeto form genérico:
   $form = new Zend_Form();

   // Objeto form personalizado:
   $form = new My_Form()

Opcionalmente puede pasarlo en la configuración, la cual será usada para establecer el estado del objeto,
potencialmente así como también crear nuevos elementos:

.. code-block:: php
   :linenos:

   // Pasando opciones en la configuración:
   $form = new Zend_Form($config);

``Zend_Form`` es iterable, e iterará sobre elementos, grupos que mostrar y subformularios, usando el orden en el
cual han sido registrados y en cualquier índice de orden que cada uno pueda tener. Esto es útil en casos donde
desee generar los elementos manualmente en el orden apropiado.

La magia de ``Zend_Form`` radica en la habilidad para servir como fábrica para elementos y grupos, así como
también la habilidad de generarse a sí mismo a través de decoradores.

.. _zend.form.forms.plugins:

Cargadores de Plugin
--------------------

``Zend_Form`` hace uso de ``Zend_Loader_PluginLoader`` para permitir a los desarroladores especificar la ubicación
de elementos y decoradores alternativos. Cada uno tiene su propio plugin loader asociado, y métodos de acceso
genéricos son usados para recuperar y modificar cada uno.

Los siguientes tipos de cargadores son usados con los variados métodos del plugin loader: 'element' y 'decorator'.
Los nombres de los tipos no distinguen mayúsculas de minúsculas.

Los métodos usados para interactuar con plugin loaders son los siguientes:

- ``setPluginLoader($loader, $type)``: $loader es el propio objeto plugin loader, mientras ``$type`` es uno de los
  tipos especificados arriba. Esto establece el plugin loader para el tipo dado al objeto loader recién
  especificado.

- ``getPluginLoader($type)``: recupera el plugin loader asociado con ``$type``.

- ``addPrefixPath($prefix, $path, $type = null)``: agrega una asociación prefijo/ruta al loader especificado por
  ``$type``. Si ``$type`` es nulo, intentará añadir una ruta a todos los loaders, añadiendo el prefijo
  "\_Element" y "\_Decorator"; y añadiendo la ruta con "Element/" y "Decorator/". Si tiene todas sus clases form
  element extras bajo una jerarquía común, éste es un método coveniente para establecer el prefijo de base para
  ellas.

- ``addPrefixPaths(array $spec)``: le permite añadir varias rutas en uno o mas plugin loaders. Se espera que cada
  elemento del array sea un array con las claves 'path', 'prefix' y 'type'.

Adicionalmente, puede especificar prefijos de rutas para todos los elementos y mostrar grupos creados a través de
una instancia de ``Zend_Form`` usando los siguientes métodos:

- ``addElementPrefixPath($prefix, $path, $type = null)``: Igual que ``addPrefixPath()``, debe especificar un
  prefijo y ruta de clase. ``$type``, cuando se especifica, tiene que ser uno de los tipos plugin loader
  especificados por ``Zend_Form_Element``; vea la :ref:`sección elemento plugins <zend.form.elements.loaders>`
  para más información de valores válidos para ``$type``. Si ``$type`` no es especificado, el método asumirá
  que es un prefijo general para todos los tipos.

- ``addDisplayGroupPrefixPath($prefix, $path)``: Igual que ``addPrefixPath()``, debe especificar un prefijo y ruta
  de clase; sin embargo, dado que los grupos de visualización (display groups) sólo soportan decoradores como
  plugins, ``$type`` no es necesario.

Elementos y decoradores personalizados son una manera fácil de compartir funcionalidad entre formularios y
encapsular funcionalidad personalizada. Vea el :ref:`ejemplo de Etiqueta Personalizada
<zend.form.elements.loaders.customLabel>` en la documentación de elementos para un ejemplo de cómo elementos
personalizados pueden ser usados como reemplazos para clases estándar.

.. _zend.form.forms.elements:

Elementos
---------

``Zend_Form`` proporciona varios métodos de acceso para añadir y eliminar elementos de el formulario. Éstos
pueden tomar instancias de objetos de elemento o servir como fábricas para instanciar el objeto elemento a sí
mismo.

El método más básico para añadir un elemento es ``addElement()``. Este método puede tomar también un objeto
de tipo ``Zend_Form_Element`` (o de una clase extendiendo ``Zend_Form_Element``), o argumentos para construir un
nuevo elemento -- incluyendo el elemento tipo, nombre y algunas opciones de configuración.

Como algunos ejemplos:

.. code-block:: php
   :linenos:

   // Usando un elemento instanciado:
   $element = new Zend_Form_Element_Text('foo');
   $form->addElement($element);

   // Usando una fábrica
   //
   // Crea un elemento de tipo Zend_Form_Element_Text con el
   // nombre de 'foo':
   $form->addElement('text', 'foo');

   // Pasa una opción etiqueta al elemento:
   $form->addElement('text', 'foo', array('label' => 'Foo:'));

.. note::

   **addElement() Implementa una Interfaz Fluida**

   ``addElement()`` implementa una interfaz fluida; es decir, retorna el objeto ``Zend_Form`` y no un elemento.
   Esto se ha hecho para permitirle encadenar multiples métodos addElement() u otros métodos formulario que
   implementen una interfaz fluida (todos los establecedores en Zend_Form implementan el patrón).

   Si desea retornar el elemento, use ``createElement()``, el cual es esbozado abajo. Tenga en cuenta de cualquier
   manera que ``createElement()`` no adjunta el elemento al formulario.

   Internamente, ``addElement()`` en realidad emplea ``createElement()`` para crear el elemento antes de adjuntarlo
   al formulario.

Una vez que el elemento ha sido añadido al formulario, puede recuperarlo por el nombre. Puede también finalizar
usando el método ``getElement()`` o usando sobrecarga para acceder al elemento como una propiedad de objeto:

.. code-block:: php
   :linenos:

   // getElement():
   $foo = $form->getElement('foo');

   // Como propiedad del objeto:
   $foo = $form->foo;

Ocasionalmente, se quiere crear un elemento sin adjuntarlo al formulario (para instanciar, si se desea hacer uso de
las rutas de plugin introducidas con el formulario, pero después se desea adjuntar el objeto al subformulario). El
método ``createElement()`` permite hacer eso:

.. code-block:: php
   :linenos:

   // $username llega a ser un objeto Zend_Form_Element_Text:
   $username = $form->createElement('text', 'username');

.. _zend.form.forms.elements.values:

Llenar y recuperar valores
^^^^^^^^^^^^^^^^^^^^^^^^^^

Después de validar el formulario, originalmente se necesitará recuperar los valores para poder ejecutar otras
operaciones, tal como actualizar una base de datos o notificar un servicio web. Se pueden recuperar todos los
valores para todos los elementos usando ``getValues()``; ``getValue($name)`` le permite recuperar un solo valor del
elemento por su nombre:

.. code-block:: php
   :linenos:

   // Obtener todos los valores:
   $values = $form->getValues();

   // Obtener sólo los valores del elemento 'foo':
   $value = $form->getValue('foo');

A veces se quiere llenar el formulario con valores especificos antes de generarlos. Éstos pueden ser llevados a
cabo ya sea con los métodos ``setDefaults()`` o ``populate()``:

.. code-block:: php
   :linenos:

   $form->setDefaults($data);
   $form->populate($data);

Por otro lado, si se quisera limpiar el formulario antes de llenarlo o validarlo; se puede realizar usando el
método ``reset()``:

.. code-block:: php
   :linenos:

   $form->reset();

.. _zend.form.forms.elements.global:

Operaciones Globales
^^^^^^^^^^^^^^^^^^^^

Ocasionalemnte se necesitarán ciertas operaciones que afecten a todos los elementos. Escenarios comunes incluyen
la necesidad de determinar rutas de acceso al prefijo complemento para todos los elementos, determinando
decoradores para todos los elementos y determinando filtros para todos los elementos. Como ejemplos:

.. _zend.form.forms.elements.global.allpaths:

.. rubric:: Determinando rutas de acceso de prefijos para todos los elementos

Se puede determinar rutas de acceso para prefijos para todos los elementos por tipo, o usando un prefijo global.
Como ejemplos:

.. code-block:: php
   :linenos:

   // Determinar la ruta de acceso de prefijos global
   // Crear rutas de acceso para los prefijos My_Foo_Filter, My_Foo_Validate,
   // y My_Foo_Decorator
   $form->addElementPrefixPath('My_Foo', 'My/Foo/');

   // Sólo rutas de acceso de filtros:
   $form->addElementPrefixPath('My_Foo_Filter',
                               'My/Foo/Filter',
                               'filter');

   // Sólo rutas de acceso de validadores:
   $form->addElementPrefixPath('My_Foo_Validate',
                               'My/Foo/Validate',
                               'validate');

   // Sólo rutas de acceso de decoradores:
   $form->addElementPrefixPath('My_Foo_Decorator',
                               'My/Foo/Decorator',
                               'decorator');

.. _zend.form.forms.elements.global.decorators:

.. rubric:: Determinando Decoradores para todos los elementos

Se pueden determinar decoradores para todos los elementos. ``setElementDecorators()`` acepta una matriz de
decoradores, solo como ``setDecorators()``, y reescribirá cualquier decorador previamente determinado en cada
elemento. En este ejemplo, determinamos los decoradores para simplificar una ViewHelper y una Label:

.. code-block:: php
   :linenos:

   $form->setElementDecorators(array(
       'ViewHelper',
       'Label'
   ));

.. _zend.form.forms.elements.global.decoratorsFilter:

.. rubric:: Determinando decoradores para algunos elementos

Pueden determinarse también decoradores para un subconjunto de elementos, ya sea por inclusión o exclusión. El
segundo argumento ``setElementDecorators()`` puede ser un array de nombres de elemento; por defecto, especificar un
array de ese tipo determinará los decoradores especificados en esos elementos solamente. Puede tambien pasar un
tercer elemento, una bandera indicando si esta lista de elementos es para propósitos de inclusión o exclusión;
si es falso, decorará todos los elementos **excepto** los pasados en la lista, Como uso estándar del método,
cualquier decorador pasado reescribirá cualquier decorador previamente determinado en cada elemento.

En el siguiente fragmento, indicamos que queremos los decoradores ViewHelper y Label para los elementos 'foo' y
'bar':

.. code-block:: php
   :linenos:

   $form->setElementDecorators(
       array(
           'ViewHelper',
           'Label'
       ),
       array(
           'foo',
           'bar'
       )
   );

Por otro lado, con este fragmento, indicaremos que queremos usar solamente los decoradores ViewHelper y Label para
cada elemento **excepto** los elementos 'foo' y 'bar':

.. code-block:: php
   :linenos:

   $form->setElementDecorators(
       array(
           'ViewHelper',
           'Label'
       ),
       array(
           'foo',
           'bar'
       ),
       false
   );

.. note::

   **Algunos Decoradores son Inapropiados para algunos Elementos**

   Mientras ``setElementDecorators()`` puede parecer una buena solución, existen algunos casos donde puede
   terminar con resultados inesperados, Por ejemplo, los muchos elementos botones (Submit, Button, Reset),
   actualmente usan la etiqueta como el valor del botón y sólo usan los decoradores ViewHelper y DtDdWrapper --
   previniendo una etiqueta adicional, errores, y sugerencias de ser generadas; el ejemplo de arriba podría
   duplicar algún contenido (la etiqueta).

   Se puede usar el array de inclusión/exclusión para superar este problema como se ha notado en el ejemplo
   anterior.

   Entonces, use este método sabiamente y dése cuenta de que puede necesitar excluir o cambiar manualmente
   algunos elementos decoradores para prevenir una salida no deseada.

.. _zend.form.forms.elements.global.filters:

.. rubric:: Determinando Filtros para todos los Elementos

En muchos casos, puede quererse aplicar el mismo filtro a todos los elementos; un caso común es ``trim()`` a todos
los valores:

.. code-block:: php
   :linenos:

   $form->setElementFilters(array('StringTrim'));

.. _zend.form.forms.elements.methods:

Métodos para Interactuar con los Elementos
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los siguientes métodos pueden ser usados para interactuar con los elementos:

- ``createElement($element, $name = null, $options = null)``

- ``addElement($element, $name = null, $options = null)``

- ``addElements(array $elements)``

- ``setElements(array $elements)``

- ``getElement($name)``

- ``getElements()``

- ``removeElement($name)``

- ``clearElements()``

- ``setDefaults(array $defaults)``

- ``setDefault($name, $value)``

- ``getValue($name)``

- ``getValues()``

- ``getUnfilteredValue($name)``

- ``getUnfilteredValues()``

- ``setElementFilters(array $filters)``

- ``setElementDecorators(array $decorators)``

- ``addElementPrefixPath($prefix, $path, $type = null)``

- ``addElementPrefixPaths(array $spec)``

.. _zend.form.forms.displaygroups:

Grupos de visualización (display groups)
----------------------------------------

Los grupos de visualización (display groups) son una manera de crear grupos virtuales de elementos para
propósitos de visualización. Todos los elementos quedan accesibles por nombre en el formulario, pero cuando
interactúan o se ejecutan sobre el formulario, cualquiera de los elementos en un grupos de visualización son
generados juntos. El caso más común de uso es agrupando los elementos en fieldsets. (TODO)

La clase base para los grupos de visualización es ``Zend_Form_DisplayGroup``. Mientras puede ser instanciado
directamente, es mejor usar el método ``addDisplayGroup()`` de la clase ``Zend_Form``. Este método toma un array
de elementos como primer argumento y el nombre para el grupo de visualización como segundo argumento.
Opcionalmente, se puede pasar en una array de opciones o en un objeto ``Zend_Config`` como tercer argumento.

Asumiendo que los elementos 'username' y 'password' has sido determinados en el formulario, el siguiente código
podría agrupar estos elementos en un grupo de visualización 'login':

.. code-block:: php
   :linenos:

   $form->addDisplayGroup(array('username', 'password'), 'login');

Puede acceder a los grupos de visualización usando el método ``getDisplayGroup()``, o mediante la sobrecarga
usando el nombre del grupo de visualización:

.. code-block:: php
   :linenos:

   // Usando getDisplayGroup():
   $login = $form->getDisplayGroup('login');

   // Usando sobrecarga:
   $login = $form->login;

.. note::

   **Decoradores por defecto que no necesitan ser cargados**

   Por defecto, los grupos de visualización son cargados durante la inicialización del objeto. Se puede
   deshabilitar pasando la opción 'disableLoadDefaultDecorators' cuando se crea un grupo de visualización:

   .. code-block:: php
      :linenos:

      $form->addDisplayGroup(
          array('foo', 'bar'),
          'foobar',
          array('disableLoadDefaultDecorators' => true)
      );

   Esta opción puede ser una mezcla con otras opciones pasadas, ambas como opciones de array o en el objeto
   ``Zend_Config``

.. _zend.form.forms.displaygroups.global:

Operaciones Globales
^^^^^^^^^^^^^^^^^^^^

Al igual que los elementos, existen algunas operaciones que pueden afectar a todos los grupos de visualización;
éstas incluyen determinar decoradores y fijar la ruta de acceso donde buscar los decoradores.

.. _zend.form.forms.displaygroups.global.paths:

.. rubric:: Fijando el Prefijo de Ruta del Decorador para todos los Grupos de Visualización

Por defecto, los grupos de visualización heredan cualquier ruta de decorador que use el formulario; sin embargo,
si deberían buscar en una ruta alternativa, puede usar el método ``addDisplayGroupPrefixPath()`` method.

.. code-block:: php
   :linenos:

   $form->addDisplayGroupPrefixPath('My_Foo_Decorator', 'My/Foo/Decorator');

.. _zend.form.forms.displaygroups.global.decorators:

.. rubric:: Fijando Decoradores para Todos los Grupos de Visualización

Pueden determinarse decoradores para todos los grupos de visualización, ``setDisplayGroupDecorators()`` admite un
array de decoradores, al igual que ``setDecorators()``, y sobreescribirá cualquier conjunto de decoradores previo
en cada grupo de visualización. En este ejemplo, fijamos los decoradores a un fieldset (el decorador FormElements
es necesario para asegurar que los elementos son iterador):

.. code-block:: php
   :linenos:

   $form->setDisplayGroupDecorators(array(
       'FormElements',
       'Fieldset'
   ));

.. _zend.form.forms.displaygroups.customClasses:

Usando Clases de Grupos de Visualización Personalizadas
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Por defecto, ``Zend_Form`` utiliza la clase ``Zend_Form_DisplayGroup`` para grupos de visualización. Puede ocurrir
que necesite extender esta clase con el fin de obtener una funcionalid personalizada. ``addDisplayGroup()`` no
permite pasar una instancia determinada, pero permite especificar la clase que usar como una de sus opciones,
usando la clave 'displayGroupClass':

.. code-block:: php
   :linenos:

   // Use the 'My_DisplayGroup' class
   $form->addDisplayGroup(
       array('username', 'password'),
       'user',
       array('displayGroupClass' => 'My_DisplayGroup')
   );

Si la clase no ha sido todavía cargada, ``Zend_Form`` intentará cargarla a través de ``Zend_Loader``.

También puede especificar una clase de grupo de visualización por defecto para usar con el formulario, de forma
que todos los grupos de visualización creados con el objeto formulario usen esa clase:

.. code-block:: php
   :linenos:

   // Use the 'My_DisplayGroup' class for all display groups:
   $form->setDefaultDisplayGroupClass('My_DisplayGroup');

Esta funcionalidad puede especificarse en configuraciones como 'defaultDisplayGroupClass', y será cargada con
antelación para asegurar que todos los grupos de visualización usen esa clase.

.. _zend.form.forms.displaygroups.interactionmethods:

Métodos para Interactuar con Grupos de Visualización
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los siguientes métodos pueden ser usados para interactuar con el grupo de visualización:

- ``addDisplayGroup(array $elements, $name, $options = null)``

- ``addDisplayGroups(array $groups)``

- ``setDisplayGroups(array $groups)``

- ``getDisplayGroup($name)``

- ``getDisplayGroups()``

- ``removeDisplayGroup($name)``

- ``clearDisplayGroups()``

- ``setDisplayGroupDecorators(array $decorators)``

- ``addDisplayGroupPrefixPath($prefix, $path)``

- ``setDefaultDisplayGroupClass($class)``

- ``getDefaultDisplayGroupClass($class)``

.. _zend.form.forms.displaygroups.methods:

Métodos Zend_Form_DisplayGroup
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Form_DisplayGroup`` tiene los siguientes métodos, agrupados por tipo:

- Configuración:

  - ``setOptions(array $options)``

  - ``setConfig(Zend_Config $config)``

- Metadatos:

  - ``setAttrib($key, $value)``

  - ``addAttribs(array $attribs)``

  - ``setAttribs(array $attribs)``

  - ``getAttrib($key)``

  - ``getAttribs()``

  - ``removeAttrib($key)``

  - ``clearAttribs()``

  - ``setName($name)``

  - ``getName()``

  - ``setDescription($value)``

  - ``getDescription()``

  - ``setLegend($legend)``

  - ``getLegend()``

  - ``setOrder($order)``

  - ``getOrder()``

- Elementos:

  - ``createElement($type, $name, array $options = array())``

  - ``addElement($typeOrElement, $name, array $options = array())``

  - ``addElements(array $elements)``

  - ``setElements(array $elements)``

  - ``getElement($name)``

  - ``getElements()``

  - ``removeElement($name)``

  - ``clearElements()``

- Cargadores Complemento:

  - ``setPluginLoader(Zend_Loader_PluginLoader $loader)``

  - ``getPluginLoader()``

  - ``addPrefixPath($prefix, $path)``

  - ``addPrefixPaths(array $spec)``

- Decoratores:

  - ``addDecorator($decorator, $options = null)``

  - ``addDecorators(array $decorators)``

  - ``setDecorators(array $decorators)``

  - ``getDecorator($name)``

  - ``getDecorators()``

  - ``removeDecorator($name)``

  - ``clearDecorators()``

- Generadores:

  - ``setView(Zend_View_Interface $view = null)``

  - ``getView()``

  - ``render(Zend_View_Interface $view = null)``

- I18n:

  - ``setTranslator(Zend_Translator_Adapter $translator = null)``

  - ``getTranslator()``

  - ``setDisableTranslator($flag)``

  - ``translatorIsDisabled()``

.. _zend.form.forms.subforms:

Subformularios
--------------

Los Sub formularios sirven para diferentes propósitos:

- Crear grupos de elementos lógicos. Dado que los sub formularios son simplemente formularios, se pueden validar
  subformularios como entidades individuales.

- Crear formularios multi-páginas. Dado que los sub formularios son simplemente formularios, se puede deplegar un
  sub formulario por separado por página, incrementando formularios multi-páginas donde cada formulario tiene su
  propia validación lógica. Solo una vez que todos los sub formularios se validen, el formulario se consideraría
  completo.

- Agrupaciones de visualización. Como grupos de visualización, los sub formularios, cuando son generados como
  parte de un formulario más grande, pueden ser usados para agrupar elementos. Sea consciente, de todas maneras,
  que el objeto formulario principal no tendrá conocimiento de los elementos en un sub formulario.

Un sub formulario puede ser un objeto ``Zend_Form`` o mas originalmente, un objeto ``Zend_Form_SubForm``. éste
último contiene decoradores apropiados para la inclusión en un formulario extenso (i.e., no se generan
adicionales formulario etiquetas *HTML*, pero si grupos de elementos). Para adjuntar un sub formulario, simplemente
añádalo al formulario y déle un nombre:

.. code-block:: php
   :linenos:

   $form->addSubForm($subForm, 'subform');

Se puede recuperar un sub formulario usando ya sea ``getSubForm($name)`` o sobrecarga usando el nombre del sub
formulario:

.. code-block:: php
   :linenos:

   // Usando getSubForm():
   $subForm = $form->getSubForm('subform');

   // Usando sobrecarga:
   $subForm = $form->subform;

Los Subformularios son incluidos en la interacción del formulario, sin embargo los elementos que lo contienen no
lo son

.. _zend.form.forms.subforms.global:

Operaciones Globales
^^^^^^^^^^^^^^^^^^^^

Como los elementos y los grupos de visualización, existen algunas operaciones que pueden afectar a todos los sub
formularios. A diferencia de los grupos de visualización y los elementos, sin embargo, los sub formularios heredan
más funcionalidad del objeto formulario principal, y la única operación real que puede realizarse globalmente es
determinar decoradores para sub formularios. Para este propósito, existe el método ``setSubFormDecorators()``. En
el siguiente ejemplo, determinaremos el decorador para todos los subformularios que sera un simple campo (el
decorador FormElements es necesario para asegurar que los elementos son iterados):

.. code-block:: php
   :linenos:

   $form->setSubFormDecorators(array(
       'FormElements',
       'Fieldset'
   ));

.. _zend.form.forms.subforms.methods:

Métodos para interactuar con Sub Formularios
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los siguientes métodos pueden ser usados para interactuar con sub formularios:

- ``addSubForm(Zend_Form $form, $name, $order = null)``

- ``addSubForms(array $subForms)``

- ``setSubForms(array $subForms)``

- ``getSubForm($name)``

- ``getSubForms()``

- ``removeSubForm($name)``

- ``clearSubForms()``

- ``setSubFormDecorators(array $decorators)``

.. _zend.form.forms.metadata:

Metadatos y Atributos
---------------------

Mientras la utilidad de un formulario primariamente deriva de los elementos que contiene, también pueden contener
otros metadatos, como un nombre (usado a menudo como ID único en el marcado *HTML*); la accion y el método del
formulario; el número de elementos, grupos y sub formularios que lo contienen; y arbitrariamente metadatos
(usualmente usados para determinar atributos *HTML* para la etiqueta del propio formulario).

Se puede determinar y recuperar el nombre del formulario usando el accesor nombre:

.. code-block:: php
   :linenos:

   // Determinar el nombre:
   $form->setName('registration');

   // Recuperar el nombre:
   $name = $form->getName();

Para determinar la acción (url en el cual se envia el formulario) y método (método por el cual debería enviar,
ej. 'POST' or 'GET'), use los accesores acción y método:

.. code-block:: php
   :linenos:

   // Determinar la acción y método:
   $form->setAction('/user/login')
        ->setMethod('post');

Se puede también especificar el tipo de codificación del fomulario usando el enctype accessors. Zend_Form define
dos constantes, ``Zend_Form::ENCTYPE_URLENCODED`` y ``Zend_Form::ENCTYPE_MULTIPART``, correspondiente a los valores
'application/x-www-form-urlencoded' y 'multipart/form-data', respectivamente; sin embargo, puede configurarlo con
cualquier tipo de codificación.

.. code-block:: php
   :linenos:

   // Determinar la acción, método y enctype:
   $form->setAction('/user/login')
        ->setMethod('post')
        ->setEnctype(Zend_Form::ENCTYPE_MULTIPART);

.. note::

   El método, acción y enctype son solo usados internamente para generar, y no para algún tipo de validación.

``Zend_Form`` implementa la interfaz ``Countable`` permitiéndole pasarlo como un argumento para contar:

.. code-block:: php
   :linenos:

   $numItems = count($form);

Determinar metadatos arbitrariamente se realiza a través de los accesores 'atribs'. Dado que la sobrecarga en
``Zend_Form`` es usada para acceder elementos, grupos de visualización y subformularios, este es el único método
para acceder a los metadatos.

.. code-block:: php
   :linenos:

   // Determinando atributos:
   $form->setAttrib('class', 'zend-form')
        ->addAttribs(array(
            'id'       => 'registration',
            'onSubmit' => 'validate(this)',
        ));

   // Recuperando atributos:
   $class = $form->getAttrib('class');
   $attribs = $form->getAttribs();

   // Removiendo atributos:
   $form->removeAttrib('onSubmit');

   // Limpiando todos los atributos:
   $form->clearAttribs();

.. _zend.form.forms.decorators:

Decoradores
-----------

Crear el marcado para un formulario es a menudo una tarea que consume mucho tiempo, particularmente si se planea
reusar el mismo marcado para mostrar acciones tales como validación de errores, enviar valores, etc. La respuesta
de ``Zend_Form`` a este problema es los **decoradores**.

Los decoradores para objetos ``Zend_Form`` pueden ser usados para generar un formulario. El decorador FormElements
iterará a través de todos los elementos en un formulario -- elementos, grupos de visualización y subformularios
-- y los generará, devolviendo el resultado. Adicionalmente, los decoradores pueden ser usados para envolver el
contenido o anteponerlo o postponerlo.

Los decoradores por defecto de ``Zend_Form`` son FormElements, HtmlTag (envuelve una lista de definición) y Form;
el código equivalente para crearlos es como sigue:

.. code-block:: php
   :linenos:

   $form->setDecorators(array(
       'FormElements',
       array('HtmlTag', array('tag' => 'dl')),
       'Form'
   ));

Que crea la salida como sigue:

.. code-block:: html
   :linenos:

   <form action="/form/action" method="post">
   <dl>
   ...
   </dl>
   </form>

Algunos de los atributos se determinan en el objeto formulario que será usado como atributos *HTML* de la etiqueta
``<form>``.

.. note::

   **Decoradores por defecto que no necesitan ser cargados**

   Por defecto, el decorador por defecto son cargados durante la inicialización del objeto. Puede deshabilitarlo
   pasando la opción 'disableLoadDefaultDecorators' al constructor:

   .. code-block:: php
      :linenos:

      $form = new Zend_Form(array('disableLoadDefaultDecorators' => true));

   Esta opción puede ser combinada con alguna otra opción que usted pueda pasar, tanto como opciones de array o
   en un objeto ``Zend_Config``

.. note::

   **Usando multiples decoradores del mismo tipo**

   Internamente, ``Zend_Form`` usa una clase decorador como un mecanismo buscador cuando se recuperan decoradores.
   Como resultado, no se pueden registrar multiples decoradores del mismo tipo; subsecuentemente los decoradores
   simplemente sobrescribirán esos decoradores que existían antes.

   Para conseguir esto, se pueden usar alias. En vez de pasar un decorador o un nombre de decorador como primer
   argumento a ``addDecorator()``, pase un array con un solo elemento, con el alias apuntando al objeto decorador o
   nombre:

   .. code-block:: php
      :linenos:

      // Alias para 'FooBar':
      $form->addDecorator(array('FooBar' => 'HtmlTag'), array('tag' => 'div'));

      // y recuperarlo después:
      $form = $element->getDecorator('FooBar');

   En los métodos ``addDecorators()`` y ``setDecorators()``, se necesitará pasar la opción 'decorator' en el
   array representando el decorador:

   .. code-block:: php
      :linenos:

      // Añadir dos decoradores 'HtmlTag', poniendo un alias a 'FooBar':
      $form->addDecorators(
          array('HtmlTag', array('tag' => 'div')),
          array(
              'decorator' => array('FooBar' => 'HtmlTag'),
              'options' => array('tag' => 'dd')
          ),
      );

      // y recuperándolo después:
      $htmlTag = $form->getDecorator('HtmlTag');
      $fooBar  = $form->getDecorator('FooBar');

Puede crear su propio decorador para generar el formulario. Un caso de uso común es si sabe el HTML exacto que
desea usar; su decorador puede crear el mismo HTML y simplemente retornarlo, potencialmente usando los decoradores
de individuales elementos o grupos de visualización.

Los siguientes métodos puden ser usados para interactuar con decoradores:

- ``addDecorator($decorator, $options = null)``

- ``addDecorators(array $decorators)``

- ``setDecorators(array $decorators)``

- ``getDecorator($name)``

- ``getDecorators()``

- ``removeDecorator($name)``

- ``clearDecorators()``

``Zend_Form`` también usa sobrecarga que permite generar decoradores específicos. ``__call()`` interceptará
métodos que lleve con el texto 'render' y use el resto del nombre del método para buscar un decorador; si se
encuentran, serán generados por un **solo** decorador. Cualquier argumento pasado a la llamada del método será
usado como contenido que pasar al método ``render()`` del decorador. Como ejemplo:

.. code-block:: php
   :linenos:

   // Generar solo los decoradores FormElements:
   echo $form->renderFormElements();

   // Generar solo el campo decorador, pasando el contenido:
   echo $form->renderFieldset("<p>This is fieldset content</p>");

Si el decorador no existe, una excepción se creará.

.. _zend.form.forms.validation:

Validación
----------

Un caso de uso primario para formularios es validar datos enviados. ``Zend_Form`` le permite validar un formulario
entero de una vez, o una parte de él, asi como también automatizar las respuestas de validación para
XmlHttpRequests (AJAX). Si los datos enviados no son válidos, contiene métodos para recuperar los distintos
códigos errores y los mensajes de elementos y subformularios de validaciones fallidas.

Para validar un formulario entero, use el método ``isValid()``:

.. code-block:: php
   :linenos:

   if (!$form->isValid($_POST)) {
       // validación fallida
   }

``isValid()`` validará cada elemento requerido, y algún elemento no requerido contenido en la data sometida.

Algunas veces se necesitará validar sólo un subset del dato; para esto use ``isValidPartial($data)``:

.. code-block:: php
   :linenos:

   if (!$form->isValidPartial($data)) {
       // validación fallida
   }

``isValidPartial()`` sólo intenta validar aquellos elementos en la información para los cuales existen similares
elementos; si un elemento es no representado en la información, es pasado por alto.

Cuando se validan elementos o grupos de elementos para un requeirimiento *AJAX*, típicamente se validará un
subset del formulario, y quiere la respuesta en *JSON*. ``processAjax()`` precisamente realiza eso:

.. code-block:: php
   :linenos:

   $json = $form->processAjax($data);

Entonces, puede simplemente enviar la respuesta *JSON* al cliente. Si el formulario es válido, ésta será una
respuesta booleana. Si no, será un objeto javascript conteniendo pares de clave/mensaje, donde cada 'message' es
un array de validación de mensajes de error.

Para los formularios que fallan la validación, se pueden recuperar ambos códigos de error y mensajes de error,
usando ``getErrors()`` y ``getMessages()``, respectivamente:

.. code-block:: php
   :linenos:

   $codes = $form->getErrors();
   $messages = $form->getMessage();

.. note::

   Dado que los mensajes devueltos por ``getMessages()`` son un array de pares de errores código/mensaje,
   ``getErrors()`` no es necesario.

Puede recuperar códigos y mensajes de error para elementos individuales simplemente pasando el nombre del elemento
a cada uno:

.. code-block:: php
   :linenos:

   $codes = $form->getErrors('username');
   $messages = $form->getMessages('username');

.. note::

   Nota: Cuando validamos elementos, ``Zend_Form`` envía un segundo argumento a cada método ``isValid()`` del
   elemento: el array de los datos que se están validando. Esto puede ser usado por validadores individuales para
   permitirles utilizar otros valores enviados al determinar la validez de los datos. Un ejemplo sería un
   formulario de registro que requiere tanto una contraseña como una confirmación de la contraseña; el elemento
   contraseña puede usar la confirmación de la contraseña como parte de su validación.

.. _zend.form.forms.validation.errors:

Mensajes de error personalizados
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A veces, puede querer especificar uno o más mensajes de error en vez de los mensajes de error generados por los
validadores adjuntos a los elementos. Adicionalmente, a veces puede querer marcar el formulario inválido usted
mismo. Como 1.6.0, esta funcionalidad es posible siguiendo los métodos. At times, you may want to specify one or
more specific error messages to use instead of the error messages generated by the validators attached to your
elements. Additionally, at times you may want to mark the form invalid yourself. As of 1.6.0, this functionality is
possible via the following methods.

- ``addErrorMessage($message)``: añade un mensaje de error para desplegar en el formulario los errores de
  validación. Se debe llamar más de una vez, y los nuevos mensajes son adicionados a la pila.

- ``addErrorMessages(array $messages)``: añade múltiples mensajes de error para desplegar en el formulario los
  errores de validación

- ``setErrorMessages(array $messages)``: añade multiples mensajes de error para desplegar en el formulario los
  errores de validación, sobrescribiendo todos los mensajes de error previamente determinados.

- ``getErrorMessages()``: recupera la lista de mensajes de error personalizados que han sido definidos.

- ``clearErrorMessages()``: remueve todos los mensajes de error personalizados que han sido definidos.

- ``markAsError()``: marca el formulario como que la validación ha fallado.

- ``addError($message)``: añade un mensaje a la pila de mensajes de error personalizados y señala al formulario
  como inválido.

- ``addErrors(array $messages)``: añade muchos mensajes a la pila de mensajes de error personalizados y señala al
  formulario como inválido.

- ``setErrors(array $messages)``: sobrescribe la pila de mensajes de error personalizada con los mensajes
  proporcionados y señala el formulario como inválido.

Todos los errores determinados de esta manera pueden ser traducidos.

.. _zend.form.forms.validation.values:

Retrieving Valid Values Only
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are scenarios when you want to allow your user to work on a valid form in several steps. Meanwhile you allow
the user to save the form with any set of values inbetween. Then if all the data is specified you can transfer the
model from the building or prototying stage to a valid stage.

You can retrieve all the valid values that match the submitted data by calling:

.. code-block:: php
   :linenos:

   $validValues = $form->getValidValues($_POST);

.. _zend.form.forms.methods:

Métodos
-------

La siguiente lista es la lista completa de métodos disponibles para ``Zend_Form``, agrupados por tipo:

- Configuración y opciones:

  - ``setOptions(array $options)``

  - ``setConfig(Zend_Config $config)``

- Cargadores de plugins y rutas:

  - ``setPluginLoader(Zend_Loader_PluginLoader_Interface $loader, $type = null)``

  - ``getPluginLoader($type = null)``

  - ``addPrefixPath($prefix, $path, $type = null)``

  - ``addPrefixPaths(array $spec)``

  - ``addElementPrefixPath($prefix, $path, $type = null)``

  - ``addElementPrefixPaths(array $spec)``

  - ``addDisplayGroupPrefixPath($prefix, $path)``

- Metadato:

  - ``setAttrib($key, $value)``

  - ``addAttribs(array $attribs)``

  - ``setAttribs(array $attribs)``

  - ``getAttrib($key)``

  - ``getAttribs()``

  - ``removeAttrib($key)``

  - ``clearAttribs()``

  - ``setAction($action)``

  - ``getAction()``

  - ``setMethod($method)``

  - ``getMethod()``

  - ``setName($name)``

  - ``getName()``

- Elementos:

  - ``addElement($element, $name = null, $options = null)``

  - ``addElements(array $elements)``

  - ``setElements(array $elements)``

  - ``getElement($name)``

  - ``getElements()``

  - ``removeElement($name)``

  - ``clearElements()``

  - ``setDefaults(array $defaults)``

  - ``setDefault($name, $value)``

  - ``getValue($name)``

  - ``getValues()``

  - ``getUnfilteredValue($name)``

  - ``getUnfilteredValues()``

  - ``setElementFilters(array $filters)``

  - ``setElementDecorators(array $decorators)``

- Subformularios:

  - ``addSubForm(Zend_Form $form, $name, $order = null)``

  - ``addSubForms(array $subForms)``

  - ``setSubForms(array $subForms)``

  - ``getSubForm($name)``

  - ``getSubForms()``

  - ``removeSubForm($name)``

  - ``clearSubForms()``

  - ``setSubFormDecorators(array $decorators)``

- Grupos de Visualización

  - ``addDisplayGroup(array $elements, $name, $options = null)``

  - ``addDisplayGroups(array $groups)``

  - ``setDisplayGroups(array $groups)``

  - ``getDisplayGroup($name)``

  - ``getDisplayGroups()``

  - ``removeDisplayGroup($name)``

  - ``clearDisplayGroups()``

  - ``setDisplayGroupDecorators(array $decorators)``

- Validación

  - ``populate(array $values)``

  - ``isValid(array $data)``

  - ``isValidPartial(array $data)``

  - ``processAjax(array $data)``

  - ``persistData()``

  - ``getErrors($name = null)``

  - ``getMessages($name = null)``

- Generadores:

  - ``setView(Zend_View_Interface $view = null)``

  - ``getView()``

  - ``addDecorator($decorator, $options = null)``

  - ``addDecorators(array $decorators)``

  - ``setDecorators(array $decorators)``

  - ``getDecorator($name)``

  - ``getDecorators()``

  - ``removeDecorator($name)``

  - ``clearDecorators()``

  - ``render(Zend_View_Interface $view = null)``

- I18n:

  - ``setTranslator(Zend_Translator_Adapter $translator = null)``

  - ``getTranslator()``

  - ``setDisableTranslator($flag)``

  - ``translatorIsDisabled()``

.. _zend.form.forms.config:

Configuración
-------------

``Zend_Form`` es totalmente configurable mediante ``setOptions()`` y ``setConfig()`` (o pasando opciones o un
objeto ``Zend_Config`` al constructor). Usando estos métodos, se pueden especificar elementos formulario, grupos
de visualización, decoradores, y metadatos.

Como regla general, si 'set' + la clave de opción (option key) hacen referencia a métodos ``Zend_Form``, entonces
el valor proporcionado será pasado al método. Si el accessor no existe, se asume que la clave referencia a un
atributo, y será pasado a ``setAttrib()``.

Excepciones a las reglas incluyen lo siguiente:

- ``prefixPaths`` será pasado a ``addPrefixPaths()``

- ``elementPrefixPaths`` será pasado a ``addElementPrefixPaths()``

- ``displayGroupPrefixPaths`` será pasado a ``addDisplayGroupPrefixPaths()``

- los siguientes establecedores no pueden ser determinado de ésta manera:

  - ``setAttrib (aunque setAttribs *funcionará*)``

  - ``setConfig``

  - ``setDefault``

  - ``setOptions``

  - ``setPluginLoader``

  - ``setSubForms``

  - ``setTranslator``

  - ``setView``

Como un ejemplo, aquí esta un archivo de configuración que pasa la configuración por cada tipo de datos
configurables:

.. code-block:: ini
   :linenos:

   [element]
   name = "registration"
   action = "/user/register"
   method = "post"
   attribs.class = "zend_form"
   attribs.onclick = "validate(this)"

   disableTranslator = 0

   prefixPath.element.prefix = "My_Element"
   prefixPath.element.path = "My/Element/"
   elementPrefixPath.validate.prefix = "My_Validate"
   elementPrefixPath.validate.path = "My/Validate/"
   displayGroupPrefixPath.prefix = "My_Group"
   displayGroupPrefixPath.path = "My/Group/"

   elements.username.type = "text"
   elements.username.options.label = "Username"
   elements.username.options.validators.alpha.validator = "Alpha"
   elements.username.options.filters.lcase = "StringToLower"
   ; more elements, of course...

   elementFilters.trim = "StringTrim"
   ;elementDecorators.trim = "StringTrim"

   displayGroups.login.elements.username = "username"
   displayGroups.login.elements.password = "password"
   displayGroupDecorators.elements.decorator = "FormElements"
   displayGroupDecorators.fieldset.decorator = "Fieldset"

   decorators.elements.decorator = "FormElements"
   decorators.fieldset.decorator = "FieldSet"
   decorators.fieldset.decorator.options.class = "zend_form"
   decorators.form.decorator = "Form"

El código de arriba fácilmente puede ser abstraído a un *XML* o un archivo de configuración basado en arrays
*PHP*.

.. _zend.form.forms.custom:

Formularios personalizados
--------------------------

Una alternativa a usar los formularios basados en configuraciones es realizar una subclase de ``Zend_Form``. Esto
tiene muchos beneficios:

- Se puede centrar la prueba de su formulario facilmente para asegurar las validaciones y generar la ejecución
  esperada.

- Control preciso sobre los individuales elementos.

- Reutilización del objeto formulario, y mejor portabilidad (no se necesita seguir los archivos de
  configuración).

- Implementar funcionalidad personalizada.

El caso mas típico de uso sería el método ``init()`` para determinar elementos de formulario específicos y de
configuración:

.. code-block:: php
   :linenos:

   class My_Form_Login extends Zend_Form
   {
       public function init()
       {
           $username = new Zend_Form_Element_Text('username');
           $username->class = 'formtext';
           $username->setLabel('Username:')
                    ->setDecorators(array(
                        array('ViewHelper',
                              array('helper' => 'formText')),
                        array('Label',
                              array('class' => 'label'))
                    ));

           $password = new Zend_Form_Element_Password('password');
           $password->class = 'formtext';
           $password->setLabel('Username:')
                    ->setDecorators(array(
                        array('ViewHelper',
                              array('helper' => 'formPassword')),
                        array('Label',
                              array('class' => 'label'))
                    ));

           $submit = new Zend_Form_Element_Submit('login');
           $submit->class = 'formsubmit';
           $submit->setValue('Login')
                  ->setDecorators(array(
                      array('ViewHelper',
                      array('helper' => 'formSubmit'))
                  ));

           $this->addElements(array(
               $username,
               $password,
               $submit
           ));

           $this->setDecorators(array(
               'FormElements',
               'Fieldset',
               'Form'
           ));
       }
   }

Este formulario puede ser instanciado simplemente así:

.. code-block:: php
   :linenos:

   $form = new My_Form_Login();

y toda la funcionalidad está instalada y lista; no se necesitan archivos de configuración. (Note que este ejemplo
esta simplificado, no contiene validadores o filtros para los elementos.)

Otra razón común para la extension es definir un conjunto de decoradores por defecto. Puede hacerlo
sobreescribiendo el método ``loadDefaultDecorators()``:

.. code-block:: php
   :linenos:

   class My_Form_Login extends Zend_Form
   {
       public function loadDefaultDecorators()
       {
           $this->setDecorators(array(
               'FormElements',
               'Fieldset',
               'Form'
           ));
       }
   }


