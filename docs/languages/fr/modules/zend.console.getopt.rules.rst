.. EN-Revision: none
.. _zend.console.getopt.rules:

Déclarer les règles Getopt
==========================

Le constructeur de la classe ``Zend\Console\Getopt`` prend un à trois arguments. Le premier argument déclare
quelles options sont supportées par votre application. Cette classe supporte des formes de syntaxe alternatives
pour déclarer les options. Voir les sections ci-dessous pour le format et l'utilisation de ces formes de syntaxe.

Le constructeur prend deux arguments supplémentaires, qui sont facultatifs. Le deuxième argument peut contenir
les arguments de la ligne de commande. La valeur par défaut est ``$_SERVER['argv']``.

Le troisième argument du constructeur peut contenir des options de configuration pour adapter le comportement de
``Zend\Console\Getopt``. Voir la section :ref:`Ajouter une configuration
<zend.console.getopt.configuration.config>` pour la référence des options disponibles.

.. _zend.console.getopt.rules.short:

Déclarer des options avec la syntaxe courte
-------------------------------------------

``Zend\Console\Getopt`` supporte une syntaxe compacte semblable à cela employée par *GNU* Getopt (voir
http://www.gnu.org/software/libc/manual/html_node/Getopt.html). Cette syntaxe supporte seulement des drapeaux
courts (1 seul caractère). Dans une chaîne de caractère unique, vous entrez chacune des lettres qui
correspondent aux drapeaux supportés par votre application. Une lettre suivie d'un caractère deux points
("**:**") indique un drapeau qui exige un paramètre.

.. _zend.console.getopt.rules.short.example:

.. rubric:: Utiliser la syntaxe courte

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt('abp:');

L'exemple ci-dessus montre l'utilisation de ``Zend\Console\Getopt`` pour déclarer que des options peuvent être
données en tant que "``-a``", "``-b``" ou "``-p``". Le dernier drapeau exige un paramètre.

La syntaxe courte est limitée aux drapeaux courts (1 seul caractère). Les alias, les types des paramètres, et
les messages d'aide ne sont pas supportés dans la syntaxe courte.

.. _zend.console.getopt.rules.long:

Déclarer des options avec la syntaxe longue
-------------------------------------------

Une syntaxe différente avec plus de possibilités est également disponible. Cette syntaxe permet d'indiquer des
alias pour les drapeaux, les types de paramètres d'option, et aussi des messages d'aide pour décrire
l'utilisation à l'utilisateur. Au lieu d'utiliser une chaîne de caractère unique comme pour la syntaxe courte,
la syntaxe longue emploie un tableau associatif comme premier argument du constructeur pour déclarer les options.

La clé de chaque élément du tableau associatif est une chaîne avec un format qui nomme le drapeau, avec tous
ses alias, séparés par le symbole "**|**". Après la série des alias, si l'option exige un paramètre, il y a un
symbole égal ("**=**") avec une lettre qui représente le **type** du paramètre :

- "**=s**" pour un paramètre de type chaîne de caractère.

- "**=w**" pour un paramètre de type mot (une chaîne de caractère qui ne contient pas d'espace).

- "**=i**" pour un paramètre de type entier (integer).

Si le paramètre est optionnel, on utilise le tiret ("**-**") au lieu du symbole égal.

La valeur de chaque élément dans le tableau associatif est un message d'aide pour décrire à l'utilisateur
comment employer votre programme.

.. _zend.console.getopt.rules.long.example:

.. rubric:: Utiliser la syntaxe longue

.. code-block:: php
   :linenos:

   $opts = new Zend\Console\Getopt(
     array(
       'abricot|a'  => 'option abricot, sans paramètres',
       'banane|b=i' => 'option banane, avec un paramètre entier obligatoire',
       'pear|p-s'   => 'option pear, avec un paramètre chaîne optionel'
     )
   );

Dans l'exemple ci-dessus, il y a trois options. "``--abricot``" et "``-a``" sont des alias l'un pour l'autre et
l'option ne prend pas de paramètres. "``--banane``" et "``-b``" sont des alias l'un pour l'autre et l'option prend
un paramètre obligatoire de type entier. Enfin, "``--pear``" et "``-p``" sont des alias l'un pour l'autre et
l'option prend un paramètre optionnel de type chaîne de caractère.



