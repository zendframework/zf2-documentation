.. _zend.form.quick-start:

Quick Start
===========

Forms are relatively easy to create. At the bare minimum, each element or fieldset requires a name; typically,
you'll also provide some attributes to hint to the view layer how it might render the item. The form itself will
also typically compose an ``InputFilter``-- which you can also conveniently create directly in the form via a
factory. Individual elements can hint as to what defaults to use when generating a related input for the input
filter.

Form validation is as easy as providing an array of data to the ``setData()`` method. If you want to simplify your
work even more, you can bind an object to the form; on successful validation, it will be populated from the
validated values.

.. _zend.form.quick-start.programmatic:

Programmatic Form Creation
--------------------------

If nothing else, you can simply start creating elements, fieldsets, and forms and wiring them together.

.. code-block:: php
   :linenos:

   use Zend\Captcha;
   use Zend\Form\Element;
   use Zend\Form\Fieldset;
   use Zend\Form\Form;
   use Zend\InputFilter\Input;
   use Zend\InputFilter\InputFilter;

   $name = new Element('name');
   $name->setLabel('Your name');
   $name->setAttributes(array(
       'type'  => 'text'
   ));

   $email = new Element\Email('email');
   $email->setLabel('Your email address');

   $subject = new Element('subject');
   $subject->setLabel('Subject');
   $subject->setAttributes(array(
       'type'  => 'text'
   ));

   $message = new Element\Textarea('message');
   $message->setLabel('Message');

   $captcha = new Element\Captcha('captcha');
   $captcha->setCaptcha(new Captcha\Dumb());
   $captcha->setLabel('Please verify you are human');

   $csrf = new Element\Csrf('security');

   $send = new Element('send');
   $send->setValue('Submit');
   $send->setAttributes(array(
       'type'  => 'submit'
   ));


   $form = new Form('contact');
   $form->add($name);
   $form->add($email);
   $form->add($subject);
   $form->add($message);
   $form->add($captcha);
   $form->add($csrf);
   $form->add($send);

   $nameInput = new Input('name');
   // configure input... and all others
   $inputFilter = new InputFilter();
   // attach all inputs

   $form->setInputFilter($inputFilter);

As a demonstration of fieldsets, let's alter the above slightly. We'll create two fieldsets, one for the sender
information, and another for the message details.

.. code-block:: php
   :linenos:

   $sender = new Fieldset('sender');
   $sender->add($name);
   $sender->add($email);

   $details = new Fieldset('details');
   $details->add($subject);
   $details->add($message);

   $form = new Form('contact');
   $form->add($sender);
   $form->add($details);
   $form->add($captcha);
   $form->add($csrf);
   $form->add($send);

Regardless of approach, as you can see, this can be tedious.

.. _zend.form.quick-start.factory:

Creation via Factory
--------------------

You can create the entire form, and input filter, using the ``Factory``. This is particularly nice if you want to
store your forms as pure configuration; you can simply pass the configuration to the factory and be done.

.. code-block:: php
   :linenos:

   use Zend\Form\Factory;

   $factory = new Factory();
   $form    = $factory->createForm(array(
       'hydrator' => 'Zend\Stdlib\Hydrator\ArraySerializable',
       'elements' => array(
           array(
               'spec' => array(
                   'name' => 'name',
                   'options' => array(
                       'label' => 'Your name',
                   ),
                   'type'  => 'Text',
               )
           ),
           array(
               'spec' => array(
                   'type' => 'Zend\Form\Element\Email',
                   'name' => 'email',
                   'options' => array(
                       'label' => 'Your email address',
                   )
               ),
           ),
           array(
               'spec' => array(
                   'name' => 'subject',
                   'options' => array(
                       'label' => 'Subject',
                   ),
                   'type'  => 'Text',
               ),
           ),
           array(
               'spec' => array(
                   'type' => 'Zend\Form\Element\Textarea',
                   'name' => 'message',
                   'options' => array(
                       'label' => 'Message',
                   )
               ),
           ),
           array(
               'spec' => array(
                   'type' => 'Zend\Form\Element\Captcha',
                   'name' => 'captcha',
                   'options' => array(
                       'label' => 'Please verify you are human.',
                       'captcha' => array(
                           'class' => 'Dumb',
                       ),
                   ),
               ),
           ),
           array(
               'spec' => array(
                   'type' => 'Zend\Form\Element\Csrf',
                   'name' => 'security',
               ),
           ),
           array(
               'spec' => array(
                   'name' => 'send',
                   'type'  => 'Submit',
                   'attributes' => array(
                       'value' => 'Submit',
                   ),
               ),
           ),
       ),
       /* If we had fieldsets, they'd go here; fieldsets contain
        * "elements" and "fieldsets" keys, and potentially a "type"
        * key indicating the specific FieldsetInterface
        * implementation to use.
       'fieldsets' => array(
       ),
        */

       // Configuration to pass on to
       // Zend\InputFilter\Factory::createInputFilter()
       'input_filter' => array(
           /* ... */
       ),
   ));

