.. _zend.di.configuration:

Zend\\Di Configuration
======================

Most of the configuration for both the setup of Definitions as well as the setup of the Instance Manager can be
attained by a configuration file. This file will produce an array (typically) and have a particular iterable
structure.

The top two keys are 'definition' and 'instance', each specifying values for respectively, definition setup and
instance manager setup.

The definition section expects the following information expressed as a PHP array:

.. code-block:: php
   :linenos:

   $config = array(
       'definition' => array(
           'compiler' => array(/* @todo compiler information */),
           'runtime'  => array(/* @todo runtime information */),
           'class' => array(
               'instantiator' => '', // the name of the instantiator, by default this is __construct
               'supertypes'   => array(), // an array of supertypes the class implements
               'methods'      => array(
                   'setSomeParameter' => array( // a method name
                       'parameterName' => array(
                           'name',       // string parameter name
                           'type',       // type or null
                           'is-required' // bool
                       )
                   )

               )
           )
       )
   );


