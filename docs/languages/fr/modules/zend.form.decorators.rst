.. _zend.form.decorators:

Créer un visuel personnalisé en utilisant Zend_Form_Decorator
=============================================================

Rendre visuellement un objet de formulaire est complètement optionnel -- il n'est pas obligatoire d'utiliser la
méthode ``render()`` de ``Zend_Form``. Cependant, si vous l'utilisez, alors des décorateurs sont utilisés pour
rendre les différents objets du formulaire.

Un nombre arbitraire de décorateurs peut être attaché à chaque objet du formulaire (élément, groupe
d'affichage, sous-formulaires ou encore l'objet formulaire lui-même) ; cependant seul un décorateur par type peut
être attaché. Les décorateurs sont appelés dans l'ordre dans lequel ils ont été enregistrés. En fonction du
décorateur en question, celui-ci peut remplacer le contenu qui lui est passé, ou alors le faire précédé ou
suivre.

La configuration du décorateur est effectuée via son constructeur ou sa méthode ``setOptions()``. Lorsque vous
créez des décorateurs au travers de méthodes comme ``addDecorator()``, alors sa configuration doit être passée
en tant que tableau à ladite méthode. Ces options de configuration peuvent être utilisées pour indiquer le
placement du décorateur, le séparateur inter-éléments ou toute autre option acceptable.

Avant le rendu d'un décorateur, au travers de sa méthode ``render()``, l'objet sur lequel il agit lui est passé
en argument, grâce à ``setElement()``, et ainsi le décorateur peut piloter l'élément sur lequel il agit. Ceci
permet de créer des décorateurs qui n'agissent que sur un petit paramètre de l'élément auquel ils sont
rattachés, comme le label, les messages d'erreur, etc... En chaînant des décorateurs qui rendent chacun
individuellement un petit morceau d'un élément, vous pouvez créer une mise en forme complexe représentant
l'objet (élément) dans son intégralité.

.. _zend.form.decorators.operation:

Configuration
-------------

Pour configurer un décorateur, passez un tableau d'options ou un objet ``Zend_Config`` à son constructeur. Aussi,
un tableau peut être passé à ``setOptions()``, ou un objet ``Zend_Config`` à ``setConfig()``.

Options de base:

- *placement*\  : le placement peut être 'append' ou 'prepend' (insensible à la casse), et indique sur le
  contenu passé à ``render()`` doit être ajouté après ou avant, respectivement. Dans le cas où le décorateur
  remplace le contenu, cette directive de placement est ignorée. La directive par défaut est 'append'.

- *separator*\  : le séparateur est utilisé entre le contenu passé à ``render()`` et le nouveau contenu
  généré par le décorateur, ou encore entre les éléments rendus (par exemple FormElements utilise le
  séparateur entre chaque objet rendu). Dans le cas où le décorateur remplace son contenu, cette option est
  ignorée. Par défaut, elle vaut ``PHP_EOL``.

L'interface des décorateurs spécifie les méthodes pour agir sur les options. Les voici :

- ``setOption($key, $value)``\  : affecte une option.

- ``getOption($key)``\  : récupère une option.

- ``getOptions()``\  : récupère toutes les options.

- ``removeOption($key)``\  : supprime une option.

- ``clearOptions()``\  : supprime toutes les options.

Les décorateurs sont destinés à agir avec tous les objets du formulaire, ``Zend_Form``, ``Zend_Form_Element``,
``Zend_Form_DisplayGroup``, et toute classe en dérivant. La méthode ``setElement()`` vous permet de passer
l'objet au décorateur sur lequel il travaille. ``getElement()`` vous permet de récupérer cet objet depuis le
décorateur.

Chaque méthode ``render()`` des décorateurs accepte en paramètre une chaîne ``$content``. Lorsque le premier
décorateur est appelé, cette chaîne est en toute logique vide, alors que tous les appels successifs
travailleront sur le contenu précédent. Selon le type de décorateur et ses options, la chaîne sera alors
remplacée, précédée ou suivie du nouveau contenu décoré. Dans ces deux derniers cas, un séparateur optionnel
peut être utilisé.

.. _zend.form.decorators.standard:

Décorateurs standards
---------------------

``Zend_Form`` est fourni avec quelques décorateurs de base, voyez :ref:`le chapitre sur les décorateurs standards
<zend.form.standardDecorators>` pour plus de détails.

.. _zend.form.decorators.custom:

Décorateurs personnalisés
-------------------------

Si vos rendus HTML sont complexes, ou si vous avez besoin de beaucoup de personnalisation, vous pouvez alors créer
vos propres décorateurs.

Les décorateurs ont juste besoin d'implémenter l'interface ``Zend_Form_Decorator_Interface``. Celle-ci spécifie
les méthodes suivantes :

.. code-block:: php
   :linenos:

   interface Zend_Form_Decorator_Interface
   {
       public function __construct($options = null);
       public function setElement($element);
       public function getElement();
       public function setOptions(array $options);
       public function setConfig(Zend_Config $config);
       public function setOption($key, $value);
       public function getOption($key);
       public function getOptions();
       public function removeOption($key);
       public function clearOptions();
       public function render($content);
   }

Pour vous simplifier la tâche, vous pourriez considérer le fait d'étendre ``Zend_Form_Decorator_Abstract``, qui
implémente toutes les méthodes de l'interface sauf ``render()``.

