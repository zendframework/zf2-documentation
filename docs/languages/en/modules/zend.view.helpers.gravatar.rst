.. _zend.view.helpers.initial.gravatar:

Gravatar Helper
===============

.. _zend.view.helpers.initial.gravatar.introduction:

Introduction
------------

The ``Gravatar`` helper is useful for render image html markup using gravatar.com service.

.. _zend.view.helpers.initial.gravatar.basic-usage:

Basic Usage
-----------

You can use ``Gravatar`` helper wherever you want in .phtml view files as in this example:

.. code-block:: php
	:linenos:

	//This could be inside any of your .phtml file
	echo $this->gravatar('email@example.com')->getImgTag();

The first (and only in this example) argument passed to ``Gravatar`` helper is an e-mail for which you want grab
image from gravatar.com. For convenience this e-mail will be automatically hashed with md5 algorithm.

This will render html as below:

.. code-block:: html

	<img src="http://www.gravatar.com/avatar/5658ffccee7f0ebfda2b226238b1eb6e?s=80&d=mm&r=g">

As you can see helper already puts some defaults to url for you.

Custom Settings
---------------

You can customize request for gravatar.com image simply by using helper setters:

.. code-block:: php
	:linenos:
	
	$gravatar = $this->gravatar();
	$gravatar->setEmail('email@example.com') //Sets email if you didn't pass one in helper invocation
		->setImgSize(40); //Sets image size which gravatar.com return
		->setDefaultImg(\Zend\View\Helper\Gravatar::DEFAULT_MM); //Sets default returned image
		->setRating(\Zend\View\Helper\Gravatar::RATING_G) //Sets rating for avatar
		->setSecure(true); //Sets for using https instead of http in image source
	echo $gravatar->getImgTag();

or you can use array with following keys:

.. code-block:: php
	:linenos:

	$settings = array(
		'img_size'    => 40,
        	'default_img' => \Zend\View\Helper\Gravatar::DEFAULT_MM,
        	'rating'      => \Zend\View\Helper\Gravatar::RATING_G,
        	'secure'      => null,
	);
	$email = 'email@example.com';
	echo $this->gravatar($email,$settings)->getImgTag();

Passing ``null`` to ``secure`` setting will cause that ssl or non-ssl will be chosen same as current request
in your application.
