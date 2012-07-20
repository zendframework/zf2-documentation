.. _zend.markup.parsers:

Analyseurs Zend_Markup (parsers)
================================

``Zend_Markup`` est fourni avec deux analyseurs, BBCode et Textile.

.. _zend.markup.parsers.theory:

Theorie de l'analyse
--------------------

Les analyseurs syntaxiques de ``Zend_Markup`` sont des classes qui convertissent du texte balisé en un arbre
d'identifiants d'analyses, appelées 'tokens'. Même si nous utilisons par la suite l'analyseur BBCode, le principe
de l'arbre à tokens est le même pour tous les analyseurs syntaxiques. Essayons avec un morceau de BBCode par
exemple:

.. code-block:: php
   :linenos:

   [b]foo[i]bar[/i][/b]baz

L'analyseur BBCode va analyser syntaxiquement ce code et en déduire l'arbre suivant:

- [b]

  - foo

  - [i]

    - bar

- baz

Notez que les tags de fermeture n'existent plus dans l'arbre généré. Ceci car ils n'ont pas de valeur
particulière pour la sémantique, ils ne sont pas perdus mais stockés grâce au seul tag d'ouverture. Notez aussi
que ceci n'est qu'une vue simplifiée de l'arbre réel qui contient en réalité bien plus d'informations comme les
attributs éventuels du tag et son nom.

.. _zend.markup.parsers.bbcode:

L'analyseur BBCode
------------------

L'analyseur BBCode est un analyseur de ``Zend_Markup`` qui transforme un code BBCode en arbres à tokens. La
syntaxe des tags BBCode est:

.. code-block:: text
   :linenos:

   [name(=(value|"value"))( attribute=(value|"value"))*]

Des exemples de tags BBCode valides:

.. code-block:: php
   :linenos:

   [b]
   [list=1]
   [code file=Zend/Markup.php]
   [url="http://framework.zend.com/" title="Zend Framework!"]

Par défaut, tous les tags sont fermés avec la syntaxe '[/tagname]'.

.. _zend.markup.parsers.textile:

L'analyseur Textile
-------------------

L'analyseur Textile de ``Zend_Markup`` convertit du texte au format Textile en un arbre à tokens. Textile n'ayant
pas de structure à base de tags, la liste suivante est un exemple de tags:

.. _zend.markup.parsers.textile.tags:

.. table:: Liste de tags Textile basiques

   +-------------------------------------------+---------------------------------------------------------+
   |Entrée                                     |Sortie                                                   |
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

L'analyseur Textile encapsule tous les tags dans des paragraphes; un paragraphe se termine par deux nouvelles
lignes, et s'il y a des tags supplémentaires, un nouveau paragraphe sera ajouté.

.. _zend.markup.parsers.textile.lists:

Listes
^^^^^^

L'analyseur Textile supporte aussi deux types de listes. Le type numérique, utilisant le caractère "#" et le type
anonyme qui utilise lui l'étoile "\*". Exemple des deux listes:

.. code-block:: php
   :linenos:

   # Item 1
   # Item 2

   * Item 1
   * Item 2

Le code ci-dessus génèrera deux listes, la première, numérique; et la seconde, anonyme. Dans les éléments des
listes, vous pouvez utiliser des tags classiques comme le gras (\*), et l'emphase(italique) (\_). Les tags ayant
besoin de créer une nouvelle ligne (comme 'h1' etc.) ne peuvent être utilisés au sein des listes.


