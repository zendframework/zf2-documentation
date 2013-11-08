.. _zendservice.akismet:

ZendService\\Akismet
====================

.. _zendservice.akismet.introduction:

Introduction
------------

``ZendService\Akismet\Akismet`` provides a client for the `Akismet API`_. The Akismet service is used to determine if
incoming data is potentially spam. It also exposes methods for submitting data as known spam or as false positives
(ham). It was originally intended to help categorize and identify spam for Wordpress, but it can be used for any
type of data.

Akismet requires an *API* key for usage. You can get one by signing up for a `WordPress.com`_ account. You do not
need to activate a blog. Simply acquiring the account will provide you with the *API* key.

Akismet requires that all requests contain a *URL* to the resource for which data is being filtered. Because of
Akismet's origins in WordPress, this resource is called the blog *URL*. This value should be passed as the second
argument to the constructor, but may be reset at any time using the ``setBlogUrl()`` method, or overridden by
specifying a 'blog' key in the various method calls.

.. _zendservice.akismet.verifykey:

Verify an API key
-----------------

``ZendService\Akismet\Akismet::verifyKey($key)`` is used to verify that an Akismet *API* key is valid. In most cases, you
will not need to check, but if you need a sanity check, or to determine if a newly acquired key is active, you may
do so with this method.

.. code-block:: php
   :linenos:

   // Instantiate with the API key and a URL to the application or
   // resource being used
   $akismet = new ZendService\Akismet\Akismet($apiKey,
                                       'http://framework.zend.com/wiki/');
   if ($akismet->verifyKey($apiKey)) {
       echo "Key is valid.\n";
   } else {
       echo "Key is not valid\n";
   }

If called with no arguments, ``verifyKey()`` uses the *API* key provided to the constructor.

``verifyKey()`` implements Akismet's *verify-key* REST method.

.. _zendservice.akismet.isspam:

Check for spam
--------------

``ZendService\Akismet\Akismet::isSpam($data)`` is used to determine if the data provided is considered spam by Akismet. It
accepts an associative array as the sole argument. That array requires the following keys be set:

- *user_ip*, the IP address of the user submitting the data (not your IP address, but that of a user on your site).

- *user_agent*, the reported UserAgent string (browser and version) of the user submitting the data.

The following keys are also recognized specifically by the *API*:

- *blog*, the fully qualified *URL* to the resource or application. If not specified, the *URL* provided to the
  constructor will be used.

- *referrer*, the content of the HTTP_REFERER header at the time of submission. (Note spelling; it does not follow
  the header name.)

- *permalink*, the permalink location, if any, of the entry the data was submitted to.

- *comment_type*, the type of data provided. Values specified in the *API* include 'comment', 'trackback',
  'pingback', and an empty string (''), but it may be any value.

- *comment_author*, the name of the person submitting the data.

- *comment_author_email*, the email of the person submitting the data.

- *comment_author_url*, the *URL* or home page of the person submitting the data.

- *comment_content*, the actual data content submitted.

You may also submit any other environmental variables you feel might be a factor in determining if data is spam.
Akismet suggests the contents of the entire $_SERVER array.

The ``isSpam()`` method will return either ``TRUE`` or ``FALSE``, or throw an exception if the *API* key is
invalid.

.. _zendservice.akismet.isspam.example-1:

isSpam() Usage
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 ' . '(Windows; U; Windows NT ' .
                                 '5.2; en-GB; rv:1.8.1) Gecko/20061010 ' .
                                 'Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => 'John Doe',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "I'm not a spammer, honest!"
   );
   if ($akismet->isSpam($data)) {
       echo "Sorry, but we think you're a spammer.";
   } else {
       echo "Welcome to our site!";
   }

``isSpam()`` implements the *comment-check* Akismet *API* method.

.. _zendservice.akismet.submitspam:

Submitting known spam
---------------------

Spam data will occasionally get through the filter. If you discover spam that you feel should have been caught, you
can submit it to Akismet to help improve their filter.

``ZendService\Akismet\Akismet::submitSpam()`` takes the same data array as passed to ``isSpam()``, but does not return a
value. An exception will be raised if the *API* key used is invalid.

.. _zendservice.akismet.submitspam.example-1:

submitSpam() Usage
^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT 5.2;' .
                                 'en-GB; rv:1.8.1) Gecko/20061010 Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => 'John Doe',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "I'm not a spammer, honest!"
   );
   $akismet->submitSpam($data));

``submitSpam()`` implements the *submit-spam* Akismet *API* method.

.. _zendservice.akismet.submitham:

Submitting false positives (ham)
--------------------------------

Data will occasionally be trapped erroneously as spam by Akismet. For this reason, you should probably keep a log
of all data trapped as spam by Akismet and review it periodically. If you find such occurrences, you can submit the
data to Akismet as "ham", or a false positive (ham is good, spam is not).

``ZendService\Akismet\Akismet::submitHam()`` takes the same data array as passed to ``isSpam()`` or ``submitSpam()``, and,
like ``submitSpam()``, does not return a value. An exception will be raised if the *API* key used is invalid.

.. _zendservice.akismet.submitham.example-1:

submitHam() Usage
^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT 5.2;' .
                                 'en-GB; rv:1.8.1) Gecko/20061010 Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => 'John Doe',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "I'm not a spammer, honest!"
   );
   $akismet->submitHam($data));

``submitHam()`` implements the *submit-ham* Akismet *API* method.

.. _zendservice.akismet.accessors:

Zend-specific Methods
---------------------

While the Akismet *API* only specifies four methods, ``ZendService\Akismet\Akismet`` has several additional methods that
may be used for retrieving and modifying internal properties.

- ``getBlogUrl()`` and ``setBlogUrl()`` allow you to retrieve and modify the blog *URL* used in requests.

- ``getApiKey()`` and ``setApiKey()`` allow you to retrieve and modify the *API* key used in requests.

- ``getCharset()`` and ``setCharset()`` allow you to retrieve and modify the character set used to make the
  request.

- ``getPort()`` and ``setPort()`` allow you to retrieve and modify the *TCP* port used to make the request.

- ``getUserAgent()`` and ``setUserAgent()`` allow you to retrieve and modify the *HTTP* user agent used to make the
  request. Note: this is not the user_agent used in data submitted to the service, but rather the value provided in
  the *HTTP* User-Agent header when making a request to the service.

  The value used to set the user agent should be of the form *some user agent/version | Akismet/version*. The
  default is *Zend Framework/ZF-VERSION | Akismet/1.11*, where *ZF-VERSION* is the current Zend Framework version
  as stored in the ``Zend\Version\Version::VERSION`` constant.



.. _`Akismet API`: http://akismet.com/development/api/
.. _`WordPress.com`: http://wordpress.com/
