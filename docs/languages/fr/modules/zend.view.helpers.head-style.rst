.. EN-Revision: none
.. _zend.view.helpers.initial.headstyle:

L'aide de vue HeadStyle
=======================

L'élément HTML *<style>* est utilisé pour inclure des feuilles de styles *CSS* à l'intérieur de l'élément
HTML *<head>*.

.. note::

   **Utilisez HeadLink pour lier des fichiers CSS externes**

   :ref:`HeadLink <zend.view.helpers.initial.headlink>` devrait être utilisé pour inclure des feuilles de styles
   externes. *HeadStyle* ne devrait être utilisé que si vous souhaitez définir des feuilles de styles internes.

L'aide de vue *HeadStyle* supporte les méthodes suivantes pour l'ajout et le paramétrage des déclarations de
feuilles de styles :

- ``appendStyle($content, $attributes = array())``

- ``offsetSetStyle($index, $content, $attributes = array())``

- ``prependStyle($content, $attributes = array())``

- ``setStyle($content, $attributes = array())``

Dans tous les cas, ``$content`` est le contenu des déclarations *CSS*. ``$attributes`` sont les attributs
additionnels que vous pouvez fournir à la balise *style*: "lang", "title", "media", ou "dir" sont autorisés.

.. note::

   **Paramétrez des commentaires conditionnels**

   *HeadStyle* vous permet d'englober vos balises de style avec des commentaires conditionnels, ce qui permet de
   les masquer pour des navigateurs spécifiques. Pour ajouter les balises conditionnelles, fournissez le
   paramètre *conditional* en tant que partie du paramètre ``$attrs`` lors de l'appel de la méthode.

   .. _zend.view.helpers.initial.headstyle.conditional:

   .. rubric:: HeadStyle avec des commentaires conditionnels

   .. code-block:: php
      :linenos:

      // adding scripts
      $this->headStyle()->appendStyle($styles, array('conditional' => 'lt IE 7'));

*HeadStyle* permet aussi la capture des déclarations de style ; ceci peut être utile si vous voulez créer des
déclarations par programme, et ensuite les placer à un autre endroit. L'utilisation de cette fonctionnalité est
montrée dans un exemple ci-dessous.

Enfin, vous pouvez utiliser la méthode ``headStyle()`` pour ajouter rapidement des éléments de déclarations ;
la signature de la méthode est ``headStyle($content$placement = 'APPEND', $attributes = array())``. ``$placement``
peut être "APPEND", "PREPEND", ou "SET".

*HeadStyle* surcharge chacune des méthodes ``append()``, ``offsetSet()``, ``prepend()``, et ``set()`` pour imposer
l'utilisation des méthodes spéciales listées ci-dessus. En interne, il stocke chaque élément sous la forme
d'un *stdClass*, qui est ensuite sérialisé en utilisant la méthode ``itemToString()``. Ceci vous permet de
réaliser des vérifications sur les éléments de la pile, et optionnellement modifier ces éléments en modifiant
simplement l'objet retourné.

L'aide *HeadStyle* est une implémentation concrète de l'aide :ref:`Placeholder
<zend.view.helpers.initial.placeholder>`.

.. note::

   **UTF-8 encoding used by default**

   By default, Zend Framework uses *UTF-8* as its default encoding, and, specific to this case, ``Zend_View`` does
   as well. Character encoding can be set differently on the view object itself using the ``setEncoding()`` method
   (or the the ``encoding`` instantiation parameter). However, since ``Zend\View\Interface`` does not define
   accessors for encoding, it's possible that if you are using a custom view implementation with this view helper,
   you will not have a ``getEncoding()`` method, which is what the view helper uses internally for determining the
   character set in which to encode.

   If you do not want to utilize *UTF-8* in such a situation, you will need to implement a ``getEncoding()`` method
   in your custom view implementation.

.. _zend.view.helpers.initial.headstyle.basicusage:

.. rubric:: Utilisation basique de l'aide HeadStyle

Vous pouvez spécifier une nouvelle balise de style à n'importe quel moment :

.. code-block:: php
   :linenos:

   // ajout de styles
   $this->headStyle()->appendStyle($styles);

L'ordre est très important avec les *CSS*; vous pouvez devoir assurer que les déclarations soient chargées dans
un ordre spécifique dû à l'ordre de la cascade ; employez les diverses directives "append", "prepend", et
"offsetSet" pour faciliter cette tâche :

.. code-block:: php
   :linenos:

   // Mettre les styles dans le bon ordre

   // - placer à un offset particulier
   $this->headStyle()->offsetSetStyle(100, $stylesPerso);

   // - placer à la fin
   $this->headStyle()->appendStyle($stylesFinaux);

   // - placer au début
   $this->headStyle()->prependStyle($stylesInitiaux);

Quand vous êtes finalement prêt à afficher toutes les déclarations de styles dans votre script de layout,
faîtes un simple *echo* de l'aide :

.. code-block:: php
   :linenos:

   <?php echo $this->headStyle() ?>

.. _zend.view.helpers.initial.headstyle.capture:

.. rubric:: Capturer les déclarations de style en utilisant l'aide HeadStyle

Parfois vous devez produire des déclarations de styles *CSS* par programme. Même si vous pouvez employer la
concaténation de chaînes, les "heredocs", ou tout autre équivalent, il est souvent plus facile de faire juste la
création des styles et de les entourer par des balises *PHP*. *HeadStyle* vous permet de le faire, et capture
ainsi l'élément dans la pile :

.. code-block:: php
   :linenos:

   <?php $this->headStyle()->captureStart() ?>
   body {
       background-color: <?php echo $this->bgColor ?>;
   }
   <?php $this->headStyle()->captureEnd() ?>

Les suppositions suivantes sont considérées :

- Les déclarations de styles sont ajoutées à la pile. Si vous souhaitez qu'elles remplacent la pile ou qu'elles
  soient ajoutées en début de pile, vous devez fournir "SET" ou "PREPEND", en tant que premier argument de
  ``captureStart()``.

- Si vous souhaitez spécifier un quelconque attribut additionnel pour la balise *<style>*, fournissez-le sous la
  forme d'un tableau en deuxième argument de ``captureStart()``.


