.. EN-Revision: none
.. _zend.rest.introduction:

Introduction
============

Les services Web REST utilisent des formats *XML* spécifiques. Ces normes ad-hoc signifient que la façon
d'accéder à un service Web REST est différente pour chaque service. Les services Web REST utilise typiquement
les paramètres *URL* (données GET) ou les informations du chemin pour demander des données, et les données POST
pour envoyer des données.

Zend Framework fournit les possibilités de client et de serveur, qui, une fois utilisées ensemble tiennent compte
de beaucoup plus d'expérience d'interface "locale" par l'intermédiaire de l'accès aux propriétés d'objet
virtuel. Le composant serveur comporte l'exposition automatique des fonctions et des classes employant un format
compréhensible et simple de *XML*. En accédant à ces services via le client, il est possible de rechercher
facilement les données retournées lors de l'appel à distance. Si vous souhaitez employer le client avec un
service non basé sur le service Zend_Rest_Server, il fournira un accès plus facile aux données.

En plus des composants ``Zend_Rest_Server`` et ``Zend_Rest_Client``, les classes :ref:`Zend_Rest_Route et
Zend_Rest_Controller <zend.controller.router.routes.rest>` sont fournies pour aider lors du routage des requêtes
vers les contrôleurs.


