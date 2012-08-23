.. EN-Revision: none
.. _performance.localization:

Internationalisation (i18n) and Localisation (l10n)
===================================================

Internationaliser et localiser un site sont des manières fantastiques d'étendre votre audience et de s'assurer
que tous les visiteurs peuvent trouver l'information dont ils ont besoin. Cependant, ceci entraîne souvent une
dégradation de performance. Ci-dessous vous trouverez des stratégies à utiliser pour réduire la surcharge due
à l'I18N et à la L10N.

.. _performance.localization.translationadapter:

Quel adaptateur de traduction dois-je utiliser ?
------------------------------------------------

Tous les adaptateurs de traduction ne sont pas conçus de la même façon. Certains ont plus de fonctionnalités
que d'autres, et certains sont plus performants que d'autres. De plus, vous pouvez avoir des contraintes qui vous
forcent à utiliser un adaptateur en particulier. Cependant si vous avez le choix, quels adaptateurs sont les plus
rapides ?

.. _performance.localization.translationadapter.fastest:

Utiliser les adaptateurs de traduction non-XML pour plus de rapidité
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zend Framework embarque toute une variété d'adaptateurs de traduction. Une moitié de ceux-ci utilisent un format
XML, entraînant une surcharge mémoire et des pertes de performance. Heureusement, il existe plusieurs adaptateurs
basés sur d'autres formats qui peuvent être analysés beaucoup plus rapidement. Par ordre de vitesse, du plus
rapide au plus lent, ils sont :

- **Array**\  : celui-ci est le plus rapide, puisqu'il est, par définition, analysé dans un format natif de PHP
  immédiatement lors de son inclusion.

- **CSV**\  : utilises *fgetcsv()* pour analyser un fichier CSV file et le transforme en un format PHP natif.

- **INI**\  : utilises *parse_ini_file()* pour analyser un fichier INI file et le transforme en un format PHP
  natif. Celui-ci et l'adaptateur CSV sont équivalent en terme de performance.

- **Gettext**\  : l'adaptateur Gettext de Zend Framework **n'utilise pas** l'extension gettext puisqu'elle n'est
  pas thread safe et ne permet pas de spécifier plus d'une locale par serveur. En conséquence, il est plus lent
  que d'utiliser l'extension Gettext directement, mais comme le format Gettext est binaire, il reste plus rapide à
  analyser qu'un format XML.

Si l'un de vos besoins principaux est la performance, nous vous conseillons d'utiliser l'un des adaptateurs
ci-dessus.

.. _performance.localization.cache:

Comment peut-on améliorer les performances de la traduction et de la localisation ?
-----------------------------------------------------------------------------------

Peut-être, pour certaines raisons, vous êtes limité à un adaptateur de traduction de type XML. Ou peut-être
vous voudriez accélérer des choses encore plus. Ou peut-être vous voulez rendre des opérations de localisation
plus rapides. Comment pouvez-vous faire ceci ?

.. _performance.localization.cache.usage:

Utiliser les caches de traductions et de localisation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A la fois ``Zend_Translator`` et ``Zend_Locale`` implémente une fonctionnalité de mise en cache qui peuvent
considérablement améliorer les performances. Dans chacun des cas, le goulot principal est typiquement la lecture
des fichiers, pas la réelle consultation ; la mise en cache élimine la nécessité de relire de nouveau les
fichiers de traduction ou de localisation.

Vous pouvez lire plus d'informations concernant la mise en cache d'informations de traduction ou de localisation
dans les paragraphes suivants :

- :ref:`Mise en cache pour Zend_Translator <zend.translator.adapter.caching>`

- :ref:`Mise en cache pour Zend_Locale <zend.locale.cache>`


