.. _learning.layout.intro:

Einführung
==========

Wenn eine Website gebaut wird, die Zend Frameworks *MVC* Layer verwendet, sind die View Skripte typischerweise nur
Abschnitte von *HTML* welche der angefragten Aktion angehören. Wenn man zum Beispiel die Aktion "``/user/list``"
hat, könnte man ein View Skript erstellen welches durch die Benutzer iteriert und eine unsortierte Liste
präsentiert:

.. code-block:: php
   :linenos:

   <h2>Benutzer</h2>
   <ul>
       <?php if (!count($this->users)): ?>
       <li>Keine Benutzer gefunden</li>
       <?php else: ?>
       <?php foreach ($this->users as $user): ?>
       <li>
           <?php echo $this->escape($user->fullname) ?>
           (<?php echo $this->escape($user->email) ?>)
       </li>
       <?php endforeach ?>
       <?php endif ?>
   </ul>

Da dies nur ein *HTML* Abschnitt ist, ist dies keine gültige Seite; es fehlt eine *DOCTYPE* Deklaration, und die
öffnenden *HTML* und *BODY* Tags. Die Frage ist also, wie wir diese erstellen?

In frühen Versionen von Zend Framework erstellten Entwickler oft "header" und "footer" View Skripte welche diese
Teile enthielten, und Sie dann in jedem View Skript darstellten. Wärend diese Methode funktioniert ist es auch
schwer Sie im Nachhinein zu verändern, oder kombinierte Inhalte zu erstellen indem mehrere Aktionen aufgerufen
werden.

Das `Two Step View`_ Design Pattern beantwortet viele der gezeigten Probleme. In diesem Pattern wird die
"application" (Anwendungs) View als erstes erstellt, und dann in die "page" (Seite) Views injiziert, welche
anschließend dem Kunden presentiert wird. Die Seitenansicht kann wie ein seitenweites Template oder Layout
angesehen werden, und würde übliche Elemente zwischen den verschiedenen Seiten verwenden.

Im Zend Framework implementiert ``Zend_Layout`` das Two Step View Pattern.



.. _`Two Step View`: http://martinfowler.com/eaaCatalog/twoStepView.html
