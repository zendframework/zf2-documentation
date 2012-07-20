.. _zend.currency.additional:

Zusätzliche Informationen für Zend_Currency
===========================================

.. _zend.currency.additional.informations:

Währungsinformationen
---------------------

Manchmal ist es notwendig Informationen zu erhalten die sich auf eine Währung beziehen. ``Zend_Currency`` bietet
verschiedene Methoden an um diese Informationen zu erhalten. Als vorhandenen Methoden sind die folgenden enthalten:

- **getCurrencyList()**: Gibt eine Liste aller Währungen als Array zurück welche in einer angegebenen Region
  verwendet werden. Wenn keine Region angegeben wurde ist der Standardwert das Gebietsschema des Objekts.

- **getLocale()**: Gibt das gesetzte Gebietsschema für die aktuelle Währung zurück.

- **getName()**: Gibt den kompletten Namen für die aktuelle Währung zurück. Wenn für die aktuelle Währung kein
  kompletter Name vorhanden ist, wird deren Abkürzung zurückgegeben.

- **getRegionList()**: Gibt eine Liste aller Regionen als Array zurück in denen diese Währung verwendet wird.
  Wenn keine Währung angegeben wurde ist der Standardwert das Gebietsschema des Objektes.

- **getService()**: Gibt das, für die aktuelle Währung gesetzte, Service zur Währungsumrechnung zurück.

- **getShortName()**: Gibt die Abkürzung für die aktuelle Währung zurück.

- **getSymbol()**: Gibt das Zeichen für die Währung zurück. Wenn die Währung kein Zeichen enthält, dann wird
  deren Abkürzung zurückgegeben.

- **getValue()**: Gibt den gesetzten Wert für die aktuelle Währung zurück.

Schauen wir uns ein paar Codeabschnitte als Beispiel an:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency();

   var_dump($currency->getValue());
   // Gibt 0 zurück

   var_dump($currency->getRegionList());
   // Könnte ein Array mit allen Regionen zurückgeben in denen USD verwendet wird

   var_dump($currency->getRegionList('EUR'));
   // Gibt ein Array mit allen Regionen zurück in welchen EUR verwendet wird

   var_dump($currency->getName());
   // Könnte 'US Dollar' zurückgeben

   var_dump($currency->getName('EUR'));
   // Gibt 'Euro' zurück

Wie man sehen kann erlauben verschiedene Methode die Verwendung von zusätzlichen Parametern welche das aktuelle
Objekt überschreiben um Informationen für andere Währungen zu erhalten. Bei Unterdrückung dieser Parameter
werden die Informationen von der aktuell gesetzten Währung zurückgegeben.

.. _zend.currency.additional.cache:

Performance Optimierung für Währungen
-------------------------------------

Die Performance von ``Zend_Currency`` kann durch Verwendung von ``Zend_Cache`` optimiert werden. Die statische
Methode ``Zend_Currency::setCache($cache)`` akzeptiert eine Option: einen Adapter für ``Zend_Cache``. Wenn der
Cache Adapter gesetzt ist, werden die Daten der Lokalisierung welche von ``Zend_Currency`` verwendet werden,
gecacht. Zusätzlich gibt es einige statische Methoden für die Manipulation des Caches: ``getCache()``,
``hasCache()``, ``clearCache()`` und ``removeCache()``.

.. _zend.currency.usage.cache.example:

.. rubric:: Währungen cachen

.. code-block:: php
   :linenos:

   // Erstellung eines Cache Objekts
   $cache = Zend_Cache::factory('Core',
                                'File',
                                array('lifetime' => 120,
                                      'automatic_serialization' => true),
                                array('cache_dir'
                                          => dirname(__FILE__) . '/_files/'));
   Zend_Currency::setCache($cache);


