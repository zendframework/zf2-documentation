.. _zend.form.element.monthselect:

Month Select
^^^^^^^^^^^^

``Zend\Form\Element\MonthSelect`` is meant to be paired with the ``Zend\Form\View\Helper\FormMonthSelect``.
This element creates two select elements, where the first one is populated with months and the second is
populated with years. By default, it sets 100 years in the past for the year element, starting with the current year.

.. _zend.form.element.monthselect.usage:

.. rubric:: Basic Usage

.. code-block:: php
    :linenos:

    use Zend\Form\Element;
    use Zend\Form\Form;

    $monthYear = new Element\MonthSelect('monthyear');
    $monthYear->setLabel('Select a month and a year');
    $monthYear->setMinYear(1986);

    $form = new Form('dateselect');
    $form->add($monthYear);

Using the array notation:

.. code-block:: php
    :linenos:

    use Zend\Form\Form;

    $form = new Form('dateselect');
    $form->add(array(
        'type' => 'Zend\Form\Element\MonthSelect',
        'name' => 'monthyear',
        'options' => array(
            'label' => 'Select a month and a year',
            'min_year' => 1986,
        )
    ));

.. _zend.form.element.monthselect.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element <zend.form.element.methods>`.

.. function:: getMonthElement()
   :noindex:

   Returns the Select element that is used for the months part.

   :rtype: ``Zend\Form\Element\Select``

.. function:: getYearElement()
   :noindex:

   Returns the Select element that is used for the years part.

   :rtype: ``Zend\Form\Element\Select``

.. function:: setMonthAttributes(array $monthAttributes)
   :noindex:

   Set attributes on the Select element that is used for the months part.

.. function:: getMonthAttributes()
   :noindex:

   Get attributes on the Select element that is used for the months part.

   :rtype: array

.. function:: setYearAttributes(array $yearAttributes)
   :noindex:

   Set attributes on the Select element that is used for the years part.

.. function:: getYearAttributes()
   :noindex:

   Get attributes on the Select element that is used for the years part.

   :rtype: array

.. function:: setMinYear(int $minYear)
   :noindex:

   Set the minimum year.

.. function:: getMinYear()
   :noindex:

   Get the minimum year.

.. function:: setMaxYear(int $maxYear)
   :noindex:

   Set the maximum year.

.. function:: getMaxYear()
   :noindex:

   Get the maximum year.

.. function:: setValue(mixed $value)
   :noindex:

   Set the value for the MonthSelect element.

   If the value is an instance of ``\DateTime``, it will use the month and year values from that date.
   Otherwise, the value should be an associative array with the ``month`` key for the month value,
   and with the ``year`` key for the year value.
