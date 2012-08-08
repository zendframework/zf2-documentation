.. EN-Revision: none
.. _zend.session.savehandler.dbtable:

Zend_Session_SaveHandler_DbTable
================================

ההתקנה הבסיסית של Zend_Session_SaveHandler_DbTable חייבת לכלול לפחות 4 עמודות,
המצויינים בקובץ ההגדרות/אובייקט ההגדרות: primary, אשר הוא המפתח
הראשי וכברירת מחדל מוגדר למזהה היחודי אשר בעצם סטרינג באורך 32
תווים; modified, אשר משמש בתור זמן בפורמט UNIX של התאריך עדכון האחרון;
lifetime, אשר משמש בתור תקופת החיים של ה session (modified + lifetime > time() ); data,
אשר משמש בתור המידע אשר נשמר בטבלה.

.. _zend.session.savehandler.dbtable.basic:

.. rubric:: שימוש בסיסי

.. code-block:: php
   :linenos:

   CREATE TABLE `session` (
     `id` char(32),
     `modified` int,
     `lifetime` int,
     `data` text,
     PRIMARY KEY (`id`)
   );


.. code-block:: php
   :linenos:

   //get your database connection ready
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'        =>'example.com',
       'username'    => 'dbuser',
       'password'    => '******',
       'dbname'    => 'dbname'
   ));

   //you can either set the Zend_Db_Table default adapter
   //or you can pass the db connection straight to the save handler $config
   Zend_Db_Table_Abstract::setDefaultAdapter($db);
   $config = array(
       'name'           => 'session',
       'primary'        => 'id',
       'modifiedColumn' => 'modified',
       'dataColumn'     => 'data',
       'lifetimeColumn' => 'lifetime'
   );

   //create your Zend_Session_SaveHandler_DbTable and
   //set the save handler for Zend_Session
   Zend_Session::setSaveHandler(new Zend_Session_SaveHandler_DbTable($config));

   //start your session!
   Zend_Session::start();

   //now you can use Zend_Session like any other time


ניתן גם להשתמש בכמה מפתחות ראשיים לכמה עמודות ב
Zend_Session_SaveHandler_DbTable.

.. _zend.session.savehandler.dbtable.multi-column-key:

.. rubric:: שימוש במפתח ראשי לכמה עמודות

.. code-block:: php
   :linenos:

   CREATE TABLE `session` (
       `session_id` char(32) NOT NULL,
       `save_path` varchar(32) NOT NULL,
       `name` varchar(32) NOT NULL DEFAULT '',
       `modified` int,
       `lifetime` int,
       `session_data` text,
       PRIMARY KEY (`Session_ID`, `save_path`, `name`)
   );


.. code-block:: php
   :linenos:

   //setup your DB connection like before
   //NOTE: this config is also passed to Zend_Db_Table so anything specific
   //to the table can be put in the config as well
   $config = array(
       'name'              => 'session', //table name as per Zend_Db_Table
       'primary'           => array(
           'session_id',   //the sessionID given by PHP
           'save_path',    //session.save_path
           'name',         //session name
       ),
       'primaryAssignment' => array( //you must tell the save handler which columns you
                                     //are using as the primary key. ORDER IS IMPORTANT
           'sessionId',          //first column of the primary key is of the sessionID
           'sessionSavePath',    //second column of the primary key is the save path
           'sessionName',        //third column of the primary key is the session name
       ),
       'modifiedColumn'    => 'modified',     //time the session should expire
       'dataColumn'        => 'session_data', //serialized data
       'lifetimeColumn'    => 'lifetime',     //end of life for a specific record
   );

   //Tell Zend_Session to use your Save Handler
   Zend_Session::setSaveHandler(new Zend_Session_SaveHandler_DbTable($config));

   //start your session
   Zend_Session::start();

   //use Zend_Session as normal