If we wanted to use fieldsets, as we demonstrated in the previous example, we could do the following:

.. code-block:: php
   :linenos:

   use Zend\Form\Factory;

   $factory = new Factory();
   $form    = $factory->createForm(array(
       'hydrator'  => 'Zend\Stdlib\Hydrator\ArraySerializable',
       'fieldsets' => array(
           array(
               'spec' => array(
                   'name' => 'sender',
                   'elements' => array(
                       array(
                           'spec' => array(
                               'name' => 'name',
                               'options' => array(
                                   'label' => 'Your name',
                               ),
                               'type' => 'Text'
                           ),
                       ),
                       array(
                           'spec' => array(
                               'type' => 'Zend\Form\Element\Email',
                               'name' => 'email',
                               'options' => array(
                                   'label' => 'Your email address',
                               ),
                           ),
                       ),
                   ),
               ),
           ),
           array(
               'spec' => array(
                   'name' => 'details',
                   'elements' => array(
                       array(
                           'spec' => array(
                               'name' => 'subject',
                               'options' => array(
                                   'label' => 'Subject',
                               ),
                               'type' => 'Text',
                           ),
                       ),
                       array(
                           'spec' => array(
                               'name' => 'message',
                               'type' => 'Zend\Form\Element\Textarea',
                               'options' => array(
                                   'label' => 'Message',
                               ),
                           ),
                       ),
                   ),
               ),
           ),
       ),
       'elements' => array(
           array(
               'spec' => array(
                   'type' => 'Zend\Form\Element\Captcha',
                   'name' => 'captcha',
                   'options' => array(
                       'label' => 'Please verify you are human. ',
                       'captcha' => array(
                           'class' => 'Dumb',
                       ),
                   ),
               ),
           ),
           array(
               'spec' => array(
               'type' => 'Zend\Form\Element\Csrf',
               'name' => 'security',
           ),
       ),
       array(
           'spec' => array(
               'name' => 'send',
               'type'  => 'Submit',
               'attributes' => array(
                   'value' => 'Submit',
               ),
           ),
        ),
       ),
       // Configuration to pass on to
       // Zend\InputFilter\Factory::createInputFilter()
       'input_filter' => array(
       /* ... */
       ),
   ));

Note that the chief difference is nesting; otherwise, the information is basically the same.

The chief benefits to using the ``Factory`` are allowing you to store definitions in configuration, and usage of
significant whitespace.

.. _zend.form.quick-start.extension:

Factory-backed Form Extension
-----------------------------

The default ``Form`` implementation is backed by the ``Factory``. This allows you to extend it, and define your
form internally. This has the benefit of allowing a mixture of programmatic and factory-backed creation, as well as
defining a form for re-use in your application.

.. code-block:: php
   :linenos:

   namespace Contact;

   use Zend\Captcha\AdapterInterface as CaptchaAdapter;
   use Zend\Form\Element;
   use Zend\Form\Form;

   class ContactForm extends Form
   {
       protected $captcha;

       public function __construct(CaptchaAdapter $captcha)
       {
       
           parent::__construct();
           
           $this->captcha = $captcha;

           // add() can take either an Element/Fieldset instance,
           // or a specification, from which the appropriate object
           // will be built.

           $this->add(array(
               'name' => 'name',
               'options' => array(
                   'label' => 'Your name',
               ),
               'type'  => 'Text',
           ));
           $this->add(array(
               'type' => 'Zend\Form\Element\Email',
               'name' => 'email',
               'options' => array(
                   'label' => 'Your email address',
               ),
           ));
           $this->add(array(
               'name' => 'subject',
               'options' => array(
                   'label' => 'Subject',
               ),
               'type'  => 'Text',
           ));
           $this->add(array(
               'type' => 'Zend\Form\Element\Textarea',
               'name' => 'message',
               'options' => array(
                   'label' => 'Message',
               ),
           ));
           $this->add(array(
               'type' => 'Zend\Form\Element\Captcha',
               'name' => 'captcha',
               'options' => array(
                   'label' => 'Please verify you are human.',
                   'captcha' => $this->captcha,
               ),
           ));
           $this->add(new Element\Csrf('security'));
           $this->add(array(
               'name' => 'send',
               'type'  => 'Submit',
               'attributes' => array(
                   'value' => 'Submit',
               ),
           ));

           // We could also define the input filter here, or
           // lazy-create it in the getInputFilter() method.
       }
   }

