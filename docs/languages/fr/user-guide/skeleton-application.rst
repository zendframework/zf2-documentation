.. _user-guide.skeleton-application:

#######################################
Démarrer: Un modèle d'application
#######################################

Pour construire notre , nous allons commencer avec le modèle
`ZendSkeletonApplication <https://github.com/zendframework/ZendSkeletonApplication>`_
disponible sur `github <https://github.com/>`_. Use Composer
(http://getcomposer.org) pour créer un nouveau projet "from scratch" avec
Zend Framework:

.. code-block:: bash

    php composer.phar create-project -s dev zendframework/skeleton-application path/to/install

.. note::

    Une autre possibilité pour installer le ZendSkeletonApplication est
    d'utiliser github.  Rendez vous sur
    https://github.com/zendframework/ZendSkeletonApplication et cliquez sur le
    bouton “Zip”. Cela ca télécharger un fichier avec un nom similaire à
    ``zendframework-ZendSkeletonApplication-zfrelease-2.0.0beta5-2-gc2c7315.zip``.

    Décompressez ce fichier dans le dossier de vos vhosts et renommez-le en
    ``zf2-tutorial``.

    ZendSkeletonApplication est configuré pour utiliser Composer
    (http://getcomposer.org) pour résoudre ses dépendances. Dans notre cas, la
    dépendance est Zend Framework 2 lui-même.

    Pour installer Zend Framework 2 dans notre application, nous entrons
    simplement:

    .. code-block:: bash

        php composer.phar self-update
        php composer.phar install

    depuis le dossier ``zf2-tutorial``. Cela prend quelques instants. Vous
    devriez voir une sortie ressemblant à:

    .. code-block:: bash

        Installing dependencies from lock file
        - Installing zendframework/zendframework (dev-master)
          Cloning 18c8e223f070deb07c17543ed938b54542aa0ed8

        Generating autoload files

.. note::

    Si vous voyez ce message:

    .. code-block:: bash

        [RuntimeException]
          The process timed out.

    c'est que votre connection est trop lente pour télécharger le package dans
    le temps imparti, et composer termine en "time out". Pour éviter cela,
    au lieu d'exécuter:

    .. code-block:: bash

        php composer.phar install

    vous pouvez exécuter:

    .. code-block:: bash

        COMPOSER_PROCESS_TIMEOUT=5000 php composer.phar install

Nous pouvons maintenant nous intéresser au virtual host.

Virtual host
------------

Vous devez créer un hôte virtuel Apache pour l'application et modifier votre
fichier hosts de sorte que http://zf2-tutorial.localhost serve ``index.php``
depuis le répertoire ``zf2-tutorial/public``.

Configurer l'hôte vrtuel est communément effectué dans les fichiers ``httpd.conf``
ou ``extra/httpd-vhosts.conf``. Si vous utilisez ``httpd-vhosts.conf``,
assurez-vous que ce fichier est inclus par le fichier principal ``httpd.conf``.
Quelques distributions Linux (ex: Ubuntu) préparent Apache de sorte que les
fichiers de configuration soient stockés dans le répertoire ``/etc/apache2`` et
créent un fichier par hôte virtuel dans le dossier ``/etc/apache2/sites-enabled``.
Dans ce cas, vous placerez le bloc de notre hôte virtuel dans le fichier
``/etc/apache2/sites-enabled/zf2-tutorial``.

Assurez-vous que ``NameVirtualHost`` est défini et similaire à “\*:80”, et
définissez alors un hôte virtuel avec ces quelques lignes:

.. code-block:: apache

    <VirtualHost *:80>
        ServerName zf2-tutorial.localhost
        DocumentRoot /path/to/zf2-tutorial/public
        SetEnv APPLICATION_ENV "development"
        <Directory /path/to/zf2-tutorial/public>
            DirectoryIndex index.php
            AllowOverride All
            Order allow,deny
            Allow from all
        </Directory>
    </VirtualHost>

Vérifiez que que vous avez bien modifié le fichier ``/etc/hosts`` ou
``c:\windows\system32\drivers\etc\hosts`` pour que ``zf2-tutorial.localhost``
soit mappé sur ``127.0.0.1``. Le site web est alors accessible à l'adresse
http://zf2-tutorial.localhost.

.. code-block:: txt

    127.0.0.1               zf2-tutorial.localhost localhost

Redémarrez le serveur web.
Si tout est correctement effectué, vous devriez voir un écran comme ceci:

.. image:: ../images/user-guide.skeleton-application.hello-world.png
    :width: 940 px

Pour tester que votre fichier ``.htaccess`` fonctionne, naviguez vers
http://zf2-tutorial.localhost/1234 et vous devriez voir ceci:

.. image:: ../images/user-guide.skeleton-application.404.png
    :width: 940 px

Si vous observez une erreur standard Apache 404 error, vous devez corriger votre
``.htaccess`` avant de continuer. Si vous utilisez IIS avec le module URL
Rewrite Module, importez les lignes suivantes:

.. code-block:: apache

    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [NC,L]

Vous avez maintenant une application de base en état de marche et nous pouvons
commencer à ajouter les spécificités de notre application.
