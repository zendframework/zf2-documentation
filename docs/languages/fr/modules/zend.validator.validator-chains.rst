.. EN-Revision: none
.. _zend.validate.validator_chains:

Chaînes de validation
=====================

Souvent, de multiples validations doivent être appliquées à une valeur dans un ordre particulier. Le code
suivant décrit une méthode permettant de solutionner l'exemple de :ref:`l'introduction
<zend.validate.introduction>`, dans lequel un identifiant doit contenir précisément entre 6 et 12 caractères
alphanumériques.

   .. code-block:: php
      :linenos:

      // Creation d'une chaîne de validateurs et ajout de validateurs
      $validateurChaine = new Zend\Validate\Validate();
      $validateurChaine->addValidator(
                          new Zend\Validate\StringLength(array('min' => 6,
                                                               'max' => 12)))
                       ->addValidator(new Zend\Validate\Alnum());

      // Validation de l'identifiant
      if ($validateurChaine->isValid($identifiant)) {
          // l'identifiant est testé avec succès
      } else {
          // l'identifiant échoue aux tests, afficher pourquoi
          foreach ($validateurChaine->getMessages() as $message) {
              echo "$message\n";
          }
      }

Les validateurs sont exécutés dans leur ordre d'ajout à ``Zend_Validate``. Dans l'exemple ci-dessus,
l'identifiant est d'abord testé pour vérifier que sa longueur est bien comprise entre 6 et 12 caractères, puis
ensuite testé pour vérifier qu'il ne contient bien que des caractères alphanumériques. Le second test est
exécuté quelque soit le résultat du précédent. Ainsi, dans le cas où les deux tests échouent,
``getMessages()`` retournera un message d'échec pour chacun des validateurs.

Dans certains cas, il peut être utile d'interrompre le processus si l'un des tests échoue. ``Zend_Validate``
permet ce cas de figure via l'usage du deuxième paramètre de la méthode ``addValidator()``. En positionnant
``$breakChainOnFailure`` à ``TRUE``, le validateur ajouté interrompra la procédure de test s'il échoue, ce qui
permet d'éviter de lancer tout autre test qui serait inutile ou inapproprié dans ce cas de figure. Si l'exemple
précédent était écrit comme suit, la validation alphanumérique ne serait pas lancé si la vérification de la
longueur de la valeur échouait :

   .. code-block:: php
      :linenos:

      $validateurChaine->addValidator(
                          new Zend\Validate\StringLength(array('min' => 6,
                                                               'max' => 12)),
                          true)
                       ->addValidator(new Zend\Validate\Alnum());



Tout objet qui implémente ``Zend\Validate\Interface`` peut être utilisé dans une chaîne de validation.


