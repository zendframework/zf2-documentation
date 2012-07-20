.. _zend.markup.parsers:

Zend_Markup Parser
==================

``Zend_Markup`` wird aktuell mit zwei Parsern ausgeliefert, einen BBCode Parser und einen Textile Parser.

.. _zend.markup.parsers.theory:

Theorie des Parsens
-------------------

Die Parser von ``Zend_Markup`` sind Klasse die Text mit Markup in einen Token Baum konvertieren. Auch wenn wir hier
den BBCode Parser als Beispiel verwenden ist die Idee des Token Baums die gleiche bei allen Parsern. Wir beginnen
mit diesem Teil von BBCode als Beispiel:

.. code-block:: php
   :linenos:

   [b]foo[i]bar[/i][/b]baz

Der BBCode Parser nimmt diesen Wert, teilt Ihn auf und erzeugt den folgenden Baum:

- [b]

  - foo

  - [i]

    - bar

- baz

Wie man sieht sind die schließenden Tags weg. Sie werden nicht als Inhalt der Baumstruktur angezeigt. Das ist
deswegen der Fall, da schließende Tags kein Teil des aktuellen Inhalts sind. Das bedeutet aber nicht das die
schließenden Tags einfach verloren sind. Sie sind in der Tag Information für das Tag selbst gespeichert. Es ist
auch zu beachten das dies nur eine vereinfachte Darstelliung des Baumes selbst ist. Der aktuelle Baum enthält viel
mehr Information, wie die Attribute der Tags und deren Namen.

.. _zend.markup.parsers.bbcode:

Der BBCode Parser
-----------------

Der BBCode Parser ist ein ``Zend_Markup`` Parser der BBCode in einen Token Baum konvertiert. Die Syntax alle BBCode
Tags ist:

.. code-block:: text
   :linenos:

   [name(=(value|"value"))( attribute=(value|"value"))*]

Einige Beispiel von gültigen BBCode Tags sind:

.. code-block:: php
   :linenos:

   [b]
   [list=1]
   [code file=Zend/Markup.php]
   [url="http://framework.zend.com/" title="Zend Framework!"]

Standardmäßig werden alle Tags durch Verwendung des Formats '[/tagname]' geschlossen.

.. _zend.markup.parsers.textile:

Der Textile Parser
------------------

Der Textile Parser ist ein ``Zend_Markup`` Parser der Textile in einen Token Baum konvertiert. Weil Textile keine
Tag Struktur hat ist nachfolgend eine Liste von Beispiel Tags:

.. _zend.markup.parsers.textile.tags:

.. table:: Liste der grundsätzlichen Textile Tags

   +-------------------------------------------+---------------------------------------------------------+
   |Beispiel Eingabe                           |Beispiel Ausgabe                                         |
   +===========================================+=========================================================+
   |\*foo*                                     |<strong>foo</strong>                                     |
   +-------------------------------------------+---------------------------------------------------------+
   |\_foo_                                     |<em>foo</em>                                             |
   +-------------------------------------------+---------------------------------------------------------+
   |??foo??                                    |<cite>foo</cite>                                         |
   +-------------------------------------------+---------------------------------------------------------+
   |-foo-                                      |<del>foo</del>                                           |
   +-------------------------------------------+---------------------------------------------------------+
   |+foo+                                      |<ins>foo</ins>                                           |
   +-------------------------------------------+---------------------------------------------------------+
   |^foo^                                      |<sup>foo</sup>                                           |
   +-------------------------------------------+---------------------------------------------------------+
   |~foo~                                      |<sub>foo</sub>                                           |
   +-------------------------------------------+---------------------------------------------------------+
   |%foo%                                      |<span>foo</span>                                         |
   +-------------------------------------------+---------------------------------------------------------+
   |PHP(PHP Hypertext Preprocessor)            |<acronym title="PHP Hypertext Preprocessor">PHP</acronym>|
   +-------------------------------------------+---------------------------------------------------------+
   |"Zend Framework":http://framework.zend.com/|<a href="http://framework.zend.com/">Zend Framework</a>  |
   +-------------------------------------------+---------------------------------------------------------+
   |h1. foobar                                 |<h1>foobar</h1>                                          |
   +-------------------------------------------+---------------------------------------------------------+
   |h6. foobar                                 |<h6>foobar</h6>                                          |
   +-------------------------------------------+---------------------------------------------------------+
   |!http://framework.zend.com/images/logo.gif!|<img src="http://framework.zend.com/images/logo.gif" />  |
   +-------------------------------------------+---------------------------------------------------------+

Auch der Textile Parser wrappt alle Tags in Paragraphen; ein Paragraph endet mit zwei Leerzeilen, und wenn es mehr
Tags gibt, wird ein neuer Paragraph hinzugefügt.

.. _zend.markup.parsers.textile.lists:

Listen
^^^^^^

Der Textile Parser unterstützt auch zwei Typen von Listen. Den nummerischen Typ der das "#" Zeichen verwendet und
Bullet-Listen welche das "\*" Zeichen verwenden. Anbei ein Beispiel für beide Listen:

.. code-block:: php
   :linenos:

   # Element 1
   # Element 2

   * Element 1
   * Element 2

Das obige erzeugt zwei Listen: Die erste nummeriert; und die zweite mit Punkten. In den Listen Elementen können
normale Tags wie dick (\*), und hochgestellt (\_) verwendet werden. Tags die auf einer neuen Zeile beginnen müssen
(wie 'h1' usw.) können nicht innerhalb von Listen verwendet werden.


