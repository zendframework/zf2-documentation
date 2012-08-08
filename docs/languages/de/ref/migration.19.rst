.. EN-Revision: none
.. _migration.19:

Zend Framework 1.9
==================

Wenn man von einem Zend Framework Release vor 1.9.0 zu einem beliebigen 1.9 Release hochrüstet sollte man die
folgenden Migrations Hinweise beachten.

.. _migration.19.zend.file.transfer:

Zend_File_Transfer
------------------

.. _migration.19.zend.file.transfer.mimetype:

MimeType Prüfung
^^^^^^^^^^^^^^^^

Aus Sicherheitsgründen haben wir den standardmäßigen Fallback Mechanismus der ``MimeType``, ``ExcludeMimeType``,
``IsCompressed`` und ``IsImage`` Prüfungen ausgeschaltet. Das bedeutet, wenn die **fileInfo** oder **magicMime**
Erweiterungen nicht gefunden werden können, dann wird die Prüfung immer fehlschlagen.

Wenn es notwendig ist das man für die Prüfung die *HTTP* Felder verwendet welche vom Benutzer geschickt werden,
dann kann man dieses Feature einschalten indem die ``enableHeaderCheck()`` Methode verwendet wird.

.. note::

   **Sicherheits Hinweis**

   Man sollte beachten, das wenn man sich auf die *HTTP* Felder verlässt, die vom Benutzer geschickt werden, das
   ein Sicherheits Risiko ist. Diese können einfach geändert werden und könnten es einem Benutzer erlauben eine
   schädliche Datei zu schicken.

.. _migration.19.zend.file.transfer.example:

.. rubric:: Die Verwendung der HTTP Felder erlauben

.. code-block:: php
   :linenos:

   // Bei der Initiierung
   $valid = new Zend_File_Transfer_Adapter_Http(array('headerCheck' => true);

   // oder im Nachhinein
   $valid->enableHeaderCheck();

.. _migration.19.zend.filter:

Zend_Filter
-----------

Vor dem Release 1.9 erlaubte ``Zend_Filter`` die Verwendung der statischen Methode ``get()``. Ab dem Release 1.9
wurde diese Methode zu ``filterStatic()`` umbenannt um besser zu beschreiben was Sie macht. Die alte ``get()``
Methode wurde als deprecated markiert.

.. _migration.19.zend.http.client:

Zend_Http_Client
----------------

.. _migration.19.zend.http.client.fileuploadsarray:

Änderungen in der internen Speicherung der Information von hochgeladenen Dateien
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In Version 1.9 vom Zend Framework gibt es eine Ändernug wie ``Zend_Http_Client`` Informationen über hochgeladenen
Dateien intern speichert, bei denen die ``Zend_Http_Client::setFileUpload()`` Methode verwendet wird.

Diese Änderung wurde durchgeführt um es zu erlauben mehrere Dateien mit dem gleichen Formularnamen, als Array von
Dateien, hochzuladen. Weitere Informationen über dieses Problem können in `diesem Fehlerreport`_ gefunden werden.

.. _migration.19.zend.http.client.fileuploadsarray.example:

.. rubric:: Interne Speicherung der Informationen von hochgeladenen Dateien

.. code-block:: php
   :linenos:

   // Zwei Dateien mit dem gleichen Namen des Formularelements als Array hochladen
   $client = new Zend_Http_Client();
   $client->setFileUpload('file1.txt',
                          'userfile[]',
                          'some raw data',
                          'text/plain');
   $client->setFileUpload('file2.txt',
                          'userfile[]',
                          'some other data',
                          'application/octet-stream');

   // In Zend Framework 1.8 oder älter, ist der Wert der geschützten
   // Variable $client->files:
   // $client->files = array(
   //     'userfile[]' => array('file2.txt',
                                'application/octet-stream',
                                'some other data')
   // );

   // In Zend Framework 1.9 oder neuer, ist der Wert von $client->files:
   // $client->files = array(
   //     array(
   //         'formname' => 'userfile[]',
   //         'filename' => 'file1.txt,
   //         'ctype'    => 'text/plain',
   //         'data'     => 'some raw data'
   //     ),
   //     array(
   //         'formname' => 'userfile[]',
   //         'filename' => 'file2.txt',
   //         'formname' => 'application/octet-stream',
   //         'formname' => 'some other data'
   //     )
   // );

