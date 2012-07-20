.. _introduction.installation:

************
Installation
************

Veuillez vous reporter à l'annexe concernant :ref:`la configuration système requise <requirements>` pour plus
d'informations.

Installer Zend Framework est extrêmement simple. Une fois que vous avez téléchargé et décompressé le
framework, vous devez ajouter le dossier "/library" de la distribution en début de votre chemin d'inclusion
("*include_path*"). Vous pouvez bien entendu aussi déplacer la librairie à tout autre position (partagée ou non)
dans votre arborescence de fichiers.

   - `Téléchargement de la dernière version stable :`_ Cette version, disponible à la fois au format *.zip* et
     au format *.tar.gz*, est un bon choix pour ceux qui débutent avec Zend Framework.

   - `Téléchargement du dernier cliché nocturne :`_ Pour ceux qui veulent être à l'avant-garde, les clichés
     nocturnes représentent le dernier progrès de développement de Zend Framework. Ces clichés sont empaquetés
     avec la documentation en anglais seulement ou dans toutes les langues disponibles. Si vous prévoyez de
     travailler avec les derniers développements de Zend Framework, considérez plutôt l'emploi d'un client
     subversion (SVN).

   - Utilisation d'un client `Subversion`_ (SVN) : Zend Framework est un logiciel open-source, et le référentiel
     Subversion utilisé pour son développement est disponible publiquement. Considérer l'utilisation de SVN pour
     récupérer Zend Framework si vous utilisez déjà SVN pour vos propres développements, si vous voulez
     contribuer à l'évolution du framework, ou si vous désirez mettre à jour votre version du framework plus
     souvent que les sorties stables.

     `L'exportation`_ est utile si vous souhaitez obtenir une révision particulière du framework sans les
     dossiers *.svn* créé dans une copie de travail.

     `L'extraction d'une copie de travail`_ est intéressante si vous contribuez à Zend Framework, et une copie de
     travail peut être mise à jour à n'importe quel moment avec `svn update`_ et les changements peuvent être
     livrés au référentiel SVN avec la commande `svn commit`_.

     Une `définition externe`_ est très pratique pour les développeurs utilisant déjà SVN pour gérer les
     copies de travail de leurs applications.

     L'URL du tronc du référentiel SVN de Zend Framework est :
     `http://framework.zend.com/svn/framework/standard/trunk`_



Une fois votre copie de Zend Framework disponible, votre application nécessite d'avoir accès aux classes du
framework. Bien qu'il y ait `plusieurs manières de réaliser ceci`_, votre `include_path`_ de PHP doit contenir le
chemin vers la bibliothèque de Zend Framework.

Zend fournit un `tutoriel de démarrage rapide ("QuickStart")`_ pour vous permettre de démarrer rapidement. Ceci
est une excellente manière pour commencer à apprendre le framework avec une présentation de cas concrets que
vous pourriez avoir à utiliser.

Puisque les composants de Zend Framework sont plutôt connectés de manière lâche, divers composants peuvent
être choisis pour un usage indépendant si nécessaire. Les chapitres suivants documente l'utilisation de Zend
Framework composant par composant.



.. _`Téléchargement de la dernière version stable :`: http://framework.zend.com/download/latest
.. _`Téléchargement du dernier cliché nocturne :`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`L'exportation`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`L'extraction d'une copie de travail`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`svn commit`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.commit.html
.. _`définition externe`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/standard/trunk`: http://framework.zend.com/svn/framework/trunk
.. _`plusieurs manières de réaliser ceci`: http://www.php.net/manual/fr/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/fr/ini.core.php#ini.include-path
.. _`tutoriel de démarrage rapide ("QuickStart")`: http://framework.zend.com/docs/quickstart
