.. _zend.view.helpers.initial.action:

Action View Helfer
==================

Der ``Action`` View Helfer ermöglicht es View Skripten eine gegebene Controller Aktion auszuführen; das Ergebnis
des Antwortsobjektes das der Ausführung folgt wird dann zurückgegeben. Dieses kann verwendet werden wenn eine
bestimmte Aktion wiederverwendbare Inhalte oder "helfende" Inhalte erstellt.

Aktionen die zu einem ``_forward()`` oder einer Umleitung führen werden als ungültig angenommen, und als leerer
String zurückgegeben.

Die *API* für den ``Action`` View Helfer folgt dem der meisten *MVC* Komponenten die Controller Aktionen aufrufen:
``action($action, $controller, $module = null, array $params = array())``. ``$action`` und ``$controller`` werden
benötigt; wenn kein Modul angegeben wird, dann wird das Standardmodul angenommen.

.. _zend.view.helpers.initial.action.usage:

.. rubric:: Grundsätzliche Verwendung von Action View Helfern

Als Beispiel, könnte man einen ``CommentController`` mit einer ``listAction()`` Methode haben die man in
Reihenfolge ausführen will, um eine Liste von Kommentaren für die aktuelle Anfrage herauszuholen:

.. code-block:: php
   :linenos:

   <div id="sidebar right">
       <div class="item">
           <?php echo $this->action('list',
                                    'comment',
                                    null,
                                    array('count' => 10)); ?>
       </div>
   </div>


