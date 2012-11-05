.. EN-Revision: none
.. _migration.16:

Zend Framework 1.6
==================

Wenn man von einem älteren Release auf Zend Framework 1.6 oder höher hochrüstet sollte man die folgenden
Migrations Hinweise beachten.

.. _migration.16.zend.controller:

Zend_Controller
---------------

.. _migration.16.zend.controller.dispatcher:

Änderungen im Dispatcher Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Benutzer haben uns darauf aufmerksam gemacht das sowohl ``Zend\Controller\Front`` als auch
``Zend\Controller\Router\Route\Module`` Methoden des Dispatchers verwenden die nicht im Dispatcher Interface waren.
Wir haben jetzt die folgenden drei Methoden hinzugefügt um sicherzustellen das eigene Dispatcher weiterhin mit der
ausgelieferten Implementation arbeiten:

- ``getDefaultModule()``: Sollte den Namen des Standardmoduls zurückgeben.

- ``getDefaultControllerName()``: Sollte den Namen des Standardcontrollers zurückgeben.

- ``getDefaultAction()``: Sollte den Namen der Standardaktion zurückgeben.

.. _migration.16.zend.file.transfer:

Zend\File\Transfer
------------------

.. _migration.16.zend.file.transfer.validators:

Änderungen bei der Verwendung von Prüfungen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wie von Benutzern festgestellt wurde, haben die Prüfungen von ``Zend\File\Transfer`` nicht auf die gleiche Art und
Weise funktioniert wie standardmäßigen von ``Zend_Form``. ``Zend_Form`` erlaubt die Verwendung eines
``$breakChainOnFailure`` Parameters der die Prüfung für alle weitere Prüfer unterbricht wenn ein Prüffehler
aufgetreten ist.

Deshalb wurde dieser Parameter bei allen bestehenden Prüfungen von ``Zend\File\Transfer`` hinzugefügt.

- Alte *API* der Methode: ``addValidator($validator, $options, $files)``.

- Neue *API* der Methode: ``addValidator($validator, $breakChainOnFailure, $options, $files)``.

Um also eigene Skripte auf die neue *API* zu migrieren, muß einfach ein ``FALSE`` nach der Definition der
gewünschten Prüfung hinzugefügt werden.

.. _migration.16.zend.file.transfer.example:

.. rubric:: Wie man eigene Dateiprüfungen von 1.6.1 auf 1.6.2 ändert

.. code-block:: php
   :linenos:

   // Beispiel für 1.6.1
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('FilesSize', array('1B', '100kB'));

   // Selbes Beispiel für 1.6.2 und neuer
   // Beachte das hinzugefügte boolsche false
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('FilesSize', false, array('1B', '100kB'));


