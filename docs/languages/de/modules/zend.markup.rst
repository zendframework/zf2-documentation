.. _zend.markup.introduction:

Einführung
==========

Die Komponente ``Zend_Markup`` bietet einen erweiterbaren Weg für das Parsen von Text und die Darstellung von
leichtgewichtigen Markup Sprachen wie BBcode und Textile. Sie ist ab Zend Framework Version 1.10 vorhanden.

``Zend_Markup`` verwendet eine Factory Methode um eine Instanz eines Renderers zu instanzieren der
``Zend_Markup_Renderer_Abstract`` erweitert. Die Factory Methode akzeptiert drei Argumente. Der erste ist der
Parser welcher verwendet wird um den Text in Token zu zerlegen (z.B. BbCode). Der zweite (optionale) Parameter ist
der Renderer der verwendet wird. Er ist standardmäßig *HTML*. Drittens ein Array mit Optionen die spezifiziert
werden können und mit dem Renderer verwendet werden.


