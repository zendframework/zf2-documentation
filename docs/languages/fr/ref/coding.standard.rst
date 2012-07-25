.. _coding-standard:

******************************************
Convention de codage PHP de Zend Framework
******************************************

.. _coding-standard.overview:

Vue d'ensemble
--------------

.. _coding-standard.overview.scope:

Portée
^^^^^^

Ce document fournit les lignes directrices pour le formatage de code et la documentation pour les contributeurs
individuels et les équipes contributrices à Zend Framework. Un certain nombre de développeurs utilisant Zend
Framework ont trouvé ces conventions de codage pratique car leurs styles de codage sont cohérents avec l'ensemble
du code de Zend Framework. Il est également à noter qu'il exige un effort significatif pour spécifier
entièrement des normes de codage. Note: parfois les développeurs considèrent l'établissement d'une norme plus
important que ce que cette norme suggère réellement en tout cas au niveau de l'analyse détaillée de la
conception. Les lignes directrices dans les conventions de codage de Zend Framework effectuent un cliché des
pratiques qui ont bien fonctionnées dans le projet Zend Framework. Vous pouvez modifier ces règles ou les
utiliser comme telles en accord avec les termes de votre `licence.`_

Les sujets traités dans les conventions de codage de Zend Framework sont :

   - Formatage des fichiers PHP

   - Conventions de nommage

   - Style de code

   - Documentation en ligne



.. _coding-standard.overview.goals:

Buts
^^^^

De bonnes conventions de codage sont importantes dans tout projet de développement, et plus particulièrement
lorsque plusieurs développeurs travaillent en même temps sur le projet. Avoir ces conventions permet de s'assurer
que le code est de haute qualité, peu buggé et facilement maintenu.

.. _coding-standard.php-file-formatting:

Formatage des fichiers PHP
--------------------------

.. _coding-standard.php-file-formatting.general:

Général
^^^^^^^

Pour les fichiers contenant uniquement du code PHP, la balise de fermeture ("?>") n'est jamais permise. Il n'est
pas requis par PHP. Ne pas l'inclure permet de se prémunir les problèmes liés à l'injection accidentelle
d'espaces blancs dans la sortie.

**IMPORTANT :** L'inclusion de données binaires arbitraires comme il est permis par *__HALT_COMPILER()* est
prohibé dans tout fichier PHP de Zend Framework, ainsi que dans tout fichier dérivé. L'utilisation de cette
possibilité est uniquement permise pour des scripts spéciaux d'installation.

.. _coding-standard.php-file-formatting.indentation:

Indentation
^^^^^^^^^^^

Utilisez une indentation de 4 espaces, sans tabulations.

.. _coding-standard.php-file-formatting.max-line-length:

Longueur maximum d'une ligne
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La longueur souhaitée d'une ligne est de 80 caractères, c'est-à-dire que les développeurs devraient avoir pour
but de ne pas dépasser les 80 caractères pour des raisons pratiques. Cependant, des lignes plus longues sont
acceptables. La longueur maximum de toute ligne de code PHP est de 120 caractères.

.. _coding-standard.php-file-formatting.line-termination:

Terminaison de lignes
^^^^^^^^^^^^^^^^^^^^^

La terminaison de ligne est la terminaison standard pour les fichier textes UNIX. Les lignes doit finir seulement
avec un "linefeed" (LF). Les linefeeds sont représentés comme 10 en ordinal, ou 0x0A en hexadécimal.

Note : N'utilisez pas de retour chariots (CR) comme le font les Macintosh (0x0D) ou de combinaison retour
chariot/linefeed (CRLF) comme le font les ordinateurs sous Windows (0x0D, 0x0A).

.. _coding-standard.naming-conventions:

Conventions de nommage
----------------------

.. _coding-standard.naming-conventions.classes:

Classes
^^^^^^^

Zend Framework emploie une convention de nommage des classes où les noms des classes mènent directement dans les
répertoires dans lesquels elles sont stockées. Le répertoire racine de Zend Framework est le répertoire
"Zend/", tandis que le répertoire racine de la librairie extras de Zend Framework est "ZendX/". Toutes les classes
sont stockées de façon hiérarchique sous ces dossiers racines.

