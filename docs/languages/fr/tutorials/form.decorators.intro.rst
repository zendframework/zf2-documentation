.. _learning.form.decorators.intro:

Introduction
============

:ref:`Zend_Form <zend.form>` utilise le pattern **décorateur** afin de générer le rendu des éléments.
Contrairement au pattern `classique du décorateur`_, dans lequel ce sont des objets qui sont passés, les
décorateurs de ``Zend_Form`` implémentent un pattern `strategy`_, et utilisent les méta-données contenues dans
l'élément ou le formulaire afin de créer une représentation de celles-ci.

Ne vous laissez pas surprendre par ces termes, les décorateurs de ``Zend_Form`` ne sont pas terriblement
difficiles et les mini-tutoriels qui suivent vont vous le prouver. Ils vont vous guider pour les bases et les
techniques avancées de décoration.



.. _`classique du décorateur`: http://en.wikipedia.org/wiki/Decorator_pattern
.. _`strategy`: http://en.wikipedia.org/wiki/Strategy_pattern
