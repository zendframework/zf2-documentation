.. _zendservice.amazon:

ZendService\\Amazon
===================

.. _zendservice.amazon.introduction:

Introduction
------------

``ZendService\Amazon\Amazon`` is a simple *API* for using Amazon web services. ``ZendService\Amazon\Amazon`` has two *API*\ s:
a more traditional one that follows Amazon's own *API*, and a simpler "Query *API*" for constructing even complex
search queries easily.

``ZendService\Amazon\Amazon`` enables developers to retrieve information appearing throughout Amazon.com web sites
directly through the Amazon Web Services *API*. Examples include:



   - Store item information, such as images, descriptions, pricing, and more

   - Customer and editorial reviews

   - Similar products and accessories

   - Amazon.com offers

   - ListMania lists



In order to use ``ZendService\Amazon\Amazon``, you should already have an Amazon developer *API* key as well as a secret
key. To get a key and for more information, please visit the `Amazon Web Services`_ web site. As of August 15th,
2009 you can only use the Amazon Product Advertising *API* through ``ZendService\Amazon\Amazon``, when specifying the
additional secret key.

.. note::

   **Attention**

   Your Amazon developer *API* and secret keys are linked to your Amazon identity, so take appropriate measures to
   keep them private.

.. _zendservice.amazon.introduction.example.itemsearch:

.. rubric:: Search Amazon Using the Traditional API

In this example, we search for *PHP* books at Amazon and loop through the results, printing them.

.. code-block:: php
   :linenos:

   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zendservice.amazon.introduction.example.query_api:

.. rubric:: Search Amazon Using the Query API

Here, we also search for *PHP* books at Amazon, but we instead use the Query *API*, which resembles the Fluent
Interface design pattern.

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

Country Codes
-------------

By default, ``ZendService\Amazon\Amazon`` connects to the United States ("*US*") Amazon web service. To connect from a
different country, simply specify the appropriate country code string as the second parameter to the constructor:

.. _zendservice.amazon.countrycodes.example.country_code:

.. rubric:: Choosing an Amazon Web Service Country

.. code-block:: php
   :linenos:

   // Connect to Amazon in Japan
   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'JP', 'AMAZON_SECRET_KEY');

.. note::

   **Country codes**

   Valid country codes are: *CA*, *DE*, *FR*, *JP*, *UK*, and *US*.

.. _zendservice.amazon.itemlookup:

Looking up a Specific Amazon Item by ASIN
-----------------------------------------

The ``itemLookup()`` method provides the ability to fetch a particular Amazon item when the *ASIN* is known.

.. _zendservice.amazon.itemlookup.example.asin:

.. rubric:: Looking up a Specific Amazon Item by ASIN

.. code-block:: php
   :linenos:

   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $item = $amazon->itemLookup('B0000A432X');

The ``itemLookup()`` method also accepts an optional second parameter for handling search options. For full
details, including a list of available options, please see the `relevant Amazon documentation`_.

.. note::

   **Image information**

   To retrieve images information for your search results, you must set *ResponseGroup* option to *Medium* or
   *Large*.

.. _zendservice.amazon.itemsearch:

Performing Amazon Item Searches
-------------------------------

Searching for items based on any of various available criteria are made simple using the ``itemSearch()`` method,
as in the following example:

.. _zendservice.amazon.itemsearch.example.basic:

.. rubric:: Performing Amazon Item Searches

.. code-block:: php
   :linenos:

   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zendservice.amazon.itemsearch.example.responsegroup:

.. rubric:: Using the ResponseGroup Option

The *ResponseGroup* option is used to control the specific information that will be returned in the response.

.. code-block:: php
   :linenos:

   $amazon = new ZendService\Amazon\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array(
       'SearchIndex'   => 'Books',
       'Keywords'      => 'php',
       'ResponseGroup' => 'Small,ItemAttributes,Images,SalesRank,Reviews,' .
                          'EditorialReview,Similarities,ListmaniaLists'
       ));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

The ``itemSearch()`` method accepts a single array parameter for handling search options. For full details,
including a list of available options, please see the `relevant Amazon documentation`_

.. tip::

   The :ref:`ZendService\Amazon\Query <zendservice.amazon.query>` class is an easy to use wrapper around this
   method.

.. _zendservice.amazon.query:

Using the Alternative Query API
-------------------------------

.. _zendservice.amazon.query.introduction:

Introduction
^^^^^^^^^^^^

``ZendService\Amazon\Query`` provides an alternative *API* for using the Amazon Web Service. The alternative *API*
uses the Fluent Interface pattern. That is, all calls can be made using chained method calls. (e.g.,
*$obj->method()->method2($arg)*)