Les noms de classes ne peuvent contenir que des caractères alphanumériques. Les nombres sont autorisés, mais
déconseillés. Les tirets bas ("\_") ne sont autorisés que pour être utilisés comme séparateur de chemin ; le
nom de fichier "Zend/Db/Table.php" doit mener à la classe appelée "Zend_Db_Table".

Si un nom de classe comprend plus d'un mot, la première lettre de chaque nouveau mot doit être mis en majuscule.
La mise en majuscule de lettres successives n'est pas autorisée, c'est-à-dire qu'une classe "Zend_PDF" est
interdit alors que "Zend_Pdf" est autorisé.

Ces conventions définissent un pseudo mécanisme d'espace de noms pour Zend Framework. Zend Framework adoptera la
fonctionnalité des espaces de noms de PHP quand celle-ci sera disponible et qu'il sera possible pour les
développeurs de l'utiliser dans leurs applications.

Regardez les noms de classes dans les librairies standard et extras pour avoir des exemples de cette convention de
nommage. **IMPORTANT :** le code qui opère avec le Framework mais qui n'en fait par partie, c'est-à-dire le code
écrit par un utilisateur et pas Zend ou une des entreprises partenaires, ne doivent jamais commencer par "Zend\_".

.. _coding-standard.naming-conventions.abstracts:

Abstract Classes
^^^^^^^^^^^^^^^^

In general, abstract classes follow the same conventions as :ref:`classes
<coding-standard.naming-conventions.classes>`, with one additional rule: abstract class names must end in the term,
"Abstract", and that term must not be preceded by an underscore. As an example, ``Zend_Controller_Plugin_Abstract``
is considered an invalid name, but ``Zend_Controller_PluginAbstract`` or ``Zend_Controller_Plugin_PluginAbstract``
would be valid names.

.. note::

   This naming convention is new with version 1.9.0 of Zend Framework. Classes that pre-date that version may not
   follow this rule, but will be renamed in the future in order to comply.

   The rationale for the change is due to namespace usage. As we look towards Zend Framework 2.0 and usage of *PHP*
   5.3, we will be using namespaces. The easiest way to automate conversion to namespaces is to simply convert
   underscores to the namespace separator -- but under the old naming conventions, this leaves the classname as
   simply "Abstract" or "Interface" -- both of which are reserved keywords in *PHP*. If we prepend the
   (sub)component name to the classname, we can avoid these issues.

   To illustrate the situation, consider converting the class ``Zend_Controller_Request_Abstract`` to use
   namespaces:

   .. code-block:: php
      :linenos:

      namespace Zend\Controller\Request;

      abstract class Abstract
      {
          // ...
      }

   Clearly, this will not work. Under the new naming conventions, however, this would become:

   .. code-block:: php
      :linenos:

      namespace Zend\Controller\Request;

      abstract class RequestAbstract
      {
          // ...
      }

   We still retain the semantics and namespace separation, while omitting the keyword issues; simultaneously, it
   better describes the abstract class.

.. _coding-standard.naming-conventions.interfaces:

Interfaces
^^^^^^^^^^

In general, interfaces follow the same conventions as :ref:`classes <coding-standard.naming-conventions.classes>`,
with one additional rule: interface names may optionally end in the term, "Interface", but that term must not be
preceded by an underscore. As an example, ``Zend_Controller_Plugin_Interface`` is considered an invalid name, but
``Zend_Controller_PluginInterface`` or ``Zend_Controller_Plugin_PluginInterface`` would be valid names.

While this rule is not required, it is strongly recommended, as it provides a good visual cue to developers as to
which files contain interfaces rather than classes.

.. note::

   This naming convention is new with version 1.9.0 of Zend Framework. Classes that pre-date that version may not
   follow this rule, but will be renamed in the future in order to comply. See :ref:`the previous section
   <coding-standard.naming-conventions.abstracts>` for more information on the rationale for this change.

.. _coding-standard.naming-conventions.filenames:

Noms de fichiers
^^^^^^^^^^^^^^^^

Pour tous les autres fichiers, seuls des caractères alphanumériques, tirets bas et tirets demi-cadratin ("-")
sont autorisés. Les espaces et les caractères spéciaux sont interdits.