Wie man sieht gestattet diese Änderung die Verwendung des gleichen Namens für das Formularelement mit mehr als
einer Datei - trotzdem führt dies zu einer subtilen Änderung der Rückwärtskompatibilität und sollte erwähnt
werden.

.. _migration.19.zend.http.client.getparamsrecursize:

Zend_Http_Client::\_getParametersRecursive() sollte nicht mehr eingesetzt werden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Beginnend mit Version 1.9, wird die geschützte Methode ``_getParametersRecursive()`` nicht mehr von
``Zend_Http_Client`` verwendet und ist abgelehnt (deprecated). Ihre Verwendung führt zu einer ``E_NOTICE``
Nachricht die von *PHP* kommt.

Wenn man ``Zend_Http_Client`` erweitert und diese Methode aufrufr, sollte man sehen das man stattdessen die
statische Methode ``Zend_Http_Client::_flattenParametersArray()`` verwendet.

Nochmals, da ``_getParametersRecursive()`` eine geschützte Methode ist, sind nur Benutzer betroffen die
``Zend_Http_Client`` erweitert haben.

.. _migration.19.zend.locale:

Zend_Locale
-----------

.. _migration.19.zend.locale.deprecated:

Abgelaufene Methoden
^^^^^^^^^^^^^^^^^^^^

Einige spezialisiertere Übersetzungsmethoden stehen nicht mehr zur Verfügung weil Sie bestehende Verhaltensweisen
duplizieren. Beachten Sie das die alten Methoden weiterhin funktionieren, aber eine Benutzer Notiz geworfen wird,
die den neuen Aufruf beschreibt. Diese Methoden werden mit 2.0 entfernt. Die folgende Liste zeigt die alten und
neuen Methodenaufrufe.

.. _migration.19.zend.locale.deprecated.table-1:

.. table:: List der Methodenaufrufe

   +----------------------------------------+--------------------------------------------+
   |Alter Aufruf                            |Neuer Aufruf                                |
   +========================================+============================================+
   |getLanguageTranslationList($locale)     |getTranslationList('language', $locale)     |
   +----------------------------------------+--------------------------------------------+
   |getScriptTranslationList($locale)       |getTranslationList('script', $locale)       |
   +----------------------------------------+--------------------------------------------+
   |getCountryTranslationList($locale)      |getTranslationList('territory', $locale, 2) |
   +----------------------------------------+--------------------------------------------+
   |getTerritoryTranslationList($locale)    |getTranslationList('territory', $locale, 1) |
   +----------------------------------------+--------------------------------------------+
   |getLanguageTranslation($value, $locale) |getTranslation($value, 'language', $locale) |
   +----------------------------------------+--------------------------------------------+
   |getScriptTranslation($value, $locale)   |getTranslation($value, 'script', $locale)   |
   +----------------------------------------+--------------------------------------------+
   |getCountryTranslation($value, $locale)  |getTranslation($value, 'country', $locale)  |
   +----------------------------------------+--------------------------------------------+
   |getTerritoryTranslation($value, $locale)|getTranslation($value, 'territory', $locale)|
   +----------------------------------------+--------------------------------------------+

.. _migration.19.zend.view.helper.navigation:

Zend_View_Helper_Navigation
---------------------------

Vor dem Release 1.9 hat der Menü Helfer (``Zend_View_Helper_Navigation_Menu``) Untermenüs nicht richtig
dargestellt. Wenn ``onlyActiveBranch`` ``TRUE`` war und die Option ``renderParents`` ``FALSE`` wurde nichts
dargestellt wenn die tiefste aktive Seite auf einer geringeren Tiele als die ``minDepth`` Option war.

In einfacheren Worten; Wenn ``minDepth`` auf '1' gesetzt war und die aktive Seite eine der Seiten am Anfangs-Level,
wurde nichts dargestellt wie das folgende Beispiel zeigt.

Das folgende Container Setup wird angenommen:

.. code-block:: php
   :linenos:

   <?php
   $container = new Zend_Navigation(array(
       array(
           'label' => 'Home',
           'uri'   => '#'
       ),
       array(
           'label'  => 'Products',
           'uri'    => '#',
           'active' => true,
           'pages'  => array(
               array(
                   'label' => 'Server',
                   'uri'   => '#'
               ),
               array(
                   'label' => 'Studio',
                   'uri'   => '#'
               )
           )
       ),
       array(
           'label' => 'Solutions',
           'uri'   => '#'
       )
   ));

Der folgende Code wird in einem View Script verwendet:

.. code-block:: php
   :linenos:

   <?php echo $this->navigation()->menu()->renderMenu($container, array(
       'minDepth'         => 1,
       'onlyActiveBranch' => true,
       'renderParents'    => false
   )); ?>

Vor dem Release 1.9 würde der obige Codeabschnitt nichts ausgeben.

Seit dem Release 1.9 akzeptiert die ``_renderDeepestMenu()`` Methode in ``Zend_View_Helper_Navigation_Menu`` aktive
Seiten die ein Level unter ``minDepth`` sind, solange diese Seite Kinder hat.

Der gleiche Codeabschnitt zeigt jetzt die folgende Ausgabe:

.. code-block:: html
   :linenos:

   <ul class="navigation">
       <li>
           <a href="#">Server</a>
       </li>
       <li>
           <a href="#">Studio</a>
       </li>
   </ul>

.. _migration.19.security:

Sicherheitsfixes ab 1.9.7
-------------------------

Zusätzlich können Benutzer der Serie 1.9 von anderen Änderungen beginnend in Version 1.9.7 betroffen sein. Das
sind alles Sicherheitsbehebungen welche auch potentiell Probleme mit Rückwärtskompatibilität haben können.

.. _migration.19.security.zend.filter.html-entities:

Zend_Filter_HtmlEntities
^^^^^^^^^^^^^^^^^^^^^^^^

Um zu einem höheren Sicherheitsstandard für die Zeichenkodierung zu kommen, ist der Standardwert von
``Zend_Filter_HtmlEntities`` jetzt *UTF-8* statt *ISO-8859-1*.

Zusätzlich, weil der aktuelle Mechanismus mit Zeichenkodierung handelt und nicht mit Zeichensets, wurden zwei
Methoden hinzugefügt. ``setEncoding()`` und ``getEncoding()``. Die vorhergehenden Methoden ``setCharSet()`` und
``setCharSet()`` sind jetzt deprecated und verweisen auf die neuen Methoden. Letztendlich, statt die geschützten
Mitglieder in der ``filter()`` Methode direkt zu verwenden, werden Sie durch Ihre expliziten Zugriffsmethoden
empfangen. Wenn man den Filter in der Vergangenheit erweitert hat, sollte man seinen Code und seine Unittests
prüfen um sicherzustellen das weiterhin alles funktioniert.

.. _migration.19.security.zend.filter.strip-tags:

Zend_Filter_StripTags
^^^^^^^^^^^^^^^^^^^^^

``Zend_Filter_StripTags`` enthielt in voehergehenden Versionen ein ``commentsAllowed`` Flag, welches es erlaubt hat
*HTML* Kommentare in von dieser Klasse gefiltertem *HTML* Text als erlaubt zu markieren. Aber das öffnet den Weg
für *XSS* Attacken, speziell im Internet Explorer (der es erlaubt konditionelle Funktionalität über *HTML*
Kommentare zu spezifizieren). Beginnend mit Version 1.9.7 (und retour mit den Versionen 1.8.5 und 1.7.9), hat das
``commentsAllowed`` Flag keine Bedeutung meht, und alle *HTML* Kommentare, inklusive denen die andere *HTML* Tags
oder untergeordnete Kommentare enthalten, werden von der endgültigen Aufgabe des Filters entfernt.



.. _`diesem Fehlerreport`: http://framework.zend.com/issues/browse/ZF-5744
