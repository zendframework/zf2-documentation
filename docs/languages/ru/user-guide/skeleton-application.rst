.. _user-guide.skeleton-application:

#################################
Начиная работу: каркас приложения
#################################

Работу над нашим приложением мы начнем с `ZendSkeletonApplication
<https://github.com/zendframework/ZendSkeletonApplication>`_,
доступным на `github <https://github.com/>`_. Перейдите по ссылке
https://github.com/zendframework/ZendSkeletonApplication и кликните
на кнопке “Zip”. Таким образом будет загружен файл с именем
``zendframework-ZendSkeletonApplication-zfrelease-2.0.0beta5-2-gc2c7315.zip``
или похожим.

Распакуйте этот файл в директории, где хранятся ваши виртуальные
хосты, и переименуйте распакованную директорию в ``zf2-tutorial``.

Для управления зависимостями ZendSkeletonApplication использует
Composer (http://getcomposer.org). При этом Zend Framework
2 сам является зависимостью.

Для установки Zend Framework 2 в нашем приложении мы просто пишем:

.. code-block:: bash

    php composer.phar self-update
    php composer.phar install

находясь внутри папки ``zf2-tutorial``. Это займет некоторое время.
Вы должны увидеть подобное сообщение:

.. code-block:: bash

    Installing dependencies from lock file
    - Installing zendframework/zendframework (dev-master)
      Cloning 18c8e223f070deb07c17543ed938b54542aa0ed8

    Generating autoload files

.. note::

    Если сообщение будет таким: 

    .. code-block:: bash

        [RuntimeException]      
          The process timed out. 

    значит ваше подключение слишком медленное для загрузки пакета целиком,
    и composer прерывает работу по тайм-ауту. Чтобы избежать этого, вместо:

    .. code-block:: bash

        php composer.phar install

    запустите:

    .. code-block:: bash

        COMPOSER_PROCESS_TIMEOUT=5000 php composer.phar install

Теперь мы можем перейти к настройке виртуального хоста.

Виртуальный хост
----------------

Вам потребуется создать виртуальный хост для будущего приложения и настроить
его таким образом, чтобы http://zf2-tutorial.localhost отправлял файл
``index.php`` из директории ``zf2-tutorial/public``.

Обычно настройка виртуального хоста происходит внутри файла ``httpd.conf``
или ``extra/httpd-vhosts.conf``. Если вы используете ``httpd-vhosts.conf``,
убедитесь, что он включен в главный файл ``httpd.conf``. В некоторых Linux
дистрибутивах (например, Ubuntu) пакет веб-сервера называется Apache, так
что конфигурационные файлы хранятся в /etc/apache2, а для каждого виртуального
хоста создается отдельный файл в /etc/apache2/sites-enabled. В этом случае
приведенную ниже конфигурацию сохраните в файл /etc/apache2/sites-enabled/zf2-tutorial.

Убедитесь, что ``NameVirtualHost`` определен и установлен в значение
“\*:80” или похожее, а затем настройте виртуальный хост используя
следующее определение:

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

Не забудьте обновить ваш ``/etc/hosts`` или
``c:\windows\system32\drivers\etc\hosts`` таким образом, чтобы хост
``zf2-tutorial.localhost`` соответствовал адресу ``127.0.0.1``. В дальнейшем
веб-сайт будет доступен по ссылке http://zf2-tutorial.localhost.

.. code-block:: txt

    127.0.0.1               zf2-tutorial.localhost localhost

Если вы все сделаете правильно, результат должен выглядеть примерно так:

.. image:: ../images/user-guide.skeleton-application.hello-world.png
    :width: 940 px

Чтобы проверить работоспособность вашего ``.htaccess``, перейдите по
ссылке http://zf2-tutorial.localhost/1234, вы должны увидеть что-то вроде:

.. image:: ../images/user-guide.skeleton-application.404.png
    :width: 940 px

Если вы увидите страндартную 404 страницу Apache, проверьте правильность
настройки ``.htaccess``.

Теперь, когда у вас есть работающий каркас, мы можем начать работу над
приложением.
