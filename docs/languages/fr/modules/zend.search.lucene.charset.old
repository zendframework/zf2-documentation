.. _zend.search.lucene.charset:

Jeu de caractères
=================

.. _zend.search.lucene.charset.description:

Support UTF-8 et caractères sur un octet
----------------------------------------

``Zend_Search_Lucene`` utilise l'UTF-8 en interne. Les fichiers d'index stockent des données Unicode dans le
"format UTF-8 modifié" de Java. ``Zend_Search_Lucene`` supporte totalement ce format, à une exception près. [#]_

L'encodage des caractères d'entrée peut être spécifié grâce à l'API de ``Zend_Search_Lucene``. Les données
seront converties automatiquement en UTF-8.

.. _zend.search.lucene.charset.default_analyzer:

Analyseur de texte par défaut
-----------------------------

Cependant, l'analyseur de texte par défaut (aussi utilisé par l'analyseur de requête) utilise ``ctype_alpha()``.

``ctype_alpha()`` n'est pas compatible UTF-8, donc l'analyseur convertit le texte vers "ASCII//TRANSLIT" avant
l'indexation. Le même processus est utilisé de manière transparente lors du requêtage. [#]_

.. note::

   L'analyseur par défaut isole les chiffres. Utilisez le parseur "Num" si vous voulez que les chiffres soient
   considérés comme des mots.

.. _zend.search.lucene.charset.utf_analyzer:

Analyseurs de texte compatibles UTF-8
-------------------------------------

``Zend_Search_Lucene`` contient aussi des analyseurs compatibles UTF-8 :
``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8``, ``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num``,
``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8_CaseInsensitive``,
``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num_CaseInsensitive``.

N'importe quel analyseur peut être activé avec un code comme celui-ci:

   .. code-block:: php
      :linenos:

      Zend_Search_Lucene_Analysis_Analyzer::setDefault(
          new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());



.. warning::

   Les analyseurs UTF-8 ont été améliorés dans Zend Framework 1.5. Les anciennes versions considéraient les
   caractères non-ASCII comme des lettres. Les nouveaux analyseurs sont quant à eux plus précis sur ce point.

   Ceci pourrait vous obliger à reconstruire votre index afin que vos données et vos requêtes de recherche
   soient au même format. Des résultats faux peuvent apparaître sinon.

Tous ces analyseurs nécessitent que la libraire PCRE (Perl-compatible regular expressions) soit compilée avec le
support d'UTF-8. Ce support d'UTF-8 pour PCRE est activé par défaut dans les sources des libraires PCRE livrées
avec *PHP*, mais si vous avez utilisé des librairies partagées pour la compilation de *PHP*, alors le support
d'UTF-8 peut dépendre de l'OS.

Utilisez ce code pour vérifier si le support d'UTF-8 est assuré pour PCRE :

   .. code-block:: php
      :linenos:

      if (@preg_match('/\pL/u', 'a') == 1) {
          echo "support UTF-8 pour PCRE activé.\n";
      } else {
          echo "support UTF-8 pour PCRE désactivé.\n";
      }



Les analyseurs UTF-8 insensibles à la casse ont aussi besoin de l'extension `mbstring`_ pour être activés.

Si vous voulez les analyseurs UTF-8 insensibles à la casse, mais que vous n'avez pas mbstring, normalisez alors
vos données avant de les indexer ainsi que vos requêtes avant vos recherches, ceci en les tranformant en casse
minuscule :

   .. code-block::
      :linenos:

      // Indexation
      setlocale(LC_CTYPE, 'de_DE.iso-8859-1');

      ...

      Zend_Search_Lucene_Analysis_Analyzer::setDefault(
          new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());

      ...

      $doc = new Zend_Search_Lucene_Document();

      $doc->addField(Zend_Search_Lucene_Field::UnStored(
                          'contents', strtolower($contents))
                    );

      // champ titre (indexed, unstored)
      $doc->addField(Zend_Search_Lucene_Field::UnStored(
                          'title', strtolower($title))
                    );

      // champ titre (unindexed, stored)
      $doc->addField(Zend_Search_Lucene_Field::UnIndexed('_title', $title));



   .. code-block:: php
      :linenos:

      // Recherche
      setlocale(LC_CTYPE, 'de_DE.iso-8859-1');

      ...

      Zend_Search_Lucene_Analysis_Analyzer::setDefault(
          new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());

      ...

      $hits = $index->find(strtolower($query));





.. _`mbstring`: http://www.php.net/manual/en/ref.mbstring.php

.. [#] Zend_Search_Lucene supporte seulement les caractères Basic Multilingual Plane (BMP) (de 0x0000 à 0xFFFF)
       et ne supporte pas les "caractères supplémentaires" (caractères dont les codes sont supérieurs à
       0xFFFF).

       Java 2 représente ces caractères comme une paire de char (16-bit), le premier depuis l'échelle haute
       (0xD800-0xDBFF), le second pour l'échelle basse (0xDC00-0xDFFF). Ils sont alors encodés comme des
       caractères UTF-8 standards sur six octets. La représentation UTF-8 standard utilise elle 4 octets pour les
       caractères supplémentaires.
.. [#] La conversion vers 'ASCII//TRANSLIT' peut dépendre de la locale courante ou de l'OS.