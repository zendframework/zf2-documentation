.. _zend.currency.calculation:

Rechnen mit Währungen
=====================

Wenn man mit Währungen arbeitet muss man manchmal mit Ihnen kalkulieren. ``Zend_Currency`` erlaubt das mit einigen
einfachen Methoden. Die folgenden Methoden sind zur Unterstützung von Berechnungen:

- **add()**: Diese Methode addiert die angegebene Währung zum existierenden Währungsobjekt.

- **sub()**: Diese Methode substrahiert die angegebene Währung vom existierenden Währungsobjekt.

- **div()**: Diese Methode dividiert die angegebene Währung vom existierenden Währungsobjekt.

- **mul()**: Diese Methode multipliziert die angegebene Währung zum existierenden Währungsobjekt.

- **mod()**: Diese Methode berechnet den verbleibenden Wert (Modulo) einer Division der angegebenen Währung vom
  existierenden Währungsobjekt.

- **compare()**: Diese Methode vergleicht die angegebene Währung mit dem existierenden Währungsobjekt. Wenn beide
  Werte identisch sind wird '0' zurückgegeben. Wenn der existierende Währungswert größer als der angegebene ist
  gibt diese Methode 1 zurück. Andernfalls wird '-1' zurückgegeben.

- **equals()**: Diese Methode vergleicht die angegebene Währung mit dem existierenden Währungsobjekt. Wenn beide
  Werte identisch sind wird ``TRUE`` zurückgegeben, andernfalls ``FALSE``.

- **isMore()**: Diese Methode vergleicht die angegebene Währung mit dem existierenden Währungsobjekt. Wenn die
  existierende Währung größer als die angegebene ist wird ``TRUE`` zurückgegeben, andernfalls ``FALSE``.

- **isLess()**: Diese Methode vergleicht die angegebene Währung mit dem existierenden Währungsobjekt. Wenn die
  existierende Währung kleiner als die angegebene ist wird ``TRUE`` zurückgegeben, andernfalls ``FALSE``.

Wie man sehen kann erlauben die verschiedenen Methoden mit ``Zend_Currency`` jede Art der Berechnung. Die nächsten
Schnipsel zeigen einige Beispiele:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency; // Könnte '$ 1.000,00' zurückgeben

   $currency->add(500);
   print $currency; // Könnte '$ 1.500,00' zurückgeben

.. code-block:: php
   :linenos:

   $currency_2 = new Zend_Currency(
       array(
           'value'    => 500,
           'currency' => 'USD',
       )
   );

   if ($currency->isMore($currency_2)) {
       print "First is more";
   }

   $currency->div(5);
   print $currency; // Könnte '$ 200,00' zurückgeben


