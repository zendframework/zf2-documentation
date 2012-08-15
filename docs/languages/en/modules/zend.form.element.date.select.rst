.. _zend.form.element.date.select:

DateSelect Element
------------

Sometimes, an input text like HTML5 date elements, or even a JavaScript calendar, is not the most user-friendly way to enter dates. Often, simple selects is much more intuitive. ``Zend\Form\Element\DateSelect`` is meant to be paired with the ``Zend/Form/View/Helper/FormDateSelect``. This element internally manages three selects (one for day, one for month and one for year). This element adds validators to its input filter in order to validate the date on the server, and a filter to simply get back a string representing the date (instead of three integers).

Please note that what you get back from this element is a string containing the date in the standard format "Y-m-d" (2012-05-06 for instance). You can of course convert it to a DateTime object in your domain object, or during hydration.

.. _zend.form.element.date.select.usage:

Basic Usage
^^^^^^^^^^^

This element automatically renders the date using three selects.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $date = new Element\DateSelect(‘birth-date');
   $date
       ->setLabel(‘Birth date’)
       ->setMinYear(1932)
       ->setMaxYear(2012);

   $form = new Form('my-form');
   $form->add($date);

.. _zend.form.element.date.select.methods:

Public Methods
^^^^^^^^^^^^^^

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element
<zend.form.element.methods>`.

.. function:: setOptions(array $options)
   :noindex:

   Set options for an element of type DateSelect. Accepted options, in addition to the inherited options of Zend\\Form\\Element <zend.form.element.methods.set-options>` , are: ``"min_year"``, `` "max_year"`` which call ``setMinYear``, and ``setMaxYear``, respectively.
   
.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes ``Zend\Filter\Callback`` (that converts the three selects value to a standard string with format « Y-m-d ».
   
   Returns array
   
.. function:: setMinYear($minYear)
   :noindex:

   Allows to set the min year that will be used in the select. This one must be inferior to maxYear.
   
.. function:: getMinYear()
   :noindex:

   Returns the min year that is used in the select for years.
   
.. function:: setMaxYear($maxYear)
   :noindex:

   Allows to set the max year that will be used in the select. This one must be superior to minYear.
   
.. function:: getMaxYear()
   :noindex:

   Returns the max year that is used in the select for years.
   

