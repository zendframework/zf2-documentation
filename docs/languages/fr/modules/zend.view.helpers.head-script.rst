.. _zend.view.helpers.initial.headscript:

L'aide de vue HeadScript
========================

L'élément HTML *<script>* est utilisé pour à la fois pour fournir des éléments de scripts côté-client dans
le code HTML et aussi pour lier une ressource distante contenant du script côté-client. L'aide de vue
*HeadScript* vous permet de gérer ces deux cas.

L'aide de vue *HeadScript* supportent les méthodes suivantes pour paramétrer ou ajouter des scripts :

- *appendFile($src, $type = 'text/javascript', $attrs = array())*

- *offsetSetFile($index, $src, $type = 'text/javascript', $attrs = array())*

- *prependFile($src, $type = 'text/javascript', $attrs = array())*

- ``setFile($src, $type = 'text/javascript', $attrs = array())``

- *appendScript($script, $type = 'text/javascript', $attrs = array())*

- *offsetSetScript($index, $script, $type = 'text/javascript', $attrs = array())*

- *prependScript($script, $type = 'text/javascript', $attrs = array())*

- *setScript($script, $type = 'text/javascript', $attrs = array())*

Dans le cas des méthodes de type **File()*, ``$src`` est l'emplacement distant du script à charger ; c'est
généralement sous la forme d'une *URL* ou d'un chemin de fichier. Pour les méthode de type **Script()*,
``$script`` sont les directives de script côté-client que vous souhaitez utiliser dans l'élément.

.. note::

   **Paramétrez des commentaires conditionnels**

   *HeadScript* vous permet d'englober vos balises de script avec des commentaires conditionnels, ce qui permet de
   les masquer pour des navigateurs spécifiques. Pour ajouter les balises conditionnelles, fournissez le
   paramètre *conditional* en tant que partie du paramètre ``$attrs`` lors de l'appel de la méthode.

   .. _zend.view.helpers.initial.headscript.conditional:

   .. rubric:: Headscript avec des commentaires conditionnels

   .. code-block:: php
      :linenos:

      // adding scripts
      $this->headScript()->appendFile('/js/prototype.js',
                                      'text/javascript',
                                      array('conditional' => 'lt IE 7');

*HeadScript* vous permet aussi de capturer des scripts ; ceci peut être utile si vous voulez créer du script
côté-client par programmation, et ensuite le placer n'importe où. Une utilisation de ceci est montré dans un
exemple ci-dessous.

Enfin, vous pouvez aussi utiliser la méthode ``headScript()`` pour rapidement ajouter des éléments de script ;
le prototype dans ce cas est *headScript($mode = 'FILE', $spec, $placement = 'APPEND')*. Le ``$mode`` est soit
"FILE", soit "SCRIPT", suivant si vous liez un script ou que vous en définissiez un. ``$spec`` est soit le script
à lier ou la source du script elle-même. ``$placement`` est "APPEND", "PREPEND", ou "SET".

*HeadScript* surcharge chacun des ``append()``, ``offsetSet()``, ``prepend()``, et ``set()`` pour imposer
l'utilisation des méthodes spéciales énumérées ci-dessus. En interne, il stocke chaque élément sous la forme
d'un *stdClass*, qui peut être ensuite sérialisé grâce à la méthode ``itemToString()``. Ceci vous permet de
réaliser des vérifications sur les éléments dans la pile, et optionnellement de les modifier en modifiant
simplement l'objet retourné.

L'aide *HeadScript* est une implémentation concrète de l':ref:`aide Conteneur
<zend.view.helpers.initial.placeholder>`.

.. note::

   **Utilisez InlineScript pour les scripts dans le corps ("body") du HTML**

   L'aide de vue, :ref:`InlineScript <zend.view.helpers.initial.inlinescript>`, similaire à *HeadScript* devrait
   être utilisée quand vous souhaitez inclure des scripts dans le corps ("``body``") du HTML. Placer ces scripts
   en fin du document est une bonne pratique pour accélérer l'envoi de votre page, particulièrement pour les
   scripts tiers d'analyse.

.. note::

   **Les attributs arbitraires sont désactivées par défaut**

   Par défaut, *HeadScript* affichera seulement les attributs de *<script>* approuvés par le W3C. Ceux-ci inclus
   "*type*", "*charset*", "*defer*", "*language*", et "*src*". Cependant, certaines bibliothèques javascript,
   notamment `Dojo`_, utilise des attributs personnalisés dans le but de modifier le comportement. Pour autoriser
   ce type d'attribut, vous pouvez les activer grâce à la méthode ``setAllowArbitraryAttributes()``:

   .. code-block:: php
      :linenos:

      $this->headScript()->setAllowArbitraryAttributes(true);

.. _zend.view.helpers.initial.headscript.basicusage:

.. rubric:: Utilisation basique de l'aide HeadScript

Vous devriez ajouter une nouvelle balise de script à chaque fois. Comme noté ci-dessus, ceux-ci peuvent être des
liens vers des ressources externes ou vers les scripts eux-mêmes.

.. code-block:: php
   :linenos:

   // ajout de scripts
   $this->headScript()->appendFile('/js/prototype.js')
                      ->appendScript($onloadScript);

L'ordre est souvent important avec les scripts côté-client ; vous devez vous assurer de charger les librairies
dans un ordre spécifique en fonction de leurs dépendances ; utilisez à la fois les directives *append*,
*prepend*, et *offsetSet* pour vous aider dans cette tâche :

.. code-block:: php
   :linenos:

   // mettre les scripts dans l'ordre

   // placer celui-ci à un offset particulier pour s'assurer
   // de le charger en dernier
   $this->headScript()->offsetSetFile(100, '/js/myfuncs.js');

   // utiliser les effets de scriptaculous (append utilise
   // l'index suivant, c-à-d. 101)
   $this->headScript()->appendFile('/js/scriptaculous.js');

   // mais dans tous les cas, le script de base prototype
   // doit être chargé en premier :
   $this->headScript()->prependFile('/js/prototype.js');

Quand vous êtes finalement prêt à afficher tous les scripts dans votre layout, faîtes simplement un *echo* de
l'aide :

.. code-block:: php
   :linenos:

   <?php echo $this->headScript() ?>

.. _zend.view.helpers.initial.headscript.capture:

.. rubric:: Capturer les scripts en utilisant l'aide HeadScript

Parfois vous devez générer des scripts côté-client par programme. Même si vous pouvez employer la
concaténation de chaînes, les "heredocs", ou tout autre équivalent, il est souvent plus facile de faire juste la
création des scripts et de les entourer par des balises *PHP*. *HeadScript* vous permet de le faire, et capture
ainsi l'élément dans la pile :

.. code-block:: php
   :linenos:

   <?php $this->headScript()->captureStart() ?>
   var action = '<?php echo $this->baseUrl ?>';
   $('foo_form').action = action;
   <?php $this->headScript()->captureEnd() ?>

Les suppositions suivantes sont considérées :

- Les déclarations de scripts sont ajoutées à la pile. Si vous souhaitez qu'elles remplacent la pile ou qu'elles
  soient ajoutées en début de pile, vous devez fournir "SET" ou "PREPEND", en tant que premier argument de
  ``captureStart()``.

- Le type *MIME* est considéré comme étant "text/javascript" ; si vous souhaitez spécifier un type différent,
  vous devez le fournir en tant que deuxième argument de ``captureStart()``.

- Si vous souhaitez spécifier un quelconque attribut additionnel pour la balise *<script>*, fournissez-le sous la
  forme d'un tableau en troisième argument de ``captureStart()``.



.. _`Dojo`: http://www.dojotoolkit.org/