You'll note that this example, the elements are added in the constructor. This is done to allow altering and/or
configuring either the form or input filter factory instances, which could then have bearing on how elements,
inputs, etc. are created. In this case, it also allows injection of the CAPTCHA adapter, allowing us to configure
it elsewhere in our application and inject it into the form.

.. _zend.form.quick-start.validation:

Validating Forms
----------------

Validating forms requires three steps. First, the form must have an input filter attached. Second, you must inject
the data to validate into the form. Third, you validate the form. If invalid, you can retrieve the error messages,
if any.

.. code-block:: php
   :linenos:

   // assuming $captcha is an instance of some Zend\Captcha\AdapterInterface
   $form = new Contact\ContactForm($captcha);

   // If the form doesn't define an input filter by default, inject one.
   $form->setInputFilter(new Contact\ContactFilter());

   // Get the data. In an MVC application, you might try:
   $data = $request->getPost();  // for POST data
   $data = $request->getQuery(); // for GET (or query string) data

   $form->setData($data);

   // Validate the form
   if ($form->isValid()) {
       $validatedData = $form->getData();
   } else {
       $messages = $form->getMessages();
   }

You can get the raw data if you want, by accessing the composed input filter.

.. code-block:: php
   :linenos:

   $filter = $form->getInputFilter();

   $rawValues    = $filter->getRawValues();
   $nameRawValue = $filter->getRawValue('name');

.. _zend.form.quick-start.input-specification:

Hinting to the Input Filter
---------------------------

Often, you'll create elements that you expect to behave in the same way on each usage, and for which you'll want
specific filters or validation as well. Since the input filter is a separate object, how can you achieve these
latter points?

Because the default form implementation composes a factory, and the default factory composes an input filter
factory, you can have your elements and/or fieldsets hint to the input filter. If no input or input filter is
provided in the input filter for that element, these hints will be retrieved and used to create them.

To do so, one of the following must occur. For elements, they must implement
``Zend\InputFilter\InputProviderInterface``, which defines a ``getInputSpecification()`` method; for fieldsets,
they must implement ``Zend\InputFilter\InputFilterProviderInterface``, which defines a
``getInputFilterSpecification()`` method.

In the case of an element, the ``getInputSpecification()`` method should return data to be used by the input filter
factory to create an input. Every HTML5 (email, url, color…) elements have a built-in element that use this logic. For instance, here is how the ``Zend\Form\Element\Color`` element is defined:

.. code-block:: php
   :linenos:

    namespace Zend\Form\Element;

    use Zend\Form\Element;
    use Zend\InputFilter\InputProviderInterface;
    use Zend\Validator\Regex as RegexValidator;
    use Zend\Validator\ValidatorInterface;

    class Color extends Element implements InputProviderInterface
    {
        /**
         * Seed attributes
         *
         * @var array
         */
        protected $attributes = array(
            'type' => 'color',
        );
    
        /**
         * @var ValidatorInterface
         */
        protected $validator;
    
        /**
         * Get validator
         *
         * @return ValidatorInterface
         */
        protected function getValidator()
        {
            if (null === $this->validator) {
                $this->validator = new RegexValidator('/^#[0-9a-fA-F]{6}$/');
            }
            return $this->validator;
        }
    
        /**
         * Provide default input rules for this element
         *
         * Attaches an email validator.
         *
         * @return array
         */
        public function getInputSpecification()
        {
            return array(
                'name' => $this->getName(),
                'required' => true,
                'filters' => array(
                    array('name' => 'Zend\Filter\StringTrim'),
                    array('name' => 'Zend\Filter\StringToLower'),
                ),
                'validators' => array(
                    $this->getValidator(),
                ),
            );
        }
    }

