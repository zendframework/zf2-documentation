.. _zend.view.introduction:

Introduction
============

``Zend_View`` est une classe qui permet de travailler avec la partie "Vue" du motif de conception
Modèle-Vue-Contrôleur. Elle existe pour aider à garder la vue séparée du modèle et des scripts du
contrôleur. Elle fournie un système d'aide, de filtres d'affichage, et d'échappement de variables.

``Zend_View`` est un système de template agnostique ; vous pouvez utiliser *PHP* comme langage de template, ou
créer des instances d'autres systèmes de templates, et les manipuler à travers les scripts de vue.

L'utilisation de ``Zend_View`` se déroule en deux étapes principales : 1. Votre script de contrôleur crée une
instance de ``Zend_View`` et assigne des variables à cette instance. 2. Le contrôleur dit à ``Zend_View``
d'effectuer le rendu d'une vue particulière, et de ce fait va donner le contrôle au script de vue, qui va
générer l'affichage.

.. _zend.view.introduction.controller:

Script du Contrôleur
--------------------

Comme exemple simple, imaginons que votre contrôleur aie une liste de données sur des livres qu'il veut afficher
en passant par une vue. Le contrôleur pourrait alors ressembler à ceci :

.. code-block:: php
   :linenos:

   // utilise un modèle pour obtenir les données sur les livres :
   // auteurs et titres
   $data = array(
       array(
           'auteur' => 'Hernando de Soto',
           'titre' => 'Le mystère du capitalisme'
       ),
       array(
           'auteur' => 'Henry Hazlitt',
           'titre' => 'Les sciences économique en un cours'
       ),
       array(
           'auteur' => 'Milton Friedman',
           'titre' => 'Libre de choisir'
       )
   );

   // assigniation des données du livre à une instance Zend_View
   Zend_Loader::loadClass('Zend_View');
   $view = new Zend_View();
   $view->books = $data;

   // et appel du script de rendu d'affichage appelé "booklist.php"
   echo $view->render('booklist.php');

.. _zend.view.introduction.view:

Script de vue
-------------

