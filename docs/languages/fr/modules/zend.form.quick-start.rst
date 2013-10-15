.. EN-Revision: none
.. _zend.form.quickstart:

Zend_Form démarrage rapide
==========================

Ce guide rapide couvre les bases de la création, de la validation, et du rendu des formulaires ``Zend_Form``.

.. _zend.form.quickstart.create:

Créer un objet de formulaire
----------------------------

Instanciez simplement un objet ``Zend_Form``\  :

.. code-block:: php
   :linenos:

   $form = new Zend_Form;

Pour des usages avancés, vous voudriez probablement dériver ``Zend_Form``, mais pour les formulaires simples,
vous pouvez créez un formulaire depuis une instance de ``Zend_Form``.

Vous pouvez spécifier (c'est une bonne idée) l'action et la méthode d'envoi du formulaire grâce à
``setAction()`` et ``setMethod()``\  :

.. code-block:: php
   :linenos:

   $form->setAction('/resource/process')
        ->setMethod('post');

Le code ci-dessus indique au formulaire d'être envoyé vers l'URL "/resource/process" avec la méthode *HTTP*
POST. Ceci va impacter le rendu du formulaire (la balise *<form>*).

Il est possible d'assigner les attributs HTML supplémentaires à la balise *<form>* via la méthode
``setAttrib()`` ou encore ``setAttribs()``. Par exemple, indiquons un attribut "id" au formulaire :

.. code-block:: php
   :linenos:

   $form->setAttrib('id', 'login');

.. _zend.form.quickstart.elements:

Ajouter des éléments au formulaire
----------------------------------

Un formulaire ne sert à rien sans éléments. Le composant ``Zend_Form`` est fourni avec un ensemble d'éléments
qui rendent du code *XHTML* via les aides de ``Zend_View``. Voici ces aides :

- button

- checkbox (ou plusieurs checkboxes avec multiCheckbox)

- hidden

- image

- password

- radio

- reset

- select (régulier ou à selection multiple)

- submit

- text

- textarea

Vous avez 2 manières de procéder pour ajouter les éléments au formulaire : instanciez vous même les objets des
éléments, ou passer le type d'élément à ``Zend_Form``, qui va alors créer le bon objet pour vous.

Quelques exemples :

.. code-block:: php
   :linenos:

   // Ajout d'un objet élément :
   $form->addElement(new Zend\Form\Element\Text('username'));

   // Passage d'un texte décrivant le futur objet élément, à Zend_Form :
   $form->addElement('text', 'username');

Par défaut, ces éléments n'ont ni validateurs, ni filtres. Vous devrez donc ajoutez des validateurs et/ou des
filtres, manuellement. Ceci est possible soit (a) avant de passer l'élément au formulaire, (b) via les options de
configuration passés lors de la création de l'élément, ou (c) en récupérant l'objet déjà enregistré,
depuis le formulaire, et en le configurant ensuite.

Voyons comment passer un validateur à un élément dont nous créons l'objet. On peut passer soit l'objet
``Zend\Validate\*``, soit une chaîne le décrivant :

.. code-block:: php
   :linenos:

   $username = new Zend\Form\Element\Text('username');

   // Passage d'un objet Zend\Validate\*:
   $username->addValidator(new Zend\Validate\Alnum());

   // Passage du nom du validateur:
   $username->addValidator('alnum');

En utilisant la technique de passage par le nom, vous pouvez ajouter un tableau d'options à passer au constructeur
de l'objet validateur. Ceci se fait en troisième paramètre :

.. code-block:: php
   :linenos:

   // Passage d'options au validateur
   $username->addValidator('regex', false, array('/^[a-z]/i'));

(Le second paramètre permet d'indiquer au validateur s'il doit briser la chaîne de validation ou non. Par
défaut, ``FALSE``: ce n'est donc pas le cas.)

Vous pouvez avoir besoin de spécifier qu'un élément est requis. Ceci peut être fait en utilisant un accesseur
ou en passant une option à la création de l'élément. Voici un exemple :

.. code-block:: php
   :linenos:

   // Cet élément est requis:
   $username->setRequired(true);

Lorsqu'un élément est requis, un validateur "NotEmpty" lui est ajouté, sur le dessus de sa pile de validateurs.

La gestion des filtres est très semblable à celle des validateurs. Voyons comment ajouter un filtre qui retourne
la donnée en minuscules :

.. code-block:: php
   :linenos:

   $username->addFilter('StringtoLower');

Finalement, la configuration complète de l'élément pourra ressembler à cela :

.. code-block:: php
   :linenos:

   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]/'))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // ou, de manière plus compacte:
   $username->addValidators(array('alnum',
           array('regex', false, '/^[a-z]/i')
       ))
       ->setRequired(true)
       ->addFilters(array('StringToLower'));

Aussi simple que cela puisse paraître, cela peut très vite devenir fastidieux de répéter ces opérations sur
tous les éléments du formulaire. Reprenons le cas (b) d'au dessus : lorsque l'on crée un élément,
``Zend\Form\Form::addElement()`` agit comme une fabrique et on peut lui passer des options de configuration. Par
exemple, des validateurs ou des filtres. Essayons ceci :

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

   Si vous vous apercevez que vous créez des éléments basés sur les mêmes options, étendre
   ``Zend\Form\Element`` peut devenir une bonne option. Votre nouvelle classe configurera directement vos objets.

.. _zend.form.quickstart.render:

Rendre (visuellement) un formulaire
-----------------------------------

Rendre un formulaire est très simple. La plupart des éléments nécessitent les aides de vue ``Zend_View`` pour
être rendus. Ils ont donc besoin d'un objet de vue. Pour rendre un formulaire, appelez sa méthode ``render()`` ou
faites un *echo* devant l'objet.

.. code-block:: php
   :linenos:

   // Appel explicite de render() :
   echo $form->render($view);

   // Supposant que setView() avec passage d'un objet Zend_View a été appelée avant :
   echo $form;

Par défaut, ``Zend_Form`` et les ``Zend\Form\Element`` vont essayer de récupérer l'objet de vue depuis l'aide
d'action *ViewRenderer*, ce qui signifie que vous n'aurez pas besoin de spécifier un objet de vue manuellement si
vous utilisez le système *MVC* de Zend Framework. Pour rendre un formulaire dans une vue *MVC*, un simple *echo*
suffit :

.. code-block:: php
   :linenos:

   <?php echo $this->form ?>

Techniquement, ``Zend_Form`` utilise des "décorateurs" pour effectuer le rendu visuel. Ces décorateurs peuvent
remplacer le contenu, ou le placer avant ou après. Ils peuvent aussi introspecter l'élément qui leur est passé.
Ainsi, vous pouvez chaîner plusieurs décorateurs pour utiliser des effets visuels. Par défaut,
``Zend\Form\Element`` combine quatre décorateurs pour s'afficher :

.. code-block:: php
   :linenos:

   $element->addDecorators(array(
       'ViewHelper',
       'Errors',
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));

(Où <HELPERNAME> est le nom de l'aide de vue à utiliser, qui varie selon l'élément à rendre.)

Les décorateurs par défaut (rappelés ci-dessus), produisent le rendu suivant :

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

(Le formatage peut un peu changer.)

Vous pouvez changer les décorateurs utilisés par un élément si vous voulez avoir un visuel différent ; voyez
la section sur les décorateurs pour plus d'informations.

Le formulaire boucle sur ses éléments et entoure leur rendu d'une balise HTML *<form>*. Cette balise prend en
compte la méthode, l'action, et les éventuels attributs passés via ``setAttribs()``.

Les éléments sont bouclés dans l'ordre dans lequel ils sont ajoutés, ou, si votre élément possède un
attribut "order", celui-ci sera alors utilisé pour gérer sa place dans la pile des éléments :

.. code-block:: php
   :linenos:

   $element->setOrder(10);

Ou encore, à la création de l'élément via ``addElement()``\  :

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array('order' => 10));