The above would hint to the input filter to create and attach an input named after the element, marking it as
required, and giving it a ``StringTrim`` and ``StringToLower`` filters and a ``Regex`` validator. Note that you can either rely on the input filter to create filters and validators, or directly instantiate them.

For fieldsets, you do very similarly; the difference is that ``getInputFilterSpecification()`` must return
configuration for an input filter.

.. code-block:: php
   :linenos:

   namespace Contact\Form;

   use Zend\Form\Fieldset;
   use Zend\InputFilter\InputFilterProviderInterface;
   use Zend\Validator;

   class SenderFieldset extends Fieldset implements InputFilterProviderInterface
   {
       public function getInputFilterSpecification()
       {
           return array(
               'name' => array(
                   'required' => true,
                   'filters'  => array(
                       array('name' => 'Zend\Filter\StringTrim'),
                   ),
                   'validators' => array(
                       array(
                           'name' => 'Zend\Validator\StringLength', 
                           'options' => array(
                               'min' => 3,
                               'max' => 256
                           ),
                       ),
                   ),
               ),
               'email' => array(
                   'required' => true,
                   'filters'  => array(
                       array('name' => 'Zend\Filter\StringTrim'),
                   ),
                   'validators' => array(
                       new Validator\EmailAddress(),
                   ),
               ),
           );
       }
   }

Specifications are a great way to make forms, fieldsets, and elements re-usable trivially in your applications. In
fact, the ``Captcha`` and ``Csrf`` elements define specifications in order to ensure they can work without
additional user configuration!

