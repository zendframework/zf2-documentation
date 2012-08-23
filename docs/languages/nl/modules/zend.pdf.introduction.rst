.. EN-Revision: none
.. _zend.pdf.introduction:

Inleiding
=========

De *Zend_Pdf* module is een volledig in PHP 5 geschreven motor voor het manipuleren van PDF (Portable Document
Format). Het kan bestaande documenten laden, nieuwe documenten maken, documenten wijzigen en weer opslaan. Het laat
dus eender welke PHP toepassing dynamisch PDF documenten aanmaken door bestaande templates aan te passen of
documenten van de grond opnieuw op te bouwen. Zend_Pdf ondersteunt de volgende mogelijkheden:



   - Een nieuw document maken of een bestaand document laden. [#]_

   - Een bepaalde revisie van een document verkrijgen.

   - Pagina's binnenin het document manipuleren. De pagina orde veranderen, nieuwe pagina's toevoegen, pagina's
     verwijderen uit een document.

   - Verschillende tekening vormen (lijnen, rechthoeken, polygonen, cirkels, ellipsen en sectoren).

   - Tekst schrijven met één van de 16 standaard lettertypes.

   - Rotaties.

   - Beelden tekenen. [#]_

   - Incremental PDF bestand update.





.. [#] PDF V1.4 (Acrobat 5) documenten zijn nu ondersteund.
.. [#] Enkel JPG beelden zijn ondersteund op dit moment.