Par exemple, imaginons que vous ne souhaitiez pas vous encombrer avec un nombre important de décorateurs, et que
vous vouliez afficher les principale caractéristiques d'un élément grâce à un seul décorateur (label,
élément, messages d'erreur et description), le tout dans une *div*. Voici comment vous pourriez procéder :

.. code-block:: php
   :linenos:

   class My_Decorator_Composite extends Zend_Form_Decorator_Abstract
   {
       public function buildLabel()
       {
           $element = $this->getElement();
           $label = $element->getLabel();
           if ($translator = $element->getTranslator()) {
               $label = $translator->translate($label);
           }
           if ($element->isRequired()) {
               $label .= '*';
           }
           $label .= ':';
           return $element->getView()
                          ->formLabel($element->getName(), $label);
       }

       public function buildInput()
       {
           $element = $this->getElement();
           $helper  = $element->helper;
           return $element->getView()->$helper(
               $element->getName(),
               $element->getValue(),
               $element->getAttribs(),
               $element->options
           );
       }

       public function buildErrors()
       {
           $element  = $this->getElement();
           $messages = $element->getMessages();
           if (empty($messages)) {
               return '';
           }
           return '<div class="errors">' .
                  $element->getView()->formErrors($messages) . '</div>';
       }

       public function buildDescription()
       {
           $element = $this->getElement();
           $desc    = $element->getDescription();
           if (empty($desc)) {
               return '';
           }
           return '<div class="description">' . $desc . '</div>';
       }

       public function render($content)
       {
           $element = $this->getElement();
           if (!$element instanceof Zend_Form_Element) {
               return $content;
           }
           if (null === $element->getView()) {
               return $content;
           }

           $separator = $this->getSeparator();
           $placement = $this->getPlacement();
           $label     = $this->buildLabel();
           $input     = $this->buildInput();
           $errors    = $this->buildErrors();
           $desc      = $this->buildDescription();

           $output = '<div class="form element">'
                   . $label
                   . $input
                   . $errors
                   . $desc
                   . '</div>';

           switch ($placement) {
               case (self::PREPEND):
                   return $output . $separator . $content;
               case (self::APPEND):
               default:
                   return $content . $separator . $output;
           }
       }
   }

Vous pouvez maintenant placer ce décorateur dans les chemins des décorateurs :

.. code-block:: php
   :linenos:

   // pour un élément:
   $element->addPrefixPath('My_Decorator',
                           'My/Decorator/',
                           'decorator');

   // pour tous les éléments:
   $form->addElementPrefixPath('My_Decorator',
                               'My/Decorator/',
                               'decorator');

Dès à présent, vous pouvez indiquer que vous voulez utiliser le décorateur 'Composite', (c'est son nom de
classe sans le préfixe) et l'attacher à un élément :

.. code-block:: php
   :linenos:

   // Ecrase les éventuels décorateurs de cet élément avec le notre:
   $element->setDecorators(array('Composite'));

Cet exemple vous montre comment rendre un contenu HTML complexe à partir de propriétés d'un élément, en une
seule passe. Il existe des décorateurs qui ne s'occupent que d'une propriété de l'élément auquel ils sont
rattachés, 'Errors' et 'Label' en sont d'excellents exemples qui permettent un placement fin.

Par exemple, si vous souhaitez simplement informer l'utilisateur d'une erreur, mais sans lui montrer les messages
d'erreurs, vous pouvez créer votre propre décorateur 'Errors' :

.. code-block:: php
   :linenos:

   class My_Decorator_Errors
   {
       public function render($content = '')
       {
           $output = '<div class="errors">La valeur est invalide, rééssayez</div>';

           $placement = $this->getPlacement();
           $separator = $this->getSeparator();

           switch ($placement) {
               case 'PREPEND':
                   return $output . $separator . $content;
               case 'APPEND':
               default:
                   return $content . $separator . $output;
           }
       }
   }

Dans cet exemple particulier, comme le segment final du nom de la classe, 'Errors', respecte la syntaxe de
``Zend_Form_Decorator_Errors``, il sera alors utilisé **à la place du** décorateur par défaut -- ceci signifie
que vous n'avez pas besoin de l'injecter dans un élément particulier. En nommant vos fins de classes de
décorateurs comme celles des décorateurs standards, vous pouvez changer la décoration sans agir sur les
éléments en question.

.. _zend.form.decorators.individual:

Rendre des décorateurs individuellement
---------------------------------------

Comme les décorateurs agissent souvent sur une propriété d'un élément, et en fonction de la décoration
précédente, il peut être utile d'afficher juste le rendu d'un décorateur particulier, sur un élément. Ceci
est possible par la surcharge des méthodes dans les classes principales de Zend_Form (formulaires,
sous-formulaires, groupes d'affichage, éléments).

Pour effectuer ceci, appelez simplement *render[nom-du-décorateur]()*, où "[nom-du-décorateur]" est le nom court
de votre décorateur (sans son préfixe de classe). Il est aussi possible de lui passer optionnellement du contenu,
par exemple :

.. code-block:: php
   :linenos:

   // rend juste le décorateur Label de cet élément:
   echo $element->renderLabel();

   // Rend juste le décorateur Fieldset, en lui passant du contenu:
   echo $group->renderFieldset('fieldset content');

   // rend juste le tag HTML du formulaire, avec du contenu:
   echo $form->renderHtmlTag('wrap this content');

Si le décorateur n'existe pas, une exception sera levée.

Ceci peut être particulièrement utile lors du rendu d'un formulaire avec le décorateur ViewScript ; là où
chaque élément utilise ses décorateurs pour rendre du contenu, mais de manière très fine.


