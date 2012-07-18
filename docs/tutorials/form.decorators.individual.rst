.. _learning.form.decorators.individual:

Rendering Individual Decorators
===============================

In the :ref:`previous section <learning.form.decorators.layering>`, we looked at how you can combine decorators to
create complex output. We noted that while you have a ton of flexibility with this approach, it also adds some
complexity and overhead. In this section, we will examine how to render decorators individually in order to create
custom markup for forms and/or individual elements.

Once you have registered your decorators, you can later retrieve them by name from the element. Let's review the
previous example:

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'prefixPath' => array('decorator' => array(
           'My_Decorator' => 'path/to/decorators/',
       )),
       'decorators' => array(
           'SimpleInput'
           array('SimpleLabel', array('placement' => 'append')),
       ),
   ));

If we wanted to pull and render just the ``SimpleInput`` decorator, we can do so using the ``getDecorator()``
method:

.. code-block:: php
   :linenos:

   $decorator = $element->getDecorator('SimpleInput');
   echo $decorator->render('');

This is pretty easy, but it can be made even easier; let's do it in a single line:

.. code-block:: php
   :linenos:

   echo $element->getDecorator('SimpleInput')->render('');

Not too bad, but still a little complex. To make this easier, a shorthand notation was introduced into
``Zend_Form`` in 1.7: you can render any registered decorator by calling a method of the format
``renderDecoratorName()``. This will effectively perform what you see above, but makes the ``$content`` argument
optional and simplifies the usage:

.. code-block:: php
   :linenos:

   echo $element->renderSimpleInput();

This is a neat trick, but how and why would you use it?

Many developers and designers have very precise markup needs for their forms. They would rather have full control
over the output than rely on a more automated solution which may or may not conform to their design. In other
cases, the form layout may require a lot of specialized markup -- grouping arbitrary elements, making some
invisible unless a particular link is selected, etc.

Let's utilize the ability to render individual decorators to create some specialized markup.

First, let's define a form. Our form will capture a user's demographic details. The markup will be highly
customized, and in some cases use view helpers directly instead of form elements in order to achieve its goals.
Here is the basic form definition:

.. code-block:: php
   :linenos:

   class My_Form_UserDemographics extends Zend_Form
   {
       public function init()
       {
           // Add a path for my own decorators
           $this->addElementPrefixPaths(array(
               'decorator' => array('My_Decorator' => 'My/Decorator'),
           ));

           $this->addElement('text', 'firstName', array(
               'label' => 'First name: ',
           ));
           $this->addElement('text', 'lastName', array(
               'label' => 'Last name: ',
           ));
           $this->addElement('text', 'title', array(
               'label' => 'Title: ',
           ));
           $this->addElement('text', 'dateOfBirth', array(
               'label' => 'Date of Birth (DD/MM/YYYY): ',
           ));
           $this->addElement('text', 'email', array(
               'label' => 'Your email address: ',
           ));
           $this->addElement('password', 'password', array(
               'label' => 'Password: ',
           ));
           $this->addElement('password', 'passwordConfirmation', array(
               'label' => 'Confirm Password: ',
           ));
       }
   }

.. note::

   We're not defining any validators or filters at this time, as they are not relevant to the discussion of
   decoration. In a real-world scenario, you should define them.

With that out of the way, let's consider how we might want to display this form. One common idiom with first/last
names is to display them on a single line; when a title is provided, that is often on the same line as well. Dates,
when not using a JavaScript date chooser, will often be separated into three fields displayed side by side.

Let's use the ability to render an element's decorators one by one to accomplish this. First, let's note that no
explicit decorators were defined for the given elements. As a refresher, the default decorators for (most) elements
are:

- ``ViewHelper``: utilize a view helper to render a form input

- ``Errors``: utilize the ``FormErrors`` view helper to render validation errors

- ``Description``: utilize the ``FormNote`` view helper to render the element description (if any)

- ``HtmlTag``: wrap the above three items in a **<dd>** tag

- ``Label``: render the element label using the ``FormLabel`` view helper (and wrap it in a **<dt>** tag)

Also, as a refresher, you can access any element of a form as if it were a class property; simply reference the
element by the name you assigned it.

Our view script might then look like this:

.. code-block:: php
   :linenos:

   <?php
   $form = $this->form;
   // Remove <dt> from label generation
   foreach ($form->getElements() as $element) {
       $element->getDecorator('label')->setOption('tag', null);
   }
   ?>
   <form method="<?php echo $form->getMethod() ?>" action="<?php echo
       $form->getAction()?>">
       <div class="element">
           <?php echo $form->title->renderLabel()
                 . $form->title->renderViewHelper() ?>
           <?php echo $form->firstName->renderLabel()
                 . $form->firstName->renderViewHelper() ?>
           <?php echo $form->lastName->renderLabel()
                 . $form->lastName->renderViewHelper() ?>
       </div>
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
       <div class="element">
           <?php echo $form->password->renderLabel()
                 . $form->password->renderViewHelper() ?>
       </div>
       <div class="element">
           <?php echo $form->passwordConfirmation->renderLabel()
                 . $form->passwordConfirmation->renderViewHelper() ?>
       </div>
       <?php echo $this->formSubmit('submit', 'Save') ?>
   </form>

If you use the above view script, you'll get approximately the following *HTML* (approximate, as the *HTML* below
is formatted):

.. code-block:: html
   :linenos:

   <form method="post" action="">
       <div class="element">
           <label for="title" tag="" class="optional">Title:</label>
           <input type="text" name="title" id="title" value=""/>

           <label for="firstName" tag="" class="optional">First name:</label>
           <input type="text" name="firstName" id="firstName" value=""/>

           <label for="lastName" tag="" class="optional">Last name:</label>
           <input type="text" name="lastName" id="lastName" value=""/>
       </div>

       <div class="element">
           <label for="dateOfBirth" tag="" class="optional">Date of Birth
               (DD/MM/YYYY):</label>
           <input type="text" name="dateOfBirth[day]" id="dateOfBirth-day"
               value="" size="2" maxlength="2"/>
           /
           <input type="text" name="dateOfBirth[month]" id="dateOfBirth-month"
               value="" size="2" maxlength="2"/>
           /
           <input type="text" name="dateOfBirth[year]" id="dateOfBirth-year"
               value="" size="4" maxlength="4"/>
       </div>

       <div class="element">
           <label for="password" tag="" class="optional">Password:</label>
           <input type="password" name="password" id="password" value=""/>
       </div>

       <div class="element">
           <label for="passwordConfirmation" tag="" class="" id="submit"
               value="Save"/>
   </form>

It may not be truly pretty, but with some CSS, it could be made to look exactly how you might want to see it. The
main point, however, is that this form was generated using almost entirely custom markup, while still leveraging
decorators for the most common markup (and to ensure things like escaping with htmlentities and value injection
occur).

By this point in the tutorial, you should be getting fairly comfortable with the markup possibilities using
``Zend_Form``'s decorators. In the next section, we'll revisit the date element from above, and demonstrate how to
create a custom element and decorator for composite elements.


