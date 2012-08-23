.. EN-Revision: none
.. _zend.json.introduction:

Introduction
============

``Zend_Json`` fournit des méthodes pratiques permettant de convertir du code *PHP* natif en notation *JSON*, et
vice versa. Pour plus d'informations concernant *JSON*, visitez le site du `projet JSON`_.

La notation *JSON* (JavaScript Object Notation [Ndt : Notation-Objet JavaScript]) peut être utilisée comme un
système d'échange de données entre JavaScript et d'autres langages. Comme la notation *JSON* peut être
évaluée directement par JavaScript, c'est une alternative plus simple que *XML* pour les interfaces *AJAX*.

De plus, ``Zend_Json`` fournit une manière utile pour convertir n'importe quel chaîne arbitraire formatée en
*XML* en une chaîne formatée en *JSON*. Cette caractéristique permettra aux développeurs *PHP* de transformer
les données encodées en format *XML* en un format *JSON* avant de l'envoyer aux navigateurs basés sur des
applications client Ajax. ``Zend_Json`` fournit une fonction facilitant la conversion de données dynamiques du
code côté serveur évitant ainsi l'analyse syntaxique inutile réalisée dans les applications côté client. Il
offre une fonction utilitaire agréable qui aboutit aux techniques plus simples de traitement de données
d'applications spécifiques.



.. _`projet JSON`: http://www.json.org/
