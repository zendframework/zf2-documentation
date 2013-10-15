.. _zendgdata.introduction:

Introduction
============

Google Data *API*\ s provide programmatic interface to some of Google's online services. The Google data Protocol
is based upon the `Atom Publishing Protocol`_ and allows client applications to retrieve data matching queries,
post data, update data and delete data using standard *HTTP* and the Atom syndication formation. The ``ZendGData``
component is a *PHP* 5 interface for accessing Google Data from *PHP*. The ``ZendGData`` component also supports
accessing other services implementing the Atom Publishing Protocol.

See http://code.google.com/apis/gdata/ for more information about Google Data *API*.

The services that are accessible by ``ZendGData`` include the following:



   - :ref:`Google Calendar <zendgdata.calendar>` is a popular online calendar application.

   - :ref:`Google Spreadsheets <zendgdata.spreadsheets>` provides an online collaborative spreadsheets tool which
     can be used as a simple data store for your applications.

   - :ref:`Google Documents List <zendgdata.docs>` provides an online list of all spreadsheets, word processing
     documents, and presentations stored in a Google account.

   - :ref:`Google Provisioning <zendgdata.gapps>` provides the ability to create, retrieve, update, and delete
     user accounts, nicknames, groups, and email lists on a Google Apps hosted domain.

   - :ref:`YouTube <zendgdata.youtube>` provides the ability to search and retrieve videos, comments, favorites,
     subscriptions, user profiles and more.

   - :ref:`Picasa Web Albums <zendgdata.photos>` provides an online photo sharing application.

   - :ref:`Google Analytics <zendgdata.analytics>` is a visitor statistics application.

   - `Google Blogger`_ is a popular Internet provider of "push-button publishing" and syndication.

   - Google CodeSearch allows you to search public source code from many projects.

   - Google Notebook allows you to view public Notebook content.



.. note::

   **Unsupported services**

   ``ZendGData`` does not provide an interface to any other Google service, such as Search, Gmail, Translation, or
   Maps. Only services that support the Google Data *API* are supported.

.. _zendgdata.introduction.structure:

Structure of ZendGData
-----------------------

``ZendGData`` is composed of several types of classes:



   - Service classes - inheriting from ``ZendGData\App``. These also include other classes such as ``ZendGData``,
     ``ZendGData\Spreadsheets``, etc. These classes enable interacting with APP or GData services and provide the
     ability to retrieve feeds, retrieve entries, post entries, update entries and delete entries.

   - Query classes - inheriting from ``ZendGData\Query``. These also include other classes for specific services,
     such as ``ZendGData\Spreadsheets\ListQuery`` and ``ZendGData\Spreadsheets\CellQuery``. Query classes provide
     methods used to construct a query for data to be retrieved from GData services. Methods include getters and
     setters like ``setUpdatedMin()``, ``setStartIndex()``, and ``getPublishedMin()``. The query classes also have
     a method to generate a *URL* representing the constructed query --``getQueryUrl()``. Alternatively, the query
     string component of the *URL* can be retrieved used the ``getQueryString()`` method.

   - Feed classes - inheriting from ``ZendGData\App\Feed``. These also include other classes such as
     ``ZendGData\Feed``, ``ZendGData\Spreadsheets\SpreadsheetFeed``, and ``ZendGData\Spreadsheets\ListFeed``.
     These classes represent feeds of entries retrieved from services. They are primarily used to retrieve data
     returned from services.

   - Entry classes - inheriting from ``ZendGData\App\Entry``. These also include other classes such as
     ``ZendGData\Entry``, and ``ZendGData\Spreadsheets\ListEntry``. These classes represent entries retrieved
     from services or used for constructing data to send to services. In addition to being able to set the
     properties of an entry (such as the spreadsheet cell value), you can use an entry object to send update or
     delete requests to a service. For example, you can call ``$entry->save()`` to save changes made to an entry
     back to service from which the entry initiated, or ``$entry->delete()`` to delete an entry from the server.

   - Other Data model classes - inheriting from ``ZendGData\App\Extension``. These include classes such as
     ``ZendGData\App\Extension\Title`` (representing the atom:title *XML* element), ``ZendGData\Extension\When``
     (representing the gd:when *XML* element used by the GData Event "Kind"), and ``ZendGData\Extension\Cell``
     (representing the gs:cell *XML* element used by Google Spreadsheets). These classes are used purely to store
     the data retrieved back from services and for constructing data to be sent to services. These include getters
     and setters such as ``setText()`` to set the child text node of an element, ``getText()`` to retrieve the text
     node of an element, ``getStartTime()`` to retrieve the start time attribute of a When element, and other
     similar methods. The data model classes also include methods such as ``getDOM()`` to retrieve a DOM
     representation of the element and all children and ``transferFromDOM()`` to construct a data model
     representation of a DOM tree.



.. _zendgdata.introduction.services:

Interacting with Google Services
--------------------------------

Google data services are based upon the Atom Publishing Protocol (APP) and the Atom syndication format. To interact
with APP or Google services using the ``ZendGData`` component, you need to use the service classes such as
``ZendGData\App``, ``ZendGData``, ``ZendGData\Spreadsheets``, etc. These service classes provide methods to
retrieve data from services as feeds, insert new entries into feeds, update entries, and delete entries.

Note: A full example of working with ``ZendGData`` is available in the ``demos/Zend/Gdata`` directory. This
example is runnable from the command-line, but the methods contained within are easily portable to a web
application.

.. _zendgdata.introduction.magicfactory:

Obtaining instances of ZendGData classes
-----------------------------------------

The Zend Framework naming standards require that all classes be named based upon the directory structure in which
they are located. For instance, extensions related to Spreadsheets are stored in:
``Zend/Gdata/Spreadsheets/Extension/...`` and, as a result of this, are named
``ZendGData\Spreadsheets\Extension\...``. This causes a lot of typing if you're trying to construct a new instance
of a spreadsheet cell element!

We've implemented a magic factory method in all service classes (such as ``ZendGData\App``, ``ZendGData``,
``ZendGData\Spreadsheets``) that should make constructing new instances of data model, query and other classes
much easier. This magic factory is implemented by using the magic ``__call()`` method to intercept all attempts to
call ``$service->newXXX(arg1, arg2, ...)``. Based off the value of XXX, a search is performed in all registered
'packages' for the desired class. Here's some examples:

.. code-block:: php
   :linenos:

   $ss = new ZendGData\Spreadsheets();

   // creates a ZendGData\App\Spreadsheets\CellEntry
   $entry = $ss->newCellEntry();

   // creates a ZendGData\App\Spreadsheets\Extension\Cell
   $cell = $ss->newCell();
   $cell->setText('My cell value');
   $cell->setRow('1');
   $cell->setColumn('3');
   $entry->cell = $cell;

   // ... $entry can then be used to send an update to a Google Spreadsheet

Each service class in the inheritance tree is responsible for registering the appropriate 'packages' (directories)
which are to be searched when calling the magic factory method.

.. _zendgdata.introduction.authentication:

Google Data Client Authentication
---------------------------------

Most Google Data services require client applications to authenticate against the Google server before accessing
private data, or saving or deleting data. There are two implementations of authentication for Google Data:
:ref:`AuthSub <zendgdata.authsub>` and :ref:`ClientLogin <zendgdata.clientlogin>`. ``ZendGData`` offers class
interfaces for both of these methods.

Most other types of queries against Google Data services do not require authentication.

.. _zendgdata.introduction.dependencies:

Dependencies
------------

``ZendGData`` makes use of :ref:`Zend\Http\Client <zend.http.client>` to send requests to google.com and fetch
results. The response to most Google Data requests is returned as a subclass of the ``ZendGData\App\Feed`` or
``ZendGData\App\Entry`` classes.

``ZendGData`` assumes your *PHP* application is running on a host that has a direct connection to the Internet.
The ``ZendGData`` client operates by contacting Google Data servers.

.. _zendgdata.introduction.creation:

Creating a new Gdata client
---------------------------

Create a new object of class ``ZendGData\App``, ``ZendGData``, or one of the subclasses available that offer
helper methods for service-specific behavior.

The single optional parameter to the ``ZendGData\App`` constructor is an instance of :ref:`Zend\Http\Client
<zend.http.client>`. If you don't pass this parameter, ``ZendGData`` creates a default ``Zend\Http\Client``
object, which will not have associated credentials to access private feeds. Specifying the ``Zend\Http\Client``
object also allows you to pass configuration options to that client object.

.. code-block:: php
   :linenos:

   $client = new Zend\Http\Client();
   $client->setConfig( ...options... );

   $gdata = new ZendGData\Gdata($client);

Beginning with Zend Framework 1.7, support has been added for protocol versioning. This allows the client and
server to support new features while maintaining backwards compatibility. While most services will manage this for
you, if you create a ``ZendGData`` instance directly (as opposed to one of its subclasses), you may need to
specify the desired protocol version to access certain server functionality.

