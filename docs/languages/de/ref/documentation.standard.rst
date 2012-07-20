.. _doc-standard:

**************************************
Zend Framework Dokumentations Standard
**************************************

.. _doc-standard.overview:

Übersicht
---------

.. _doc-standard.overview.scope:

Ziele
^^^^^

Dieses Dokument bietet Richtlinien für die Erstellung der End-Benutzer Dokumentation die im Zend Framework
gefunden werden kann. Es ist als Richtlinie für die Mitglieder des Zend Framework gedacht, welche Dokumentationen
als Teil Ihrer übermittelten Komponenten Dokumentation schreiben müssen, sowie für die Übersetzer von
Dokumentation. Der hier enthaltene Standard ist gedacht für einfache Übersetzung von Dokumentationen,
minimalisieren von Visualisierung und stylistischen Unterschieden zwischen den unterschiedlichen
Dokumentationsdateien, und macht das Finden von Änderungen in der Dokumentation einfacher mit ``diff`` Tools.

Man kann diese Standards zusammen mit den Regeln unserer `Lizenz`_ adoptieren und oder modifizieren.

Themen die im Zend Framework Dokumentations Standard beschrieben sind enthalten die Formatierung von
Dokumentationsdateien sowie Empfehlungen für die Qualität der Dokumentation.

.. _doc-standard.file-formatting:

Formatierung von Dokumentationsdateien
--------------------------------------

.. _doc-standard.file-formatting.xml-tags:

XML Tags
^^^^^^^^

Jede Datei des Manuals muß die folgenden *XML* Deklarationen am Beginn der Datei enthalten:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <!-- Reviewed: no -->

*XML* Dateien von übersetzten Sprachen müssen auch ein Revisions Tag enthalten das mit der Revision der
englischen Sprachdatei korrespondiert auf der die Übersetzung basiert.

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <!-- EN-Revision: 14978 -->
   <!-- Reviewed: no -->

.. _doc-standard.file-formatting.max-line-length:

Maximale Zeilenlänge
^^^^^^^^^^^^^^^^^^^^

Die maximale Zeilenlänge, inklusive Tags, Attribute und Einrückungen, darf 100 Zeichen nicht überschreiten. Es
gibt nur eine einzige Ausnahme zu dieser Regel: Attributen und Werte Paaren ist es erlaubt die 100 Zeichen zu
überschreiten wenn diese nicht getrennt werden dürfen.

.. _doc-standard.file-formatting.indentation:

Einrückung
^^^^^^^^^^

Eine Einrückung sollte aus 4 Leerzeichen bestehen. Tabulatoren sind nicht erlaubt.

Tags welche auf dem gleichen Level sind müssen auch die gleiche Einrückung haben.

.. code-block:: xml
   :linenos:

   <sect1>
   </sect1>

   <sect1>
   </sect1>

Tags welche ein Level unter dem vorhergehenden Tag sind müssen mit 4 zusätzlichen Leerzeichen eingerückt werden.

.. code-block:: xml
   :linenos:

   <sect1>
       <sect2>
       </sect2>
   </sect1>

Mehrere Block Tags in der gleichen Zeile sind nicht erlaubt; mehrere Inline Tags sind trotzdem erlaubt.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   <sect1><sect2>
   </sect2></sect1>

   <!-- ERLAUBT -->
   <para>
       <classname>Zend_Magic</classname> existiert nicht. <classname>Zend_Acl</classname> existiert.
   </para>

.. _doc-standard.file-formatting.line-termination:

Zeilen Begrenzung
^^^^^^^^^^^^^^^^^

Die Zeilen Begrenzung folgt der Unix Textdatei Konvention. Zeilen müssen mit einem einzelnen Linefeed (LF) Zeichen
enden. Linefeed Zeichen werden als ordinale 10, oder Hexadezimale 0x0A repräsentiert.

Beachte: Es sind keine Carriage Returns (*CR*) zu verwenden welche die Konvention in Apple OS's (0x0D) sind, oder
die Carriage Return - Linefeed Kombination (*CRLF*) welche der Standard für Windows OS (0x0D, 0x0A) sind.

.. _doc-standard.file-formatting.empty-tags:

Leere Tags
^^^^^^^^^^

Leere Tags sind nicht erlaubt; alle Tags müssen Text oder Untertags enthalten.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   <para>
       Irgendein Text. <link></link>
   </para>

   <para>
   </para>

.. _doc-standard.file-formatting.whitespace:

