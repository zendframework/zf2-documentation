.. _zend.ldap.ldif:

LDIFへ、または、からのLDAPデータシリアライズ
==========================

.. _zend.ldap.ldif.encode:

LDIFへのLDAP項目シリアライズ
------------------

.. code-block:: php
   :linenos:

   $data = array(
       'dn'                         => 'uid=rogasawara,ou=営業部,o=Airius',
       'objectclass'                => array('top',
                                             'person',
                                             'organizationalPerson',
                                             'inetOrgPerson'),
       'uid'                        => array('rogasawara'),
       'mail'                       => array('rogasawara@airius.co.jp'),
       'givenname;lang-ja'          => array('ロドニー'),
       'sn;lang-ja'                 => array('小笠原'),
       'cn;lang-ja'                 => array('小笠原 ロドニー'),
       'title;lang-ja'              => array('営業部 部長'),
       'preferredlanguage'          => array('ja'),
       'givenname'                  => array('ロドニー'),
       'sn'                         => array('小笠原'),
       'cn'                         => array('小笠原 ロドニー'),
       'title'                      => array('営業部 部長'),
       'givenname;lang-ja;phonetic' => array('ろどにー'),
       'sn;lang-ja;phonetic'        => array('おがさわら'),
       'cn;lang-ja;phonetic'        => array('おがさわら ろどにー'),
       'title;lang-ja;phonetic'     => array('えいぎょうぶ ぶちょう'),
       'givenname;lang-en'          => array('Rodney'),
       'sn;lang-en'                 => array('Ogasawara'),
       'cn;lang-en'                 => array('Rodney Ogasawara'),
       'title;lang-en'              => array('Sales, Director'),
   );
   $ldif = Zend_Ldap_Ldif_Encoder::encode($data, array('sort' => false,
                                                       'version' => null));
   /*
   $ldif contains:
   dn:: dWlkPXJvZ2FzYXdhcmEsb3U95Za25qWt6YOoLG89QWlyaXVz
   objectclass: top
   objectclass: person
   objectclass: organizationalPerson
   objectclass: inetOrgPerson
   uid: rogasawara
   mail: rogasawara@airius.co.jp
   givenname;lang-ja:: 44Ot44OJ44OL44O8
   sn;lang-ja:: 5bCP56yg5Y6f
   cn;lang-ja:: 5bCP56yg5Y6fIOODreODieODi+ODvA==
   title;lang-ja:: 5Za25qWt6YOoIOmDqOmVtw==
   preferredlanguage: ja
   givenname:: 44Ot44OJ44OL44O8
   sn:: 5bCP56yg5Y6f
   cn:: 5bCP56yg5Y6fIOODreODieODi+ODvA==
   title:: 5Za25qWt6YOoIOmDqOmVtw==
   givenname;lang-ja;phonetic:: 44KN44Gp44Gr44O8
   sn;lang-ja;phonetic:: 44GK44GM44GV44KP44KJ
   cn;lang-ja;phonetic:: 44GK44GM44GV44KP44KJIOOCjeOBqeOBq+ODvA==
   title;lang-ja;phonetic:: 44GI44GE44GO44KH44GG44G2IOOBtuOBoeOCh+OBhg==
   givenname;lang-en: Rodney
   sn;lang-en: Ogasawara
   cn;lang-en: Rodney Ogasawara
   title;lang-en: Sales, Director
   */

.. _zend.ldap.ldif.decode:

LDIF文字列をLDAP項目に非シリアライズ化
-----------------------

.. code-block:: php
   :linenos:

   $ldif = "dn:: dWlkPXJvZ2FzYXdhcmEsb3U95Za25qWt6YOoLG89QWlyaXVz
   objectclass: top
   objectclass: person
   objectclass: organizationalPerson
   objectclass: inetOrgPerson
   uid: rogasawara
   mail: rogasawara@airius.co.jp
   givenname;lang-ja:: 44Ot44OJ44OL44O8
   sn;lang-ja:: 5bCP56yg5Y6f
   cn;lang-ja:: 5bCP56yg5Y6fIOODreODieODi+ODvA==
   title;lang-ja:: 5Za25qWt6YOoIOmDqOmVtw==
   preferredlanguage: ja
   givenname:: 44Ot44OJ44OL44O8
   sn:: 5bCP56yg5Y6f
   cn:: 5bCP56yg5Y6fIOODreODieODi+ODvA==
   title:: 5Za25qWt6YOoIOmDqOmVtw==
   givenname;lang-ja;phonetic:: 44KN44Gp44Gr44O8
   sn;lang-ja;phonetic:: 44GK44GM44GV44KP44KJ
   cn;lang-ja;phonetic:: 44GK44GM44GV44KP44KJIOOCjeOBqeOBq+ODvA==
   title;lang-ja;phonetic:: 44GI44GE44GO44KH44GG44G2IOOBtuOBoeOCh+OBhg==
   givenname;lang-en: Rodney
   sn;lang-en: Ogasawara
   cn;lang-en: Rodney Ogasawara
   title;lang-en: Sales, Director";
   $data = Zend_Ldap_Ldif_Encoder::decode($ldif);
   /*
   $data = array(
       'dn'                         => 'uid=rogasawara,ou=営業部,o=Airius',
       'objectclass'                => array('top',
                                             'person',
                                             'organizationalPerson',
                                             'inetOrgPerson'),
       'uid'                        => array('rogasawara'),
       'mail'                       => array('rogasawara@airius.co.jp'),
       'givenname;lang-ja'          => array('ロドニー'),
       'sn;lang-ja'                 => array('小笠原'),
       'cn;lang-ja'                 => array('小笠原 ロドニー'),
       'title;lang-ja'              => array('営業部 部長'),
       'preferredlanguage'          => array('ja'),
       'givenname'                  => array('ロドニー'),
       'sn'                         => array('小笠原'),
       'cn'                         => array('小笠原 ロドニー'),
       'title'                      => array('営業部 部長'),
       'givenname;lang-ja;phonetic' => array('ろどにー'),
       'sn;lang-ja;phonetic'        => array('おがさわら'),
       'cn;lang-ja;phonetic'        => array('おがさわら ろどにー'),
       'title;lang-ja;phonetic'     => array('えいぎょうぶ ぶちょう'),
       'givenname;lang-en'          => array('Rodney'),
       'sn;lang-en'                 => array('Ogasawara'),
       'cn;lang-en'                 => array('Rodney Ogasawara'),
       'title;lang-en'              => array('Sales, Director'),
   );
   */