The ``ZendService\Amazon\Query`` *API* uses overloading to easily set up an item search and then allows you to
search based upon the criteria specified. Each of the options is provided as a method call, and each method's
argument corresponds to the named option's value:

.. _zendservice.amazon.query.introduction.example.basic:

.. rubric:: Search Amazon Using the Alternative Query API

In this example, the alternative query *API* is used as a fluent interface to specify options and their respective
values:

.. code-block:: php
   :linenos:

   $query = new ZendService\Amazon\Query('MY_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $query->Category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

This sets the option *Category* to "Books" and *Keywords* to "PHP".

For more information on the available options, please refer to the `relevant Amazon documentation`_.

.. _zendservice.amazon.classes:

ZendService\\Amazon Classes
---------------------------

The following classes are all returned by :ref:`ZendService\Amazon\Amazon::itemLookup() <zendservice.amazon.itemlookup>`
and :ref:`ZendService\Amazon\Amazon::itemSearch() <zendservice.amazon.itemsearch>`:



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

ZendService\\Amazon\\Item
^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Amazon\Item`` is the class type used to represent an Amazon item returned by the web service. It
encompasses all of the items attributes, including title, description, reviews, etc.

.. _zendservice.amazon.classes.item.asxml:

ZendService\\Amazon\\Item::asXML()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

string:``asXML()``


Return the original *XML* for the item

.. _zendservice.amazon.classes.item.properties:

Properties
^^^^^^^^^^

``ZendService\Amazon\Item`` has a number of properties directly related to their standard Amazon *API*
counterparts.

.. _zendservice.amazon.classes.item.properties.table-1:

.. table:: ZendService\Amazon\Item Properties

   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |Name            |Type                        |Description                                                                                |
   +================+============================+===========================================================================================+
   |ASIN            |string                      |Amazon Item ID                                                                             |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |DetailPageURL   |string                      |URL to the Items Details Page                                                              |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |SalesRank       |int                         |Sales Rank for the Item                                                                    |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |SmallImage      |ZendService\Amazon\Image    |Small Image of the Item                                                                    |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |MediumImage     |ZendService\Amazon\Image    |Medium Image of the Item                                                                   |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |LargeImage      |ZendService\Amazon\Image    |Large Image of the Item                                                                    |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |Subjects        |array                       |Item Subjects                                                                              |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |Offers          |ZendService\Amazon\OfferSet |Offer Summary and Offers for the Item                                                      |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |CustomerReviews |array                       |Customer reviews represented as an array of ZendService\Amazon\CustomerReview objects      |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |EditorialReviews|array                       |Editorial reviews represented as an array of ZendService\Amazon\EditorialReview objects    |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |SimilarProducts |array                       |Similar Products represented as an array of ZendService\Amazon\SimilarProduct objects      |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |Accessories     |array                       |Accessories for the item represented as an array of ZendService\Amazon\Accessories objects |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |Tracks          |array                       |An array of track numbers and names for Music CDs and DVDs                                 |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |ListmaniaLists  |array                       |Item related Listmania Lists as an array of ZendService\Amazon\ListmaniaList objects       |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+
   |PromotionalTag  |string                      |Item Promotional Tag                                                                       |
   +----------------+----------------------------+-------------------------------------------------------------------------------------------+

:ref:`Back to Class List <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.image:

ZendService\\Amazon\\Image
^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Amazon\Image`` represents a remote Image for a product.

.. _zendservice.amazon.classes.image.properties:

Properties
^^^^^^^^^^

.. _zendservice.amazon.classes.image.properties.table-1:

.. table:: ZendService\Amazon\Image Properties

   +------+------------+---------------------------------+
   |Name  |Type        |Description                      |
   +======+============+=================================+
   |Url   |Zend\Uri\Uri|Remote URL for the Image         |
   +------+------------+---------------------------------+
   |Height|int         |The Height of the image in pixels|
   +------+------------+---------------------------------+
   |Width |int         |The Width of the image in pixels |
   +------+------------+---------------------------------+

:ref:`Back to Class List <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.resultset:

ZendService\\Amazon\\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Amazon\ResultSet`` objects are returned by :ref:`ZendService\Amazon\Amazon::itemSearch()
<zendservice.amazon.itemsearch>` and allow you to easily handle the multiple results returned.

.. note::

   **SeekableIterator**

   Implements the *SeekableIterator* for easy iteration (e.g. using *foreach*), as well as direct access to a
   specific result using ``seek()``.

.. _zendservice.amazon.classes.resultset.totalresults:

ZendService\\Amazon\\ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``
Returns the total number of results returned by the search

:ref:`Back to Class List <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.offerset:

ZendService\\Amazon\\OfferSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each result returned by :ref:`ZendService\Amazon\Amazon::itemSearch() <zendservice.amazon.itemsearch>` and
:ref:`ZendService\Amazon\Amazon::itemLookup() <zendservice.amazon.itemlookup>` contains a
``ZendService\Amazon\OfferSet`` object through which pricing information for the item can be retrieved.

.. _zendservice.amazon.classes.offerset.parameters:

Properties
^^^^^^^^^^

.. _zendservice.amazon.classes.offerset.parameters.table-1:

.. table:: ZendService\Amazon\OfferSet Properties

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
   |Offers                |array |An array of ZendService\Amazon\Offer objects.                 |
   +----------------------+------+--------------------------------------------------------------+

:ref:`Back to Class List <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.offer:

ZendService\\Amazon\\Offer
^^^^^^^^^^^^^^^^^^^^^^^^^^

Each offer for an item is returned as an ``ZendService\Amazon\Offer`` object.

.. _zendservice.amazon.classes.offer.properties:

ZendService\\Amazon\\Offer Properties
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zendservice.amazon.classes.offer.properties.table-1:

.. table:: Properties

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

:ref:`Back to Class List <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.similarproduct:

ZendService\\Amazon\\SimilarProduct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When searching for items, Amazon also returns a list of similar products that the searcher may find to their
liking. Each of these is returned as a ``ZendService\Amazon\SimilarProduct`` object.

Each object contains the information to allow you to make sub-sequent requests to get the full information on the
item.

.. _zendservice.amazon.classes.similarproduct.properties:

Properties
^^^^^^^^^^

.. _zendservice.amazon.classes.similarproduct.properties.table-1:

.. table:: ZendService\Amazon\SimilarProduct Properties

   +-----+------+--------------------------------+
   |Name |Type  |Description                     |
   +=====+======+================================+
   |ASIN |string|Products Amazon Unique ID (ASIN)|
   +-----+------+--------------------------------+
   |Title|string|Products Title                  |
   +-----+------+--------------------------------+

:ref:`Back to Class List <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.accessories:

ZendService\\Amazon\\Accessories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Accessories for the returned item are represented as ``ZendService\Amazon\Accessories`` objects

.. _zendservice.amazon.classes.accessories.properties:

Properties
^^^^^^^^^^

.. _zendservice.amazon.classes.accessories.properties.table-1:

.. table:: ZendService\Amazon\Accessories Properties

   +-----+------+--------------------------------+
   |Name |Type  |Description                     |
   +=====+======+================================+
   |ASIN |string|Products Amazon Unique ID (ASIN)|
   +-----+------+--------------------------------+
   |Title|string|Products Title                  |
   +-----+------+--------------------------------+

:ref:`Back to Class List <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.customerreview:

ZendService\\Amazon\\CustomerReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each Customer Review is returned as a ``ZendService\Amazon\CustomerReview`` object.

.. _zendservice.amazon.classes.customerreview.properties:

Properties
^^^^^^^^^^

.. _zendservice.amazon.classes.customerreview.properties.table-1:

.. table:: ZendService\Amazon\CustomerReview Properties

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

:ref:`Back to Class List <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.editorialreview:

ZendService\\Amazon\\EditorialReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each items Editorial Reviews are returned as a ``ZendService\Amazon\EditorialReview`` object

.. _zendservice.amazon.classes.editorialreview.properties:

Properties
^^^^^^^^^^

.. _zendservice.amazon.classes.editorialreview.properties.table-1:

.. table:: ZendService\Amazon\EditorialReview Properties

   +-------+------+------------------------------+
   |Name   |Type  |Description                   |
   +=======+======+==============================+
   |Source |string|Source of the Editorial Review|
   +-------+------+------------------------------+
   |Content|string|Review Content                |
   +-------+------+------------------------------+

:ref:`Back to Class List <zendservice.amazon.classes>`

.. _zendservice.amazon.classes.listmania:

ZendService\\Amazon\\Listmania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each results List Mania List items are returned as ``ZendService\Amazon\Listmania`` objects.

.. _zendservice.amazon.classes.listmania.properties:

Properties
^^^^^^^^^^

.. _zendservice.amazon.classes.listmania.properties.table-1:

.. table:: ZendService\Amazon\Listmania Properties

   +--------+------+-----------+
   |Name    |Type  |Description|
   +========+======+===========+
   |ListId  |string|List ID    |
   +--------+------+-----------+
   |ListName|string|List Name  |
   +--------+------+-----------+

:ref:`Back to Class List <zendservice.amazon.classes>`



.. _`Amazon Web Services`: http://aws.amazon.com/
.. _`relevant Amazon documentation`: http://www.amazon.com/gp/aws/sdk/main.html/102-9041115-9057709?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation