.. EN-Revision: none
.. _zend.validator.validator_chains:

Cadenas de Validadores
======================

Frecuentemente deben aplicarse múltiples validaciones a algún valor en un orden particular. El siguiente código
demuestra una forma de resolver el ejemplo de la :ref:`introducción <zend.validator.introduction>`, donde el nombre
de usuario debe tener entre 6 y 12 caracteres alfanuméricos.

.. code-block:: php
   :linenos:

   // Crea una cadena de validadores y le agrega validadores
   $validatorChain = new Zend_Validate();
   $validatorChain->addValidator(
                       new Zend_Validate_StringLength(array('min' => 6,
                                                            'max' => 12)))
                  ->addValidator(new Zend_Validate_Alnum());

   // Valida el username
   if ($validatorChain->isValid($username)) {
       // username pasó la validación
   } else {
       // username falló en la validación; muestre las razones
       foreach ($validatorChain->getMessages() as $message) {
           echo "$message\n";
       }
   }

Los validadores se ejecutan en el orden en que se agregaron a ``Zend_Validate``. En el ejemplo anterior, el nombre
de usuario, primero se comprueba que su longitud esté entre 6 y 12 caracteres y luego se controla para garantizar
que sólo contiene caracteres alfanuméricos. La segunda validación; de caracteres alfanuméricos; se realiza
independientemente de que la primera validación; de longitud entre 6 y 12 caracteres; tenga éxito. Esto significa
que si ambas validaciones fallan, ``getMessages()`` devolverá mensajes de fracaso desde ambos validadores.

En algunos casos tiene sentido detener la cadena de validación si falla alguno de los procesos de validación.
``Zend_Validate`` acepta tales casos pasando como segundo parámetro el método ``addValidator()``. Poniendo
``$breakChainOnFailure`` a ``TRUE``, el validador agregado quebrará la cadena de ejecución por el fracaso, que
evita correr cualquier otra validación que se decida que es innecesaria o inapropiada para la situación. Si el
ejemplo anterior fue escrito como sigue, entonces el sistema de validación alfanumérica no se ejecutará si falla
la longitud del string de validación:

.. code-block:: php
   :linenos:

   $validatorChain->addValidator(
                       new Zend_Validate_StringLength(array('min' => 6,
                                                            'max' => 12)),
                       true)
                  ->addValidator(new Zend_Validate_Alnum());

Cualquier objeto que implemente ``Zend_Validate_Interface`` puede ser utilizado en una cadena de validación.


