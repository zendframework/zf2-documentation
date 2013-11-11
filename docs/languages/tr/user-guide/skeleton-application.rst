.. _user-guide.skeleton-application:

###########################
Başlangıç: İskelet Uygulama
###########################

Uygulamamızı oluşturabilmek için `github <https://github.com/>`_'ta mevcut olan
`ZendSkeletonApplication <https://github.com/zendframework/ZendSkeletonApplication>`_
ile başlayacağız. https://github.com/zendframework/ZendSkeletonApplication adresine
gidin ve “Zip” butonuna tıklayın. Bu işlem adı
``zendframework-ZendSkeletonApplication-zfrelease-2.0.0beta5-2-gc2c7315.zip``
benzeri olan bir dosyayı bilgisayarınıza indirmenize yarayacak.

Bu dosyayı vhostlarınızı sakladığınız dizine çıkartın (unzip) ve oluşturulan dosyanın
adını ``zf2-tutorial`` olarak değiştirin

ZendSkeletonApplication, gerekliliklerini edinebilmek için Composer
(http://getcomposer.org) ile kullanıma uygun olarak ayarlanmıştır. Bu durumda gereklilik
Zend Framework 2’nin kendisidir.

Uygulamanıza Zend Framework 2’yi kurmak için ``zf2-tutorial`` dizini içinde konsola:

.. code-block:: bash

    php composer.phar self-update
    php composer.phar install

yazın. Bu işlem biraz zaman alacak. Aşağıdakine benzer bir çıktı göreceksiniz:

.. code-block:: bash

    Installing dependencies from lock file
    - Installing zendframework/zendframework (dev-master)
      Cloning 18c8e223f070deb07c17543ed938b54542aa0ed8

    Generating autoload files

.. note::

    Eğer aşağıdaki mesajı görürseniz:

    .. code-block:: bash

        [RuntimeException]
          The process timed out.

    Bağlantınız gerekli paketi zamanında indirebilmek için çok yavaş ve composer’ın süresi
    doldu demektir. Bundan kaçınmak için aşağıdaki komutu çalıştırmak yerine:

    .. code-block:: bash

        php composer.phar install

    Aşağıdaki komutu çalıştırın:

    .. code-block:: bash

        COMPOSER_PROCESS_TIMEOUT=5000 php composer.phar install

Artık Sanal Sunucuya (Virtual Host) geçebiliriz.

Sanal Sunucu (Virtual host)
---------------------------

Şimdi http://zf2-tutorial.localhost adresinin ``zf2-tutorial/public`` dizinindeki
``index.php`` dosyasına bağlanması için bir Apache Virtual Host oluşturmanız gerekecek.

Sanal sunucu oluşturmak genelde ``httpd.conf`` veya ``extra/httpd-vhosts.conf```
dosyasında yapılır. Eğer ``httpd-vhosts.conf`` dosyasını kullanıyorsanız,
``httpd.conf`` içinde bu dosyanın çağırıldığına emin olun. Bazı Linux sürümleri
(örn: Ubuntu) Apache’yi paketler. Böylelikle konfigürasyon dosyaları ``/etc/apache2``
içinde depolanır ve her sanal sunucu için ``/etc/apache2/sites-enabled`` dizininde
ayrı bir dosya oluşturulabilir. Bu durumda sanal sunucu bloğunu
``/etc/apache2/sites-enabled/zf2-tutorial`` dizinine yerleştireceksiniz.

``NameVirtualHost``’un tanımlanmış ve “\*:80” ya da benzeri olarak ayarlanmıl
olduğuna emin olun ve aşağıdaki satırlarla bir sanal sunucu tanımlayın

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

``zf2-tutorial.localhost`` adresinin ``127.0.0.1`` IP adresine yönlendirilmesini
sağlamak için ``/etc/hosts`` veya ``c:\windows\system32\drivers\etc\hosts``
dosyanızı güncellemeyi unutmayın. İşlemler başarı ile tamamlandığında
http://zf2-tutorial.localhost adresi ulaşılabilir olacak.

.. code-block:: txt

    127.0.0.1               zf2-tutorial.localhost localhost

Eğer doğru şekilde yaptıysanız aşağıdakine benzer bir ekran karşınıza çıkacak:

.. image:: ../images/user-guide.skeleton-application.hello-world.png
    :width: 940 px

``.htaccess`` çalışıp çalışmadığını test etmek için http://zf2-tutorial.localhost/1234
adresini açmaya çalıştığınızda aşağıdaki gibi bir ekran göreceksiniz:

.. image:: ../images/user-guide.skeleton-application.404.png
    :width: 940 px

Eğer Apache 404 sayfası görürseniz, devam etmeden önce ``.htaccess`` kullanımını
düzeltmeniz gerekecek. Eğer URL Rewrite modüllü bir ISS kullanıyorsanız,
aşağıdakini ekleyin:

.. code-block:: apache

    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteRule ^ index.php [NC,L]

Artık çalışan bir iskelet uygulamaya sahipsiniz ve uygulamamız için özellikleri
eklemeye başlayabiliriz.
