.. EN-Revision: none
.. _zend.view.helpers.initial.headlink:

L'aide de vue HeadLink
======================

L'élément HTML *<link>* est de plus en plus employé pour lier différents types de ressources à votre site :
feuilles de styles, syndication, icônes, trackbacks et d'autres. L'aide *HeadLink* fournit une interface simple
pour créer et agréger ces éléments pour la récupération postérieure et le rendement dans votre script
d'affichage.

L'aide *HeadLink* possède des méthodes pour ajouter des liens de feuilles de style dans sa pile :

- *appendStylesheet($href, $media, $conditionalStylesheet, $extras)*

- *offsetSetStylesheet($index, $href, $media, $conditionalStylesheet, $extras)*

- *prependStylesheet($href, $media, $conditionalStylesheet, $extras)*

- *setStylesheet($href, $media, $conditionalStylesheet, $extras)*

La valeur par défaut de ``$media`` vaut *screen*, mais peut être n'importe quelle valeur de média valide.
``$conditionalStylesheet`` est une chaîne ou le booléen ``FALSE``, et sera utilisé au moment du rendu pour
déterminer si des commentaires spéciaux doivent être inclus pour empêcher le chargement de la feuille de style
sur certaines plate-formes. ``$extras`` est un tableau de valeurs supplémentaires que vous voulez ajouter à la
balise.

De plus, l'aide *HeadLink* possède des méthodes pour ajouter des liens alternatifs dans sa pile :

- ``appendAlternate($href, $type, $title, $extras)``

- ``offsetSetAlternate($index, $href, $type, $title, $extras)``

- ``prependAlternate($href, $type, $title, $extras)``

- ``setAlternate($href, $type, $title, $extras)``

La méthode ``headLink()`` de l'aide permet de spécifier tous les attributs nécessaires à un élément *<link>*,
et vous permet aussi de préciser l'emplacement - le nouvel élément peut remplacer tous les autres, s'ajouter au
début ou à la fin de la liste.

L'aide *HeadLink* est une implémentation concrète de l'aide :ref:`Placeholder
<zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.headlink.basicusage:

.. rubric:: Utilisation basique de l'aide HeadLink

Vous pouvez spécifier un *headLink* à n'importe quel moment. Typiquement, vous pouvez spécifier des liens
globaux dans votre script de disposition, et des liens spécifiques à l'application dans vos scripts de vue. Dans
votre script de disposition, dans la section *<head>*, vous pourrez ensuite afficher le résultat de l'aide.

.. code-block:: php
   :linenos:

   <?php // régler les liens dans votre script de vue :
   $this->headLink()->appendStylesheet('/styles/basic.css')
                    ->headLink(array('rel' => 'favicon',
                                     'href' => '/img/favicon.ico'),
                               'PREPEND')
                    ->prependStylesheet('/styles/moz.css',
                                        'screen',
                                        true,
                                        array('id' => 'my_stylesheet'));
   ?>

   <!-- effectuer le rendu -->
   <?php echo $this->headLink() ?>


