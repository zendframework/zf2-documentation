.. _zend.form.standardElements:

Elementos Enviados en el Formulario Estandard de Zend Framework
===============================================================

Zend Framework viene con clases de elementos concretos cubriendo la mayoría de los elementos de los formularios
*HTML*. La mayoría simplemente especifica una vista de ayuda para usar cuando se decora el elemento, pero varios
ofrecen funcionalidad adicional. La siguiente es una lista de todas las clases, así como también una descripción
de la funcionalidad que ofrecen.

.. _zend.form.standardElements.button:

Zend_Form_Element_Button
------------------------

Usada para crear elementos *HTML* de tipo button, ``Zend_Form_Element_Button`` extiende
:ref:`Zend_Form_Element_Submit <zend.form.standardElements.submit>`, derivandi sy funcionalidad personalizada. It
specifies the 'formButton' view helper for decoration.

Like the submit element, it uses the element's label as the element value for display purposes; in other words, to
set the text of the button, set the value of the element. The label will be translated if a translation adapter is
present.

Because the label is used as part of the element, the button element uses only the :ref:`ViewHelper
<zend.form.standardDecorators.viewHelper>` and :ref:`DtDdWrapper <zend.form.standardDecorators.dtDdWrapper>`
decorators.

Después de llenar o validar un formulario, se puede verificar si el botón dado fue pulsado usando el método
``isChecked()``.

.. _zend.form.standardElements.captcha:

Zend_Form_Element_Captcha
-------------------------

Los CAPTCHAs son usados para prevenir el envio automático de formularios por los robots y otros procesos
automatizados.

The Captcha form element allows you to specify which :ref:`Zend_Captcha adapter <zend.captcha.adapters>` you wish
to utilize as a form captcha. It then sets this adapter as a validator to the object, and uses a Captcha decorator
for rendering (which proxies to the CAPTCHA adapter).

Adapters may be any adapters in ``Zend_Captcha``, as well as any custom adapters you may have defined elsewhere. To
allow this, you may pass an additional plugin loader type key, 'CAPTCHA' or 'captcha', when specifying a plugin
loader prefix path:

.. code-block:: php
   :linenos:

   $element->addPrefixPath('My_Captcha', 'My/Captcha/', 'captcha');

Los Captcha entonces pueden ser cargados usando el método ``setCaptcha()``, el cual puede tomar una instancia
cualquiera de CAPTCHA instance, o el nombre corto del adaptador captcha:

.. code-block:: php
   :linenos:

   // instancia concreta:
   $element->setCaptcha(new Zend_Captcha_Figlet());

   // Usando nombre corto:
   $element->setCaptcha('Dumb');

Si desea cargar sus elementos configuración, especifique la clave 'captcha' con un array conteniendo la clave
'captcha', o ambas claves 'captcha' y 'captchaOptions':

.. code-block:: php
   :linenos:

   // Usindo la clave captcha simple:
   $element = new Zend_Form_Element_Captcha('foo', array(
       'label' => "Please verify you're a human",
       'captcha' => array(
           'captcha' => 'Figlet',
           'wordLen' => 6,
           'timeout' => 300,
       ),
   ));

   // Usindo captcha y captchaOptions:
   $element = new Zend_Form_Element_Captcha('foo', array(
       'label' => "Please verify you're a human"
       'captcha' => 'Figlet',
       'captchaOptions' => array(
           'captcha' => 'Figlet',
           'wordLen' => 6,
           'timeout' => 300,
       ),
   ));

El decorador usado es determinado consultando el adaptador captcha. Por defecto, es usado el :ref:`Captcha
decorator <zend.form.standardDecorators.captcha>`, pero un adaptador puede especificar uno diferente vía su
método ``getDecorator()``.

Como ha notado, el adaptador CAPTCHA actúa él mismo como un validador para el elemento. Adicionalmente, el
validador NotEmpty no es usado y el elemento es marcado como requerido. En la mayoría de los casos, usted no
necesitará hacer nada más para tener un captcha presente en su formulario.

.. _zend.form.standardElements.checkbox:

Zend_Form_Element_Checkbox
--------------------------

Las casillas de verificación (checkboxes) *HTML* le permiten devolver un valor específico, pero básicamente
funcionan como los booleanos: cuando está marcada, el valor es enviado; cuando no está marcada, no se envía
nada. Internamente, Zend_Form_Element_Checkbox fuerza este estado.