.. note::

    If you set custom input filter specification either in ``getInputSpecification()`` or in ``getInputFilterSpecification()``,
    the ``Zend\InputFilter\InputInterface`` set for that specific field is reset to the default ``Zend\InputFilter\Input``.

    Some form elements may need a particular input filter, like ``Zend\Form\Element\File``: in this case it's mandatory to specify
    the ``type`` key in your custom specification to match the original one (in ex. for the file element it's ``Zend\InputFilter\FileInput``).

.. _zend.form.quick-start.binding:

Binding an object
-----------------

As noted in the intro, forms in Zend Framework bridge the domain model and the view layer. Let's see that in
action.

When you ``bind()`` an object to the form, the following happens:

- The composed ``Hydrator`` calls ``extract()`` on the object, and uses the values returned, if any, to populate
  the ``value`` attributes of all elements. If a form contains a fieldset that itself contains another fieldset, the form will recursively extract the values.
  
- When ``isValid()`` is called, if ``setData()`` has not been previously set, the form uses the composed
  ``Hydrator`` to extract values from the object, and uses those during validation.

- If ``isValid()`` is successful (and the ``bindOnValidate`` flag is enabled, which is true by default), then the
  ``Hydrator`` will be passed the validated values to use to hydrate the bound object. (If you do not want this
  behavior, call ``setBindOnValidate(FormInterface::BIND_MANUAL)``).

- If the object implements ``Zend\InputFilter\InputFilterAwareInterface``, the input filter it composes will be
  used instead of the one composed on the form.

This is easier to understand in practice.

.. code-block:: php
   :linenos:

   $contact = new ArrayObject;
   $contact['subject'] = '[Contact Form] ';
   $contact['message'] = 'Type your message here';

   $form    = new Contact\ContactForm;

   $form->bind($contact); // form now has default values for
                          // 'subject' and 'message'

   $data = array(
       'name'    => 'John Doe',
       'email'   => 'j.doe@example.tld',
       'subject' => '[Contact Form] \'sup?',
   );
   $form->setData($data);

   if ($form->isValid()) {
       // $contact now looks like:
       // array(
       //     'name'    => 'John Doe',
       //     'email'   => 'j.doe@example.tld',
       //     'subject' => '[Contact Form] \'sup?',
       //     'message' => 'Type your message here',
       // )
       // only as an ArrayObject
   }

When an object is bound to the form, calling ``getData()`` will return that object by default. If you want to
return an associative array instead, you can pass the ``FormInterface::VALUES_AS_ARRAY`` flag to the method.

.. code-block:: php
   :linenos:

   use Zend\Form\FormInterface;
   $data = $form->getData(FormInterface::VALUES_AS_ARRAY);

Zend Framework ships several standard :ref:`hydrators <zend.stdlib.hydrator>`, and implementation is as simple as
implementing ``Zend\Stdlib\Hydrator\HydratorInterface``, which looks like this:

.. code-block:: php
   :linenos:

   namespace Zend\Stdlib\Hydrator;

   interface HydratorInterface
   {
       /** @return array */
       public function extract($object);
       public function hydrate(array $data, $object);
   }

.. _zend.form.quick-start.rendering:

Rendering
---------

As noted previously, forms are meant to bridge the domain model and view layer. We've discussed the domain model
binding, but what about the view?

The form component ships a set of form-specific view helpers. These accept the various form objects, and introspect
them in order to generate markup. Typically, they will inspect the attributes, but in special cases, they may look
at other properties and composed objects.

When preparing to render, you will likely want to call ``prepare()``. This method ensures that certain injections
are done, and will likely in the future munge names to allow for ``scoped[array][notation]``.

The simplest view helpers available are ``Form``, ``FormElement``, ``FormLabel``, and
``FormElementErrors``. Let's use them to display the contact form.

.. code-block:: php
   :linenos:

   <?php
   // within a view script
   $form = $this->form;
   $form->prepare();

   // Assuming the "contact/process" route exists...
   $form->setAttribute('action', $this->url('contact/process'));

   // Set the method attribute for the form
   $form->setAttribute('method', 'post');

   // Get the form label plugin
   $formLabel = $this->plugin('formLabel');

   // Render the opening tag
   echo $this->form()->openTag($form);
   ?>
   <div class="form_element">
   <?php
       $name = $form->get('name');
       echo $formLabel->openTag() . $name->getOption('label');
       echo $this->formInput($name);
       echo $this->formElementErrors($name);
       echo $formLabel->closeTag();
   ?></div>

   <div class="form_element">
   <?php
       $subject = $form->get('subject');
       echo $formLabel->openTag() . $subject->getOption('label');
       echo $this->formInput($subject);
       echo $this->formElementErrors($subject);
       echo $formLabel->closeTag();
   ?></div>

   <div class="form_element">
   <?php
       $message = $form->get('message');
       echo $formLabel->openTag() . $message->getOption('label');
       echo $this->formTextarea($message);
       echo $this->formElementErrors($message);
       echo $formLabel->closeTag();
   ?></div>

   <div class="form_element">
   <?php
       $captcha = $form->get('captcha');
       echo $formLabel->openTag() . $captcha->getOption('label');
       echo $this->formCaptcha($captcha);
       echo $this->formElementErrors($captcha);
       echo $formLabel->closeTag();
   ?></div>

   <?php echo $this->formElement($form->get('security')) ?>
   <?php echo $this->formElement($form->get('send')) ?>

   <?php echo $this->form()->closeTag() ?>

There are a few things to note about this. First, to prevent confusion in IDEs and editors when syntax
highlighting, we use helpers to both open and close the form and label tags. Second, there's a lot of repetition
happening here; we could easily create a partial view script or a composite helper to reduce boilerplate. Third,
note that not all elements are created equal -- the CSRF and submit elements don't need labels or error messages
necessarily. Finally, note that the ``FormElement`` helper tries to do the right thing -- it delegates actual
markup generation to other view helpers; however, it can only guess what specific form helper to delegate to based
on the list it has. If you introduce new form view helpers, you'll need to extend the ``FormElement`` helper, or
create your own.

However, your view files can quickly become long and repetitive to write. While we do not currently provide a
single-line form view helper (as this reduces the form customization), the simplest and most recommended way to
render your form is by using the ``FormRow`` view helper. This view helper automatically renders a label (if present),
the element itself using the ``FormElement`` helper, as well as any errors that could arise. Here is the previous form,
rewritten to take advantage of this helper :

.. code-block:: php
   :linenos:

   <?php
   // within a view script
   $form = $this->form;
   $form->prepare();

   // Assuming the "contact/process" route exists...
   $form->setAttribute('action', $this->url('contact/process'));

   // Set the method attribute for the form
   $form->setAttribute('method', 'post');

   // Render the opening tag
   echo $this->form()->openTag($form);
   ?>
   <div class="form_element">
   <?php
       $name = $form->get('name');
       echo $this->formRow($name);
   ?></div>

   <div class="form_element">
   <?php
       $subject = $form->get('subject');
       echo $this->formRow($subject);
   ?></div>

   <div class="form_element">
   <?php
       $message = $form->get('message');
       echo $this->formRow($message);
   ?></div>

   <div class="form_element">
   <?php
       $captcha = $form->get('captcha');
       echo $this->formRow($captcha);
   ?></div>

   <?php echo $this->formElement($form->get('security')) ?>
   <?php echo $this->formElement($form->get('send')) ?>

   <?php echo $this->form()->closeTag() ?>

Note that ``FormRow`` helper automatically prepends the label. If you want it to be rendered after the element itself,
you can pass an optional parameter to the ``FormRow`` view helper :

.. code-block:: php
   :linenos:
   :emphasize-lines: 4

   <div class="form_element">
   <?php
       $name = $form->get('name');
       echo $this->formRow($name, 'append');
   ?></div>

Taking advantage of HTML5 input attributes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

HTML5 brings a lot of exciting features, one of them being a simplified client form validations. Adding HTML5 attributes is simple as you just need to add specify the attributes. However, please note that adding those attributes does not automatically add Zend validators to the form's input filter. You still need to manually add them.

.. code-block:: php
   :linenos:

   $form->add(array(
       'name' => 'phoneNumber',
       'options' => array(
           'label' => 'Your phone number'
       ),
       'attributes' => array(
           'type' => 'tel'
           'required' => 'required',
           'pattern'  => '^0[1-68]([-. ]?[0-9]{2}){4}$'
       )
   ));

View helpers will automatically render those attributes, and hence allowing modern browsers to perform automatic validation.

.. note::

    Although client validation is nice from a user experience point of view, it has to be used in addition with server validation, as client validation can be easily fooled.

.. _zend.form.quick-start.partial:

Validation Groups
-----------------

Sometimes you want to validate only a subset of form elements. As an example, let's say we're re-using our contact
form over a web service; in this case, the ``Csrf``, ``Captcha``, and submit button elements are not of interest,
and shouldn't be validated.

``Zend\Form`` provides a proxy method to the underlying ``InputFilter``'s ``setValidationGroup()`` method, allowing
us to perform this operation.

.. code-block:: php
   :linenos:

   $form->setValidationGroup('name', 'email', 'subject', 'message');
   $form->setData($data);
   if ($form->isValid()) {
       // Contains only the "name", "email", "subject", and "message" values
       $data = $form->getData();
   }

If you later want to reset the form to validate all, simply pass the ``FormInterface::VALIDATE_ALL`` flag to the
``setValidationGroup()`` method.

.. code-block:: php
   :linenos:

   use Zend\Form\FormInterface;
   $form->setValidationGroup(FormInterface::VALIDATE_ALL);

When your form contains nested fieldsets, you can use an array notation to validate only a subset of the fieldsets :

.. code-block:: php
   :linenos:

   $form->setValidationGroup(array(
        'profile' => array(
            'firstname',
            'lastname'
        )
   ));
   $form->setData($data);
   if ($form->isValid()) {
       // Contains only the "firstname" and "lastname" values from the
       // "profile" fieldset
       $data = $form->getData();
   }
   

.. _zend.form.quick-start.annotations:

Using Annotations
-----------------

Creating a complete forms solution can often be tedious: you'll create some domain model object, an input filter
for validating it, a form object for providing a representation for it, and potentially a hydrator for mapping the
form elements and fieldsets to the domain model. Wouldn't it be nice to have a central place to define all of
these?

Annotations allow us to solve this problem. You can define the following behaviors with the shipped annotations in
``Zend\Form``:

- *AllowEmpty*: mark an input as allowing an empty value. This annotation does not require a value.

- *Attributes*: specify the form, fieldset, or element attributes. This annotation requires an associative array of
  values, in a JSON object format: ``@Attributes({"class":"zend_form","type":"text"})``.

- *ComposedObject*: specify another object with annotations to parse. Typically, this is used if a property
  references another object, which will then be added to your form as an additional fieldset. Expects a string
  value indicating the class for the object being composed ``@ComposedObject("Namespace\Model\ComposedObject")`` or an array to compose a collection: ``@ComposedObject({
  "target_object":"Namespace\Model\ComposedCollection", "is_collection":"true", "options":{"count":2}})`` 
  ``target_object`` is the element to compose, ``is_collection`` flags this as a collection and ``options`` can take an array
  of options to pass into the collection. 

- *ErrorMessage*: specify the error message to return for an element in the case of a failed validation. Expects a
  string value.

- *Exclude*: mark a property to exclude from the form or fieldset. This annotation does not require a value.

- *Filter*: provide a specification for a filter to use on a given element. Expects an associative array of values,
  with a "name" key pointing to a string filter name, and an "options" key pointing to an associative array of
  filter options for the constructor: ``@Filter({"name": "Boolean", "options": {"casting":true}})``. This annotation
  may be specified multiple times.

- *Flags*: flags to pass to the fieldset or form composing an element or fieldset; these are usually used to
  specify the name or priority. The annotation expects an associative array: ``@Flags({"priority": 100})``.

- *Hydrator*: specify the hydrator class to use for this given form or fieldset. A string value is expected.

- *InputFilter*: specify the input filter class to use for this given form or fieldset. A string value is expected.

- *Input*: specify the input class to use for this given element. A string value is expected.

- *Name*: specify the name of the current element, fieldset, or form. A string value is expected.

- *Options*: options to pass to the fieldset or form that are used to inform behavior -- things that are not
  attributes; e.g. labels, CAPTCHA adapters, etc. The annotation expects an associative array: ``@Options({"label":
  "Username:"})``.

- *Required*: indicate whether an element is required. A boolean value is expected. By default, all elements are
  required, so this annotation is mainly present to allow disabling a requirement.

- *Type*: indicate the class to use for the current element, fieldset, or form. A string value is expected.

- *Validator*: provide a specification for a validator to use on a given element. Expects an associative array of
  values, with a "name" key pointing to a string validator name, and an "options" key pointing to an associative
  array of validator options for the constructor: ``@Validator({"name": "StringLength", "options": {"min":3, "max":
  25}})``. This annotation may be specified multiple times.

To use annotations, you simply include them in your class and/or property docblocks. Annotation names will be
resolved according to the import statements in your class; as such, you can make them as long or as short as you
want depending on what you import.

.. note::

    Form annotations require ``Doctrine\Common``, which contains an annotation
    parsering engine. The simplest way to install ``Doctrine\Common`` is if you
    are using ``Composer``; simply update your ``composer.json`` and add the
    following line to the ``require`` section:

    .. code-block:: javascript
       :linenos:

       "doctrine/common": ">=2.1",

    Then run ``php composer.phar update`` to install the dependency.

    If you're not using ``Composer``, visit `the Doctrine project website
    <http://www.doctrine-project.org/projects/common.html>`_ for more details on
    installation.

Here's a simple example.

.. code-block:: php
   :linenos:

   use Zend\Form\Annotation;

   /**
    * @Annotation\Name("user")
    * @Annotation\Hydrator("Zend\Stdlib\Hydrator\ObjectProperty")
    */
   class User
   {
       /**
        * @Annotation\Exclude()
        */
       public $id;

       /**
        * @Annotation\Filter({"name":"StringTrim"})
        * @Annotation\Validator({"name":"StringLength", "options":{"min":1, "max":25}})
        * @Annotation\Validator({"name":"Regex", "options":{"pattern":"/^[a-zA-Z][a-zA-Z0-9_-]{0,24}$/"}})
        * @Annotation\Attributes({"type":"text"})
        * @Annotation\Options({"label":"Username:"})
        */
       public $username;

       /**
        * @Annotation\Type("Zend\Form\Element\Email")
        * @Annotation\Options({"label":"Your email address:"})
        */
       public $email;
   }

The above will hint to the annotation build to create a form with name "user", which uses the hydrator
``Zend\Stdlib\Hydrator\ObjectProperty``. That form will have two elements, "username" and "email". The "username"
element will have an associated input that has a ``StringTrim`` filter, and two validators: a ``StringLength``
validator indicating the username is between 1 and 25 characters, and a ``Regex`` validator asserting it follows a
specific accepted pattern. The form element itself will have an attribute "type" with value "text" (a text
element), and a label "Username:". The "email" element will be of type ``Zend\Form\Element\Email``, and have the
label "Your email address:".

To use the above, we need ``Zend\Form\Annotation\AnnotationBuilder``:

.. code-block:: php
   :linenos:

   use Zend\Form\Annotation\AnnotationBuilder;

   $builder = new AnnotationBuilder();
   $form    = $builder->createForm('User');

At this point, you have a form with the appropriate hydrator attached, an input filter with the appropriate inputs,
and all elements.

.. note::

   **You're not done**

   In all likelihood, you'll need to add some more elements to the form you construct. For example, you'll want a
   submit button, and likely a CSRF-protection element. We recommend creating a fieldset with common elements such
   as these that you can then attach to the form you build via annotations.


