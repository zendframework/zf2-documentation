.. _zend.form.advanced:

Uso avanzado de Zend_Form
=========================

``Zend_Form`` tiene una funcional riqueza, muchas de ellas dirigidas a expertos desarroladores. Este capítulo esta
dirigido a documentar algunas de las funcionalidades con ejemplos y casos de uso.

.. _zend.form.advanced.arrayNotation:

Notación de array
-----------------

A muchos desarroladores web experimentados les gusta agrupar elementos relacionados de formulario usando notación
de array en los nombres del elemento. Por ejemplo, si se tienen dos direcciones que se desean capturar, un envío y
una dirección de facturación, se pueden tener elementos idénticos; agrupándolos en un array se puede asegurar
que son capturados por separado. Nótese el siguiente formulario por ejemplo:

.. code-block:: html
   :linenos:

   <form>
       <fieldset>
           <legend>Shipping Address</legend>
           <dl>
               <dt><label for="recipient">Ship to:</label></dt>
               <dd><input name="recipient" type="text" value="" /></dd>

               <dt><label for="address">Address:</label></dt>
               <dd><input name="address" type="text" value="" /></dd>

               <dt><label for="municipality">City:</label></dt>
               <dd><input name="municipality" type="text" value="" /></dd>

               <dt><label for="province">State:</label></dt>
               <dd><input name="province" type="text" value="" /></dd>

               <dt><label for="postal">Postal Code:</label></dt>
               <dd><input name="postal" type="text" value="" /></dd>
           </dl>
       </fieldset>

       <fieldset>
           <legend>Billing Address</legend>
           <dl>
               <dt><label for="payer">Bill To:</label></dt>
               <dd><input name="payer" type="text" value="" /></dd>

               <dt><label for="address">Address:</label></dt>
               <dd><input name="address" type="text" value="" /></dd>

               <dt><label for="municipality">City:</label></dt>
               <dd><input name="municipality" type="text" value="" /></dd>

               <dt><label for="province">State:</label></dt>
               <dd><input name="province" type="text" value="" /></dd>

               <dt><label for="postal">Postal Code:</label></dt>
               <dd><input name="postal" type="text" value="" /></dd>
           </dl>
       </fieldset>

       <dl>
           <dt><label for="terms">I agree to the Terms of Service</label></dt>
           <dd><input name="terms" type="checkbox" value="" /></dd>

           <dt></dt>
           <dd><input name="save" type="submit" value="Save" /></dd>
       </dl>
   </form>

En este ejemplo, la facturación y la dirección de envío contienen algunos campos idénticos, eso significa que
uno puede sobrescribir al otro. Nosotros podemos resolver esta solución usando una notación de array:

.. code-block:: html
   :linenos:

   <form>
       <fieldset>
           <legend>Shipping Address</legend>
           <dl>
               <dt><label for="shipping-recipient">Ship to:</label></dt>
               <dd><input name="shipping[recipient]" id="shipping-recipient"
                   type="text" value="" /></dd>

               <dt><label for="shipping-address">Address:</label></dt>
               <dd><input name="shipping[address]" id="shipping-address"
                   type="text" value="" /></dd>

               <dt><label for="shipping-municipality">City:</label></dt>
               <dd><input name="shipping[municipality]" id="shipping-municipality"
                   type="text" value="" /></dd>

               <dt><label for="shipping-province">State:</label></dt>
               <dd><input name="shipping[province]" id="shipping-province"
                   type="text" value="" /></dd>

               <dt><label for="shipping-postal">Postal Code:</label></dt>
               <dd><input name="shipping[postal]" id="shipping-postal"
                   type="text" value="" /></dd>
           </dl>
       </fieldset>

       <fieldset>
           <legend>Billing Address</legend>
           <dl>
               <dt><label for="billing-payer">Bill To:</label></dt>
               <dd><input name="billing[payer]" id="billing-payer"
                   type="text" value="" /></dd>

               <dt><label for="billing-address">Address:</label></dt>
               <dd><input name="billing[address]" id="billing-address"
                   type="text" value="" /></dd>

               <dt><label for="billing-municipality">City:</label></dt>
               <dd><input name="billing[municipality]" id="billing-municipality"
                   type="text" value="" /></dd>

               <dt><label for="billing-province">State:</label></dt>
               <dd><input name="billing[province]" id="billing-province"
                   type="text" value="" /></dd>

               <dt><label for="billing-postal">Postal Code:</label></dt>
               <dd><input name="billing[postal]" id="billing-postal"
                   type="text" value="" /></dd>
           </dl>
       </fieldset>

       <dl>
           <dt><label for="terms">I agree to the Terms of Service</label></dt>
           <dd><input name="terms" type="checkbox" value="" /></dd>

           <dt></dt>
           <dd><input name="save" type="submit" value="Save" /></dd>
       </dl>
   </form>

