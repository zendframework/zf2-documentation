.. _zend.form.element.month.select:

MonthSelect Element
------------

Sometimes, an input text like HTML5 date elements, or even a JavaScript calendar, is not the most user-friendly way to enter dates. Often, simple selects is much more intuitive. ``Zend\Form\Element\MonthSelect`` is meant to be paired with the ``Zend/Form/View/Helper/FormMonthSelect``. This element internally manages two selects (one for month and one for year). This element adds validators to its input filter in order to validate the date on the server, and a filter to simply get back a string representing the date (instead of two integers).

Please note that what you get back from this element is a string containing the date in the standard format "Y-m" (2012-05 for instance). You can of course convert it to a DateTime object in your domain object, or during hydration.

.. _zend.form.element.month.select.usage:

Basic Usage
^^^^^^^^^^^

This element automatically renders the date using two selects.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $date = new Element\DateSelect(‘date-begin);
   $date
       ->setLabel(‘When did you begin your job ?’)
       ->setMinYear(1970)
       ->setMaxYear(2012);

   $form = new Form('my-form');
   $form->add($date);

.. _zend.form.element.month.select.methods:

Public Methods
^^^^^^^^^^^^^^

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element\\DateSelect
<zend.form.element.date.select.methods>`.

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes ``Zend\Filter\Callback`` (that converts the three selects value to a standard string with format « Y-m ».
   
   Returns array
