.. _zend.view.helpers.initial.object:

L'aide de vue HTML Object
=========================

L'élément HTML *<object>* est utilisé pour inclure un média comme Flash ou QuickTime dans les pages Web. L'aide
de vue *Object* vous aide à réaliser ceci avec un minimum d'effort.

Il existe quatre aides de vue *Object* initiaux :

- *htmlFlash*: génère le balisage pour l'inclusion de fichiers Flash.

- *htmlObject*: génère le balisage pour l'inclusion d'objets personnalisés.

- *htmlPage*: génère le balisage pour l'inclusion d'autres pages (X)HTML.

- *htmlQuicktime*: génère le balisage pour l'inclusion de fichiers QuickTime.

Toutes ces aides partagent une interface similaire. Pour cette raison, cette documentation ne présentera des
exemples que pour deux de ces aides.

.. _zend.view.helpers.initial.object.flash:

.. rubric:: Aide de vue Flash

Inclure du Flash dans votre page est assez simple. Le seul argument requis est l'URI de la ressource.

.. code-block:: php
   :linenos:

   <?php echo $this->htmlFlash('/path/to/flash.swf'); ?>

Ceci affichera le code HTML suivant :

.. code-block:: html
   :linenos:

   <object data="/path/to/flash.swf" type="application/x-shockwave-flash"
       classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
       codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
   </object>

Cependant vous pouvez aussi spécifier des attributs, des paramètres et du contenu qui peuvent être affichés
avec la balise *<object>*. Ceci peut être montré avec l'aide de vue *htmlObject*.

.. _zend.view.helpers.initial.object.object:

.. rubric:: Personnalisation d'un objet en fournissant des arguments additionnels

Le premier argument de l'aide *Object* est toujours requis. Il s'agit de l'URI de la ressource à inclure. Le
second argument est seulement requis par l'aide *htmlObject*. Les autres aides contiennent déjà la bonne valeur
pour cet argument. Le troisième argument est utilisé pour fournir des attributs à l'élément *object*. Seul un
tableau de paires clé/valeur est accepté. *classid* ou *codebase* sont des exemples de tels attributs. Le
quatrième paramètre ne prend aussi qu'un tableau de paires clé/valeur est les utilise pour créer des éléments
*<param>*. Enfin, vous avez la possibilité de fournir un contenu additionnel à l'objet en cinquième paramètre.
Voici donc un exemple qui utilise tous le paramètres :

.. code-block:: php
   :linenos:

   <?php echo $this->htmlObject(
       '/path/to/file.ext',
       'mime/type',
       array(
           'attr1' => 'aval1',
           'attr2' => 'aval2'
       ),
       array(
           'param1' => 'pval1',
           'param2' => 'pval2'
       ),
       'some content'
   ); ?>

Ceci affichera le code HTML suivant :



   .. code-block:: php
      :linenos:

      <object data="/path/to/file.ext" type="mime/type"
              attr1="aval1" attr2="aval2">
          <param name="param1" value="pval1" />
          <param name="param2" value="pval2" />
          some content
      </object>




