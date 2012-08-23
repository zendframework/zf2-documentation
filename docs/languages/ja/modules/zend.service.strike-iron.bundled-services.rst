.. EN-Revision: none
.. _zend.service.strikeiron.bundled-services:

Zend_Service_StrikeIron: バンドルされているサービス
======================================

``Zend_Service_StrikeIron`` には、StrikeIron のサービスのうち人気のある 3
つについてのラッパークラスが含まれています。

.. _zend.service.strikeiron.bundled-services.zip-code-information:

ZIP Code Information
--------------------

``Zend_Service_StrikeIron_ZipCodeInfo`` は、StrikeIron の Zip Code Information Service
用のクライアントです。 このサービスについての詳細は、以下の StrikeIron
のリソースを参照ください。



   - `Zip Code Information Service のページ`_

   - `Zip Code Information Service の WSDL`_

このサービスの ``getZipCode()`` メソッドは、
アメリカやカナダの郵便番号についての情報を取得します。

   .. code-block:: php
      :linenos:

      $strikeIron = new Zend_Service_StrikeIron(array('username' => 'あなたのユーザ名',
                                                      'password' => 'あなたのパスワード'));

      // Zip Code Information サービス用のクライアントを取得します
      $zipInfo = $strikeIron->getService(array('class' => 'ZipCodeInfo'));

      // 郵便番号 95014 についての情報を取得します
      $response = $zipInfo->getZipCode(array('ZipCode' => 95014));
      $zips = $response->serviceResult;

      // 結果を表示します
      if ($zips->count == 0) {
          echo 'みつかりませんでした';
      } else {
          // コードをひとつだけ指定したときの返り値はオブジェクトとなります。
          // 要素ひとつの配列ではありません。
          if (! is_array($zips->zipCodes)) {
              $zips->zipCodes = array($zips->zipCodes);
          }

          // すべての結果を表示します
          foreach ($zips->zipCodes as $z) {
              $info = $z->zipCodeInfo;

              // すべてのプロパティを表示します
              print_r($info);

              // あるいは都市名のみを表示します
              echo $info->preferredCityName;
          }
      }

      // 詳細なステータス情報
      // http://www.strikeiron.com/exampledata/StrikeIronZipCodeInformation_v3.pdf
      $status = $response->serviceStatus;



.. _zend.service.strikeiron.bundled-services.us-address-verification:

U.S. Address Verification
-------------------------

``Zend_Service_StrikeIron_USAddressVerification`` は StrikeIron の U.S. Address Verification Service
用のクライアントです。 このサービスについての詳細は、以下の StrikeIron
のリソースを参照ください。



   - `U.S. Address Verification Service のページ`_

   - `U.S. Address Verification Service の WSDL`_



このサービスの ``verifyAddressUSA()`` メソッドは、 アメリカの住所を検証します。

   .. code-block:: php
      :linenos:

      $strikeIron = new Zend_Service_StrikeIron(array('username' => 'あなたのユーザ名',
                                                      'password' => 'あなたのパスワード'));

      // Zip Code Information サービス用のクライアントを取得します
      $verifier = $strikeIron->getService(array('class' => 'USAddressVerification'));

      // 調べる住所を指定します。すべてのフィールドが必須というわけではありませんが、
      // できるだけ多くを指定したほうがよい結果が得られます
      $address = array('firm'           => 'Zend Technologies',
                       'addressLine1'   => '19200 Stevens Creek Blvd',
                       'addressLine2'   => '',
                       'city_state_zip' => 'Cupertino CA 95014');

      // 住所を検証します
      $result = $verifier->verifyAddressUSA($address);

      // 結果を表示します
      if ($result->addressErrorNumber != 0) {
          echo $result->addressErrorNumber;
          echo $result->addressErrorMessage;
      } else {
          // すべてのプロパティを表示します
          print_r($result);

          // あるいは企業名のみを表示します
          echo $result->firm;

          // 正しい住所ですか?
          $valid = ($result->valid == 'VALID');
      }



.. _zend.service.strikeiron.bundled-services.sales-use-tax-basic:

Sales & Use Tax Basic
---------------------

``Zend_Service_StrikeIron_SalesUseTaxBasic`` は、 StrikeIron の Sales & Use Tax Basic
サービス用のクライアントです。 このサービスについての詳細は、以下の StrikeIron
のリソースを参照ください。



   - `Sales & Use Tax Basic Service のページ`_

   - `Sales & Use Tax Basic Service の WSDL`_



このサービスには 2 つのメソッドがあります。 ``getTaxRateUSA()`` および
``getTaxRateCanada()`` は、
それぞれアメリカとカナダの販売・消費税の情報を取得します。

   .. code-block:: php
      :linenos:

      $strikeIron = new Zend_Service_StrikeIron(array('username' => 'あなたのユーザ名',
                                                      'password' => 'あなたのパスワード'));

      // Sales & Use Tax Basic サービス用のクライアントを取得します
      $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

      // カナダのオンタリオ州の税率を取得します
      $rateInfo = $taxBasic->getTaxRateCanada(array('province' => 'foo'));
      print_r($rateInfo);               // すべてのプロパティを表示します
      echo $rateInfo->GST;              // あるいは GST (Goods & Services Tax) のみを表示します

      // アメリカ・カリフォルニア州クパチーノの税率を取得します
      $rateInfo = $taxBasic->getTaxRateUS(array('zip_code' => 95014));
      print_r($rateInfo);               // すべてのプロパティを表示します
      echo $rateInfo->state_sales_tax;  // あるいは州の消費税のみを表示します





.. _`Zip Code Information Service のページ`: http://www.strikeiron.com/ProductDetail.aspx?p=267
.. _`Zip Code Information Service の WSDL`: http://sdpws.strikeiron.com/zf1.StrikeIron/sdpZIPCodeInfo?WSDL
.. _`U.S. Address Verification Service のページ`: http://www.strikeiron.com/ProductDetail.aspx?p=198
.. _`U.S. Address Verification Service の WSDL`: http://ws.strikeiron.com/zf1.StrikeIron/USAddressVerification4_0?WSDL
.. _`Sales & Use Tax Basic Service のページ`: http://www.strikeiron.com/ProductDetail.aspx?p=351
.. _`Sales & Use Tax Basic Service の WSDL`: http://ws.strikeiron.com/zf1.StrikeIron/taxdatabasic4?WSDL
