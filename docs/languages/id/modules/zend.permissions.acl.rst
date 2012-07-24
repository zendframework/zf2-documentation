.. _zend.permissions.acl.introduction:

Pengenalan
==========

Zend\Permissions\Acl menyediakan implementasi access control list (ACL) untuk manajemen hak akses (privilege). Secara umum,
sebuah aplikasi dapat menggunakan ACL untuk mengontrol akses terhadap objek-objek yang terproteksi oleh objek yang
lain.

Untuk keperluan dokumentasi ini, berikut istilah-istilah yang perlu anda ketahui,



   - **resource** adalah sebuah objek yang dikontrol akses terhadapnya.

   - **role** adalah sebuah objek yang meminta akses ke resource.

Dengan kalimat sederhana, **role adalah objek yang meminta akses ke resource tertentu**. Sebagai ilustrasi, jika
pengguna parkir meminta akses ke sebuah mobil, maka pengguna parkir tersebut adalah role, sementara mobil adalah
resource, karena hak akses ke mobil tertentu tidak dimiliki semua orang.

Dengan spesifikasi dan penggunaan ACL, sebuah aplikasi dapat mengontrol bagaimana role diberikan hak untuk
mengakses resource tertentu.

.. _zend.permissions.acl.introduction.resources:

Tentang Resource
----------------

Membuat sebuah resource di Zend\Permissions\Acl sangat mudah. Zend\Permissions\Acl menyediakan interface *Zend\Permissions\Acl\Resource\ResourceInterface*
untuk memfasilitasi pembuatan resource dalam sebuah aplikasi. Sebuah class hanya perlu mengimplementasikan
interface ini, yang terdiri dari hanya sebuah method, *getResourceId()*, dan Zend\Permissions\Acl akan mengenali objek tersebut
sebagai sebuah resource. Zend\Permissions\Acl juga menyediakan *Zend\Permissions\Acl\Resource* sebagai implementasi dasar dari
*Zend\Permissions\Acl\Resource\ResourceInterface*, sehingga developer cukup meng-extend class ini sesuai kebutuhan.

Zend\Permissions\Acl menyediakan struktur pohon untuk menyimpan resource-resource. Karena struktur pohon ini, tiap resource
dapat diorganisasikan mulai dari yang umum (akar) sampai ke yang lebih spesifik (daun). Query pada resource
tertentu secara otomatis akan mencari aturan-aturan di hirarki resource mulai dari resource teratas (ancestor),
sehingga dimungkinkan untuk mewariskan aturan ke bawahnya dengan lebih mudah. Sebagai ilustrasi, jika sebuah role
defaultnya diterapkan pada seluruh bangunan di sebuah kota, maka akan lebih mudah jika role itu diterapkan terhadap
satu kota, bukannya terhadap tiap bangunan di dalam kota tersebut. Kalaupun misalnya beberapa bangunan perlu
pengecualian, Zend\Permissions\Acl cukup menetapkan pengecualian itu saja ke beberapa gedung. Sebuah resource dapat mewarisi
dari satu resource yang jadi parent-nya, sementara resource yang jadi parent ini bisa mewarisi dari resource di
atasnya, dan seterusnya.

Zend\Permissions\Acl juga mendukung hak akses istimewa (privilege) pada resource (mis: "create", "read", "update", "delete"),
sehingga developer dapat menetapkan aturan yang bisa mempengaruhi seluruh privilege atau sebagian privilege saja
pada satu atau lebih resource.

.. _zend.permissions.acl.introduction.roles:

Tentang Role
------------

Sebagaimana resource, membuat sebuah role juga sangat mudah. Semua role mesti mengimplementasikan
*Zend\Permissions\Acl\Role\RoleInterface*. Interface ini berisi sebuah method, *getRoleId()*. Zend\Permissions\Acl juga menyediakan
*Zend\Permissions\Acl\Role* sebagai implementasi dasar dari *Zend\Permissions\Acl\Role\RoleInterface*, sehingga developer cukup meng-extend
class ini sesuai kebutuhan.

Dalam Zend\Permissions\Acl, sebuah role dapat mewarisi aturan dari satu atau lebih role di atasnya (parent). Sebagai ilustrasi,
sebuah role user dengan nama "sally", mungkin milik dari satu atau lebih role yang lain yang jadi parent-nya,
seperti "editor" dan "administrator" misalnya. Developer dapat menetapkan aturan yang berbeda untuk "editor" dan
"administrator", dan "sally" akan mewarisi aturan tersebut dari keduanya, tanpa harus menetapkan aturan langsung ke
"sally".

Biarpun kemampuan mewariskan aturan antar role ini sangat berguna, namun terkdang pewarisan berlipat (multiple
inheritance) ini dapat menimbulkan kompleksitas yang tinggi. Contoh berikut memberi ilustrasi masalah pewarisan
yang menimbulkan kondisi ambiguitas dan bagaimana Zend\Permissions\Acl memecahkannya.