Por defecto, si la casilla (checkbox) está marcada su valor es '1', y si no está marcada su valor es '0'. You can
specify the values to use using the ``setCheckedValue()`` and ``setUncheckedValue()`` accessors, respectively.
Internally, any time you set the value, if the provided value matches the checked value, then it is set, but any
other value causes the unchecked value to be set.

Additionally, setting the value sets the ``checked`` property of the checkbox. You can query this using
``isChecked()`` or simply accessing the property. Using the ``setChecked($flag)`` method will both set the state of
the flag as well as set the appropriate checked or unchecked value in the element. Please use this method when
setting the checked state of a checkbox element to ensure the value is set properly.

``Zend_Form_Element_Checkbox`` uses the 'formCheckbox' view helper. The checked value is always used to populate
it.

.. _zend.form.standardElements.file:

Zend_Form_Element_File
----------------------

The File form element provides a mechanism for supplying file upload fields to your form. It utilizes
:ref:`Zend_File_Transfer <zend.file.transfer.introduction>` internally to provide this functionality, and the
``FormFile`` view helper as also the ``File`` decorator to display the form element.

By default, it uses the ``Http`` transfer adapter, which introspects the ``$_FILES`` array and allows you to attach
validators and filters. Validators and filters attached to the form element will be attached to the transfer
adapter.

.. _zend.form.standardElements.file.usage:

.. rubric:: File form element usage

The above explanation of using the File form element may seem arcane, but actual usage is relatively trivial:

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload');
   // ensure only 1 file
   $element->addValidator('Count', false, 1);
   // limit to 100K
   $element->addValidator('Size', false, 102400);
   // only JPEG, PNG, and GIFs
   $element->addValidator('Extension', false, 'jpg,png,gif');
   $form->addElement($element, 'foo');

También debe asegurarse de que se ha provisto un tipo de codificación corecto al formulario; se debe utilizar
'multipart/form-data'. Se puede hacer esto estableciendo el atributo 'enctype' en el formulario:

.. code-block:: php
   :linenos:

   $form->setAttrib('enctype', 'multipart/form-data');

After the form is validated successfully, you must receive the file to store it in the final destination using
``receive()``. Additionally you can determinate the final location using ``getFileName()``:

.. code-block:: php
   :linenos:

   if (!$form->isValid) {
       print "Ohoh... validation error";
   }

   if (!$form->foo->receive()) {
       print "Error receiving the file";
   }

   $location = $form->foo->getFileName();

.. note::

   **Ubicaciones Predeterminadas para la Carga de Archivos**

   Por defecto, los archivos son cargados al directorio temp del sistema.

.. note::

   **Valores de archivo**

   Dentro de *HTTP*, un elemento file no tiene valor. Por tanto y a causa de razones de seguridad usted solo
   obtendrá el nombre del archivo cargado llamando a getValue() y no el destino completo. si usted necesita la
   información completa llame a getFileName() y le devolverá el destino y nombre de archivo completo.

Per default the file will automatically be received when you call ``getValues()`` on the form. The reason behind
this behaviour is, that the file itself is the value of the file element.

.. code-block:: php
   :linenos:

   $form->getValues();

.. note::

   Therefor another call of ``receive()`` after calling ``getValues()`` will not have an effect. Also creating a
   instance of ``Zend_File_Transfer`` will not have an effect as there no file anymore to receive.

Still, sometimes you may want to call ``getValues()`` without receiving the file. You can archive this by calling
``setValueDisabled(true)``. To get the actual value of this flag you can call ``isValueDisabled()``.

.. _zend.form.standardElements.file.retrievement:

.. rubric:: Explicit file retrievement

First call ``setValueDisabled(true)``.

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload')
           ->setValueDisabled(true);

Now the file will not be received when you call ``getValues()``. So you must call ``receive()`` on the file
element, or an instance of ``Zend_File_Transfer`` yourself.

.. code-block:: php
   :linenos:

   $values = $form->getValues();

   if ($form->isValid($form->getPost())) {
       if (!$form->foo->receive()) {
           print "Upload error";
       }
   }

There are several states of the uploaded file which can be checked with the following methods:

- ``isUploaded()``: Checks if the file element has been uploaded or not.

- ``isReceived()``: Checks if the file element has already been received.

- ``isFiltered()``: Checks if the filters have already been applied to the file element or not.

