.. _learning.form.decorators.composite:

Creating and Rendering Composite Elements
=========================================

In :ref:`the last section <learning.form.decorators.individual>`, we had an example showing a "date of birth
element":

.. code-block:: php
   :linenos:

   <div class="element">
       <?php echo $form->dateOfBirth->renderLabel() ?>
       <?php echo $this->formText('dateOfBirth[day]', '', array(
           'size' => 2, 'maxlength' => 2)) ?>
       /
       <?php echo $this->formText('dateOfBirth[month]', '', array(
           'size' => 2, 'maxlength' => 2)) ?>
       /
       <?php echo $this->formText('dateOfBirth[year]', '', array(
           'size' => 4, 'maxlength' => 4)) ?>
   </div>

How might you represent this element as a ``Zend_Form_Element``? How might you write a decorator to render it?

.. _learning.form.decorators.composite.element:

The Element
-----------

The questions about how the element would work include:

- How would you set and retrieve the value?

- How would you validate the value?

- Regardless, how would you then allow for discrete form inputs for the three segments (day, month, year)?

The first two questions center around the form element itself: how would ``setValue()`` and ``getValue()`` work?
There's actually another question implied by the question about the decorator: how would you retrieve the discrete
date segments from the element and/or set them?

The solution is to override the ``setValue()`` method of your element to provide some custom logic. In this
particular case, our element should have three discrete behaviors:

- If an integer timestamp is provided, it should be used to determine and store the day, month, and year.

- If a textual string is provided, it should be cast to a timestamp, and then that value used to determine and
  store the day, month, and year.

- If an array containing keys for date, month, and year is provided, those values should be stored.

Internally, the day, month, and year will be stored discretely. When the value of the element is retrieved, it will
be done so in a normalized string format. We'll override ``getValue()`` as well to assemble the discrete date
segments into a final string.

Here's what the class would look like:

.. code-block:: php
   :linenos:

   class My_Form_Element_Date extends Zend_Form_Element_Xhtml
   {
       protected $_dateFormat = '%year%-%month%-%day%';
       protected $_day;
       protected $_month;
       protected $_year;

       public function setDay($value)
       {
           $this->_day = (int) $value;
           return $this;
       }

       public function getDay()
       {
           return $this->_day;
       }

       public function setMonth($value)
       {
           $this->_month = (int) $value;
           return $this;
       }

       public function getMonth()
       {
           return $this->_month;
       }

       public function setYear($value)
       {
           $this->_year = (int) $value;
           return $this;
       }

       public function getYear()
       {
           return $this->_year;
       }

       public function setValue($value)
       {
           if (is_int($value)) {
               $this->setDay(date('d', $value))
                    ->setMonth(date('m', $value))
                    ->setYear(date('Y', $value));
           } elseif (is_string($value)) {
               $date = strtotime($value);
               $this->setDay(date('d', $date))
                    ->setMonth(date('m', $date))
                    ->setYear(date('Y', $date));
           } elseif (is_array($value)
                     && (isset($value['day'])
                         && isset($value['month'])
                         && isset($value['year'])
                     )
           ) {
               $this->setDay($value['day'])
                    ->setMonth($value['month'])
                    ->setYear($value['year']);
           } else {
               throw new Exception('Invalid date value provided');
           }

           return $this;
       }

       public function getValue()
       {
           return str_replace(
               array('%year%', '%month%', '%day%'),
               array($this->getYear(), $this->getMonth(), $this->getDay()),
               $this->_dateFormat
           );
       }
   }

This class gives some nice flexibility -- we can set default values from our database, and be certain that the
value will be stored and represented correctly. Additionally, we can allow for the value to be set from an array
passed via form input. Finally, we have discrete accessors for each date segment, which we can now use in a
decorator to create a composite element.

.. _learning.form.decorators.composite.decorator:

The Decorator
-------------

Revisiting the example from the last section, let's assume that we want users to input each of the year, month, and
day separately. *PHP* fortunately allows us to use array notation when creating elements, so it's still possible to
capture these three entities into a single value -- and we've now created a ``Zend_Form`` element that can handle
such an array value.

The decorator is relatively simple: it will grab the day, month, and year from the element, and pass each to a
discrete view helper to render individual form inputs; these will then be aggregated to form the final markup.

.. code-block:: php
   :linenos:

   class My_Form_Decorator_Date extends Zend_Form_Decorator_Abstract
   {
       public function render($content)
       {
           $element = $this->getElement();
           if (!$element instanceof My_Form_Element_Date) {
               // only want to render Date elements
               return $content;
           }

           $view = $element->getView();
           if (!$view instanceof Zend_View_Interface) {
               // using view helpers, so do nothing if no view present
               return $content;
           }

           $day   = $element->getDay();
           $month = $element->getMonth();
           $year  = $element->getYear();
           $name  = $element->getFullyQualifiedName();

           $params = array(
               'size'      => 2,
               'maxlength' => 2,
           );
           $yearParams = array(
               'size'      => 4,
               'maxlength' => 4,
           );

           $markup = $view->formText($name . '[day]', $day, $params)
                   . ' / ' . $view->formText($name . '[month]', $month, $params)
                   . ' / ' . $view->formText($name . '[year]', $year, $yearParams);

           switch ($this->getPlacement()) {
               case self::PREPEND:
                   return $markup . $this->getSeparator() . $content;
               case self::APPEND:
               default:
                   return $content . $this->getSeparator() . $markup;
           }
       }
   }

We now have to do a minor tweak to our form element, and tell it that we want to use the above decorator as a
default. That takes two steps. First, we need to inform the element of the decorator path. We can do that in the
constructor:

.. code-block:: php
   :linenos:

   class My_Form_Element_Date extends Zend_Form_Element_Xhtml
   {
       // ...

       public function __construct($spec, $options = null)
       {
           $this->addPrefixPath(
               'My_Form_Decorator',
               'My/Form/Decorator',
               'decorator'
           );
           parent::__construct($spec, $options);
       }

       // ...
   }

Note that this is being done in the constructor and not in ``init()``. This is for two reasons. First, it allows
extending the element later to add logic in ``init`` without needing to worry about calling ``parent::init()``.
Second, it allows passing additional plugin paths via configuration or within an ``init`` method that will then
allow overriding the default ``Date`` decorator with my own replacement.

Next, we need to override the ``loadDefaultDecorators()`` method to use our new ``Date`` decorator:

.. code-block:: php
   :linenos:

   class My_Form_Element_Date extends Zend_Form_Element_Xhtml
   {
       // ...

       public function loadDefaultDecorators()
       {
           if ($this->loadDefaultDecoratorsIsDisabled()) {
               return;
           }

           $decorators = $this->getDecorators();
           if (empty($decorators)) {
               $this->addDecorator('Date')
                    ->addDecorator('Errors')
                    ->addDecorator('Description', array(
                        'tag'   => 'p',
                        'class' => 'description'
                    ))
                    ->addDecorator('HtmlTag', array(
                        'tag' => 'dd',
                        'id'  => $this->getName() . '-element'
                    ))
                    ->addDecorator('Label', array('tag' => 'dt'));
           }
       }

       // ...
   }

What does the final output look like? Let's consider the following element:

.. code-block:: php
   :linenos:

   $d = new My_Form_Element_Date('dateOfBirth');
   $d->setLabel('Date of Birth: ')
     ->setView(new Zend_View());

   // These are equivalent:
   $d->setValue('20 April 2009');
   $d->setValue(array('year' => '2009', 'month' => '04', 'day' => '20'));

If you then echo this element, you get the following markup (with some slight whitespace modifications for
readability):

.. code-block:: html
   :linenos:

   <dt id="dateOfBirth-label"><label for="dateOfBirth" class="optional">
       Date of Birth:
   </label></dt>
   <dd id="dateOfBirth-element">
       <input type="text" name="dateOfBirth[day]" id="dateOfBirth-day"
           value="20" size="2" maxlength="2"> /
       <input type="text" name="dateOfBirth[month]" id="dateOfBirth-month"
           value="4" size="2" maxlength="2"> /
       <input type="text" name="dateOfBirth[year]" id="dateOfBirth-year"
           value="2009" size="4" maxlength="4">
   </dd>

.. _learning.form.decorators.composite.conclusion:

Conclusion
----------

We now have an element that can render multiple related form input fields, and then handle the aggregated fields as
a single entity -- the ``dateOfBirth`` element will be passed as an array to the element, and the element will
then, as we noted earlier, create the appropriate date segments and return a value we can use for most backends.

In the end, you get a uniform element *API* you can use to describe an element representing a composite value.


