
Zend_Service_Amazon
===================

.. _zend.service.amazon.introduction:

Introduction
------------

``Zend_Service_Amazon`` is a simple *API* for using Amazon web services. ``Zend_Service_Amazon`` has two *API* s: a more traditional one that follows Amazon's own *API* , and a simpler "Query *API* " for constructing even complex search queries easily.

``Zend_Service_Amazon`` enables developers to retrieve information appearing throughout Amazon.com web sites directly through the Amazon Web Services *API* . Examples include:
    - Store item information, such as images, descriptions, pricing, and more
    - Customer and editorial reviewsSimilar products and accessoriesAmazon.com offersListMania lists



In order to use ``Zend_Service_Amazon`` , you should already have an Amazon developer *API* key aswell as a secret key. To get a key and for more information, please visit the `Amazon Web Services`_ web site. As of August 15th, 2009 you can only use the Amazon Product Advertising *API* through ``Zend_Service_Amazon`` , when specifying the additional secret key.

.. note::
    **Attention**

    Your Amazon developer *API* and secret keys are linked to your Amazon identity, so take appropriate measures to keep them private.

.. _zend.service.amazon.introduction.example.itemsearch:

Search Amazon Using the Traditional API
---------------------------------------

In this example, we search for *PHP* books at Amazon and loop through the results, printing them.

.. code-block:: php
    :linenos:
    
    $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
    $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                         'Keywords' => 'php'));
    foreach ($results as $result) {
        echo $result->Title . '<br />';
    }
    

.. _zend.service.amazon.introduction.example.query_api:

Search Amazon Using the Query API
---------------------------------

Here, we also search for *PHP* books at Amazon, but we instead use the Query *API* , which resembles the Fluent Interface design pattern.

.. code-block:: php
    :linenos:
    
    $query = new Zend_Service_Amazon_Query('AMAZON_API_KEY',
                                           'US',
                                           'AMAZON_SECRET_KEY');
    $query->category('Books')->Keywords('PHP');
    $results = $query->search();
    foreach ($results as $result) {
        echo $result->Title . '<br />';
    }
    

.. _zend.service.amazon.countrycodes:

Country Codes
-------------

By default, ``Zend_Service_Amazon`` connects to the United States ("US") Amazon web service. To connect from a different country, simply specify the appropriate country code string as the second parameter to the constructor:

.. _zend.service.amazon.countrycodes.example.country_code:

Choosing an Amazon Web Service Country
--------------------------------------

.. code-block:: php
    :linenos:
    
    // Connect to Amazon in Japan
    $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'JP', 'AMAZON_SECRET_KEY');
    

.. note::
    **Country codes**

    Valid country codes are:CA,DE,FR,JP,UK, andUS.

.. _zend.service.amazon.itemlookup:

Looking up a Specific Amazon Item by ASIN
-----------------------------------------

The ``itemLookup()`` method provides the ability to fetch a particular Amazon item when the *ASIN* is known.

.. _zend.service.amazon.itemlookup.example.asin:

Looking up a Specific Amazon Item by ASIN
-----------------------------------------

.. code-block:: php
    :linenos:
    
    $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
    $item = $amazon->itemLookup('B0000A432X');
    

The ``itemLookup()`` method also accepts an optional second parameter for handling search options. For full details, including a list of available options, please see the `relevant Amazon documentation`_ .

.. note::
    **Image information**

    To retrieve images information for your search results, you must setResponseGroupoption toMediumorLarge.

.. _zend.service.amazon.itemsearch:

Performing Amazon Item Searches
-------------------------------

Searching for items based on any of various available criteria are made simple using the ``itemSearch()`` method, as in the following example:

.. _zend.service.amazon.itemsearch.example.basic:

Performing Amazon Item Searches
-------------------------------

.. code-block:: php
    :linenos:
    
    $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
    $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                         'Keywords' => 'php'));
    foreach ($results as $result) {
        echo $result->Title . '<br />';
    }
    

.. _zend.service.amazon.itemsearch.example.responsegroup:

Using the ResponseGroup Option
------------------------------

TheResponseGroupoption is used to control the specific information that will be returned in the response.

.. code-block:: php
    :linenos:
    
    $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
    $results = $amazon->itemSearch(array(
        'SearchIndex'   => 'Books',
        'Keywords'      => 'php',
        'ResponseGroup' => 'Small,ItemAttributes,Images,SalesRank,Reviews,' .
                           'EditorialReview,Similarities,ListmaniaLists'
        ));
    foreach ($results as $result) {
        echo $result->Title . '<br />';
    }
    

The ``itemSearch()`` method accepts a single array parameter for handling search options. For full details, including a list of available options, please see the `relevant Amazon documentation`_ 

The :ref:`Zend_Service_Amazon_Query <zend.service.amazon.query>` class is an easy to use wrapper around this method.

.. _zend.service.amazon.query:

Using the Alternative Query API
-------------------------------

.. _zend.service.amazon.query.introduction:

Introduction
------------

``Zend_Service_Amazon_Query`` provides an alternative *API* for using the Amazon Web Service. The alternative *API* uses the Fluent Interface pattern. That is, all calls can be made using chained method calls. (e.g.,$obj->method()->method2($arg))

The ``Zend_Service_Amazon_Query``  *API* uses overloading to easily set up an item search and then allows you to search based upon the criteria specified. Each of the options is provided as a method call, and each method's argument corresponds to the named option's value:

.. _zend.service.amazon.query.introduction.example.basic:

Search Amazon Using the Alternative Query API
---------------------------------------------

In this example, the alternative query *API* is used as a fluent interface to specify options and their respective values:

.. code-block:: php
    :linenos:
    
    $query = new Zend_Service_Amazon_Query('MY_API_KEY', 'US', 'AMAZON_SECRET_KEY');
    $query->Category('Books')->Keywords('PHP');
    $results = $query->search();
    foreach ($results as $result) {
        echo $result->Title . '<br />';
    }
    

This sets the optionCategoryto "Books" andKeywordsto "PHP".

For more information on the available options, please refer to the `relevant Amazon documentation`_ .

.. _zend.service.amazon.classes:

Zend_Service_Amazon Classes
---------------------------

The following classes are all returned by :ref:`Zend_Service_Amazon::itemLookup() <zend.service.amazon.itemlookup>` and :ref:`Zend_Service_Amazon::itemSearch() <zend.service.amazon.itemsearch>` :
    - Zend_Service_Amazon_ItemZend_Service_Amazon_ImageZend_Service_Amazon_ResultSetZend_Service_Amazon_OfferSetZend_Service_Amazon_OfferZend_Service_Amazon_SimilarProductZend_Service_Amazon_AccessoriesZend_Service_Amazon_CustomerReviewZend_Service_Amazon_EditorialReviewZend_Service_Amazon_ListMania



.. _zend.service.amazon.classes.item:

Zend_Service_Amazon_Item
------------------------

``Zend_Service_Amazon_Item`` is the class type used to represent an Amazon item returned by the web service. It encompasses all of the items attributes, including title, description, reviews, etc.

.. _zend.service.amazon.classes.item.asxml:

Zend_Service_Amazon_Item::asXML()
---------------------------------

``string``  ``asXML`` 

Return the original *XML* for the item

.. _zend.service.amazon.classes.item.properties:

Properties
----------

``Zend_Service_Amazon_Item`` has a number of properties directly related to their standard Amazon *API* counterparts.

.. _zend.service.amazon.classes.item.properties.table-1:


Zend_Service_Amazon_Item Properties
-----------------------------------
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|Name            |Type                        |Description                                                                                |
+================+============================+===========================================================================================+
|ASIN            |string                      |Amazon Item ID                                                                             |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|DetailPageURL   |string                      |URL to the Items Details Page                                                              |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|SalesRank       |int                         |Sales Rank for the Item                                                                    |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|SmallImage      |Zend_Service_Amazon_Image   |Small Image of the Item                                                                    |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|MediumImage     |Zend_Service_Amazon_Image   |Medium Image of the Item                                                                   |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|LargeImage      |Zend_Service_Amazon_Image   |Large Image of the Item                                                                    |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|Subjects        |array                       |Item Subjects                                                                              |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|Offers          |Zend_Service_Amazon_OfferSet|Offer Summary and Offers for the Item                                                      |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|CustomerReviews |array                       |Customer reviews represented as an array of Zend_Service_Amazon_CustomerReview objects     |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|EditorialReviews|array                       |Editorial reviews represented as an array of Zend_Service_Amazon_EditorialReview objects   |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|SimilarProducts |array                       |Similar Products represented as an array of Zend_Service_Amazon_SimilarProduct objects     |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|Accessories     |array                       |Accessories for the item represented as an array of Zend_Service_Amazon_Accessories objects|
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|Tracks          |array                       |An array of track numbers and names for Music CDs and DVDs                                 |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|ListmaniaLists  |array                       |Item related Listmania Lists as an array of Zend_Service_Amazon_ListmainList objects       |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+
|PromotionalTag  |string                      |Item Promotional Tag                                                                       |
+----------------+----------------------------+-------------------------------------------------------------------------------------------+


:ref:`Back to Class List <zend.service.amazon.classes>` 

.. _zend.service.amazon.classes.image:

Zend_Service_Amazon_Image
-------------------------

``Zend_Service_Amazon_Image`` represents a remote Image for a product.

.. _zend.service.amazon.classes.image.properties:

Properties
----------

.. _zend.service.amazon.classes.image.properties.table-1:


Zend_Service_Amazon_Image Properties
------------------------------------
+------+--------+---------------------------------+
|Name  |Type    |Description                      |
+======+========+=================================+
|Url   |Zend_Uri|Remote URL for the Image         |
+------+--------+---------------------------------+
|Height|int     |The Height of the image in pixels|
+------+--------+---------------------------------+
|Width |int     |The Width of the image in pixels |
+------+--------+---------------------------------+


:ref:`Back to Class List <zend.service.amazon.classes>` 

.. _zend.service.amazon.classes.resultset:

Zend_Service_Amazon_ResultSet
-----------------------------

``Zend_Service_Amazon_ResultSet`` objects are returned by :ref:`Zend_Service_Amazon::itemSearch() <zend.service.amazon.itemsearch>` and allow you to easily handle the multiple results returned.

.. note::
    **SeekableIterator**

    Implements theSeekableIteratorfor easy iteration (e.g. usingforeach), as well as direct access to a specific result using ``seek()`` .

.. _zend.service.amazon.classes.resultset.totalresults:

Zend_Service_Amazon_ResultSet::totalResults()
---------------------------------------------
``int``  ``totalResults`` 
Returns the total number of results returned by the search

:ref:`Back to Class List <zend.service.amazon.classes>` 

.. _zend.service.amazon.classes.offerset:

Zend_Service_Amazon_OfferSet
----------------------------

Each result returned by :ref:`Zend_Service_Amazon::itemSearch() <zend.service.amazon.itemsearch>` and :ref:`Zend_Service_Amazon::itemLookup() <zend.service.amazon.itemlookup>` contains a ``Zend_Service_Amazon_OfferSet`` object through which pricing information for the item can be retrieved.

.. _zend.service.amazon.classes.offerset.parameters:

Properties
----------

.. _zend.service.amazon.classes.offerset.parameters.table-1:


Zend_Service_Amazon_OfferSet Properties
---------------------------------------
+----------------------+------+--------------------------------------------------------------+
|Name                  |Type  |Description                                                   |
+======================+======+==============================================================+
|LowestNewPrice        |int   |Lowest Price for the item in "New" condition                  |
+----------------------+------+--------------------------------------------------------------+
|LowestNewPriceCurrency|string|The currency for the LowestNewPrice                           |
+----------------------+------+--------------------------------------------------------------+
|LowestOldPrice        |int   |Lowest Price for the item in "Used" condition                 |
+----------------------+------+--------------------------------------------------------------+
|LowestOldPriceCurrency|string|The currency for the LowestOldPrice                           |
+----------------------+------+--------------------------------------------------------------+
|TotalNew              |int   |Total number of "new" condition available for the item        |
+----------------------+------+--------------------------------------------------------------+
|TotalUsed             |int   |Total number of "used" condition available for the item       |
+----------------------+------+--------------------------------------------------------------+
|TotalCollectible      |int   |Total number of "collectible" condition available for the item|
+----------------------+------+--------------------------------------------------------------+
|TotalRefurbished      |int   |Total number of "refurbished" condition available for the item|
+----------------------+------+--------------------------------------------------------------+
|Offers                |array |An array of Zend_Service_Amazon_Offer objects.                |
+----------------------+------+--------------------------------------------------------------+


:ref:`Back to Class List <zend.service.amazon.classes>` 

.. _zend.service.amazon.classes.offer:

Zend_Service_Amazon_Offer
-------------------------

Each offer for an item is returned as an ``Zend_Service_Amazon_Offer`` object.

.. _zend.service.amazon.classes.offer.properties:

Zend_Service_Amazon_Offer Properties
------------------------------------

.. _zend.service.amazon.classes.offer.properties.table-1:


Properties
----------
+-------------------------------+-------+------------------------------------------------------------------------------------------+
|Name                           |Type   |Description                                                                               |
+===============================+=======+==========================================================================================+
|MerchantId                     |string |Merchants Amazon ID                                                                       |
+-------------------------------+-------+------------------------------------------------------------------------------------------+
|MerchantName                   |string |Merchants Amazon Name. Requires setting the ResponseGroup option to OfferFull to retrieve.|
+-------------------------------+-------+------------------------------------------------------------------------------------------+
|GlancePage                     |string |URL for a page with a summary of the Merchant                                             |
+-------------------------------+-------+------------------------------------------------------------------------------------------+
|Condition                      |string |Condition of the item                                                                     |
+-------------------------------+-------+------------------------------------------------------------------------------------------+
|OfferListingId                 |string |ID of the Offer Listing                                                                   |
+-------------------------------+-------+------------------------------------------------------------------------------------------+
|Price                          |int    |Price for the item                                                                        |
+-------------------------------+-------+------------------------------------------------------------------------------------------+
|CurrencyCode                   |string |Currency Code for the price of the item                                                   |
+-------------------------------+-------+------------------------------------------------------------------------------------------+
|Availability                   |string |Availability of the item                                                                  |
+-------------------------------+-------+------------------------------------------------------------------------------------------+
|IsEligibleForSuperSaverShipping|boolean|Whether the item is eligible for Super Saver Shipping or not                              |
+-------------------------------+-------+------------------------------------------------------------------------------------------+


:ref:`Back to Class List <zend.service.amazon.classes>` 

.. _zend.service.amazon.classes.similarproduct:

Zend_Service_Amazon_SimilarProduct
----------------------------------

When searching for items, Amazon also returns a list of similar products that the searcher may find to their liking. Each of these is returned as a ``Zend_Service_Amazon_SimilarProduct`` object.

Each object contains the information to allow you to make sub-sequent requests to get the full information on the item.

.. _zend.service.amazon.classes.similarproduct.properties:

Properties
----------

.. _zend.service.amazon.classes.similarproduct.properties.table-1:


Zend_Service_Amazon_SimilarProduct Properties
---------------------------------------------
+-----+------+--------------------------------+
|Name |Type  |Description                     |
+=====+======+================================+
|ASIN |string|Products Amazon Unique ID (ASIN)|
+-----+------+--------------------------------+
|Title|string|Products Title                  |
+-----+------+--------------------------------+


:ref:`Back to Class List <zend.service.amazon.classes>` 

.. _zend.service.amazon.classes.accessories:

Zend_Service_Amazon_Accessories
-------------------------------

Accessories for the returned item are represented as ``Zend_Service_Amazon_Accessories`` objects

.. _zend.service.amazon.classes.accessories.properties:

Properties
----------

.. _zend.service.amazon.classes.accessories.properties.table-1:


Zend_Service_Amazon_Accessories Properties
------------------------------------------
+-----+------+--------------------------------+
|Name |Type  |Description                     |
+=====+======+================================+
|ASIN |string|Products Amazon Unique ID (ASIN)|
+-----+------+--------------------------------+
|Title|string|Products Title                  |
+-----+------+--------------------------------+


:ref:`Back to Class List <zend.service.amazon.classes>` 

.. _zend.service.amazon.classes.customerreview:

Zend_Service_Amazon_CustomerReview
----------------------------------

Each Customer Review is returned as a ``Zend_Service_Amazon_CustomerReview`` object.

.. _zend.service.amazon.classes.customerreview.properties:

Properties
----------

.. _zend.service.amazon.classes.customerreview.properties.table-1:


Zend_Service_Amazon_CustomerReview Properties
---------------------------------------------
+------------+------+----------------------------------+
|Name        |Type  |Description                       |
+============+======+==================================+
|Rating      |string|Item Rating                       |
+------------+------+----------------------------------+
|HelpfulVotes|string|Votes on how helpful the review is|
+------------+------+----------------------------------+
|CustomerId  |string|Customer ID                       |
+------------+------+----------------------------------+
|TotalVotes  |string|Total Votes                       |
+------------+------+----------------------------------+
|Date        |string|Date of the Review                |
+------------+------+----------------------------------+
|Summary     |string|Review Summary                    |
+------------+------+----------------------------------+
|Content     |string|Review Content                    |
+------------+------+----------------------------------+


:ref:`Back to Class List <zend.service.amazon.classes>` 

.. _zend.service.amazon.classes.editorialreview:

Zend_Service_Amazon_EditorialReview
-----------------------------------

Each items Editorial Reviews are returned as a ``Zend_Service_Amazon_EditorialReview`` object

.. _zend.service.amazon.classes.editorialreview.properties:

Properties
----------

.. _zend.service.amazon.classes.editorialreview.properties.table-1:


Zend_Service_Amazon_EditorialReview Properties
----------------------------------------------
+-------+------+------------------------------+
|Name   |Type  |Description                   |
+=======+======+==============================+
|Source |string|Source of the Editorial Review|
+-------+------+------------------------------+
|Content|string|Review Content                |
+-------+------+------------------------------+


:ref:`Back to Class List <zend.service.amazon.classes>` 

.. _zend.service.amazon.classes.listmania:

Zend_Service_Amazon_Listmania
-----------------------------

Each results List Mania List items are returned as ``Zend_Service_Amazon_Listmania`` objects.

.. _zend.service.amazon.classes.listmania.properties:

Properties
----------

.. _zend.service.amazon.classes.listmania.properties.table-1:


Zend_Service_Amazon_Listmania Properties
----------------------------------------
+--------+------+-----------+
|Name    |Type  |Description|
+========+======+===========+
|ListId  |string|List ID    |
+--------+------+-----------+
|ListName|string|List Name  |
+--------+------+-----------+


:ref:`Back to Class List <zend.service.amazon.classes>` 


.. _`Amazon Web Services`: http://aws.amazon.com/
.. _`relevant Amazon documentation`: http://www.amazon.com/gp/aws/sdk/main.html/102-9041115-9057709?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation
