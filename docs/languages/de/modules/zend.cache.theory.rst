.. EN-Revision: none
.. _zend.cache.theory:

Die Theorie des Cachens
=======================

Es gibt 3 Schlüsselkonzepte in ``Zend_Cache``. Eines ist die eindeutige Identifizierung (ein String), die benutzt
wird, um Cache Datensätze zu identifizieren. Das zweite ist die **'lifetime'** Direktive, wie im Beispiel gezeigt;
sie definiert, wie lange eine gecachte Ressource als 'frisch' betrachtet wird. Das dritte Konzept ist die bedingte
Ausführung, so das Teile des Codes komplett übersprungen werden können, was die Leistung steigert. Die
Haupt-Frontend Funktion (eg. ``Zend_Cache_Core::get()``) ist immer so gestaltet, das ``FALSE`` zurückgegeben wird,
wenn ein Cache fehlt. Aber nur, wenn das für die Natur des Frontends Sinn macht. Das erlaubt es Endbenutzern, die
Teile des Codes, die gecached (oder übersprungen) werden sollen, in **if(){ ... }** Anweisungen zu umhüllen,
wobei die Bedingung die ``Zend_Cache`` Methode selbst ist. Am Ende der Blöcke muss das erstellte auf alle Fälle
gespeichert werden (z.B. ``Zend_Cache_Core::save()``).

.. note::

   Das Design der bedingten Ausführung des erzeugten Codes ist in einigen Frontends nicht notwendig (**Function**,
   zum Beispiel) wenn die komplette Logik im verwendeten Frontend integriert ist.

.. note::

   'Cache hit' ist ein Ausdruck für eine Bedingung, wenn ein Cache Datensatz gefunden wurde, er gültig und
   'frisch' ist (in anderen Worten, er ist noch nicht abgelaufen). 'Cache miss' ist alles andere. Wenn ein 'Cache
   miss' passiert, müssen die Daten erzeugt werden (wie man es normalerweise tun würde) und anschließend cachen.
   Wenn ein 'Cache hit' geschieht muß, auf der anderen Seite, das Backend automatisch den Datensatz vom Cache
   transparent holen.

.. _zend.cache.factory:

Die Zend_Cache Factory Methode
------------------------------

Ein guter Weg, um eine verwendbare Instanz eines ``Zend_Cache`` Frontends zu erstellen, wird im folgenden Beispiel
gegeben:

.. code-block:: php
   :linenos:

   // Wir wählen ein Backend (zum Beispiel 'File' oder 'Sqlite'...)
   $backendName = '[...]';

   // Wir wählen ein Frontend (zum Beispiel 'Core', 'Output', 'Page'...)
   $frontendName = '[...]';

   // Wir definieren ein Array von Optionen für das gewählte Frontend
   $frontendOptions = array([...]);

   // Wir definieren ein Array von Optionen für das gewählte Backend
   $backendOptions = array([...]);

   // Wir erstellen eine gute Instanz
   // (natürlich sind die letzten 2 Argumente optional)
   $cache = Zend_Cache::factory($frontendName,
                                $backendName,
                                $frontendOptions,
                                $backendOptions);

In den folgenden Beispielen wird angenommen, dass die ``$cache`` Variable ein gültiges, initiiertes Frontend wie
gezeigt enthält und dass verstanden wird, wie Parameter an das ausgewählte Backend übergeben werden.

.. note::

   Immer ``Zend_Cache::factory()`` benutzen, um eine Frontend Instanz zu bekommen. Das selbstständige
   Instantiieren von Frontends und Backends funktioniert nicht so wie erwartet.

.. _zend.cache.tags:

Markierte Datensätze
--------------------

Markierungen sind ein Weg um Cache Datensätze zu kategorisieren. Wenn der Cache mit der ``save()`` Methode
abgespeichert werden soll, kann ein Array mit Markierungen für diesen Datensatz angelegt werden. Dann besteht die
Möglichkeit, alle markierten Cache Datensätze mit einer bestimmten Markierung (oder Markierungen), zu löschen:

.. code-block:: php
   :linenos:

   $cache->save($huge_data, 'myUniqueID', array('tagA', 'tagB', 'tagC'));

.. note::

   Man beachte, dass die ``save()`` Method einen optionales, viertes Argument akzeptiert: ``$specificLifetime``
   (wenn != ``FALSE``, setzt es eine spezifische Laufzeit für diesen speziellen Cache Eintrag)

.. _zend.cache.clean:

Löschen des Caches
------------------

Um eine bestimmte Cache ID zu entfernen oder annullieren, kann die ``remove()`` Methode benutzt werden:

.. code-block:: php
   :linenos:

   $cache->remove('idToRemove');

Um mehrere Cache IDs mit einer Operation zu entfernen oder annulieren, kann die ``clean()`` Methode benutzt werden.
Zum Beispiel um alle Cache Datensätze zu entfernen :

.. code-block:: php
   :linenos:

   // Löschen aller Datensätze
   $cache->clean(Zend_Cache::CLEANING_MODE_ALL);

   // Nur abgelaufene löschen
   $cache->clean(Zend_Cache::CLEANING_MODE_OLD);

Um Cache Einträge zu löschen, die zu den Tags 'tagA' und 'tagC' entsprechen :

.. code-block:: php
   :linenos:

   $cache->clean(
       Zend_Cache::CLEANING_MODE_MATCHING_TAG,
       array('tagA', 'tagC')
   );

Um Cache Einträge zu löschen die den Tags 'tagA' oder 'tagC' nicht entsprechen:

.. code-block:: php
   :linenos:

   $cache->clean(
       Zend_Cache::CLEANING_MODE_NOT_MATCHING_TAG,
       array('tagA', 'tagC')
   );

Um Cache Einträge zu löschen, die zu den Tags 'tagA' oder 'tagC' entsprechen :

.. code-block:: php
   :linenos:

   $cache->clean(
       Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
       array('tagA', 'tagC')
   );

Mögliche Löschmodi sind: ``CLEANING_MODE_ALL``, ``CLEANING_MODE_OLD``, ``CLEANING_MODE_MATCHING_TAG``,
``CLEANING_MODE_NOT_MATCHING_TAG`` und ``CLEANING_MODE_MATCHING_ANY_TAG``. Die letzteren sind, wie deren Namen
vermuten lassen, kombiniert mit einem Array von Markierungen für die Löschoperation.


