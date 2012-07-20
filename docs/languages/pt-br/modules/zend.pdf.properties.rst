.. _zend.pdf.info:

Informação do Documento e Metadados
===================================

Um documento *PDF* deve incluir informações gerais como o título do documento, autor, e datas de criação e
modificação.

Historicamente essas informações são armazenadas com o uso de estruturas especiais. Esta estrutura está
disponível para leitura e escrita como uma matriz associativa usando a propriedade pública *properties* dos
objetos ``Zend_Pdf``:

.. code-block:: php
   :linenos:

   $pdf = Zend_Pdf::load($pdfPath);

   echo $pdf->properties['Title'] . "\n";
   echo $pdf->properties['Author'] . "\n";

   $pdf->properties['Title'] = 'Novo Título.';
   $pdf->save($pdfPath);

As seguintes chaves são definidas pelo padrão *PDF* v1.4 (Acrobat 5):



   - **Title**- string, opcional, o título do documento.

   - **Author**- string, opcional, o nome da pessoa que criou o documento.

   - **Subject**- string, opcional, o assunto do documento.

   - **Keywords**- string, opcional, palavras-chave associadas ao documento.

   - **Creator**- string, opcional, se o documento foi convertido para *PDF* a partir de outro formato, o nome da
     aplicação (por exemplo, Adobe FrameMaker®) que criou o documento original.

   - **Producer**- string, opcional, se o documento foi convertido para *PDF* a partir de outro formato, o nome da
     aplicação (por exemplo, Acrobat Distiller) que o converteu para *PDF*.

   - **CreationDate**- string, opcional, a data e a hora na qual o documento foi criado, na seguinte forma:
     "D:YYYYMMDDHHmmSSOHH'mm'", onde:



        - **YYYY** é o ano.

        - **MM** é o mês.

        - **DD** é o dia (01–31).

        - **HH** é a hora (00–23).

        - **mm** é o minuto (00–59).

        - **SS** é o segundo (00–59).

        - **O** é a relação da hora local com a Hora Universal (UT), denotada por um dos caracteres +, −, ou Z
          (veja abaixo).

        - **HH** seguido por ' é o valor absoluto da diferença da Hora Universal em horas (00–23).

        - **mm** seguido por ' é o valor absoluto da diferença da Hora Universal em minutos (00–59).

     O apóstrofo (') depois do HH e do mm é parte da sintaxe. Todos os campos depois do ano são opcionais. (O
     prefixo D:, embora também seja opcional, é fortemente recomendado.) Os valores padrões para MM e DD são,
     para ambos, 01; todos os outros campos numéricos têm valor padrão zero. Um sinal positivo (+) no valor de
     um campo significa que a hora local é mais tarde que a Hora Universal, e um sinal negativo (−) indica que
     é mais cedo, e a letra Z indica que a hora é igual à Hora Universal. Se nenhuma informação sobre à Hora
     Universal for específicada, a relação da hora com a Hora Universal é considerada desconhecida. Sendo ou
     não conhecido o fuso horário, o resto da data deve ser especificado na hora local.

     Por exemplo, 23 de Dezembro de 1998, 7:52 da noite, U.S. Pacific Standard Time, é representado pela string
     "D:199812231952−08'00'".

   - **ModDate**- string, opcional, a data e a hora da atualização mais recente no documento, na mesma forma de
     **CreationDate**.

   - **Trapped**- booleano, opcional, indica se o documento foi modificado para a inclusão de informações
     "trapped".



        - **TRUE**- The document has been fully trapped; no further trapping is needed.

        - **FALSE**- The document has not yet been trapped; any desired trapping must still be done.

        - **NULL**- Either it is unknown whether the document has been trapped or it has been partly but not yet
          fully trapped; some additional trapping may still be needed.





Desde a versão 1.6 do *PDF*, os metadados podem ser armazenados em um documento *XML* especial anexado ao *PDF*
(XMP -`Extensible Metadata Platform`_).

Este documento *XML* pode ser recuperado e anexado ao PDF com os métodos ``Zend_Pdf::getMetadata()`` e
``Zend_Pdf::setMetadata($metadata)``:

.. code-block:: php
   :linenos:

   $pdf = Zend_Pdf::load($pdfPath);
   $metadata = $pdf->getMetadata();
   $metadataDOM = new DOMDocument();
   $metadataDOM->loadXML($metadata);

   $xpath = new DOMXPath($metadataDOM);
   $pdfPreffixNamespaceURI = $xpath->query('/rdf:RDF/rdf:Description')
                                   ->item(0)
                                   ->lookupNamespaceURI('pdf');
   $xpath->registerNamespace('pdf', $pdfPreffixNamespaceURI);

   $titleNode = $xpath->query('/rdf:RDF/rdf:Description/pdf:Title')->item(0);
   $title = $titleNode->nodeValue;
   ...

   $titleNode->nodeValue = 'Novo título';
   $pdf->setMetadata($metadataDOM->saveXML());
   $pdf->save($pdfPath);

Propriedades comuns são duplicadas na estrutura Info e nos Metadados do documento (se presente). Agora é
responsabilidade da aplicação do usuário mantê-los sincronizados.



.. _`Extensible Metadata Platform`: http://www.adobe.com/products/xmp/
