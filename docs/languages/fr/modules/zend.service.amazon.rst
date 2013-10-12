.. EN-Revision: none
.. _zend.service.amazon:

Zend\Service\Amazon
===================

.. _zend.service.amazon.introduction:

Introduction
------------

``Zend\Service\Amazon`` est une *API* simple pour utiliser les Web services d'Amazon. ``Zend\Service\Amazon`` a
deux *API*\ s : une plutôt traditionnelle qui suit la propre *API* d'Amazon, et un "Query *API*" simplifiée pour
construire facilement des requêtes de recherche, même compliquées.

``Zend\Service\Amazon`` permet aux développeurs de récupérer des informations disponible sur le site Amazon.com
directement à travers l'API Amazon Web Services. Les exemples incluent :

   - Le stockage de données informatives, comme des images, des descriptions, le prix et plus

   - Revues éditoriales et commerciales

   - Des produits et accessoires similaires

   - Les offres Amazon.com

   - Les listes ListMania



Pour pouvoir utiliser ``Zend\Service\Amazon``, vous devez avant tout avoir une clé "developer *API*" Amazon ainsi
que votre clé secrète. Pour obtenir une telle clé et pour plus d'informations, vous pouvez visitez le site Web
`Amazon Web Services`_. A partir du 15 août 2009, vous ne pourrez utiliser l'API Amazon à travers
``Zend\Service\Amazon``, quand spécifiant la clé secrète.

.. note::

   **Attention**

   Votre clé "developer *API*" et votre clé secret sont liées à votre identité Amazon, donc faites en sorte de
   les conserver privées.

.. _zend.service.amazon.introduction.example.itemsearch:

.. rubric:: Recherche sur Amazon en utilisant l'API traditionnelle

Dans cet exemple, nous recherchons les livres sur *PHP* disponibles chez Amazon et boucler sur les résultats pour
les afficher.

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $response = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                         'Keywords' => 'php'));
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zend.service.amazon.introduction.example.query_api:

.. rubric:: Recherche sur Amazon en utilisant l'API de requête

Ici nous cherchons aussi les livres sur *PHP* disponibles chez Amazon, mais en utilisant l'API de requête, qui
ressemble au modèle de conception Interface Fluide.

.. code-block:: php
   :linenos:

   $query = new Zend\Service\Amazon\Query('AMAZON_API_KEY',
                                          'US',
                                          'AMAZON_SECRET_KEY');
   $query->category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zend.service.amazon.countrycodes:

Codes de pays
-------------

Par défaut, ``Zend\Service\Amazon`` se connecte au Web service Amazon américain ("*US*"). Pour se connecter
depuis un pays différent, il vous suffit simplement de définir, comme second paramètre du constructeur, la
chaîne de caractère correspondant au code du pays :

.. _zend.service.amazon.countrycodes.example.country_code:

.. rubric:: Choisir un service Web Amazon d'un pays

.. code-block:: php
   :linenos:

   // Connexion à Amazon France
   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'FR', 'AMAZON_SECRET_KEY');

.. note::

   **Codes de pays**

   Les codes de pays valides sont *CA*, *DE*, *FR*, *JP*, *UK*, et *US*.

.. _zend.service.amazon.itemlookup:

Rechercher un produit Amazon spécifique avec son ASIN
-----------------------------------------------------

La méthode ``itemLookup()`` fournit la possibilité de rechercher un produit Amazon particulier lorsque son *ASIN*
est connu.

.. rubric:: Rechercher une produit Amazon spécifique avec son ASIN

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $item = $amazon->itemLookup('B0000A432X');

La méthode ``itemLookup()`` accepte aussi un second paramètre optionnel pour gérer les options de recherche.
Pour les détails complets et une liste des options disponibles, visitez `la documentation Amazon
correspondante.`_.

.. note::

   **Information sur les images**

   Pour récupérer les informations d'images pour vos résultats de recherche, vous devez définir l'option
   *ResponseGroup* à *Medium* ou *Large*.

.. _zend.service.amazon.itemsearch:

Lancer des recherches de produits sur Amazon
--------------------------------------------

Rechercher des produits basés sur tous les divers critères disponibles sont rendus simples grâce à la méthode
``itemSearch()``, comme le montre l'exemple suivant :

.. _zend.service.amazon.itemsearch.example.basic:

.. rubric:: Lancer des recherches de produits sur Amazon

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zend.service.amazon.itemsearch.example.responsegroup:

.. rubric:: Utilisation de l'option *ResponseGroup*

L'option *ResponseGroup* est utilisée pour contrôler les informations spécifiques qui sont retournées dans la
réponse.

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array(
       'SearchIndex'   => 'Books',
       'Keywords'      => 'php',
       'ResponseGroup' => 'Small,ItemAttributes,Images,'
                        . 'SalesRank,Reviews,EditorialReview,'
                        . 'Similarities,ListmaniaLists'
       ));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

La méthode ``itemSearch()`` accepte un seul tableau en paramètre pour gérer les options de recherche. Pour plus
de détails et une liste des options disponibles, visitez `la documentation Amazon correspondante`_

.. tip::

   La classe :ref:`Zend\Service\Amazon\Query <zend.service.amazon.query>` est une enveloppe simple d'utilisation de
   cette méthode.

.. _zend.service.amazon.query:

Utiliser l'API alternative de requêtes
--------------------------------------

.. _zend.service.amazon.query.introduction:

Introduction
^^^^^^^^^^^^

``Zend\Service\Amazon\Query`` fournit une *API* alternative pour utiliser le service Web Amazon. L'API alternative
utilise le modèle de conception 'Interface Fluide'. C'est à dire que les appels peuvent-être fait en utilisant
une chaîne d'appels de méthodes (ie *$obj->method()->method2($arg)*)

L'API ``Zend\Service\Amazon\Query`` utilise la surcharge pour mettre en place facilement une recherche d'article,
et ainsi vous permettre de chercher en se basant sur les critères spécifiés. Chacune de ces options est fournie
en tant qu'appel de méthode, et chaque paramètre de méthode correspond à la valeur des options nommées.

.. _zend.service.amazon.query.introduction.example.basic:

.. rubric:: Rechercher sur Amazon en utilisant l'API alternative de requêtes

Dans cet exemple, l'API de requêtes alternative est utilisée comme une interface fluide pour spécifier les
options et leurs valeurs respectives :

.. code-block:: php
   :linenos:

   $query = new Zend\Service\Amazon\Query('MY_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $query->Category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

Cela définit l'option *Category* à "Livres" et *Keywords* à "PHP".

Pour plus d'information sur les options disponibles, vous pouvez vous référer à la `documentation spécifique`_.

.. _zend.service.amazon.classes:

Classes Zend\Service\Amazon
---------------------------

Les classes suivantes sont toutes retournées par :ref:`Zend\Service\Amazon::itemLookup()
<zend.service.amazon.itemlookup>` et :ref:`Zend\Service\Amazon::itemSearch() <zend.service.amazon.itemsearch>`:

   - :ref:`Zend\Service\Amazon\Item <zend.service.amazon.classes.item>`

   - :ref:`Zend\Service\Amazon\Image <zend.service.amazon.classes.image>`

   - :ref:`Zend\Service\Amazon\ResultSet <zend.service.amazon.classes.resultset>`

   - :ref:`Zend\Service\Amazon\OfferSet <zend.service.amazon.classes.offerset>`

   - :ref:`Zend\Service\Amazon\Offer <zend.service.amazon.classes.offer>`

   - :ref:`Zend\Service\Amazon\SimilarProduct <zend.service.amazon.classes.similarproduct>`

   - :ref:`Zend\Service\Amazon\Accessories <zend.service.amazon.classes.accessories>`

   - :ref:`Zend\Service\Amazon\CustomerReview <zend.service.amazon.classes.customerreview>`

   - :ref:`Zend\Service\Amazon\EditorialReview <zend.service.amazon.classes.editorialreview>`

   - :ref:`Zend\Service\Amazon\ListMania <zend.service.amazon.classes.listmania>`



.. _zend.service.amazon.classes.item:

Zend\Service\Amazon\Item
^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service\Amazon\Item`` est le type de classe utilisé pour représenter un produit Amazon retourné par le
service Web. Elle récupère tous les attributs des articles, incluant le titre, la description, les revues, etc.

.. _zend.service.amazon.classes.item.asxml:

Zend\Service\Amazon\Item::asXML()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

string:``asXML()``


Retourne le *XML* original de l'article

.. _zend.service.amazon.classes.item.properties:

Propriétés
^^^^^^^^^^

``Zend\Service\Amazon\Item`` a un nombre de propriétés directement relié à leur contre-parties de l'API
standard Amazon.

.. _zend.service.amazon.classes.item.properties.table-1:

.. table:: Propriétés de Zend\Service\Amazon\Item

   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Nom             |Type                        |Description                                                                                              |
   +================+============================+=========================================================================================================+
   |ASIN            |string                      |Amazon Item ID                                                                                           |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |DetailPageURL   |string                      |URL pour la page de détail des articles                                                                  |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |SalesRank       |int                         |Niveau de vente pour cet article                                                                         |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |SmallImage      |Zend\Service\Amazon\Image   |Petite image de l'article                                                                                |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |MediumImage     |Zend\Service\Amazon\Image   |Image moyenne de l'article                                                                               |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |LargeImage      |Zend\Service\Amazon\Image   |Grande image de l'article                                                                                |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Subjects        |array                       |Sujets de l'article                                                                                      |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Les offres      |Zend\Service\Amazon\OfferSet|Sommaire des offres, et offres pour l'article                                                            |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |CustomerReviews |array                       |Les revues clients sont représentées comme un tableau d'objets Zend\Service\Amazon\CustomerReview        |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |EditorialReviews|array                       |Les revues éditoriales sont représentées comme un tableau d'objets Zend\Service\Amazon\EditorialReview   |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |SimilarProducts |array                       |Les produits similaires sont représentés comme un tableau d'objets Zend\Service\Amazon\SimilarProduct    |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Accessories     |array                       |Les accessoires pour l'article sont représentés comme un tableau d'objets Zend\Service\Amazon\Accessories|
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Tracks          |array                       |Un tableau contenant le nombre de pistes ainsi que les noms pour les CDs ou DVDs musicaux                |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |ListmaniaLists  |array                       |Les listes Listmania reliées à un article, comme un tableau d'objets Zend\Service\Amazon\ListmaniaList   |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |PromotionalTag  |string                      |Balise promotionnelle de l'article                                                                       |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.image:

Zend\Service\Amazon\Image
^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service\Amazon\Image`` représente une image distante pour un produit.

.. _zend.service.amazon.classes.image.properties:

Propriétés
^^^^^^^^^^

.. _zend.service.amazon.classes.image.properties.table-1:

.. table:: Propriétés de Zend\Service\Amazon\Image

   +------+--------+---------------------------------+
   |Name  |Type    |Description                      |
   +======+========+=================================+
   |Url   |Zend_Uri|Url distante de l'image          |
   +------+--------+---------------------------------+
   |Height|int     |La hauteur (en pixels) de l'image|
   +------+--------+---------------------------------+
   |Width |int     |La largeur (en pixels) de l'image|
   +------+--------+---------------------------------+

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.resultset:

Zend\Service\Amazon\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Des objets ``Zend\Service\Amazon\ResultSet`` sont retournés par :ref:`Zend\Service\Amazon::itemSearch()
<zend.service.amazon.itemsearch>` et vous permettent de gérer facilement les différents résultats retournés.

.. note::

   **SeekableIterator**

   Implémente l'itérateur *SeekableIterator* pour une itération simple (en utilisant *foreach*), aussi bien que
   l'accès direct à une *URL* spécifique en utilisant ``seek()``.

.. _zend.service.amazon.classes.resultset.totalresults:

Zend\Service\Amazon\ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``
Retourne le nombre total de résultats de la recherche

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offerset:

Zend\Service\Amazon\OfferSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque résultat retourné par :ref:`Zend\Service\Amazon::itemSearch() <zend.service.amazon.itemsearch>` et
:ref:`Zend\Service\Amazon::itemLookup() <zend.service.amazon.itemlookup>` contient un objet
``Zend\Service\Amazon\OfferSet`` au travers duquel il est possible de récupérer les informations de prix de
l'article.

.. _zend.service.amazon.classes.offerset.parameters:

Propriétés
^^^^^^^^^^

.. _zend.service.amazon.classes.offerset.parameters.table-1:

.. table:: Propriétés de Zend\Service\Amazon\OfferSet

   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+
   |Name                  |Type  |Description                                                                                                             |
   +======================+======+========================================================================================================================+
   |LowestNewPrice        |int   |Le plus bas prix pour l'article en condition "New" (ie les articles neufs)                                              |
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+
   |LowestNewPriceCurrency|string|La devise pour le LowestNewPrice                                                                                        |
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+
   |LowestOldPrice        |int   |Le plus bas prix pour l'article en condition "Used" (ie les articles d'occasion)                                        |
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+
   |LowestOldPriceCurrency|string|La devise pour le LowestOldPrice                                                                                        |
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+
   |TotalNew              |int   |Le nombre total des conditions "new" disponibles pour cet article (ie le nombre de modèles neufs en stock)              |
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+
   |TotalUsed             |int   |Le nombre total des conditions "used" disponible pour cet article (ie le nombre de modèles d'occasion en stock)         |
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+
   |TotalCollectible      |int   |Le nombre total des conditions "collectible" disponible pour cet article (ie le nombre de pièces de collection en stock)|
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+
   |TotalRefurbished      |int   |Le nombre total des conditions "refurbished" disponible pour cet article (ie le nombre de pièces remise à neuf en stock)|
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+
   |Offers                |array |Un tableau d'objets Zend\Service\Amazon\Offer                                                                           |
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offer:

Zend\Service\Amazon\Offer
^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque offre pour un article est retourné sous la forme d'un objet ``Zend\Service\Amazon\Offer``.

.. _zend.service.amazon.classes.offer.properties:

Zend\Service\Amazon\Offer Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. table:: Propriétés de Zend\Service\Amazon\Offer

   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+
   |Name                           |Type   |Description                                                                                       |
   +===============================+=======+==================================================================================================+
   |MerchantId                     |string |ID Amazon du fournisseur                                                                          |
   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+
   |MerchantName                   |string |Nom du fournisseur Amazon. Nécessite le réglage de ResponseGroup à OfferFull pour la récupération.|
   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+
   |GlancePage                     |string |URL de la page avec un résumé du fournisseur                                                      |
   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+
   |Condition                      |string |Condition de cet article                                                                          |
   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+
   |OfferListingId                 |string |ID de la liste d'offre                                                                            |
   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+
   |Price                          |int    |Prix de l'article                                                                                 |
   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+
   |CurrencyCode                   |string |Code de la devise pour le prix de l'article                                                       |
   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+
   |Availability                   |string |Disponibilité de l'article                                                                        |
   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+
   |IsEligibleForSuperSaverShipping|boolean|Est-ce que l'article est éligible ou pas pour un "Super Saver Shipping"                           |
   +-------------------------------+-------+--------------------------------------------------------------------------------------------------+

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.similarproduct:

Zend\Service\Amazon\SimilarProduct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lors de la recherche d'articles, Amazon retourne aussi une liste de produits similaires qui pourraient intéresser
le visiteur. Chacun d'entre eux est retourné dans un objet ``Zend\Service\Amazon\SimilarProduct``.

Chaque objet contient l'information qui vous permet de faire les requêtes suivantes pour obtenir les informations
complètes sur un article.

.. _zend.service.amazon.classes.similarproduct.properties:

Propriétés
^^^^^^^^^^

.. _zend.service.amazon.classes.similarproduct.properties.table-1:

.. table:: Propriétés de Zend\Service\Amazon\SimilarProduct

   +-----+------+---------------------------------------------+
   |Name |Type  |Description                                  |
   +=====+======+=============================================+
   |ASIN |string|Identifiant unique d'un produit Amazon (ASIN)|
   +-----+------+---------------------------------------------+
   |Title|string|Intitulé du produit                          |
   +-----+------+---------------------------------------------+

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.accessories:

Zend\Service\Amazon\Accessories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les accessoires pour un article retourné sont représentés comme un objet ``Zend\Service\Amazon\Accessories``.

.. _zend.service.amazon.classes.accessories.properties:

Propriétés
^^^^^^^^^^

.. _zend.service.amazon.classes.accessories.properties.table-1:

.. table:: Propriétés de Zend\Service\Amazon\Accessories

   +-----+------+---------------------------------------------+
   |Name |Type  |Description                                  |
   +=====+======+=============================================+
   |ASIN |string|Identifiant unique d'un produit Amazon (ASIN)|
   +-----+------+---------------------------------------------+
   |Title|string|Intitulé du produit                          |
   +-----+------+---------------------------------------------+

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.customerreview:

Zend\Service\Amazon\CustomerReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque revue de client est retournée sous la forme d'un objet ``Zend\Service\Amazon\CustomerReview``.

.. _zend.service.amazon.classes.customerreview.properties:

Propriétés
^^^^^^^^^^

.. _zend.service.amazon.classes.customerreview.properties.table-1:

.. table:: Propriétés de Zend\Service\Amazon\CustomerReview

   +------------+------+---------------------------------------------------+
   |Name        |Type  |Description                                        |
   +============+======+===================================================+
   |Rating      |string|Evaluation de l'article                            |
   +------------+------+---------------------------------------------------+
   |HelpfulVotes|string|Votes pour "Ce commentaire vous a-t'il été utile ?"|
   +------------+------+---------------------------------------------------+
   |CustomerId  |string|Identifiant du client                              |
   +------------+------+---------------------------------------------------+
   |TotalVotes  |string|Total des votes                                    |
   +------------+------+---------------------------------------------------+
   |Date        |string|Date de la revue                                   |
   +------------+------+---------------------------------------------------+
   |Summary     |string|Sommaire de la revue                               |
   +------------+------+---------------------------------------------------+
   |Content     |string|Contenu de la revue                                |
   +------------+------+---------------------------------------------------+

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.editorialreview:

Zend\Service\Amazon\EditorialReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque revue éditoriale d'un article est retournée dans un objet ``Zend\Service\Amazon\EditorialReview``.

.. _zend.service.amazon.classes.editorialreview.properties:

Propriétés
^^^^^^^^^^

.. _zend.service.amazon.classes.editorialreview.properties.table-1:

.. table:: Propriétés de Zend\Service\Amazon\EditorialReview

   +-------+------+-----------------------------+
   |Name   |Type  |Description                  |
   +=======+======+=============================+
   |Source |string|Source de la revue éditoriale|
   +-------+------+-----------------------------+
   |Content|string|Contenu de la revue          |
   +-------+------+-----------------------------+

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.listmania:

Zend\Service\Amazon\Listmania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque résultat de liste ListMania est retourné dans un objet ``Zend\Service\Amazon\Listmania``.

.. _zend.service.amazon.classes.listmania.properties:

Propriétés
^^^^^^^^^^

.. _zend.service.amazon.classes.listmania.properties.table-1:

.. table:: Propriétés de Zend\Service\Amazon\Listmania

   +--------+------+-----------------------+
   |Name    |Type  |Description            |
   +========+======+=======================+
   |ListId  |string|Identifiant de la liste|
   +--------+------+-----------------------+
   |ListName|string|Nom de la liste        |
   +--------+------+-----------------------+

:ref:`Retour à la liste des classes <zend.service.amazon.classes>`



.. _`Amazon Web Services`: http://aws.amazon.com/
.. _`la documentation Amazon correspondante.`: http://www.amazon.com/gp/aws/sdk/main.html/103-9285448-4703844?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemLookupOperation
.. _`la documentation Amazon correspondante`: http://www.amazon.com/gp/aws/sdk/main.html/103-9285448-4703844?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation
.. _`documentation spécifique`: http://www.amazon.com/gp/aws/sdk/main.html/102-9041115-9057709?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation
