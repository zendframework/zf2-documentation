.. _zend.progressbar.adapter.console:

Zend_ProgressBar_Adapter_Console
================================

``Zend_ProgressBar_Adapter_Console`` est un adaptateur de type texte pour les terminaux. Il peut automatiquement
détecter la largeur du terminal mais supporte aussi des largeurs personnalisées. Vous pouvez définir quels
éléments seront affichés avec la barre de progression et personnaliser leur ordre. Vous pouvez aussi définir le
style de la barre de progression elle-même.

.. note::

   **Reconnaissance automatique de la largeur de la console**

   *shell_exec* est nécessaire pour que ceci fonctionne sur les systèmes de type \*nix. Sur Windows, il y a
   toujours un terminal fixe de 80 caractères de large, donc la reconnaissance automatique n'est pas nécessaire.

Vous pouvez paramétrer les options de l'adaptateur soit via les méthodes *set** soit en fournissant un tableau
("array") ou une instance ``Zend_Config`` en tant que premier paramètre du constructeur. Les options disponibles
sont :

- *outputStream*\  : un flux de sortie différent, si vous ne souhaitez pas utiliser STDOUT. Peut être n'importe
  quel autre flux come *php://stderr* ou un chemin vers un fichier.

- *width*\  : soit un entier ou la constante ``AUTO`` de ``Zend_Console_ProgressBar``.

- *elements*\  : soit ``NULL`` par défaut ou un tableau avec au moins l'une des constantes de
  ``Zend_Console_ProgressBar`` suivantes comme valeur :

  - ``ELEMENT_PERCENT``\  : la valeur courante en pourcentage.

  - ``ELEMENT_BAR``\  : la barre qui va représenter le pourcentage.

  - ``ELEMENT_ETA``\  : le calcul automatique du temps restant estimé (NDT. : "Estimated Time for
    Accomplishment"). Cet élément est affiché pour la première fois qu'après cinq secondes, car durant ce
    temps, il n'est pas possible de calculer des résultats précis.

  - ``ELEMENT_TEXT``\  : un message de statut optionnel concernant le processus courant.

- *textWidth*\  : largeur en caractères de l'élément ``ELEMENT_TEXT``. Par défaut vaut 20.

- *charset*\  : encodage de l'élément ``ELEMENT_TEXT``. Par défaut vaut "utf-8".

- *barLeftChar*\  : un caractère qui est utilisé du côté gauche de l'indicateur de la barre de progression.

- *barRightChar*\  : un caractère qui est utilisé du côté droit de l'indicateur de la barre de progression.

- *barIndicatorChar*\  : un caractère qui est utilisé pour l'indicateur de la barre de progression. Celui-ci
  peut être vide.


