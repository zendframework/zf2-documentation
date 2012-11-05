.. _zend.debug.dumping:

Dumping Variables
=================

The static method ``Zend\Debug\Debug::dump()`` prints or returns information about an expression. This simple technique
of debugging is common because it is easy to use in an ad hoc fashion and requires no initialization, special
tools, or debugging environment.

.. _zend.debug.dumping.example:

.. rubric:: Example of dump() method

.. code-block:: php
   :linenos:

   Zend\Debug\Debug::dump($var, $label = null, $echo = true);

The ``$var`` argument specifies the expression or variable about which the ``Zend\Debug\Debug::dump()`` method outputs
information.

The ``$label`` argument is a string to be prepended to the output of ``Zend\Debug\Debug::dump()``. It may be useful, for
example, to use labels if you are dumping information about multiple variables on a given screen.

The boolean ``$echo`` argument specifies whether the output of ``Zend\Debug\Debug::dump()`` is echoed or not. If
``TRUE``, the output is echoed. Regardless of the value of the ``$echo`` argument, the return value of this method
contains the output.

It may be helpful to understand that ``Zend\Debug\Debug::dump()`` method wraps the *PHP* function `var_dump()`_. If the
output stream is detected as a web presentation, the output of ``var_dump()`` is escaped using
`htmlspecialchars()`_ and wrapped with (X)HTML ``<pre>`` tags.

.. tip::

   **Debugging with Zend\Log**

   Using ``Zend\Debug\Debug::dump()`` is best for ad hoc debugging during software development. You can add code to dump
   a variable and then remove the code very quickly.

   Also consider the :ref:`Zend\Log <zend.log.overview>` component when writing more permanent debugging code. For
   example, you can use the ``DEBUG`` log level and the :ref:`stream log writer <zend.log.writers.stream>` to
   output the string returned by ``Zend\Debug\Debug::dump()``.



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