.. _zend.form.standardElements.file.isuploaded:

.. rubric:: Checking if an optional file has been uploaded

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload')
           ->setRequired(false);
   $element->addValidator('Size', false, 102400);
   $form->addElement($element, 'foo');

   // The foo file element is optional but when it's given go into here
   if ($form->foo->isUploaded()) {
       // foo file given... do something
   }

``Zend_Form_Element_File`` soporta también archivos múltiples. Para llamar el método ``setMultiFile($count)``
usted puede establecer la cantidad de elementos file que usted desea crear. Esto le previene de establecer la misma
configuración varias veces.

.. _zend.form.standardElements.file.multiusage:

.. rubric:: Configuración de múltiples archivos

Crear un elemento multi archivo es lo mismo que querer configurar un elemento único. Sólo tiene que llamar a
``setMultiFile()`` adicionalmente después de la creación:

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload');
   // asegura mínimo 1, maximo 3 archivos
   $element->addValidator('Count', false, array('min' => 1, 'max' => 3));
   // limita a 100K
   $element->addValidator('Size', false, 102400);
   // solo JPEG, PNG, y GIFs
   $element->addValidator('Extension', false, 'jpg,png,gif');
   // define 3 elementos file idénticos
   $element->setMultiFile(3);
   $form->addElement($element, 'foo');

En su vista usted ahora obtendrá 3 elementos para carga de archivos idénticos los cuales comparten la misma
configuración. Para obtener el conjunto del número de archivos múltiples simplemente llame a ``getMultiFile()``.

.. note::

   **Elementos File en Subformularios**

   Cuando usted use elementos file en subformularios debería establecer nombres únicos. Así, cuando usted nombre
   su elemento file en el subformulario1, debe darle un nombre diferente en el subformularios.

   Tan pronto como haya dos elementos file nombrados de forma idéntica, el segundo elemento no se mostrará o
   enviará.

   Additionally, file elements are not rendered within the sub-form. So when you add a file element into a subform,
   then the element will be rendered within the main form.

Para limitar el tamaño del archivo, el cual es cargado por el cliente, debe establecer el tamaño máximo de
archivo que el formulario acepta . Esto limitará el tamaño del archivo en el lado del cliente configurando la
opción ``MAX_FILE_SIZE`` en el formulario. Tan pronto como establezca este valor usando el método
``setMaxFileSize($size)``, será generado con el elemento file.

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Upload an image:')
           ->setDestination('/var/www/upload')
           ->addValidator('Size', false, 102400) // límite en 100K
           ->setMaxFileSize(102400); // limita el tamaño del archivo en el lado del cliente
   $form->addElement($element, 'foo');

.. note::

   **MaxFileSize con elementos file múltiples**

   Cuando usted usa elementos file múltiples en los formularios tiene que establecer el ``MAX_FILE_SIZE`` una sola
   vez. Establecerlo otra vez sobreescribirá el valor previamente establecido.

   Note que usted puede establecer ``MAX_FILE_SIZE`` una sola vez, incluso si usa múltiples formularios.

.. _zend.form.standardElements.hidden:

Zend_Form_Element_Hidden
------------------------

Los elementos Hidden simplemente inyectan datos que deben ser enviados, pero que el usuario no debe manipular.
``Zend_Form_Element_Hidden`` logra esto a través del uso del helper de vista 'formHidden'.

.. _zend.form.standardElements.hash:

Zend_Form_Element_Hash
----------------------

Este elemento provee protección de ataques desde CSRF sobre formularios, asegurando que el dato es enviado por la
sesión del usuario que generó el formulario y no por un script malicioso. La protección se logra mediante la
adición de un elemento hash a un formulario y verificandolo cuando el formulario es enviado.

El nombre del elemento hash debe ser único. Se recomienda usar la opción ``salt`` para el elemento, dos hashes
con el mismo nombre y diferentes salts no chocan:

.. code-block:: php
   :linenos:

   $form->addElement('hash', 'no_csrf_foo', array('salt' => 'unique'));

Puede establecer el salt más tarde usando el método ``setSalt($salt)``.

Internamente, el elemento almacena un identificador único usando ``Zend_Session_Namespace``, y lo comprueba en el
momento que se envía (comprueba que el TTL no ha espirado). El validador 'Identical' entonces es usado para
asegurarse que el hash enviado marcha con el hash alamacenado.

