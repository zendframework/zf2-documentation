.. _zend.currency.usage:

Zend_Currency verwenden
=======================

.. _zend.currency.usage.generic:

Generelle Verwendung
--------------------

Der einfachste Anwendungsfall in einer Anwendung ist die Verwendung des Gebietsschemas des Clients. Wenn man eine
Instanz von ``Zend_Currency`` erstellt ohne eine Option anzugeben, wird das Gebietsschema des Clients verwendet um
die richtige Währung zu setzen.

.. _zend.currency.usage.generic.example-1:

.. rubric:: Erstellung einer Währung mit Client Einstellungen

Angenommen unser Client hat "en_US" als gewünschte Sprache in seinem Browser gesetzt. In diesem Fall wird
``Zend_Currency`` die Währung welche zu verwenden automatisch erkannt.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency();

   // Siehe die Standardwerte welche vom Client abhängen
   // var_dump($currency);

Das erstellte Objekt würde jetzt die Währung "US Dollar" enthalten da dies die aktuell zugeordnete Währung für
US (Vereinigte Staaten) ist. Es wurden auch andere Optionen gesetzt wie "$" für das Währungszeichen oder "USD"
für die Abkürzung.

.. note::

   **Die automatische Erkennung des Gebietsschemas funktioniert nicht immer**

   Es ist zu beachten das die automatische Erkennung des Gebietsschemas nicht immer richtig funktioniert. Der Grund
   für dieses Verhalten liegt darin das ``Zend_Currency`` ein Gebietsschema benötigt welches eine Region
   enthält. Wenn der Client nur "en" als Gebietsschema setzt würde ``Zend_Currency`` nicht mehr wissen welches
   der mehr als 30 Länder gemeint ist. In diesem Fall wird eine Exception geworfen.

   Ein Client könnte die Einstellungen des Gebietsschemas in seinem Browser auch unterdrücken. Das würde zum
   Problem führen dass die Einstellungen der eigenen Umgebung als Fallback verwendet werden und dies könnte auch
   zu einer Exception führen.

.. _zend.currency.usage.locale:

Erstellung einer Währung basierend auf einem Gebietsschema
----------------------------------------------------------

Um diese Probleme mit dem Client zu vermeiden kann man das gewünschte Gebietsschema einfach manuell setzen.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency('en_US');

   // Man könnte auch die 'locale' Option verwenden
   // $currency = new Zend_Currency(array('locale' => 'en_US'));

   // Siehe die aktuellen Einstellungen welche auf 'en_US' fixiert sind
   // var_dump($currency);

Wie in unserem ersten Beispiel ist die verwendete Währung "US Dollar". Aber jetzt sind wir nicht mehr von den
Einstellungen des Clients abhängig.

``Zend_Currency`` unterstützt auch die Verwendung eines Anwendungsweiten Gebietsschemas. Man kann eine Instanz von
``Zend_Locale`` wie anbei gezeigt in der Registry setzen. Mit dieser Schreibweise vermeidet man das manuelle Setzen
des Gebietsschemas für jede Instanz, wenn man das selbe Gebietsschema in der gesamten Anwendung verwenden will.

.. code-block:: php
   :linenos:

   // In der Bootstrap Datei
   $locale = new Zend_Locale('de_AT');
   Zend_Registry::set('Zend_Locale', $locale);

   // Irgendwo in der Anwendung
   $currency = new Zend_Currency();

.. _zend.currency.usage.territory:

Erstellung einer Währung basierend auf einem Land
-------------------------------------------------

``Zend_Currency`` ist auch in der Lage basierend auf einem angegebenen Land zu arbeiten indem intern
``Zend_Locale`` verwendet wird.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency('US');

   // See the actual settings which are fixed to 'en_US'
   // var_dump($currency);

.. note::

   **Uppercase territories**

   When you know that you are using a territory, then you should uppercase it. Otherwise you could get an in your
   eyes false locale in return. For example, when you give "om" then you could expect "ar_OM" to be returned. But
   in fact it returns "om", as it's also a language.

   Therefor always uppercase the input when you know that a territory is meant.


