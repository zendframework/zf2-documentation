.. _zend.markup.renderers:

Moteurs de rendu Zend_Markup
============================

``Zend_Markup`` est fournie avec un moteur de rendu, le *HTML*.

.. _zend.markup.renderers.add:

Ajouter vos propres markups
---------------------------

En ajoutant vos markups, vous pouvez ajouter vos propres fonctionnalités aux moteurs de rendu de ``Zend_Markup``.
Grâce à la structure en markups, vous pouvez ajouter presque toutes les fonctionnalités que vous voulez, depuis
des markups simples jusqu'à des structures de données complexes. Voici un exemple pour un markup simple 'foo' :

.. code-block:: php
   :linenos:

   // Créer une instance de Zend_Markup_Renderer_Html,
   // avec Zend_Markup_Parser_BbCode comme analyseur
   $bbcode = Zend_Markup::factory('Bbcode');

   // Ceci va créer un markup simple 'foo'
   // Le premier paramètre définit le nom du markup
   // Le second param prend un entier qui définit le type de markup.
   // Le troisième param est un tableau qui définit d'autres caractéristiques
   // du markup comme son groupe et (dans ce cas) les markups de début et de fin
   $bbcode->addMarkup(
       'foo',
       Zend_Markup_Renderer_RendererAbstract::TYPE_REPLACE,
       array(
           'start' => '-bar-',
           'end'   => '-baz-',
           'group' => 'inline'
       )
   );

   // La sortie sera: 'my -bar-markup-baz-'
   echo $bbcode->render('my [foo]markup[/foo]');

Notez que créer vos propres markups n'est utile que si l'analyseur syntaxique en tient compte. Actuellement, seul
BBCode supporte cela. Textile ne supporte pas les markups personnalisés.

Certains moteurs de rendu (comme le moteur *HTML*) supporte un paramètre nommé "markup". Cela remplace les
paramètres "start" et "end", et il effectue le rendu du markup avec des attributs par défaut ainsi que le markup
de fin.

.. _zend.markup.renderers.add.callback:

Ajout d'un markup de rappel(callback)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ajouter des markups de rappel permet de faire bien plus que de simples remplacements. Par exemple, vous pouvez
changer le contenu, utiliser des paramètres pour changer la sortie, etc.

Un rappel est une classe qui implémente ``Zend_Markup_Renderer_TokenInterface`` Voici un exemple de classe de
markup de rappel :

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

Il est possible maintenant d'ajouter le markup "upper", avec comme fonction de rappel, une instance de
``My_Markup_Renderer_Html_Upper``. Voici un exemple :

.. code-block:: php
   :linenos:

   // Créer une instance de Zend_Markup_Renderer_Html,
   // avec Zend_Markup_Parser_BbCode comme analyseur
   $bbcode = Zend_Markup::factory('Bbcode');

   // Ceci va créer un markup simple 'foo'
   // Le premier paramètre définit le nom du markup
   // Le second param prend un entier qui définit le type de markup.
   // Le troisième param est un tableau qui définit d'autres caractéristiques
   // du markup comme son groupe et (dans ce cas) les markups de début et de fin
   $bbcode->addMarkup(
       'upper',
       Zend_Markup_Renderer_RendererAbstract::TYPE_CALLBACK,
       array(
           'callback' => new My_Markup_Renderer_Html_Upper(),
           'group'    => 'inline'
       )
   );

   // La sortie sera: 'my !up!MARKUP!up!'
   echo $bbcode->render('my [upper]markup[/upper]');

.. _zend.markup.renderers.list:

Liste de markups
----------------

.. _zend.markup.renderers.list.tags:

.. table:: Liste de markups

   +--------------------------------------------------------+---------------------------------------------------------+
   |Entrée (bbcode)                                         |Sortie                                                   |
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


