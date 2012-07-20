.. _learning.form.decorators.composite:

Créer et rendre des éléments composites
=======================================

Dans :ref:`la dernière section <learning.form.decorators.individual>`, nous avions un exemple traitant un
élément "date de naissance":

.. code-block:: php
   :linenos:

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

Comment représenteriez-vous cet élément en tant que ``Zend_Form_Element``? Comment écrire un décorateur qui
s'assure de son rendu ?

.. _learning.form.decorators.composite.element:

L'élément
---------

Les questions à se poser sur le fonctionnement de l'élément sont:

- Comment affecter et récupérer une valeur?

- Comment valider la valeur?

- Comment proposer l'affectation personnalisée d'une valeur composées de trois segments (jour, mois, année)?

Les deux première questions se positionnent sur l'élément de formulaire lui-même, comment vont fonctionner les
méthodes ``setValue()`` et ``getValue()``? L'autre question nous suggère de nous questionner sur comment
récupérer les segments représentant la date, ou comment les affecter dans l'élément?

La solution est de surcharger la méthode ``setValue()`` dans l'élément pour proposer sa propre logique. Dans le
cas de notre exemple, notre élément devrait avoir trois comportements distincts:

- Si un timestamp entier est utilisé, il doit aider à la détermination des entités jour, mois, année.

- Si une chaine est utilisée, elle devrait être transformée en timestamp, et cette valeur sera utiliser pour
  déterminer les entités jour, mois, année.

- Si un tableau contenant les clés jour, mois, année est utilisé, alors les valeurs doivent être stockées.

En interne, les jour, mois et année seront stockés distinctement. Lorsque la valeur de l'élément sera
demandée, nous récupèrerons une chaine formatée et normalisée. Nous surchargerons ``getValue()`` pour
assembler les segments élémentaires composant la date.

Voici à quoi ressemblerait la classe:

.. code-block:: php
   :linenos:

   class My_Form_Element_Date extends Zend_Form_Element_Xhtml
   {
       protected $_dateFormat = '%year%-%month%-%day%';
       protected $_day;
       protected $_month;
       protected $_year;

       public function setDay($value)
       {
           $this->_day = (int) $value;
           return $this;
       }

       public function getDay()
       {
           return $this->_day;
       }

       public function setMonth($value)
       {
           $this->_month = (int) $value;
           return $this;
       }

       public function getMonth()
       {
           return $this->_month;
       }

       public function setYear($value)
       {
           $this->_year = (int) $value;
           return $this;
       }

       public function getYear()
       {
           return $this->_year;
       }

       public function setValue($value)
       {
           if (is_int($value)) {
               $this->setDay(date('d', $value))
                    ->setMonth(date('m', $value))
                    ->setYear(date('Y', $value));
           } elseif (is_string($value)) {
               $date = strtotime($value);
               $this->setDay(date('d', $date))
                    ->setMonth(date('m', $date))
                    ->setYear(date('Y', $date));
           } elseif (is_array($value)
                     && (isset($value['day'])
                         && isset($value['month'])
                         && isset($value['year'])
                     )
           ) {
               $this->setDay($value['day'])
                    ->setMonth($value['month'])
                    ->setYear($value['year']);
           } else {
               throw new Exception('Valeur de date invalide');
           }

           return $this;
       }

       public function getValue()
       {
           return str_replace(
               array('%year%', '%month%', '%day%'),
               array($this->getYear(), $this->getMonth(), $this->getDay()),
               $this->_dateFormat
           );
       }
   }

Cette classe est fléxible : nous pouvons affecter les valeurs par défaut depuis une base de données et être
certains qu'elles seront stockées correctement. Aussi, la valeur peut être affectée depuis un tableau provenant
des entrées du formulaire. Enfin, nous avons tous les accesseurs distincts pour chaque segment de la date, un
décorateur pourra donc créer l'élément comme il le voudra.

.. _learning.form.decorators.composite.decorator:

Le décorateur
-------------

Toujours en suivant notre exemple, imaginons que nous voulions que notre utilisateur saisissent chaque segment
jour, mois, année séparément. Heureusement, PHP permet d'utiliser la notation tableau pour créer des
éléments, ainsi nous pourrons capturer ces trois valeurs en une seule et nous crérons un élément ``Zend_Form``
traitant avec des valeurs en tableau.

Le décorateur est relativement simple: Il va récupérer le jour, le mois et l'année de l'élément et passer
chaque valeur à une aide de vue qui rendra chaque champ individuellement. Nous les rassemblerons ensuite dans le
rendu final.