Maintenant, nous avons besoin d'associer le script de vue "``booklist.php``". C'est un script *PHP* comme les
autres, à une exception près : il s'exécute dans la portée de l'instance ``Zend_View``, ce qui veut dire que
les référence à ``$this`` pointent vers les attributs et les méthodes de ``Zend_View``. (Les variables
assignées à l'instance par le contrôleur sont des propriétés publiques de l'instance ``Zend_View``). Ainsi un
script de vue de base pourrait ressembler à ceci :

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>

       <!-- La table des livres -->
       <table>
           <tr>
               <th>Auteur</th>
               <th>Titre</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['auteur']) ?></td>
               <td><?php echo $this->escape($val['titre']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>Aucun livre à afficher</p>

   <?php endif; ?>

Notez l'utilisation de la méthode *escape* pour échapper les variables à afficher.

.. _zend.view.introduction.options:

Options
-------

``Zend_View`` possède plusieurs options qui peuvent être réglées pour changer le comportement de vos scripts de
vues.

- *basePath*: indique le chemin de base où peuvent être trouvés les dossiers de scripts, d'aides et de filtres.
  Il considère une structure de dossiers de ce type :

  .. code-block:: php
     :linenos:

     chemin/vers/
         helpers/
         filters/
         scripts/

  Ceci peut être paramétré via les méthodes ``setBasePath()``, ``addBasePath()``, ou l'option *basePath* du
  constructeur.

- *encoding*: indique l'encodage de caractère à utiliser avec ``htmlentities()``, ``htmlspecialchars()``, et tout
  autre opération. La valeur par défaut est ISO-8859-1 (latin1). Il peut être paramétré avec la méthode
  ``setEncoding()`` ou l'option *encoding* du constructeur.

- *escape*: indique le callback que doit utiliser ``escape()``. Ceci pet être paramétré avec la méthode
  ``setEscape()`` ou l'option *escape* du constructeur.

- *filter*: indique un filtre à utiliser avant d'effectuer le rendu d'un script de vue. Ceci peut être
  paramétré avec les méthodes ``setFilter()``, ``addFilter()``, ou l'option *filter* du constructeur.

- *strictVars*: force ``Zend_View`` à émettre des "notices" et des "warnings" quand des variables non
  initialisées sont lues. Ceci peut être activé en appelant ``strictVars(true)`` ou en passant l'option
  *strictVars* au constructeur.

.. _zend.view.introduction.shortTags:

Balises courtes dans les scripts de vue
---------------------------------------

Dans nos exemples et notre documentation, nous utilisons les balises longues *PHP*: **<?php**. De plus, nous
utilisons parfois `la syntaxe alternative des structures de contrôle`_. Ce sont des éléments pratiques à
utiliser lors de la rédaction de vos scripts de vue, car elles rendent les constructions plus laconiques,
maintiennent les instructions sur des lignes uniques et éliminent la chasse aux accolades à l'intérieur de
l'HTML.

Dans les versions précédentes, nous recommandions souvent l'utilisation des balises courtes (**<?** et **<?=**),
car elles rendent les scripts de vues moins verbeux. Cependant, la valeur par défaut du fichier ``php.ini`` pour
le réglage ``short_open_tag`` est désactivé par défaut en production ou en hébergement mutualisé ; rendant
ainsi vos scripts peu portables. De plus, si vous modélisez du *XML* dans vos scripts, la présence des balises
courtes entrainera l'échec de la validation. Enfin, si vous utilisez les balises courtes et que ``short_open_tag``
est désactivé, le script retournera soit des erreurs, soit votre code PHP à l'utilisateur.

Ceci étant dit, de nombreux développeurs préfère utiliser la forme complète pour des questions de validation
ou de portabilité. Par exemple, *short_open_tag* est désactivé dans le **php.ini.recommended**, et si vous avez
du *XML* dans vos scripts de vue, alors les balises courtes entraîneront un échec de validation du modèle.

De plus, si vous utilisez les balises courtes avec un réglage du paramètre à "off", alors les scripts de vue
vont soit entraîner des erreurs, soit simplement afficher le code à l'utilisateur.

Si malgré ces avertissements, vous souhaitez utiliser les balises courtes mais qu'elles sont désactivées, vous
avez deux options :

- Activer les dans votre fichier *.htaccess*:

  .. code-block:: apache
     :linenos:

     php_value "short_open_tag" "on"

  Ceci est seulement possible si vous êtes autorisé à créer et utiliser les fichiers *.htaccess*. Cette
  directive peut aussi être ajoutée à votre fichier *httpd.conf*.

- Activer une enveloppe de flux ("stream wrapper") optionnelle pour convertir les balises courtes en balises
  longues à la volée :

  .. code-block:: php
     :linenos:

     $view->setUseStreamWrapper(true);

  Ceci enregistre ``Zend_View_Stream`` en tant que enveloppe de flux pour les scripts de vue, et permet de
  s'assurer que votre code continue à fonctionner comme si les balises courtes étaient activées.

.. warning::

   **Les enveloppes de flux de vue dégradent les performances**

   L'utilisation d'enveloppe de flux **dégradera** les performances de votre application, bien que les tests de
   performance réels sont indisponibles pour quantifier le niveau de dégradation. Nous recommandons donc soit
   d'activer les balises courtes, soit de convertir vos scripts pour utiliser la forme longue, ou d'avoir une bonne
   stratégie de mise en cache partielle ou totale du contenu de vos pages.

.. _zend.view.introduction.accessors:

Accesseurs utiles
-----------------

Typiquement, vous ne devriez seulement avoir besoin d'appeler les méthodes ``assign()``, ``render()``, ou une des
méthodes pour le paramétrage/l'ajout de chemins de filtre, d'aide et de script de vues. Cependant, si vous
souhaitez étendre ``Zend_View`` vous-même, ou avez besoin d'accéder à quelques unes de ces méthodes internes,
un certain nombre d'accesseurs existent :

- ``getVars()`` retournera toutes les variables assignées.

- ``clearVars()`` effacera toutes les variables assignées ; utile si vous souhaitez ré-utiliser un objet de vue,
  ou contrôler les variables qui sont disponibles.

- ``getScriptPath($script)`` récupérera le chemin résolu vers un script donné..

- ``getScriptPaths()`` récupérera tous les chemins vers les scripts de vues enregistrés.

- ``getHelperPath($helper)`` récupérera le chemin résolu vers une classe d'aide nommée.

- ``getHelperPaths()`` récupérera tous les chemins vers les aides enregistrés.

- ``getFilterPath($filter)`` récupérera le chemin résolu vers une classe de filtre nommée.

- ``getFilterPaths()`` récupérera tous les chemins vers les filtres enregistrés.



.. _`la syntaxe alternative des structures de contrôle`: http://us.php.net/manual/en/control-structures.alternative-syntax.php
