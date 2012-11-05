.. EN-Revision: none
.. _zend.validate.set.callback:

Callback
========

``Zend\Validate\Callback`` erlaubt es einen Callback anzugeben der verwendet wird um einen angegebenen Wert zu
prüfen.

.. _zend.validate.set.callback.options:

Unterstützte Optionen für Zend\Validate\Callback
------------------------------------------------

Die folgenden Optionen werden für ``Zend\Validate\Callback`` unterstützt:

- **callback**: Setzt den Callback welcher für die Prüfung aufgerufen wird.

- **options**: Setzt zusätzliche Optionen welche an den Callback übergeben werden.

.. _zend.validate.set.callback.basic:

Grundsätzliche Verwendung
-------------------------

Der einfachste Anwendungsfall besteht darin eine einzelne Funktion zu haben und diese als Callback zu verwenden.
Angenommen wir haben die folgende Funktion.

.. code-block:: .validator.
   :linenos:

   function myMethod($value)
   {
       // einige Prüfungen
       return true;
   }

Um diese in ``Zend\Validate\Callback`` zu verwenden muss man Sie nur auf folgende Weise aufrufen:

.. code-block:: .validator.
   :linenos:

   $valid = new Zend\Validate\Callback('myMethod');
   if ($valid->isValid($input)) {
       // Input scheint gültig zu sein
   } else {
       // Input ist ungültig
   }

.. _zend.validate.set.callback.closure:

Verwendung mit Closures
-----------------------

*.validator.* 5.3 führt `Closures`_ ein, welche grundsätzlich selbst-enthaltene oder **anonyme** Funktionen sind. *.validator.*
nimmt an das Closures eine andere Form eines Callbacks sind, und können daher als solche mit
``Zend\Validate\Callback`` verwendet werden. Als Beispiel:

.. code-block:: .validator.
   :linenos:

   $valid = new Zend\Validate\Callback(function($value){
       // einige Prüfungen
       return true;
   });

   if ($valid->isValid($input)) {
       // Input scheint gültig zu sein
   } else {
       // Input ist ungültig
   }

.. _zend.validate.set.callback.class:

Verwendung mit klassenbasierten Callbacks
-----------------------------------------

Natürlich ist es auch möglich eine Klassenmethode als Callback zu verwenden. Angenommen wir haben die folgende
Klassenmethode:

.. code-block:: .validator.
   :linenos:

   class MyClass
   {
       public function myMethod($value)
       {
           // einige Prüfungen
           return true;
       }
   }

Die Definition des Callbacks ist in diesem Fall fast die gleiche. Man muss nur eine Instanz der Klasse vor der
Methode erstellen und ein Array das den Callback beschreibt:

.. code-block:: .validator.
   :linenos:

   $object = new MyClass;
   $valid = new Zend\Validate\Callback(array($object, 'myMethod'));
   if ($valid->isValid($input)) {
       // Input scheint gültig zu sein
   } else {
       // Input ist ungültig
   }

Man kann auch eine statische Methode als Callback definieren. Angenommen wir haben die folgende Klassendefinition
dann ist die Verwendung des Prüfers wie folgt:

.. code-block:: .validator.
   :linenos:

   class MyClass
   {
       public static function test($value)
       {
           // Einige Prüfungen
           return true;
       }
   }

   $valid = new Zend\Validate\Callback(array('MyClass', 'test'));
   if ($valid->isValid($input)) {
       // Input scheint gültig zu sein
   } else {
       // Input ist ungültig
   }

Letztendlich kann man, wenn man *.validator.* 5.3 verwendet, die magische Methode ``__invoke()`` in der eigenen Klasse
definieren. Wenn man das tut dann funktioniert die Angabe einer Instanz der Klasse genauso:

.. code-block:: .validator.
   :linenos:

   class MyClass
   {
       public function __invoke($value)
       {
           // some validation
           return true;
       }
   }

   $object = new MyClass();
   $valid = new Zend\Validate\Callback($object);
   if ($valid->isValid($input)) {
       // Input scheint gültig zu sein
   } else {
       // Input ist ungültig
   }

.. _zend.validate.set.callback.options2:

Optionen hinzufügen
-------------------

``Zend\Validate\Callback`` erlaubt auch die Verwendung von Optionen welche als zusätzliche Argumente dem Callback
übergeben werden.

Nehmen wir die folgende Klassen und Methoden Definition an:

.. code-block:: .validator.
   :linenos:

   class MyClass
   {
       function myMethod($value, $option)
       {
           // einige Prüfungen
           return true;
       }
   }

Es gibt zwei Wege um den Prüfer über zusätzliche Optionen zu informieren: Diese im Constructor übergeben, oder
Sie mit der Methode ``setOptions()`` übergeben.

Um Sie im Contructor zu übergeben, muss ein Array übergeben werden das die zwei Schlüssel "callback" und
"options" enthält:

.. code-block:: .validator.
   :linenos:

   $valid = new Zend\Validate\Callback(array(
       'callback' => array('MyClass', 'myMethod'),
       'options'  => $option,
   ));

   if ($valid->isValid($input)) {
       // Input scheint gültig zu sein
   } else {
       // Input ist ungültig
   }

Andererseits können Sie dem Prüfer auch nach der Instanzierung übergeben werden:

.. code-block:: .validator.
   :linenos:

   $valid = new Zend\Validate\Callback(array('MyClass', 'myMethod'));
   $valid->setOptions($option);

   if ($valid->isValid($input)) {
       // Input scheint gültig zu sein
   } else {
       // Input ist ungültig
   }

Wenn zusätzliche Werte an ``isValid()`` übergeben werden, dann werden diese Werte unmittelbar nach ``$value``
hinzugefügt.

.. code-block:: .validator.
   :linenos:

   $valid = new Zend\Validate\Callback(array('MyClass', 'myMethod'));
   $valid->setOptions($option);

   if ($valid->isValid($input, $additional)) {
       // Input scheint gültig zu sein
   } else {
       // Input ist ungültig
   }

Wenn der Aufruf zu einem Callback durchgeführt wird, dann wird der Wert der zu überprüfen ist als erstes
Argument an den Callback übergeben gefolgt von allen anderen Werten die an ``isValid()`` übergeben wurden; alle
anderen Optionen folgen Ihm. Die Anzahl und der Typ der Optionen welche verwendet werden ist nicht limitiert.



.. _`Closures`: http://.validator..net/functions.anonymous
