.. EN-Revision: none
.. _migration.18:

Zend Framework 1.8
==================

Wenn man von einem älteren Release auf Zend Framework 1.8 oder höher hochrüstet sollte man die folgenden
Migrations Hinweise beachten.

.. _migration.18.zend.controller:

Zend_Controller
---------------

.. _migration.18.zend.controller.router:

Änderungen der Standard Route
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Da übersetzte Segmente in der neuen Standard Route eingeführt wurden, ist das '**@**' Zeichen kein spezielles
Zeichen am Begin eines Segments der Route. Um es trotzdem in einem statischen Segment verwenden zu können, muß es
durch das Voranstellen eines zweiten '**@**' Zeichens escapt werden. Die selbe Regel trifft für das '**:**'
Zeichen zu:

.. _migration.18.zend.locale:

Zend_Locale
-----------

.. _migration.18.zend.locale.defaultcaching:

Standard Caching
^^^^^^^^^^^^^^^^

Ab Zend Framework 1.8 wurde ein standardmäßiges Caching hinzugefügt. Der Grund für diese Änderung war, das die
meisten Benutzer Performance Probleme hatten, aber kein Caching verwendet wurde. Da der I18n Core eine Engstelle
ist wenn kein Caching verwendet wird, wurde entschieden ein standardmäßiges Caching hinzuzufügen wenn für
``Zend_Locale`` kein Cache gesetzt wurde.

Manchmal ist es trotzdem gewünscht ein Cachen zu verhindern, selbst wenn das die Performance beeinträchtigt. Um
das zu tun kann das Cachen durch Verwendung der ``disableCache()`` Methode abgeschaltet werden.

.. _migration.18.zend.locale.defaultcaching.example:

.. rubric:: Standardmäßiges Caching abschalten

.. code-block:: php
   :linenos:

   Zend\Locale\Locale::disableCache(true);


