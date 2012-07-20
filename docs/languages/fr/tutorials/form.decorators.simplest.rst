.. _learning.form.decorators.simplest:

Les bases des décorateurs
=========================

.. _learning.form.decorators.simplest.decorator-overview:

Aperçu du pattern décorateur
----------------------------

Pour commencer, nous allons voir un peu de théorie sur `le pattern décorateur`_. Une technique consiste à
définir une interface commune que les objets originaux et les décorateurs implémentent ; les décorateurs ayant
comme dépendance les objets originaux, ils vont alors pouvoir redéfinir ou proxier les appels à leurs méthodes.
Voyons un peu de code afin de mieux comprendre :

.. code-block:: php
   :linenos:

   interface Window
   {
       public function isOpen();
       public function open();
       public function close();
   }

   class StandardWindow implements Window
   {
       protected $_open = false;

       public function isOpen()
       {
           return $this->_open;
       }

       public function open()
       {
           if (!$this->_open) {
               $this->_open = true;
           }
       }

       public function close()
       {
           if ($this->_open) {
               $this->_open = false;
           }
       }
   }

   class LockedWindow implements Window
   {
       protected $_window;

       public function __construct(Window $window)
       {
           $this->_window = $window;
           $this->_window->close();
       }

       public function isOpen()
       {
           return false;
       }

       public function open()
       {
           throw new Exception('Cannot open locked windows');
       }

       public function close()
       {
           $this->_window->close();
       }
   }

Nous créons un objet de type ``StandardWindow``, le passons au constructeur de ``LockedWindow``, et le
comportement de notre fenêtre a maintenant changé. Le point fort ici est que nous n'avons pas besoin
d'implémenter une fonctionnalité de verrou ("lock") dans l'objet de base (StandardWindow) -- le décorateur
s'occupe de cela. En plus, vous pouvez utiliser votre fenêtre décorée à la place de la fenêtre standard :
elles implémentent la même interface.

Une utilisation particulièrement pratique du pattern décorateur est pour tout ce qui concerne la représentation
des objets. Par exemple un objet "Personne" qui en lui-même n'a aucune représentation textuelle. Grâce au
pattern décorateur, vous pouvez créer un objet qui va agir comme une Personne mais qui pourra aussi représenter
textuellement cette Personne.

Dans cet exemple particulier, nous allons utiliser le `duck typing`_ plutôt qu'une interface explicite. Ceci
permet à notre implémentation d'être un peu plus fléxible tout en gardant l'utilisation de la décoration
intacte.

.. code-block:: php
   :linenos:

   class Person
   {
       public function setFirstName($name) {}
       public function getFirstName() {}
       public function setLastName($name) {}
       public function getLastName() {}
       public function setTitle($title) {}
       public function getTitle() {}
   }

   class TextPerson
   {
       protected $_person;

       public function __construct(Person $person)
       {
           $this->_person = $person;
       }

       public function __call($method, $args)
       {
           if (!method_exists($this->_person, $method)) {
               throw new Exception('Invalid method called on HtmlPerson: '
                   .  $method);
           }
           return call_user_func_array(array($this->_person, $method), $args);
       }

       public function __toString()
       {
           return $this->_person->getTitle() . ' '
               . $this->_person->getFirstName() . ' '
               . $this->_person->getLastName();
       }
   }

Dans cet exemple, nous passons une instance ``Person`` au constructeur de ``TextPerson``. Grâce à la surcharge
des méthodes, nous pouvons continuer d'appeler les méthodes de ``Person``-- affecter un nom, un prénom, ... --
mais nous pouvons en plus récupérer une représentation sous forme de chaîne grâce à ``__toString()``.

Cet exemple est proche du fonctionnement interne des décorateurs de ``Zend_Form``. La différence est qu'au lieu
que le décorateur n'encapsule l'objet initial, c'est l'objet élément qui possède en lui un ou plusieurs
decorateurs à qui il passe lui-même pour effectuer le rendu visuel. Les décorateurs peuvent ainsi accéder à
l'élément et en créer une représentation.

.. _learning.form.decorators.simplest.first-decorator:

Créer votre premier décorateur
------------------------------

Les décorateurs de ``Zend_Form`` implémentent tous, ``Zend_Form_Decorator_Interface``. Cette interface permet de
régler les options du décorateur, enregistrer en lui l'élément ainsi qu'effectuer le rendu. Une classe de base,
``Zend_Form_Decorator_Abstract``, propose une implémentation de cette logique de base dont vous aurez besoin, à
l'exception du rendu que vous devrez définir.

Imaginons une situation dans laquelle nous souhaitons simplement rendre un élément comme un tag html text avec un
libellé (label). Juste la base, nous verrons plus tard la gestion des erreurs et les éventuels autres tags html.
Un tel décorateur pourrait ressembler à ça :

.. code-block:: php
   :linenos:

   class My_Decorator_SimpleInput extends Zend_Form_Decorator_Abstract
   {
       protected $_format = '<label for="%s">%s</label><input id="%s" name="%s" type="text" value="%s"/>';

       public function render($content)
       {
           $element = $this->getElement();
           $name    = htmlentities($element->getFullyQualifiedName());
           $label   = htmlentities($element->getLabel());
           $id      = htmlentities($element->getId());
           $value   = htmlentities($element->getValue());

           $markup  = sprintf($this->_format, $name, $label, $id, $name, $value);
           return $markup;
       }
   }

Créons un élément qui utilise ce décorateur :

.. code-block:: php
   :linenos:

   $decorator = new My_Decorator_SimpleInput();
   $element   = new Zend_Form_Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'decorators' => array($decorator),
   ));

Le visuel de cet élément donne :

.. code-block:: html
   :linenos:

   <label for="bar[foo]">Foo</label>
   <input id="bar-foo" name="bar[foo]" type="text" value="test"/>

Nous pourrions aussi ranger cette classe dans un dossier de librairie, il faut alors informer l'élément du chemin
vers ce dossier, et ensuite faire référence au décorateur comme "SimpleInput" :

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'prefixPath' => array('decorator' => array(
           'My_Decorator' => 'path/to/decorators/',
       )),
       'decorators' => array('SimpleInput'),
   ));

Ceci permet de partager du code entre projets et ouvre aussi la possibilité d'étendre dans le futur les classes
rangées.

Dans le chapitre suivant, nous allons voir comment combiner les décorateurs afin de créer un affichage par
morceaux (composite).



.. _`le pattern décorateur`: http://en.wikipedia.org/wiki/Decorator_pattern
.. _`duck typing`: http://en.wikipedia.org/wiki/Duck_typing