El helper de vista 'formHidden' es usado para generar el elemento en el formulario.

.. _zend.form.standardElements.Image:

Zend_Form_Element_Image
-----------------------

Las imágenes pueden ser usadas como elementos de formulario, y le permiten especificar elementos gráficos como
botones de formulario.

Los elementos Image necesitan una imagen fuente. ``Zend_Form_Element_Image`` le permite especificar esto usando el
método de acceso ``setImage()`` (o clave de configuración 'image'). Opcionalmente, también puede especificar un
valor para utilizar al momento de enviar la imagen utilizando el método de acceso ``setImageValue()`` (o clave de
configuración 'imageValue'). Cuando el valor establecido para el elemento sea igual a ``imageValue``, entonces el
método de acceso ``isChecked()`` devolverá ``TRUE``.

Los elementos Image usan el :ref:`Decorador de Imagen <zend.form.standardDecorators.image>` para generar (así como
el estandard Errors, HtmlTag, y decorador Label). Opcionalmente, puede especificar una etiqueta para el decorador
``Image`` que luego envuelva al elemento imagen.

.. _zend.form.standardElements.multiCheckbox:

Zend_Form_Element_MultiCheckbox
-------------------------------

En ocasiones, se tiene un conjunto de checkboxes, y se desea agrupar los resultados. Esto es como un
:ref:`Multiselect <zend.form.standardElements.multiselect>`, pero en lugar de estar en una lista desplegable,
necesita mostrarlos en pares checkbox/value (casilla de verificación/valor).

``Zend_Form_Element_MultiCheckbox`` hace esto sencillo. Like all other elements extending the base Multi element,
you can specify a list of options, and easily validate against that same list. The 'formMultiCheckbox' view helper
ensures that these are returned as an array in the form submission.

Por defecto, este elemnto requiere un validador ``InArray`` el cual valida contra el array de llaves de las
opciones registradas. Se puede desactivar esta caracteristica llamando a ``setRegisterInArrayValidator(false)``, o
pasando un valor ``FALSE`` a la configuración de llaves ``registerInArrayValidator``.

Se puede manipular las opciones de checkbox usando los siguinetes métodos:

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (overwrites existing options)

- getMultiOption($option)

- getMultiOptions()

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

Para marcar los valores confirmados, se necesita pasar un array de valores a ``setValue()``. El siguiente código
verificará los valores "bar" y "bat":

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_MultiCheckbox('foo', array(
       'multiOptions' => array(
           'foo' => 'Foo Option',
           'bar' => 'Bar Option',
           'baz' => 'Baz Option',
           'bat' => 'Bat Option',
       );
   ));

   $element->setValue(array('bar', 'bat'));

Note que cuando se determina un asimple variable, se debe pasar un array.

.. _zend.form.standardElements.multiselect:

Zend_Form_Element_Multiselect
-----------------------------

*XHTML* ``selector`` de elementos permite 'multiple' atributos, indicando multiples opciones pueden ser
seleccionados por submision, en vez de lo usual. ``Zend_Form_Element_Multiselect`` extiende
:ref:`Zend_Form_Element_Select <zend.form.standardElements.select>`, y define los atributos ``multiple`` a
'multiple'. Como las otras clases que heredan de la clase base ``Zend_Form_Element_Multi``, se puede manipular las
opciones del selector usando:

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (overwrites existing options)

- getMultiOption($option)

- getMultiOptions()

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

Si un adaptador de tranducción es registrado con el formulario y/o elemnto, la opción valores será traducido
para propósito de despliegue.

Por defecto, este elemento registra un validador ``InArray`` el cual valida contra el array de llaves de opciones
registradas. se puede deshabilitar esta caracteristica llamando a ``setRegisterInArrayValidator(false)``, o pasando
un valor ``FALSE`` a la configuracion de llaves ``registerInArrayValidator``.

.. _zend.form.standardElements.password:

Zend_Form_Element_Password
--------------------------

Elementos contraseña son basicamente elementos de texto -- excepto que tipicamente no se quiera desplegar la
contraseña en los mensajes de error o del elemnto en si cuando el formulario es re desplegado.

``Zend_Form_Element_Password`` archiva esto llamando ``setValueObscured(true)`` en cada validador (asegurando que
la contraseña este oculta en mensajes de validación de errores), y usando la vista ayuda 'formPassword' (el cual
no desplega el valor pasado).

