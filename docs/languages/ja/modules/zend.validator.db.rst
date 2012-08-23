.. EN-Revision: none
.. _zend.validator.Db:

Db_RecordExists および Db_NoRecordExists
=====================================

``Zend_Validate_Db_RecordExists`` および ``Zend_Validate_Db_NoRecordExists`` は、
データベースのテーブル上に
指定した値のレコードが存在するかどうかを調べる手段を提供します。

.. _zend.validator.set.db.options:

Supported options for Zend_Validate_Db_*
----------------------------------------

The following options are supported for ``Zend_Validate_Db_NoRecordExists`` and ``Zend_Validate_Db_RecordExists``:

- **adapter**: The database adapter which will be used for the search.

- **exclude**: Sets records which will be excluded from the search.

- **field**: The database field within this table which will be searched for the record.

- **schema**: Sets the schema which will be used for the search.

- **table**: The table which will be searched for the record.

.. _zend.validator.db.basic-usage:

基本的な使用法
-------

このバリデータの基本的な使用例です。

.. code-block:: php
   :linenos:

   // メールアドレスがデータベース内に存在するかどうかを調べます
   $validator = new Zend_Validate_Db_RecordExists(
       array(
           'table' => 'users',
           'field' => 'emailaddress'
       )
   );
   if ($validator->isValid($emailaddress)) {
       // メールアドレスは有効なようです
   } else {
       // メールアドレスが無効なので、その理由を表示します
       foreach ($validator->getMessages() as $message) {
           echo "$message\n";
       }
   }

上の例は、指定したメールアドレスがデータベースのテーブル内に存在するかどうかを調べます。
指定したカラムの値が ``$emailaddress`` に一致するレコードがなければ、
エラーメッセージが表示されます。

.. code-block:: php
   :linenos:

   // ユーザ名がデータベースに存在しないことを調べます
   $validator = new Zend_Validate_Db_NoRecordExists(
       array(
           'table' => 'users',
           'field' => 'username'
       )
   );
   if ($validator->isValid($username)) {
       // ユーザ名は有効なようです
   } else {
       // ユーザ名が無効なので、その理由を表示します
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

上の例は、指定したユーザ名がデータベースのテーブル上に存在しないことを確認します。
指定したカラムの値が ``$username`` に一致するレコードが見つかれば、
エラーメッセージが表示されます。

.. _zend.validator.db.excluding-records:

レコードの除外
-------

``Zend_Validate_Db_RecordExists`` および ``Zend_Validate_Db_NoRecordExists`` には、
テーブルの一部を除外してその内容を調べる方法があります。 where
句を文字列で指定するか、あるいはキー "field" および "value"
を含む配列を指定します。

除外条件を配列で指定すると、 *!=* 演算子を使用します。
つまり、テーブル内の残りのレコードの内容を確認してからレコードを変更できるのです
(たとえばユーザ情報のフォームなどで使用します)。

.. code-block:: php
   :linenos:

   // そのユーザ名のユーザがほかにいないことを調べます
   $user_id   = $user->getId();
   $validator = new Zend_Validate_Db_NoRecordExists(
       array(
           'table' => 'users',
           'field' => 'username',
           'exclude' => array(
               'field' => 'id',
               'value' => $user_id
           )
       )
   );

   if ($validator->isValid($username)) {
       // ユーザ名は有効なようです
   } else {
       // ユーザ名が無効なので、その理由を表示します
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

上の例は、 *id = $user_id* であるレコードを除いてそのテーブル内に $username
を含むレコードが存在しないことを調べます。

除外条件を文字列で指定することもできるので、 *!=*
以外の演算子を指定することもできます。
これは、複合キーに対するチェックの際に便利です。

.. code-block:: php
   :linenos:

   $post_id   = $post->getId();
   $clause    = $db->quoteInto('post_id = ?', $category_id);
   $validator = new Zend_Validate_Db_RecordExists(
       array(
           'table'   => 'posts_categories',
           'field'   => 'post_id',
           'exclude' => $clause
       )
   );

   if ($validator->isValid($username)) {
       // ユーザ名は有効なようです
   } else {
       // ユーザ名が無効なので、その理由を表示します
       $messages = $validator->getMessages();
       foreach ($messages as $message) {
           echo "$message\n";
       }
   }

上の例は、 *posts_categories* テーブル内に *post_id* の値が ``$category_id``
に一致するレコードがあることを調べます。

.. _zend.validator.db.database-adapters:

データベースアダプタ
----------

アダプタを指定することもできます。
複数のデータベースアダプタを使用している場合や
デフォルトのアダプタを設定していない場合などにこれを使用します。
以下に例を示します。

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Db_RecordExists(
       array(
           'table' => 'users',
           'field' => 'id',
           'adapter' => $dbAdapter
       )
   );

.. _zend.validator.db.database-schemas:

データベーススキーマ
----------

データベース内のスキーマを PostgreSQL や DB/2 のアダプタで指定するには、キー *table*
および *schema* を持つ配列を次の例のように渡します。 below:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Db_RecordExists(
       array(
           'table'  => 'users',
           'schema' => 'my',
           'field'  => 'id'
       )
   );


