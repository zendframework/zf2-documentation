.. EN-Revision: none
.. _zend.validator.writing_validators:

Escribiendo Validadores
=======================

``Zend_Validate`` provee un conjunto de validadores que suelen necesitarse, pero inevitablemente, los
desarrolladores quiere escribir sus propios validadores personalizados para sus necesidades particulares. La tarea
de escribir un validador personalizado se describe en esta sección.

``Zend_Validate_Interface`` define tres métodos, isValid(), getMessages(), y getErrors(), que pueden ser
implementadas por clases de usuario a fin de crear objetos de validación personalizados. Un objeto que implementa
una interfaz ``Zend_Validate_Interface`` puede añadirse a una cadena de validación con
``Zend_Validate::addValidator()``. Tales objetos también pueden ser usados con :ref:`Zend_Filter_Input
<zend.filter.input>`.

De la descripción anterior de ``Zend_Validate_Interface``, podrá inferir que las clases de validación que
proporciona Zend Framework devuelven un valor booleano para cuando un valor se valida satisfactoriamente o no.
También proporcionan información sobre **por qué** un valor falló en la validación. La disponibilidad de las
razones para los fracasos de validación puede ser valiosa para una aplicación por diversos motivos, tales como
proporcionar estadísticas para análisis de usabilidad.

La funcionalidad de los mensajes de validación básica de fallos están implementados en
``Zend_Validate_Abstract``. A fin de incluir esta funcionalidad al crear una clase de validación, simplemente
extienda ``Zend_Validate_Abstract``. En la extensión de la clase deberá aplicar la lógica del método
``isValid()`` y definir las variables y plantillas de mensajes que correspondan a los tipos de fallos de
validación que puedan suceder. Si falla un valor en su test de validación, entonces ``isValid()`` deberá
devolver ``FALSE``. Si el valor pasa su test de validación, entonces ``isValid()`` deberá devolver ``TRUE``.

En general, el método ``isValid()`` no debería arrojar excepciones, salvo que sea imposible determinar si el
valor de entrada es válido o no. Algunos ejemplos de casos razonables para lanzar una excepción podría ser si un
archivo no puede abrirse, que un servidor *LDAP* no pudiera ser contactado, o una conexión a una base de datos no
estuviera disponible. Estos son casos en los que puede ser necesario determinar el éxito o fracaso de la
validación.

.. _zend.validator.writing_validators.example.simple:

.. rubric:: Crear una Clase de Validación sencilla

El siguiente ejemplo demuestra cómo podría escribirse un sencillo validador personalizado. En este caso las
reglas de validación son simplemente que el valor de entrada debe ser de punto flotante.

   .. code-block:: php
      :linenos:

      class MyValid_Float extends Zend_Validate_Abstract
      {
          const FLOAT = 'float';

          protected $_messageTemplates = array(
              self::FLOAT => "'%value%' no es un valor de punto flotante"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              if (!is_float($value)) {
                  $this->_error(self::FLOAT);
                  return false;
              }

              return true;
          }
      }

La clase define una plantilla para su único mensaje de fallo de validación, que incluye el mágico parámetro
**%value%**. La llamada a ``_setValue()`` prepara al objeto para insertar automáticamente en el mensaje de fallo
al valor probado, si éste falla en la validación. La llamada a ``_error()`` sigue las pistas para establecer una
razón por el fracaso de la validación. Dado que esta clase sólo define un mensaje de fallo, no es necesario
darle a ``_error()`` el nombre de la plantilla del mensaje de fallo.

.. _zend.validator.writing_validators.example.conditions.dependent:

.. rubric:: Escribiendo una Clase de Validación habiendo Condiciones Dependientes

El siguiente ejemplo muestra un conjunto de reglas de validación más complejo, donde es necesario que el valor de
entrada ser numérico y dentro del límite de un rango de valores mínimos y máximos. Un valor de entrada podría
fallar en la validación exactamente por una de las siguientes razones:

- El valor de entrada no es numérico.

- El valor de entrada es menor que el valor mínimo permitido.

- El valor de entrada es mayor que el valor máximo permitido.

Estas razones en el fallo de validación, son traducidas a las definiciones en la clase:

