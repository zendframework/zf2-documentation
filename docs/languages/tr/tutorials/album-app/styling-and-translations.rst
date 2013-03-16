.. _user-guide.styling-and-translations:

##########################
Sitilize Etme ve Çeviriler
##########################

SkeletonApplication’un sitilizasyonunu aldık ki bu iyi. Fakat dili türkçeye
çevirmemiz, başlığı değiştirmemiz ve copyright mesajını silmemiz gerekiyor.

İlk önce dili Türkçeye çevirebilmek için ``Application`` modülünün
``module.config.php`` dosyasını düzenlememiz gerekiyor. ``module.config.php``
dosyasını açın ve ``translator`` tanımlaması içindeki ``locale`` tanımlamasının
değerini ``tr_TR`` olarak değiştirin.

.. code-block:: php
    :emphasize-lines: 2

    'translator' => array(
        'locale' => 'tr_TR',
        'translation_file_patterns' => array(
            array(
                'type'     => 'gettext',
                'base_dir' => __DIR__ . '/../language',
                'pattern'  => '%s.mo',
            ),
        ),
    ),

ZendSkeletonApplication ``Zend\I18n``’nin çeviri fonksiyonelliğini
bütün yazılar için kullanıyor. Bu komponent ``Application/language`` dizinindeki
``.po`` dosyalarını kullanıyor ve yazıları değiştirmek/eklemek için
`poedit <http://www.poedit.net/download.php>`_ kullanabilirsiniz. Poedit’i
çalıştırın ve ``application/language/tr_TR.po`` dosyasını açın. Listedeki
“Skeleton Application”’a tıklayarak ``Orjinal`` string’lere ulaşabilirsiniz ve
sonra çeviri için “Tutorial” yazın.

.. image:: ../images/user-guide.styling-and-translations.poedit.png

Araç çubuğundaki Kaydet (Save) butonuna basın. Bu işlem bizim için ``tr_TR.mo``
dosyasını oluşturacaktır. Eğer herhangi bir ``.mo`` dosyası oluşmadığını fark
ederseniz, ``Preferences -> Editor -> Behavior`` kısmına gidip
``Automatically compile .mo file on save`` isimli kısımın işaretli olduğuna
emin olun.

Copyright mesajını silmek için ``Application`` modülünün ``layout.phtml`` view
scriptini düzenlememiz gerekiyor:

.. code-block:: php

    // module/Application/view/layout/layout.phtml:
    // Bu satırı silin:
    <p>&copy; 2005 - 2012 by Zend Technologies Ltd. <?php echo $this->translate('All 
    rights reserved.') ?></p>

Artık sayfa biraz daha iyi gözüküyor!

.. image:: ../images/user-guide.styling-and-translations.translated-image.png
    :width: 940 px
