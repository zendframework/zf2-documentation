.. EN-Revision: none
.. _zend.di.configuration:

Configurazione Zend\\Di
=======================

La maggior parte della configurazione, sia per il setup delle Definitions come per l'impostazione dell'Instance
Manager può essere raggiunto da un file di configurazione. Questo file produrrà un array (tipicamente) con una
particolare struttura iterabile.

Le tue parole chiave sono 'definition' ed 'istanza', ognuna specifica valori per rispettivamente: impostazioni di
definizione e impostazioni per l'instanza manager.

La sezione di definizione si aspetta le seguenti informazioni espresse come un array PHP:

.. code-block:: php
   :linenos:

   $config = array(
       'definition' => array(
           'compiler' => array(/* @todo compiler information */),
           'runtime'  => array(/* @todo runtime information */),
           'class' => array(
               'instantiator' => '', // the name of the instantiator, by default this is __construct
               'supertypes    => array(), // an array of supertypes the class implements
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


