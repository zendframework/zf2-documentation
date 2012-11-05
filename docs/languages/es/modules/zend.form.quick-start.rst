.. EN-Revision: none
.. _zend.form.quickstart:

Inicio rápido a Zend_Form
=========================

Esta guía rápida pretende cubrir los fundamentos para crear, validar y presentar formularios usando ``Zend_Form``

.. _zend.form.quickstart.create:

Creando un objeto formulario
----------------------------

Crear un objeto de formulario es muy simple: solo instancíe ``Zend_Form``

.. code-block:: php
   :linenos:

   $form = new Zend_Form;

Para casos de uso avanzados, es posible desee crear una subclase de ``Zend_Form``, pero para formularios simples,
puede programar la creación de un formulario usando un objeto ``Zend_Form``

Si desea especificar el action y method del formulario (siempre buenas ideas), puede hacer uso de los accesos
``setAction()`` y ``setMethod()``:

.. code-block:: php
   :linenos:

   $form->setAction('/resource/process')
        ->setMethod('post');

El código de arriba establece el action del formulario a la *URL* parcial "/resource/process" y como method *HTTP*
POST. Esto se mostrará en la presentación final.

Usted puede establecer atributos *HTML* adicionales para la etiqueta ``<form>`` mediante el uso de los métodos
setAttrib() o setAttribs(). Por ejemplo, si desea especificar el id establezca el atributo "id":

.. code-block:: php
   :linenos:

   $form->setAttrib('id', 'login');

.. _zend.form.quickstart.elements:

Añadir elementos al formulario
------------------------------

Un formulario no es nada sin sus elementos. ``Zend_Form`` contiene de manera predeterminada algunos elementos que
generan *XHTML* vía auxiliares ``Zend_View``. Son los siguientes:

- button

- checkbox (o varios checkboxes a la vez con multiCheckbox)

- hidden

- image

- password

- radio

- reset

- select (tanto regulares como de multi-selección)

- submit

- text

- textarea

Tiene dos opciones para añadir elementos a un formulario; puede instanciar elementos concretos y pasarlos como
objetos, o simplemente puede pasar el tipo de elemento y ``Zend_Form`` instaciará por usted un objeto del tipo
correspondiente.

Algunos ejemplos:

.. code-block:: php
   :linenos:

   // Instanciando un elemento y pasandolo al objeto form:
   $form->addElement(new Zend\Form_Element\Text('username'));

   // Pasando el tipo de elemento del formulario al objeto form:
   $form->addElement('text', 'username');

De manera predeterminada, éstos no tienen validadores o filtros. Esto significa que tendrá que configurar sus
elementos con un mínimo de validadores, y potencialmente filtros. Puede hacer esto (a) antes de pasar el elemento
al formulario, (b) vía opciones de configuración pasadas cuando crea un elemento a través de ``Zend_Form``, o
(c) recuperar el elemento del objeto form y configurándolo posteriormente.

Veamos primero la creación de validadores para la instancia de un elemento concreto. Puede pasar objetos
``Zend\Validate\*`` o el nombre de un validador para utilizar:

.. code-block:: php
   :linenos:

   $username = new Zend\Form_Element\Text('username');

   // Pasando un objeto Zend\Validate\*:
   $username->addValidator(new Zend\Validate\Alnum());

   // Pasando el nombre de un validador:
   $username->addValidator('alnum');

Cuando se utiliza esta segunda opción, si el constructor del validador acepta argumentos, se pueden pasar en un
array como tercer parámetro:

.. code-block:: php
   :linenos:

   // Pasando un patrón
   $username->addValidator('regex', false, array('/^[a-z]/i'));

(El segundo parámetro se utiliza para indicar si el fallo debería prevenir la ejecución de validadores
posteriores o no; por defecto, el valor es ``FALSE``.)

Puede también desear especificar un elemento como requerido. Esto puede hacerse utilizando un método de acceso o
pasando una opción al crear el elemento. En el primer caso:

.. code-block:: php
   :linenos:

   // Hace este elemento requerido:
   $username->setRequired(true);

