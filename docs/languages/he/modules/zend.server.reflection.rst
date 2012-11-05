.. EN-Revision: none
.. _zend.server.reflection:

Zend\Server\Reflection
======================

.. _zend.server.reflection.introduction:

הקדמה
-----

*Zend\Server\Reflection* מספק מנגנון שליטה ובקרה סטנדרטי לבחינה עצמית של
מחלקות ופונצקיות לשימוש במחלקות שרת. רכיב זה מבוסס על ה Reflection API
של PHP 5, המרחיב אותו בעזרת מתודות להחזרת פרמטרים ותיאורים אודות
מחלקות ופונצקיות שונות, ורשימה מלאה של כל הפונצקיות.

בדרך כלל, ברכיב זה ישתמשו רק מתכנתים אשר משתמשים במחלקות השרת
במערכת.

.. _zend.server.reflection.usage:

שימוש
-----

דוגמא לשימוש:

.. code-block:: php
   :linenos:

   $class    = Zend\Server\Reflection::reflectClass('My_Class');
   $function = Zend\Server\Reflection::reflectFunction('my_function');

   // Get prototypes
   $prototypes = $reflection->getPrototypes();

   // Loop through each prototype for the function
   foreach ($prototypes as $prototype) {

       // Get prototype return type
       echo "Return type: ", $prototype->getReturnType(), "\n";

       // Get prototype parameters
       $parameters = $prototype->getParameters();

       echo "Parameters: \n";
       foreach ($parameters as $parameter) {
           // Get parameter type
           echo "    ", $parameter->getType(), "\n";
       }
   }

   // Get namespace for a class, function, or method.
   // Namespaces may be set at instantiation time (second argument), or using
   // setNamespace()
   $reflection->getNamespace();


*reflectFunction()* מחזיר אובייקט מסוג *Zend\Server_Reflection\Function*; *reflectClass* מחזיר
אובייקט מסוג *Zend\Server_Reflection\Class*. יש לקרוא את הדוקומנטציה כדי לדעת
אילו מתודות יש לכל אחד.


