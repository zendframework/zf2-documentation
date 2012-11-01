.. EN-Revision: none
.. _zend.progressbar.introduction:

Zend_ProgressBar
================

.. _zend.progressbar.whatisit:

Introduction
------------

``Zend_ProgressBar`` est un composant pour créer et mettre à jour les barres de progression dans différents
environnements. Il consiste en un backend unique, qui affiche la progression au travers de l'un des multiples
adaptateurs. A chaque mise à jour, il prend un chemin absolu et un message d'état, et appelle ensuite
l'adaptateur avec certaines valeurs précalculées comme le pourcentage et le temps restant estimé.

.. _zend.progressbar.basic:

Utilisation basique de Zend_Progressbar
---------------------------------------

``Zend_ProgressBar`` est assez simple d'utilisation. Vous créez simplement une nouvelle instance de
``Zend_Progressbar``, en définissant des valeurs minimum et maximum, et en choisissant un adaptateur pour afficher
les données. Si vous voulez travailler avec un fichier, vous pouvez faire comme ceci :

.. code-block:: php
   :linenos:

   $progressBar = new Zend\ProgressBar\ProgressBar(0, $fileSize, $adapter);

   while (!feof($fp)) {
       // Faire quelque chose

       $progressBar->update($currentByteCount);
   }

   $progressBar->finish();

Dans un premier temps, une instance de ``Zend_ProgressBar``, avec une valeur minimum de 0, une valeur maximum
correspondant à la taille totale du fichier et un adaptateur spécifique. Ensuite on travaille avec le fichier et
à chaque boucle la barre de progression est mise à jour avec le nombre d'octets courant. A la fin de la boucle,
le statut de la barre de progression est réglé à terminé.

``Zend_ProgressBar`` possède aussi une méthode ``refresh()`` qui recalcule le temps restant estimé et met à
jour l'adaptateur. Ceci est pratique quand il n'y a aucune donnée à mettre à jour mais que vous souhaitez que la
barre de progression soit mise à jour.

.. _zend.progressbar.adapters:

Adaptateurs standard
--------------------

``Zend_ProgressBar`` est fourni avec les deux adaptateurs suivants :

   - :ref:` <zend.progressbar.adapter.console>`

   - :ref:` <zend.progressbar.adapter.jspush>`

   - :ref:` <zend.progressbar.adapter.jspull>`



.. include:: zend.progress-bar.adapter.console.rst
.. include:: zend.progress-bar.adapter.js-push.rst
.. include:: zend.progress-bar.adapter.js-pull.rst

