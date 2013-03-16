.. EN-Revision: none
.. _zend.validator.set.stringlength:

StringLength
============

Ce validateur vérifie la longueur d'une chaine de caractères.

.. note::

   **Zend\Validate\StringLength ne supporte que les chaînes**

   Zend\Validate\StringLength ne fonctionnera pas avec les entiers, flottants, les dates ou encore les objets.

.. _zend.validator.set.stringlength.options:

Options gérées par Zend\Validate\StringLength
---------------------------------------------

Les options suivantes sont reconnues par ``Zend\Validate\StringLength``:

- **encoding**: Définit l'encodage ``ICONV`` à utiliser avec la chaîne.

- **min**: Définit le nombre de caractères minimum requis.

- **max**: Définit le nombre de caractères maximum requis.

.. _zend.validator.set.stringlength.basic:

Comportement par défaut de Zend\Validate\StringLength
-----------------------------------------------------

Par défaut, ce validateur vérifie qu'une valeur de chaîne est bien entre ``min`` et ``max`` caractères. Pour
``min``, la valeur par défaut est **0** et pour ``max`` c'est **NULL** ce qui signifie illimité.

Ainsi par défaut, sans aucune option, ce validateur vérifie que la donnée traitée est bien une chaîne.

.. _zend.validator.set.stringlength.maximum:

Limiter sur la borne supérieure
-------------------------------

La borne supérieure se règle au moyen de l'option ``max``. Ce doit être un entier.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(array('max' => 6));

   $validator->isValid("Test"); // retourne true
   $validator->isValid("Testing"); // retourne false

Il est possible de préciser cette option plus tard, au moyen de la méthode ``setMax()``. ``getMax()`` existe
aussi.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength();
   $validator->setMax(6);

   $validator->isValid("Test"); // retourne true
   $validator->isValid("Testing"); // retourne false

.. _zend.validator.set.stringlength.minimum:

Limiter sur la borne inférieure
-------------------------------

La borne inférieure se règle au moyen de l'option ``min``. Ce doit être un entier.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(array('min' => 5));

   $validator->isValid("Test"); // retourne false
   $validator->isValid("Testing"); // retourne true

Il est possible de préciser cette option plus tard, au moyen de la méthode ``setMin()``. ``getMin()`` existe
aussi.

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength();
   $validator->setMin(5);

   $validator->isValid("Test"); // retourne false
   $validator->isValid("Testing"); // retourne true

.. _zend.validator.set.stringlength.both:

Limiter via les deux bornes
---------------------------

Quelques fois, il est nécessaire de s'assurer que la chaine comprenne bien un nombre de caractères entre deux
bornes min et max. Par exemple depuis un champ de formulaire représentant un nom, vous voudriez que l'utilisateur
ne puisse saisir plus de 30 caractères mais au moins 3. Voyez l'exemple qui suit:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(array('min' => 3, 'max' => 30));

   $validator->isValid("."); // retourne false
   $validator->isValid("Test"); // retourne true
   $validator->isValid("Testing"); // retourne true

.. note::

   **Comportement illogique, borne inférieure supérieure à la borne supérieure**

   Si vous tentez de préciser un min supérieur au max, ou inversement, une exception sera levée.

.. _zend.validator.set.stringlength.encoding:

Encodage des valeurs
--------------------

Les chaines se représentent toujours en considérant un encodage. Même si vous ne le précisez pas explicitement,
*PHP* en utilise un. Si votre application utilise un encodage différent de celui de *PHP*, vous devrez alors le
préciser.

Vous pouvez passer votre propre encodage à l'initialisation grâce à l'option ``encoding``, ou en utilisant la
méthode ``setEncoding()``. Nous supposons que votre installation utilise *ISO* ainsi que votre application. Dans
ce cas, vous verrez le comportement suivant:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validate\StringLength(
       array('min' => 6)
   );
   $validator->isValid("Ärger"); // retourne false

   $validator->setEncoding("UTF-8");
   $validator->isValid("Ärger"); // retourne true

   $validator2 = new Zend\Validate\StringLength(
       array('min' => 6, 'encoding' => 'UTF-8')
   );
   $validator2->isValid("Ärger"); // retourne true

Si votre installation et votre application utilisent des encodages différents, vous deviez toujours préciser
l'encodage vous-même.


