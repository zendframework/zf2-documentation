.. _zend.progressbar.adapter.jspull:

Zend_ProgressBar_Adapter_JsPull
===============================

``Zend_ProgressBar_Adapter_JsPull`` est l'opposé de jsPush, car il requiert de venir récupérer les nouvelles
mises à jour, plutôt que d'envoyer les mises à jour vers le navigateur. Généralement, vous devriez utiliser
l'adaptateur avec l'option de persistance de ``Zend_ProgressBar``. Lors de l'appel, l'adaptateur envoie une chaîne
*JSON* vers le navigateur, qui est comparable à la chaîne *JSON* envoyée par l'adaptateur jsPush. La seule
différence est qu'il contient un paramètre supplémentaire "*finished*", qui vaut ``FALSE`` quand ``update()``
est appelée ou ``TRUE`` quand ``finish()`` est appelée.

Vous pouvez paramétrer les options de l'adaptateur soit avec les méthodes *set** soit en fournissant un tableau
("array") ou une instance de ``Zend_Config`` contenant les options en tant que premier paramètre du constructeur.
Les options disponibles sont :

- *exitAfterSend*: sort de la requête courante après que les données aient été envoyées au navigateur. Vaut
  ``TRUE`` par défaut.


