.. _user-guide.styling-and-translations:

#####################
Diseño y traducciones
#####################

Hemos tomado el diseño de nuestra SkeletonApplication, que está bien, pero necesitamos
cambiar el título y eliminar el mensaje de copyright.

ZendSkeletonApplication está montado para utilizar la funcionalidad de
traducción de ``Zend\I18n`` para todo el texto. Utiliza archivos ``.po`` que residen en
``application/language``, y usted necesita utilizar `poedit
<http://www.poedit.net/download.php/>`_ para cambiar el texto. Inicie poedit y
abra ``application/language/en_US.po``. Haga click en “Skeleton Application” en la lista
de strings ``Original`` y después escriba “Tutorial” como traducción.

.. image:: ../images/user-guide.styling-and-translations.poedit.png

Pulse Save en la barra de herramientas y poedit creará un archivo ``en_US.mo`` para nosotros.

Para eliminar el mensaje de copyright, necesitamos editar el script de vista ``layout.phtml``
del módulo ``Application``:

.. code-block:: php

    // module/Application/view/layout/layout.phtml:
    // Remove this line:
    <p>&copy; 2005 - 2012 by Zend Technologies Ltd. <?php echo $this->translate('All 
    rights reserved.') ?></p>

¡La página ahora tiene una apariencia ligeramente mejor!

.. image:: ../images/user-guide.styling-and-translations.translated-image.png
    :width: 940 px
