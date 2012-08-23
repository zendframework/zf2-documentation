.. EN-Revision: none
.. _zend.json.objects:

Utilisation avancée de Zend_Json
================================

.. _zend.json.advanced.objects1:

Objets JSON
-----------

Lorsque vous encodez des objets *PHP* en tant que *JSON*, toutes les propriétés publiques de cet objet sont
encodées dans un objet *JSON*.

*JSON* ne vous permet pas de référencer des objets, donc le soin devra être pris pour ne pas coder des objets
avec des références récursives. Si vous avez des problèmes de récursivité, ``Zend_Json::encode()`` et
``Zend_Json_Encoder::encode()`` autorisent un deuxième paramètre facultatif afin de vérifier la récursivité ;
si un objet est sérialisé deux fois, une exception sera levée.

Bien que les objets Javascript correspondent de très près aux tableau associatifs de *PHP*, décoder des objets
*JSON* pose une légère difficulté. Certains suggèrent qu'un identifiant de classe soit passé, et qu'une
instance de cette classe soit créée et définie avec les paires clé/valeur des objets *JSON*; d'autres pensent
que cela pourrait poser un risque de sécurité potentiel.

Par défaut, ``Zend_Json`` décodera des objets JSON comme en tableaux associatifs. Cependant, si vous désirez
avoir un objet en retour, vous pouvez le spécifier :

   .. code-block:: php
      :linenos:

      // Décode des objets JSON en tant qu'objets PHP
      $phpNatif = Zend_Json::decode($valeurEncodee, Zend_Json::TYPE_OBJECT);

Tous les objets sont ainsi décodés et retournés comme des objets de type *StdClass*, avec leurs propriétés
correspondantes aux paires clé/valeur de la notation JSON.

La recommandation de Zend Framework est que le développeur doit décider comment décoder les objets *JSON*. Si un
objet d'un type spécifié doit être créé, il peut être créé dans le code du développeur et définit avec
les valeurs décodées en utilisant ``Zend_Json``.

.. _zend.json.advanced.objects2:

Encoding PHP objects
--------------------

If you are encoding *PHP* objects by default the encoding mechanism can only access public properties of these
objects. When a method ``toJson()`` is implemented on an object to encode, ``Zend_Json`` calls this method and
expects the object to return a *JSON* representation of its internal state.

.. _zend.json.advanced.internal:

Internal Encoder/Decoder
------------------------

Zend_Json has two different modes depending if ext/json is enabled in your *PHP* installation or not. If ext/json
is installed by default ``json_encode()`` and ``json_decode()`` functions are used for encoding and decoding
*JSON*. If ext/json is not installed a Zend Framework implementation in *PHP* code is used for en-/decoding. This
is considerably slower than using the php extension, but behaves exactly the same.

Still sometimes you might want to use the internal encoder/decoder even if you have ext/json installed. You can
achieve this by calling:

.. code-block:: php
   :linenos:

   Zend_Json::$useBuiltinEncoderDecoder = true:

.. _zend.json.advanced.expr:

JSON Expressions
----------------

Javascript makes heavy use of anonymnous function callbacks, which can be saved within *JSON* object variables.
Still they only work if not returned inside double qoutes, which ``Zend_Json`` naturally does. With the Expression
support for Zend_Json support you can encode *JSON* objects with valid javascript callbacks. This works for both
``json_encode()`` or the internal encoder.

A javascript callback is represented using the ``Zend_Json_Expr`` object. It implements the value object pattern
and is immutable. You can set the javascript expression as the first constructor argument. By default
``Zend_Json::encode`` does not encode javascript callbacks, you have to pass the option *'enableJsonExprFinder' =
true* into the *encode* function. If enabled the expression support works for all nested expressions in large
object structures. A usage example would look like:

.. code-block:: php
   :linenos:

   $data = array(
       'onClick' => new Zend_Json_Expr('function() {'
                 . 'alert("I am a valid javascript callback '
                 . 'created by Zend_Json"); }'),
       'other' => 'no expression',
   );
   $jsonObjectWithExpression = Zend_Json::encode(
       $data,
       false,
       array('enableJsonExprFinder' => true)
   );


