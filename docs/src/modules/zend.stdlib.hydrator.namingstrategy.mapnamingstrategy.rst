.. _zend.stdlib.hydrator.namingstrategy.mapnamingstrategy:

MapNamingStrategy
=================

``Zend\Stdlib\Hydrator\NamingStrategy\MapNamingStrategy`` Maps keys based on a given map. 

Example Usage
-------------

.. code:: php

    <?php
    $namingStrategy = new \Zend\Stdlib\Hydrator\NamingStrategy\MapNamingStrategy([
        'foo' => 'bar',
        'baz' => 'bash'
    ]);
    echo $namingStrategy->hydrate('foo'); // outputs: foo
    echo $namingStrategy->hydrate('baz'); // outputs: bash

    echo $namingStrategy->extract('bar'); // outputs: foo
    echo $namingStrategy->extract('bash'); // outputs: baz
    ?>

This strategy can be used in hydrators to dictate how keys should be mapped:

.. code:: php

    <?php
    class Foo {
        public $bar;
    }

    $namingStrategy = new \Zend\Stdlib\Hydrator\NamingStrategy\MapNamingStrategy([
        'foo' => 'bar',
        'baz' => 'bash'
    ]);
    $hydrator = new \Zend\Stdlib\Hydrator\ObjectProperty();
    $hydrator->setNamingStrategy($namingStrategy);

    $foo = new Foo();
    $hydrator->hydrate(['foo' => 123],$foo);

    print_r($foo); // Foo Object ( [bar] => 123 )
    print_r($hydrator->extract($foo)); // Array ( [foo] => 123 )
    ?>