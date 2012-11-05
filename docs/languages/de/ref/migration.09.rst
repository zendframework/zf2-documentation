.. EN-Revision: none
.. _migration.09:

Zend Framework 0.9
==================

Wenn man von einem älteren Release auf Zend Framework 0.9 oder höher hochrüstet sollte man die folgenden
Migrations Hinweise beachten.

.. _migration.09.zend.controller:

Zend_Controller
---------------

0.9.3 bietet :ref:`Aktionhelfer <zend.controller.actionhelpers>` neu an. Als Teil dieser Änderung wurden die
folgenden Methoden entfernt da Sie nun im :ref:`Weiterleitungs Aktionhelfer
<zend.controller.actionhelpers.redirector>` inkludiert sind:

- ``setRedirectCode()``; wurde umbenannt in ``Zend\Controller\Action\Helper\Redirector::setCode()``.

- ``setRedirectPrependBase()``; wurde umbenannt in ``Zend\Controller\Action\Helper\Redirector::setPrependBase()``.

- ``setRedirectExit()``; wurde umbenannt in ``Zend\Controller\Action\Helper\Redirector::setExit()``.

Lese die :ref:`Aktionhelfer Dokumentation <zend.controller.actionhelpers>` für nähere Informationen über das
empfangen und manipulieren von Helfer Objekten und die :ref:`Weiterleitungshelfer Dokumentation
<zend.controller.actionhelpers.redirector>` für weitere Information über das setzen von Weiterleitungsoptionen
(sowie alternative Methoden des weiterleitens).


