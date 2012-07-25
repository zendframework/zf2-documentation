.. _zend.permissions.acl.refining:

접근 제어의 정련(精鍊)
=============

.. _zend.permissions.acl.refining.precise:

정확한 접근 제어
---------

:ref:`이전 장 <zend.permissions.acl.introduction>`\ 에서 정의한 기본적인 ACL에서는, 다양한 규칙을 ACL
전체(모든 자원)에 대해서 적용했습니다. 그러나 실제로 접근 제어에는 다양하고
복잡한 단계와 예외사항을 만나기 쉽습니다. Zend\Permissions\Acl은 이러한 경우에도 간단하고
유연한 방법으로 대응할 수 있습니다.

예로 든 CMS에서 대부분의 유저를 'staff'그룹에서 정리해 관리하고 있었습니다.
여기에서는 CMS의 뉴스레터나 최신 뉴스에의 접근을 필요로 하는 'marketing'이라는
새로운 그룹을 만듭니다. 이 그룹은 뉴스레터 및 최신 뉴스의 발행과 보존 권한을
가집니다.

덧붙여, 'staff'그룹은 뉴스의 내용은 열람할 수는 있지만, 최신 뉴스의 수정은 할 수
없게 합니다. 마지막으로, 누구라도 (administrators를 포함해서) '발표' 뉴스 내용은
보존할 수 없게 합니다. 왜냐하면, 그것들의 유효기간은 1 ~ 2일 정도 밖에 되지 않기
때문입니다.

먼저, 이러한 변경을 반영시키기 위해 롤 레지스트리를 수정합니다. 'staff'그룹과
동일한 기본 권한을 가지는 'marketing'그룹을 만들기로 했으므로, 'marketing'그룹을
만들고, 'staff'그룹으로 부터 권한을 상속받습니다:

.. code-block::
   :linenos:
   <?php
   // 새로운 marketing그룹은 staff그룹으로부터 권한을 상속받습니다
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('marketing'), 'staff');

다음에, 위의 접근 제어는 특정 자원(예: "newsletter","latest news","announcement news")에 대해
한정되는 것에 주의하시기 바랍니다. 이제 우리는 다음과 같이 이들 자원을
추가합니다:

.. code-block::
   :linenos:
   <?php
   // 규칙을 적용할 자원을 만듭니다
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('newsletter'));           // newsletter
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('news'));                 // news
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('latest'), 'news');       // latest news
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('announcement'), 'news'); // announcement news

그러면, 이들에게 ACL의 해당 범위에 특정 규칙들을 정의하는 문제는 간단합니다:

.. code-block::
   :linenos:
   <?php
   // Marketing그룹은 뉴스레터 및 최신 뉴스를 발행, 보존할 수 없으면 안됩니다
   $acl->allow('marketing', array('newsletter', 'latest'), array('publish', 'archive'));

   // Staff (그리고 상속에 의한 marketing)그룹은 최신 뉴스의 수정을 할 수 없습니다
   $acl->deny('staff', 'latest', 'revise');

   // 전원 (administrators를 포함해서)은 발표 뉴스를 보존할 수 없습니다
   $acl->deny(null, 'announcement', 'archive');

이것으로, 이제 최신 변경 내용을 반영한 ACL에 질의할 수 있습니다:

.. code-block::
   :linenos:
   <?php
   echo $acl->isAllowed('staff', 'newsletter', 'publish') ?
        "allowed" : "denied"; // denied

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied"; // allowed

   echo $acl->isAllowed('staff', 'latest', 'publish') ?
        "allowed" : "denied"; // denied

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied"; // allowed

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied"; // allowed

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied"; // denied

   echo $acl->isAllowed('editor', 'announcement', 'archive') ?
        "allowed" : "denied"; // denied

   echo $acl->isAllowed('administrator', 'announcement', 'archive') ?
        "allowed" : "denied"; // denied

.. _zend.permissions.acl.refining.removing:

접근 제어의 삭제
---------

ACL로부터 하나 또는 복수의 접근 규칙을 삭제하려면, *removeAllow()* 또는 *removeDeny()*
메소드를 사용합니다. *allow()* 및 *deny()*\ 와 같이, null값을 지정하면 모든 롤이나 자원,
권한을 나타내게 됩니다:

.. code-block::
   :linenos:
   <?php
   // staff(그리고 상속에 의한 marketing)그룹으로부터 최신 뉴스의 수정 거부를 삭제합니다
   $acl->removeDeny('staff', 'latest', 'revise');

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied"; // allowed

   // marketing그룹으로부터 뉴스레터의 발행 및 보존 권한을 없앱니다
   $acl->removeAllow('marketing', 'newsletter', array('publish', 'archive'));

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied"; // denied

   echo $acl->isAllowed('marketing', 'newsletter', 'archive') ?
        "allowed" : "denied"; // denied

위에서 설명한 것처럼, 서서히 권한을 변경해 나갈 수도 있습니다만, 권한에 대해서
*null* 값을 설정하면, 이러한 변경을 일괄적으로 수행할 수 있습니다.

.. code-block::
   :linenos:
   <?php
   // marketing그룹에 대해 최신 뉴스의 모든 권한을 허가합니다
   $acl->allow('marketing', 'latest');

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied"; // allowed

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied"; // allowed

   echo $acl->isAllowed('marketing', 'latest', 'anything') ?
        "allowed" : "denied"; // allowed


