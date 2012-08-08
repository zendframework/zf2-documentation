.. EN-Revision: none
.. _zend.pdf.introduction:

Introduction
============

``Zend_Pdf`` est un composant entièrement écrit en PHP5 permettant la manipulation de documents *PDF* (Portable
Document Format). Il peut charger des documents, créer, modifier et les sauvegarder. Cela peut aider toute les
applications *PHP* à générer dynamiquement des documents *PDF* en modifiant un modèle existant ou en générant
un document à partir de rien. ``Zend_Pdf`` supporte les fonctionnalités suivantes :

   - Créer un nouveau document ou en charger un qui existe déjà. [#]_

   - Récupérer une version spécifique d'un document.

   - Manipuler les pages d'un document. Changer l'ordre des pages, ajouter des nouvelles pages, retirer des pages.

   - Différents outils de dessins (lignes, rectangles, polygones, cercles, ellipses et secteurs).

   - Dessiner du texte en utilisant une des 14 polices standard ou vos propres polices TrueType.

   - Rotations.

   - Inclure des images. [#]_

   - Mise à jour incrémentale des fichiers *PDF*.





.. [#] Les documents aux format *PDF* V1.4 (Acrobat 5) sont désormais supportés au chargement.
.. [#] Les images au format JPG, PNG [jusqu'à 8bit par canaux+Alpha] et TIFF sont supportées.