Tout fichier contenant du code PHP doit se terminer par l'extension ".php". Ces exemples montrent des noms de
fichiers acceptables pour contenir les noms de classes issus des exemples ci-dessus :

   .. code-block:: php
      :linenos:

      Zend/Db.php

      Zend/Controller/Front.php

      Zend/View/Helper/FormRadio.php

Les noms de fichiers doivent correspondre aux noms des classes décris ci-dessus.

.. _coding-standard.naming-conventions.functions-and-methods:

Fonctions et méthodes
^^^^^^^^^^^^^^^^^^^^^

Les noms de fonctions ne peuvent contenir que des caractères alphanumériques. Les tirets bas ("\_") ne sont pas
permis. Les nombres sont autorisés mais déconseillés.

Les noms de fonctions doivent toujours commencer avec une lettre en minuscule. Quand un nom de fonction est
composé de plus d'un seul mot, la première lettre de chaque mot doit être mise en majuscule. C'est ce que l'on
appelle communément la "notationCamel".

La clarté est conseillée. Le nom des fonctions devrait être aussi explicite que possible, c'est un gage de
compréhension du code.

Voici des exemples de noms acceptables pour des fonctions :

   .. code-block:: php
      :linenos:

      filterInput()

      getElementById()

      widgetFactory()



Pour la programmation orientée objet, les accesseurs aux objets doivent toujours être préfixés par soit "get"
soit "set". Lorsque vous utilisez des motifs de conception, comme le Singleton ou la Fabrique, le nom de la
méthode doit contenir le nom du motif pour permettre une reconnaissance plus simple et plus rapide du motif.

Pour des méthodes d'objet qui sont déclarées avec la construction "private" ou "protected", le premier
caractère du nom variable doit être un tiret bas simple ("\_"). C'est la seule utilisation autorisé d'un tiret
bas dans un nom de méthode. Les méthodes déclarées "public" ne devraient jamais commencer par un tiret bas.

Les fonctions à portée globale ("les fonctions flottantes") sont autorisées mais déconseillées. Il est
recommandé de mettre ces fonctions dans des classes statiques.

.. _coding-standard.naming-conventions.variables:

Variables
^^^^^^^^^

Les noms de variables ne peuvent contenir que des caractères alphanumériques. Les tirets bas ne sont pas permis.
Les nombres sont autorisés mais déconseillés.

Pour les variables membres de classe qui sont déclarées comme "private" ou "protected", le premier caractère du
nom de la variable doit être un tiret bas simple ("\_"). C'est la seule utilisation autorisé d'un tiret bas dans
un nom de variable. Les variables membres "public" ne devraient jamais commencer par un tiret bas.

Tout comme les noms de fonction (cf la section 3.3 ci-dessus), les noms de variables doivent toujours commencer par
un caractère en minuscule et suivre la convention de capitalisation de la "notationCamel".

La clarté est conseillée. Les variables devraient toujours être aussi claires que pratiques. Des noms de
variables comme "$i" et "$n" sont déconseillé pour tout autre usage que les petites boucles. Si une boucle
contient plus de 20 lignes de code, les variables pour les indices doivent avoir des noms descriptifs.

.. _coding-standard.naming-conventions.constants:

Constantes
^^^^^^^^^^

Les constantes peuvent contenir des caractères alphanumériques et des tirets bas. Les nombres sont autorisés.

Les constantes doivent toujours être en majuscule, cependant les mots pouvant les composer doivent être séparés
par des tiret-bats ("\_").

Par exemple, *EMBED_SUPPRESS_EMBED_EXCEPTION* est permis mais *EMBED_SUPPRESSEMBEDEXCEPTION* ne l'est pas.

Les constantes doivent toujours être définies comme des membres d'une classe, en utilisant la construction
"const". Définir des constantes globales avec "define" est permis mais déconseillé.

.. _coding-standard.coding-style:

Style de codage
---------------

.. _coding-standard.coding-style.php-code-demarcation:

Démarcation du code PHP
^^^^^^^^^^^^^^^^^^^^^^^

Les codes PHP doivent toujours être délimités dans la forme complète, par les balises PHP standards :

   .. code-block:: php
      :linenos:

      <?php

      ?>



Les balises courtes d'ouvertures ("<?")ne sont pas autorisées. Pour les fichiers ne contenant que du code PHP, la
balise de fermeture doit toujours être omise (Voir :ref:` <coding-standard.php-file-formatting.general>`).

.. _coding-standard.coding-style.strings:

Chaînes de caractères
^^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.strings.literals:

Chaînes littérales
^^^^^^^^^^^^^^^^^^

Lorsqu'une chaîne est littérale (c'est-à-dire qu'elle ne contient pas de substitution de variables),
l'apostrophe ou guillemet simple doit être utilisé pour démarquer la chaîne :

   .. code-block:: php
      :linenos:

      $a = 'Exemple de chaîne de caractères';



.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

Chaînes de caractères littérales avec apostrophes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lorsque qu'une chaîne littérale contient des apostrophes, il est permis de les démarquer en utilisant les
guillemets doubles. Ceci est particulièrement conseillé pour les requêtes SQL :

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` from `people` "
           . "WHERE `name`='Eric' OR `name`='Caroline'";

La syntaxe ci-dessus est préférée à l'échappement des apostrophes car elle est plus facile à lire.

.. _coding-standard.coding-style.strings.variable-substitution:

Substitution de variables
^^^^^^^^^^^^^^^^^^^^^^^^^

La substitution des variables est permise en utilisant une de ces deux formes :

   .. code-block:: php
      :linenos:

      $greeting = "Bonjour $name, bienvenue !";

      $greeting = "Bonjour {$name}, bienvenue !";



Pour des raisons d'uniformité, cette forme n'est pas permise :

   .. code-block:: php
      :linenos:

      $greeting = "Bonjour ${name}, bienvenue !";



.. _coding-standard.coding-style.strings.string-concatenation:

Concaténation de chaînes
^^^^^^^^^^^^^^^^^^^^^^^^

Les chaînes peuvent êtres concaténées en utilisant l'opérateur ".". Un espace doit toujours être ajouté
avant, et après cet opérateur, cela permet d'améliorer la lisibilité :

   .. code-block:: php
      :linenos:

      $company = 'Zend' . ' ' . 'Technologies';



Lors de la concaténation de chaînes avec l'opérateur ".", il est permis de couper le segment en plusieurs lignes
pour améliorer la lisibilité. Dans ces cas, chaque nouvelle ligne doit être remplie avec des espaces, de façon
à aligner le "." sous l'opérateur "=" :

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` FROM `people` "
           . "WHERE `name` = 'Caroline' "
           . "ORDER BY `name` ASC ";



.. _coding-standard.coding-style.arrays:

Tableaux
^^^^^^^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

Tableaux indexés numériquement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

L'utilisation d'indices négatifs n'est pas permise.

Un tableau indexé peut commencer avec n'importe quel nombre positif, cependant cette méthode est déconseillée.
Il est conseillé de commencer l'indexation à 0.

Lors de la déclaration de tableaux indexés avec la construction *array*, un espace doit être ajouté après
chaque virgule délimitante, pour améliorer la lisibilité :

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio');



Il est aussi permis de déclarer des tableaux indexés sur plusieurs lignes en utilisant la construction *array*.
Dans ce cas, chaque nouvelle ligne doit être remplie par des espaces jusqu'à ce que cette ligne s'aligne, comme
il est montré dans l'exemple suivant :

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500);



Alternately, the initial array item may begin on the following line. If so, it should be padded at one indentation
level greater than the line containing the array declaration, and all successive lines should have the same
indentation; the closing paren should be on a line by itself at the same indentation level as the line containing
the array declaration:

.. code-block:: php
   :linenos:

   $sampleArray = array(
       1, 2, 3, 'Zend', 'Studio',
       $a, $b, $c,
       56.44, $d, 500,
   );

When using this latter declaration, we encourage using a trailing comma for the last item in the array; this
minimizes the impact of adding new items on successive lines, and helps to ensure no parse errors occur due to a
missing comma.

.. _coding-standard.coding-style.arrays.associative:

Tableaux associatifs
^^^^^^^^^^^^^^^^^^^^

Lorsque de la déclaration de tableaux associatifs avec la construction *array*, il est conseillé de séparer la
définition sur plusieurs lignes. Dans ce cas, chaque ligne successive doit être remplie par des espaces pour que
les clés et les valeurs soient alignées :

   .. code-block:: php
      :linenos:

      $sampleArray = array('firstKey'  => 'firstValue',
                           'secondKey' => 'secondValue');



