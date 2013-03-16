.. _user-guide.overview:

#####################################
Débuter avec Zend Framework 2
#####################################

Ce tutoriel est une introduction à l'utilisation de Zend Framework 2 en créant
une application pilotée par une base de données très simple et basée su le
paradigme Model-View-Controller. A la fin de ce tutoriel, vous obtiendrez une
application ZF2 fonctionnelle et vous pourrez en examiner le code pour
comprendre comment elle fonctionne et comment interagissent ses différents
éléments

.. _user-guide.overview.assumptions:

Quelques prérequis
----------------

Ce tutoriel suppose que vous avez un environnement PHP 5.3.3 avec un serveur web
Apache web et une base MySQL, accessible via l'extension PDO. Votre installation
Apache doit inclure l'extension mod_rewrite correctement configurée.

Vous devez aussi vous assurer qu'Apache supporte les fichiers``.htaccess``.
Ceci est normalement mis en place en modifiant ce paramètrage:

.. code-block:: apache

    AllowOverride None

vers

.. code-block:: apache

    AllowOverride FileInfo

dans votre fichier ``httpd.conf``. Vérifiez la documentation de votre
distribution pour plus les détails exacts. Vous ne serez pas capable d'accéder à
d'autre page que l'accueil de ce tutoriel si vous n'avez pas correctement
configuré mod_rewrite and .htaccess.

L'application du tutoriel
------------------------

L'application que nous allons mettre en place est un simple système d'inventaire
permettant d'afficher les albums dont nous disposons. La page principale sera
la liste liste de notre collection et nous permettra d'ajouter, modifier et
supprimer des CDs. Nous allons avoir besoin de quatre pages pour notre site web:

+----------------+------------------------------------------------------------+
| Page           | Description                                                |
+================+============================================================+
| Liste des      | Cet écran affiche la liste des albumset fournit des liens  |
| albums         | pour les modifier et les supprimer. Un lien pour ajouter   |
|                | des albums sera également présent.                         |
+----------------+------------------------------------------------------------+
| Ajouter un     | Cet écran permet l'ajout d'un nouvel album                 |
| nouvel album   | Cet écran permet l'ajout d'un nouvel album                 |
+----------------+------------------------------------------------------------+
| Modifier un    | Cet écran fournit un formulaire de modification            |
| album          | pour un album.                                             |
+----------------+------------------------------------------------------------+
| Supprimer un   | Cette page vous demandera de confirmer la                  |
| album          | suppression avant de supprimer un album.                   |
+----------------+------------------------------------------------------------+

Nous aurons également besoin de stocker des données dans notre base. Nous avons
seulement besoin d'une table avec ces champs :

+------------+--------------+-------+-----------------------------+
| Field name | Type         | Null? | Notes                       |
+============+==============+=======+=============================+
| id         | integer      | No    | Primary key, auto-increment |
+------------+--------------+-------+-----------------------------+
| artist     | varchar(100) | No    |                             |
+------------+--------------+-------+-----------------------------+
| title      | varchar(100) | No    |                             |
+------------+--------------+-------+-----------------------------+

