
Zend\\Form\\Element\\Url
========================

The ``Url`` element is meant to be paired with the ``Zend/Form/View/Helper/FormUrl`` for `HTML5 inputs with type url`_ . This element adds filters and a ``Zend\Validator\Uri`` validator to it's input filter specification for validating HTML5 URL input values on the server.

.. _zend.form.element.url.methods:

Available Methods
-----------------

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element <zend.form.element.methods>` .

.. _zend.form.element.url.methods.get-input-specification:


**getInputSpecification**


    ``getInputSpecification()``


Returns a input filter specification, which includes a ``Zend\Filter\StringTrim`` filter, and a ``Zend\Validator\Uri`` to validate the URI string.

Returns array


.. _`HTML5 inputs with type url`: http://www.whatwg.org/specs/web-apps/current-work/multipage/states-of-the-type-attribute.html#url-state-(type=url)