.. code-block:: php
   :linenos:

   class MyValid_NumericBetween extends Zend_Validate_Abstract
   {
       const MSG_NUMERIC = 'msgNumeric';
       const MSG_MINIMUM = 'msgMinimum';
       const MSG_MAXIMUM = 'msgMaximum';

       public $minimum = 0;
       public $maximum = 100;

       protected $_messageVariables = array(
           'min' => 'minimum',
           'max' => 'maximum'
       );

       protected $_messageTemplates = array(
           self::MSG_NUMERIC => "'%value%' no es numérico",
           self::MSG_MINIMUM => "'%value%' debe ser al menos '%min%'",
           self::MSG_MAXIMUM => "'%value%' debe ser no mayor a '%max%'"
       );

       public function isValid($value)
       {
           $this->_setValue($value);

           if (!is_numeric($value)) {
               $this->_error(self::MSG_NUMERIC);
               return false;
           }

           if ($value < $this->minimum) {
               $this->_error(self::MSG_MINIMUM);
               return false;
           }

           if ($value > $this->maximum) {
               $this->_error(self::MSG_MAXIMUM);
               return false;
           }

           return true;
       }
   }

Las propiedades públicas ``$minimum`` y ``$maximum`` se han establecido para proporcionar los límites mínimo y
máximo, respectivamente, de un valor a validar. La clase también define dos variables de mensajes que
corresponden a las propiedades públicas y permiten usar ``min`` y ``max`` en plantillas de mensajes como
parámetros mágicos, al igual que con ``value``.

Tenga en cuenta que si cualquiera de las comprobaciones de validación falla en ``isValid()``, ya está preparado
un mensaje apropiado, y el método inmediatamente devuelve ``FALSE``. Estas reglas de validación son por lo tanto
secuencialmente dependientes. Es decir, si uno de los tests falla, no hay necesidad de poner a prueba las
posteriores reglas de validación. Sin embargo, esta necesidad no será el caso. El siguiente ejemplo ilustra cómo
escribir una clase con reglas de validación independientes, donde el objeto validación puede devolver múltiples
razones por las cuales fracasó un intento de validación en particular.

.. _zend.validator.writing_validators.example.conditions.independent:

.. rubric:: Validación con Condiciones Independientes, Múltiples Razones del Fracaso

Considere escribir una clase de validación y control de contraseñas - cuando es necesario que un usuario elija
una contraseña que cumple determinados criterios para ayudar a tener cuentas de usuario seguras. Supongamos que la
seguridad de la contraseña aplica criterios que fuerzan a lo siguiente:

- debe tener al menos una longitud de 8 caracteres,

- contener al menos una letra en mayúscula,

- contener al menos una letra en minúscula,

- contener al menos un dígito.

La siguiente clase implementa estos criterios de validación:

   .. code-block:: php
      :linenos:

      class MyValid_PasswordStrength extends Zend_Validate_Abstract
      {
          const LENGTH = 'length';
          const UPPER  = 'upper';
          const LOWER  = 'lower';
          const DIGIT  = 'digit';

          protected $_messageTemplates = array(
              self::LENGTH => "'%value%' debe tener al menos una longitud de 8 caracteres",
              self::UPPER  => "'%value%' debe contener al menos una letra en mayúscula",
              self::LOWER  => "'%value%' debe contener al menos una letra en minúscula",
              self::DIGIT  => "'%value%' debe contener al menos un dígito"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              $isValid = true;

              if (strlen($value) < 8) {
                  $this->_error(self::LENGTH);
                  $isValid = false;
              }

              if (!preg_match('/[A-Z]/', $value)) {
                  $this->_error(self::UPPER);
                  $isValid = false;
              }

              if (!preg_match('/[a-z]/', $value)) {
                  $this->_error(self::LOWER);
                  $isValid = false;
              }

              if (!preg_match('/\d/', $value)) {
                  $this->_error(self::DIGIT);
                  $isValid = false;
              }

              return $isValid;
          }
      }

Las cuatro pruebas de criterio en ``isValid()`` no devuelven inmediatamente ``FALSE``. Esto permite a la clase de
validación a proporcionar **todas** las razones por las que la contraseña de entrada no cumplió los requisitos
de validación. Si, por ejemplo, un usuario ingresara el string "``#$%``" como contraseña, ``isValid()`` causaría
que los cuatro mensajes de fracaso de validación sean devueltos por un llamado posterior a ``getMessages()``.


