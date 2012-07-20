.. _zend.console.getopt.introduction:

Introduction
============

La classe ``Zend_Console_Getopt`` aide les applications lancées en ligne de commande à analyser les options et
arguments.

Les utilisateurs peuvent spécifier des arguments en ligne de commande quand ils exécutent votre application. Ces
arguments ont du sens dans l'application : changer son comportement, choisir des ressources, ou spécifier des
paramètres. Beaucoup d'options ont une signification usuelle, par exemple "``--verbose``" permet la production
d'informations supplémentaires dans beaucoup d'applications. D'autres options peuvent avoir un sens qui est
différent pour chaque application. Par exemple, "``-c``" prend des sens différents lorsqu'il est utilisé dans
``grep``, ``ls``, et ``tar``.

Nous avons ci-dessous quelques définitions de termes. L'usage commun des termes varie, mais cette documentation
utilisera les définitions ci-dessous.

- "argument" : une chaîne de caractères qui apparaît dans la ligne de commande après le nom de la commande. Les
  arguments peuvent être des options ou bien peut apparaître sans option, appeler des ressources sur lesquelles
  la commande agit.

- "option" : un argument qui signifie que la commande va changer son comportement par défaut d'une manière
  quelconque.

- "flag" (drapeau) : la première partie d'une option, identifie le but de l'option. Un drapeau est précédé
  conventionnellement par un ou deux tirets ("``-``" or "``--``"). Un drapeau court comporte un caractère unique.
  Un drapeau long est une chaîne de plusieurs caractères. Un tiret simple précède un drapeau court ou un groupe
  de drapeaux courts. Un tiret double précède un drapeau long. Les drapeaux longs ne peuvent pas être groupés.

- "parameter" (paramètre) : la seconde partie d'une option ; une donnée qui peut accompagner un drapeau, si c'est
  applicable à l'option donnée. Par exemple, beaucoup de commandes acceptent "``--verbose``", mais typiquement
  cette option n'a aucun paramètre. Cependant, une option comme "``--user`` a presque toujours besoin d'un
  paramètre à sa suite.

  Un paramètre peut être donné comme un argument séparé après un argument de drapeau, ou comme faisant partie
  de la même chaîne de caractères, séparé du drapeau par le symbole égal ("``=``"). La dernière forme est
  autorisée seulement avec des drapeaux longs. Par exemple, ``-u username``, ``--user username``, et
  ``--user=username`` sont des formats supportés par ``Zend_Console_Getopt``.

- "cluster" (groupe) : les drapeaux courts peuvent être combinés dans une chaîne de caractère unique
  précédée par un tiret simple. Par exemple, "``ls -1str``" emploie un groupe de quatre drapeaux courts. Cette
  commande est équivalente à "``ls -1 -s -t -r``". Seuls les drapeaux courts peuvent être groupés. Vous ne
  pouvez pas faire un groupe de drapeaux longs.

Par exemple, dans "``mysql --user=root mabase``", "``mysql``" est la **commande**, "``--user=root``" est une
**option**, "``--user``" est un **drapeau**, "``root``" est un **paramètre** de l'option, et "``mabase``" est un
argument mais pas une option dans notre définition.

``Zend_Console_Getopt`` fournit une interface pour déclarer quels drapeaux sont valides pour votre application,
produit une erreur et un message s'ils emploient un drapeau invalide, et transmet à votre application les drapeaux
spécifiés par l'utilisateur.

.. note::

   **Getopt n'est pas une application framework**

   ``Zend_Console_Getopt`` **n'interprète pas** le sens des drapeaux ou des paramètres, cette classe n'exécute
   pas non plus de processus d'application ou n'invoque pas le code d'application. Vous devez implémenter ces
   actions dans votre propre code d'application. Vous pouvez utiliser la classe ``Zend_Console_Getopt`` pour
   analyser la ligne d'instruction et fournir des méthodes orientées objet pour savoir quelles options ont été
   données par un utilisateur, mais le code pour utiliser ces données pour appeler les parties de votre
   application devra être dans une autre classe *PHP*.

Les sections suivantes décrivent l'utilisation de ``Zend_Console_Getopt``.


