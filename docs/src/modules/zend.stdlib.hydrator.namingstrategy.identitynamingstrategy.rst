.. _zend.stdlib.hydrator.namingstrategy.identitynamingstrategy:

IdentityNamingStrategy
======================

``Zend\Stdlib\Hydrator\NamingStrategy\IdentityNamingStrategy`` Will use the key it is given for hydration and extraction.

Example Usage
-------------

.. code:: php

    <?php
    $namingStrategy = new \Zend\Stdlib\Hydrator\NamingStrategy\IdentityNamingStrategy();
    echo $namingStrategy->hydrate('foo'); // outputs: foo
    echo $namingStrategy->extract('bar'); // outputs: bar
    ?>

This strategy can be used in hydrators as well:

.. code:: php

    <?php
    class Foo {
        public $foo;
    }

    $namingStrategy = new \Zend\Stdlib\Hydrator\NamingStrategy\IdentityNamingStrategy();
    $hydrator = new \Zend\Stdlib\Hydrator\ObjectProperty();
    $hydrator->setNamingStrategy($namingStrategy);

    $foo = new Foo();
    $hydrator->hydrate(['foo' => 123],$foo);

    print_r($foo); // Foo Object ( [foo] => 123 )
    print_r($hydrator->extract($foo)); // Array ( [foo] => 123 )
    ?>