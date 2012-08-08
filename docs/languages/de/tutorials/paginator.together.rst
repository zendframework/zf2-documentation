.. EN-Revision: none
.. _learning.paginator.together:

Alles zusammenfügen
===================

Wir haben gesehen wie ein Paginator Objekt erstellt wurd, wie die Elemente der aktuellen Seite dargestellt werden
und wie ein Navigationselement dargestellt wird um durch die Seiten zu navigieren. In diesem Kapitel sehen wir wie
Paginator in den Rest der MVC Anwendung passt.

Im folgenden Beispiel ignorieren wir die Implementation der besten Praxis bei der ein Service Layer verwendet wird
um das Beispiel einfach und leichter verständlich zu machen. Sobald wir mit der Verwendung von Service Layern
vertraut sind, sollte es einfach sein zu sehen wie Paginator in diesen Ansatz der besten Praxis passt.

Beginnen wir mit dem Controller. Die Beispielanwendung ist einfach und wir geben alles einfach in den
IndexController und die IndexAction. Wie gesagt ist das nur zu Zwecken der Demonstration. Eine echte Anwendung
sollte Controller nicht in dieser Art und Weise verwenden.

.. code-block:: php
   :linenos:

   class IndexController extends Zend_Controller_Action
   {
       public function indexAction()
       {
           // Das Seitenkontroll View Skript einrichten. Siehe das Handbuch zu
           // Seitenkontrollen für weitere Informationen über dieses View Skript
           Zend_View_Helper_PaginationControl::setDefaultViewPartial('controls.phtml');

           // Holt eine bereits instanzierte Datenbank Verbindung von der Registry
           $db = Zend_Registry::get('db');

           // Erstellt ein Select Objekt welches Blog Posts holt, und absteigend
           // anhand des Erstellungsdatums sortiert
           $select = $db->select()->from('posts')->order('date_created DESC');

           // Erstellt einen Paginator für die Abfrage der Blog Posts
           $paginator = Zend_Paginator::factory($select);

           // Die aktuelle Seitenzahl von der Anfrage lesen. Der Standardwert ist
           // 1 wenn keine explizite Seitenzahl angegeben wurde
           $paginator->setCurrentPageNumber($this->_getParam('page', 1));

           // Weist das Paginator Objekt der View zu
           $this->view->paginator = $paginator;
       }
   }

Das folgende View Skript ist das index.phtml View Skript für die indexAction des IndexController's. Das View
Skript kann einfach gehalten werden. Wir nehmen an das der standardmäßige ScrollingStyle verwendet wird.

.. code-block:: php
   :linenos:

   <ul>
   <?php
   // Den Titel jedes Eintrags für die aktuelle Seite
   // in einem Listen-Element darstellen
   foreach ($this->paginator as $item) {
       echo '<li>' . $item["title"] . '</li>';
   }
   ?>
   </ul>
   <?php echo $this->paginator; ?>

Jetzt zum Index des Projekts navigieren und Paginator in Aktion sehen. Was wir in diesem Tutorial diskutiert haben
ist nur die Spitze des Eisbergs. Das Referenz Handbuch und die *API* Dokumentation können mehr darüber sagen das
mit ``Zend_Paginator`` alles getan werden kann.