Alternately, the initial array item may begin on the following line. If so, it should be padded at one indentation
level greater than the line containing the array declaration, and all successive lines should have the same
indentation; the closing paren should be on a line by itself at the same indentation level as the line containing
the array declaration. For readability, the various "=>" assignment operators should be padded such that they
align.

.. code-block:: php
   :linenos:

   $sampleArray = array(
       'firstKey'  => 'firstValue',
       'secondKey' => 'secondValue',
   );

When using this latter declaration, we encourage using a trailing comma for the last item in the array; this
minimizes the impact of adding new items on successive lines, and helps to ensure no parse errors occur due to a
missing comma.

.. _coding-standard.coding-style.classes:

Classes
^^^^^^^

.. _coding-standard.coding-style.classes.declaration:

Déclaration de classes
^^^^^^^^^^^^^^^^^^^^^^

Les classes doivent être nommées conformément aux conventions de nommage de Zend Framework.

L'accolade est toujours écrite dans la ligne sous le nom de la classe.

Toutes les classes doivent avoir un bloc de documentation conforme aux standards PHPDocumentor.

Tout code d'une classe doit être indenté avec 4 espaces.

Une seule classe est permise par fichier PHP.

Le placement de code additionnel dans un fichier de classe est permis, mais déconseillé. Dans ces fichiers, deux
lignes vides doivent séparer la classe du code PHP additionnel.

Voici un exemple d'une déclaration de classe autorisée :

   .. code-block:: php
      :linenos:

      /**
       * Bloc de documentation
       */
      class SampleClass
      {
          // contenu de la classe
          // qui doit être indenté avec 4 espaces
      }



Classes that extend other classes or which implement interfaces should declare their dependencies on the same line
when possible.

.. code-block:: php
   :linenos:

   class SampleClass extends FooAbstract implements BarInterface
   {
   }

If as a result of such declarations, the line length exceeds the :ref:`maximum line length
<coding-standard.php-file-formatting.max-line-length>`, break the line before the "extends" and/or "implements"
keywords, and pad those lines by one indentation level.

.. code-block:: php
   :linenos:

   class SampleClass
       extends FooAbstract
       implements BarInterface
   {
   }

If the class implements multiple interfaces and the declaration exceeds the maximum line length, break after each
comma separating the interfaces, and indent the interface names such that they align.

.. code-block:: php
   :linenos:

   class SampleClass
       implements BarInterface,
                  BazInterface
   {
   }

.. _coding-standard.coding-style.classes.member-variables:

Variables membres de la classe
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les variables membres doivent être nommées en respectant les conventions de nommage de Zend Framework.

Toute variable déclarée dans une classe doit être listée en haut de cette classe, avant toute déclaration de
méthode.

La construction *var* n'est pas permise. Les variables membres déclarent toujours leur visibilité en utilisant la
construction *private*, *protected*, ou *public*. L'accès direct à ces variables membres en les rendant publiques
est permis mais déconseillé. Il est préférable d'utiliser des accesseurs (set/get).

.. _coding-standard.coding-style.functions-and-methods:

Fonctions et méthodes
^^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

Déclaration de fonctions et de méthodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les fonctions doivent être nommées en respectant les conventions de nommage de Zend Framework.

Les fonctions internes aux classes doivent toujours déclarer leur visibilité en utilisant la construction
*private*, *protected*, ou *public*.

Tout comme les classes, l'accolade ouvrante est toujours écrite sous le nom de la fonction. Il n'y a pas d'espace
entre le nom de la fonction et les parenthèses des arguments. Il n'y a pas d'espace entre la parenthèse fermante
et l'accolade.

Les fonctions globales sont fortement déconseillées.

Voici un exemple d'une déclaration permise d'une fonction de classe :

   .. code-block:: php
      :linenos:

      /*
       * Bloc de documentation
       */
      class Foo
      {
          /**
           * Bloc de documentation
           */
          public function bar()
          {
              // contenu de la fonction
              // qui doit être indenté avec 4 espaces
          }
      }



