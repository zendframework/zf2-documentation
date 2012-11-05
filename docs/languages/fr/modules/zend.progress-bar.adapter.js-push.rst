.. EN-Revision: none
.. _zend.progressbar.adapter.jspush:

Zend\ProgressBar_Adapter\JsPush
===============================

``Zend\ProgressBar_Adapter\JsPush`` est un adaptateur qui vous permet de mettre à jour une barre de progression
dans un navigateur au travers de Javascript. Ceci veut dire qu'une seconde connexion n'est pas nécessaire pour
recueillir le statut du processus courant, mais que le processus lui-même envoie son statut directement au
navigateur.

Vous pouvez paramétrer les options de l'adaptateur soit avec les méthodes *set** soit en fournissant un tableau
("array") ou une instance de ``Zend_Config`` contenant les options en tant que premier paramètre du constructeur.
Les options disponibles sont :

- *updateMethodName*: la méthode Javascript qui sera appelée à chaque mise à jour. La valeur par défaut est
  ``Zend\ProgressBar\Update``.

- *finishMethodName*: la méthode Javascript qui sera appelée lorsque le statut terminé sera atteint. La valeur
  par défaut est ``NULL``, qui veut dire que rien n'est fait.

L'utilisation de cet adaptateur est assez simple. Premièrement vous créez une barre de progression pour le
navigateur, soit avec Javascript ou auparavant en pur HTML. Ensuite vous définissez une méthode de mise à jour
et optionnellement une méthode de finalisation en Javascript, les deux acceptant un objet *JSON* en tant qu'unique
argument. Ensuite vous appelez une page Web avec un processus chronophage dans une balise *iframe* ou *object*
masqué. Pendant que le processus tourne, l'adaptateur appelle la méthode de mise à jour à chaque mise à jour
avec un objet *JSON*, contenant le paramètres suivants :

- *current*: la valeur courante

- *max*: la valeur maximum

- *percent*: le pourcentage calculé

- *timeTaken*: le temps depuis quand le processus courant est en marche

- *timeRemaining*: le temps estimé pour que le processus se termine

- *text*: le message de statut optionnel, si fourni

.. _zend.progressbar-adapter.jspush.example:

.. rubric:: Exemple basique du fonctionnement côté-client

Cet exemple illustre un paramétrage basique du HTML, *CSS* et JavaScript pour l'adaptateur JsPush :

.. code-block:: html
   :linenos:

   <div id="zend-progressbar-container">
       <div id="zend-progressbar-done"></div>
   </div>

   <iframe src="long-running-process.php" id="long-running-process"></iframe>

.. code-block:: css
   :linenos:

   #long-running-process {
       position: absolute;
       left: -100px;
       top: -100px;

       width: 1px;
       height: 1px;
   }

   #zend-progressbar-container {
       width: 100px;
       height: 30px;

       border: 1px solid #000000;
       background-color: #ffffff;
   }

   #zend-progressbar-done {
       width: 0;
       height: 30px;

       background-color: #000000;
   }

.. code-block:: javascript
   :linenos:

   function Zend\ProgressBar\Update(data)
   {
       document.getElementById('zend-progressbar-done').style.width =
           data.percent + '%';
   }

Ceci créera un simple conteneur avec une bordure noire et un bloc qui indique le niveau du processus courant. Vous
ne devez pas masquer l'*iframe* ou l'*object* par *display: none;*, car dans ce cas les navigateurs comme Safari 2
ne chargeront pas le contenu réel.

Plutôt que de créer votre barre de progression personnalisée, vous pouvez utiliser une de celles disponibles
dans les librairies JavaScript comme Dojo, jQuery etc. Par exemple, il existe :

- Dojo : `http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html`_

- jQuery : `http://t.wits.sg/2008/06/20/jquery-progress-bar-11/`_

- MooTools : `http://davidwalsh.name/dw-content/progress-bar.php`_

- Prototype : `http://livepipe.net/control/progressbar`_

.. note::

   **Intervalle de mise à jour**

   Vous devez faire attention à ne pas envoyer trop de mises à jour, puisque chaque mise à jour a une taille
   minimum de 1ko. Ceci est requis par le navigateur Safari pour rendre et exécuter l'appel de fonction. Internet
   Explorer possède une limitation similaire mais à 256 octets.



.. _`http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html`: http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html
.. _`http://t.wits.sg/2008/06/20/jquery-progress-bar-11/`: http://t.wits.sg/2008/06/20/jquery-progress-bar-11/
.. _`http://davidwalsh.name/dw-content/progress-bar.php`: http://davidwalsh.name/dw-content/progress-bar.php
.. _`http://livepipe.net/control/progressbar`: http://livepipe.net/control/progressbar