Verwendung von Leerzeichen in Dokumenten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _doc-standard.file-formatting.whitespace.trailing:

Leerzeichen in Tags
^^^^^^^^^^^^^^^^^^^

Öffnende Block Tags sollten direkt nach Ihnen keine Leerzeichen haben sondern nur einen Zeilenumbruch (und
Einrückungen in der folgenden Zeile).

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   <sect1>LEERZEICHEN
   </sect1>

Öffnende Inline Tags sollten keine Leerzeichen haben die Ihnen direkt folgen.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   Das ist die Klasse <classname> Zend_Class</classname>.

   <!-- OK -->
   Das ist die Klasse <classname>Zend_Class</classname>.

Schließenden Block Tags können Leerzeichen vorangestellt sein die dem aktuellen Einrückungslevel entsprechen,
aber nicht mehr als diese Anzahl.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
       <sect1>
        </sect1>

   <!-- OK -->
       <sect1>
       </sect1>

Schließenden Inline Tags dürfen keine Leerzeichen vorangestellt sein.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   Das ist die Klasse <classname>Zend_Class </classname>

   <!-- OK -->
   Das ist die Klasse <classname>Zend_Class</classname>

.. _doc-standard.file-formatting.whitespace.multiple-line-breaks:

Mehrere Zeilenumbrüche
^^^^^^^^^^^^^^^^^^^^^^

Mehrere Zeilenumbrüche innerhalb oder auch zwischen Tags sind nicht erlaubt.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   <para>
       Etwas Text...

       ... und mehr Text.
   </para>


   <para>
       Anderer Paragraph.
   </para>

   <!-- OK -->
   <para>
       Etwas Text...
       ... und mehr Text
   </para>

   <para>
       Anderer Paragraph.
   </para>

.. _doc-standard.file-formatting.whitespace.tag-separation:

Trennung zwischen Tags
^^^^^^^^^^^^^^^^^^^^^^

Tags auf dem gleichen Level müssen durch eine leere Zeile getrennt sein um die Lesbarkeit zu erhöhen.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   <para>
       Etwas Text...
   </para>
   <para>
       Mehr Text...
   </para>

   <!-- OK -->
   <para>
       Etwas Text...
   </para>

   <para>
       Mehr Text...
   </para>

Das erste Untertag sollte direkt unterhalb seiner Eltern geöffnet werden, ohne das eine leere Zeile zwischen Ihnen
ist; das letzte Untertag solte direkt vor dem Schließenden Tag seiner Eltern geschlossen werden.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   <sect1>

       <sect2>
       </sect2>

       <sect2>
       </sect2>

       <sect2>
       </sect2>

   </sect1>

   <!-- OK -->
   <sect1>
       <sect2>
       </sect2>

       <sect2>
       </sect2>

       <sect2>
       </sect2>
   </sect1>

.. _doc-standard.file-formatting.program-listing:

Programm Auflistungen
^^^^^^^^^^^^^^^^^^^^^

Das öffnende **<programlisting>** Tag muss das richtige "language" Attribut anzeigen und auf dem gleichen Level
eingerückt sein wie die vorhergehenden Blöcke.

.. code-block:: xml
   :linenos:

   <para>Vorhergehender Paragraph.</para>

   <programlisting language="php"><![CDATA[

*CDATA* sollte um alle Programm Auflistungen vorhanden sein.

**<programlisting>** Sektionen dürfen keine Zeilenumbrüche oder Leerzeichen am Anfang oder Ende der Sektion
besitzen, da diese auch in der endgültigen Ausgabe dargestellt werden.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   <programlisting language="php"><![CDATA[

   $render = "xxx";

   ]]></programlisting>

   <!-- OK -->
   <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]></programlisting>

Endende *CDATA* und **<programlisting>** Tags sollten in der gleichen Zeile, aber ohne Einrückung stehen.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
       <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]>
       </programlisting>

   <!-- NICHT ERLAUBT -->
       <programlisting language="php"><![CDATA[
   $render = "xxx";
       ]]></programlisting>

   <!-- OK -->
       <programlisting language="php"><![CDATA[
   $render = "xxx";
   ]]></programlisting>

Das **<programlisting>** Tag sollte das "language" Atribut mit einem Wert enthalten der dem Inhalt der Programm
Auflistung entspricht. Typischerweise enthält es die Werte "css", "html", "ini", "javascript", "php", "text", und
"xml".

