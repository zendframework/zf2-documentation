.. EN-Revision: none
.. _zend.debug.dumping:

Mostrar información de variables(Dumping Variables)
===================================================

El método estático ``Zend_Debug::dump()`` imprime o devuelve información sobre una expresión. Esta sencilla
técnica de depuración es común, porque es fácil de utilizar en caliente y no requiere inicialización,
herramientas especiales, o la depuración del entorno.

.. _zend.debug.dumping.example:

.. rubric:: Ejemplo del método dump()

.. code-block:: php
   :linenos:

   Zend_Debug::dump($var, $label=null, $echo=true);

El argumento ``$var`` especifica la expresión o variable sobre la cual el método ``Zend_Debug::dump()`` generará
información.

The ``$label`` argument is a string to be prepended to the output of ``Zend_Debug::dump()``. It may be useful, for
example, to use labels if you are dumping information about multiple variables on a given screen.

El argumento boleano ``$echo`` especifica si la salida de ``Zend_Debug::dump()`` es o no mostrada. Si es ``TRUE``,
la salida es mostrada. A pesar del valor del argumento ``$echo``, el retorno de este método contiene la salida.

Puede ser útil comprender que el método ``Zend_Debug::dump()`` envuelve la función de *PHP* `var_dump()`_. Si el
flujo de salida es detectado como una presentación de la web, la salida de ``var_dump()`` es escapada usando
`htmlspecialchars()`_ y envuelta con el tag (X)HTML ``<pre>``.

.. tip::

   **Depurando con Zend_Log**

   Usar ``Zend_Debug::dump()`` es lo mejor para la depuración en caliente durante el desarrollo de software. Puede
   añadir el código para volcar una variable y después quitar el código fácilmente.

   También considere el componente :ref:`Zend_Log <zend.log.overview>` component when writing more permanent
   debugging code. For example, you can use the ``DEBUG`` log level and the :ref:`stream log writer
   <zend.log.writers.stream>` to output the string returned by ``Zend_Debug::dump()``.



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
