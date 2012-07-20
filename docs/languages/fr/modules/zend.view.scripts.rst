.. _zend.view.scripts:

Scripts de vue
==============

Une fois que le contrôleur a assigné les variables et appelé ``render()``, ``Zend_View`` inclue le script de vue
requis et l'exécute "à l'intérieur" de la portée de l'instance ``Zend_View``. Donc dans vos scripts de vue, les
références à ``$this`` pointent en fait sur l'instance ``Zend_View`` elle-même.

Les variables assignées à la vue depuis le contrôleur lui sont référées comme des propriétés de l'instance.
Par exemple, si le contrôleur a assigné une variable "quelquechose", vous vous référerez à cette variable par
*$this->quelquechose* dans le script de vue. (Cela vous permet de garder une trace pour savoir quelles valeurs ont
été assignées au script, et lesquelles sont internes au script lui même.)

Pour rappel, voici l'exemple de script issu de l'introduction de ce chapitre sur ``Zend_View``.

.. code-block:: php
   :linenos:

   <?php if ($this->livres): ?>

       <!-- La table des livres -->
       <table>
           <tr>
               <th>Auteur</th>
               <th>Titre</th>
           </tr>

           <?php foreach ($this->livres as $cle => $livre): ?>
           <tr>
               <td><?php echo $this->escape($livre['auteur']) ?></td>
               <td><?php echo $this->escape($livre['titre']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>Aucun livre à afficher</p>

   <?php endif; ?>

.. _zend.view.scripts.escaping:

Échapper la sortie
------------------

Une des tâches les plus importantes à effectuer dans un script de vue est de s'assurer que la sortie est
correctement échappée ; de plus ceci permet d'éviter les attaques de type cross-site scripting (XSS). A moins
que vous n'utilisiez une fonction, une méthode, ou une aide qui gère l'échappement, vous devriez toujours
échapper les variables lors de l'affichage.

``Zend_View`` a une méthode appelée ``escape()`` qui se charge de l'échappement.

.. code-block:: php
   :linenos:

   // mauvaise pratique d'affichage
   echo $this->variable;

   // bonne pratique d'affichage
   echo $this->escape($this->variable);

Par défaut, la méthode ``escape()`` utilise la fonction *PHP* ``htmlspecialchar()`` pour l'échappement.
Cependant, en fonction de votre environnement, vous souhaitez peut-être un échappement différent. Utilisez la
méthode ``setEscape()`` au niveau du contrôleur pour dire à ``Zend_View`` quelle méthode de rappel ("callback")
elle doit utiliser.

.. code-block:: php
   :linenos:

   // crée une instance Zend_View
   $view = new Zend_View();

   // spécifie qu'il faut utiliser htmlentities
   // comme rappel d'échappement
   $view->setEscape('htmlentities');

   // ou spécifie qu'il faut utiliser une méthode statique
   // comme rappel d'échappement
   $view->setEscape(array('UneClasse', 'nomDeMethode'));

   // ou alors une méthode d'instance
   $obj = new UneClasse();
   $view->setEscape(array($obj, 'nomDeMethode'));

   // et ensuite effectue le rendu de la vue
   echo $view->render(...);

La fonction ou méthode de rappel doit prendre la valeur à échapper dans le premier paramètre, et tous les
autres paramètres devraient être optionnels.

.. _zend.view.scripts.templates:

Utiliser des systèmes de gabarit (template) alternatifs
-------------------------------------------------------

Bien que *PHP* lui-même un moteur de gabarit puissant, beaucoup de développeurs pensent que c'est beaucoup trop
puissant ou complexe pour les graphistes/intégrateurs et veulent utiliser un moteur de template alternatif.
``Zend_View`` fournit deux mécanismes pour faire cela, le premier à travers les scripts de vues, le second en
implémentant ``Zend_View_Interface``.

.. _zend.view.scripts.templates.scripts:

Système de gabarit utilisant les scripts de vues
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Un script de vue peut être utilisé pour instancier et manipuler un objet de gabarit séparé, comme un gabarit de
type PHPLIB. Le script de vue pour ce type d'activité pourrait ressembler à ceci :

.. code-block:: php
   :linenos:

   include_once 'template.inc';
   $tpl = new Template();

   if ($this->livres) {
       $tpl->setFile(array(
           "listelivre" => "listelivre.tpl",
           "chaquelivre" => "chaquelivre.tpl",
       ));

       foreach ($this->livres as $cle => $livre) {
           $tpl->set_var('auteur', $this->escape($livre['auteur']);
           $tpl->set_var('titre', $this->escape($livre['titre']);
           $tpl->parse("livre", "chaquelivre", true);
       }

       $tpl->pparse("output", "listelivre");
   } else {
       $tpl->setFile("nobooks", "pasdelivres.tpl")
       $tpl->pparse("output", "pasdelivres");
   }

Et ceci pourrait être les fichiers de gabarits correspondants :

.. code-block:: html
   :linenos:

   <!-- listelivre.tpl -->
   <table>
       <tr>
           <th>Auteur</th>
           <th>Titre</th>
       </tr>
       {livres}
   </table>

   <!-- chaquelivre.tpl -->
       <tr>
           <td>{auteur}</td>
           <td>{title}</td>
       </tr>

   <!-- pasdelivres.tpl -->
   <p>Aucun livre à afficher</p>

.. _zend.view.scripts.templates.interface:

Système de gabarit utilisant Zend_View_Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Certains peuvent trouver plus facile de simplement fournir un moteur de gabarit compatible avec ``Zend_View``.
``Zend_View_Interface`` définit l'interface de compatibilité minimale nécessaire :

.. code-block:: php
   :linenos:

   /**
    * Retourne l'objet moteur de gabarit actuel
    */
   public function getEngine();

   /**
    * Affecte le dossier des scripts de gabarits
    */
   public function setScriptPath($path);

   /**
    * Règle un chemin de base pour toutes les ressources de vue
    */
   public function setBasePath($path, $prefix = 'Zend_View');

   /**
    * Ajoute un chemin de base supplémentaire pour les ressources de vue
    */
   public function addBasePath($path, $prefix = 'Zend_View');

   /**
    * Récupère les chemins actuels vers les ressources de vue
    */
   public function getScriptPaths();

   /**
    * Méthode à surcharger pour affecter les variables des gabarits
    * en tant que propriétés de l'objet
    */
   public function __set($key, $value);
   public function __isset($key);
   public function __unset($key);

   /**
    * Affectation manuelle de variable de gabarit, ou possibilité
    * d'affecter des variables en masse.
    */
   public function assign($spec, $value = null);

   /**
    * Efface toutes les variables du gabarit déjà affectées
    */
   public function clearVars();

   /**
    * Effectue le rendu du gabarit nommé $name
    */
   public function render($name);

En utilisant cette interface, il devient relativement facile d'encapsuler un moteur de gabarit tiers comme une
classe compatible ``Zend_View``. Comme par exemple, le code suivant est une encapsulation potentielle de Smarty :

.. code-block:: php
   :linenos:

   class Zend_View_Smarty implements Zend_View_Interface
   {
       /**
        * Objet Smarty
        * @var Smarty
        */
       protected $_smarty;

       /**
        * Constructeur
        *
        * @param string $tmplPath
        * @param array $extraParams
        * @return void
        */
       public function __construct($tmplPath = null,
                                   $extraParams = array())
       {
           $this->_smarty = new Smarty;

           if (null !== $tmplPath) {
               $this->setScriptPath($tmplPath);
           }

           foreach ($extraParams as $key => $value) {
               $this->_smarty->$key = $value;
           }
       }

       /**
        * Retourne l'objet moteur de gabarit
        *
        * @return Smarty
        */
       public function getEngine()
       {
           return $this->_smarty;
       }

       /**
        * Affecte le dossier des scripts de gabarits
        *
        * @param string $path Le répertoire à affecter au path
        * @return void
        */
       public function setScriptPath($path)
       {
           if (is_readable($path)) {
               $this->_smarty->template_dir = $path;
               return;
           }

           throw new Exception('Répertoire fourni invalide');
       }

       /**
        * Récupère le dossier courant des gabarits
        *
        * @return string
        */
       public function getScriptPaths()
       {
           return array($this->_smarty->template_dir);
       }

       /**
        * Alias pour setScriptPath
        *
        * @param string $path
        * @param string $prefix Unused
        * @return void
        */
       public function setBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Alias pour setScriptPath
        *
        * @param string $path
        * @param string $prefix Unused
        * @return void
        */
       public function addBasePath($path, $prefix = 'Zend_View')
       {
           return $this->setScriptPath($path);
       }

       /**
        * Affectation une variable au gabarit
        *
        * @param string $key Le nom de la variable
        * @param mixed $val La valeur de la variable
        * @return void
        */
       public function __set($key, $val)
       {
           $this->_smarty->assign($key, $val);
       }

       /**
        * Autorise le fonctionnement du test avec empty() and isset()
        *
        * @param string $key
        * @return boolean
        */
       public function __isset($key)
       {
           return (null !== $this->_smarty->get_template_vars($key));
       }

       /**
        * Autorise l'effacement de toutes les variables du gabarit
        *
        * @param string $key
        * @return void
        */
       public function __unset($key)
       {
           $this->_smarty->clear_assign($key);
       }

       /**
        * Affectation de variables au gabarit
        *
        * Autorise une affectation simple (une clé => une valeur)
        * OU
        * le passage d'un tableau (paire de clé => valeur)
        * à affecter en masse
        *
        * @see __set()
        * @param string|array $spec Le type d'affectation à utiliser
                                   (clé ou tableau de paires clé => valeur)
        * @param mixed $value (Optionel) Si vous assignez une variable nommée,
                                         utilisé ceci comme valeur
        * @return void
        */
       public function assign($spec, $value = null)
       {
           if (is_array($spec)) {
               $this->_smarty->assign($spec);
               return;
           }

           $this->_smarty->assign($spec, $value);
       }

       /**
        * Effacement de toutes les variables affectées
        *
        * Efface toutes les variables affectées à Zend_View
        * via {@link assign()} ou surcharge de propriété
        * ({@link __get()}/{@link __set()}).
        *
        * @return void
        */
       public function clearVars()
       {
           $this->_smarty->clear_all_assign();
       }

       /**
        * Exécute le gabarit et retourne l'affichage
        *
        * @param string $name Le gabarit à exécuter
        * @return string L'affichage
        */
       public function render($name)
       {
           return $this->_smarty->fetch($name);
       }
   }

Dans cet exemple, vous instanciez la classe ``Zend_View_Smarty`` au lieu de ``Zend_View``, et vous l'utilisez de la
même façon :

.. code-block:: php
   :linenos:

   //Exemple 1a. Dans l'initView() de l'initializer.
   $view = new Zend_View_Smarty('/chemin/vers/les/templates');
   $viewRenderer =
       Zend_Controller_Action_HelperBroker::getStaticHelper('ViewRenderer');
   $viewRenderer->setView($view)
                ->setViewBasePathSpec($view->_smarty->template_dir)
                ->setViewScriptPathSpec(':controller/:action.:suffix')
                ->setViewScriptPathNoControllerSpec(':action.:suffix')
                ->setViewSuffix('tpl');

   //Exemple 1b. L'utilisation dans le contrôleur d'action reste la même
   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           $this->view->book   = 'Zend PHP 5 Certification Study Guide';
           $this->view->author = 'Davey Shafik and Ben Ramsey'
       }
   }

   //Example 2. Initialisation de la vue dans le contrôleur d'action
   class FooController extends Zend_Controller_Action
   {
       public function init()
       {
           $this->view   = new Zend_View_Smarty('/path/to/templates');
           $viewRenderer = $this->_helper->getHelper('viewRenderer');
           $viewRenderer->setView($this->view)
                        ->setViewBasePathSpec($view->_smarty->template_dir)
                        ->setViewScriptPathSpec(':controller/:action.:suffix')
                        ->setViewScriptPathNoControllerSpec(':action.:suffix')
                        ->setViewSuffix('tpl');
       }
   }


