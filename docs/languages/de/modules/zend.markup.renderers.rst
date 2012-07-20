.. _zend.markup.renderers:

Zend_Markup Renderer
====================

``Zend_Markup`` wird aktuell mit einem Renderer ausgeliefert, dem *HTML* Renderer.

.. _zend.markup.renderers.add:

Eigene Markups hinzufügen
-------------------------

Indem man eigene Merkups hinzufügt, kann man den ``Zend_Markup`` Renderern eigene Funktionalitäten hinzufügen.
Mit der Markup Struktur kann man jede Funktionalität welche man haben will hinzufügen. Von einfachen Markups bis
zu komplizierten Markup Strukturen. Ein einfaches Beispiel für ein 'foo' Markup:

.. code-block:: php
   :linenos:

   // Erstellt eine Instanz von Zend_Markup_Renderer_Html,
   // mit Zend_Markup_Parser_BbCode als seinen Parser
   $bbcode = Zend_Markup::factory('Bbcode');

   // Dies erstellt ein einfaches 'foo' Markup
   // Der erste Parameter definiert den Namen des Markups
   // Der zweite Parameter nimmt ein Integer welche den Typ des Markups definiert
   // Der dritte Parameter ist ein Array die andere Dinge des Markups definiert
   // wie die Gruppe des Markups, und (in diesem Fall) ein Start und Ende Markup
   $bbcode->addMarkup(
       'foo',
       Zend_Markup_Renderer_RendererAbstract::TYPE_REPLACE,
       array(
           'start' => '-bar-',
           'end'   => '-baz-',
           'group' => 'inline'
       )
   );

   // Jetzt gibt dies folgendes aus: 'my -bar-markup-baz-'
   echo $bbcode->render('my [foo]markup[/foo]');

Es gilt zu beachten das die Erstellung eigener Markups nur dann Sinn macht wenn der eigene Parser diese auch in
einer Markup Struktur unterstützt. Aktuell unterstützt dies nur BBCode. Textile hat keine Unterstützung für
eigene Markups.

Einige Renderer (wie der *HTML* Renderer) enthalten auch Unterstützung für einen 'markup' Parameter. Dieser
ersetzt die 'start' und 'end' Parameter, und er stellt die Markups inklusive einiger Standardattribute und dem
schließenden Markup dar.

.. _zend.markup.renderers.add.callback:

Ein Callback Markup hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Durch das Hinzufügen eines Callback Markups kann man viel mehr tun als nur das einfache Ersetzen von Markups. Zum
Beispiel kann man den Inhalt ändern, die Parameter verwenden um die Ausgabe zu beeinflussen, usw.

Ein Callback ist eine Klasse welche das ``Zend_Markup_Renderer_TokenInterface`` Interface implementiert. Ein
Beispiel einer einfachen Callback Klasse:

.. code-block:: php
   :linenos:

   class My_Markup_Renderer_Html_Upper
       implements Zend_Markup_Renderer_TokenConverterInterface
   {

       public function convert(Zend_Markup_Token $token, $text)
       {
           return '!up!' . strtoupper($text) . '!up!';
       }

   }

Jetzt kann man das 'upper' Markup, mit einem Callback einer Instanz der Klasse ``My_Markup_Renderer_Html_Upper``
hinzufügen. Ein einfaches Beispiel:

.. code-block:: php
   :linenos:

   // Erstellt eine Instanz von Zend_Markup_Renderer_Html,
   // mit Zend_Markup_Parser_BbCode als seinen Parser
   $bbcode = Zend_Markup::factory('Bbcode');

   // Das erstellt ein einfaches 'foo' Markup
   // Der erste Parameter definiert den Namen des Markups
   // Der zweite Parameter nimmt ein Integer welches den Markuptyp definiert
   // Der dritte Parameter ist ein Array welches andere Dinge über ein Markup
   // definiert, wie die Gruppe des Markups und (in diesem Fall) ein Start und Ende
   // Markup
   $bbcode->addMarkup(
       'upper',
       Zend_Markup_Renderer_RendererAbstract::TYPE_CALLBACK,
       array(
           'callback' => new My_Markup_Renderer_Html_Upper(),
           'group'    => 'inline'
       )
   );

   // Jetzt wird die folgende Ausgabe erstellt: 'my !up!MARKUP!up!'
   echo $bbcode->render('my [upper]markup[/upper]');

.. _zend.markup.renderers.list:

Liste der Markups
-----------------

.. _zend.markup.renderers.list.markups:

.. table:: Liste der Markups

   +--------------------------------------------------------+---------------------------------------------------------+
   |Beispiel Eingabe (BBCode)                               |Beispiel Ausgabe                                         |
   +========================================================+=========================================================+
   |[b]foo[/b]                                              |<strong>foo</strong>                                     |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[i]foo[/i]                                              |<em>foo</em>                                             |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[cite]foo[/cite]                                        |<cite>foo</cite>                                         |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[del]foo[/del]                                          |<del>foo</del>                                           |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[ins]foo[/ins]                                          |<ins>foo</ins>                                           |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[sup]foo[/sup]                                          |<sup>foo</sup>                                           |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[sub]foo[/sub]                                          |<sub>foo</sub>                                           |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[span]foo[/span]                                        |<span>foo</span>                                         |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[acronym title="PHP Hypertext Preprocessor]PHP[/acronym]|<acronym title="PHP Hypertext Preprocessor">PHP</acronym>|
   +--------------------------------------------------------+---------------------------------------------------------+
   |[url=http://framework.zend.com/]Zend Framework[/url]    |<a href="http://framework.zend.com/">Zend Framework</a>  |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[h1]foobar[/h1]                                         |<h1>foobar</h1>                                          |
   +--------------------------------------------------------+---------------------------------------------------------+
   |[img]http://framework.zend.com/images/logo.gif[/img]    |<img src="http://framework.zend.com/images/logo.gif" />  |
   +--------------------------------------------------------+---------------------------------------------------------+


