.. EN-Revision: none
.. _zend.pdf.info:

Informations du document et métadonnées
=======================================

Un document *PDF* peut inclure des informations générales comme le titre du document, l'auteur et les dates de
création ou de modification.

Historiquement ces informations sont stockées dans une structure spéciale Info. Cette structure est disponible en
lecture/écriture sous la forme d'un tableau associatif en utilisant la propriété publique *properties* des
objets ``Zend_Pdf``:

   .. code-block:: php
      :linenos:

      $pdf = Zend_Pdf::load($pdfPath);

      echo $pdf->properties['Title'] . "\n";
      echo $pdf->properties['Author'] . "\n";

      $pdf->properties['Title'] = 'Nouveau Titre.';
      $pdf->save($pdfPath);



Les clés suivantes sont définies par la norme *PDF* v1.4 (Acrobat 5) :

   - **Title**- string, optionnel, le titre du document.

   - **Author**- string, optionnel, le nom de la personne qui a créé le document.

   - **Subject**- string, optionnel, le sujet du document.

   - **Keywords**- string, optionnel, les mots clés associés au document.

   - **Creator**- string, optionnel, si le document a été converti en *PDF* à partir d'un autre format, le nom
     de l'application (par exemple, Adobe FrameMaker®) qui a créé le document original à partir duquel il a
     été converti.

   - **Producer**- string, optionnel, si le document a été converti en *PDF* à partir d'un autre format, le nom
     de l'application (par exemple, Acrobat Distiller) qui l'a converti en *PDF*.

   - **CreationDate**- string, optionnel, la date et l'heure auxquelles le document a été créé sous la forme
     suivante : "D:YYYYMMDDHHmmSSOHH'mm'", où :

        - **YYYY** est la date.

        - **MM** est le mois.

        - **DD** est le jour (01–31).

        - **HH** est l'heure (00–23).

        - **mm** est la minute (00–59).

        - **SS** est la seconde (00–59).

        - **O** est la différence de l'heure locale par rapport au temps universel (UT), dénoté par un des
          caractères +, de −, ou de Z (voir ci-dessous).

        - **HH** suivi par ' est la valeur absolue du décalage par rapport à l'UT en heures (00–23).

        - **mm** suivi par ' est la valeur absolue du décalage par rapport à l'UT en minutes (00–59).

     Le caractère apostrophe (') après "HH" et "mm" est un élément de la syntaxe. Chaque champs après l'année
     est optionnel. (Le préfixe "D:", bien que lui aussi optionnel, est fortement recommandé.) Les valeurs par
     défaut pour "MM" et "DD" sont à "01" ; tous les autres champs numériques ont par défaut des valeurs à
     zéro. Un signe plus (+) en tant que valeur pour le champs "0" signifie que l'heure locale est après l'UT, un
     signe moins (-) que l'heure locale est avant l'UT, et la lettre "Z" que l'heure locale est égale à l'UT. Si
     aucune information concernant l'UT n'est spécifiée, la différence par rapport à l'UT est considérée
     inconnue. Que le décalage horaire soit connu ou non, le reste de la date devrait être exprimée en heure
     locale.

     Par exemple la date "23 décembre 1998 à 19:52 (heure locale U.S. Pacifique)" est représentée par la
     chaîne "D:199812231952−08'00'".

   - **ModDate**- string, optionnel, la date et l'heure auxquelles le document a été le plus récemment modifié,
     sous la même forme que **CreationDate**.

   - **Trapped**- boolean, optionnel, indique si le document à été modifié pour inclure une information de
     "trapping".

        - **true**- Le document a été entièrement "trappé" ; aucun autre "trapping" n'est nécessaire.

        - **false**- Le document n'a pas encore été "trappé" ; tout "trapping" reste encore à réaliser.

        - **null**- Soit il est impossible de savoir si le document a été "trappé", soit il a été
          partiellement "trappé" ; certains "trapping" additionnels sont nécessaires.





Depuis la version v1.6 de la norme *PDF*, les métadonnées peuvent être stockées dans un document *XML* spécial
attaché au document *PDF* (XMP -`eXtensible Metadata Platform`_).

Ce document XML peut être récupéré et attaché au document PDF avec les méthodes ``Zend_Pdf::getMetadata()``
et ``Zend_Pdf::setMetadata($metadata)``:

   .. code-block:: php
      :linenos:

      $pdf = Zend_Pdf::load($pdfPath);
      $metadata = $pdf->getMetadata();
      $metadataDOM = new DOMDocument();
      $metadataDOM->loadXML($metadata);

      $xpath = new DOMXPath($metadataDOM);
      $pdfPreffixNamespaceURI = $xpath->query('/rdf:RDF/rdf:Description')
                                      ->item(0)
                                      ->lookupNamespaceURI('pdf');
      $xpath->registerNamespace('pdf', $pdfPreffixNamespaceURI);

      $titleNode = $xpath->query('/rdf:RDF/rdf:Description/pdf:Title')
                         ->item(0);
      $title = $titleNode->nodeValue;
      ...

      $titleNode->nodeValue = 'Nouveau titre';
      $pdf->setMetadata($metadataDOM->saveXML());
      $pdf->save($pdfPath);



Les propriétés communes du document sont dupliquées dans la structure Info et dans le document de métadonnées
(s'il est présent). Il est de la responsabilité de l'utilisateur de l'application de les maintenir
synchronisées.



.. _`eXtensible Metadata Platform`: http://www.adobe.com/products/xmp/
