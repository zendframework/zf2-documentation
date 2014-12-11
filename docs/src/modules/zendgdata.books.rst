.. _zendgdata.books:

Using the Book Search Data API
==============================

The Google Book Search Data *API* allows client applications to view and update Book Search content in the form of
Google Data *API* feeds.

Your client application can use the Book Search Data *API* to issue full-text searches for books and to retrieve
standard book information, ratings, and reviews. You can also access individual users'`library collections and
public reviews`_. Finally, your application can submit authenticated requests to enable users to create and modify
library collections, ratings, labels, reviews, and other account-specific entities.

For more information on the Book Search Data *API*, please refer to the official `PHP Developer's Guide`_ on
code.google.com.

.. _zendgdata.books.authentication:

Authenticating to the Book Search service
-----------------------------------------

You can access both public and private feeds using the Book Search Data *API*. Public feeds don't require any
authentication, but they are read-only. If you want to modify user libraries, submit reviews or ratings, or add
labels, then your client needs to authenticate before requesting private feeds. It can authenticate using either of
two approaches: AuthSub proxy authentication or ClientLogin username/password authentication. Please refer to the
`Authentication section in the PHP Developer's Guide`_ for more detail.

.. _zendgdata.books.searching_for_books:

Searching for books
-------------------

The Book Search Data *API* provides a number of feeds that list collections of books.

The most common action is to retrieve a list of books that match a search query. To do so you create a
``VolumeQuery`` object and pass it to the ``Books::getVolumeFeed()`` method.

For example, to perform a keyword query, with a filter on viewability to restrict the results to partial or full
view books, use the ``setMinViewability()`` and ``setQuery()`` methods of the ``VolumeQuery`` object. The following
code snippet prints the title and viewability of all volumes whose metadata or text matches the query term
"domino":

.. code-block:: php
   :linenos:

   $books = new ZendGData\Books();
   $query = $books->newVolumeQuery();

   $query->setQuery('domino');
   $query->setMinViewability('partial_view');

   $feed = $books->getVolumeFeed($query);

   foreach ($feed as $entry) {
       echo $entry->getVolumeId();
       echo $entry->getTitle();
       echo $entry->getViewability();
   }

The ``Query`` class, and subclasses like ``VolumeQuery``, are responsible for constructing feed *URL*\ s. The
VolumeQuery shown above constructs a *URL* equivalent to the following:

.. code-block:: php
   :linenos:

   http://www.google.com/books/feeds/volumes?q=keyword&min-viewability=partial

Note: Since Book Search results are public, you can issue a Book Search query without authentication.

Here are some of the most common ``VolumeQuery`` methods for setting search parameters:

``setQuery()``: Specifies a search query term. Book Search searches all book metadata and full text for books
matching the term. Book metadata includes titles, keywords, descriptions, author names, and subjects. Note that any
spaces, quotes or other punctuation in the parameter value must be *URL*-escaped (Use a plus (**+**) for a space).
To search for an exact phrase, enclose the phrase in quotation marks. For example, to search for books matching the
phrase "spy plane", set the ``q`` parameter to ``%22spy+plane%22``. You can also use any of the `advanced search
operators`_ supported by Book Search. For example, ``jane+austen+-inauthor:austen`` returns matches that mention
(but are not authored by) Jane Austen.

``setStartIndex()``: Specifies the index of the first matching result that should be included in the result set.
This parameter uses a one-based index, meaning the first result is 1, the second result is 2 and so forth. This
parameter works in conjunction with the max-results parameter to determine which results to return. For example, to
request the third set of 10 results—results 21-30—set the ``start-index`` parameter to **21** and the
max-results parameter to **10**. Note: This isn't a general cursoring mechanism. If you first send a query with
``?start-index=1&max-results=10`` and then send another query with ``?start-index=11&max-results=10``, the service
cannot guarantee that the results are equivalent to ``?start-index=1&max-results=20``, because insertions and
deletions could have taken place in between the two queries.

``setMaxResults()``: Specifies the maximum number of results that should be included in the result set. This
parameter works in conjunction with the start-index parameter to determine which results to return. The default
value of this parameter is **10** and the maximum value is **20**.

``setMinViewability()``: Allows you to filter the results according to the books'`viewability status`_. This
parameter accepts one of three values: **'none'** (the default, returning all matching books regardless of
viewability), **'partial_view'** (returning only books that the user can preview or view in their entirety), or
**'full_view'** (returning only books that the user can view in their entirety).

.. _zendgdata.books.partner_restrict:

Partner Co-Branded Search
^^^^^^^^^^^^^^^^^^^^^^^^^

Google Book Search provides `Co-Branded Search`_, which lets content partners provide full-text search of their
books from their own websites.

If you are a partner who wants to do Co-Branded Search using the Book Search Data *API*, you may do so by modifying
the feed *URL* above to point to your Co-Branded Search implementation. if, for example, a Co-Branded Search is
available at the following *URL*:

.. code-block:: php
   :linenos:

   http://www.google.com/books/p/PARTNER_COBRAND_ID?q=ball

then you can obtain the same results using the Book Search Data *API* at the following *URL*:

.. code-block:: php
   :linenos:

   http://www.google.com/books/feeds/p/PARTNER_COBRAND_ID/volumes?q=ball+-soccer

To specify an alternate *URL* when querying a volume feed, you can provide an extra parameter to
``newVolumeQuery()``

.. code-block:: php
   :linenos:

   $query =
       $books->newVolumeQuery('http://www.google.com/books/p/PARTNER_COBRAND_ID');

For additional information or support, visit our `Partner help center`_.

.. _zendgdata.books.community_features:

Using community features
------------------------

.. _zendgdata.books.adding_ratings:

Adding a rating
^^^^^^^^^^^^^^^

A user can add a rating to a book. Book Search uses a 1-5 rating system in which 1 is the lowest rating. Users
cannot update or delete ratings.

To add a rating, add a ``Rating`` object to a ``VolumeEntry`` and post it to the annotation feed. In the example
below, we start from an empty ``VolumeEntry`` object.

.. code-block:: php
   :linenos:

   $entry = new ZendGData\Books\VolumeEntry();
   $entry->setId(new ZendGData\App\Extension\Id(VOLUME_ID));
   $entry->setRating(new ZendGData\Extension\Rating(3, 1, 5, 1));
   $books->insertVolume($entry, ZendGData\Books::MY_ANNOTATION_FEED_URI);

.. _zendgdata.books.reviews:

Reviews
^^^^^^^

In addition to ratings, authenticated users can submit reviews or edit their reviews. For information on how to
request previously submitted reviews, see `Retrieving annotations`_.

.. _zendgdata.books.adding_review:

Adding a review
^^^^^^^^^^^^^^^

To add a review, add a ``Review`` object to a ``VolumeEntry`` and post it to the annotation feed. In the example
below, we start from an existing ``VolumeEntry`` object.

.. code-block:: php
   :linenos:

   $annotationUrl = $entry->getAnnotationLink()->href;
   $review        = new ZendGData\Books\Extension\Review();

   $review->setText("This book is amazing!");
   $entry->setReview($review);
   $books->insertVolume($entry, $annotationUrl);

.. _zendgdata.books.editing_review:

Editing a review
^^^^^^^^^^^^^^^^

To update an existing review, first you retrieve the review you want to update, then you modify it, and then you
submit it to the annotation feed.

.. code-block:: php
   :linenos:

   $entryUrl = $entry->getId()->getText();
   $review   = new ZendGData\Books\Extension\Review();

   $review->setText("This book is actually not that good!");
   $entry->setReview($review);
   $books->updateVolume($entry, $entryUrl);

.. _zendgdata.books.labels:

Labels
^^^^^^

You can use the Book Search Data *API* to label volumes with keywords. A user can submit, retrieve and modify
labels. See `Retrieving annotations`_ for how to read previously submitted labels.

.. _zendgdata.books.submitting_labels:

Submitting a set of labels
^^^^^^^^^^^^^^^^^^^^^^^^^^

To submit labels, add a ``Category`` object with the scheme ``LABELS_SCHEME`` to a ``VolumeEntry`` and post it to
the annotation feed.

.. code-block:: php
   :linenos:

   $annotationUrl = $entry->getAnnotationLink()->href;
   $category      = new ZendGData\App\Extension\Category(
       'rated',
       'http://schemas.google.com/books/2008/labels');
   $entry->setCategory(array($category));
   $books->insertVolume($entry, ZendGData\Books::MY_ANNOTATION_FEED_URI);

.. _zendgdata.books.retrieving_annotations:

Retrieving annotations: reviews, ratings, and labels
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can use the Book Search Data *API* to retrieve annotations submitted by a given user. Annotations include
reviews, ratings, and labels. To retrieve any user's annotations, you can send an unauthenticated request that
includes the user's user ID. To retrieve the authenticated user's annotations, use the value **me** as the user ID.

.. code-block:: php
   :linenos:

   $feed = $books->getVolumeFeed(
               'http://www.google.com/books/feeds/users/USER_ID/volumes');
   <i>(or)</i>
   $feed = $books->getUserAnnotationFeed();

   // print title(s) and rating value
   foreach ($feed as $entry) {
       foreach ($feed->getTitles() as $title) {
           echo $title;
       }
       if ($entry->getRating()) {
           echo 'Rating: ' . $entry->getRating()->getAverage();
       }
   }

For a list of the supported query parameters, see the `query parameters`_ section.

.. _zendgdata.books.deleting_annotations:

