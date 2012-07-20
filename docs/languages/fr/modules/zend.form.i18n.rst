.. _zend.form.i18n:

Internationaliser un formulaire Zend_Form
=========================================

De plus en plus de développeurs ont besoin de fournir des applications multilingues. ``Zend_Form`` propose des
moyens simples dans ce but, et gère cette responsabilité en tandem avec :ref:`Zend_Translator <zend.translator>`
et :ref:`Zend_Validate <zend.validate>`.

Par défaut, aucune internationalisation (i18n) n'est effectuée. Pour l'activer dans ``Zend_Form``, vous devrez
instancier un objet ``Zend_Translator`` avec un adaptateur et l'attacher à ``Zend_Form`` et/ou ``Zend_Validate``.
Voyez la :ref:`documentation de Zend_Translator <zend.translator>` pour plus d'informations sur la création de son
objet et de ses adaptateurs.

.. note::

   **L'i18n peut être désactivée par objet**

   Vous pouvez désactiver la traduction pour tout formulaire, élément, groupe d'affichage ou sous-formulaire en
   appelant sa méthode ``setDisableTranslator($flag)`` ou en lui passant un paramètre *disableTranslator*. Ceci
   peut être utile pour désactiver l'i18n pour des éléments de formulaires individuels, ou des groupes
   d'éléments par exemple.

.. _zend.form.i18n.initialization:

Initialiser l'i18n dans les formulaires
---------------------------------------

Pour activer les traductions dans vos formulaires, vous avez besoin soit d'un objet ``Zend_Translator`` complet, ou
alors d'un objet ``Zend_Translator_Adapter``, comme ceci est détaillé dans la documentation de
``Zend_Translator``. Une fois un objet d'i18n en votre possession, plusieurs choix s'offrent à vous :

- **Le plus simple**\  : ajoutez l'objet d'i18n dans le registre. Tout composant utilisant l'i18n dans Zend
  Framework a la capacité de découvrir de lui-même un objet de traduction si celui-ci est enregistré dans le
  registre à la clé "Zend_Translator" :

  .. code-block:: php
     :linenos:

     // utilisez la clé registre 'Zend_Translator' ;
     // $translate est un objet Zend_Translator :
     Zend_Registry::set('Zend_Translator', $translate);

  Cet objet sera cherché par ``Zend_Form``, ``Zend_Validate``, et ``Zend_View_Helper_Translator``.

- Si tout ce qui vous importe est la traduction des messages d'erreurs, vous pouvez ajouter l'objet de traduction
  à ``Zend_Validate_Abstract``\  :

  .. code-block:: php
     :linenos:

     // Indique aux classes de validation d'utiliser
     // un objet de traduction spécifique :
     Zend_Validate_Abstract::setDefaultTranslator($translate);

- Autre manière de procéder; attacher un objet de traduction à ``Zend_Form`` de manière générale. Ceci aura
  pour effet, entres-autres, de gérer la traduction des messages d'erreur de la validation :

  .. code-block:: php
     :linenos:

     // Indique à toutes les classes de formulaire d'utiliser un objet de traduction
     // Indique aussi aux validateurs d'utiliser ce même objet pour traduire
     // les messages d'erreur :
     Zend_Form::setDefaultTranslator($translate);

- Enfin, il est possible d'attacher un objet de traduction à une instance du formulaire, ou à un ou plusieurs de
  ses éléments, grâce à ``setTranslator()``\  :

  .. code-block:: php
     :linenos:

     // Indique à *cette* instance de formulaire, d'utiliser un objet de
     // traduction. L'objet de traduction sera aussi utilisé par tous les
     // validateurs pour traduire les messages d'erreur :
     $form->setTranslator($translate);

     // Indique à *cette* instance d'élément de formulaire, d'utiliser
     // un objet de traduction. L'objet de traduction sera aussi utilisé
     // par tous les validateurs de *cet* élément spécifique :
     $element->setTranslator($translate);

.. _zend.form.i18n.standard:

Cibles gérées par l'I18n
------------------------

Maintenant que vous avez attaché un objet de traduction, que pouvez vous faire avec ?

- **Messages d'erreur des validateurs**\  : les messages d'erreurs des validateurs peuvent être traduits. Pour
  cela, utilisez les identifiants des messages des validateurs (constantes de vos validateurs ``Zend_Validate``.
  Pour plus d'informations sur ces clés, voyez la documentation de :ref:`Zend_Validate <zend.validate>`.

  Aussi, depuis la version 1.6.0, vous pouvez fournir des chaînes de traduction en utilisant les messages d'erreur
  actuels comme identifiants. C'est le comportement recommandé pour 1.6.0 ou supérieures, nous allons déprécier
  l'utilisation des clés (constantes de classe) dans les prochaines versions.

- **Labels**\  : les labels des éléments seront traduits si un objet de traduction et une chaîne de traduction
  existent.

- **Légende des Fieldset**\  : les groupes d'éléments et les sous-formulaires sont rendus dans des "fieldsets"
  par défaut. Le décorateur FieldSet essaye de traduire la légende via l'objet de traduction.

- **Description des formulaires et éléments de formulaire**\  : tous les types relatifs au formulaire
  (éléments, formulaires, groupes d'éléments ou sous-formulaires) permettent de spécifier une description
  optionnelle. Le décorateur Description essaye de traduire la description.

- **Valeurs de Multi-option**\  : les éléments héritant de ``Zend_Form_Element_Multi``\ (MultiCheckbox,
  Multiselect, et Radio) peuvent aussi traduire les valeurs (et non les clés) de leurs options.

- **Labels de Submit et Button**\  : les boutons (éléments Submit, Button et Reset) vont traduire le label
  affiché à l'utilisateur.


