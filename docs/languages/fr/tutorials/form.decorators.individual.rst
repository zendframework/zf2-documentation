.. EN-Revision: none
.. _learning.form.decorators.individual:

Rendu individuel des décorateurs
================================

Dans la :ref:`section précédente <learning.form.decorators.layering>`, nous avons vu comment combiner les
décorateurs afin de créer un rendu complexe. Ceci est très fléxible mais rajoute tout de même un part de
compléxité à l'ensemble. Dans ce chapitre, nous allons inspecter le rendu individuel des décorateurs afin de
créer du contenu visuel pour des formulaires ou des éléments.

Une fois des décorateurs enregistrés, vous pouvez les récupérer via leur nom depuis l'élément. Revoyons
l'exemple précédent:

.. code-block:: php
   :linenos:

   $element = new Zend\Form\Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'prefixPath' => array('decorator' => array(
           'My_Decorator' => 'path/to/decorators/',
       )),
       'decorators' => array(
           'SimpleInput'
           array('SimpleLabel', array('placement' => 'append')),
       ),
   ));

Si nous voulons récupérer le décorateur ``SimpleInput``, nous passons par la méthode ``getDecorator()``:

.. code-block:: php
   :linenos:

   $decorator = $element->getDecorator('SimpleInput');
   echo $decorator->render('');

C'est simple et ça peut l'être encore plus; ré-écrivons le tout sur une seule ligne:

.. code-block:: php
   :linenos:

   echo $element->getDecorator('SimpleInput')->render('');

Pas mauvais, mais toujours un peu compliqué. Pour simplifier, une notation raccourcie a été introduite dans
``Zend_Form`` en 1.7: vous pouvez rendre n'importe quel décorateur enregistré en appelant une méthode de la
forme ``renderDecoratorName()``. Ceci effectue le rendu et fait en sorte que ``$content`` soit optionnel ce qui
simplifie l'utilisation:

.. code-block:: php
   :linenos:

   echo $element->renderSimpleInput();

C'est une simplification astucieuse, mais comment et pourquoi l'utiliser?

Beaucoup de développeurs ont des besoins très précis en affichage des formulaires. Ils préfèrent avoir un
contrôle complet sur tout l'affichage plutôt que d'utiliser une solution automatisée qui peut s'écarter de leur
but initial. Dans d'autres cas, les formulaires peuvent demander un affichage extrêmement spécifique, en groupant
des éléments alors que d'autres doivent pouvoir être invisibles avant que l'on n'effectue telle action sur la
page, etc.

Utilisons la possibilité de rendre un seul décorateur pour créer un affichage précis.

D'abord, définissons un formulaire. Celui-ci récupèrera des détails démographiques sur l'utilisateur. Le rendu
sera hautement personnalisé et dans certains cas il utilisera les aides de vue directement plutôt que les
éléments. Voici une définition simple du formulaire:

.. code-block:: php
   :linenos:

   class My_Form_UserDemographics extends Zend_Form
   {
       public function init()
       {
           // Ajoute un chemin pour les décorateurs personnalisés
           $this->addElementPrefixPaths(array(
               'decorator' => array('My_Decorator' => 'My/Decorator'),
           ));

           $this->addElement('text', 'firstName', array(
               'label' => 'First name: ',
           ));
           $this->addElement('text', 'lastName', array(
               'label' => 'Last name: ',
           ));
           $this->addElement('text', 'title', array(
               'label' => 'Title: ',
           ));
           $this->addElement('text', 'dateOfBirth', array(
               'label' => 'Date of Birth (DD/MM/YYYY): ',
           ));
           $this->addElement('text', 'email', array(
               'label' => 'Your email address: ',
           ));
           $this->addElement('password', 'password', array(
               'label' => 'Password: ',
           ));
           $this->addElement('password', 'passwordConfirmation', array(
               'label' => 'Confirm Password: ',
           ));
       }
   }

.. note::

   Nous n'utilisons pas de validateurs ou de filtres ici, car ils n'ont rien à voir avec le rendu visuel qui nous
   interesse. En réalité, il y en aurait.

