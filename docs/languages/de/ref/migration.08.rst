.. _migration.08:

Zend Framework 0.8
==================

Wenn man von einem älteren Release auf Zend Framework 0.8 oder höher hochrüstet sollte man die folgenden
Migrations Hinweise beachten.

.. _migration.08.zend.controller:

Zend_Controller
---------------

Durch bisherige Änderungen bleibt die wesentliche Verwendung der *MVC* Komponenten gleich:

.. code-block:: php
   :linenos:

   require_once 'Zend/Controller/Front.php';
   Zend_Controller_Front::run('/path/to/controllers');

Dennoch wurde die Verzeichnisstruktur gründliche überarbeitet, verschiedene Komponenten wurden entfernt und
mehrere andere umbenannt und hinzugefügt. Die Änderungen beinhalten:

- ``Zend_Controller_Router`` wurde entfernt für den Rewrite Router entfernt.

- ``Zend_Controller_RewriteRouter`` wurde in ``Zend_Controller_Router_Rewrite`` umbenannt und zum Standard Router
  befördert, der mit dem Framework ausgeliefert wird; ``Zend_Controller_Front`` wird ihn als Standard verwenden,
  wenn kein anderer Router übergeben wird.

- Eine neue Route Klasse für die Verwendung mit dem Rewrite Router wurde eingeführt:
  ``Zend_Controller_Router_Route_Module``; sie deckt die Standardrouten ab, die vom *MVC* verwendet werden und
  bietet die Unterstützung für :ref:`Controller Module <zend.controller.modular>`.

- ``Zend_Controller_Router_StaticRoute`` wurde umbenannt in ``Zend_Controller_Router_Route_Static``.

- ``Zend_Controller_Dispatcher`` wurde umbenannt in ``Zend_Controller_Dispatcher_Standard``.

- ``Zend_Controller_Action::_forward()``'s Argumente wurden geändert. Die Signatur ist nun:

  .. code-block:: php
     :linenos:

     final protected function _forward($action,
                                       $controller = null,
                                       $module = null,
                                       array $params = null);

  ``$action`` wird immer benötigt; wenn kein Controller angegeben wird, wird eine Action im aktuellen Controller
  angenommen. ``$module`` wird immer ignoriert, es sei denn ``$controller`` wird angegeben. Schließlich werden
  alle übergebenen Parameter ``$params`` an das Request Objekt angehängt. Wenn man keinen Controller oder kein
  Modul angeben, aber dennoch Parameter übergeben möchte, gibt man einfach ``NULL`` für diese Werte an.


