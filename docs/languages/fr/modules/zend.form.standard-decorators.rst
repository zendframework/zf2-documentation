.. _zend.form.standardDecorators:

Décorateurs standards fournis avec Zend Framework
=================================================

``Zend_Form`` est livré avec plusieurs décorateurs standards. Pour plus d'informations sur l'utilisation des
décorateurs en général, voyez :ref:`la section sur les décorateurs <zend.form.decorators>`.

.. _zend.form.standardDecorators.callback:

Zend_Form_Decorator_Callback
----------------------------

Le décorateur Callback peut exécuter une fonction de rappel pour rendre du contenu. Les fonctions doivent être
spécifiées grâce à l'option 'callback' passée à la configuration du décorateur, et peut être n'importe
quelle fonction *PHP* valide. Les fonctions peuvent accepter 3 arguments , ``$content`` ( le contenu original
passé au décorateur), ``$element`` (l'objet étant décoré), et un tableau d'options ``$options``. Voici un
exemple :

.. code-block:: php
   :linenos:

   class Util
   {
       public static function label($content, $element, array $options)
       {
           return '<span class="label">' . $element->getLabel() . "</span>";
       }
   }

Cette fonction de rappel devrait être spécifiée avec *array('Util', 'label')*, et générera du (mauvais) code
HTML pour le label. Le décorateur Callback remplacera, fera suivre ou précéder le contenu original avec la
valeur qu'il retourne.

Le décorateur Callback accepte qu'on lui passe une valeur nulle pour l'option de placement, ce qui remplacera le
contenu original par le contenu décoré. 'prepend' et 'append' restent cependant acceptés.

.. _zend.form.standardDecorators.captcha:

Zend_Form_Decorator_Captcha
---------------------------

Le décorateur Captcha est à utiliser avec :ref:`l'élément de formulaire CAPTCHA
<zend.form.standardElements.captcha>`. Il utilise la méthode ``render()`` de l'adaptateur de CAPTCHA pour
générer son contenu.

Une variante du décorateur Captcha, 'Captcha_Word', est aussi utilisée quelques fois et créer 2 éléments, un
id et un input. L'id indique l'identifiant de session à comparer et l'input est pour la saisie du CAPTCHA. Ces 2
éléments sont validés comme un seul.

.. _zend.form.standardDecorators.description:

Zend_Form_Decorator_Description
-------------------------------

Le décorateur Description peut être utilisé pour afficher la description affectée à un ``Zend_Form``,
``Zend_Form_Element``, ou ``Zend_Form_DisplayGroup``; il cherche cette description en utilisant
``getDescription()`` sur l'objet en question.

Par défaut, si aucune description n'est présente, rien ne sera généré. Dans le cas contraire , la description
est entourée d'un tag HTML *p* par défaut, même si vous pouvez passer le tag que vous voulez en utilisant
l'option *tag* à la création du décorateur, ou en utilisant sa méthode ``setTag()``. Vous pouvez aussi
spécifier une classe pour le tag en renseignant l'option *class* ou en appelant ``setClass()``.

La description est échappée en utilisant le mécanisme de l'objet de vue par défaut. Vous pouvez désactiver
cette fonctionnalité en passant ``FALSE`` à l'option 'escape' du décorateur ou via sa méthode ``setEscape()``.

.. _zend.form.standardDecorators.dtDdWrapper:

Zend_Form_Decorator_DtDdWrapper
-------------------------------

Les décorateurs par défaut utilisent des listes de définition (*<dl>*) pour rendre les éléments de formulaire.
Comme les éléments d'un formulaire peuvent apparaître dans n'importe quel ordre, les groupe d'affichage et les
sous-formulaires peuvent être encapsulés dedans. Afin de garder ces types d'éléments dans la liste de
définition, DtDdWrapper crée une nouvelle définition vide (*<dt>*) et encapsule don contenu dans une nouvelle
donnée de définition (*<dd>*). L'affichage ressemble alors à ceci :

.. code-block:: html
   :linenos:

   <dt></dt>
   <dd><fieldset id="subform">
       <legend>User Information</legend>
       ...
   </fieldset></dd>

Ce décorateur remplace le contenu qu'on lui fournit par ce même contenu entouré de *<dd>*.

.. _zend.form.standardDecorators.errors:

Zend_Form_Decorator_Errors
--------------------------

Les erreurs des éléments possèdent leur propre décorateur : 'Errors'. Celui-ci utilise l'aide de vue
FormErrors, qui rend les messages d'erreur dans une liste non ordonnée (*<ul>*) qui reçoit la classe d'affichage
"errors".

Le décorateur 'Errors' peut faire suivre ou précéder son contenu.

.. _zend.form.standardDecorators.fieldset:

Zend_Form_Decorator_Fieldset
----------------------------

Les groupes d'affichage et les sous-formulaires rendent leur contenu dans des balises HTML fieldsets par défaut.
Le décorateur Fieldset vérifie une option 'legend' ou la méthode ``getLegend()`` dans l'élément, et l'utilise
comme élément de légende si non vide. Tout contenu qu'on lui passe est entouré d'une balise HTML "fieldset", et
remplace donc le contenu précédent. Tout attribut passé à l'élément décoré sera rendu comme attribut de la
balise HTML fieldset.

.. _zend.form.standardDecorators.file:

Zend_Form_Decorator_File
------------------------

Les éléments de type "File" (upload de fichiers) ont une notation spéciale lorsque vous utilisez de multiples
éléments file ou des sous-formulaires. Le décorateur File est utilisé par ``Zend_Form_Element_File`` et
autorise plusieurs éléments avec un seul appel de méthode. Il est utilisé automatiquement et gère alors le nom
de chaque élément.

.. _zend.form.standardDecorators.form:

Zend_Form_Decorator_Form
------------------------

Les objets ``Zend_Form`` ont en général besoin de rendre une balise HTML "form". Le décorateur Form utilise
l'aide de vue du même nom dans ce but. Il encapsule le contenu qu'on lui passe dans une balise HTML 'form' et
remplace donc ce contenu par le nouveau entouré. Les action, méthode et attributs de l'objet ``Zend_Form`` sont
bien entendus utilisés dans la balise.

.. _zend.form.standardDecorators.formElements:

Zend_Form_Decorator_FormElements
--------------------------------

Les formulaires, groupes d'affichage et sous-formulaires sont des collections d'éléments. Afin de rendre ces
éléments, ils utilisent le décorateur FormElements, qui itère sur tous les éléments et appelle leur méthode
``render()`` en les joignant avec le séparateur. Il peut faire suivre ou précéder son contenu.

.. _zend.form.standardDecorators.formErrors:

Zend_Form_Decorator_FormErrors
------------------------------

Certains développeurs ou designers préfèrent regrouper tous les messages d'erreur en haut du formulaire. Le
décorateur FormErrors a été conçu dans ce but.

Par défaut, la liste d'erreurs générée ressemble à ceci :

.. code-block:: html
   :linenos:

   <ul class="form-errors>
       <li><b>[element label or name]</b><ul>
               <li>[error message]</li>
               <li>[error message]</li>
           </ul>
       </li>
       <li><ul>
           <li><b>[subform element label or name</b><ul>
                   <li>[error message]</li>
                   <li>[error message]</li>
               </ul>
           </li>
       </ul></li>
   </ul>

Vous pouvez lui passer un tas d'options afin de la configurer plus finement :

- *ignoreSubForms*\  : ignore ou pas la récursion dans les sous-formulaires. Par défaut : ``FALSE`` (autorise
  la récursion).

- *markupElementLabelEnd*\  : balise à ajouter après le label des éléments. Par défaut: '</b>'

- *markupElementLabelStart*\  : balise à ajouter avant le label des éléments. Par défaut: '<b>'

- *markupListEnd*\  : balise à ajouter après la liste des messages d'erreur. Par défaut: '</ul>'.

- *markupListItemEnd*\  : balise à ajouter après chaque message d'erreur. Par défaut: '</li>'

- *markupListItemStart*\  : balise à ajouter avant chaque message d'erreur. Par défaut: '<li>'

- *markupListStart*\  : balise à ajouter autour de la liste des messages d'erreur. Par défaut: '<ul
  class="form-errors">'

Le décorateur FormErrors peut faire suivre ou précéder son contenu.

.. _zend.form.standardDecorators.htmlTag:

Zend_Form_Decorator_HtmlTag
---------------------------

Le décorateur HtmlTag vous permet d'utiliser une balise HTML pour décorer votre contenu. La balise utilisée est
passée comme option 'tag' et toute autre option sera utilisée comme attribut HTML à cette balise. Par défaut,
le contenu généré remplace le contenu reçu par le décorateur. Vous pouvez tout de même préciser un placement
'append' ou 'prepend'.

.. _zend.form.standardDecorators.image:

Zend_Form_Decorator_Image
-------------------------

Le décorateur Image vous permet de créer un tag HTML d'image (*<input type="image" ... />*), et optionnellement
le rendre à l'intérieur d'une autre balise HTML.

Par défaut, le décorateur utilise la propriété 'src' , qui peut être renseignée grâce à la méthode
``setImage()`` (avec la source de l'image). Aussi, le label de l'élément va être utilisé comme propriété
'alt' de la balise et le propriété *imageValue* (manipulée grâce à ``setImageValue()`` et ``getImageValue()``)
sera utilisée comme valeur.

Pour spécifier une balise HTML à utiliser avec l'élément, passez l'option 'tag' au décorateur, ou utilisez sa
méthode ``setTag()``.

.. _zend.form.standardDecorators.label:

Zend_Form_Decorator_Label
-------------------------

Les éléments de formulaire possèdent en général un label, et le décorateur du même nom permet de le rendre.
Il utilise l'aide de vue FormLabel en récupérant le label de l'élément avec ``getLabel()``. Si aucun label
n'est présent, rien n'est rendu. Par défaut, les label sont traduits lorsqu'un objet de traduction existe.

Vous pouvez aussi spécifier optionnellement une option 'tag'. Si celle-ci est précisée, alors le label sera
encapsulé dans la balise HTML en question. Si la balise est présente mais qu'il n'y a pas de label, alors la
balise est rendu seule. Vous pouvez utiliser aussi une classe *CSS* grâce à l'option 'class' ou la méthode
``setClass()``.

Aussi, vous pouvez utiliser les préfixes ou des suffixes à afficher pour l'élément, selon si celui-ci est
requis ou pas. Par exemple on peut imaginer que tout label est suivi du caractère ":". Aussi, tout élément
requis à la saisie pourrait comporter une étoile "\*". Des méthodes existent pour effectuer cela :

- *optionalPrefix*: affecte le texte à préfixer au label si l'élément est optionnel. ``setOptionalPrefix()`` et
  ``getOptionalPrefix()`` existent aussi.

- *optionalSuffix*: affecte le texte à suffixer au label si l'élément est optionnel. ``setOptionalSuffix()`` et
  ``getOptionalSuffix()`` existent aussi.

- *requiredPrefix*: affecte le texte à préfixer au label si l'élément est marqué comme requis.
  ``setRequiredPrefix()`` et ``getRequiredPrefix()`` existent aussi.

- *requiredSuffix*: affecte le texte à suffixer au label si l'élément est marqué comme requis.
  ``setRequiredSuffix()`` et ``getRequiredSuffix()`` existent aussi.

Par défaut, le décorateur Label préfixe son rendu vis à vis du contenu qu'on lui passe à décorer. L'option
'placement' reste disponible avec comme autre valeur possible 'append'

.. _zend.form.standardDecorators.prepareElements:

Zend_Form_Decorator_PrepareElements
-----------------------------------

Les formulaires, les groupes d'affichage et les sous-formulaires sont des collections d'éléments. Lors de
l'utilisation du décorateur :ref:`ViewScript <zend.form.standardDecorators.viewScript>` dans vos formulaires, il
peut être utile de récursivement passer l'objet de vue, le traducteur et tous les noms réels (notation tableau
des sous-formulaires) aux éléments. Cette tache peut être effectuée grâce au décorateur 'PrepareElements'. En
général, vous le marquerez en tant que premier décorateur de la pile.

.. code-block:: php
   :linenos:

   $form->setDecorators(array(
       'PrepareElements',
       array('ViewScript', array('viewScript' => 'form.phtml')),
   ));

.. _zend.form.standardDecorators.viewHelper:

Zend_Form_Decorator_ViewHelper
------------------------------

Beaucoup d'éléments utilisent les aides de ``Zend_View`` pour leur propre rendu, et ceci est effectué grâce au
décorateur ViewHelper. Avec lui, vous pouvez spécifier une option 'helper' pour lui indiquer explicitement l'aide
de vue à utiliser. Si aucune ne lui est fournie, il utilise le nom de la classe de l'élément (moins le chemin :
la dernière partie du nom de la classe) afin de déterminer l'aide de vue à utiliser. Par exemple,
'Zend_Form_Element_Text' cherchera l'aide de vue 'form' + 'Text' soit 'formText'.

Tout attributs ajoutés à l'élément sera passé à l'aide vue comme attribut de l'élément HTML résultant.

Par défaut, ce décorateur fait suivre son contenu au contenu qu'on lui passe.

.. _zend.form.standardDecorators.viewScript:

Zend_Form_Decorator_ViewScript
------------------------------

Quelques fois, vous pouvez avoir besoin d'un script de vue pour afficher vos éléments. Ceci vous permettra un
placement très fin et détaillé, ou alors de changer la vue utilisée en fonction du module *MVC* dans lequel
vous vous situez, par exemple.

Le décorateur ViewScript nécessite une option 'viewScript'. Celle-ci peut aussi être passée à l'élément
lui-même, via sa propriété 'viewScript'. Le décorateur rend alors ce script de vue comme un script partiel (ce
qui signifie que chaque appel à lui possède son propre espace de variables). Plusieurs variables sont alors
peuplées dans le script de vue :

- *element*\  : l'élément décoré

- *content*\  : le contenu passé au décorateur

- *decorator*\  : l'objet décorateur lui-même

- Aussi, toute variable passée au décorateur via ``setOptions()`` et qui n'est pas utilisée en interne (qui
  n'est pas 'placement', 'separator', etc.) est alors passée comme variable de vue.

Voici un exemple :

.. code-block:: php
   :linenos:

   // Affectation d'un décorateur ViewScript à un seul élément
   // en spécifiant comme option le script de vue (obligatoire) et d'autres options :
   $element->setDecorators(array(array('ViewScript', array(
       'viewScript' => '_element.phtml',
       'class'      => 'form element'
   ))));

   // OU spécifier le script de vue comme attribut de l'élément
   $element->viewScript = '_element.phtml';
   $element->setDecorators(array(array('ViewScript',
                                       array('class' => 'form element'))));

Le script de vue pourrait alors ressembler à cela :

.. code-block:: php
   :linenos:

   <div class="<?php echo $this->class ?>">
       <?php echo $this->formLabel($this->element->getName(),
                                   $this->element->getLabel()) ?>
       <?php echo $this->{$this->element->helper}(
                          $this->element->getName(),
                          $this->element->getValue(),
                          $this->element->getAttribs()
       ) ?>
       <?php echo $this->formErrors($this->element->getMessages()) ?>
       <div class="hint"><?php echo $this->element->getDescription() ?></div>
   </div>

.. note::

   **Remplacer le contenu avec un script de vue**

   Le contenu n'est pas remplacé par défaut, vous pouvez le demander en spécifiant l'option 'placement' du
   décorateur. Il existe plusieurs manières de faire :

   .. code-block:: php
      :linenos:

      // A la création du décorateur:
      $element->addDecorator('ViewScript', array('placement' => false));

      // Application au décorateur déja existant:
      $decorator->setOption('placement', false);

      // Application au décorateur déja ajouté à un élément:
      $element->getDecorator('ViewScript')->setOption('placement', false);

      // Depuis un script de vue:
      $this->decorator->setOption('placement', false);

L'utilisation du décorateur ViewScript est recommandée dans les cas où vous souhaitez avoir un placement HTML
très détaillé et très fin de vos éléments.


