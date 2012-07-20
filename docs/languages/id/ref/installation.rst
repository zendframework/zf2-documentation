.. _introduction.installation:

Instalasi
=========

Zend Framework membutuhkan PHP 5.1.4 atau yang lebih baru, walaupun Zend sangat merekomendasikan 5.2.3 atau yang
lebih baru dengan pertimbangan keamanan dan performansi yang ada pada versi terakhir. Anda dapat melihat lebih
detail di :ref:`lampiran kebutuhan <requirements>`.

Instalasi Zend Framework terbilang sangat mudah. Begitu anda mengunduh dan meng-ekstrak framework, anda tinggal
menambahkan folder /library pada include path di setting PHP anda. Atau bisa juga dengan memindahkan folder library
ini ke lokasi tertentu di filesystem anda yang bisa diakses skrip PHP. Selesai.



   - `Unduh versi stabil yang terkhir dirilis.`_ Versi ini tersedia dalam format *.zip* dan *.tar.gz*. Untuk anda
     yang baru menggunakan Zend Framework, versi ini adalah yang paling cocok buat anda.

   - `Unduh nighly snapshot versi terakhir.`_ Untuk anda yang ingin mengetahui komponen-komponen Zend Framework
     paling baru yang sedang dikembangkan namun belum dikategorikan stabil, nightly snapshot adalah tempatnya.
     Snapshot ini berisi selain komponen ZF juga disertai dokumentasi dalam bahasa Inggris atau bahasa lain yang
     tersedia.

   - Menggunakan program `Subversion`_ (SVN) client. Zend Framework adalah perangkat lunak open source, dan
     Subversion repository yang digunakan dalam pengembangannya dapat diakses oleh publik. Gunakan SVN jika anda
     sudah biasa menggunakan SVN untuk pengembangan aplikasi anda, atau ingin ikut berkontribusi dalam pengembangan
     ZF, atau sekedar meng-upgrade versi framework anda dengan yang paling terakhir.

     `Exporting`_ berguna jika anda ingin mendapatkan revisi framework tanpa direktori *.svn* di folder tempat anda
     bekerja.

     `Check out`_ untuk anda yang ingin berkontribusi dalam pengembangan Zend Framework, dan folder lokal tempat
     anda bekerja dapat diupdate kapanpun dengan `svn update`_.

     `External definition`_ untuk anda yang sudah terbiasa menggunakan SVN untuk mengelola folder lokal tempat anda
     bekerja.

     URL trunk dari repository SVN Zend Framework adalah `http://framework.zend.com/svn/framework/standard/trunk`_



Begitu anda sudah mendapatkan salinan Zend Framework, aplikasi anda harus dapat mengakses class-class di dalam
framework. Meskipun `ada berbagai cara untuk melakukan ini`_, setting `include_path`_ di PHP anda mesti menyertakan
path ke library Zend Framework.

Zend menyediakan artikel berisi `panduan cepat untuk mulai menggunakan Zend Framework`_. Artikel ini adalah tempat
yang cocok bagi anda yang baru mulai menggunakan Zend Framework, dengan penekanan pada kasus-kasus real yang sering
kita temui saat membangun aplikasi web.

Karena komponen-komponen Zend Framework didesain untuk dapat berjalan secara terpisah dan sendiri-sendiri, anda
mungkin menggunakan kombinasi yang unik dari komponen-komponen ini untuk keperluan aplikasi anda. Bab-bab
berikutnya akan menjelaskan secara komprehensif dari tiap-tiap komponen Zend Framework.



.. _`Unduh versi stabil yang terkhir dirilis.`: http://framework.zend.com/download
.. _`Unduh nighly snapshot versi terakhir.`: http://framework.zend.com/download/snapshot
.. _`Subversion`: http://subversion.tigris.org
.. _`Exporting`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.export.html
.. _`Check out`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.checkout.html
.. _`svn update`: http://svnbook.red-bean.com/nightly/en/svn.ref.svn.c.update.html
.. _`External definition`: http://svnbook.red-bean.com/nightly/en/svn.advanced.externals.html
.. _`http://framework.zend.com/svn/framework/standard/trunk`: http://framework.zend.com/svn/framework/standard/trunk
.. _`ada berbagai cara untuk melakukan ini`: http://www.php.net/manual/en/configuration.changes.php
.. _`include_path`: http://www.php.net/manual/en/ini.core.php#ini.include-path
.. _`panduan cepat untuk mulai menggunakan Zend Framework`: http://framework.zend.com/docs/quickstart