.. _zend.form.quickstart.validate:

Vérifier qu'un formulaire est valide
------------------------------------

Après l'envoi du formulaire, il faut vérifier les valeurs que contiennent ses éléments. Tous les validateurs de
chaque élément sont donc interrogés. Si l'élément était marqué comme requis et que l'élément ne reçoit
aucune donnée, les validateurs suivants agiront sur une valeur ``NULL``.

D'où proviennent les données ? Vous pouvez utiliser ``$_POST`` ou ``$_GET``, ou n'importe quelle source de
données (service Web par exemple) :

.. code-block:: php
   :linenos:

   if ($form->isValid($_POST)) {
       // succès!
   } else {
       // echec!
   }

Avec des requêtes *AJAX*, il arrive que l'on ait besoin de ne valider qu'un élément, ou un groupe d'élément.
``isValidPartial()`` validera un formulaire partiel. Contrairement à ``isValid()``, si une valeur est absente, les
autres validateurs ne seront pas interrogés :

.. code-block:: php
   :linenos:

   if ($form->isValidPartial($_POST)) {
       // Tous les éléments présents dans $_POST ont passé la validation
   } else {
       // un ou plusieurs éléments présent dans $_POST ont échoué
   }

La méthode ``processAjax()`` peut aussi être utilisée pour valider partiellement un formulaire. Contrairement à
``isValidPartial()``, cette méthode retournera les messages d'erreur de validation au format *JSON*.

En supposant que les validateurs aient passé, vous pouvez dès lors récupérer les valeurs filtrées depuis les
éléments :

.. code-block:: php
   :linenos:

   $values = $form->getValues();

Si vous désirez les valeurs non filtrées, utilisez :

.. code-block:: php
   :linenos:

   $unfiltered = $form->getUnfilteredValues();

Si d'un autre côté, vous ne souhaitez que les valeurs filtrées valides d'un formulaire partiellement valide,
vous pouvez appeler :

.. code-block:: php
   :linenos:

   $values = $form->getValidValues($_POST);

.. _zend.form.quickstart.errorstatus:

Les statuts d'erreur
--------------------

Votre formulaire a échoué à l'envoi ? Dans la plupart des cas, vous voudrez rendre à nouveau le formulaire,
mais avec les messages d'erreur affichés :