.. code-block:: xml
   :linenos:

   <!-- PHP -->
   <programlisting language="php"><![CDATA[

   <!-- Javascript -->
   <programlisting language="javascript"><![CDATA[

   <!-- XML -->
   <programlisting language="xml"><![CDATA[

Für Programm Auflistungen die nur *PHP* Code enthalten werden keine *PHP* Tags (wie z.B. "<?php", "?>") benötigt,
und sollten auch nicht verwendet werden. Sie zeigen nur das Naheliegendste und werden durch die Verwendung des
**<programlisting>** Tags impliziert.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   <programlisting language="php"<![CDATA[<?php
       // ...
   ?>]]></programlisting>

   <programlisting language="php"<![CDATA[
   <?php
       // ...
   ?>
   ]]></programlisting>

Die Zeilenlängen in Programm Auflistungen sollten den :ref:`Coding Standard Empfehlungen
<coding-standard.php-file-formatting.max-line-length>` folgen.

``require_once()``, ``require()``, ``include_once()`` und ``include()`` sollten innerhalb von *PHP* Auflistungen
nicht verwendet werden. Sie zeigen nur das naheliegendste, und sind meistens nicht notwendig wenn ein Autoloader
verwendet wird. Sie sollten nur verwendet werden wenn Sie essentiell für das Beispiel sind.

.. note::

   **Niemals Short Tags verwenden**

   Short Tags (z.B., "<?", "<?=") sollten niemals innerhalb von **programlisting** oder einer Dokuments verwendet
   werden.

.. _doc-standard.file-formatting.inline-tags:

Notizen zu speziellen Inline Tags
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _doc-standard.file-formatting.inline-tags.classname:

classname
^^^^^^^^^

Das Tag **<classname>** muß jedesmal verwendet werden wenn ein Klassenname durch sich selbst repräsentiert wird;
er sollte nicht in Kombination mit einem Methodennamen, Variablennamen, oder einer Konstante verwendet werden, und
auch anderer Inhalt ist nicht innerhalb des Tags erlaubt.

.. code-block:: xml
   :linenos:

   <para>
       Die Klasse <classname>Zend_Class</classname>.
   </para>

.. _doc-standard.file-formatting.inline-tags.varname:

varname
^^^^^^^

Variablen müssen im **<varname>** Tag eingehüllt sein. Variablen müssen mit Verwendung des "$" Siegels
geschrieben werden. Kein anderer Inhalt ist innerhalb des Tags erlaubt, ausser es wird ein Klassenname verwendet,
der eine Klassenvariable anzeigt.

.. code-block:: xml
   :linenos:

   <para>
       Die Variable <varname>$var</varname> und die Klassenvariable
       <varname>Zend_Class::$var</varname>.
   </para>

.. _doc-standard.file-formatting.inline-tags.methodname:

methodname
^^^^^^^^^^

Methoden müssen innerhalb des **<methodname>** Tags stehen. Methoden müssen entweder die komplette Methoden
Signatur enthalten, oder zumindest ein Paar schließender Klammern (z.B., "()"). Kein anderer Inhalt ist innerhalb
dieses Tags erlaubt, ausser es wird ein Klassenname verwendet der eine Klassenmethode anzeigt.

.. code-block:: xml
   :linenos:

   <para>
       Die Methode <methodname>foo()</methodname> und die Klassenmethode
       <methodname>Zend_Class::foo()</methodname>. Eine Methode mit der kompletten
       Signatur <methodname>foo($bar, $baz)</methodname>
   </para>

.. _doc-standard.file-formatting.inline-tags.constant:

constant
^^^^^^^^

Das **<constant>** Tag ist zu verwenden wenn Konstanten angezeigt werden sollen. Konstanten müssen
*GROßGESCHRIEBEN* werden. Kein anderer Inhalt ist innerhalb dieses Tags erlaubt, ausser es wird ein Klassenname
verwendet, der eine Klassenkonstante anzeigt.

.. code-block:: xml
   :linenos:

   <para>
       Die Konstante <constant>FOO</constant> und die Klassenkonstante
       <constant>Zend_Class::FOO</constant>.
   </para>

.. _doc-standard.file-formatting.inline-tags.filename:

filename
^^^^^^^^

Dateinamen und Pfade müssen im **<filename>** Tag enthalten sein. Kein anderer Inhalt ist innerhalb dieses Tags
erlaubt.

.. code-block:: xml
   :linenos:

   <para>
       Die Datei <filename>application/Bootstrap.php</filename>.
   </para>

.. _doc-standard.file-formatting.inline-tags.command:

command
^^^^^^^

Commands, Shell Skripte, und Programmaufrufe müssen im **<command>** Tag enthalten sein. Wenn das Kommando
Argumente enthält sollten diese auch im Tag enthalten sein.

.. code-block:: xml
   :linenos:

   <para>
       Ausführen von <command>zf.sh create project</command>.
   </para>

.. _doc-standard.file-formatting.inline-tags.code:

code
^^^^

Die Verwendung des **<code>** Tags ist nicht erlaubt. Stattdessen sollten die anderen vorher besprochenen Inline
Tags verwendet werden.

.. _doc-standard.file-formatting.block-tags:

Notizen zu speziellen Block Tags
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _doc-standard.file-formatting.block-tags.title:

title
^^^^^

Das **<title>** Tag darf keine anderen Tags enthalten.

.. code-block:: xml
   :linenos:

   <!-- NICHT ERLAUBT -->
   <title>Verwendung von <classname>Zend_Class</classname></title>

   <!-- OK -->
   <title>Verwendung von Zend_Class</title>

.. _doc-standard.recommendations:

Empfehlungen
------------

.. _doc-standard.recommendations.editors:

Editoren ohne Autoformatierung verwenden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Für die Bearbeitung der Dokumentation sollten typischerweise keine formale *XML* Editoren verwendet werden. Solche
Editoren formatieren bestehende Dokumente normalerweise so das diese Ihren eigenen Standards folgen und folgen dem
Docbook Standard nicht strikt. Als Beispiel haben wir gesehen das Sie die *CDATA* Tags entfernen, die Trennung von
4 Leerzeichen zu Tabs oder 2 Leerzeichen ändern, usw.

Die Styling Richtlinien wurde großteile geschrieben um Übersetzern zu helfen damit diese durch Verwendung von
normalen ``diff`` Tools erkennen welche Zeilen sich geändert haben. Die Automatische formatierung macht diesen
Prozess viel schwieriger.

.. _doc-standard.recommendations.images:

Verwendung von Bildern
^^^^^^^^^^^^^^^^^^^^^^

Gute Bilder und Diagramme können die Lesbarkeit und Gemeinsamkeit erhöhen. Sie sollten immer dann verwendet
werden wenn Sie diesen Zielen helfen. Bilder sollten im Verzeichnis ``documentation/manual/en/figures/`` platziert,
und nach dem Kapitel benannt werden in dem Sie vorkommen.

.. _doc-standard.recommendations.examples:

Gute Fallbeispiele
^^^^^^^^^^^^^^^^^^

Man sollte nach guten Fallbeispielen sehen die von der Community verbreitet werden. Speziell jene die in den
Kommentaren der Proposals oder einer der Mailing Listen gesendet werden. Beispiel zeigen oft viel besser die
Verwendung als es Beschreibungen tun.

Wenn man Beispiele für die Inkludierung in das Handbuch schreibt, sollte man allen Coding Standards und
Dokumentations Standards folgen.

.. _doc-standard.recommendations.phpdoc:

Vermeide die Wiederholung von phpdoc Inhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das Handbuch ist dazu gedacht ein Referenzhandbuch für die Verwendung durch Endbenutzer zu sein. Die Wiederholung
von phpdoc Dokumentation für intern verwendete Komponenten und Klassen ist nicht erwünscht, und die
Beschreibungen sollten auf die Verwendung fokusiert sein, und nicht der internen Arbeitsweise. In jedem Fall und zu
jeder Zeit wollen wir das sich die Dokumentations-Team auf die Übersetzung des englischen Handbuchs und nicht den
phpdoc Kommentaren fokusiert.

.. _doc-standard.recommendations.links:

Verwendung von Links
^^^^^^^^^^^^^^^^^^^^

Links sollten zu anderen Sektionen des Handbuchs oder externen Quellen verweisen statt Dokumentation zu
wiederholen.

Die Verlinkung zu anderen Sektionen des Handbuchs kann durchgeführt werden indem das **<link>** Tag verwendet wird
(für welches man den Link Text selbst angeben muß).

.. code-block:: xml
   :linenos:

   <para>
       "Link" verweist zu einer Sektion, und verwendet beschreibenden Text: <link
           linkend="doc-standard.recommendations.links">Dokumentation zum
           Link</link>.
   </para>

Um auf eine externe Ressource zu verweisen muß **<ulink>** verwendet werden:

.. code-block:: xml
   :linenos:

   <para>
       Die <ulink url="http://framework.zend.com/">Zend Framework Seite</ulink>.
   </para>



.. _`Lizenz`: http://framework.zend.com/license
