.. EN-Revision: none
.. _learning.plugins.usage:

Utiliser des Plugins
====================

Les composants utilisant des plugins se servent de ``Zend\Loader\PluginLoader`` pour fonctionner. Cette classe vous
propose d'enregistrer des "chemins de préfixes". Le composant va alors utiliser la méthode ``load()`` du
PluginLoader en lui passant le nom court du plugin à charger. Le PluginLoader va ensuite tester chaque chemin de
préfixe pour trouver une classe qui corresponde au nom court passé. Les chemins de préfixes sont testés en
ordre LIFO (last in, first out) et il trouvera d'abord les chemins de préfixes enregistrés en dernier, ce qui
permet de surcharger des plugins existants.

Voici quelques exemples pour éclaircir tout ça.

.. _learning.plugins.usage.basic:

.. rubric:: Exemple de base: ajouter un chemin de préfixes simple

Dans cet exemple, nous supposerons que des validateurs ont été écrits et enregistrés sous
``foo/plugins/validators/``, puis que toutes ces classes partagent le même préfixe "Foo_Validate\_"; ces deux
informations forment le "chemin de préfixes". Imaginons maintenant deux validateurs, un s'appelle "Even" (impaire)
il validera donc un chiffre impaire, et l'autre "Dozens"(multiples) qui vérifiera un chiffre multiple de 12.
L'arbre ressemble à ceci:

.. code-block:: text
   :linenos:

   foo/
   |-- plugins/
   |   |-- validators/
   |   |   |-- Even.php
   |   |   |-- Dozens.php

Maintenant, nous allons informer un ``Zend\Form\Element`` de ce chemin de préfixes. La méthode
``addPrefixPath()`` de ``Zend\Form\Element`` prend comme troisième paramètre le type de plugin pour lequel on
spécifie un chemin, dans notre cas il s'agit d'un plugin de validation , "validate".

.. code-block:: php
   :linenos:

   $element->addPrefixPath('Foo_Validate', 'foo/plugins/validators/', 'validate');

Dès lors il devient possible de passer à l'élément le nom court du validateur. Dans l'exemple qui suit, nous
mixons des validateurs standards ("NotEmpty", "Int") et personnalisés ("Even", "Dozens"):

.. code-block:: php
   :linenos:

   $element->addValidator('NotEmpty')
           ->addValidator('Int')
           ->addValidator('Even')
           ->addValidator('Dozens');

Lorsque l'élément devra utiliser la validation, il appellera le plugin via le PluginLoader. Les deux premiers
validateurs vont correspondre à ``Zend\Validate\NotEmpty`` et ``Zend\Validate\Int``, puis les deux suivants à
``Foo_Validate_Even`` et ``Foo_Validate_Dozens``, respectivement.

.. note::

   **Que se passe-t-il si un plugin n'est pas trouvé?**

   Que se passe-t-il si un plugin est demandé mais que le PluginLoader ne peut pas trouver de classe qui y
   corresponde? Dans notre exemple ci-dessus, la question devient "que se passe-t-il si j'enregistre le validateur
   "Bar" dans l'élément?"

   Le PluginLoader va chercher dans tous les chemins de prefixes pour trouver un fichier qui corresponde au nom du
   plugin. Si le fichier n'est pas trouvé, il passe au prochain chemin.

   Une fois que la pile de chemins est épuisée, si aucun fichier n'a été trouvé, il enverra une
   ``Zend\Loader_PluginLoader\Exception``.

.. _learning.plugins.usage.override:

.. rubric:: Exemple intermédiaire: Surcharger un plugin existant

Une des forces du PluginLoader est qu'il utilise une pile LIFO, ceci vous permet de surcharger des plugins
existants par les votres stockés dans des chemins différents en enregistrant ce chemin dans la pile.

Par exemple, considérons ``Zend\View_Helper\FormButton`` (les aides de vue sont une forme de plugin). Cette aide
de vue accepte trois paramètres, un nom DOM, une valeur (utilisée comme libéllé de bouton), et un tableau
optionnel d'options. L'aide génère du HTML concernant un élément de formulaire.

Imaginons que vous vouliez que cette aide génère un vrai bouton HTML ``button``; vous ne voulez pas que cette
aide génère un identifiant DOM mais plutôt une classe CSS; et que vous ne souhaitez pas utiliser d'options
supplémentaires. Vous pourriez faire cela de plusieurs manières. Dans tous les cas vous allez créer votre aide
de vue en y écrivant le comportement mais comment allez-vous nommer votre aide de vue et comment l'instancier?

Nous allons d'abord nommer notre classe avec un nom unique non existant, ``Foo_View_Helper_CssButton``, ceci donne
immédiatement un nom de plugin: "CssButton". Pourquoi pas, mais ceci pose quelques problèmes: si vous utilisiez
déja "FormButton" dans votre code vous allez devoir changer le nom partout, et si un autre développeur rejoind
vos rangs, il pourrait être troublé par "CssButton" et intuitivement penser à l'aide standard "FormButton".

Le mieux reste encore de nommer notre aide de vue "Button", en lui donnant comme nom de classe
``Foo_View_Helper_Button``. Nous enregistrons aussi le chemin de préfixes dans la vue:

.. code-block:: php
   :linenos:

   // Zend\View\View::addHelperPath() utilise PluginLoader; attention par contre
   // sa signature inverse les arguments par rapport à PluginLoader, ceci car il
   // propose une valeur par défaut au préfixe : "Zend\View\Helper"
   //
   // La ligne ci-dessous suppose que la classe soit logée dans 'foo/view/helpers/'.
   $view->addHelperPath('foo/view/helpers', 'Foo_View_Helper');

A partir de ce moment, utiliser l'aide "Button" mènera vers votre propre classe ``Foo_View_Helper_Button``!


