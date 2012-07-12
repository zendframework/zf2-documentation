
Zend_Session_SaveHandler_DbTable
================================

The basic setup for ``Zend_Session_SaveHandler_DbTable`` must at least have four columns, denoted in the config array or ``Zend_Config`` object: primary, which is the primary key and defaults to just the session id which by default is a string of length 32; modified, which is the unix timestamp of the last modified date; lifetime, which is the lifetime of the session ( ``modified + lifetime > time();`` ); and data, which is the serialized data stored in the session

You can also use Multiple Columns in your primary key for ``Zend_Session_SaveHandler_DbTable`` .


