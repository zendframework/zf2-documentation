.. EN-Revision: none
.. _zend.validator.introduction:

Introducción
============

Cuando se necesita validar algún tipo de dato, el componente ``Zend_Validate`` ofrece un conjunto de validadores,
como así también un sencillo mecanismo de encadenado de validaciones por el cual múltiples validadores pueden
aplicarse a un dato en un orden definido por el usuario.

.. _zend.validator.introduction.definition:

¿Qué es un validador?
---------------------

Un validador examina su entrada con respecto a algunos requerimientos y produce un resultado booleano si la entrada
valida satisfactoriamente con los requisitos. Si la entrada no cumple los requisitos, un validador también podrá
proporcionar información adicional sobre que requisito(s) no son satisfechos.

Por ejemplo, una aplicación web podría requerir que un usuario ingrese su nombre, de entre seis y doce caracteres
de longitud y que sólo puede contener caracteres alfanuméricos. Se puede usar un validador para asegurar que los
usuarios cumplan estos requisitos. Si el nombre de usuario elegido no cumple con uno o ambos de los requisitos,
sería útil saber cuál de estos requisitos no se cumple.

.. _zend.validator.introduction.using:

Uso básico de validadores
-------------------------

Habiendo definido la validación de esta manera, Zend Framework nos proporciona el fundamento para
``Zend\Validate\Interface`` que define dos métodos, ``isValid()`` y ``getMessages()``. El método ``isValid()``
realiza la validación del valor, devolviendo ``TRUE`` si y sólo si el valor pasa contra el criterio de
validación.

Si ``isValid()`` devuelve ``FALSE``, la función ``getMessages()`` devuelve un array de mensajes explicando el
motivo(s) del fracaso de la validación. Las claves del array son strings cortos que identifican las razones por
las cuales fracasó la validación, y los valores del array son los correspondientes mensajes para ser leídos por
un ser humano. Las claves y los valores son dependientes de la clase; cada clase de validación define su propio
conjunto de mensajes de validación fallidas y las claves únicas que las identifican. Cada clase tiene también
una definición constante que hace corresponder a cada identificador con una causa del fallo de validación.

.. note::

   El método ``getMessages()`` devuelve información del fracaso de la validación sólo para la llamada más
   reciente a ``isValid()``. Cada llamada a ``isValid()`` borra los mensajes y errores causados por una llamada
   anterior ``isValid()``, porque es probable que cada llamada a ``isValid()`` se refiera al valor de una entrada
   diferente.

El siguiente ejemplo ilustra la validación de una dirección de e-mail:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\EmailAddress();

   if ($validator->isValid($email)) {
       // email parece ser válido
   } else {
       // email es inválido; muestre la razones
       foreach ($validator->getMessages() as $messageId => $message) {
           echo "Falla de validación '$messageId': $message\n";
       }
   }

.. _zend.validator.introduction.messages:

Personalizar los mensajes
-------------------------

Para validar las clases se proporciona un método ``setMessage()`` con el que se puede especificar el formato de un
mensaje devuelto por ``getMessages()`` en caso de fallo de validación. El primer argumento de este método es un
string que contiene el mensaje de error. Usted puede incluir tokens en este array que serán sustituidos con datos
relevantes al validador. El token **%value%** es aceptado por todos los validadores, que es sustituido por el valor
que pasó a ``isValid()``. Cada clase de validación, puede dar apoyo a otros tokens en base a cada caso. Por
ejemplo, **%max%** es un token apoyado por ``Zend\Validate\LessThan``. El método ``getMessageVariables()``
devuelve un array de tokens variables aceptados por el validador.

El segundo argumento opcional es un string que identifica la plantilla de mensajes que se establecerá en caso del
fracaso de la validación, lo que es útil cuando una clase de validación define más de una causa para el fallo.
Si omite el segundo argumento, ``setMessage()`` asume que el mensaje que especifique debe ser utilizado por la
plantilla del primer mensaje que declaró en la clase de validación. Muchas clases de validación sólo definen
una plantilla de mensaje de error, así que no hay necesidad de especificar el cambio de plantilla de mensaje.



   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\StringLength(array('min' => 8, 'max' => 12));

      $validator->setMessage(
          'El string \'%value%\' es muy corto; debe tener al menos %min% ' .
          'caracteres',
          Zend\Validate\StringLength::TOO_SHORT);

      if (!$validator->isValid('word')) {
          $messages = $validator->getMessages();
          echo current($messages);

          // "El string 'word' es muy corto; debe tener al menos 8 caracteres"
      }



Puede establecer varios mensajes usando el método ``setMessages()``. Su argumento es un array que contiene pares
de clave/mensaje.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(array('min' => 8, 'max' => 12));

   $validator->setMessages( array(
       Zend\Validate\StringLength::TOO_SHORT =>
           'El string \'%value%\' es muy corto',
       Zend\Validate\StringLength::TOO_LONG  =>
           'El string \'%value%\' es muy largo'
   ));

Incluso, si su aplicación requiere una mayor flexibilidad para informar los fallos de validación, puede acceder a
las propiedades por el mismo nombre, tal como los tokens de mensajes apoyados por una determinada clase de
validación. La propiedad ``value`` siempre está disponible en un validador; es el valor que especificó en el
argumento de ``isValid()``. En cada clase de validación se puede dar apoyo a otras propiedades basándose en el
esquema de caso por caso.

   .. code-block:: php
      :linenos:

      $validator = new Zend\Validate\StringLength(8, 12);

      if (!validator->isValid('word')) {
          echo 'Palabra fallada: '
              . $validator->value
              . '; su longitud no está entre '
              . $validator->min
              . ' y '
              . $validator->max
              . "\n";
      }



