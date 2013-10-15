.. EN-Revision: none
.. _zendservice.amazon:

ZendService\Amazon\Amazon
===================

.. _zendservice.amazon.introduction:

Introduction
------------

``ZendService\Amazon\Amazon`` est une *API* simple pour utiliser les Web services d'Amazon. ``ZendService\Amazon\Amazon`` a
deux *API*\ s : une plutôt traditionnelle qui suit la propre *API* d'Amazon, et un "Query *API*" simplifiée pour
construire facilement des requêtes de recherche, même compliquées.

``ZendService\Amazon\Amazon`` permet aux développeurs de récupérer des informations disponible sur le site Amazon.com
directement à travers l'API Amazon Web Services. Les exemples incluent :

   - Le stockage de données informatives, comme des images, des descriptions, le prix et plus

   - Revues éditoriales et commerciales

   - Des produits et accessoires similaires

   - Les offres Amazon.com

   - Les listes ListMania



Pour pouvoir utiliser ``ZendService\Amazon\Amazon``, vous devez avant tout avoir une clé "developer *API*" Amazon ainsi
que votre clé secrète. Pour obtenir une telle clé et pour plus d'informations, vous pouvez visitez le site Web
`Amazon Web Services`_. A partir du 15 août 2009, vous ne pourrez utiliser l'API Amazon à travers
``ZendService\Amazon\Amazon``, quand spécifiant la clé secrète.

.. note::

   **Attention**

   Votre clé "developer *API*" et votre clé secret sont liées à votre identité Amazon, donc faites en sorte de
   les conserver privées.

.. _zendservice.amazon.introduction.example.itemsearch:

.. rubric:: Recherche sur Amazon en utilisant l'API traditionnelle

Dans cet exemple, nous recherchons les livres sur *PHP* disponibles chez Amazon et boucler sur les résultats pour
les afficher.

.. code-block:: php
   :linenos:

   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $response = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                         'Keywords' => 'php'));
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zendservice.amazon.introduction.example.query_api:

.. rubric:: Recherche sur Amazon en utilisant l'API de requête

Ici nous cherchons aussi les livres sur *PHP* disponibles chez Amazon, mais en utilisant l'API de requête, qui
ressemble au modèle de conception Interface Fluide.

.. code-block:: php
   :linenos:

   $query = new ZendService\Amazon\Query('AMAZON_API_KEY',
                                          'US',
                                          'AMAZON_SECRET_KEY');
   $query->category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zendservice.amazon.countrycodes:

Codes de pays
-------------

Par défaut, ``ZendService\Amazon\Amazon`` se connecte au Web service Amazon américain ("*US*"). Pour se connecter
depuis un pays différent, il vous suffit simplement de définir, comme second paramètre du constructeur, la
chaîne de caractère correspondant au code du pays :

.. _zendservice.amazon.countrycodes.example.country_code:

.. rubric:: Choisir un service Web Amazon d'un pays

.. code-block:: php
   :linenos:

   // Connexion à Amazon France
   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'FR', 'AMAZON_SECRET_KEY');

.. note::

   **Codes de pays**

   Les codes de pays valides sont *CA*, *DE*, *FR*, *JP*, *UK*, et *US*.

.. _zendservice.amazon.itemlookup:

Rechercher un produit Amazon spécifique avec son ASIN
-----------------------------------------------------

La méthode ``itemLookup()`` fournit la possibilité de rechercher un produit Amazon particulier lorsque son *ASIN*
est connu.

.. rubric:: Rechercher une produit Amazon spécifique avec son ASIN

.. code-block:: php
   :linenos:

   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $item = $amazon->itemLookup('B0000A432X');

La méthode ``itemLookup()`` accepte aussi un second paramètre optionnel pour gérer les options de recherche.
Pour les détails complets et une liste des options disponibles, visitez `la documentation Amazon
correspondante.`_.

.. note::

   **Information sur les images**

   Pour récupérer les informations d'images pour vos résultats de recherche, vous devez définir l'option
   *ResponseGroup* à *Medium* ou *Large*.

.. _zendservice.amazon.itemsearch:

Lancer des recherches de produits sur Amazon
--------------------------------------------

