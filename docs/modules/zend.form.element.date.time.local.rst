
Zend\\Form\\Element\\DateTimeLocal
==================================

The ``DateTimeLocal`` element is meant to be paired with the ``Zend/Form/View/Helper/FormDateTimeLocal`` for `HTML5 inputs with type datetime-local`_ . This element adds filters and validators to it's input filter specification in order to validate HTML5 a local datetime input values on the server.

.. _zend.form.element.date-time-local.methods:

Available Methods
-----------------

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element\\DateTime <zend.form.element.date-time.methods>` .

.. _zend.form.element.date-time-local.methods.get-input-specification:


**getInputSpecification**


    ``getInputSpecification()``


Returns a input filter specification, which includes ``Zend\Filter\StringTrim`` and will add the appropriate validators based on the values from the ``min`` , ``max`` , and ``step`` attributes. See :ref:`getInputSpecification in Zend\\Form\\Element\\DateTime <zend.form.element.date-time.methods.get-input-specification>` for more information.

Returns array


.. _`HTML5 inputs with type datetime-local`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#local-date-and-time-state-(type=datetime-local)
