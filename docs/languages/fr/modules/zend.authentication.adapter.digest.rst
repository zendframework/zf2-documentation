.. EN-Revision: none
.. _zend.authentication.adapter.digest:

Authentification "Digest"
=========================

.. _zend.authentication.adapter.digest.introduction:

Introduction
------------

`L'authentification "Digest"`_ est une méthode d'authentification *HTTP* qui améliore `l'authentification
basique`_ en fournissant un moyen d'authentifier sans avoir à transmettre le mot de passe en clair sur le réseau.

Cet adaptateur permet l'authentification en utilisant un fichier texte contenant des lignes comportant les
éléments de base d'une authentification Digest :

- identifiant, tel que "**utilisateur.jean**"

- domaine, tel que "**Zone administrative**"

- hachage *MD5*\ 5 d'un identifiant, domaine et mot de passe, séparés par des caractères deux-points.

Les éléments ci-dessus sont séparés par des caractères deux-points, comme dans l'exemple suivant (dans lequel
le mot de passe est "**unMotdepasse**") :

.. code-block:: text
   :linenos:

   unUtilisateur:Un domaine:3b17d7f3a9374666e892cbce58aa724f

.. _zend.authentication.adapter.digest.specifics:

Spécifications
--------------

L'adaptateur d'authentification Digest, ``Zend\Auth\Adapter\Digest`` requiert plusieurs paramètres d'entrée :

- filename : fichier utilisé pour réaliser l'authentification

- realm : domaine d'authentification Digest ("realm" en anglais)

- username : identifiant d'authentification Digest

- password : mot de passe pour l'identifiant dans le domaine

Ces paramètres doivent être définis avant l'appel de ``authenticate()``.

.. _zend.authentication.adapter.digest.identity:

Identité
--------

L'adaptateur d'authentification Digest retourne un objet ``Zend\Auth\Result``, lequel a été alimenté avec
l'identité sous la forme d'un tableau ayant pour clés **realm** (domaine) et **username** (identifiant). Les
valeurs respectives associées à ces clés correspondent aux valeurs définies avant l'appel à
``authenticate()``.

.. code-block:: php
   :linenos:

   $adaptateur = new Zend\Auth\Adapter\Digest($nomFichier,
                                              $domaine,
                                              $identifiant,
                                              $motdepasse);

   $resultat = $adaptateur->authenticate();

   $identite = $resultat->getIdentity();

   print_r($identite);

   /*
   Array
   (
       [realm] => Un domaine
       [username] => unUtilisateur
   )
   */



.. _`L'authentification "Digest"`: http://fr.wikipedia.org/wiki/HTTP_Authentification#M.C3.A9thode_Digest
.. _`l'authentification basique`: http://fr.wikipedia.org/wiki/HTTP_Authentification#M.C3.A9thode_Basic
