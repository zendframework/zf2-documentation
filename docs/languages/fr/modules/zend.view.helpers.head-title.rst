.. EN-Revision: none
.. _zend.view.helpers.initial.headtitle:

L'aide de vue HeadTitle
=======================

L'élément HTML *<title>* est utilisé pour fournir un titre à un document HTML. L'aide *HeadTitle* vous permet
par programme de créer et de stocker le titre afin de le récupérer plus tard et de l'afficher.

L'aide *HeadTitle* est une implémentation concrète de l'aide :ref:`Placeholder
<zend.view.helpers.initial.placeholder>`. Elle surcharge la méthode ``toString()`` pour forcer la génération
d'un élément *<title>*, et ajoute une méthode ``headTitle()`` pour des réglages faciles et rapides et pour
l'aggrégation des éléments du titre. La signature de la méthode est ``headTitle($title, $setType = null)``; par
défaut, la valeur est ajoutée en fin de pile (pour aggréger les segments du titre) si laissé à null, mais vous
pouvez aussi spécifier "``PREPEND``" (pour l'ajouter en début de pile) ou "``SET``" (pour remplacer la pile
existante).

Since setting the aggregating (attach) order on each call to ``headTitle`` can be cumbersome, you can set a default
attach order by calling ``setDefaultAttachOrder()`` which is applied to all ``headTitle()`` calls unless you
explicitly pass a different attach order as the second parameter.

.. _zend.view.helpers.initial.headtitle.basicusage:

.. rubric:: Utilisation basique de l'aide HeadTitle

Vous pouvez spécifier la balise de titre à n'importe quel moment. Un usage typique serait de paramètrer les
différents segments du titre à chaque niveau de profondeur de votre application : site, module, contrôleur,
action et ressources potentielles.

.. code-block:: php
   :linenos:

   // Paramétrage des noms de contrôleurs et d'action
   // en tant que segment de titre :
   $request = Zend\Controller\Front::getInstance()->getRequest();
   $this->headTitle($request->getActionName())
        ->headTitle($request->getControllerName());

   // Réglage du nom de site, par exemple dans votre script
   // de disposition :
   $this->headTitle('Zend Framework');

   // Réglage de la haîne de séparation des segments :
   $this->headTitle()->setSeparator(' / ');

Quand vous êtes finalement prêt à afficher le titre dans votre script de disposition, faîtes simplement un
*echo* de l'aide :

.. code-block:: php
   :linenos:

   <!-- Affiche <action> / <controller> / Zend Framework -->
   <?php echo $this->headTitle() ?>