En el ejemplo anterior, obtenemos direcciones separadas. En el formulario sometido, ahora tenemos tres elementos,
'guardar' elemento para someterlo, y dos arrays, 'envio' y 'cuenta', cada uno con llaves para los variados
elementos.

``Zend_Form`` intenta automatizar este proceso con los :ref:`subformularios <zend.form.forms.subforms>`. Por
defecto, los subformularios son generados usando la notación de array como se muestra en el anterior formulario
*HTML* listado completo con identificadores. El nombre del array esta basado en el nombre del subformulario, con
las llaves basados en los elementos contenidos en el subformulario. Los subformularios pueder ser anidados
arbitrariamente, y esto puede crear arrays anidados que reflejan la estructura. Adicionalmente, las validaciones
rutinarias en ``Zend_Form`` respetan la estructura del array, asegurando que sus formularios sean validados
correctamente, no importa cuan arbitrariamente anidados esten los subformularios. No se necesita hacer nada para
beneficiarse; éste comportamiento esta activo por defecto.

Adicionalmente, existen facilidades que le permiten activar condicionalmente la notación de un array, así como
también especificar el específico array al cual un elemento o coleccion pertenece:

- ``Zend_Form::setIsArray($flag)``: Definiendo la bandera a ``TRUE``, se puede indicar que un formulario entero
  debería ser tratado como un array. Por defecto, el nombre del formulario será usado como el nombre del array, a
  no ser que ``setElementsBelongTo()`` haya sido llamado. Si el formulario no tiene un nombre específico, o si
  ``setElementsBelongTo()`` no ha sido definido, esta bandera será ignorada (como cuando no hay nombre del array
  al cual los elementos puedan pertenecer).

  Se deberá determinar si un formulario está siendo tratado como un array usando el accesor ``isArray()``.

- ``Zend_Form::setElementsBelongTo($array)``: Usando este método, se puede especificar el nombre de un array al
  cual todos los elementos del formulario pertenecen. Se puede determinar el nombre usando el accesor
  ``getElementsBelongTo()``.

Adicionalmente, a nivel del elemento, se pueden especificar elementos individuales que puedan pertenecer a arrays
particulares usando el método ``Zend_Form_Element::setBelongsTo()``. Para descubrir el valor que tiene -- sea o no
sea definido explícitamente o implícitamente a través del formulario -- se puede usar el accesor
``getBelongsTo()``.

.. _zend.form.advanced.multiPage:

Formularios Multi-Página
------------------------

Actualmente, los formularios multi-página no están oficialmente soportados en ``Zend_Form``; sin embargo, la
mayoría del soporte para implementarlos está disponible y puede ser utilizado con algunos retoques.

La clave para crear fomrularios multi-página es utilizar subformularios, pero solo para mostrar un solo
subformulario por página. Esto le permite someter un solo subformulario a la vez y validarlo, pero no procesar el
formulario hasta que todos los subformularios esten completos.

.. _zend.form.advanced.multiPage.registration:

.. rubric:: Ejemplo de formulario de registro

Vamos a usar un formulario de registro como ejemplo. Para nuestros propósitos, queremos capturar el nombre del
usuario y la contraseña en la primera página, después la información del usuario -- nombre, apellido, y
ubicación -- y finalmente permitirles decidir qué lista de correo, si desean suscribirse.

Primero, vamos a crear nuestro propio formulario, y definir varios subformularios dentro del mismo:

.. code-block:: php
   :linenos:

   class My_Form_Registration extends Zend_Form
   {
       public function init()
       {
           // Crea un subformulario usuario: username y password
           $user = new Zend_Form_SubForm();
           $user->addElements(array(
               new Zend_Form_Element_Text('username', array(
                   'required'   => true,
                   'label'      => 'Username:',
                   'filters'    => array('StringTrim', 'StringToLower'),
                   'validators' => array(
                       'Alnum',
                       array('Regex',
                             false,
                             array('/^[a-z][a-z0-9]{2,}$/'))
                   )
               )),

               new Zend_Form_Element_Password('password', array(
                   'required'   => true,
                   'label'      => 'Password:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       'NotEmpty',
                       array('StringLength', false, array(6))
                   )
               )),
           ));

           // Crea un subformulario de datos demográficos : given name, family name, y
           // location
           $demog = new Zend_Form_SubForm();
           $demog->addElements(array(
               new Zend_Form_Element_Text('givenName', array(
                   'required'   => true,
                   'label'      => 'Given (First) Name:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('Regex',
                             false,
                             array('/^[a-z][a-z0-9., \'-]{2,}$/i'))
                   )
               )),

               new Zend_Form_Element_Text('familyName', array(
                   'required'   => true,
                   'label'      => 'Family (Last) Name:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('Regex',
                             false,
                             array('/^[a-z][a-z0-9., \'-]{2,}$/i'))
                   )
               )),

               new Zend_Form_Element_Text('location', array(
                   'required'   => true,
                   'label'      => 'Your Location:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('StringLength', false, array(2))
                   )
               )),
           ));

           // Crea un sub fomulario de correos
           $listOptions = array(
               'none'        => 'No lists, please',
               'fw-general'  => 'Zend Framework General List',
               'fw-mvc'      => 'Zend Framework MVC List',
               'fw-auth'     => 'Zend Framwork Authentication and ACL List',
               'fw-services' => 'Zend Framework Web Services List',
           );
           $lists = new Zend_Form_SubForm();
           $lists->addElements(array(
               new Zend_Form_Element_MultiCheckbox('subscriptions', array(
                   'label'        =>
                       'Which lists would you like to subscribe to?',
                   'multiOptions' => $listOptions,
                   'required'     => true,
                   'filters'      => array('StringTrim'),
                   'validators'   => array(
                       array('InArray',
                             false,
                             array(array_keys($listOptions)))
                   )
               )),
           ));

           // Adjuntando los subformlarios al formulario principal
           $this->addSubForms(array(
               'user'  => $user,
               'demog' => $demog,
               'lists' => $lists
           ));
       }
   }

Note que no hay botones de enviar, y que ni hemos hecho nada con los decoradores de subformularios -- lo que
significa que por defecto serán desplegados como campos. Necesitaremos hacer algo con ellos mientras desplegamos
cada subformulario individualmente, y añadir botones de manera que podamos procesarlos realmente -- el cual
requerira las propiedades acción y método. Vamos a añadir algunos andamios a nuestras clases para proveer esa
información:

.. code-block:: php
   :linenos:

   class My_Form_Registration extends Zend_Form
   {
       // ...

       /**
        * Prepara un subformulario para mostrar
        *
        * @param  string|Zend_Form_SubForm $spec
        * @return Zend_Form_SubForm
        */
       public function prepareSubForm($spec)
       {
           if (is_string($spec)) {
               $subForm = $this->{$spec};
           } elseif ($spec instanceof Zend_Form_SubForm) {
               $subForm = $spec;
           } else {
               throw new Exception('Invalid argument passed to ' .
                                   __FUNCTION__ . '()');
           }
           $this->setSubFormDecorators($subForm)
                ->addSubmitButton($subForm)
                ->addSubFormActions($subForm);
           return $subForm;
       }

       /**
        * Add form decorators to an individual sub form
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function setSubFormDecorators(Zend_Form_SubForm $subForm)
       {
           $subForm->setDecorators(array(
               'FormElements',
               array('HtmlTag', array('tag' => 'dl',
                                      'class' => 'zend_form')),
               'Form',
           ));
           return $this;
       }

       /**
        * Añade un Boton de envio(submit) a cada subformulario
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function addSubmitButton(Zend_Form_SubForm $subForm)
       {
           $subForm->addElement(new Zend_Form_Element_Submit(
               'save',
               array(
                   'label'    => 'Save and continue',
                   'required' => false,
                   'ignore'   => true,
               )
           ));
           return $this;
       }

       /**
        * Añade el method y el action a cada subformulario
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function addSubFormActions(Zend_Form_SubForm $subForm)
       {
           $subForm->setAction('/registration/process')
                   ->setMethod('post');
           return $this;
       }
   }

Siguiente, necesitamos añadir andamios a nuestro action controller, y tener varias consideraciones. Primero,
necesitamos asegurar que persiste la información del formulario entre los requerimientos, de esa manera determinar
cuándo terminar. Segundo, necesitamos alguna lógica para determinar qué segmentos del formulario han sido
sometidos, y qué subformulario mostrar de acuerdo a la información. Usaremos ``Zend_Session_Namespace`` para
persistir la información, el cual nos ayudará a responder la pregunta de qué formulario someter.

Vamos a crear nuestro controlador, y añadir un método para recuperar un formulario instanciado:

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       protected $_form;

       public function getForm()
       {
           if (null === $this->_form) {
               $this->_form = new My_Form_Registration();
           }
           return $this->_form;
       }
   }

Ahora, vamos a añadir algunas funcionalidades para determinar qué formulario mostrar. Básicamente, hasta que el
formulario entero sea considerado válido, necesitamos continuar mostrando segmentos de formulario. Adicionalmente,
queremos asegurar que están en un orden particular: usuario, demog, y después las listas. Podemos determinar qué
información ha sido sometida verificando nuestro session namespace para claves particulares representando cada
subformulario.

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       protected $_namespace = 'RegistrationController';
       protected $_session;

       /**
        * Obtiene el namespace de la sesión que estamos usando
        *
        * @return Zend_Session_Namespace
        */
       public function getSessionNamespace()
       {
           if (null === $this->_session) {
               $this->_session =
                   new Zend_Session_Namespace($this->_namespace);
           }

           return $this->_session;
       }

       /**
        * Obtiene la lista de Formularios que ya están almacenados en la sesión
        *
        * @return array
        */
       public function getStoredForms()
       {
           $stored = array();
           foreach ($this->getSessionNamespace() as $key => $value) {
               $stored[] = $key;
           }

           return $stored;
       }

       /**
        * Obtiene la lista de todos los subformularios disponibles
        *
        * @return array
        */
       public function getPotentialForms()
       {
           return array_keys($this->getForm()->getSubForms());
       }

       /**
        * ¿Qué subformulario se envio?
        *
        * @return false|Zend_Form_SubForm
        */
       public function getCurrentSubForm()
       {
           $request = $this->getRequest();
           if (!$request->isPost()) {
               return false;
           }

           foreach ($this->getPotentialForms() as $name) {
               if ($data = $request->getPost($name, false)) {
                   if (is_array($data)) {
                       return $this->getForm()->getSubForm($name);
                       break;
                   }
               }
           }

           return false;
       }

       /**
        * Obtiene el siguiente subformulario para mostrarlo
        *
        * @return Zend_Form_SubForm|false
        */
       public function getNextSubForm()
       {
           $storedForms    = $this->getStoredForms();
           $potentialForms = $this->getPotentialForms();

           foreach ($potentialForms as $name) {
               if (!in_array($name, $storedForms)) {
                   return $this->getForm()->getSubForm($name);
               }
           }

           return false;
       }
   }

El método de arriba nos permite usar notaciones tal como "``$subForm = $this->getCurrentSubForm();``" recuperar el
actual subformulario para la validación, o "``$next = $this->getNextSubForm();``" obtener el siguiente para
mostrar.

Ahora, vamos a encontrar la manera para procesar y mostrar varios subformularios. Podemos usar
``getCurrentSubForm()`` para determinar si algún subformulario ha sido sometido (los valores de retorno ``FALSE``
indican que ninguno ha sido desplegado o sometido), y ``getNextSubForm()`` recupera el formulario que mostrar.
Podemos entonces usar el método del formulario ``prepareSubForm()`` para asegurar que el formulario está listo
para mostrar.

