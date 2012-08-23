.. EN-Revision: none
.. _learning.form.decorators.intro:

Einführung
==========

:ref:`Zend_Form <zend.form>` verwendet das **Decorator** Pattern um Elemente und Formulare darzustellen. Anders als
das klassische `Decorator Pattern`_, dem man ein Objekt übergibt um eine Klasse zu umhüllen, implementieren die
Decorators in ``Zend_Form`` ein `Strategy Pattern`_, und verwenden die Metadaten welche in einem Element oder
Formular enthalten sind um eine Repräsenation von Ihm zu erstellen.

Man sollte sich von der Ausdrucksweise nicht erschrecken lassen. Trotzdem, im Herzen sind Decorators in
``Zend_Form`` schrecklich einfach, und das nachfolgende Mini-Tutorial sollte helfen damit zurecht zu kommen. Es
führt durch die Grundsätze der Decoration, den ganzen Weg für die Erstellung von Decorators für kombinierte
Elemente.



.. _`Decorator Pattern`: http://en.wikipedia.org/wiki/Decorator_pattern
.. _`Strategy Pattern`: http://en.wikipedia.org/wiki/Strategy_pattern
