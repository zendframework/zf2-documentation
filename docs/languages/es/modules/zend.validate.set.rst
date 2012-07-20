.. _zend.validate.set:

Clases de Validación Estándar
=============================

Zend Framework viene con un conjunto estándar de clases de validación listas para usar.

.. _zend.validate.set.alnum:

Alnum
-----

Devuelve ``TRUE`` si y sólo si ``$valor`` contiene caracteres alfanuméricos únicamente. Este validador incluye
una opción para considerar también al espacio en blanco como caracter válido.

.. note::

   Los caracteres alfabéticos significan caracteres que componen palabras en cada idioma. Sin embargo, el alfabeto
   inglés es tratado como caracteres alfabéticos en los siguientes idiomas: chino, japonés, coreano. El lenguaje
   es especificado por Zend_Locale.

.. _zend.validate.set.alpha:

Alpha
-----

Devuelve ``TRUE`` si y sólo si ``$valor`` sólo contiene caracteres alfabéticos. Este validador incluye una
opción para considerar también al espacio en blanco como caracter válido.

.. include:: zend.validate.barcode.rst
.. _zend.validate.set.between:

Between
-------

Devuelve ``TRUE`` si y sólo si ``$valor`` está entre los valores límites mínimo y máximo. La comparación es
inclusiva por defecto (``$valor`` puede ser igual a una valor límite), aunque esto puede ser anulado a fin de
hacer una comparación estricta, donde ``$valor`` debe ser estrictamente mayor al mínimo y estrictamente menor al
máximo.

.. include:: zend.validate.callback.rst
.. include:: zend.validate.credit-card.rst
.. _zend.validate.set.ccnum:

Ccnum
-----

Devuelve ``TRUE`` si y sólo si ``$valor`` sigue el algoritmo Luhn (mod-10 checksum) para tarjetas de crédito.

.. note::

   The ``Ccnum`` validator has been deprecated in favor of the ``CreditCard`` validator. For security reasons you
   should use CreditCard instead of Ccnum.

.. _zend.validate.set.date:

Date
----

Devuelve ``TRUE`` si y sólo si ``$valor`` es una fecha válida en el formato ``YYYY-MM-DD`` (AAAA-MM-DD). Si se
usa la opción ``locale`` entonces la fecha será validada de acuerdo a lo establecido para ese locale. Además, si
se establece la opción ``format`` ese formato se utiliza para la validación. Para más detalles acerca de los
parámetros opcionales ver en: :ref:`Zend_Date::isDate() <zend.date.others.comparison.table>`.

.. include:: zend.validate.db.rst
.. _zend.validate.set.digits:

Digits
------

Devuelve ``TRUE`` si y sólo si ``$valor`` contiene solamente dígitos.

.. include:: zend.validate.email-address.rst
.. _zend.validate.set.float:

Float
-----

Devuelve ``TRUE`` si y sólo si ``$value`` es un valor de punto flotante. Desde Zend Framework 1.8 toma en cuenta
la localizacion actual del navegador, las variables o el uso. Puede usar get/setLocale para cambiar la
configuracion regional o crear una instancia para este validador

.. _zend.validate.set.greater_than:

GreaterThan
-----------

Devuelve ``TRUE`` si y sólo si ``$valor`` es mayor al límite mínimo.

.. _zend.validate.set.hex:

Hex
---

Devuelve ``TRUE`` si y sólo si ``$valor`` contiene caracteres hexadecimales (0-9 y A-F).

.. include:: zend.validate.hostname.rst
.. _zend.validate.set.iban:

Iban
----

Returns ``TRUE`` if and only if ``$value`` contains a valid IBAN (International Bank Account Number). IBAN numbers
are validated against the country where they are used and by a checksum.

There are two ways to validate IBAN numbers. As first way you can give a locale which represents a country. Any
given IBAN number will then be validated against this country.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Iban('de_AT');
   $iban = 'AT611904300234573201';
   if ($validator->isValid($iban)) {
       // IBAN appears to be valid
   } else {
       // IBAN is invalid
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

This should be done when you want to validate IBAN numbers for a single countries. The simpler way of validation is
not to give a locale like shown in the next example.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Iban();
   $iban = 'AT611904300234573201';
   if ($validator->isValid($iban)) {
       // IBAN appears to be valid
   } else {
       // IBAN is invalid
   }

But this shows one big problem: When you have to accept only IBAN numbers from one single country, for example
france, then IBAN numbers from other countries would also be valid. Therefor just remember: When you have to
validate a IBAN number against a defined country you should give the locale. And when you accept all IBAN numbers
regardless of any country omit the locale for simplicity.

.. _zend.validate.set.in_array:

InArray
-------

Devuelve ``TRUE`` si y sólo si ``$valor`` se encuentra en un array, y si la opción es estricta entonces también
verificará el tipo de dato de ``$valor``.

.. include:: zend.validate.identical.rst
.. include:: zend.validate.in-array.rst
.. _zend.validate.set.int:

Int
---

Returns ``TRUE`` if and only if ``$value`` is a valid integer. Since Zend Framework 1.8 this validator takes into
account the actual locale from browser, environment or application wide set locale. You can of course use the
get/setLocale accessors to change the used locale or give it while creating a instance of this validator.

.. include:: zend.validate.ip.rst
.. include:: zend.validate.isbn.rst
.. _zend.validate.set.less_than:

LessThan
--------

Devuelve ``TRUE`` si y sólo si ``$valor`` es menor al límite máximo.

.. include:: zend.validate.not-empty.rst
.. include:: zend.validate.post-code.rst
.. _zend.validate.set.regex:

Regex
-----

Devuelve ``TRUE`` si y sólo si ``$valor`` coincide con el patrón de una expresión regular.

.. include:: zend.validate.sitemap.rst
.. _zend.validate.set.string_length:

StringLength
------------

Devuelve ``TRUE`` si y sólo si la longitud del string ``$valor`` es por lo menos un mínimo y no mayor a un
máximo (cuando la opción max no es ``NULL``). Desde la versión 1.5.0, el método ``setMin()`` lanza una
excepción si la longitud mínima tiene un valor mayor que la longitud máxima establecida, y el método
``setMax()`` lanza una excepción si la longitud máxima se fija a un valor inferior que la longitud mínima
establecida. Desde la versión 1.0.2, esta clase soporta UTF-8 y a otras codificaciones, basado en el valor actual
de: `iconv.internal_encoding`_. If you need a different encoding you can set it with the accessor methods
getEncoding and setEncoding.



.. _`iconv.internal_encoding`: http://www.php.net/manual/en/ref.iconv.php#iconv.configuration
