.. _zend.session.introduction:

Introduction
============

L'équipe Auth de Zend Framework apprécie considérablement votre feedback et vos contributions sur notre liste
émail : `fw-auth@lists.zend.com`_.

Dans les applications Web écrites en *PHP*, une **session** représente un raccordement logique entre le côté
serveur, des données persistantes et un client particulier (par exemple, un navigateur Web). ``Zend_Session`` aide
à contrôler et à préserver les données de session, un complément logique des données de type cookie, en cas
de demande de page multiples par le même client. À la différence des données de cookie, les données de session
ne sont pas stockées du côté client, et elles sont seulement partagées avec le client quand le code source du
côté serveur rend volontairement disponible les données par l'intermédiaire d'une réponse à une demande du
client. Dans le cadre de ce composant et de cette documentation, le terme "données de session" se rapportent aux
données du côté serveur stockées dans `$_SESSION`_, contrôlées par ``Zend_Session``, et individuellement
manipulées par des objets ``Zend_Session_Namespace``. **Les espaces de noms de session** permettent d'accéder aux
données de session en utilisant les `espaces de noms`_ classiques implémentés logiquement en tant que groupes
nommés de tableaux associatifs, indexés par des chaînes (semblables aux tableaux habituels de *PHP*).

Les instances ``Zend_Session_Namespace`` sont des objets accesseurs pour les sous-parties nommées de
``$_SESSION``. Le composant ``Zend_Session`` encapsule l'extension session de *PHP* existante avec une interface
d'administration et de gestion, afin de fournir une *API* à ``Zend_Session_Namespace`` pour les espaces de noms de
session persistants. ``Zend_Session_Namespace`` fournit une interface normalisée et orientée objet pour
travailler en espaces de noms persistants à l'intérieur du mécanisme standard des sessions de *PHP*. Le support
existe pour les espaces de noms anonymes et les espaces de nom de session authentifiés (par exemple, "login").
``Zend_Auth``, le composant d'authentification de Zend Framework emploie ``Zend_Session_Namespace`` pour stocker
les informations liées aux utilisateurs authentifiés. Puisque ``Zend_Session`` emploie les fonctions normales de
l'extension session de *PHP*, tous les options et réglages familiers de configuration s'appliquent (voir
`http://www.php.net/session`_), avec en bonus la facilité d'accès par une interface orientée objet et un
comportement par défaut fournissant les meilleures pratiques et une intégration sans problèmes dans Zend
Framework. Ainsi, un id standard de session *PHP*, stocké soit dans un cookie côté client ou incorporé dans
l'URL, maintient l'association entre un client et des données de session.

La fonction de gestion de session par défaut `session_set_save_handler`_ ne maintient pas cette association dans
un faisceau (NDT. : "cluster") de serveurs sous certaines conditions car les données de session sont sauvegardées
seulement sur le serveur qui répond à la requête. Si une requête peut être réalisée par un serveur
différent de celui où les données de session sont sauvegardées, alors le serveur appelé n'aura pas accès aux
données de session (si elles ne sont pas disponibles dans un système de fichiers en réseau). Une liste
additionnelle de gestionnaire de session sera fournie, dès que possible. Les membres de la communauté sont
encouragés à suggérer et soumettre des gestionnaires de sauvegardes à la liste `fw-auth@lists.zend.com`_. Un
gestionnaire de sauvegarde compatible ``Zend_Db`` a été signalé à la liste.



.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`$_SESSION`: http://www.php.net/manual/fr/reserved.variables.php#reserved.variables.session
.. _`espaces de noms`: http://fr.wikipedia.org/wiki/Espace_de_noms
.. _`http://www.php.net/session`: http://www.php.net/manual/fr/ref.session.php
.. _`session_set_save_handler`: http://www.php.net/manual/fr/function.session-set-save-handler.php