Cuando tenemos un formulario sometido, podemos validar el subformulario, y luego verificar si el formulario entero
es válido ahora. Para hacer esas tareas, necesitamos métodos adicionales que aseguren que la información
sometida es añadida a la sesión, y que cuando validamos el formulario entero, nosotros validamos contra todos los
segmentos de la sesión:

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       /**
        * ¿Es válido el subformulario?
        *
        * @param  Zend_Form_SubForm $subForm
        * @param  array $data
        * @return bool
        */
       public function subFormIsValid(Zend_Form_SubForm $subForm,
                                      array $data)
       {
           $name = $subForm->getName();
           if ($subForm->isValid($data)) {
               $this->getSessionNamespace()->$name = $subForm->getValues();
               return true;
           }

           return false;
       }

       /**
        * ¿Es válido todo el formulario?
        *
        * @return bool
        */
       public function formIsValid()
       {
           $data = array();
           foreach ($this->getSessionNamespace() as $key => $info) {
               $data[$key] = $info;
           }

           return $this->getForm()->isValid($data);
       }
   }

Ahora que tenemos el trabajo preparado, vamos a construir las acciones para este controlador. Necesitaremos una
página de destino para el formulario, y luego una acción 'process' para procesar el formulario.

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       public function indexAction()
       {
           // volver a mostrar la página actual, o mostrar el "siguiente"
           // (primer) subformulario
           if (!$form = $this->getCurrentSubForm()) {
               $form = $this->getNextSubForm();
           }
           $this->view->form = $this->getForm()->prepareSubForm($form);
       }

       public function processAction()
       {
           if (!$form = $this->getCurrentSubForm()) {
               return $this->_forward('index');
           }

           if (!$this->subFormIsValid($form,
                                      $this->getRequest()->getPost())) {
               $this->view->form = $this->getForm()->prepareSubForm($form);
               return $this->render('index');
           }

           if (!$this->formIsValid()) {
               $form = $this->getNextSubForm();
               $this->view->form = $this->getForm()->prepareSubForm($form);
               return $this->render('index');
           }

           // Formulario Válido!
           // Render information in a verification page
           $this->view->info = $this->getSessionNamespace();
           $this->render('verification');
       }
   }

Como se ha notado, el código actual para procesar el formulario es relativamente simple. Verificamos si tenemos un
subformulario actual sometido y si no, retornamos a la página de destino. Si tenemos un subformulario,
intentaremos validarlo, volviéndolo a mostrar si tiene fallos. Si el subformulario es válido, entonces
verificaremos si el formulario es válido, lo que debería indicar que hemos terminado; si no, mostraremos el
siguiente segmento del formulario. Finalmente, mostraremos una página de verificación con el contenido de la
sesión.

Los scripts de vista son muy simples:

.. code-block:: php
   :linenos:

   <?php // registration/index.phtml ?>
   <h2>registro</h2>
   <?php echo  $this->form ?>

   <?php // registration/verification.phtml ?>
   <h2>Gracias por Registrarse!</h2>
   <p>
       Aquí está la información que nos ha proporcionado:
   </p>

   <?php
   // Tienen que construir esto con los items que estan almacenados en los namespaces
   // de la sesión
   foreach ($this->info as $info):
       foreach ($info as $form => $data): ?>
   <h4><?php echo  ucfirst($form) ?>:</h4>
   <dl>
       <?php foreach ($data as $key => $value): ?>
       <dt><?php echo  ucfirst($key) ?></dt>
       <?php if (is_array($value)):
           foreach ($value as $label => $val): ?>
       <dd><?php echo  $val ?></dd>
           <?php endforeach;
          else: ?>
       <dd><?php echo  $this->escape($value) ?></dd>
       <?php endif;
       endforeach; ?>
   </dl>
   <?php endforeach;
   endforeach

Próximas novedades de Zend Framework incluirán componentes para hacer formularios multi páginas mas simples,
abstrayendo la sesión y la lógica de orden. Mientras tanto, el ejemplo de arriba debería servir como guia
razonable para alcanzar esta tarea en su web.


