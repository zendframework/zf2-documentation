.. _zend.form.advanced-use-of-forms:

Advanced use of forms
=====================

Starting from Zend Framework 2.1, forms elements are created using the service manager through the use of a plugin manager, as it was for view helpers, controller plugins, filters… This new feature has a number of benefits, especially when you need to handle complex dependencies in form/fieldsets. This section describes all the benefits of this new architecture in ZF 2.1.

.. _zend.form.advanced-use-of-forms.short-names:

Short names
-----------

The first advantage of pulling form elements from the service manager is that now you can use short names to create new elements through the factory. Therefore, this code:

.. code-block:: php
   :linenos:

   $form->add(array(
   		'type' => 'Zend\Form\Element\Email'
   		'name' => 'email'
   ));
   
can now be replaced by:

.. code-block:: php
   :linenos:

   $form->add(array(
   		'type' => 'Email'
   		'name' => 'email'
   ));

Each element provided out-of-the-box by Zend Framework 2 support this natively, so you can now make your initialization code more compact.

.. _zend.form.advanced-use-of-forms.create-your-own-elements:

Create your own elements
------------------------

Similar to how you would add a view helper, you can easily create your own form elements, and add them to the ``Zend\Form\FormElementManager`` plugin manager to be able to set dependencies or use the short name. For this, Zend Framework 2.1 adds a new feature interface through the ``getFormElementConfig`` function.

First, create your own element:

.. code-block:: php
   :linenos:
   
   namespace Application\Form\Element;
   
   use Zend\Form\Element;

   class CustomElement extends Element
   {
   		// Define your element…
   }

Then, just adds it to the plugin manager, in your ``Module.php`` class:

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
   					'custom' => 'Application\Form\Element\CustomElement'
   				)
   			);
   		}
   }
   
Of course, you can use a factory instead of an invokable in order to handle dependencies in your elements/fieldsets/forms.

Then, you can use your custom element like any other elements:

.. code-block:: php
   :linenos:

   $form->add(array(
   		'type' => 'Custom' // Note that it's not case-sensitive !
   		'name' => 'myCustomElement'
   ));
   
As a consequence of this, you can easily override any standard Zend elements if they do not fit your needs. For instance, if you want to create your own Email element instead of the built-in one, you can simply create your element, and adding it to the form element config with the same key as the element you want to replace:

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
   
Now, whenever you will create an element whose ``type`` is 'Email', it will create your own Email element instead of the built-in one (if you want to be able to use both the built-in one and your own one, you can still provide the FQCN of the element, for instance ``Zend\Form\Element\Email``).

However, in order for this to work, there is one thing to change in your code. If you want to be able to use your own elements (as well as to handle dependencies, as we will see later), you must create your forms using the service manager. For instance, if you have the following form, that is using our ``custom`` element that we defined earlier:

.. code-block:: php
   :linenos:
   
   namespace Application\Form;
   
   use Zend\Form\Form;
   
   class MyForm extends Form
   {
   		public function __construct()
   		{
   			$this->add(
   				array(
   					'name' => 'foo',
   					'type' => 'Custom'
   				)
   			);
   		}
   }
   
In your controller (or in your service, or whenever you want to create a form), directly instantiating your form this way won't work:

.. code-block:: php
   :linenos:
   
   public function testAction()
   {
   		$form = new \Application\Form\MyForm();
   }

This code will work if you use only built-in elements, however, as we added a custom element, we altered the plugin manager configuration, and the form won't be aware of this modified plugin manager, unless we create it using the service manager. Hopefully, this is easy, as you need to replace the previous code by:

.. code-block:: php
   :linenos:
   
   public function testAction()
   {
   		$formManager = $this->serviceLocator->get('FormElementManager');
   		$form 		 = $formManager->get('Application\Form\MyForm');
   }

As you can see here, we first get the form manager (that we modified in our Module.php class), and create the form by specifying the fully qualified class name of the form. Please note that you don't need to add `Application\Form\MyForm` to the `invokables` array. If it is not specified, the form manager will just instantiate it directly.

In short, to create your own form elements (or even reusable fieldsets !) and be able to use them in your form using the short-name notation, you need to:

1. Create your element (like you did before).
2. Add it to the form element manager by defining the `getFormElementConfig`, exactly the same way you do it form view helpers, controller plugins…
3. Create your form through the form element manager instead of directly instantiate it.


.. _zend.form.advanced-use-of-forms.handling-dependencies:

Handling dependencies
---------------------

One of the most complex thing in Zend Framework 2.0 when using forms was to handle dependencies. For instance, a very frequent use case was a form that creates a fieldset, that itself need an access to the database to populate a select element. Previously, in such a situation, you would either rely on the Registry using the Singleton pattern, or either you would "transfer" the dependency from controller to form, and to form to fieldset (and even to fieldset to another fieldset if you have a complex form). This was ugly and not easy to use. Hopefully, service manager solves this use case in an elegant manner.

For instance, let's say that a form create a fieldset called AlbumFieldset:

.. code-block:: php
   :linenos:
   
   namespace Application\Form;
   
   use Zend\Form\Form;
   
   class CreateAlbum extends Form
   {
   		public function __construct()
   		{
   			$this->add(array(
   				'name' => 'album',
   				'type' => 'AlbumFieldset'
   			));
   		}
   }

Let's now create the `AlbumFieldset` that has a dependency with an `AlbumTable` class that allows you to fetch albums from database.

.. code-block:: php
   :linenos:
   
   namespace Application\Form;
   
   use Album\Model;
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
an element in your Module.php class:

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
   					}
   				)
   			);
   		}
   }
   
Finally, create your form using the form element manager instead of directly
instantiate it:
   
.. code-block:: php
   :linenos:
   
   public function testAction()
   {
   		$formManager = $this->serviceLocator->get('FormElementManager');
   		$form 		 = $formManager->get('Application\Form\CreateAlbum');
   }

Et voilà ! The dependency will be automatically handled by the form element manager, and you don't need to create the `AlbumTable` in your controller, giving it to the form, which itself gives it to the fieldset.
   
### Specific case of initializers

In the previous example, we explicitely defined the dependency in the controller of the `AlbumFieldset` class. However, in some cases, you may want to use an initializer (like `Zend\ServiceManager\ServiceLocatorAwareInterface`) to inject a specific object to all your forms/fieldsets/elements.
   
The problem with initializers is that they are injected AFTER the construction of the object, which means that if you need this dependency when you create elements, it won't be available yet. For instance, this example won't work:
   
.. code-block:: php
   :linenos:
   
   namespace Application\Form;
   
   use Album\Model;
   use Zend\Form\Fieldset;
   use Zend\ServiceManager\ServiceLocatorAwareInterface;
   
   class AlbumFieldset extends Fieldset implements ServiceLocatorAwareInterface
   {
   		protected $serviceLocator;
   		
   		public function __construct()
   		{   		
   			// Here, $this->serviceLocator is null because it has not been
   			// injected yet, as initializers are run after __construct
   		}
   		
   		public function setServiceLocator(ServiceLocator $sl)
   		{
   			$this->serviceLocator = $sl;
   		}
   		
   		public function getServiceLocator()
   		{
   			return $this->serviceLocator;
   		}
   }
   
Hopefully, there is an easy workaround: every form elements now implements the new interface `Zend\Stdlib\InitializableInterface`, that defines a single `init` function. In the context of form elements, this `init` function is automatically called once all the dependencies (including the initializers) are resolved. Therefore, the previous example can be rewritten the following way:

.. code-block:: php
   :linenos:
   
   namespace Application\Form;
   
   use Album\Model;
   use Zend\Form\Fieldset;
   use Zend\ServiceManager\ServiceLocatorAwareInterface;
   
   class AlbumFieldset extends Fieldset implements ServiceLocatorAwareInterface
   {
   		protected $serviceLocator;
   		
   		public function init()
   		{   		
   			// Here, we have $this->serviceLocator !!
   		}
   		
   		public function setServiceLocator(ServiceLocator $sl)
   		{
   			$this->serviceLocator = $sl;
   		}
   		
   		public function getServiceLocator()
   		{
   			return $this->serviceLocator;
   		}
   }