In cases where the argument list exceeds the :ref:`maximum line length
<coding-standard.php-file-formatting.max-line-length>`, you may introduce line breaks. Additional arguments to the
function or method must be indented one additional level beyond the function or method declaration. A line break
should then occur before the closing argument paren, which should then be placed on the same line as the opening
brace of the function or method with one space separating the two, and at the same indentation level as the
function or method declaration. The following is an example of one such situation:

   .. code-block:: php
      :linenos:

      /**
       * Documentation Block Here
       */
      class Foo
      {
          /**
           * Documentation Block Here
           */
          public function bar($arg1, $arg2, $arg3,
              $arg4, $arg5, $arg6
          ) {
              // all contents of function
              // must be indented four spaces
          }
      }



**NOTE :** Le passage par référence est permis uniquement dans la déclaration de la fonction :

   .. code-block:: php
      :linenos:

      /**
       * Bloc de documentation
       */
      class Foo
      {
          /**
           * Bloc de documentation
           */
          public function bar(&$baz)
          {}
      }



L'appel par référence est interdit.

La valeur de retour ne doit pas être entourée de parenthèses. Ceci peut gêner à la lecture et peut aussi
casser le code si une méthode est modifiée plus tard pour retourner par référence.

   .. code-block:: php
      :linenos:

      /**
       * Bloc de documentation
       */
      class Foo
      {
          /**
           * INCORRECT
           */
          public function bar()
          {
              return($this->bar);
          }

          /**
           * CORRECT
           */
          public function bar()
          {
              return $this->bar;
          }
      }



.. _coding-standard.coding-style.functions-and-methods.usage:

Usage de fonctions et méthodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les arguments d'une fonction sont séparés par un espace après la virgule de délimitation. Voici un exemple d'un
appel de fonction qui prend trois arguments :

   .. code-block:: php
      :linenos:

      threeArguments(1, 2, 3);



L'appel par référence est interdit. Référez vous à la section sur la déclaration de fonctions pour la
méthode correcte de passage des argument par référence.

Pour les fonctions dont les arguments peuvent être des tableaux, l'appel à la fonction doit inclure la
construction "array" et peut être divisé en plusieurs ligne pour améliorer la lecture. Dans ces cas, les
standards d'écriture de tableaux s'appliquent aussi :

   .. code-block:: php
      :linenos:

      threeArguments(array(1, 2, 3), 2, 3);

      threeArguments(array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500), 2, 3);

      threeArguments(array(
          1, 2, 3, 'Zend', 'Studio',
          $a, $b, $c,
          56.44, $d, 500
      ), 2, 3);



.. _coding-standard.coding-style.control-statements:

Structure de contrôle
^^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

If / Else / Elseif
^^^^^^^^^^^^^^^^^^

Les structure de contrôles basées sur les constructions *if* et *elseif* doivent avoir un seul espace avant la
parenthèse ouvrante de la condition, et un seul espace après la parenthèse fermante.

Pour la condition entre les parenthèses, les opérateurs doivent être séparés par des espaces pour une
meilleure lisibilité. Les parenthèses internes sont conseillées pour améliorer le regroupement logique de
longues conditions.

L'accolade ouvrante est écrite sur la même ligne que la condition. L'accolade fermante est toujours écrite sur
sa propre ligne. Tout contenu présent à l'intérieur des accolades doit être indenté par 4 espaces.

   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      }



If the conditional statement causes the line length to exceed the :ref:`maximum line length
<coding-standard.php-file-formatting.max-line-length>` and has several clauses, you may break the conditional into
multiple lines. In such a case, break the line prior to a logic operator, and pad the line such that it aligns
under the first character of the conditional clause. The closing paren in the conditional will then be placed on a
line with the opening brace, with one space separating the two, at an indentation level equivalent to the opening
control statement.

.. code-block:: php
   :linenos:

   if (($a == $b)
       && ($b == $c)
       || (Foo::CONST == $d)
   ) {
       $a = $d;
   }

The intention of this latter declaration format is to prevent issues when adding or removing clauses from the
conditional during later revisions.

Pour les instruction "if" qui incluent "elseif" ou "else", les conventions de formatage sont similaires à celles
de la construction "if". Les exemples suivants montrent le formatage approprié pour les structures "if" avec
"else" et/ou les constructions "elseif" :

   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      } else {
          $a = 7;
      }

      if ($a != 2) {
          $a = 2;
      } elseif ($a == 3) {
          $a = 4;
      } else {
          $a = 7;
      }

      if (($a == $b)
          && ($b == $c)
          || (Foo::CONST == $d)
      ) {
          $a = $d;
      } elseif (($a != $b)
                || ($b != $c)
      ) {
          $a = $c;
      } else {
          $a = $b;
      }

PHP permet que ces instructions soient écrites sans accolades dans certaines circonstances. La convention de
codage ne fait pas de différentiation et toutes les instructions "if", "elseif" et "else" doivent utiliser des
accolades.

.. _coding-standards.coding-style.control-statements.switch:

Switch
^^^^^^

Les instructions de contrôle avec "switch" ne doivent avoir qu'un seul espace avant la parenthèse ouvrante de
l'instruction conditionnelle, et aussi un seul espace après la parenthèse fermante.

Tout le contenu à l'intérieur de l'instruction "switch" doit être indenté avec 4 espaces. Le contenu sous
chaque "case" doit être indenté avec encore 4 espaces supplémentaires.

.. code-block:: php
   :linenos:

   switch ($numPeople) {
       case 1:
           break;

       case 2:
           break;

       default:
           break;
   }

La construction *default* ne doit jamais être oubliée dans une instruction *switch*.

**NOTE :** Il est parfois pratique d'écrire une clause *case* qui passe à travers le *case* suivant en omettant
l'inclusion de *break* ou *return*. Pour distinguer ce cas d'un bug, toute clause *case* ne contenant pas *break*
ou *return* doit contenir le commentaire "// break intentionally omitted".

.. _coding-standards.inline-documentation:

Documentation intégrée
^^^^^^^^^^^^^^^^^^^^^^

.. _coding-standards.inline-documentation.documentation-format:

Format de la documentation
^^^^^^^^^^^^^^^^^^^^^^^^^^

Tous les blocs de documentation ("docblocks") doivent être compatible avec le format phpDocumentor. La description
du format phpDocumentor n'est pas du ressort de ce document. Pour plus d'information, visitez `http://phpdoc.org/`_

Tous les fichiers de code source écrits pour Zend Framework ou qui opèrent avec ce framework doivent contenir un
docblock du fichier, en haut de chaque fichier, et un docblock de classe immédiatement au dessus de chaque classe.
Ci-dessous vous trouverez des exemples de tels docblocs.

.. _coding-standards.inline-documentation.files:

Fichiers
^^^^^^^^

Chaque fichier qui contient du code PHP doit avoir un bloc d'entête en haut du fichier qui contient au minimum ces
balises phpDocumentor :

   .. code-block:: php
      :linenos:

      /**
       * Description courte du fichier
       *
       * Description longue du fichier s'il y en a une
       *
       * LICENSE: Informations sur la licence
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://framework.zend.com/license   BSD License
       * @link       http://framework.zend.com/package/PackageName
       * @since      File available since Release 1.5.0
      */



.. _coding-standards.inline-documentation.classes:

Classes
^^^^^^^

Chaque classe doit avoir un docblock qui contient au minimum ces balises phpDocumentor :

   .. code-block:: php
      :linenos:

      /**
       * Description courte de la classe
       *
       * Description longue de la classe, s'il y en a une
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://framework.zend.com/license   BSD License
       * @version    Release: @package_version@
       * @link       http://framework.zend.com/package/PackageName
       * @since      Class available since Release 1.5.0
       * @deprecated Class deprecated in Release 2.0.0
       */



.. _coding-standards.inline-documentation.functions:

Fonctions
^^^^^^^^^

Chaque fonction, méthode, doit avoir un docblock contenant au minimum :

   - Une description de la fonction

   - Tous les arguments

   - Toutes les valeurs de retour possibles



Il n'est pas nécessaire d'utiliser la balise "@access" parce que le niveau d'accès est déjà connu avec les
constructions "public", "private", "protected" utilisée pour déclarer la fonction.

Si une fonction/méthode peut lancer une exception, utilisez "@throws" :

   .. code-block:: php
      :linenos:

      @throws exceptionclass [description]





.. _`licence.`: http://framework.zend.com/license
.. _`http://phpdoc.org/`: http://phpdoc.org/