Deleting Annotations
^^^^^^^^^^^^^^^^^^^^

If you retrieved an annotation entry containing ratings, reviews, and/or labels, you can remove all annotations by
calling ``deleteVolume()`` on that entry.

.. code-block:: php
   :linenos:

   $books->deleteVolume($entry);

.. _zendgdata.books.sharing_with_my_library:

Book collections and My Library
-------------------------------

Google Book Search provides a number of user-specific book collections, each of which has its own feed.

The most important collection is the user's My Library, which represents the books the user would like to remember,
organize, and share with others. This is the collection the user sees when accessing his or her `My Library page`_.

.. _zendgdata.books.retrieving_books_in_library:

Retrieving books in a user's library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following sections describe how to retrieve a list of books from a user's library, with or without query
parameters.

You can query a Book Search public feed without authentication.

.. _zendgdata.books.retrieving_all_books_in_library:

Retrieving all books in a user's library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To retrieve the user's books, send a query to the My Library feed. To get the library of the authenticated user,
use **me** in place of ``USER_ID``.

.. code-block:: php
   :linenos:

   $feed = $books->getUserLibraryFeed();

Note: The feed may not contain all of the user's books, because there's a default limit on the number of results
returned. For more information, see the ``max-results`` query parameter in `Searching for books`_.

.. _zendgdata.books.retrieving_books_in_library_with_query:

Searching for books in a user's library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Just as you can `search across all books`_, you can do a full-text search over just the books in a user's library.
To do this, just set the appropriate parameters on the ``VolumeQuery`` object.

For example, the following query returns all the books in your library that contain the word "bear":

.. code-block:: php
   :linenos:

   $query = $books->newVolumeQuery(
       'http://www.google.com/books/feeds/users' .
       '/USER_ID/collections/library/volumes');
   $query->setQuery('bear');
   $feed = $books->getVolumeFeed($query);

For a list of the supported query parameters, see the `query parameters`_ section. In addition, you can search for
books that have been `labeled by the user`_:

.. code-block:: php
   :linenos:

   $query = $books->newVolumeQuery(
       'http://www.google.com/books/feeds/users/' .
       'USER_ID/collections/library/volumes');
   $query->setCategory(
   $query->setCategory('favorites');
   $feed = $books->getVolumeFeed($query);

.. _zendgdata.books.updating_library:

Updating books in a user's library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can use the Book Search Data *API* to add a book to, or remove a book from, a user's library. Ratings, reviews,
and labels are valid across all the collections of a user, and are thus edited using the annotation feed (see
`Using community features`_).

.. _zendgdata.books.library_book_add:

Adding a book to a library
^^^^^^^^^^^^^^^^^^^^^^^^^^

After authenticating, you can add books to the current user's library.

You can either create an entry from scratch if you know the volume ID, or insert an entry read from any feed.

The following example creates a new entry and adds it to the library:

.. code-block:: php
   :linenos:

   $entry = new ZendGData\Books\VolumeEntry();
   $entry->setId(new ZendGData\App\Extension\Id(VOLUME_ID));
   $books->insertVolume(
       $entry,
       ZendGData\Books::MY_LIBRARY_FEED_URI
   );

The following example adds an existing ``VolumeEntry`` object to the library:

.. code-block:: php
   :linenos:

   $books->insertVolume(
       $entry,
       ZendGData\Books::MY_LIBRARY_FEED_URI
   );

.. _zendgdata.books.library_book_remove:

Removing a book from a library
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To remove a book from a user's library, call ``deleteVolume()`` on the ``VolumeEntry`` object.

.. code-block:: php
   :linenos:

   $books->deleteVolume($entry);



.. _`library collections and public reviews`: http://books.google.com/googlebooks/mylibrary/
.. _`PHP Developer's Guide`: http://code.google.com/apis/books/gdata/developers_guide_php.html
.. _`Authentication section in the PHP Developer's Guide`: http://code.google.com/apis/books/gdata/developers_guide_php.html#Authentication
.. _`advanced search operators`: http://books.google.com/advanced_book_search
.. _`viewability status`: http://code.google.com/apis/books/docs/dynamic-links.html#terminology
.. _`Co-Branded Search`: http://books.google.com/support/partner/bin/answer.py?hl=en&answer=65113
.. _`Partner help center`: http://books.google.com/support/partner/
.. _`Retrieving annotations`: #ZendGData.books.retrieving_annotations
.. _`query parameters`: #ZendGData.books.query_pParameters
.. _`My Library page`: http://books.google.com/books?op=library
.. _`Searching for books`: #ZendGData.books.searching_for_books
.. _`search across all books`: #ZendGData.books.searching_for_books
.. _`labeled by the user`: #ZendGData.books.labels
.. _`Using community features`: #ZendGData.books.community_features