.. code-block:: php
   :linenos:

   class My_Form_Decorator_Date extends Zend_Form_Decorator_Abstract
   {
       public function render($content)
       {
           $element = $this->getElement();
           if (!$element instanceof My_Form_Element_Date) {
               // Nous ne rendons que des éléments Date
               return $content;
           }

           $view = $element->getView();
           if (!$view instanceof Zend_View_Interface) {
               // Nous utilisons des aides de vue, si aucune vue n'existe
               // nous ne rendons rien
               return $content;
           }

           $day   = $element->getDay();
           $month = $element->getMonth();
           $year  = $element->getYear();
           $name  = $element->getFullyQualifiedName();

           $params = array(
               'size'      => 2,
               'maxlength' => 2,
           );
           $yearParams = array(
               'size'      => 4,
               'maxlength' => 4,
           );

           $markup = $view->formText($name . '[day]', $day, $params)
                   . ' / ' . $view->formText($name . '[month]', $month, $params)
                   . ' / ' . $view->formText($name . '[year]', $year, $yearParams);

           switch ($this->getPlacement()) {
               case self::PREPEND:
                   return $markup . $this->getSeparator() . $content;
               case self::APPEND:
               default:
                   return $content . $this->getSeparator() . $markup;
           }
       }
   }

Il faut maintenant préciser à notre élément d'utiliser notre décorateur par défaut. Pour ceci, il faut
informer l'élément du chemin vers notre décorateur. Nous pouvons effectuer ceci par le constructeur:

.. code-block:: php
   :linenos:

   class My_Form_Element_Date extends Zend_Form_Element_Xhtml
   {
       // ...

       public function __construct($spec, $options = null)
       {
           $this->addPrefixPath(
               'My_Form_Decorator',
               'My/Form/Decorator',
               'decorator'
           );
           parent::__construct($spec, $options);
       }

       // ...
   }

Notez que l'on fait cela en constructeur et non dans la méthode ``init()``. Ceci pour deux raisons. D'abord, ceci
permet d'étendre dans le futur notre élément afin d'y ajouter de la logique dans ``init`` sans se soucier de
l'appel à ``parent::init()``. Ensuite, celà permet aussi de redéfinir le décorateur par défaut ``Date`` dans
le futur si celà devient nécessaire, via le constructeur ou la méthode ``init``.

Ensuite, nous devons réécrire la méthode ``loadDefaultDecorators()`` pour lui indiquer d'utiliser notre
décorateur ``Date``:

.. code-block:: php
   :linenos:

   class My_Form_Element_Date extends Zend_Form_Element_Xhtml
   {
       // ...

       public function loadDefaultDecorators()
       {
           if ($this->loadDefaultDecoratorsIsDisabled()) {
               return;
           }

           $decorators = $this->getDecorators();
           if (empty($decorators)) {
               $this->addDecorator('Date')
                    ->addDecorator('Errors')
                    ->addDecorator('Description', array(
                        'tag'   => 'p',
                        'class' => 'description'
                    ))
                    ->addDecorator('HtmlTag', array(
                        'tag' => 'dd',
                        'id'  => $this->getName() . '-element'
                    ))
                    ->addDecorator('Label', array('tag' => 'dt'));
           }
       }

       // ...
   }

A qyuoi ressemble le rendu final ? Considérons l'élément suivant:

.. code-block:: php
   :linenos:

   $d = new My_Form_Element_Date('dateOfBirth');
   $d->setLabel('Date de naissance: ')
     ->setView(new Zend_View());

   // Ces deux procédés sont équivalents:
   $d->setValue('20 April 2009');
   $d->setValue(array('year' => '2009', 'month' => '04', 'day' => '20'));

Si vous affichez cet élément, vous obtiendrez ce rendu (avec quelques modifications concernant la mise en page du
manuel et sa lisibilité):

.. code-block:: html
   :linenos:

   <dt id="dateOfBirth-label"><label for="dateOfBirth" class="optional">
       Date de naissance:
   </label></dt>
   <dd id="dateOfBirth-element">
       <input type="text" name="dateOfBirth[day]" id="dateOfBirth-day"
           value="20" size="2" maxlength="2"> /
       <input type="text" name="dateOfBirth[month]" id="dateOfBirth-month"
           value="4" size="2" maxlength="2"> /
       <input type="text" name="dateOfBirth[year]" id="dateOfBirth-year"
           value="2009" size="4" maxlength="4">
   </dd>

.. _learning.form.decorators.composite.conclusion:

Conclusion
----------

Nous avons maintenant un élément qui peut rendre de multiples champs de formulaire, et les traiter comme une
seule entité -- la valeur ``dateOfBirth`` sera passée comme un tableau à l'élément et celui-ci créra les
segments de date appropriés et retournera une valeur normalisée.

Enfin, vous avez une API uniforme pour décrire un élement se composant se plusieurs segments distincts.


