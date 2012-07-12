
Zend\\Form\\Element\\Week
=========================

The ``Week`` element is meant to be paired with the ``Zend/Form/View/Helper/FormWeek`` for `HTML5 inputs with type week`_ . This element adds filters and validators to it's input filter specification in order to validate HTML5 week input values on the server.

.. _zend.form.element.week.methods:

Available Methods
-----------------

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element\\DateTime <zend.form.element.date-time.methods>` .

.. _zend.form.element.week.methods.get-input-specification:


**getInputSpecification**


    ``getInputSpecification()``


Returns a input filter specification, which includes ``Zend\Filter\StringTrim`` and will add the appropriate validators based on the values from the ``min`` , ``max`` , and ``step`` attributes. See :ref:`getInputSpecification in Zend\\Form\\Element\\DateTime <zend.form.element.date-time.methods.get-input-specification>` for more information.

One difference from ``Zend\Form\Element\DateTime`` is that the ``Zend\Validator\DateStep`` validator will expect the ``step`` attribute to use an interval of weeks (default is 1 week).

Returns array


.. _`HTML5 inputs with type week`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#week-state-(type=week)