Maintenant réfléchissons au rendu visuel du formulaire. Une communalité concernant les nom et prénom est qu'on
les affiche l'un à coté de l'autre, à coté de leur titre, si présent. Les dates, si elles n'utilisent pas
Javascript, affichent souvent des champs séparés pour chaque segment de la date.

Utilisons la possibilité de rendre des décorateurs un par un pour accomplir notre tâche. D'abord, notez qu'aucun
décorateur spécifique n'a été renseigné dans les éléments. Rappelons donc les décorateurs par défaut de la
plupart des éléments:

- ``ViewHelper``: utilise une aide de vue pour rendre l'élément balise de formulaire à proprement parlé.

- ``Errors``: utilise l'aide de vue ``FormErrors`` pour afficher les erreurs de validation éventuelles.

- ``Description``: utilise l'aide de vue ``FormNote`` afin de rendre la description éventuelle de l'élément.

- ``HtmlTag``: encapsule les trois objets ci-dessus dans un tag **<dd>**.

- ``Label``: rend l'intitulé de l'élément en utilisant l'aide de vue ``FormLabel`` (et en encapsulant le tout
  dans un tag **<dt>**).

Nous vous rappelons aussi que vous pouvez accéder à tout élément individuellement en tant qu'attribut du
formulaire représentant son nom.

Notre script de vue ressemblerait à cela:

.. code-block:: php
   :linenos:

   <?php
   $form = $this->form;
   // Enlève le <dt> depuis l'intitulé
   foreach ($form->getElements() as $element) {
       $element->getDecorator('label')->setOption('tag', null);
   }
   ?>
   <form method="<?php echo $form->getMethod() ?>" action="<?php echo
       $form->getAction()?>">
       <div class="element">
           <?php echo $form->title->renderLabel()
                 . $form->title->renderViewHelper() ?>
           <?php echo $form->firstName->renderLabel()
                 . $form->firstName->renderViewHelper() ?>
           <?php echo $form->lastName->renderLabel()
                 . $form->lastName->renderViewHelper() ?>
       </div>
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
       <div class="element">
           <?php echo $form->password->renderLabel()
                 . $form->password->renderViewHelper() ?>
       </div>
       <div class="element">
           <?php echo $form->passwordConfirmation->renderLabel()
                 . $form->passwordConfirmation->renderViewHelper() ?>
       </div>
       <?php echo $this->formSubmit('submit', 'Save') ?>
   </form>

Si vous utilisez le script ci-dessus, vous verrez un code HTML ressemblant à ceci:

.. code-block:: html
   :linenos:

   <form method="post" action="">
       <div class="element">
           <label for="title" tag="" class="optional">Title:</label>
           <input type="text" name="title" id="title" value=""/>

           <label for="firstName" tag="" class="optional">First name:</label>
           <input type="text" name="firstName" id="firstName" value=""/>

           <label for="lastName" tag="" class="optional">Last name:</label>
           <input type="text" name="lastName" id="lastName" value=""/>
       </div>

       <div class="element">
           <label for="dateOfBirth" tag="" class="optional">Date of Birth
               (DD/MM/YYYY):</label>
           <input type="text" name="dateOfBirth[day]" id="dateOfBirth-day"
               value="" size="2" maxlength="2"/>
           /
           <input type="text" name="dateOfBirth[month]" id="dateOfBirth-month"
               value="" size="2" maxlength="2"/>
           /
           <input type="text" name="dateOfBirth[year]" id="dateOfBirth-year"
               value="" size="4" maxlength="4"/>
       </div>

       <div class="element">
           <label for="password" tag="" class="optional">Password:</label>
           <input type="password" name="password" id="password" value=""/>
       </div>

       <div class="element">
           <label for="passwordConfirmation" tag="" class="" id="submit"
               value="Save"/>
   </form>

Ca peut ne pas ressembler à quelque chose de terminé, mais avec un peu de CSS, cela peut ressembler exactement à
ce que vous cherchez. Le point important ici, c'est que le formulaire a été généré en utilisant de la
décoration manuelle personnalisée (ainsi que l'utilisation d'échappement avec htmlentities).

Grâce à cette partie du tutoriel, vous devriez être à l'aise avec les possibilité de rendu de ``Zend_Form``.
Dans la section suivante, nous verrons comment monter un élément de date grâce à des éléments et des
décorateur uniques assemblés main.


