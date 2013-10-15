.. EN-Revision: none
.. _zend.tag.cloud:

Zend\Tag\Cloud
==============

``Zend\Tag\Cloud`` est la partie qui s'occupe du rendu dans ``Zend_Tag``. par défaut, elle utilise un ensemble de
décorateurs HTML , ce qui permet de créer des nuages de tags pour un site, mais elle met aussi à votre
disposition 2 classes abstraites vous permettant de créer vos propres rendus, par exemple pour créer des tags
rendus en *PDF*.

Vous pouvez instancier et configurer ``Zend\Tag\Cloud`` de manière classique, ou via un tableau ou un objet
``Zend_Config``. Voici les options disponibles:

- *cloudDecorator*\  : défini le décorateur du nuage. Ceci peut être un objet, un nom de classe qui sera
  chargée par pluginloader, une instance de ``Zend\Tag\Cloud\Decorator\Cloud`` ou un tableau contenant les clés
  *decorator* et optionnellement *options*, qui est elle-même un tableau passé comme options au constructeur du
  décorateur.

- *tagDecorator*\  : le décorateur d'un tag individuel. Ceci peut être un objet, un nom de classe qui sera
  chargée par pluginloader, une instance de ``Zend\Tag\Cloud\Decorator\Cloud`` ou un tableau contenant les clés
  *decorator* et optionnellement *options*, qui est elle-même un tableau passé comme options au constructeur du
  décorateur.

- *pluginLoader*\  : un chargeur de classe à utiliser. Doit implémenter l'interface
  ``Zend\Loader\PluginLoader\Interface``.

- *prefixPath*\  : préfixes de chemins à ajouter au chargeur de classes. Doit être un tableau contenant les
  préfixes et les chemins. Les éléments invalides seront ignorés.

- *itemList*\  : une liste d'entités à utiliser. Doit être une instance de ``Zend\Tag\ItemList``.

- *tags*\  : une liste de tags à assigner au nuage. Chacun doit implémenter ``Zend\Tag\Taggable`` ou être un
  tableau qui pourra être utilisé pour instancier ``Zend\Tag\Item``.

.. _zend.tag.cloud.example.using:

.. rubric:: Utiliser Zend\Tag\Cloud

Cet exemple illustre les manipulations de base pour créer un nuage de tags, ajouter des tags et afficher le rendu.

.. code-block:: php
   :linenos:

   // Crée un nuage et assigne des tags statiques
   $cloud = new Zend\Tag\Cloud(array(
       'tags' => array(
           array('title' => 'Code', 'weight' => 50,
                 'params' => array('url' => '/tag/code')),
           array('title' => 'Zend Framework', 'weight' => 1,
                 'params' => array('url' => '/tag/zend-framework')),
           array('title' => 'PHP', 'weight' => 5,
                 'params' => array('url' => '/tag/php')),
       )
   ));

   // Rendu du nuage
   echo $cloud;

Ceci affichera le nuage de tags, avec les polices par défaut.

.. _zend.tag.cloud.decorators:

Decorateurs
-----------

``Zend\Tag\Cloud`` a besoin de 2 types de décorateurs afin de rendre le nuage. Un décorateur pour rendre chacun
des tags, et un décorateur pour rendre le nuage lui-même. ``Zend\Tag\Cloud`` propose un décorateur par défaut
qui formate le nuage en HTML. Il utilise par défaut des listes ul/li et des tailles de polices différentes selon
les poids des tags.

.. _zend.tag.cloud.decorators.htmltag:

Décorateur HTML
^^^^^^^^^^^^^^^

Le décorateur HTML va rendre chaque tag dans un élément ancré, entouré d'un élément li. L'ancre est fixe et
ne peut être changée, mais l'élément peut lui l'être.

.. note::

   **Paramètre d'URL**

   Une ancre étant ajoutée à chaque tag, vous devez spécifier une *URL* pour chacun d'eux.

Le décorateur de tags peut utiliser des tailles de police différentes pour chaque ancre, ou pour chaque classe de
liste. Les options suivantes sont disponibles:

- *fontSizeUnit*\  : définit l'unité utilisée dans la taille des polices. em, ex, px, in, cm, mm, pt, pc et %.

- *minFontSize*\  : Taille minimale de la police (poids le plus faible) (doit être un entier).

- *maxFontSize*\  : Taille maximale de la police (poids le plus fort) (doit être un entier).

- *classList*\  : un tableau de classes utilisées dans les tags.

- *htmlTags*\  : un tableau de tags HTML entourant l'ancre. Chaque élément peut être une chaîne de
  caractères, utilisée comme type d'élément, ou un tableau contenant une liste d'attributs pour l'élément. La
  clé du tableau est alors utilisée pour définir le type de l'élément.

.. _zend.tag.cloud.decorators.htmlcloud:

Décorateur HTML de nuage
^^^^^^^^^^^^^^^^^^^^^^^^

Le décorateur HTML de nuage va entourer les tags avec une balise ul. Vous pouvez changer la balise, en utiliser
plusieurs, utiliser un séparateur. Voici les options:

- *separator*\  : définit le séparateur utilisé entre chaque tag.

- *htmlTags*\  : un tableau de balises HTML entourant chaque tag. Chaque élément peut être une chaîne de
  caractères, utilisée comme type d'élément, ou un tableau contenant une liste d'attributs pour l'élément. La
  clé du tableau est alors utilisée pour définir le type de l'élément.


