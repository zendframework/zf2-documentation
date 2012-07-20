.. _zend.currency.usage:

Utiliser Zend_Currency
======================

.. _zend.currency.usage.generic:

Utilisation de base
-------------------

La manière la plus simple consiste à se reposer sur la locale de l'utilisateur. Lorsque vous créez une instance
de ``Zend_Currency`` sans préciser d'options, la locale du client sera alors utilisée.

.. _zend.currency.usage.generic.example-1:

.. rubric:: Créer une monnaie avec les paramètres du client

Imaginons un client dont la locale est "en_US" dans son navigateur. Dans ce cas, ``Zend_Currency`` détectera
automatiquement la monnaie à utiliser.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency();

   // Voyons les paramètres par défaut régis par la locale utilisateur
   // var_dump($currency);

L'objet crée va alors contenir une monnaie "US Dollar" car il s'agit de la monnaie affectée aux USA. D'autres
options ont aussi été affectées comme le signe "$" ou l'abbréviation "USD".

.. note::

   **La détection automatique par locale ne fonctionne pas toujours**

   La détection automatique par locale ne fonctionne pas toujours car ``Zend_Currency`` nécessite une locale
   incluant la région. Si le client utilise une locale courte ("en"), ``Zend_Currency`` ne sait pas quelle région
   parmi les 30 possibles choisir. Une exception sera alors levée.

   Un client peut aussi déregler la locale dans son navigateur, ou la supprimer. Ainsi le paramètre de
   l'environnement sera alors utilisé pour la locale, ce qui peut mener à des comportements non attendus ou des
   exceptions.

.. _zend.currency.usage.locale:

Créer une monnaie basée sur une locale
--------------------------------------

Pour éviter ce genre de problème, précisez manuellement la locale à utiliser.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency('en_US');

   // Utilisation de l'option 'locale'
   // $currency = new Zend_Currency(array('locale' => 'en_US'));

   // Voir la monnaie avec les paramètres actuels fixés à 'en_US'
   // var_dump($currency);

Dans l'exemple ci-dessus, nous ne sommes plus dépendant du client.

``Zend_Currency`` supporte aussi l'utilisation d'une locale globale. Mettez une instance de ``Zend_Locale`` dans le
registre comme montré ci-après. Dans un tel cas, l'option locale n'est plus obligatoire pour chaque instance et
la même locale sera utilisée partout, tout le temps.

.. code-block:: php
   :linenos:

   // dans le bootstrap
   $locale = new Zend_Locale('de_AT');
   Zend_Registry::set('Zend_Locale', $locale);

   // quelque part dans l'application
   $currency = new Zend_Currency();

.. _zend.currency.usage.territory:

Création de monnaie basée sur un pays
-------------------------------------

``Zend_Currency`` est aussi capable de travailler à partir d'un pays fourni en utilisant ``Zend_Locale`` en
interne.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency('US');

   // Voir le réglage courant qui vaut 'en_US'
   // var_dump($currency);

.. note::

   **Mettre en majuscule les pays**

   Quand vous savez que vous utilisez un pays, vous devez le mettre en majuscule. Sinon vous pourriez croire que
   vous recevez un fausse locale. Par exemple quan vous donnez "om", vous pourriez alors espérer retrouver
   "ar_OM". Mais en ait il s'agira de "om" qui est aussi une langue.

   Ainsi mettez toujours en majuscule l'entrée quand vous savez qu'il s'agit d'un pays.


