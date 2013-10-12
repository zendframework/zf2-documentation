.. EN-Revision: none
.. _learning.lucene.indexing:

Indexation
==========

L'indexation s'effectue en ajoutant un nouveau document à un index existant ou à un nouvel index :

.. code-block:: php
   :linenos:

   $index->addDocument($doc);

Il y a deux manières de créer un objet document. La première est de le faire manuellement.

.. _learning.lucene.indexing.doc-creation:

.. rubric:: Construction manuel de document

.. code-block:: php
   :linenos:

   $doc = new Zend\Search\Lucene\Document();
   $doc->addField(Zend\Search\Lucene\Field::Text('url', $docUrl));
   $doc->addField(Zend\Search\Lucene\Field::Text('title', $docTitle));
   $doc->addField(Zend\Search\Lucene\Field::unStored('contents', $docBody));
   $doc->addField(Zend\Search\Lucene\Field::binary('avatar', $avatarData));

La seconde méthode est de le charger depuis un fichier *HTML* ou Microsoft Office 2007 :

.. _learning.lucene.indexing.doc-loading:

.. rubric:: Chargement de document

.. code-block:: php
   :linenos:

   $doc = Zend\Search\Lucene\Document\Html::loadHTML($htmlString);
   $doc = Zend\Search\Lucene\Document\Docx::loadDocxFile($path);
   $doc = Zend\Search\Lucene\Document\Pptx::loadPptFile($path);
   $doc = Zend\Search\Lucene\Document\Xlsx::loadXlsxFile($path);

Si un document est chargé depuis l'un des formats supportés, il peut quand même être étendu manuellement avec
des champs définis par l'utilisateur.

.. _learning.lucene.indexing.policy:

Politique d'indexation
----------------------

Vous devrez définir votre politique d'indexation au sein de la conception de l'architecture de votre application.

Vous pourriez avoir besoin d'une configuration d'indexation à la demande (quelque chose comme le système *OLTP*).
Sur de test systèmes, vous ajoutez généralement un document par requête utilisateur. De cette manière,
l'option **MaxBufferedDocs** n'affectera pas le système. D'un autre coté, **MaxMergeDocs** est vraiment utile,
car il vous permet de limiter le temps d'exécution maximum du script. **MergeFactor** doit être définis par une
valeur qui conserve un équilibre entre le temps moyen d'indexation (il est aussi affecté par temps d'optimisation
moyen) et les performance de recherche (le niveau d'optimisation dépend du nombre de segments).

Si vous allez surtout effectuer des mises à jour d'index par lot, votre configuration devrait utiliser une option
**MaxBufferedDocs** définis à la valeur maximum supporté par la quantité de mémoire disponible.
**MaxMergeDocs** et **MergeFactor** doivent être définis à des valeurs réduisant au maximum le recours à
l'auto-optimisation [#]_. Les optimisations complètes d'index doivent être appliquées après l'indexation.

.. _learning.lucene.indexing.optimization:

.. rubric:: Optimisation d'index

.. code-block:: php
   :linenos:

   $index->optimize();

Dans certaines configuration, il est plus efficace d'effectuer une série de mise à jour de l'index en organisant
une file de requête de mise à jour et de traiter plusieurs requête de mise à jour dans une seule exécution de
script. Ceci réduit la charge d'ouverture de l'index et permet d'utiliser le tampon de document de l'index.



.. [#] Une limite additionnelle est le nombre maximum de gestionnaire de fichiers supporter par le système
       d'exploitation pour les opérations concurrente d'ouverture