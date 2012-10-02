.. _zend.feed.security:

Zend\\Feed and Security
=======================

.. _zend.feed.security.introduction:

Introduction
------------

As with any data coming from a source that is beyond the developer's control, special attention needs to be given
to securing, validating and filtering that data. Similar to data input to our application by users, data coming
from *RSS* and Atom feeds should also be considered unsafe and potentially dangerous, as it allows the delivery of
*HTML* and *xHTML* [#f1]_. Because data validation and filtration is out of ``Zend\Feed``'s scope, this task is 
left for implementation by the developer, by using libraries such as ``Zend\Escaper`` for escaping and `HTMLPurifier`_
for validating and filtering feed data.

Escaping and filtering of potentially insecure data is highly recommended before outputting it anywhere in our
application or before storing that data in some storage engine (be it a simple file, a database...).

.. _zend.feed.security.filtering:

Filtering data using HTMLPurifier
---------------------------------

Currently the best available library for filtering and validating *(x)HTML* data in PHP is `HTMLPurifier`_ and, as
such, is the recommended tool for this task. HTMLPurifier works by filtering out all *(x)HTML* from the data, except
for the tags and attributes specifically allowed in a whitelist, and by checking and fixing nesting of tags, ensuring
a standards-compliant output.

The following examples will show a basic usage of HTMLPurifier, but developers are urged to go through and read
`HTMLPurifier's documentation`_.

.. code-block:: php
    :linenos:

    // Setting HTMLPurifier's options
    $options = array(
        // Allow only paragraph tags
        // and anchor tags wit the href attribute
        array(
            'HTML.Allowed',
            'p,a[href]'
        ),
        // Format end output with Tidy
        array(
            'Output.TidyFormat',
            true
        ),
        // Assume XHTML 1.0 Strict Doctype
        array(
            'HTML.Doctype',
            'XHTML 1.0 Strict'
        ),
        // Disable cache, but see note after the example
        array(
            'Cache.DefinitionImpl',
            null
        )
    );

    // Configuring HTMLPurifier
    $config = HTMLPurifier_Config::createDefault();
    foreach ($options as $option) {
        $config->set($option[0], $option[1]);
    }

    // Creating a HTMLPurifier with it's config
    $purifier = new HTMLPurifier($config);

    // Fetch the RSS
    try {
       $rss = Zend\Feed\Reader\Reader::import('http://www.planet-php.net/rss/');
    } catch (Zend\Feed\Exception\Reader\RuntimeException $e) {
       // feed import failed
       echo "Exception caught importing feed: {$e->getMessage()}\n";
       exit;
    }

    // Initialize the channel data array
    // See that we're cleaning the description with HTMLPurifier
    $channel = array(
       'title'       => $rss->getTitle(),
       'link'        => $rss->getLink(),
       'description' => $purifier->purify($rss->getDescription()),
       'items'       => array()
    );

    // Loop over each channel item and store relevant data
    // See that we're cleaning the descriptions with HTMLPurifier
    foreach ($rss as $item) {
       $channel['items'][] = array(
           'title'       => $item->getTitle(),
           'link'        => $item->getLink(),
           'description' => $purifier->purify($item->getDescription())
       );
    }

.. note::

    HTMLPurifier is using the PHP `Tidy extension`_ to clean and repair the final output. If this extension is
    not available, it will silently fail but its availability has no impact on
    the library's security.

.. note::
    
    For the sake of this example, the HTMLPurifier's cache is disabled, but it is recommended to configure caching
    and use its standalone include file as it can improve the performance of HTMLPurifier substantially.

.. _zend.feed.security.escaping:

Escaping data using Zend\\Escaper
---------------------------------

To help prevent XSS attacks, Zend Framework has a new component ``Zend\Escaper``, which complies to the current
`OWASP recommendations`_, and as such, is the recommended tool for escaping HTML tags and attributes, Javascript,
CSS and URLs before outputing any potentially insecure data to the users.

.. code-block:: php
    :linenos:

    try {
        $rss = Zend\Feed\Reader\Reader::import('http://www.planet-php.net/rss/');
    } catch (Zend\Feed\Exception\Reader\RuntimeException $e) {
        // feed import failed
        echo "Exception caught importing feed: {$e->getMessage()}\n";
        exit;
    }

    // Validate all URIs
    $linkValidator = new Zend\Validator\Uri;
    $link = null;
    if ($linkValidator->isValid($rss->getLink())) {
        $link = $rss->getLink();
    }

    // Escaper used for escaping data
    $escaper = new Zend\Escaper\Escaper('utf-8');

    // Initialize the channel data array
    $channel = array(
        'title'       => $escaper->escapeHtml($rss->getTitle()),
        'link'        => $escaper->escapeHtml($link),
        'description' => $escaper->escapeHtml($rss->getDescription()),
        'items'       => array()
    );

    // Loop over each channel item and store relevant data
    foreach ($rss as $item) {
        $link = null;
        if ($linkValidator->isValid($rss->getLink())) {
            $link = $item->getLink();
        }
        $channel['items'][] = array(
            'title'       => $escaper->escapeHtml($item->getTitle()),
            'link'        => $escaper->escapeHtml($link),
            'description' => $escaper->escapeHtml($item->getDescription())
        );
    }

The feed data is now safe for output to HTML templates. You can, of course, skip escaping when simply storing the 
data persistently but remember to escape it on output later!

Of course, these are just basic examples, and cannot cover all possible scenarios that you, as a developer, can,
and most likely will, encounter. Your responsibility is to learn what libraries and tools are at your disposal,
and when and how to use them to secure your web applications.

.. rubric:: Footnotes

.. [#f1] http://tools.ietf.org/html/rfc4287#section-8.1

.. _`HTMLPurifier`: http://www.htmlpurifier.org/
.. _`HTMLPurifier's documentation`: http://www.htmlpurifier.org/docs
.. _`Tidy extension`: http://php.net/tidy 
.. _`OWASP recommendations`: https://www.owasp.org/index.php/XSS_Prevention_Cheat_Sheet

