.. _zend.barcode.objects.details:

Descrição dos códigos de barras embarcados
==========================================

Você encontrará abaixo informações detalhadas sobre todos os tipos de códigos de barras embarcados por padrão
com o Zend Framework.

.. _zend.barcode.objects.details.error:

Zend_Barcode_Object_Error
-------------------------

.. image:: ../images/zend.barcode.objects.details.error.png
   :width: 400
   :align: center

Este código de barras é um caso especial. É utilizado internamente para automaticamente renderizar uma exceção
capturada pelo componente ``Zend_Barcode``.

.. _zend.barcode.objects.details.code25:

Zend_Barcode_Object_Code25
--------------------------

.. image:: ../images/zend.barcode.objects.details.code25.png
   :width: 152
   :align: center

- **Nome:** Código 25 (ou Código 2 de 5 ou Código 25 Industrial)

- **Caracteres permitidos:**'0123456789'

- **Checksum:** opcional (módulo 10)

- **Comprimento:** variável

Não existem opções específicas para este código de barras.

.. _zend.barcode.objects.details.code25interleaved:

Zend_Barcode_Object_Code25interleaved
-------------------------------------

.. image:: ../images/zend.barcode.objects.details.int25.png
   :width: 101
   :align: center

Este código de barras estende ``Zend_Barcode_Object_Code25`` (Código 2 de 5), e tem os mesmos detalhes e
opções, e acrescenta o seguinte:

- **Nome:** Código 2 de 5 Intercalado

- **Caracteres permitidos:**'0123456789'

- **Checksum:** opcional (módulo 10)

- **Comprimento:** variável (sempre o mesmo número de caracteres)

As opções disponíveis incluem:

.. _zend.barcode.objects.details.code25interleaved.table:

.. table:: Opções do Zend_Barcode_Object_Code25interleaved

   +--------------+------------+-------------+-----------------------------------------------------------------+
   |Opção         |Tipo de Dado|Valor Padrão |Descrição                                                        |
   +==============+============+=============+=================================================================+
   |withBearerBars|Boolean     |FALSE        |Desenha uma barra grossa em cima e em baixo do código de barras. |
   +--------------+------------+-------------+-----------------------------------------------------------------+

.. note::

   Se o número de caracteres não for mesmo, o ``Zend_Barcode_Object_Code25interleaved`` adicionará
   automaticamente na frente do texto do código de barras os zeros faltantes.

.. _zend.barcode.objects.details.ean2:

Zend_Barcode_Object_Ean2
------------------------

.. image:: ../images/zend.barcode.objects.details.ean2.png
   :width: 41
   :align: center

Este código de barras estende ``Zend_Barcode_Object_Ean5`` (*EAN* 5), e tem os mesmos detalhes e opções, e
acrescenta o seguinte:

- **Nome:** *EAN*-2

- **Caracteres permitidos:**'0123456789'

- **Checksum:** utilizado apenas internamente, mas não exibido

- **Comprimento:** 2 caracteres

Não existem opções específicas para este código de barras.

.. note::

   Se o número de caracteres for menor que 2, o ``Zend_Barcode_Object_Ean2`` adicionará automaticamente na frente
   do texto do código de barras os zeros faltantes.

.. _zend.barcode.objects.details.ean5:

Zend_Barcode_Object_Ean5
------------------------

.. image:: ../images/zend.barcode.objects.details.ean5.png
   :width: 68
   :align: center

Este código de barras estende ``Zend_Barcode_Object_Ean13`` (*EAN* 13), e tem os mesmos detalhes e opções, e
acrescenta o seguinte:

- **Nome:** *EAN*-5

- **Caracteres permitidos:**'0123456789'

- **Checksum:** utilizado apenas internamente, mas não exibido

- **Comprimento:** 5 caracteres

Não existem opções específicas para este código de barras.

.. note::

   Se o número de caracteres for menor que 5, o ``Zend_Barcode_Object_Ean5`` adicionará automaticamente na frente
   do texto do código de barras os zeros faltantes.

.. _zend.barcode.objects.details.ean8:

Zend_Barcode_Object_Ean8
------------------------

.. image:: ../images/zend.barcode.objects.details.ean8.png
   :width: 82
   :align: center

Este código de barras estende ``Zend_Barcode_Object_Ean13`` (*EAN* 13), e tem os mesmos detalhes e opções, e
acrescenta o seguinte:

- **Nome:** *EAN*-8

- **Caracteres permitidos:**'0123456789'

- **Checksum:** obrigatório (módulo 10)

- **Comprimento:** 8 caracteres (incluindo o checksum)

Não existem opções específicas para este código de barras.

.. note::

   Se o número de caracteres for menor que 8, o ``Zend_Barcode_Object_Ean8`` adicionará automaticamente na frente
   do texto do código de barras os zeros faltantes.

.. _zend.barcode.objects.details.ean13:

Zend_Barcode_Object_Ean13
-------------------------

.. image:: ../images/zend.barcode.objects.details.ean13.png
   :width: 113
   :align: center

- **Nome:** *EAN*-13

- **Caracteres permitidos:**'0123456789'

- **Checksum:** obrigatório (módulo 10)

- **Comprimento:** 13 caracteres (incluindo o checksum)

Não existem opções específicas para este código de barras.

.. note::

   Se o número de caracteres for menor que 13, o ``Zend_Barcode_Object_Ean13`` adicionará automaticamente na
   frente do texto do código de barras os zeros faltantes.

   A opção ``withQuietZones`` não afeta este código de barras.

.. _zend.barcode.objects.details.code39:

Zend_Barcode_Object_Code39
--------------------------

.. image:: ../images/zend.barcode.introduction.example-1.png
   :width: 275
   :align: center

- **Nome:** Código 39

- **Caracteres permitidos:**'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ -.$/+%'

- **Checksum:** opcional (módulo 43)

- **Comprimento:** variável

.. note::

   ``Zend_Barcode_Object_Code39`` adicionará automaticamente no início e no fim o caractere ('\*').

Não existem opções específicas para este código de barras.

.. _zend.barcode.objects.details.identcode:

Zend_Barcode_Object_Identcode
-----------------------------

.. image:: ../images/zend.barcode.objects.details.identcode.png
   :width: 137
   :align: center

Este código de barras estende ``Zend_Barcode_Object_Code25interleaved`` (Código 2 de 5 Intercalado), e herda
algumas das suas capacidades, mas possui também suas próprias características.

- **Nome:** Identcode (Deutsche Post Identcode)

- **Caracteres permitidos:**'0123456789'

- **Checksum:** obrigatório (módulo 10 diferente do Código 25)

- **Comprimento:** 12 caracteres (incluindo o checksum)

Não existem opções específicas para este código de barras.

.. note::

   Se o número de caracteres for menor que 12, o ``Zend_Barcode_Object_Identcode`` adicionará automaticamente na
   frente do texto do código de barras os zeros faltantes.

.. _zend.barcode.objects.details.itf14:

Zend_Barcode_Object_Itf14
-------------------------

.. image:: ../images/zend.barcode.objects.details.itf14.png
   :width: 155
   :align: center

Este código de barras estende ``Zend_Barcode_Object_Code25interleaved`` (Código 2 de 5 Intercalado), e herda
algumas das suas capacidades, mas possui também suas próprias características.

- **Nome:** *ITF*-14

- **Caracteres permitidos:**'0123456789'

- **Checksum:** obrigatório (módulo 10)

- **Comprimento:** 14 caracteres (incluindo o checksum)

Não existem opções específicas para este código de barras.

.. note::

   Se o número de caracteres for menor que 14, o ``Zend_Barcode_Object_Itf14`` adicionará automaticamente na
   frente do texto do código de barras os zeros faltantes.

.. _zend.barcode.objects.details.leitcode:

Zend_Barcode_Object_Leitcode
----------------------------

.. image:: ../images/zend.barcode.objects.details.leitcode.png
   :width: 155
   :align: center

Este código de barras estende ``Zend_Barcode_Object_Identcode`` (Deutsche Post Identcode), e herda algumas das
suas capacidades, mas possui também suas próprias características.

- **Nome:** Leitcode (Deutsche Post Leitcode)

- **Caracteres permitidos:**'0123456789'

- **Checksum:** obrigatório (módulo 10 diferente do Código 25)

- **Comprimento:** 14 caracteres (incluindo o checksum)

Não existem opções específicas para este código de barras.

.. note::

   Se o número de caracteres for menor que 14, o ``Zend_Barcode_Object_Leitcode`` adicionará automaticamente na
   frente do texto do código de barras os zeros faltantes.

.. _zend.barcode.objects.details.planet:

Zend_Barcode_Object_Planet
--------------------------

.. image:: ../images/zend.barcode.objects.details.planet.png
   :width: 286
   :align: center

- **Nome:** Planet (PostaL Alpha Numeric Encoding Technique)

- **Caracteres permitidos:**'0123456789'

- **Checksum:** obrigatório (módulo 10)

- **Comprimento:** 12 ou 14 caracteres (incluindo o checksum)

Não existem opções específicas para este código de barras.

.. _zend.barcode.objects.details.postnet:

Zend_Barcode_Object_Postnet
---------------------------

.. image:: ../images/zend.barcode.objects.details.postnet.png
   :width: 286
   :align: center

- **Nome:** Postnet (POSTal Numeric Encoding Technique)

- **Caracteres permitidos:**'0123456789'

- **Checksum:** obrigatório (módulo 10)

- **Comprimento:** 6, 7, 10 ou 12 caracteres (incluindo o checksum)

Não existem opções específicas para este código de barras.

.. _zend.barcode.objects.details.royalmail:

Zend_Barcode_Object_Royalmail
-----------------------------

.. image:: ../images/zend.barcode.objects.details.royalmail.png
   :width: 158
   :align: center

- **Nome:** Royal Mail ou *RM4SCC* (Royal Mail 4-State Customer Code)

- **Caracteres permitidos:**'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

- **Checksum:** obrigatório

- **Comprimento:** variável

Não existem opções específicas para este código de barras.

.. _zend.barcode.objects.details.upca:

Zend_Barcode_Object_Upca
------------------------

.. image:: ../images/zend.barcode.objects.details.upca.png
   :width: 115
   :align: center

Este código de barras estende ``Zend_Barcode_Object_Ean13`` (*EAN*-13), e herda algumas das suas capacidades, mas
possui também suas próprias características.

- **Nome:** *UPC*-A (Universal Product Code)

- **Caracteres permitidos:**'0123456789'

- **Checksum:** obrigatório (módulo 10)

- **Comprimento:** 12 caracteres (incluindo o checksum)

Não existem opções específicas para este código de barras.

.. note::

   Se o número de caracteres for menor que 12, o ``Zend_Barcode_Object_Upca`` adicionará automaticamente na
   frente do texto do código de barras os zeros faltantes.

   A opção ``withQuietZones`` não afeta este código de barras.

.. _zend.barcode.objects.details.upce:

Zend_Barcode_Object_Upce
------------------------

.. image:: ../images/zend.barcode.objects.details.upce.png
   :width: 71
   :align: center

Este código de barras estende ``Zend_Barcode_Object_Upca`` (*UPC*-A), e herda algumas das suas capacidades, mas
possui também suas próprias características. O primeiro caractere do texto a ser codificado é o sistema (0 ou
1).

- **Nome:** *UPC*-E (Universal Product Code)

- **Caracteres permitidos:**'0123456789'

- **Checksum:** obrigatório (módulo 10)

- **Comprimento:** 8 caracteres (incluindo o checksum)

Não existem opções específicas para este código de barras.

.. note::

   Se o número de caracteres for menor que 8, o ``Zend_Barcode_Object_Upce`` adicionará automaticamente na frente
   do texto do código de barras os zeros faltantes.

.. note::

   Se o primeiro caractere do texto a ser codificado não for 0 ou 1, o ``Zend_Barcode_Object_Upce`` irá
   automaticamente substituí-lo por 0.

   A opção ``withQuietZones`` não afeta este código de barras.


