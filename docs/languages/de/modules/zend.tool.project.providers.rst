.. _zend.tool.project.providers:

Project Provider für Zend_Tool
==============================

Anbei ist eine Tabelle aller Provider die mit ``Zend_Tool_Project`` ausgeliefert werden.

.. _zend.tool.project.project-provider:

.. table:: Optionen des Project Providers

   +-------------+---------------------+--------------------------------------------------------+----------------------------------------------------------------------------------+
   |Provider Name|Vorhandene Aktionen  |Parameter                                               |CLI Verwendung                                                                    |
   +=============+=====================+========================================================+==================================================================================+
   |Controller   |Create               |create = [name, indexActionIncluded=true]               |zf create controller foo                                                          |
   +-------------+---------------------+--------------------------------------------------------+----------------------------------------------------------------------------------+
   |Action       |Create               |create - [name, controllerName=index, viewIncluded=true]|zf create action bar foo (oder zf create action --name bar --controlller-name=foo)|
   +-------------+---------------------+--------------------------------------------------------+----------------------------------------------------------------------------------+
   |Controller   |Create               |create - [name, indexActionIncluded=true]               |zf create controller foo                                                          |
   +-------------+---------------------+--------------------------------------------------------+----------------------------------------------------------------------------------+
   |Profile      |Show                 |show - []                                               |zf show profile                                                                   |
   +-------------+---------------------+--------------------------------------------------------+----------------------------------------------------------------------------------+
   |View         |Create               |create - [controllerName,actionNameOrSimpleName]        |zf create view foo bar (oder zf create view -c foo -a bar)                        |
   +-------------+---------------------+--------------------------------------------------------+----------------------------------------------------------------------------------+
   |Test         |Create Enable Disable|create - [libraryClassName]                             |zf create test My_Foo_Bazzf disable testzf enable test                            |
   +-------------+---------------------+--------------------------------------------------------+----------------------------------------------------------------------------------+


