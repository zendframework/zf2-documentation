.. _zend.permissions.acl.advanced:

Penggunaan Tingkat Lanjut
=========================

.. _zend.permissions.acl.advanced.storing:

Menyimpan data ACL
------------------

Zend\Permissions\Acl didesain sedemikian rupa sehingga ia tidak bergantung pada teknologi backend seperti database atau server
cache untuk menyimpan data ACL. Zend\Permissions\Acl sepenuhnya diimplementasikan dalam kode PHP sehingga perangkat
administrasi lainnya (seperti penyimpanan data ACL) dapat dibangun di atasnya dengan relatif mudah dan fleksibel.
Sebab terkadang kita perlu mengelola ACL ini secara interaktif, tidak persistence seperti halnya kalau kita
menyimpan dalam database. Untuk itu Zend\Permissions\Acl menyediakan method untuk melakukan setup dan query ACL dari aplikasi
secara dinamis.

Dengan kata lain, penyimpanan data ACL diserahkan sepenuhnya kepada developer, karena penggunaan tempat penyimpanan
data ACL sangat beragam dan berbeda untuk tiap aplikasi. Yang jelas, objek Zend\Permissions\Acl dapat diserialisasikan, dan
dengan menggunakan fungsi `serialize()`_ di PHP, anda dapat menyimpan hasil keluarannya ke tempat penyimpanan
sesuai keinginan anda. Bisa ke dalam file, database atau mekanisme caching.

.. _zend.permissions.acl.advanced.assertions:

Aturan Kondisional ACL dengan Assertion
---------------------------------------

Terkadang aturan ACL untuk memperbolehkan atau melarang akses ke resource tertentu tidak absolut melainkan
bergantung pada beberapa kondisi. Misalnya sebuah resource bisa diakses oleh role tertentu, tapi hanya antara jam
8.00 pagi sampai jam 5.00 sore. Contoh kasus lain adalah resource tertentu tidak bisa diakses oleh pengunjung
dengan IP tertentu karena sudah ditandai sebagai sumber ancaman. Zend\Permissions\Acl memiliki dukungan built-in untuk
mengimplementasikan aturan kondisional seperti ini.

Penerapan aturan kondisional seperti ini (atau assertion) dilakukan dengan menggunakan *Zend\Permissions\Acl\Assert\AssertInterface*.
Untuk menggunakan interface ini, developer harus membuat sebuah class terlebih dahulu yang mengimplementasikan
method *assert()* dari interface tersebut:

.. code-block::
   :linenos:

   class CleanIPAssertion implements Zend\Permissions\Acl\Assert\AssertInterface
   {
       public function assert(Zend\Permissions\Acl $acl,
                              Zend\Permissions\Acl\Role\RoleInterface $role = null,
                              Zend\Permissions\Acl\Resource\ResourceInterface $resource = null,
                              $privilege = null)
       {
           return $this->_isCleanIP($_SERVER['REMOTE_ADDR']);
       }

       // di sini dibuat mekanisme untuk memeriksa apakah $ip
       // tergolong aman dan tidak masuk dalam daftar blacklist
       // keluaran: true jika aman, false jika tidak aman
       protected function _isCleanIP($ip)
       {
               // ...
       }
   }


Setelah class assertion ini siap, anda tinggal menambahkan instance class tersebut dalam penentuan aturan ACL.
Aturan yang disertai class assertion seperti ini hanya berlaku jika class assertion mengeluarkan nilai *true*
(benar).

.. code-block::
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();
   $acl->allow(null, null, null, new CleanIPAssertion());


Kode di atas membuat aturan yang memperbolehkan siapapun untuk melakukan apapun pada semua resource, kecuali ketika
orang tersebut menggunakan IP yang masuk daftar blacklist. Ini karena jika class assert bernilai *false* (IP masuk
daftar blacklist) maka aturan jadi tidak berlaku, yang artinya semua akses ditolak. Mesti anda fahami, ini adalah
kasus spesial. Karena kita memberi nilai *null* pada parameter masukan (ingat kembali sifat Zend\Permissions\Acl di :ref:`sub
bab sebelumnya <zend.permissions.acl.introduction>` yang default-nya menolak semua role untuk mengakses semua resource). Namun
jika anda menetapkan aturan tertentu pada role, resource dan/atau hak akses tertentu, maka class assert yang
bernilai *false* hanya akan membuat aturan itu saja yang tidak berlaku, sementara aturan lain yang mungkin ada
tetap berlaku.

Perhatikan di method *assert()* dari objek assertion di atas. ACL, role, resource dan hak akses (privilege)
digunakan sebagai parameter masukannya. Ini memungkinkan anda untuk menentukan bilamana class assertion yang anda
buat diberlakukan terhadap ACL, role, resource dan hak akses tertentu.



.. _`serialize()`: http://php.net/serialize