.. code-block:: php
   :linenos:

   $client = new Zend\Http\Client();
   $client->setConfig( ...options... );

   $gdata = new ZendGData\Gdata($client);
   $gdata->setMajorProtocolVersion(2);
   $gdata->setMinorProtocolVersion(null);

Also see the sections on authentication for methods to create an authenticated ``Zend\Http\Client`` object.

.. _zendgdata.introduction.parameters:

Common Query Parameters
-----------------------

You can specify parameters to customize queries with ``ZendGData``. Query parameters are specified using
subclasses of ``ZendGData\Query``. The ``ZendGData\Query`` class includes methods to set all query parameters
used throughout GData services. Individual services, such as Spreadsheets, also provide query classes to defined
parameters which are custom to the particular service and feeds. Spreadsheets includes a CellQuery class to query
the Cell Feed and a ListQuery class to query the List Feed, as different query parameters are applicable to each of
those feed types. The GData-wide parameters are described below.



- The ``q`` parameter specifies a full-text query. The value of the parameter is a string.

  Set this parameter with the ``setQuery()`` function.

- The ``alt`` parameter specifies the feed type. The value of the parameter can be ``atom``, ``rss``, ``json``, or
  ``json-in-script``. If you don't specify this parameter, the default feed type is ``atom``. NOTE: Only the output
  of the atom feed format can be processed using ``ZendGData``. The ``Zend\Http\Client`` could be used to retrieve
  feeds in other formats, using query *URL*\ s generated by the ``ZendGData\Query`` class and its subclasses.

  Set this parameter with the ``setAlt()`` function.

- The ``maxResults`` parameter limits the number of entries in the feed. The value of the parameter is an integer.
  The number of entries returned in the feed will not exceed this value.

  Set this parameter with the ``setMaxResults()`` function.

- The ``startIndex`` parameter specifies the ordinal number of the first entry returned in the feed. Entries before
  this number are skipped.

  Set this parameter with the ``setStartIndex()`` function.

- The ``updatedMin`` and ``updatedMax`` parameters specify bounds on the entry date. If you specify a value for
  ``updatedMin``, no entries that were updated earlier than the date you specify are included in the feed. Likewise
  no entries updated after the date specified by ``updatedMax`` are included.

  You can use numeric timestamps, or a variety of date/time string representations as the value for these
  parameters.

  Set this parameter with the ``setUpdatedMin()`` and ``setUpdatedMax()`` functions.

There is a ``get*()`` function for each ``set*()`` function.

.. code-block:: php
   :linenos:

   $query = new ZendGData\Query();
   $query->setMaxResults(10);
   echo $query->getMaxResults();   // returns 10

The ``ZendGData`` class also implements "magic" getter and setter methods, so you can use the name of the
parameter as a virtual member of the class.

.. code-block:: php
   :linenos:

   $query = new ZendGData\Query();
   $query->maxResults = 10;
   echo $query->maxResults;        // returns 10

You can clear all parameters with the ``resetParameters()`` function. This is useful to do if you reuse a
``ZendGData`` object for multiple queries.

.. code-block:: php
   :linenos:

   $query = new ZendGData\Query();
   $query->maxResults = 10;
   // ...get feed...

   $query->resetParameters();      // clears all parameters
   // ...get a different feed...

.. _zendgdata.introduction.getfeed:

Fetching a Feed
---------------

Use the ``getFeed()`` function to retrieve a feed from a specified *URI*. This function returns an instance of
class specified as the second argument to getFeed, which defaults to ``ZendGData\Feed``.

.. code-block:: php
   :linenos:

   $gdata = new ZendGData\Gdata();
   $query = new ZendGData\Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $query->setMaxResults(10);
   $feed = $gdata->getFeed($query);

See later sections for special functions in each helper class for Google Data services. These functions help you to
get feeds from the *URI* that is appropriate for the respective service.

.. _zendgdata.introduction.paging:

Working with Multi-page Feeds
-----------------------------

When retrieving a feed that contains a large number of entries, the feed may be broken up into many smaller "pages"
of feeds. When this occurs, each page will contain a link to the next page in the series. This link can be accessed
by calling ``getLink('next')``. The following example shows how to retrieve the next page of a feed:

.. code-block:: php
   :linenos:

   function getNextPage($feed) {
       $nextURL = $feed->getLink('next');
       if ($nextURL !== null) {
           return $gdata->getFeed($nextURL);
       } else {
           return null;
       }
   }

