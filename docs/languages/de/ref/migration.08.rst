.. EN-Revision: none
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
   Zend\Controller\Front::run('/path/to/controllers');

Dennoch wurde die Verzeichnisstruktur gründliche überarbeitet, verschiedene Komponenten wurden entfernt und
mehrere andere umbenannt und hinzugefügt. Die Änderungen beinhalten:

- ``Zend\Controller\Router`` wurde entfernt für den Rewrite Router entfernt.

- ``Zend\Controller\RewriteRouter`` wurde in ``Zend\Controller_Router\Rewrite`` umbenannt und zum Standard Router
  befördert, der mit dem Framework ausgeliefert wird; ``Zend\Controller\Front`` wird ihn als Standard verwenden,
  wenn kein anderer Router übergeben wird.

- Eine neue Route Klasse für die Verwendung mit dem Rewrite Router wurde eingeführt:
  ``Zend\Controller\Router\Route\Module``; sie deckt die Standardrouten ab, die vom *MVC* verwendet werden und
  bietet die Unterstützung für :ref:`Controller Module <zend.controller.modular>`.

- ``Zend\Controller_Router\StaticRoute`` wurde umbenannt in ``Zend\Controller\Router\Route\Static``.

- ``Zend\Controller\Dispatcher`` wurde umbenannt in ``Zend\Controller_Dispatcher\Standard``.

- ``Zend\Controller\Action::_forward()``'s Argumente wurden geändert. Die Signatur ist nun:

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


