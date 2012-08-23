.. EN-Revision: none
.. _learning.lucene.intro:

Introduction à Zend_Search_Lucene
=================================

Le composant ``Zend_Search_Lucene`` est prévu pour fournir une solution de recherche full-text prête à l'emploi.
Il ne nécessite aucunes extensions *PHP* [#]_ ni que des logiciels supplémentaires soient installés, et peut
être utilisé tout de suite après l'installation du Framework Zend.

``Zend_Search_Lucene`` est un portage *PHP* du moteur de recherche full-text open source populaire connu comme
Apache Lucene. Voir `http://lucene.apache.org/`_ pour plus de détails.

L'information doit être indexée pour être disponible à la recherche. ``Zend_Search_Lucene`` et Java Lucene
utilise un concept de document connu sous le nom d'"indexation atomique d'élément."

Chaque document est un ensemble de champs : paires <nom, valeur> où le nom et la valeur sont des chaînes *UTF-8*
[#]_. N'importe quel sous ensemble de champs de document peut être marqué comme "indexé" pour inclure des
données de champ durant le processus d'indexation de texte.

Les valeurs de champs peuvent être indexées segmentées durant l'indexation. Si un champ n'est pas segmenté,
alors la valeur du champ est stockée comme un seul terme ; autrement, l'analyseur courant est utilisé pour la
segmentation.

Plusieurs analyseurs sont fournis dans le paquet ``Zend_Search_Lucene``. L'analyseur par défaut fonctionne avec du
texte *ASCII* (comme l'analyseur *UTF-8* a besoin que l'extension **mbstring** soit activée). Il n'est pas
sensible à la case, et saute les nombres. Utilisez d'autres analyseurs ou créez votre propre analyseur si vous
avez besoin de changer ce comportement.

.. note::

   **Utilisation des analyseurs durant l'indexation et la recherche**

   Note importante ! Les requêtes de recherches sont aussi segmentées en utilisant "l'analyseur courant", ainsi
   le même analyseur doit être défini par défaut durant le processus d'indexation et le processus de recherche.
   Ceci garantira que la source et le texte recherché seront transformés en termes de la même manière.

Les valeurs de champs sont stockés optionnellement au sein de l'index. Ceci permet aux données originale du champ
d'être récupérée pendant la recherche. C'est le seul moyen d'associer les résultats de recherche avec les
données originales (l'ID interne du document peut avoir changé après une optimisation d'index ou une
auto-optimisation).

Ce qui doit être gardé en mémoire, c'est que l'index Lucene n'est pas une base de données. Il ne fournit pas un
mécanisme de sauvegarde de l'index à l'exception de la sauvegarde du répertoire du système de fichier. Il ne
fournit pas de mécanisme transactionnel bien que soient supportés la mise à jour concurrente d'index ainsi que
que la mise à jour et la lecture concurrente. Il n'est pas comparable aux bases de données en terme de vitesse de
récupération de données.

Donc c'est une bonne idée :

- **De ne pas** utiliser l'index Lucene comme du stockage car cela réduirait les performance de récupération de
  résultat de recherche. Stocker uniquement les identifiants de documents (chemin de documents, *URL*\ s,
  identifiant unique de base données) et associer les données au sein de l'index. Ex. titre, annotation,
  categorie, information de langue, avatar. (Note : un champs peut être inclu dans l'indexation, mais pas stocké,
  ou stocké, mais pas indexé).

- D'écrire des fonctionalités qui peuvent reconstruire intégralement l'index, si il a été corrompu pour une
  raison ou pour une autre.

Les documents individuels dans l'index peuvent avoir des ensemble de champs totalement différents. Le même champ
dans différents documents n'a pas besoin d'avoir les mêmes attributs. Ex. un champs peu être indexé pour l'un
des documents mais sauté pour l'indexation d'un autre. Le même principe s'applique au stockage, à la
segmentation, ou traitement de valeur de champ comme chaîne binaire.



.. _`http://lucene.apache.org/`: http://lucene.apache.org

.. [#] Bien que quelques fonctionnalités de traitement *UTF-8* nécessitent que l'extension **mbstring** soit
       activée
.. [#] Les chaînes Binaires sont aussi autorisées pour être utilisées comme des valeurs de champs