If you would prefer not to work with pages in your application, pass the first page of the feed into
``ZendGData\App::retrieveAllEntriesForFeed()``, which will consolidate all entries from each page into a single
feed. This example shows how to use this function:

.. code-block:: php
   :linenos:

   $gdata = new ZendGData\Gdata();
   $query = new ZendGData\Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $feed = $gdata->retrieveAllEntriesForFeed($gdata->getFeed($query));

Keep in mind when calling this function that it may take a long time to complete on large feeds. You may need to
increase *PHP*'s execution time limit by calling ``set_time_limit()``.

.. _zendgdata.introduction.usefeedentry:

Working with Data in Feeds and Entries
--------------------------------------

After retrieving a feed, you can read the data from the feed or the entries contained in the feed using either the
accessors defined in each of the data model classes or the magic accessors. Here's an example:

.. code-block:: php
   :linenos:

   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $gdata = new ZendGData\Gdata($client);
   $query = new ZendGData\Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $query->setMaxResults(10);
   $feed = $gdata->getFeed($query);
   foreach ($feed as $entry) {
       // using the magic accessor
       echo 'Title: ' . $entry->title->text;
       // using the defined accessors
       echo 'Content: ' . $entry->getContent()->getText();
   }

.. _zendgdata.introduction.updateentry:

Updating Entries
----------------

After retrieving an entry, you can update that entry and save changes back to the server. Here's an example:

.. code-block:: php
   :linenos:

   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $gdata = new ZendGData\Gdata($client);
   $query = new ZendGData\Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $query->setMaxResults(10);
   $feed = $gdata->getFeed($query);
   foreach ($feed as $entry) {
       // update the title to append 'NEW'
       echo 'Old Title: ' . $entry->title->text;
       $entry->title->text = $entry->title->text . ' NEW';

       // update the entry on the server
       $newEntry = $entry->save();
       echo 'New Title: ' . $newEntry->title->text;
   }

.. _zendgdata.introduction.post:

Posting Entries to Google Servers
---------------------------------

The ``ZendGData`` object has a function ``insertEntry()`` with which you can upload data to save new entries to
Google Data services.

You can use the data model classes for each service to construct the appropriate entry to post to Google's
services. The ``insertEntry()`` function will accept a child of ``ZendGData\App\Entry`` as data to post to the
service. The method returns a child of ``ZendGData\App\Entry`` which represents the state of the entry as it was
returned from the server.

Alternatively, you could construct the *XML* structure for an entry as a string and pass the string to the
``insertEntry()`` function.

.. code-block:: php
   :linenos:

   $gdata = new ZendGData\Gdata($authenticatedHttpClient);

   $entry = $gdata->newEntry();
   $entry->title = $gdata->newTitle('Playing football at the park');
   $content =
       $gdata->newContent('We will visit the park and play football');
   $content->setType('text');
   $entry->content = $content;

   $entryResult = $gdata->insertEntry($entry,
           'http://www.blogger.com/feeds/blogID/posts/default');

   echo 'The <id> of the resulting entry is: ' . $entryResult->id->text;

To post entries, you must be using an authenticated ``Zend\Http\Client`` that you created using the
``ZendGData\AuthSub`` or ``ZendGData\ClientLogin`` classes.

.. _zendgdata.introduction.delete:

Deleting Entries on Google Servers
----------------------------------

Option 1: The ``ZendGData`` object has a function ``delete()`` with which you can delete entries from Google Data
services. Pass the edit *URL* value from a feed entry to the ``delete()`` method.

Option 2: Alternatively, you can call ``$entry->delete()`` on an entry retrieved from a Google service.

.. code-block:: php
   :linenos:

   $gdata = new ZendGData\Gdata($authenticatedHttpClient);
   // a Google Data feed
   $feedUri = ...;
   $feed = $gdata->getFeed($feedUri);
   foreach ($feed as $feedEntry) {
       // Option 1 - delete the entry directly
       $feedEntry->delete();
       // Option 2 - delete the entry by passing the edit URL to
       // $gdata->delete()
       // $gdata->delete($feedEntry->getEditLink()->href);
   }

To delete entries, you must be using an authenticated ``Zend\Http\Client`` that you created using the
``ZendGData\AuthSub`` or ``ZendGData\ClientLogin`` classes.



.. _`Atom Publishing Protocol`: http://ietfreport.isoc.org/idref/draft-ietf-atompub-protocol/
.. _`Google Blogger`: http://code.google.com/apis/blogger/developers_guide_php.html
