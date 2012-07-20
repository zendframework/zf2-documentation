.. _zend.view.introduction:

Einführung
==========

``Zend_View`` ist eine Klasse für die Verarbeitung des "View" Teils des Model-View-Controller Entwurfsmusters. Er
existiert, um das View Skript von den Model und Controller Skripten zu trennen. Es stellt ein System an Helfern,
Ausgabefiltern und Variablenmaskierung bereit.

``Zend_View`` ist unabhängig von einem Template System. Du kannst *PHP* als Template Sprache verwenden oder
Instanzen anderer Template Systeme erstellen und diese in deinem View Skript verarbeiten.

Im Wesentlichen verläuft die Verwendung von ``Zend_View`` in zwei Hauptschritten: 1. Dein Controller Skript
erstellt eine Instanz von ``Zend_View`` und übergibt Variablen an diese Instanz. 2. Der Controller teilt
``Zend_View`` mit, ein bestimmtes View Skript zu verarbeiten. Dabei wird die Kontrolle an das View Skript
übergeben, welches die Ausgabe erstellt.

.. _zend.view.introduction.controller:

Controller Skript
-----------------

In einem einfachen Beispiel hat dein Controller Skript eine Liste von Buchdaten, die von einem View Skript
verarbeitet werden sollen. Dieses Controller Skript kann ungefähr so aussehen:

.. code-block:: php
   :linenos:

   // verwende ein Modell, um die Daten der Bücher und Autoren zu erhalten
   $data = array(
       array(
           'author' => 'Hernando de Soto',
           'title' => 'The Mystery of Capitalism'
       ),
       array(
           'author' => 'Henry Hazlitt',
           'title' => 'Economics in One Lesson'
       ),
       array(
           'author' => 'Milton Friedman',
           'title' => 'Free to Choose'
       )
   );

   // nun übergebe die Buchdaten an die Zend_View Instanz
   Zend_Loader::loadClass('Zend_View');
   $view = new Zend_View();
   $view->books = $data;

   // und verarbeite ein View Skript mit Namen "booklist.php"
   echo $view->render('booklist.php');

.. _zend.view.introduction.view:

View Skript
-----------

Nun benötigen wir das zugehörige View Skript "booklist.php". Dies ist ein *PHP* Skript wie jedes andere mit einer
Ausnahme: es wird innerhalb der ``Zend_View`` Instanz ausgeführt, was bedeutet, dass Referenzen auf $this auf die
Eigenschaften und Methoden der ``Zend_View`` Instanz weisen. (Variablen, die vom Controller an die Instanz
übergeben wurden, sind öffentliche (public) Eigenschaften der ``Zend_View`` Instanz). Dadurch kann ein sehr
einfaches View Skript wie folgt aussehen:

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>
       <!-- Eine Tabelle mit einigen Büchern. -->
       <table>
           <tr>
               <th>Autor</th>
               <th>Titel</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>Es gibt keine Bücher zum Anzeigen.</p>

   <?php endif;?>

Beachte, wie wir die "escape()" Methode verwenden, um die Variablen für die Ausgabe zu maskieren.

.. _zend.view.introduction.options:

Optionen
--------

``Zend_View`` hat einige Optionen die gesetzt werden können um das Verhalten deiner View-Skripte zu konfigurieren.

- ``basePath``: zeigt den Basispfad von dem der Skript-, Helfer- und Filterpfad gesetzt wird. Es nimmt folgende
  Verzeichnisstruktur an:

  .. code-block:: php
     :linenos:

     base/path/
         helpers/
         filters/
         scripts/

  Das kann über ``setBasePath()``, ``addBasePath()``, oder die ``basePath`` Option dem Konstruktor gesetzt werden.

- ``encoding``: zeigt das Verschlüsseln der Zeichen für die Verwendung mit ``htmlentities()``,
  ``htmlspecialchars()``, und anderen Operationen. Standardwert ist ISO-8859-1 (latin1). Kann über
  ``setEncoding()``, oder die ``encoding`` Option im Constructor, gesetzt werden.

- ``escape``: zeigt einen Rückruf welche durch ``escape()`` benutzt wird. Kann über ``setEscape()``, oder die
  ``escape`` Option im Konstruktor, gesetzt werden.

- ``filter``: zeigt einen Filter welcher nach dem Rendern des View Skripts verwendet wird. Kann über
  ``setFilter()``, ``addFilter()``, oder die ``filter`` Option im Konstruktor, gesetzt werden.

- ``strictVars:`` zwingt ``Zend_View`` Notizen und Warnungen auszugeben wenn auf nicht initialisierte View
  Variablen zugegriffen wird. Das kann durch den Aufruf von ``strictVars(true)``, oder der Übergabe der
  ``strictVars`` Option im Konstruktor, gesetzt werden.

.. _zend.view.introduction.shortTags:

View Skripte mit Short Tags
---------------------------

In unseren Beispielen verwenden wir *PHP* Long Tags: **<?php**. Wir empfehlen auch die `alternative Syntax für
Kontrollstrukturen`_. Diese sind übliche Abkürzungen die Verwendet werden wenn View Skripte geschrieben werden,
da Sie Konstrukte verständlicher machen, die Anweisungen auf einer einzelnen Zeile belassen und die Notwendigkeit
eleminieren nach Klammern im *HTML* zu suchen.

In vorhergehenden Versionen haben wir oft die Verwendung von Short Tags empfohlen (**<?** und **<?=**), da Sie die
View Skripte weniger kompliziert machen. Trotzdem ist der Standardwert der ``php.ini`` Option ``short_open_tag``
typischerweise in Produktion oder bei Shared Hosts deaktiviert -- was deren Verwendung nicht wicklich portabel
macht. Wenn man *XML* in View Skripten als Template verwendet, werden Short Open Tags dazu führen das die Prüfung
der Templates fehlschlägt. Letztendlich, wenn man Short Tags verwendet, wärend ``short_open_tag`` ausgeschaltet
ist, werden die View Skripte entweder Fehler verursachen oder einfach den *PHP* Code an den Betrachter
zurücksenden.

Wenn man, trotz der Warnungen, Short Tags verwenden will diese aber ausgeschaltet sind, hat man zwei Optionen:

- Die Short Tags in der ``.htaccess`` Datei einschalten:

  .. code-block:: apache
     :linenos:

     php_value "short_open_tag" "on"

  Das ist nur dann möglich wenn es erlaubt ist ``.htaccess`` Dateien zu erstellen und anzupassen. Diese Direktive
  kann auch in der ``httpd.conf`` Datei hinzugefügt werden.

- Einen optionalen Stream Wrapper einschalten um Short Tags zu Long Tags on the fly zu konvertieren:

  .. code-block:: php
     :linenos:

     $view->setUseStreamWrapper(true);

  Das registriert ``Zend_View_Stream`` als Steam Wrapper für View Skripte, und stellt sicher das der Code
  weiterhin funktioniert wie wenn Short Tags eingeschaltet wären.

.. warning::

   **View Stream Wrapper verringert die Geschwindigkeit**

   Die Verwendung des Stream Wrapper **wird** die Geschwindigkeit der Anwendung verringern, auch wenn es nicht
   möglich ist Benchmarks durchzuführen um den Grad der Verlangsamung festzustellen. Wir empfehlen das entweder
   Short Tags aktiviert werden, die Skripte volle Tags verwenden, oder eine gute Strategie für das Cachen von
   partiellen, und/oder volle Seiteninhalten vorhanden ist.

.. _zend.view.introduction.accessors:

Zugriff auf Dienstprogramme
---------------------------

Typischerweise ist es nur notwendig ``assign()``, ``render()``, oder eine der Methoden für das Setzen/Hinzufügen
von Filtern, Helfern und Skript-Pfade aufzurufen. Trotzdem, wenn ``Zend_View`` selbst erweitert werden soll, oder
auf einige der Internas zugegriffen werden soll, existieren hierfür einige Zugriffsmöglichkeiten:

- ``getVars()`` gibt alle zugeordneten Variablen zurück.

- ``clearVars()`` löscht alle zugeordneten Variablen; Nützlich wenn ein View-Objekt wiederverwendet werden, aber
  auch kontrolliert werden soll welche Variablen vorhanden sind.

- ``getScriptPath($script)`` empfängt den aufgelösten Pfad zu einem gegebenen View Skript.

- ``getScriptPaths()`` empfängt alle registrierten Skript-Pfade.

- ``getHelperPath($helper)`` empfängt den aufgelösten Pfad zur angegebenen Helferklasse.

- ``getHelperPaths()`` empfängt alle registrierten Helferpfade.

- ``getFilterPath($filter)`` empfängt den aufgelösten Pfad zur angegebenen Filterklasse.

- ``getFilterPaths()`` empfängt alle registrierten Filterpfade.



.. _`alternative Syntax für Kontrollstrukturen`: http://us.php.net/manual/en/control-structures.alternative-syntax.php