.. _zend.permissions.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: Multiple Inheritance di antara Role

Kode berikut mendefinisikan tiga role dasar - "*guest*", "*member*", dan "*admin*". Kemudian role dengan nama
"*someUser*" dibuat dan mewarisi ketiga role tadi. Hati-hati, urutan dimana ketiga role parent itu terlihat di
array *$parents* sangat penting. Ketika dibutuhkan, Zend\Permissions\Acl akan mencari aturan akses bukan hanya pada role yang
di-query (dalam hal ini "*someUser*"), tapi juga pada role yang mewarisinya (dalam hal ini "*guest*", "*member*",
dan "*admin*"):

.. code-block::
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('guest'))
       ->addRole(new Zend\Permissions\Acl\Role\GenericRole('member'))
       ->addRole(new Zend\Permissions\Acl\Role\GenericRole('admin'));

   $parents = array('guest', 'member', 'admin');
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('someUser'), $parents);

   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('someResource'));

   $acl->deny('guest', 'someResource');
   $acl->allow('member', 'someResource');

   echo $acl->isAllowed('someUser', 'someResource') ? 'allowed' : 'denied';


Karena tidak ada aturan spesifik yang didefinisikan untuk role "*someUser*" terhadap "*someResource*", Zend\Permissions\Acl
kemudian mencari aturan yang mungkin didefinisikan oleh parent dari "*someUser*". Pertama, Zend\Permissions\Acl mengunjungi
"*admin*", dan ternyata tidak ada aturan untuk resource "*someResource*" di sini. Selanjutnya, Zend\Permissions\Acl menuju
"*member*", dan Zend\Permissions\Acl menemukan ada aturan di situ yang menyatakan bahwa role "*member*" diperbolehkan mengakses
"*someResource*".

Kalau saja Zend\Permissions\Acl meneruskan pencariannya ke parent yang lain ("*guest*"), maka akan ditemui bahwa "*guest*"
tidak boleh mengakses "*someResource*". Ini menimbulkan ambiguitas, karena satu role ("*someUser*") jadi memiliki
dua aturan akses yang berlawanan, yaitu "allowed" dan "denied".

Zend\Permissions\Acl memecahkan ambiguitas ini dengan menghentikan pencarian ketika sudah ditemukan role yang memiliki aturan
akses yang ia cari. Dalam kasus ini, karena role "*member*" diperiksa sebelum role "*guest*", contoh di atas akan
mencetak keluaran "*allowed*".

.. note::

   Ketika anda menetapkan dua role atau lebih sebagai parent dari sebuah role, mesti diingat bahwa parent yang
   terakhir dalam daftar pencarian adalah yang pertama kali ditanya apakah ada aturan akses untuk resource yang
   diminta.

.. _zend.permissions.acl.introduction.creating:

Membuat Access Control List (ACL)
---------------------------------

Sebuah ACL dapat merepresentasikan objek apa saja, baik fisik maupun virtual. Namun sebagai demonstrasi, kita akan
coba membuat ACL untuk Content Management System (CMS) yang mengatur hak akses beberapa pihak terhadap area
tertentu. Untuk membuat objek ACL, kita cukup inisialisasi ACL dengan tanpa parameter seperti berikut:

.. code-block::
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();


.. note::

   Sampai developer menambahkan aturan "allow", Zend\Permissions\Acl akan menolak ("denied") akses untuk setiap privilege dari
   tiap resource oleh setiap role.

.. _zend.permissions.acl.introduction.role_registry:

Mendaftarkan Role
-----------------

CMS hampir selalu membutuhkan hirarki perizinan yang menentukan kemampuan user untuk menambah, mengubah atau
menghapus content. Umumnya CMS memiliki group 'Guest' yang hanya bisa mengakses demo, group 'Staff' yang melakukan
administrasi harian, group 'Editor' yang bertanggungjawab untuk mem-publish, mereview, mengarsip dan menghapus isi
tulisan, dan terakhir ada group 'Administrator' yang tugasnya mencakup semua tugas group tadi ditambah tugas
mengelola informasi-informasi sensitif, manajemen user, konfigurasi back-end dan export/backup data. Seluruh
perizinan ini dapat direpresentasikan dalam sebuah role registry, yang memungkinkan tiap group mewarisi hak akses
dari group 'parent', sekaligus menyediakan hak akses tertentu bagi group mereka sendiri. Perizinan ini dapat
diekspresikan sebagai berikut:

.. _zend.permissions.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: Access Control untuk Contoh CMS

   +-------------+------------------------+-----------------------+
   |Nama         |Hak Akses               |Mewarisi Hak Akses Dari|
   +=============+========================+=======================+
   |Guest        |View                    |N/A                    |
   +-------------+------------------------+-----------------------+
   |Staff        |Edit, Submit, Revise    |Guest                  |
   +-------------+------------------------+-----------------------+
   |Editor       |Publish, Archive, Delete|Staff                  |
   +-------------+------------------------+-----------------------+
   |Administrator|(bisa akses semuanya)   |N/A                    |
   +-------------+------------------------+-----------------------+