.. _zend.form.standardElements.radio:

Zend_Form_Element_Radio
-----------------------

elementos de Radio permite especificar muchas opciones, de los cuales se necesita retornar un solo valor.
``Zend_Form_Element_Radio`` extiende la clase base ``Zend_Form_Element_Multi``, permitiendonos especificar un
numero de opciones, y luego usa la vista ayuda ``formRadio`` para desplegar.

Por defecto, este elemento registra un validador ``InArray`` el cual valida contra el array de llaves de opciones
registradas. se puede deshabilitar esta caracteristica llamando a ``setRegisterInArrayValidator(false)``, o pasando
un valor ``FALSE`` a la configuracion de llaves ``registerInArrayValidator``. configuration key.

Como todos los elementos se extienden del elemento clase base Multi, los siguientes métodos pueden ser usados para
manipular las opciones de radio desplegadas:

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (overwrites existing options)

- getMultiOption($option)

- getMultiOptions()

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

.. _zend.form.standardElements.reset:

Zend_Form_Element_Reset
-----------------------

Botones Reset son tipicamente usados para limpiar un formulario, y no son parte de la información sometida. Como
sea, como ellos sirven como propósito en el despliegue, son incluidos en los elementos estándar.

``Zend_Form_Element_Reset`` extends :ref:`Zend_Form_Element_Submit <zend.form.standardElements.submit>`. Tal cual,
la etiqueta es usada para desplegar el botón y será traducido si el adaptador traducción esta presente. Se
utiliza sólo los decoradores 'ViewHelper' y 'DtDdWrapper', nunca debería existir mensajes de error para tales
elementos, no se necesitará una etiqueta.

.. _zend.form.standardElements.select:

Zend_Form_Element_Select
------------------------

Cajas selectoras son una manera común de limitar espeficias opciones para un dado formulario datum.
``Zend_Form_Element_Select`` le permite generar esto rápido y fácil.

Por defecto, este elemento registra un validador ``InArray`` el cual valida contra el array de llaves de opciones
registradas. se puede deshabilitar esta caracteristica llamando a ``setRegisterInArrayValidator(false)``, o pasando
un valor ``FALSE`` a la configuracion de llaves ``registerInArrayValidator``. configuration key.

Como se extiende el elemento base Multi, los siguientes métodos pueden ser usados para manipular las opciones
seleccionadas:

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (overwrites existing options)

- getMultiOption($option)

- getMultiOptions()

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

``Zend_Form_Element_Select`` usa la vista ayuda 'formSelect' para decoración.

.. _zend.form.standardElements.submit:

Zend_Form_Element_Submit
------------------------

Submit buttons are used to submit a form. You may use multiple submit buttons; you can use the button used to
submit the form to decide what action to take with the data submitted. ``Zend_Form_Element_Submit`` makes this
decisioning easy, by adding a ``isChecked()`` method; as only one button element will be submitted by the form,
after populating or validating the form, you can call this method on each submit button to determine which one was
used.

``Zend_Form_Element_Submit`` usa la etiqueta como el "valor" del botón sometido, traduciendolo si el adaptador
traducción esta presente. ``isChecked()`` verifica el valor sometido contra la etiqueta en orden to determinar si
el botón ha sido usado.

El :ref:`ViewHelper <zend.form.standardDecorators.viewHelper>` y :ref:`DtDdWrapper
<zend.form.standardDecorators.dtDdWrapper>` decoradores generan al elemento. no decorador de etiquetas es usado,
como el botón etiqueta es usado cuando se generan los elementos; asi tipicamente, no se asociarán errores con el
elemnto sometido.

.. _zend.form.standardElements.text:

Zend_Form_Element_Text
----------------------

Lejos el mas prevaleciente tipo de formulario es el elemento texto, permitido para entrada de texto limitado; es un
elemento ideal para la entrada de la información. ``Zend_Form_Element_Text`` simplemente usa la vista ayuda
'formText' para desplegar el elemento.

.. _zend.form.standardElements.textarea:

Zend_Form_Element_Textarea
--------------------------

Textareas son usadas cuando se espera una larga cantidad de texto y no limites en la cantidad de texto sometido (
otro que el máximo tamaño tomado por su servidor or *PHP*). ``Zend_Form_Element_Textarea`` usa la vista ayuda
'textArea' para desplegar tales elementos, ocupando el valor como el contendio del elemento.