Cuando un elemento es requerido, un validador 'NotEmpty' (NoVacio) es añadido a la parte superior de la cadena de
validaciones, asegurando que el elemento tenga algún valor cuando sea requerido.

Los filtros son registrados básicamente de la misma manera que los validadores. Para efectos ilustrativos, vamos a
agregar un filtro para poner en minúsculas el valor final:

.. code-block:: php
   :linenos:

   $username->addFilter('StringtoLower');

Entonces, la configuración final de nuestro elemento queda así:

.. code-block:: php
   :linenos:

   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]/'))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // o, de manera más compacta:
   $username->addValidators(array('alnum',
           array('regex', false, '/^[a-z]/i')
       ))
       ->setRequired(true)
       ->addFilters(array('StringToLower'));

Tan simple como esto, realizarlo para cada uno de los elementos del formulario puede resultar un poco tedioso.
Intentemos la opción (b) arriba mencionada. Cuando creamos un nuevo elemento utilizando
``Zend\Form\Form::addElement()`` como fábrica, opcionalmente podemos pasar las opciones de configuración. Éstas
pueden incluir validadores y los filtros que se van a utilizar. Por lo tanto, para hacer todo lo anterior
implícitamente, intente lo siguiente:

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array(
       'validators' => array(
           'alnum',
           array('regex', false, '/^[a-z]/i')
       ),
       'required' => true,
       'filters'  => array('StringToLower'),
   ));

.. note::

   Si encuentra que está asignando elementos con las mismas opciones en varios lugares, podría considerar crear
   su propia subclase de ``Zend\Form\Element`` y utilizar ésta; a largo plazo le permitirá escribir menos.

.. _zend.form.quickstart.render:

Generar un formulario
---------------------

Generar un formulario es simple. La mayoría de los elementos utilizan un auxiliar de ``Zend_View`` para generarse
a sí mismos, por lo tanto necesitan un objeto vista con el fin de generarse. Además, tiene dos opciones: usar el
método render() del formulario, o simplemente mostrarlo con echo.

.. code-block:: php
   :linenos:

   // Llamando a render()  explicitamente, y pasando un objeto vista opcional:
   echo $form->render($view);

   // Suponiendo un objeto vista ha sido previamente establecido vía setView():
   echo $form;

De manera predeterminada, ``Zend_Form`` y ``Zend\Form\Element`` intentarán utilizar el objeto vista inicializado
en el ``ViewRenderer``, lo que significa que no tendrá que establecer la vista manualmente cuando use el *MVC* de
Zend Framework. Generar un formulario en un script vista es tan simple como:

.. code-block:: php
   :linenos:

   <?php echo $this->form

Detrás del telón, ``Zend_Form`` utiliza "decoradores" (decorators) para generar la salida. Estos decoradores
pueden reemplazar, añadir o anteponer contenido, y tienen plena introspección al elemento que les es pasado. Como
resultado, puede combinar múltiples decoradores para lograr efectos personalizados. Predeterminadamente,
``Zend\Form\Element`` actualmente combina cuatro decoradores para obtener su salida; la configuración sería como
sigue:

.. code-block:: php
   :linenos:

   $element->addDecorators(array(
       'ViewHelper',
       'Errors',
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));

(Donde <HELPERNAME> es el nombre de un view helper que utilizar, y varía según el elemento)

Lo anterior crea una salida como la siguiente:

.. code-block:: html
   :linenos:

   <dt><label for="username" class="required">Username</dt>
   <dd>
       <input type="text" name="username" value="123-abc" />
       <ul class="errors">
           <li>'123-abc' has not only alphabetic and digit characters</li>
           <li>'123-abc' does not match against pattern '/^[a-z]/i'</li>
       </ul>
   </dd>

(Aunque no con el mismo formato.)

Puede cambiar los decoradores usados para un elemento si desea tener diferente salida; véase la sección sobre
decoradores para mayor información.