.. code-block:: php
   :linenos:

   if (!$form->isValid($_POST)) {
       echo $form;

       // ou en assignant un objet de vue (cas non-MVC typiquement)
       $this->view->form = $form;
       return $this->render('form');
   }

Si vous voulez inspecter les erreurs, 2 méthodes s'offrent à vous. ``getErrors()`` retourne un tableau associatif
avec en clé le nom de l'élément et en valeur un tableau de codes d'erreurs. ``getMessages()`` retourne un
tableau associatif avec en clé le nom de l'élément, et en valeur un tableau de messages d'erreurs
(code=>message). Tout élément ne comportant pas d'erreur ne sera pas inclus dans le tableau.

.. _zend.form.quickstart.puttingtogether:

Assembler le tout ensemble
--------------------------

Créons un formulaire de d'authentification. Il aura besoin d'élément représentant :

- un nom

- un mot de passe

- un bouton d'envoi

Pour notre exemple, imaginons un nom composé de caractères alphanumériques uniquement. Le nom commencera par une
lettre, et devra faire entre 6 et 20 caractères de long, qui seront normalisés en lettres minuscules. Les mots de
passe feront 6 caractères minimum.

Nous allons utiliser la puissance de ``Zend_Form`` pour configurer le formulaire et effectuer le rendu :

.. code-block:: php
   :linenos:

   $form = new Zend\Form\Form();
   $form->setAction('/user/login')
        ->setMethod('post');

   // élément nom :
   $username = $form->createElement('text', 'username');
   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]+/'))
            ->addValidator('stringLength', false, array(6, 20))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // élément mot de passe :
   $password = $form->createElement('password', 'password');
   $password->addValidator('StringLength', false, array(6))
            ->setRequired(true);

   // Ajout des éléments au formulaire
   $form->addElement($username)
        ->addElement($password)
        // addElement() agit comme une fabrique qui crée un bouton 'Login'
        ->addElement('submit', 'login', array('label' => 'Login'));

Il nous faut à présent un contrôleur pour gérer tout cela :

.. code-block:: php
   :linenos:

   class UserController extends Zend\Controller\Action
   {
       public function getForm()
       {
           // Créer le formulaire comme décrit ci-dessus
           return $form;
       }

       public function indexAction()
       {
           // rend user/form.phtml
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
               // Validation en echec
               $this->view->form = $form;
               return $this->render('form');
           }

           $values = $form->getValues();
           // les valeurs sont récupérées
       }
   }

Le script de vue pour afficher le formulaire :

.. code-block:: php
   :linenos:

   <h2>Identifiez vous:</h2>
   <?php echo $this->form ?>

Comme vous le voyez sur le code du contrôleur, il reste du travail à faire une fois le formulaire validé. Par
exemple, utiliser ``Zend_Auth`` pour déclencher un processus d'identification.

.. _zend.form.quickstart.config:

Utiliser un objet Zend_Config
-----------------------------

Toutes les classes du composant ``Zend_Form`` sont configurables au moyen d'un objet ``Zend_Config``; vous pouvez
passer un objet ``Zend_Config`` au constructeur ou via la méthode ``setConfig()``. Voyons comment créer le
formulaire ci-dessus, au moyen d'un fichier *INI*. Tout d'abord, nous nous baserons sur une section "developement",
et nos instructions devront être imbriquées afin de refléter la configuration. Ensuite nous utiliserons un
espace de nom "user" correspondant au contrôleur, puis un "login" concernant le formulaire (ceci permet de ranger
les données correctement dans le fichier *INI*) :

.. code-block:: ini
   :linenos:

   [development]
   ; informations générales du formulaire
   user.login.action = "/user/login"
   user.login.method = "post"

   ; element username
   user.login.elements.username.type = "text"
   user.login.elements.username.options.validators.alnum.validator = "alnum"
   user.login.elements.username.options.validators.regex.validator = "regex"
   user.login.elements.username.options.validators.regex.options.pattern = "/^[a-z]/i"
   user.login.elements.username.options.validators.strlen.validator = "StringLength"
   user.login.elements.username.options.validators.strlen.options.min = "6"
   user.login.elements.username.options.validators.strlen.options.max = "20"
   user.login.elements.username.options.required = true
   user.login.elements.username.options.filters.lower.filter = "StringToLower"

   ; element password
   user.login.elements.password.type = "password"
   user.login.elements.password.options.validators.strlen.validator = "StringLength"
   user.login.elements.password.options.validators.strlen.options.min = "6"
   user.login.elements.password.options.required = true

   ; element submit
   user.login.elements.submit.type = "submit"

Le constructeur du formulaire ressemblera alors à ceci :

.. code-block:: php
   :linenos:

   $config = new Zend\Config\Ini($configFile, 'development');
   $form   = new Zend\Form\Form($config->user->login);

et tout le formulaire sera défini.

.. _zend.form.quickstart.conclusion:

Conclusion
----------

Vous êtes maintenant capable de libérer la puissance de ``Zend_Form``. Continuez de lire les chapitres suivants
pour utiliser ce composant en profondeur !