.. _zend.validator.introduction.static:

Utilizando el método estático is()
----------------------------------

Si es inconveniente cargar una clase de validación y crear una instancia del validador, puede usar el método
estático ``Zend\Validate\Validate::is()`` como un estilo alternativo de invocación. El primer argumento de este método es
el valor de una entrada de datos que usted pasaría al método ``isValid()``. El segundo argumento es un string,
que corresponde al nombre base de la clase de validación, relativo al nombre de espacio ``Zend_Validate``. El
método ``is()`` carga automáticamente la clase, crea una instancia y aplica el método ``isValid()`` a la entrada
de datos.

   .. code-block:: php
      :linenos:

      if (Zend\Validate\Validate::is($email, 'EmailAddress')) {
          // Si, el email parece ser válido
      }



Si el validador lo necesita, también puede pasar un array de constructores de argumentos.

   .. code-block:: php
      :linenos:

      if (Zend\Validate\Validate::is($value, 'Between', array('min' => 1, 'max' => 12))) {
          // Si, $value está entre 1 y 12
      }



El método ``is()`` devuelve un valor booleano, lo mismo que el método ``isValid()``. Cuando se utiliza el método
estático ``is()``, no están disponibles los mensajes de fracaso de validación.

El uso estático puede ser conveniente para invocar un validador ad-hoc (hecho especialmente), pero si tiene la
necesidad de ejecutar el validador para múltiples entradas, es más eficiente usar métodos no estáticos, creando
una instancia del objeto validador y llamando a su método ``isValid()``.

También la clase ``Zend\Filter\Input`` le permite crear ejemplos y ejecutar múltiples filtros y clases de
validadores por demanda, para procesar juegos de datos de entrada. Ver :ref:` <zend.filter.input>`.

.. _zend.validator.introduction.static.namespaces:

Namespaces
^^^^^^^^^^

When working with self defined validators you can give a forth parameter to ``Zend\Validate\Validate::is()`` which is the
namespace where your validator can be found.

.. code-block:: php
   :linenos:

   if (Zend\Validate\Validate::is($value, 'MyValidator', array('min' => 1, 'max' => 12),
                         array('FirstNamespace', 'SecondNamespace')) {
       // Yes, $value is ok
   }

``Zend_Validate`` allows also to set namespaces as default. This means that you can set them once in your bootstrap
and have not to give them again for each call of ``Zend\Validate\Validate::is()``. The following code snippet is identical
to the above one.

.. code-block:: php
   :linenos:

   Zend\Validate\Validate::setDefaultNamespaces(array('FirstNamespace', 'SecondNamespace'));
   if (Zend\Validate\Validate::is($value, 'MyValidator', array('min' => 1, 'max' => 12)) {
       // Yes, $value is ok
   }

   if (Zend\Validate\Validate::is($value, 'OtherValidator', array('min' => 1, 'max' => 12)) {
       // Yes, $value is ok
   }

For your convenience there are following methods which allow the handling of namespaces:

- **Zend\Validate\Validate::getDefaultNamespaces()**: Returns all set default namespaces as array.

- **Zend\Validate\Validate::setDefaultNamespaces()**: Sets new default namespaces and overrides any previous set. It accepts
  either a string for a single namespace of an array for multiple namespaces.

- **Zend\Validate\Validate::addDefaultNamespaces()**: Adds additional namespaces to already set ones. It accepts either a
  string for a single namespace of an array for multiple namespaces.

- **Zend\Validate\Validate::hasDefaultNamespaces()**: Returns ``TRUE`` when one or more default namespaces are set, and
  ``FALSE`` when no default namespaces are set.

.. _zend.validator.introduction.translation:

Translating messages
--------------------

Validate classes provide a ``setTranslator()`` method with which you can specify a instance of ``Zend_Translator``
which will translate the messages in case of a validation failure. The ``getTranslator()`` method returns the set
translator instance.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(array('min' => 8, 'max' => 12));
   $translate = new Zend\Translator\Translator(
       'array',
       array(Zend\Validate\StringLength::TOO_SHORT => 'Translated \'%value%\''),
       'en'
   );

   $validator->setTranslator($translate);

With the static ``setDefaultTranslator()`` method you can set a instance of ``Zend_Translator`` which will be used
for all validation classes, and can be retrieved with ``getDefaultTranslator()``. This prevents you from setting a
translator manually for all validator classes, and simplifies your code.

.. code-block:: php
   :linenos:

   $translate = new Zend\Translator\Translator(
       'array',
       array(Zend\Validate\StringLength::TOO_SHORT => 'Translated \'%value%\''),
       'en'
   );
   Zend\Validate\Validate::setDefaultTranslator($translate);

.. note::

   When you have set an application wide locale within your registry, then this locale will be used as default
   translator.

Sometimes it is necessary to disable the translator within a validator. To archive this you can use the
``setDisableTranslator()`` method, which accepts a boolean parameter, and ``isTranslatorDisabled()`` to get the set
value.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(array('min' => 8, 'max' => 12));
   if (!$validator->isTranslatorDisabled()) {
       $validator->setDisableTranslator();
   }

It is also possible to use a translator instead of setting own messages with ``setMessage()``. But doing so, you
should keep in mind, that the translator works also on messages you set your own.


