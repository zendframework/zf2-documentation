.. _zend.form.advanced-use-of-forms:

Advanced use of forms
=====================

Beginning with Zend Framework 2.1, forms elements can be registered using a designated plugin manager of
:doc:`Zend\\ServiceManager <zend.service-manager.intro>`. This is similar to how view helpers, controller plugins, and
filters are registered. This new feature has a number of benefits, especially when you need to handle complex 
dependencies in forms/fieldsets. This section describes all the benefits of this new architecture in ZF 2.1.

.. _zend.form.advanced-use-of-forms.short-names:

Short names
-----------

The first advantage of pulling form elements from the service manager is that now you can use short names to create new elements through the factory. Therefore, this code:

.. code-block:: php
    :linenos:

    $form->add(array(
        'type' => 'Zend\Form\Element\Email',
        'name' => 'email'
    ));
   
can now be replaced by:

.. code-block:: php
   :linenos:

   $form->add(array(
        'type' => 'Email',
        'name' => 'email'
   ));

Each element provided out-of-the-box by Zend Framework 2 support this natively, so you can now make your initialization code more compact.

.. _zend.form.advanced-use-of-forms.create-your-own-elements:

Creating custom elements
------------------------

``Zend\Form`` also supports custom form elements. 

To create a custom form element, make it extend the ``Zend\Form\Element`` class, or if you need a more specific
one, extend one of the ``Zend\Form\Element`` classes.

In the following we will show how to create a custom ``Phone`` element for entering phone numbers. It will extend
``Zend\Form\Element`` class and provide some default input rules.

Our custom phone element could look something like this:

.. code-block:: php
    :linenos:

    namespace Application\Form\Element;

    use Zend\Form\Element;
    use Zend\InputFilter\InputProviderInterface;
    use Zend\Validator\Regex as RegexValidator;

    class Phone extends Element implements InputProviderInterface
    {
        /**
         * @var ValidatorInterface
         */
        protected $validator;

        /**
        * Get a validator if none has been set.
        *
        * @return ValidatorInterface
        */
        public function getValidator()
        {
            if (null === $this->validator) {
                $validator = new RegexValidator('/^\+?\d{11,12}$/');
                $validator->setMessage('Please enter 11 or 12 digits only!',
                                        RegexValidator::NOT_MATCH);

                $this->validator = $validator;
            }

            return $this->validator;
        }

        /**
         * Sets the validator to use for this element
         *
         * @param  ValidatorInterface $validator
         * @return Application\Form\Element\Phone
         */
        public function setValidator(ValidatorInterface $validator)
        {
            $this->validator = $validator;
            return $this;
        }

        /**
         * Provide default input rules for this element
         *
         * Attaches a phone number validator.
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
                ),
                'validators' => array(
                    $this->getValidator(),
                ),
            );
        }
    }

By implementing the ``Zend\InputFilter\InputProviderInterface`` interface, we are hinting to our form
object that this element provides some default input rules for filtering and/or validating values. In this
example the default input specification provides a ``Zend\Filter\StringTrim`` filter and a ``Zend\Validator\Regex``
validator that validates that the value optionally has a + sign at the beginning and is followed by 11 or 12
digits.

The easiest way of start using your new custom element in your forms is to use the custom element's FQCN:

.. code-block:: php
    :linenos:

    $form = new Zend\Form\Form();
    $form->add(array(
        'name' => 'phone',
        'type' => 'Application\Form\Element\Phone',
    ));

Or, if you are extending ``Zend\Form\Form``:

.. code-block:: php
    :linenos:

    namespace Application\Form;

    use Zend\Form\Form;

    class MyForm extends Form
    {
        public function __construct($name = null)
        {
            parent::__construct($name);

            $this->add(array(
                'name' => 'phone',
                'type' => 'Application\Form\Element\Phone',
            ))
        }
    }


If you don't want to use the custom element's FQCN, but rather a short name, as of Zend Framework 2.1 you can do so
by adding them to the ``Zend\Form\FormElementManager`` plugin manager by utilising the ``getFormElementConfig`` function.

.. warning::

    To use custom elements with the FormElementManager needs a bit more work and most likely a change in how you write and
    use your forms.

First, add the custom element to the plugin manager, in your ``Module.php`` class:

.. code-block:: php
    :linenos:

    namespace Application;

    use Zend\ModuleManager\Feature\FormElementProviderInterface;

    class Module implements FormElementProviderInterface
    {
        public function getFormElementConfig()
        {
            return array(
                'invokables' => array(
                    'phone' => 'Application\Form\Element\Phone'
                )
            );
        }
    }

Or, you can do the same in your ``module.config.php`` file:

.. code-block:: php
    :linenos:

    return array(
        'form_elements' => array(
            'invokables' => array(
                'phone' => 'Application\Form\Element\Phone'
            )
        )
    );
   
You can use a factory instead of an invokable in order to handle dependencies in your elements/fieldsets/forms.

**And now comes the first catch.**

If you are creating your form class by extending ``Zend\Form\Form``, you *must not* add the custom element in the
``__construct``-or (as we have done in the previous example where we used the custom element's FQCN),
but rather in the ``init()`` method:

.. code-block:: php
   :linenos:

    namespace Application\Form;

    use Zend\Form\Form;

    class MyForm extends Form
    {
        public function init()
        {
            $this->add(array(
                'name' => 'phone',
                'type' => 'Phone',
            ));
        }
    }

**The second catch** is that you *must not* directly instantiate your form class, but rather get an instance of it
through the ``Zend\Form\FormElementManager``:

.. code-block:: php
   :linenos:

    namespace Application\Controller;

    use Zend\Mvc\Controller\AbstractActionController;

    class IndexController extends AbstractActionController
    {
        public function indexAction()
        {
            $sl = $this->getServiceLocator();
            $form = $sl->get('FormElementManager')->get('\Application\Form\MyForm');
            return array('form' => $form);
        }
    }

  
The biggest gain of this is that you can easily override any built-in Zend Framework form elements if they do not fit your needs.
For instance, if you want to create your own Email element instead of the standard one, you can simply create your element and add it to
the form element config with the same key as the element you want to replace:

.. code-block:: php
    :linenos:

    namespace Application;

    use Zend\ModuleManager\Feature\FormElementProviderInterface;

    class Module implements FormElementProviderInterface
    {
        public function getFormElementConfig()
        {
            return array(
                'invokables' => array(
                    'Email' => 'Application\Form\Element\MyEmail'
                )
            );
        }
    }
   
Now, whenever you'll create an element whose ``type`` is 'Email', it will create the custom Email element instead of the built-in one.

.. note::
   
   if you want to be able to use both the built-in one and your own one, you can still provide the FQCN of the element, 
   i.e. ``Zend\Form\Element\Email``.

As you can see here, we first get the form manager (that we modified in our Module.php class), and create the form by specifying the fully
qualified class name of the form. Please note that you don't need to add ``Application\Form\MyForm`` to the `invokables` array. If it is not
specified, the form manager will just instantiate it directly.

In short, to create your own form elements (or even reusable fieldsets !) and be able to use them in your form using the short-name notation, you need to:

1. Create your element (like you did before).
2. Add it to the form element manager by defining the ``getFormElementConfig``, exactly like using ``getServiceConfig()`` and ``getControllerConfig``.
3. Make sure the custom form element is not added in the form's ``__construct``-or, but rather in it's ``init()`` method, or after getting an instance of the form.
4. Create your form through the form element manager instead of directly instantiating it.

.. _zend.form.advanced-use-of-forms.handling-dependencies:

Handling dependencies
---------------------

One of the most complex issues in ``Zend\Form 2.0`` was dependency management. For instance, a very frequent use case
is a form that creates a fieldset, that itself need access to the database to populate a ``Select`` element. Previously
in such a situation, you would either rely on the Registry using the Singleton pattern, or either you would "transfer" 
the dependency from controller to form, and from form to fieldset (and even from fieldset to another fieldset if you 
have a complex form). This was ugly and not easy to use. Hopefully, ``Zend\ServiceManager`` solves this use case in an
elegant manner.

For instance, let's say that a form create a fieldset called ``AlbumFieldset``:

.. code-block:: php
    :linenos:

    namespace Application\Form;

    use Zend\Form\Form;

    class CreateAlbum extends Form
    {
        public function init()
        {
            $this->add(array(
                'name' => 'album',
                'type' => 'AlbumFieldset'
            ));
        }
    }

Let's now create the ``AlbumFieldset`` that depends on an ``AlbumTable`` object that allows you to fetch albums from the 
database.

.. code-block:: php
    :linenos:

    namespace Application\Form;

    use Album\Model\AlbumTable;
    use Zend\Form\Fieldset;

    class AlbumFieldset extends Fieldset
    {
        public function __construct(AlbumTable $albumTable)
        {   		
            // Add any elements that need to fetch data from database
            // using the album table !
        }
    }

For this to work, you need to add a line to the form element manager by adding
an element to your Module.php class:

.. code-block:: php
    :linenos:

    namespace Application;

    use Application\Form\AlbumFieldset;
    use Zend\ModuleManager\Feature\FormElementProviderInterface;

    class Module implements FormElementProviderInterface
    {
        public function getFormElementConfig()
        {
            return array(
                'factories' => array(
                    'AlbumFieldset' => function($sm) {
                        // I assume here that the Album\Model\AlbumTable
                        // dependency have been defined too

                        $serviceLocator = $sm->getServiceLocator();
                        $albumTable = $serviceLocator->get('Album\Model\AlbumTable');
                        $fieldset = new AlbumFieldset($albumTable);
                        return $fieldset;
                    }
                )
            );
        }
    }
   
Create your form using the form element manager instead of directly
instantiating it:
   
.. code-block:: php
    :linenos:

    public function testAction()
    {
        $formManager = $this->serviceLocator->get('FormElementManager');
        $form = $formManager->get('Application\Form\CreateAlbum');
    }

Finally, to use your fieldset in a view you need to use the formCollection function.

.. code-block:: php
    :linenos:

    echo $this->form()->openTag($form);
    echo $this->formCollection($form->get('album'));
    echo $this->form()->closeTag();


Et voilà! The dependency will be automatically handled by the form element manager, and you don't need to create the 
``AlbumTable`` in your controller, transfer it to the form, which itself passes it over to the fieldset.
   
The specific case of initializers
---------------------------------

In the previous example, we explicitly defined the dependency in the constructor of the ``AlbumFieldset`` class.
However, in some cases, you may want to use an initializer (like ``Zend\ServiceManager\ServiceLocatorAwareInterface``) 
to inject a specific object to all your forms/fieldsets/elements.
   
The problem with initializers is that they are injected AFTER the construction of the object, which means that if you
need this dependency when you create elements, it won't be available yet. For instance, this example **won't work**:
   
.. code-block:: php
    :linenos:

    namespace Application\Form;

    use Album\Model;
    use Zend\Form\Fieldset;
    use Zend\ServiceManager\ServiceLocatorAwareInterface;
    use Zend\ServiceManager\ServiceLocatorInterface;

    class AlbumFieldset extends Fieldset implements ServiceLocatorAwareInterface
    {
        protected $serviceLocator;

        public function __construct()
        {   		
            // Here, $this->serviceLocator is null because it has not been
            // injected yet, as initializers are run after __construct
        }

        public function setServiceLocator(ServiceLocatorInterface $sl)
        {
            $this->serviceLocator = $sl;
        }

        public function getServiceLocator()
        {
            return $this->serviceLocator;
        }
    }
   
Thankfully, there is an easy workaround: every form element now implements the new interface 
``Zend\Stdlib\InitializableInterface``, that defines a single ``init()`` function. In the context of form elements, 
this ``init()`` function is automatically called once all the dependencies (including all initializers) are resolved. 
Therefore, the previous example can be rewritten as such:

.. code-block:: php
    :linenos:

    namespace Application\Form;

    use Album\Model;
    use Zend\Form\Fieldset;
    use Zend\ServiceManager\ServiceLocatorAwareInterface;
    use Zend\ServiceManager\ServiceLocatorInterface;

    class AlbumFieldset extends Fieldset implements ServiceLocatorAwareInterface
    {
        protected $serviceLocator;

        public function init()
        {   		
            // Here, we have $this->serviceLocator !!
        }

        public function setServiceLocator(ServiceLocatorInterface $sl)
        {
            $this->serviceLocator = $sl;
        }

        public function getServiceLocator()
        {
            return $this->serviceLocator;
        }
    }
