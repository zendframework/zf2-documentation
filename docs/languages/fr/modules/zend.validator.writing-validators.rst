.. EN-Revision: none
.. _zend.validator.writing_validators:

Écrire des validateurs
======================

``Zend_Validate`` fournit un ensemble de validateurs habituellement nécessaires, mais inévitablement, les
développeurs souhaiteront écrire des validateurs sur mesure pour leurs besoins particuliers. La méthode
d'écriture d'un validateur personnalisé est décrit dans cette section.

``Zend_Validate_Interface`` définit trois méthodes, ``isValid()``, ``getMessages()``, et ``getErrors()``, qui
peuvent être implémentées par des classes d'utilisateur afin de créer les objets de validation sur mesure. Un
objet qui implémente l'interface ``Zend_Validate_Interface`` peut être ajouté à une chaîne de validateur avec
``Zend_Validate::addValidator()``. De tels objets peuvent également être employés avec :ref:`Zend_Filter_Input
<zend.filter.input>`.

Comme vous avez déjà pu déduire de la description ci-dessus de ``Zend_Validate_Interface``, les classes de
validation fournie avec Zend Framework retourne une valeur booléenne pour savoir si une valeur est validée ou
non. Elles fournissent également des informations sur la raison pour laquelle la validation a échoué sur une
valeur. La mise à disposition de ces raisons d'échec de validation peut être utilisée par une application dans
différents buts, tels que fournir des statistiques pour l'analyse de la facilité d'utilisation.

La fonctionnalité de base de message d'échec de validation est implémentée dans ``Zend_Validate_Abstract``.
Pour inclure cette fonctionnalité en créant une classe de validation, étendez simplement
``Zend_Validate_Abstract``. Dans la classe étendue vous implémenteriez la logique de la méthode ``isValid()`` et
définiriez les variables de message et les modèles de message qui correspondent aux types d'échecs de validation
qui peuvent se produire. Si une valeur ne passe pas vos essais de validation, alors ``isValid()`` devrait renvoyer
``FALSE``. Si la valeur passe vos essais de validation, alors ``isValid()`` devrait renvoyer ``TRUE``.

En général, la méthode ``isValid()`` ne devrait lever aucune exception, excepté où il est impossible de
déterminer si la valeur d'entrée est valide. Quelques exemples de cas raisonnables pour lever une exception
pourraient être si un fichier ne peut pas être ouvert, un serveur de *LDAP* ne pourraient pas être contacté, ou
une connexion de base de données est indisponible, où quand une telle chose peut être exigée pour que le
succès ou l'échec de validation soit déterminé.

.. _zend.validator.writing_validators.example.simple:

.. rubric:: Création d'une simple classe de validation

L'exemple suivant démontre comment un validateur personnalisé très simple pourrait être écrit. Dans ce cas-ci
les règles de validation sont simplement que la valeur d'entrée doit être une valeur en virgule flottante.

   .. code-block:: php
      :linenos:

      class MonValidateur_Float extends Zend_Validate_Abstract
      {
          const FLOAT = 'float';

          protected $_messageTemplates = array(
              self::FLOAT => "'%value%' n'est pas une valeur en virgule flottante"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              if (!is_float($value)) {
                  $this->_error(self::FLOAT);
                  return false;
              }

              return true;
          }
      }

La classe définit un modèle pour son message unique d'échec de validation, qui inclut le paramètre magique
intégré, *%value%*. L'appel à ``_setValue()`` prépare l'objet pour insérer automatiquement la valeur examinée
dans le message d'échec, si la validation de la valeur échoue. L'appel à ``_error()`` trace la raison d'échec
de validation. Puisque cette classe définit seulement un message d'échec, il n'est pas nécessaire de fournir à
``_error()`` le nom du modèle de message d'échec.

.. _zend.validator.writing_validators.example.conditions.dependent:

.. rubric:: Écriture d'une classe de validation ayant des conditions de dépendances

L'exemple suivant démontre un ensemble plus complexe de règles de validation, où on l'exige que la valeur
d'entrée doit être numérique et dans la plage des valeurs limites minimum et maximum. Une valeur d'entrée
ferait échouer la validation pour exactement une des raisons suivantes :

   - La valeur d'entrée n'est pas numérique.

   - La valeur d'entrée est inférieure que la valeur permise minimum.

   - La valeur d'entrée est supérieure que la valeur permise maximum.



Ces raisons d'échec de validation sont alors traduites dans les définitions de la classe :

   .. code-block:: php
      :linenos:

      class MonValidateur_NumericBetween extends Zend_Validate_Abstract
      {
          const MSG_NUMERIC = 'msgNumeric';
          const MSG_MINIMUM = 'msgMinimum';
          const MSG_MAXIMUM = 'msgMaximum';

          public $minimum = 0;
          public $maximum = 100;

          protected $_messageVariables = array(
              'min' => 'minimum',
              'max' => 'maximum'
          );

          protected $_messageTemplates = array(
              self::MSG_NUMERIC => "'%value%' n'est pas numérique",
              self::MSG_MINIMUM => "'%value%' doit être supérieure à '%min%'",
              self::MSG_MAXIMUM => "'%value%' doit être inférieure à '%max%'"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              if (!is_numeric($value)) {
                  $this->_error(self::MSG_NUMERIC);
                  return false;
              }

              if ($value < $this->minimum) {
                  $this->_error(self::MSG_MINIMUM);
                  return false;
              }

              if ($value > $this->maximum) {
                  $this->_error(self::MSG_MAXIMUM);
                  return false;
              }

              return true;
          }
      }

Les propriétés publiques ``$minimum`` et ``$maximum`` ont été établies pour fournir les frontières minimum et
maximum d'une valeur pour qu'elle soit validée avec succès. La classe définit également deux variables de
message qui correspondent aux propriétés publiques et permettent que *min* et *max* soient employés dans des
modèles de message en tant que paramètres magiques, comme avec *value*.

Noter que si n'importe quel élément de la validation vérifié dans ``isValid()`` échoue, un message approprié
d'échec est préparé, et la méthode renvoie immédiatement ``FALSE``. Ces règles de validation sont donc
séquentiellement dépendantes. C'est-à-dire, que si un essai échoue, il n'y a aucun besoin d'examiner les
règles suivantes de validation. Ce besoin peut exister, cependant. L'exemple suivant illustre comment écrire une
classe ayant des règles indépendantes de validation, où l'objet de validation peut renvoyer des raisons
multiples pour lesquelles une tentative particulière de validation a échoué.

.. _zend.validator.writing_validators.example.conditions.independent:

.. rubric:: Validation avec des conditions indépendantes, avec raisons multiples d'échec

Considérons l'écriture d'une classe de validation pour le contrôle de résistance d'un mot de passe - quand un
utilisateur est requis afin de choisir un mot de passe qui respecte certains critères pour aider à la
sécurisation des comptes d'utilisateur. Supposons que les critères de sécurité de mot de passe imposent que le
mot de passe :

   - est au moins une longueur de 8 caractères,

   - contient au moins une lettre majuscule,

   - contient au moins une lettre minuscule,

   - et contient au moins un caractère de chiffre.



La classe suivante implémente ces critères de validation :

   .. code-block:: php
      :linenos:

      class MonValidateur_PasswordStrength extends Zend_Validate_Abstract
      {
          const LENGTH = 'length';
          const UPPER  = 'upper';
          const LOWER  = 'lower';
          const DIGIT  = 'digit';

          protected $_messageTemplates = array(
              self::LENGTH =>
                  "'%value%' doit avoir une longueur d'au moins 8 caractères",
              self::UPPER  =>
                  "'%value%' doit contenir au moins une lettre majuscule",
              self::LOWER  =>
                  "'%value%' doit contenir au moins une lettre minuscule",
              self::DIGIT  =>
                  "'%value%' doit contenir au moins un chiffre"
          );

          public function isValid($value)
          {
              $this->_setValue($value);

              $isValid = true;

              if (strlen($value) < 8) {
                  $this->_error(self::LENGTH);
                  $isValid = false;
              }

              if (!preg_match('/[A-Z]/', $value)) {
                  $this->_error(self::UPPER);
                  $isValid = false;
              }

              if (!preg_match('/[a-z]/', $value)) {
                  $this->_error(self::LOWER);
                  $isValid = false;
              }

              if (!preg_match('/\d/', $value)) {
                  $this->_error(self::DIGIT);
                  $isValid = false;
              }

              return $isValid;
          }
      }

Noter que les quatre critères d'essais dans ``isValid()`` ne renvoient pas immédiatement ``FALSE``. Ceci permet
à la classe de validation de fournir toutes les raisons pour lesquelles le mot de passe d'entrée n'a pas réussi
à remplir les conditions de validation. Si, par exemple, un utilisateur entre la chaîne "*#$%*" comme mot de
passe, ``isValid()`` entraînera que les quatre messages d'échec de validation seront retournés lors de l'appel
suivant à ``getMessages()``.