El propio formulario simplemente itera sobre los elementos y los cubre en un <form> HTML. El action y method que
proporcionó cuando definió el formulario se pasan a la etiqueta ``<form>``, como cualquier atributo que
establezca vía ``setAttribs()`` y familia.

Elementos son desplegados en el orden en el que fueron registrados, o, si el elemento contienen un atributo de
orden, ese orden será utilizado. Usted puede fijar el orden de un elemento usando:

.. code-block:: php
   :linenos:

   $element->setOrder(10);

O, cuando crea un elemento, pasándolo como una opción:

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array('order' => 10));

.. _zend.form.quickstart.validate:

Comprobar si un formulario es válido
------------------------------------

Después que un formulario es enviado, necesitará comprobar y ver si pasa las validaciones. Cada elemento es
valuado contra los datos provistos; si una clave no está presente y el campo fue marcado como requerido, la
validación se ejecuta contra un valor ``NULL``.

¿De dónde provienen los datos?. Puede usar ``$_POST`` o ``$_GET``, o cualquier otra fuente de datos que tenga a
mano (solicitud de un servicio web, por ejemplo):

.. code-block:: php
   :linenos:

   if ($form->isValid($_POST)) {
       // ¡Correcto!
   } else {
       // ¡Fallo!
   }

Con solicitudes *AJAX*, a veces puede ignorar la validación de un solo elemento, o grupo de elementos.
``isValidPartial()`` validará parcialmente el formulario. A diferencia de ``isValid()``, que como sea, si alguna
clave no esta presente, no ejecutará las validaciones para ese elemento en particular.

.. code-block:: php
   :linenos:

   if ($form->isValidPartial($_POST)) {
       // de los elementos presentes, todos pasaron las validaciones
   } else {
       // uno u más elementos probados no pasaron las validaciones
   }

Un método adicional, ``processAjax()``, puede también ser usado para validar formularios parciales. A diferencia
de ``isValidPartial()``, regresa una cadena en formato *JSON*-formatted conteniendo mensajes de error en caso de
fallo.

Asumiendo que sus validaciones han pasado, ahora puede obtener los valores filtrados:

.. code-block:: php
   :linenos:

   $values = $form->getValues();

Si necesita los valores sin filtrar en algún punto, utilice:

.. code-block:: php
   :linenos:

   $unfiltered = $form->getUnfilteredValues();

If you on the other hand need all the valid and filtered values of a partially valid form, you can call:

.. code-block:: php
   :linenos:

   $values = $form->getValidValues($_POST);

.. _zend.form.quickstart.errorstatus:

Obteniendo el estado de error
-----------------------------

Entonces, ¿su formulario no es válido? En la mayoría de los casos, simplemente puede generar el formulario
nuevamente y los errores se mostrarán cuando se usen los decoradores predeterminados:

.. code-block:: php
   :linenos:

   if (!$form->isValid($_POST)) {
       echo $form;

       // o asigne al objeto vista y genere una vista...
       $this->view->form = $form;
       return $this->render('form');
   }

Si quiere inspeccionar los errores, tiene dos métodos. ``getErrors()`` regresa una matriz asociativa de nombres /
códigos de elementos (donde códigos es una matriz de códigos de error). ``getMessages()`` regresa una matriz
asociativa de nombres / mensajes de elementos (donde mensajes es una matriz asociativa de pares código de error /
mensaje de error). Si un elemento no tiene ningún error, no será incluido en la matriz.

.. _zend.form.quickstart.puttingtogether:

Poniendo todo junto
-------------------

Construyamos un simple formulario de login. Necesitaremos elementos que representen:

- usuario

- contraseña

- Botón de ingreso

Para nuestros propósitos, vamos a suponer que un usuario válido cumplirá con tener solo caracteres
alfanuméricos, comenzar con una letra, tener una longitud mínima de 6 caracteres y una longitud máxima de 20
caracteres; se normalizarán en minúsculas. Las contraseñas deben tener un mínimo de 6 caracteres. Cuando se
procese vamos simplemente a mostrar el valor, por lo que puede permanecer inválido.

Usaremos el poder de la opciones de configuración de ``Zend_Form`` para crear el formulario:

.. code-block:: php
   :linenos:

   $form = new Zend\Form\Form();
   $form->setAction('/user/login')
        ->setMethod('post');

   // Crea un y configura el elemento username
   $username = $form->createElement('text', 'username');
   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]+/'))
            ->addValidator('stringLength', false, array(6, 20))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // Crea y configura el elemento password:
   $password = $form->createElement('password', 'password');
   $password->addValidator('StringLength', false, array(6))
            ->setRequired(true);

   // Añade los elementos al formulario:
   $form->addElement($username)
        ->addElement($password)
        // uso de addElement() como fábrica para crear el botón 'Login':
        ->addElement('submit', 'login', array('label' => 'Login'));

A continuación, vamos a crear un controlador para manejar esto:

.. code-block:: php
   :linenos:

   class UserController extends Zend\Controller\Action
   {
       public function getForm()
       {
           // crea el formulario como se indicó arriba
           return $form;
       }

       public function indexAction()
       {
           // genera user/form.phtml
           $this->view->form = $this->getForm();
           $this->render('form');
       }

       public function loginAction()
       {
           if (!$this->getRequest()->isPost()) {
               return $this->_forward('index');
           }
           $form = $this->getForm();
           if (!$form->isValid($_POST)) {
               // Falla la validación; Se vuelve a mostrar el formulario
               $this->view->form = $form;
               return $this->render('form');
           }

           $values = $form->getValues();
           // ahora intenta y autentica...
       }
   }

Y un script para la vista que muestra el formulario:

.. code-block:: php
   :linenos:

   <h2>Please login:</h2>
   <?php echo $this->form

Como notará en el código del controlador, hay más trabajo por hacer: mientras la información enviada sea
válida, necesitará todavía realizar la autenticación usando ``Zend_Auth``, por ejemplo.

.. _zend.form.quickstart.config:

Usando un objeto Zend_Config
----------------------------

Todas las clases ``Zend_Form`` son configurables mediante ``Zend_Config``; puede incluso pasar un objeto al
constructor o pasarlo a través de ``setConfig()``. Veamos cómo podemos crear el formulario anterior usando un
archivo *INI*. Primero, vamos a seguir las recomendaciones, y colocaremos nuestras configuraciones dentro de
secciones reflejando su objetivo y y enfocándonos en la sección 'development'. A continuación, pondremos en una
sección de configuración para el controlador dado ('user'), y una clave para el formulario ('login'):

.. code-block:: ini
   :linenos:

   [development]
   ; metainformación general del formulario
   user.login.action = "/user/login"
   user.login.method = "post"

   ; elemento username
   user.login.elements.username.type = "text"
   user.login.elements.username.options.validators.alnum.validator = "alnum"
   user.login.elements.username.options.validators.regex.validator = "regex"
   user.login.elements.username.options.validators.regex.options.pattern = "/^[a-z]/i"
   user.login.elements.username.options.validators.strlen.validator = "StringLength"
   user.login.elements.username.options.validators.strlen.options.min = "6"
   user.login.elements.username.options.validators.strlen.options.max = "20"
   user.login.elements.username.options.required = true
   user.login.elements.username.options.filters.lower.filter = "StringToLower"

   ; elemento password
   user.login.elements.password.type = "password"
   user.login.elements.password.options.validators.strlen.validator = "StringLength"
   user.login.elements.password.options.validators.strlen.options.min = "6"
   user.login.elements.password.options.required = true

   ; elemento submit
   user.login.elements.submit.type = "submit"

Entonces puede pasarlo al constructor del formulario:

.. code-block:: php
   :linenos:

   $config = new Zend\Config\Ini($configFile, 'development');
   $form   = new Zend\Form\Form($config->user->login);

y el formulario entero será definido.

.. _zend.form.quickstart.conclusion:

Conclusión
----------

Esperamos que después de este pequeño tutorial sea capaz de descubrir el poder y flexibilidad de ``Zend_Form``.
Continúe leyendo para profundizar más en el tema.


