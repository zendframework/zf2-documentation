.. EN-Revision: none
.. _zend.filter.introduction:

Introduction
============

Le composant ``Zend_Filter`` fournit un ensemble de filtres de données usuel. Il fournit également un mécanisme
simple de chaînage par lequel plusieurs filtres peuvent être appliqués à une donnée dans un ordre défini.

.. _zend.filter.introduction.definition:

Qu'est-ce qu'un filtre ?
------------------------

Généralement parlant, un filtre est utilisé pour supprimer les parties non désirées de ce qui lui est soumis
tout en laissant passer la partie désirée. Dans ce cas de figure, un filtre est une opération qui restitue une
partie de la donnée soumise. Ce type de filtrage est utile pour les applications Web : suppression des données
soumises non conformes, élimination des espaces inutiles, etc.

Cette définition simple d'un filtre peut être étendue pour inclure des transformations généralisées aux
données soumises. Une transformation communément requise dans les applications Web consiste à échapper les
entités HTML. Ainsi, si un champ de formulaire est automatiquement transmis et contient des données non
vérifiées (provenant par exemple d'un navigateur Web), ces données doivent être purgées de leurs entités HTML
ou bien contenir uniquement des entités HTML échappées, de manière à se garantir contre des comportements non
désirés et les vulnérabilités de sécurité. Afin d'assurer cette opération, les entités HTML qui sont
présentes dans les données saisies doivent être soit supprimées soit échappées. Naturellement, l'approche
adéquate dépend du contexte. Un filtre de suppression des entités HTML opère dans le contexte défini plus
haut : une opération produisant un sous-ensemble à partir d'une donnée soumise. Cependant, un filtre échappant
les entités HTML transforme la valeur entrée (par exemple, "*&*" sera transformé en "*&amp;*". Permettre de
telles choses est important pour les développeurs Web et "filtrer" dans le contexte d'utilisation de
``Zend_Filter`` consiste à réaliser des transformations sur les données soumises.

.. _zend.filter.introduction.using:

Utilisation basique des filtres
-------------------------------

Avoir cette définition d'un filtre établie fournit la base pour ``Zend_Filter_Interface``, qui nécessitent une
méthode unique nommée ``filter()`` pour être implémentée par une classe de filtre.

L'exemple simple ci-dessous démontre l'utilisation d'un filtre sur les caractères esperluette (*&*, "ampersand"
en anglais) et guillemet double (*"*) :

   .. code-block:: php
      :linenos:

      $htmlEntities = new Zend_Filter_HtmlEntities();

      echo $htmlEntities->filter('&'); // &
      echo $htmlEntities->filter('"'); // "



.. _zend.filter.introduction.static:

Utilisation de la méthode statique staticFilter()
-------------------------------------------------

S'il est peu pratique de charger une classe de filtre donnée et créer une instance du filtre, vous pouvez
utiliser la méthode statique ``Zend_Filter::get()`` comme appel alternatif. Le premier argument de cette méthode
est une valeur de saisie de données, que vous passeriez à la méthode ``filter()``. Le deuxième argument est une
chaîne, qui correspond au nom de base de la classe de filtre, relativement dans l'espace de nommage
``Zend_Filter``. La méthode ``staticFilter()`` charge automatiquement la classe, crée une instance et applique la
méthode ``filter()`` à la donnée saisie.

   .. code-block:: php
      :linenos:

      echo Zend_Filter::get('&', 'HtmlEntities');



Vous pouvez aussi fournir un tableau de paramètres destinés au constructeur de la classe, s'ils sont nécessaires
pour votre classe de filtre.

   .. code-block:: php
      :linenos:

      echo Zend_Filter::filterStatic('"',
                                     'HtmlEntities',
                                     array('quotestyle' => ENT_QUOTES));



L'utilisation statique peut être pratique pour invoquer un filtre ad hoc, mais si vous avez besoin d'exécuter un
filtre pour des saisies multiples, il est plus efficace de suivre le premier exemple ci-dessus, créant une
instance de l'objet de filtre et appelant sa méthode ``filter()``.

De plus, la classe ``Zend_Filter_Input`` vous permet d'instancier et d'exécuter des filtres multiples et des
classes de validateurs sur demande pour traiter l'ensemble de données saisies. Voir :ref:` <zend.filter.input>`.


