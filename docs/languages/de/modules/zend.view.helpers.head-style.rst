.. EN-Revision: none
.. _zend.view.helpers.initial.headstyle:

HeadStyle Helfer
================

Das *HTML* Element **<style>** wird verwendet um *CSS* Stylesheets im *HTML* Element **<head>** zu inkludieren.

.. note::

   **HeadLink verwenden um CSS Dateien zu verlinken**

   :ref:`HeadLink <zend.view.helpers.initial.headlink>` sollte verwendet werden um **<link>** Elemente zu Erstellen
   die externe Stylesheets enthalten. ``HeadStyle`` wird verwendet wenn man Stylesheets inline definieren will.

Der ``HeadStyle`` Helfer unterstützt die folgenden Methoden für das Setzen und Hinzufügen von Stylesheet
Deklarationen:

- ``appendStyle($content, $attributes = array())``

- ``offsetSetStyle($index, $content, $attributes = array())``

- ``prependStyle($content, $attributes = array())``

- ``setStyle($content, $attributes = array())``

In allen Fällen ist ``$content`` die aktuelle *CSS* Deklaration. ``$attributes`` sind alle zusätzlichen Attribute
die das ``style`` Tag erhalten soll: lang, title, media, oder dir sind alle möglich.

.. note::

   **Abhängige Kommentare setzen**

   ``HeadStyle`` erlaubt es ein Script Tag in abhängige Kommentare zu setzen, das es erlaubt es vor speziellen
   Browsern zu verstecken. Um abhängige Tags zu setzen, muß der abhängige Wert als Teil des ``$attrs``
   Parameters im Methodenaufruf übergeben werden.

   .. _zend.view.helpers.initial.headstyle.conditional:

   .. rubric:: Headstyle mit abhängigen Kommentaren

   .. code-block:: php
      :linenos:

      // Skripte hinzufügen
      $this->headStyle()->appendStyle($styles, array('conditional' => 'lt IE 7'));

``HeadStyle`` erlaubt auch das Erfassen von Style Deklarationen; das kann nützlich sein wenn eine Deklaration
programmtechnisch erstellt werden soll und Sie dann woanders platziert wird. Die Verwendung hierfür wird in einem
unten angeführten Beispiel gezeigt.

Letztendlich kann auch die ``headStyle()`` Methode verwendet werden um schnellstens Deklarationselemente
hinzuzufügen; die Signatur dafür ist ``headStyle($content$placement = 'APPEND', $attributes = array())``.
``$placement`` sollte entweder 'APPEND', 'PREPEND', oder 'SET' sein.

``HeadStyle`` überschreibt jedes ``append()``, ``offsetSet()``, ``prepend()``, und ``set()`` um die Verwendung der
oben gelisteten speziellen Methoden zu forcieren. Intern wird jeder Teil als ``stdClass`` Token gespeichert,
welches später serialisiert wird durch Verwendung der ``itemToString()`` Methode. Das erlaubt es die Teile im
Stack zu Prüfen, und optional auch zu Ändern durch einfaches Modifizieren des zurückgegebenen Objektes.

Der ``HeadStyle`` Helfer ist eine konkrete Implementation des :ref:`Platzhalter Helfers
<zend.view.helpers.initial.placeholder>`.

.. note::

   **Standardmäßig wird die UTF-8 Kodierung verwendet**

   Standardmäßig verwendet Zend Framework *UTF-8* als seine Standardkodierung, und speziell in diesem Fall, macht
   das ``Zend_View`` genauso. Die Zeichenkodierung kann im View Objekt selbst auf etwas anderes gesetzt werden
   indem die Methode ``setEncoding()`` verwendet wird (oder der Parameter ``encoding`` bei der Instanzierung
   angegeben wird). Trotzdem, da ``Zend\View\Interface`` keine Zugriffsmethoden für die Kodierung anbietet ist es
   möglich dass, wenn man eine eigene View Implementation verwendet, man keine ``getEncoding()`` Methode hat,
   welche der View Helfer intern für die Erkennung des Zeichensets verwendet in das kodiert werden soll.

   Wenn man *UTF-8* in solch einer Situation nicht verwenden will, muss man in der eigenen View Implementation eine
   ``getEncoding()`` Methode implementieren.

.. _zend.view.helpers.initial.headstyle.basicusage:

.. rubric:: Grundsätzliche Verwendung des HeadStyle Helfers

Ein neues Style Tag kann jederzeit spezifiziert werden:

.. code-block:: php
   :linenos:

   // Stile hinzufügen
   $this->headStyle()->appendStyle($styles);

Die Reihenfolge ist in *CSS* sehr wichtig; es könnte sein das man sichergestellen muß das Deklarationen in einer
speziellen Reihenfolge geladen werden wegen der Reihenfolge der Kaskade; die verschiedenen append, prepend und
offsetSet Direktiven können für diesen Zweck verwendet werden:

.. code-block:: php
   :linenos:

   // Styles in Reihenfolge bringen

   // Ein spezielles Offset platzieren:
   $this->headStyle()->offsetSetStyle(100, $customStyles);

   // Am Ende platzieren:
   $this->headStyle()->appendStyle($finalStyles);

   // Am Anfang platzieren:
   $this->headStyle()->prependStyle($firstStyles);

Wenn man damit fertig ist und alle Style Deklarationen im Layout Skript ausgegeben werden können kann der Helfer
einfach wiederholt werden:

.. code-block:: php
   :linenos:

   <?php echo $this->headStyle() ?>

.. _zend.view.helpers.initial.headstyle.capture:

.. rubric:: Den HeadStyle Helfer verwenden um Style Deklarationen zu Erfassen

Hier und da müssen *CSS* Style Deklarationen programmtechnisch erstellt werden. Wärend String Kopplungen,
HereDocs und ähnliches verwendet werden könnte, ist es oft einfacher das durch erstellen der Styles und deren
Einfügung in *PHP* Tags zu machen. ``HeadStyle`` lässt das zu indem es in den Stack erfasst wird:

.. code-block:: php
   :linenos:

   <?php $this->headStyle()->captureStart() ?>
   body {
       background-color: <?php echo $this->bgColor ?>;
   }
   <?php $this->headStyle()->captureEnd() ?>

Die folgenden Annahmen werden gemacht:

- Die Style Deklarationen werden dem Stack angefügt. Wenn Sie den Stack ersetzen sollen oder an den Anfang
  hinzugefügt werden sollten muß 'SET' oder 'PREPEND' als erstes Argument an ``captureStart()`` übergeben werden

- Wenn zusätzliche Attribute für das **<style>** Tag spezifiziert werden sollen, dann müssen diese in einem
  Array als zweites Argument an ``captureStart()`` übergeben werden.


