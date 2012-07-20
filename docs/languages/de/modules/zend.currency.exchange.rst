.. _zend.currency.exchange:

Währungen wechseln
==================

Im vorherigen Abschnitt haben wir die Berechnung der Währung besprochen. Aber wie man sich vorstellen kann
bedeutet das Rechnen mit Währungen oft das man mit unterschiedlichen Währungen von verschiedenen Ländern rechnen
will.

In diesem Fall müssen die Währungen gewechselt werden so dass beide die selbe Währung verwenden. Im wirklichen
Leben ist diese Information von Banken oder Tageszeitungen erhältlich. Aber wir sind im Web, also sollten wir
vorhandene Wechselservices verwenden. ``Zend_Currency`` erlaubt deren Verwendung mit einem einfachen Callback.

Zuerst schreiben wir ein einfaches Umrechnungsservice.

.. code-block:: php
   :linenos:

   class SimpleExchange implements Zend_Currency_CurrencyInterface
   {
       public function getRate($from, $to)
       {
           if ($from !== "USD") {
               throw new Exception('Wir können nur USD umrechnen');
           }

           switch ($to) {
               case 'EUR':
                   return 2;
               case 'JPE':
                   return 0.7;
          }

          throw new Exception('$to kann nicht umgerechnet werden');
       }
   }

Wir haben jetzt ein manuelles Umrechnungsservice erstellt. Es passt nicht im wirklichen Leben, aber es zeigt wie
die Umrechnung von Währungen arbeitet.

Unsere Umrechnungsklasse muss das ``Zend_Currency_CurrencyInterface`` Interface implementieren. Diese Interface
erwartet das die einzige Methode ``getRate()`` implementiert wird. Diese Methode hat zwei Parameter die Sie
empfängt. Beide sind die Kurznamen für die angegebenen Währungen. ``Zend_Currency`` auf der anderen Seite
erwartet dass der Umrechnungsfaktor zurückgegeben wird.

In einer lebenden Umrechnungsklasse wird man warscheinlich einen Serviceprovider nach den richtigen
Umrechnungsfaktoren fragen. Für unser Beispiel ist der händische Faktor in Ordnung.

Jetzt verbinden wir unsere Umrechnungsklasse einfach mit ``Zend_Currency``. Es gibt zwei Wege mit denen das getan
werden kann. Entweder durch Anhängen einer Instanz der Umrechnungsklasse, oder einfach durch Angabe eines Strings
mit dem Klassennamen.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'EUR',
       )
   );

   $service  = new SimpleExchange();

   // Das Umrechnungsservice anfügen
   $currency->setService($service);

   $currency2 = new Zend_Currency(
       array(
           'value'    => 1000,
           'currency' => 'USD',
       )
   );

   print $currency->add($currency2);

Um obigen Beispeil wird '$ 3.000' zurückgegeben weil die 1.000 *USD* mit dem Faktor 2 in 2.000 *EUR* umgerechnet
werden.

.. note::

   **Kalkulation ohne Umrechnungsservice**

   Wenn man versucht zwei Währungsobjekte zu berechnen wenn diese nicht die selbe Währung haben und kein
   Umrechnungsservice angehängt wurde, erhält man eine Exception. Der Grund hierfür ist, dass ``Zend_Currency``
   dann nicht mehr in der Lage ist zwischen verschiedenen Währungen zu wechseln.


