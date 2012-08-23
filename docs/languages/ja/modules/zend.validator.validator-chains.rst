.. EN-Revision: none
.. _zend.validate.validator_chains:

バリデータチェイン
=========

ひとつの値に対して、複数のバリデータを指定した順に適用しなければならないことがよくあります。
以下のコードは、 :ref:`導入 <zend.validate.introduction>`
で説明した例を解決するための方法を示すものです。 ユーザ名が 6 文字から 12
文字までの英数字であるかどうかを検証します。

   .. code-block:: php
      :linenos:

      // バリデータチェインを作成し、そこにバリデータを追加します
      $validatorChain = new Zend_Validate();
      $validatorChain->addValidator(
                          new Zend_Validate_StringLength(array('min' => 6,
                                                               'max' => 12)))
                     ->addValidator(new Zend_Validate_Alnum());

      // ユーザ名を検証します
      if ($validatorChain->isValid($username)) {
          // ユーザ名は検証を通過しました
      } else {
          // ユーザ名の検証に失敗しました。理由を表示します
          foreach ($validatorChain->getMessages() as $message) {
              echo "$message\n";
          }
      }

バリデータは、 ``Zend_Validate`` に追加した順に適用されます。
上の例では、まずユーザ名の長さが 6 文字から 12
文字までの間であるかどうかを調べます。
その後で、英数字のみであるかどうかだけを調べます。
二番目の検証である「英数字かどうか」は、最初の検証である 「6 文字から 12
文字まで」が成功したかどうかにかかわらず行われます。
つまり、もし両方の検証に失敗した場合は、 ``getMessages()``
は両方の検証失敗メッセージを返すことになります。

検証が失敗した時点で、その後の検証を行わずにチェインを抜け出したいこともあるでしょう。
``Zend_Validate`` はそのような使用法もサポートしています。 そのためには、
``addValidator()`` メソッドの二番目のパラメータを使用します。 ``$breakChainOnFailure`` を
``TRUE`` に設定すると、そのバリデータが失敗した時点でチェインを抜け出します。
これにより、後に続く不要な検証や不適切な検証を行わずにすみます。
上の例を次のように書き直すと、長さの検証に失敗した場合は
英数字の検証を行わなくなります。

   .. code-block:: php
      :linenos:

      $validatorChain->addValidator(
                          new Zend_Validate_StringLength(array('min' => 6,
                                                               'max' => 12)),
                          true)
                     ->addValidator(new Zend_Validate_Alnum());



``Zend_Validate_Interface`` を実装したオブジェクトなら何でも、
バリデータチェインで使用できます。


