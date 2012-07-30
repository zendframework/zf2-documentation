.. _zend.di.configuration:

Zend\\Di Configuration
======================

Most of the configuration for both the setup of Definitions as well as the setup of the Instance Manager can be
attained by a configuration file. This file will produce an array (typically) and have a particular iterable
structure.

The top two keys are 'definition' and 'instance', each specifying values for respectively, definition setup and
instance manager setup.

You can see an example of possible configurations here:

.. code-block:: php
   :linenos:

   $diConfig = array(
       'instance' => array(

           // list of aliases pointing to classes or other aliases
           'alias' => array(
               'alias_name' => 'Referenced\ClassName\Or\Alias',
           ),

           // preferred implementations for abstract types. Zend\Di will use those when an abstract type is requested
           'preference' => array(
               'My\Interface\Or\Abstract\Type' => 'instance_alias_or_class',
           ),

           // Configuration 'My\Class\Or\Alias'
           'My\Class\Or\Alias' => array(
                'parameters' => array(
                    // parameter values: non-scalar values will be treated as references to instances in the DIC itself
                    'parameterName' => 'instance_alias_or_class_or_value',
                ),

                // list of injections to be applied: methods compatible with the type of the injection will be called
                'injections' => array(
                    'injected_instance_alias_or_class',
                ),
           ),
       ),

       'definition' => array(
           'compiler' => array(/* @todo compiler information */),

           'runtime'  => array(/* @todo runtime information */),

           'class' => array(

               // following configurations allow to define how Zend\Di should interact with My\Class.
               'My\Class' => array(

                   // the name of the instantiator: may be a closure, a callback string or array.
                   // by default this is simply '__construct'
                   'instantiator' => '',

                   // an array of supertypes the class implements
                   'supertypes    => array(),

                   // list of methods implemented by the class
                   'methods'      => array(
                       'someMethodName' => array(
                           'firstParameterName' => array(
                               // type of the parameter: false for PHP internal types (int, string, array etc.), class
                               // or interface name otherwise
                               'type' => 'Parameter\Type',

                               // whether the parameter is required or optional
                               'required' => true,
                           ),
                       ),
                   ),
               ),
           ),
       ),
   );

You will probably not need all of these configuration keys, but each has its use case, as described in the examples.