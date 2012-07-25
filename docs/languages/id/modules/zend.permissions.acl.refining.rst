.. _zend.permissions.acl.refining:

Kontrol Akses Yang Lebih Detail
===============================

.. _zend.permissions.acl.refining.precise:

Kontrol Akses Yang Presisi
--------------------------

Dasar-dasar ACL yang dijelaskan dalam :ref:`sub bab sebelumnya <zend.permissions.acl.introduction>` memperlihatkan bagaimana
berbagai hak akses diterapkan terhadap seluruh ACL (semua resource). Namun dalam prakteknya, kontrol akses sering
kali memiliki pengecualian-pengecualian dan beragam tingkat kompleksitas. Zend\Permissions\Acl memungkinkan anda mengantisipasi
hal-hal detail seperti ini dalam langkah jelas dan fleksibel.

Sebagai contoh, dalam kasus CMS kita sebelumnya, role 'staff' memiliki hak akses yang mencakup semua kebutuhan
user. Hanya saja, terkadang kita memerlukan group di bawah 'staff' yang bernama 'marketing' yang hanya bisa
mengakses "newsletter" dan berita terakhir ("latest news") di CMS.

Juga diinginkan agar 'staff' hanya dapat melihat ("view") berita ("news") tapi tidak boleh mengedit berita
terakhir. Dan terakhir, semua orang (termasuk administrator) mesti tidak bisa membuat arsip dari tiap berita
pengumumuman ("anountcement news") karena biasanya pengumuman seperti ini cuma berlaku 1-2 hari.

Pertama, kita perlu merevisi role registry untuk mangakomodir kebutuhan baru ini. Seperti sudah dijelaskan, group
'marketing' memiliki perizinan yang sama dengan 'staff', sehingga kita cukup mendefinisikan 'marketing' dengan
mewarisi perizinan dari 'staff':

.. code-block::
   :linenos:

   // Group baru bernama marketing yang mewarisi perizinan staff
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('marketing'), 'staff');


Berikutnya, kita memerlukan tiga buah resource yaitu "newsletter", "latest news", dan "announcement news":

.. code-block::
   :linenos:

   // membuat resource

   // newsletter
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('newsletter'));

   // news
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('news'));

   // latest news yang merupakan anak dari news
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('latest'), 'news');

   // announcement news yang merupakan anak dari news
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('announcement'), 'news');


Selanjutnya tinggal mendifinisikan aturan-aturan spesifik sesuai kebutuhan di atas ke dalam ACL:

.. code-block::
   :linenos:

   // Marketing bisa mempublish and mengarsip (archive) newsletter dan
   // berita terakhir
   $acl->allow('marketing',
               array('newsletter', 'latest'),
               array('publish', 'archive'));

   // Staff (dan juga marketing, sesuai pewarisan), tidak boleh
   // merevisi berita terakhir
   $acl->deny('staff', 'latest', 'revise');

   // Semua (termasuk administrator) tidak boleh
   // mengarsip berita pengumuman
   $acl->deny(null, 'announcement', 'archive');


Dari aturan baru yang sudah kita buat, kita bisa melakukan query seperti berikut:

.. code-block::
   :linenos:

   echo $acl->isAllowed('staff', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('staff', 'latest', 'publish') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('editor', 'announcement', 'archive') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('administrator', 'announcement', 'archive') ?
        "allowed" : "denied";
   // denied


.. _zend.permissions.acl.refining.removing:

Menghapus Aturan dari Kontrol Akses
-----------------------------------

Untuk menghapus satu atau lebih aturan dari ACL, anda cukup menggunakan method *removeAllow()* atau *removeDeny()*.
Seperti halnya *allow()* dan *deny()*, anda bisa menambahkan nilai *null* untuk mengindikasikan penghapusan aturan
itu berlaku terhadap semua role, resource dan atau hak akses:

.. code-block::
   :linenos:

   // Membuat staff (dan juga marketing karena pewarisan) menjadi
   // bisa merevisi berita terakhir
   $acl->removeDeny('staff', 'latest', 'revise');

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // allowed

   // Menghapus hak untuk mempublish dan mengarsip (archive) newsletter
   // dari marketing
   $acl->removeAllow('marketing',
                     'newsletter',
                     array('publish', 'archive'));

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('marketing', 'newsletter', 'archive') ?
        "allowed" : "denied";
   // denied


Hak akses dapat dimodifikasi secara spesifik untuk aksi tertentu (publish, archive) seperti ditunjukan di atas,
tapi nilai *null* pada hak akses akan menimpah modifikasi semacam itu:

.. code-block::
   :linenos:

   // kembali memperbolehkan marketing melakukan apapun terhadap
   // berita terakhir. Perhatikan kita tidak memasukan parameter terakhir pada allow()
   // yang berarti null, dan berarti ini berlaku untuk aksi apapun (publish, archive dll)
   $acl->allow('marketing', 'latest');

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('marketing', 'latest', 'anything') ?
        "allowed" : "denied";
   // allowed



