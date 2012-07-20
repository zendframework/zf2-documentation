.. _learning.layout.intro:

Introduction
============

Dans une application utilisant les couches Zend Framework *MVC*, vos scripts de vue ne seront que des blocs de
*HTML* concernant l'action demandée. Par exemple, une action "``/user/list``" mènerait vers un script de vue
itérant sur les utilisateurs en présentant une liste:

.. code-block:: php
   :linenos:

   <h2>Utilisateurs</h2>
   <ul>
       <?php if (!count($this->users)): ?>
       <li>Pas d'utilisateurs</li>
       <?php else: ?>
       <?php foreach ($this->users as $user): ?>
       <li>
           <?php echo $this->escape($user->fullname) ?>
           (<?php echo $this->escape($user->email) ?>)
       </li>
       <?php endforeach ?>
       <?php endif ?>
   </ul>

Comme c'est juste un bloc de code *HTML*, ce n'est pas une page valide, il manque le *DOCTYPE* et la balise
ouvrante *HTML* puis *BODY*. Quand seront-ils crées?

Dans les anciennes versions de Zend Framework, les développeurs créaient souvent des scripts de vue "header" et
"footer" qui servaient à cela. Ca fonctionnait certes, mais c'était difficile à refactoriser, ou pour appeler du
contenu provenant de plusieurs actions.

Le pattern `Two-Step View`_ solutionne beaucoup des problèmes indiqués. Avec, la vue "application" est crée en
premier, puis injectée dans une vue "page" ainsi présentée à l'utilisateur client. la vue de page peut être
imaginée comme un template global ou layout qui décrirait des éléments communs utilisés au travers de
multiples pages.

Dans Zend Framework, ``Zend_Layout`` implémente le pattern Two-Step View.



.. _`Two-Step View`: http://martinfowler.com/eaaCatalog/twoStepView.html
