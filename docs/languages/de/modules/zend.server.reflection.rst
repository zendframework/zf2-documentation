.. EN-Revision: none
.. _zend.server.reflection:

Zend\Server\Reflection
======================

.. _zend.server.reflection.introduction:

Einführung
----------

``Zend\Server\Reflection`` stellt einen Standardmechanismus für Funktion und Klassen Introspektion für die
Verwendung der Serverklassen bereit. Es basiert auf der *PHP* 5 Reflection *API* und erweitert diese, um Methoden
für die Erhaltung von Parameter und Rückgabewerttypen und Beschreibung, eine komplette Liste mit Funktion und
Methoden Prototypen (d.h. alle möglichen, gültigen Aufrufkombinationen) sowie Funktions- oder
Methodenbeschreibungen bereit zu stellen.

Normalerweise wird diese Funktionalität nur von Entwicklern von Serverklassen für das Framework verwendet.

.. _zend.server.reflection.usage:

Verwendung
----------

Die grundlegende Verwendung ist einfach:

.. code-block:: php
   :linenos:

   $class    = Zend\Server\Reflection::reflectClass('My_Class');
   $function = Zend\Server\Reflection::reflectFunction('my_function');

   // Prototypen auslesen
   $prototypes = $reflection->getPrototypes();

   // Durch jeden Prototyp laufen für die Funktion
   foreach ($prototypes as $prototype) {

       // Rückgabe Typ des Prototypen ausgeben
       echo "Rückgabe Typ: ", $prototype->getReturnType(), "\n";

       // Parameter des Prototypen ausgeben
       $parameters = $prototype->getParameters();

       echo "Parameter: \n";
       foreach ($parameters as $parameter) {
           // Parameter Typ ausgeben
           echo "    ", $parameter->getType(), "\n";
       }
   }

   // Erhalte Namensraum für eine Klasse, Funktion oder Methode.
   // Namensräume können zum Zeitpunkt der Instanzierung gesetzt werden
   // (zweites Argument) oder durch Verwendung von setNamespace()
   $reflection->getNamespace();

``reflectFunction()`` gibt ein ``Zend\Server\Reflection\Function`` Objekt zurück; ``reflectClass()`` gibt ein
``Zend\Server\Reflection\Class`` Objekt zurück. Bitte die *API* Documentation beachten, um zu erfahren, welche
Methoden für beide Klassen verfügbar sind.