Rechercher des produits basés sur tous les divers critères disponibles sont rendus simples grâce à la méthode
``itemSearch()``, comme le montre l'exemple suivant :

.. _zendservice.amazon.itemsearch.example.basic:

.. rubric:: Lancer des recherches de produits sur Amazon

.. code-block:: php
   :linenos:

   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zendservice.amazon.itemsearch.example.responsegroup:

.. rubric:: Utilisation de l'option *ResponseGroup*

L'option *ResponseGroup* est utilisée pour contrôler les informations spécifiques qui sont retournées dans la
réponse.

.. code-block:: php
   :linenos:

   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
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

   La classe :ref:`ZendService\Amazon\Query <zendservice.amazon.query>` est une enveloppe simple d'utilisation de
   cette méthode.

.. _zendservice.amazon.query:

Utiliser l'API alternative de requêtes
--------------------------------------

.. _zendservice.amazon.query.introduction:

Introduction
^^^^^^^^^^^^

``ZendService\Amazon\Query`` fournit une *API* alternative pour utiliser le service Web Amazon. L'API alternative
utilise le modèle de conception 'Interface Fluide'. C'est à dire que les appels peuvent-être fait en utilisant
une chaîne d'appels de méthodes (ie *$obj->method()->method2($arg)*)

L'API ``ZendService\Amazon\Query`` utilise la surcharge pour mettre en place facilement une recherche d'article,
et ainsi vous permettre de chercher en se basant sur les critères spécifiés. Chacune de ces options est fournie
en tant qu'appel de méthode, et chaque paramètre de méthode correspond à la valeur des options nommées.

.. _zendservice.amazon.query.introduction.example.basic:

.. rubric:: Rechercher sur Amazon en utilisant l'API alternative de requêtes

Dans cet exemple, l'API de requêtes alternative est utilisée comme une interface fluide pour spécifier les
options et leurs valeurs respectives :

.. code-block:: php
   :linenos:

   $query = new ZendService\Amazon\Query('MY_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $query->Category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

Cela définit l'option *Category* à "Livres" et *Keywords* à "PHP".

Pour plus d'information sur les options disponibles, vous pouvez vous référer à la `documentation spécifique`_.

.. _zendservice.amazon.classes:

Classes ZendService\Amazon\Amazon
---------------------------

Les classes suivantes sont toutes retournées par :ref:`ZendService\Amazon\Amazon::itemLookup()
<zendservice.amazon.itemlookup>` et :ref:`ZendService\Amazon\Amazon::itemSearch() <zendservice.amazon.itemsearch>`:

   - :ref:`ZendService\Amazon\Item <zendservice.amazon.classes.item>`

   - :ref:`ZendService\Amazon\Image <zendservice.amazon.classes.image>`

   - :ref:`ZendService\Amazon\ResultSet <zendservice.amazon.classes.resultset>`

   - :ref:`ZendService\Amazon\OfferSet <zendservice.amazon.classes.offerset>`

   - :ref:`ZendService\Amazon\Offer <zendservice.amazon.classes.offer>`

   - :ref:`ZendService\Amazon\SimilarProduct <zendservice.amazon.classes.similarproduct>`

   - :ref:`ZendService\Amazon\Accessories <zendservice.amazon.classes.accessories>`

   - :ref:`ZendService\Amazon\CustomerReview <zendservice.amazon.classes.customerreview>`

   - :ref:`ZendService\Amazon\EditorialReview <zendservice.amazon.classes.editorialreview>`

   - :ref:`ZendService\Amazon\ListMania <zendservice.amazon.classes.listmania>`



.. _zendservice.amazon.classes.item:

ZendService\Amazon\Item
^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Amazon\Item`` est le type de classe utilisé pour représenter un produit Amazon retourné par le
service Web. Elle récupère tous les attributs des articles, incluant le titre, la description, les revues, etc.

.. _zendservice.amazon.classes.item.asxml:

ZendService\Amazon\Item::asXML()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

string:``asXML()``


Retourne le *XML* original de l'article

.. _zendservice.amazon.classes.item.properties:

Propriétés
^^^^^^^^^^

``ZendService\Amazon\Item`` a un nombre de propriétés directement relié à leur contre-parties de l'API
standard Amazon.

.. _zendservice.amazon.classes.item.properties.table-1:

.. table:: Propriétés de ZendService\Amazon\Item

   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Nom             |Type                        |Description                                                                                              |
   +================+============================+=========================================================================================================+
   |ASIN            |string                      |Amazon Item ID                                                                                           |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |DetailPageURL   |string                      |URL pour la page de détail des articles                                                                  |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |SalesRank       |int                         |Niveau de vente pour cet article                                                                         |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |SmallImage      |ZendService\Amazon\Image   |Petite image de l'article                                                                                |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |MediumImage     |ZendService\Amazon\Image   |Image moyenne de l'article                                                                               |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |LargeImage      |ZendService\Amazon\Image   |Grande image de l'article                                                                                |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Subjects        |array                       |Sujets de l'article                                                                                      |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Les offres      |ZendService\Amazon\OfferSet|Sommaire des offres, et offres pour l'article                                                            |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |CustomerReviews |array                       |Les revues clients sont représentées comme un tableau d'objets ZendService\Amazon\CustomerReview        |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |EditorialReviews|array                       |Les revues éditoriales sont représentées comme un tableau d'objets ZendService\Amazon\EditorialReview   |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |SimilarProducts |array                       |Les produits similaires sont représentés comme un tableau d'objets ZendService\Amazon\SimilarProduct    |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Accessories     |array                       |Les accessoires pour l'article sont représentés comme un tableau d'objets ZendService\Amazon\Accessories|
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |Tracks          |array                       |Un tableau contenant le nombre de pistes ainsi que les noms pour les CDs ou DVDs musicaux                |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |ListmaniaLists  |array                       |Les listes Listmania reliées à un article, comme un tableau d'objets ZendService\Amazon\ListmaniaList   |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+
   |PromotionalTag  |string                      |Balise promotionnelle de l'article                                                                       |
   +----------------+----------------------------+---------------------------------------------------------------------------------------------------------+

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.image:

ZendService\Amazon\Image
^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Amazon\Image`` représente une image distante pour un produit.

.. _zendservice.amazon.classes.image.properties:

Propriétés
^^^^^^^^^^

.. _zendservice.amazon.classes.image.properties.table-1:

.. table:: Propriétés de ZendService\Amazon\Image

   +------+--------+---------------------------------+
   |Name  |Type    |Description                      |
   +======+========+=================================+
   |Url   |Zend_Uri|Url distante de l'image          |
   +------+--------+---------------------------------+
   |Height|int     |La hauteur (en pixels) de l'image|
   +------+--------+---------------------------------+
   |Width |int     |La largeur (en pixels) de l'image|
   +------+--------+---------------------------------+

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.resultset:

ZendService\Amazon\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Des objets ``ZendService\Amazon\ResultSet`` sont retournés par :ref:`ZendService\Amazon\Amazon::itemSearch()
<zendservice.amazon.itemsearch>` et vous permettent de gérer facilement les différents résultats retournés.

.. note::

   **SeekableIterator**

   Implémente l'itérateur *SeekableIterator* pour une itération simple (en utilisant *foreach*), aussi bien que
   l'accès direct à une *URL* spécifique en utilisant ``seek()``.

.. _zendservice.amazon.classes.resultset.totalresults:

ZendService\Amazon\ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``
Retourne le nombre total de résultats de la recherche

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.offerset:

ZendService\Amazon\OfferSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque résultat retourné par :ref:`ZendService\Amazon\Amazon::itemSearch() <zendservice.amazon.itemsearch>` et
:ref:`ZendService\Amazon\Amazon::itemLookup() <zendservice.amazon.itemlookup>` contient un objet
``ZendService\Amazon\OfferSet`` au travers duquel il est possible de récupérer les informations de prix de
l'article.

.. _zendservice.amazon.classes.offerset.parameters:

Propriétés
^^^^^^^^^^

.. _zendservice.amazon.classes.offerset.parameters.table-1:

.. table:: Propriétés de ZendService\Amazon\OfferSet

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
   |Offers                |array |Un tableau d'objets ZendService\Amazon\Offer                                                                           |
   +----------------------+------+------------------------------------------------------------------------------------------------------------------------+

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.offer:

ZendService\Amazon\Offer
^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque offre pour un article est retourné sous la forme d'un objet ``ZendService\Amazon\Offer``.

.. _zendservice.amazon.classes.offer.properties:

ZendService\Amazon\Offer Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. table:: Propriétés de ZendService\Amazon\Offer

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

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.similarproduct:

ZendService\Amazon\SimilarProduct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lors de la recherche d'articles, Amazon retourne aussi une liste de produits similaires qui pourraient intéresser
le visiteur. Chacun d'entre eux est retourné dans un objet ``ZendService\Amazon\SimilarProduct``.

Chaque objet contient l'information qui vous permet de faire les requêtes suivantes pour obtenir les informations
complètes sur un article.

.. _zendservice.amazon.classes.similarproduct.properties:

Propriétés
^^^^^^^^^^

.. _zendservice.amazon.classes.similarproduct.properties.table-1:

.. table:: Propriétés de ZendService\Amazon\SimilarProduct

   +-----+------+---------------------------------------------+
   |Name |Type  |Description                                  |
   +=====+======+=============================================+
   |ASIN |string|Identifiant unique d'un produit Amazon (ASIN)|
   +-----+------+---------------------------------------------+
   |Title|string|Intitulé du produit                          |
   +-----+------+---------------------------------------------+

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.accessories:

ZendService\Amazon\Accessories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les accessoires pour un article retourné sont représentés comme un objet ``ZendService\Amazon\Accessories``.

.. _zendservice.amazon.classes.accessories.properties:

Propriétés
^^^^^^^^^^

.. _zendservice.amazon.classes.accessories.properties.table-1:

.. table:: Propriétés de ZendService\Amazon\Accessories

   +-----+------+---------------------------------------------+
   |Name |Type  |Description                                  |
   +=====+======+=============================================+
   |ASIN |string|Identifiant unique d'un produit Amazon (ASIN)|
   +-----+------+---------------------------------------------+
   |Title|string|Intitulé du produit                          |
   +-----+------+---------------------------------------------+

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.customerreview:

ZendService\Amazon\CustomerReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque revue de client est retournée sous la forme d'un objet ``ZendService\Amazon\CustomerReview``.

.. _zendservice.amazon.classes.customerreview.properties:

Propriétés
^^^^^^^^^^

.. _zendservice.amazon.classes.customerreview.properties.table-1:

.. table:: Propriétés de ZendService\Amazon\CustomerReview

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

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.editorialreview:

ZendService\Amazon\EditorialReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque revue éditoriale d'un article est retournée dans un objet ``ZendService\Amazon\EditorialReview``.

.. _zendservice.amazon.classes.editorialreview.properties:

Propriétés
^^^^^^^^^^

.. _zendservice.amazon.classes.editorialreview.properties.table-1:

.. table:: Propriétés de ZendService\Amazon\EditorialReview

   +-------+------+-----------------------------+
   |Name   |Type  |Description                  |
   +=======+======+=============================+
   |Source |string|Source de la revue éditoriale|
   +-------+------+-----------------------------+
   |Content|string|Contenu de la revue          |
   +-------+------+-----------------------------+

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.listmania:

ZendService\Amazon\Listmania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Chaque résultat de liste ListMania est retourné dans un objet ``ZendService\Amazon\Listmania``.

.. _zendservice.amazon.classes.listmania.properties:

Propriétés
^^^^^^^^^^

.. _zendservice.amazon.classes.listmania.properties.table-1:

.. table:: Propriétés de ZendService\Amazon\Listmania

   +--------+------+-----------------------+
   |Name    |Type  |Description            |
   +========+======+=======================+
   |ListId  |string|Identifiant de la liste|
   +--------+------+-----------------------+
   |ListName|string|Nom de la liste        |
   +--------+------+-----------------------+

:ref:`Retour à la liste des classes <zendservice.amazon.classes>`



.. _`Amazon Web Services`: http://aws.amazon.com/
.. _`la documentation Amazon correspondante.`: http://www.amazon.com/gp/aws/sdk/main.html/103-9285448-4703844?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemLookupOperation
.. _`la documentation Amazon correspondante`: http://www.amazon.com/gp/aws/sdk/main.html/103-9285448-4703844?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation
.. _`documentation spécifique`: http://www.amazon.com/gp/aws/sdk/main.html/102-9041115-9057709?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation
