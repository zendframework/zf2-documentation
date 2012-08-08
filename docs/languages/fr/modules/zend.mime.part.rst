.. EN-Revision: none
.. _zend.mime.part:

Zend_Mime_Part
==============

.. _zend.mime.part.introduction:

Introduction
------------

Cette classe représente une seule partie d'un message *MIME*. Elle contient le contenu actuel de la partie du
message ainsi que des informations sur son encodage, le type de contenu ("content-type") et le nom de fichier
original. Elle fournie une méthode pour générer une chaîne de caractères à partir des données stockées. Les
objets ``Zend_Mime_Part`` peuvent-être ajoutés à :ref:`Zend_Mime_Message <zend.mime.message>` pour assembler un
message multipart complet.

.. _zend.mime.part.instantiation:

Instanciation
-------------

``Zend_Mime_Part`` est instanciée avec une chaîne de caractères qui représente le contenu de cette nouvelle
partie. Le type doit être *OCTET-STREAM*, et l'encodage 8 bits. Après instanciation de ``Zend_Mime_Part``, les
métas-informations peuvent être définies en accédant directement aux attributs :

.. code-block:: php
   :linenos:

   public $type = Zend_Mime::TYPE_OCTETSTREAM;
   public $encoding = Zend_Mime::ENCODING_8BIT;
   public $id;
   public $disposition;
   public $filename;
   public $description;
   public $charset;
   public $boundary;
   public $location;
   public $language;

.. _zend.mime.part.methods:

Méthodes pour retourner la partie du message en une chaîne de caractères
------------------------------------------------------------------------

``getContent()`` retourne le contenu encodé de MimePart en une chaîne de caractères en utilisant l'encodage
spécifié dans l'attribut ``$encoding``. Les valeurs valides sont ``Zend_Mime::ENCODING_*``, les conversions de
jeux de caractères ne sont pas effectuées.

``getHeaders()`` retourne les Mime-Headers d'un MimePart générés à partir des attributs accessibles
publiquement. Les attributs de l'objet doivent être paramétrés correctement avant que cette méthode ne soit
appelée.

   - ``$charset`` doit définir l'encodage actuel du contenu, si c'est un type texte (Texte ou HTML).

   - ``$id`` doit être défini pour identifier un content-id pour les images d'un mail HTML.

   - ``$filename`` contient le nom que le fichier aura lors de son téléchargement.

   - ``$disposition`` définit si le fichier doit être traité comme une pièce jointe ou s'il est inclus dans le
     mail (HTML).

   - ``$description`` sert uniquement pour information.

   - ``$boundary`` définit une chaîne en tant que limite.

   - ``$location`` peut être utilisé comme *URI* d'une ressource *URI* qui a une relation avec le contenu.

   - ``$language`` définit la langue du contenu.




