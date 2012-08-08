.. EN-Revision: none
.. _zend.view.helpers.initial.placeholder:

L'aide de vue Placeholder
=========================

.. note::

   NDT. : Le terme "placeholder est conservé car sa signification varie en fonction du contexte : conteneur
   générique ou emplacement réservé.

L'aide de vue *Placeholder* est utilisé pour faire persister le contenu entre les scripts de vues et les instances
de vues. Il offre aussi des fonctionnalités utiles comme l'agrégation de contenu, la capture de contenu de
scripts de vues pour une utilisation ultérieure, et l'ajout de texte pré ou post contenu (et la personnalisation
des séparateurs de contenu).

.. _zend.view.helpers.initial.placeholder.usage:

.. rubric:: Utilisation basique des Placeholders

L'utilisation basique des placeholders est la persistance des données de vue. Chaque appel de l'aide *Placeholder*
attend un nom de placeholder ; l'aide retourne un objet conteneur que vous pouvez soit manipuler ou simplement
envoyé à l'affichage.

.. code-block:: php
   :linenos:

   <?php $this->placeholder('foo')->set("Du texte pour plus tard") ?>

   <?php
       echo $this->placeholder('foo');
       // outputs "Du texte pour plus tard"
   ?>

.. _zend.view.helpers.initial.placeholder.aggregation:

.. rubric:: Utilisation des Placeholders pour agréger du contenu

L'agrégation du contenu via les placeholders peut être aussi utile parfois. Par exemple, votre script de vue peut
avoir une variable sous forme de tableau à partir de laquelle vous souhaitez récupérer des messages à afficher
plus tard ; un autre script de vue peut ensuite déterminer de la manière suivant laquelle ils seront affichés.

L'aide de vue *Placeholder* utilise des conteneurs qui étendent *ArrayObject*, fournissant de riches
fonctionnalités de manipulations des tableaux. De plus, il offre une variété de méthodes pour le formatage du
contenu stockée dans le conteneur :

- ``setPrefix($prefix)`` paramètre le texte qui sera placé préalablement à tout le contenu. Utilisez
  ``getPrefix()`` à tout moment pour déterminer le réglage courant.

- ``setPostfix($prefix)`` paramètre le texte qui sera placé après tout le contenu. Utilisez ``getPostfix()`` à
  tout moment pour déterminer le réglage courant.

- ``setSeparator($prefix)`` paramètre le texte qui sera placé entre chaque élément de contenu. Utilisez
  ``getSeparator()`` à tout moment pour déterminer le réglage courant.

- ``setIndent($prefix)`` peut être utilisé pour paramétrer une indentation pour chaque élément du contenu. Si
  un entier est fourni, il s'agira du nombre d'espaces à utiliser ; si une chaîne est fournie, elle sera
  utilisée. Utilisez ``getIndent()`` à tout moment pour déterminer le réglage courant.

.. code-block:: php
   :linenos:

   <!-- premier script de vue -->
   <?php $this->placeholder('foo')->exchangeArray($this->data) ?>

.. code-block:: php
   :linenos:

   <!-- autre script (plus tard) -->
   <?php
   $this->placeholder('foo')->setPrefix("<ul>\n    <li>")
                            ->setSeparator("</li><li>\n")
                            ->setIndent(4)
                            ->setPostfix("</li></ul>\n");
   ?>

   <?php
       echo $this->placeholder('foo');
       // affiche une liste non-ordonnée avec une belle indentation
   ?>

Puisque l'objet conteneur *Placeholder* étend *ArrayObject*, vous pouvez ainsi facilement assigner du contenu à
une clé du conteneur en particulier, plutôt que de simplement de les envoyer les unes après les autres ("push").
Les clés peuvent être accédées soit en utilisant les propriétés d'objet ou comme les clés d'un tableau.

.. code-block:: php
   :linenos:

   <?php $this->placeholder('foo')->bar = $this->data ?>
   <?php echo $this->placeholder('foo')->bar ?>

   <?php
   $foo = $this->placeholder('foo');
   echo $foo['bar'];
   ?>

.. _zend.view.helpers.initial.placeholder.capture:

.. rubric:: Utilisation des Placeholders pour capturer le contenu

Occasionnellement vous pouvez avoir du contenu pour un placeholder dans un script de vue qui est simple à mettre
sous forme de modèle ("template") ; l'aide de vue *Placeholder* vous permet de capturer tout contenu arbitraire
pour un rendu ultérieur en utilisant l'API suivante.

- ``captureStart($type, $key)`` commence la capture de contenu.

  ``$type`` doit être une des constantes de *Placeholder*: ``APPEND`` ou ``SET``. Si c'est ``APPEND``, le contenu
  capturé est ajouté à la liste de contenu courant dans le placeholder ; si c'est ``SET``, le contenu capturé
  remplace toute valeur existante dans le placeholder (potentiellement permet de remplacer tout contenu
  préalable). Par défaut, ``$type`` vaut ``APPEND``.

  ``$key`` peut être utilisé pour spécifier une clé en particulier dans le conteneur placeholder dans laquelle
  vous souhaitez capturer le contenu.

  ``captureStart()`` verrouille la capture jusqu'à l'appel de ``captureEnd()``; vous ne pouvez pas imbriquer des
  captures avec le même conteneur placeholder. Le faire entraînera la levée d'une exception.

- ``captureEnd()`` stoppe la capture de contenu, et le place dans l'objet conteneur suivant la manière utilisée
  pour appeler ``captureStart()``.

.. code-block:: php
   :linenos:

   <!-- Default capture: append -->
   <?php $this->placeholder('foo')->captureStart();
   foreach ($this->data as $datum): ?>
   <div class="foo">
       <h2><?php echo $datum->title ?></h2>
       <p><?php echo $datum->content ?></p>
   </div>
   <?php endforeach; ?>
   <?php $this->placeholder('foo')->captureEnd() ?>

   <?php echo $this->placeholder('foo') ?>

.. code-block:: php
   :linenos:

   <!-- Capture to key -->
   <?php $this->placeholder('foo')->captureStart('SET', 'data');
   foreach ($this->data as $datum): ?>
   <div class="foo">
       <h2><?php echo $datum->title ?></h2>
       <p><?php echo $datum->content ?></p>
   </div>
    <?php endforeach; ?>
   <?php $this->placeholder('foo')->captureEnd() ?>

   <?php echo $this->placeholder('foo')->data ?>

.. _zend.view.helpers.initial.placeholder.implementations:

Implémentation concrète des Placeholder
---------------------------------------

Zend Framework embarque certaines implémentations concrètes de placeholders. Celles-ci sont destinées à des
placeholders communément utilisés : doctype, titre de page, et les différents éléments <head>. Dans tous les
cas, appeler le placeholder sans arguments retournera l'élément lui-même.

La documentation pour chacun des éléments existe séparément, suivez les liens ci-dessous :

- :ref:`Doctype <zend.view.helpers.initial.doctype>`

- :ref:`HeadLink <zend.view.helpers.initial.headlink>`

- :ref:`HeadMeta <zend.view.helpers.initial.headmeta>`

- :ref:`HeadScript <zend.view.helpers.initial.headscript>`

- :ref:`HeadStyle <zend.view.helpers.initial.headstyle>`

- :ref:`HeadTitle <zend.view.helpers.initial.headtitle>`

- :ref:`InlineScript <zend.view.helpers.initial.inlinescript>`


