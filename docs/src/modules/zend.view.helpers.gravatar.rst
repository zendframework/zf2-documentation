.. _zend.view.helpers.initial.gravatar:

Gravatar Helper
===============

.. _zend.view.helpers.initial.gravatar.introduction:

Introduction
------------

The ``Gravatar`` helper is useful for rendering image HTML markup returned from the gravatar.com
service.

.. _zend.view.helpers.initial.gravatar.basic-usage:

Basic Usage
-----------

You can use the ``Gravatar`` helper wherever in view scripts per the following example:

.. code-block:: php
    :linenos:

    //This could be inside any of your .phtml file
    echo $this->gravatar('email@example.com')->getImgTag();

The first (and only, in this example) argument passed to the ``Gravatar`` helper is an e-mail for
which you want grab an avatar from gravatar.com. For convenience, this e-mail will be automatically
hashed via the md5 algorithm.

This will render the HTML below:

.. code-block:: html

    <img src="http://www.gravatar.com/avatar/5658ffccee7f0ebfda2b226238b1eb6e?s=80&d=mm&r=g">

As you can see, the helper already provides URL defaults for you.

.. _zend.view.helpers.initial.gravatar.custom-settings:

Custom Settings
---------------

You can customize the request for a gravatar.com image by using setter methods on the view helper:

.. code-block:: php
    :linenos:

    $gravatar = $this->gravatar();
    
    // Set the email instead of passing it via helper invocation
    $gravatar->setEmail('email@example.com');

    // Set the image size you want gravatar.com to return, in pixels
    $gravatar->setImgSize(40);

    // Set the default avatar image to use if gravatar.com does not find a match
    $gravatar->setDefaultImg( \Zend\View\Helper\Gravatar::DEFAULT_MM );

    // Set the avatar "rating" threshold (often used to omit NSFW avatars)
    $gravatar->setRating( \Zend\View\Helper\Gravatar::RATING_G );

    // Indicate that a secure URI should be used for the image source
    $gravatar->setSecure(true);

    // Render the <img> tag with the email you've set previously
    echo $gravatar->getImgTag();

Alternately, you can pass an array as the second argument on invocation, with the following keys:

.. code-block:: php
    :linenos:

    $settings = array(
        'img_size'    => 40,
        'default_img' => \Zend\View\Helper\Gravatar::DEFAULT_MM,
        'rating'      => \Zend\View\Helper\Gravatar::RATING_G,
        'secure'      => null,
    );
    $email = 'email@example.com';
    echo $this->gravatar($email, $settings);

.. note::

   Passing ``null`` for the ``secure`` setting will cause the view helper to choose a schema that
   matches the current request to your application. This is the default behavior.

As you can see in the above examples, there are predefined settings for the default image and rating. 

The Gravatar helper defines the following constants for ratings:

* ``RATING_G``
* ``RATING_PG``
* ``RATING_R``
* ``RATING_X``

The helper defines the following constants for the default image:
* ``DEFAULT_404``
* ``DEFAULT_MM``
* ``DEFAULT_IDENTICON``
* ``DEFAULT_MONSTERID``
* ``DEFAULT_WAVATAR``

You may also provide custom attributes for the generated ``img`` tag. To do this, pass an attributes
array to the ``setAttributes()`` method:

.. code-block:: php
    :linenos:

    $gravatar = $this->gravatar('email@example.com');

    // Suppose that I want to add the class attribute with a value of
    // "gravatarcls" to the rendered <img> tag:
    $attr = array(
        'class' => 'gravatarcls',
    );
    echo $gravatar->setAttributes($attr)->getImgTag(); 

Alternately, you can pass this array as the third argument during helper invocation:

.. code-block:: php
    :linenos:

    $email = 'email@example.com';
    $settings = array(
        'default_img' => \Zend\View\Helper\Gravatar::DEFAULT_MM,
    );
    $attr = array(
        'class' => 'gravatar-image',
        'id'    => 'gravatar',
    );

    echo $this->gravatar($email, $settings, $attr);