Untuk contoh kasus ini kita akan menggunakan *Zend\Permissions\Acl\Role*, walaupun sembarang objek yang mengimplementasikan
*Zend\Permissions\Acl\Role\RoleInterface* bisa digunakan. Group-group ini dapat ditambahkan ke role registry dengan cara berikut:

.. code-block::
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

   // Menambahkan group ke Role registry menggunakan Zend\Permissions\Acl\Role
   // Guest tidak mewarisi hak akses dari group lain
   $roleGuest = new Zend\Permissions\Acl\Role\GenericRole('guest');
   $acl->addRole($roleGuest);

   // Staff mewarisi hak akses dari guest
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('staff'), $roleGuest);

   /*
   Alternatif lain untuk kode di atas adalah seperti berikut:
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('staff'), 'guest');
   */

   // Editor mewarisi hak akses dari staff
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('editor'), 'staff');

   // Administrator tidak mewarisi hak akses dari group lain
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('administrator'));


.. _zend.permissions.acl.introduction.defining:

Mendefinisikan Access Control
-----------------------------

Sekarang di dalam ACL sudah ada role-role, berikutnya kita dapat menentukan bagaimana aturan akses tiap role
tersebut ke resource. Kalau anda perhatikan, kita belum mendefinsikan satupun resource dalam contoh kasus ini. Yang
sederhananya ini berarti semua aturan berlaku untuk semua resource, apapun itu. Ini karena Zend\Permissions\Acl menerapkan
aturan akses dari yang umum ke yang lebih spesifik dengan tujuan untuk meminimasi jumlah aturan yang mesti dibuat.
Ini dimungkinkan karena resource dan role mewarisi aturan yang didefinisikan di pendahulu-pendahulu mereka
sebelumnya.

.. note::

   Secara umum, Zend\Permissions\Acl mematuhi aturan tertentu jika dan hanya jika tidak ada aturan lain yang lebih spesifik.

Sebagai konsekuensi hal ini, kita dapat mendefinisikan seperangkat aturan yang kompleks dengan kode yang minimal.
Untuk contoh kasus kita di atas, berikut adalah kode untuk menerapkan aturan aksesnya:

.. code-block::
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

   $roleGuest = new Zend\Permissions\Acl\Role\GenericRole('guest');
   $acl->addRole($roleGuest);
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('staff'), $roleGuest);
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('editor'), 'staff');
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('administrator'));

   // Guest hanya boleh melihat (view) content
   $acl->allow($roleGuest, null, 'view');

   /*
   Kode di atas bisa juga ditulis:
   $acl->allow('guest', null, 'view');
   //*/

   // Staff mewarisi hak akses view dari guest, tapi juga perlu tambahan izin revise
   $acl->allow('staff', null, array('edit', 'submit', 'revise'));

   // Editor mewarisi izin view, edit, submit, dan revise dari
   // staff, tapi juga perlu tambahan izin delete
   $acl->allow('editor', null, array('publish', 'archive', 'delete'));

   // Administrator tidak mewarisi apa-apa, tapi memiliki semua hak akses
   $acl->allow('administrator');


Nilai *null* dalam method *allow()* di atas digunakan untuk mengindikasikan kalau aturan bersangkutan berlaku untuk
semua resource.

.. _zend.permissions.acl.introduction.querying:

Mengambil (Query) Aturan ACL
----------------------------

Sekarang kita sudah memiliki ACL yang fleksibel yang dapat digunakan untuk menentukan apakah pemohon memiliki akses
untuk melakukan fungsi tertentu dalam sebuah aplikasi web. Untuk mengambil (query) aturan ACL yang telah ditetapkan
sebelumnya cukup dengan menggunakan method *isAllowed()* seperti berikut:

.. code-block::
   :linenos:

   echo $acl->isAllowed('guest', null, 'view') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('staff', null, 'publish') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('staff', null, 'revise') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('editor', null, 'view') ?
        "allowed" : "denied";
   // allowed karena mewarisinya dari guest

   echo $acl->isAllowed('editor', null, 'update') ?
        "allowed" : "denied";
   // denied karena tidak ada aturan allow untuk 'update'

   echo $acl->isAllowed('administrator', null, 'view') ?
        "allowed" : "denied";
   // allowed karena administrator diperbolehkan mengakses apapun

   echo $acl->isAllowed('administrator') ?
        "allowed" : "denied";
   // allowed karena administrator diperbolehkan mengakses apapun

   echo $acl->isAllowed('administrator', null, 'update') ?
        "allowed" : "denied";
   // allowed karena administrator diperbolehkan mengakses apapun



