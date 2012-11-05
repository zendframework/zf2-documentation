.. EN-Revision: none
.. _zend.filter.set.callback:

Callback
========

Dieser Filter erlaubt es einem eigene Methoden in Verbindung mit ``Zend_Filter`` zu verwenden. Man muß keinen
neuen Filter erstellen wenn man bereits eine Methode hat die diesen Job erledigt.

Nehmen wir an das wir einen Filter erstellen wollen der einen String umdreht.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Callback('strrev');

   print $filter->filter('Hello!');
   // Ausgabe "!olleH"

Wie man sehen kann ist es wirklich sehr einfach ein Callback zu verwenden um einen eigenen Filter zu definieren. Es
ist auch möglich eine Methode zu verwenden, wenn diese innerhalb einer Klasse definiert ist, indem ein Array als
Callback angegeben wird.

.. code-block:: php
   :linenos:

   // Unsere Klassendefinition
   class MyClass
   {
       public function Reverse($param);
   }

   // Die Filter Definition
   $filter = new Zend\Filter\Callback(array('MyClass', 'Reverse'));
   print $filter->filter('Hello!');

Um den aktuell gesetzten Callback zu erhalten kann ``getCallback()`` verwendet werden, und um einen anderen
Callback zu setzen kann ``setCallback()`` verwendet werden.

Es ist auch möglich Standardparameter zu definieren, die der aufgerufenen Methode als Array übergeben werden wenn
der Filter ausgeführt wird. Dieses Array wird mit dem Wert der gefiltert werden soll zusammengehängt.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Callback(
       array(
           'callback' => 'MyMethod',
           'options'  => array('key' => 'param1', 'key2' => 'param2')
       )
   );
   $filter->filter(array('value' => 'Hello'));

Wenn man die oben stehende Methodendefinition manuell aufrufen würde, dann würde das wie folgt aussehen:

.. code-block:: php
   :linenos:

   $value = MyMethod('Hello', 'param1', 'param2');

.. note::

   Man sollte auch beachten das die Definition einer Callback Methode, welche nicht aufgerufen werden kann, eine
   Exception auslöst.


