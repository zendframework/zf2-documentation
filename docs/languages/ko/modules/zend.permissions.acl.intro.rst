.. EN-Revision: none
.. _zend.acl.introduction:

소개
==

Zend_Acl는 가볍고 유연한 접근 제어 리스트(ACL : Access Control List) 기능과 권한 관리
기능을 제공합니다. 일반적으로 애플리케이션에서는 다른 요구 객체에 의해 보호된
객체에의 접근을 제어하기 위해서 이러한 기능을 사용합니다.

이 문서에 대해,



   - **자원(Resource)** 은 접근 제어의 대상이 되는 객체입니다.

   - **롤(Role)** 은 자원에 접근을 요구하는 객체입니다.

간단하게 말하면, **롤은 자원에 접근을 요구하는 것**\ 입니다. 예를 들어, 어떤 사람이
자동차를 탈려고 요청을 한다면, "요청한 사람"이 롤이고 "자동차"가 자원이 되고,
자동차에 탄 후에는 제어가 가능해집니다.

애플리케이션은 접근 제어 리스트(ACL)의 설정과 사용을 통해, 요청한 객체(롤)를
보호된 객체(자원)로의 접근을 허가할 지 제어합니다.

.. _zend.acl.introduction.resources:

자원(Resources)에 대해
-----------------

Zend_Acl에서 자원을 작성하는 것은 간단합니다. Zend_Acl은 개발자가 자원을 작성하기
쉽도록 *Zend_Acl_Resource_Interface*\ 를 제공합니다. 자원 클래스는 단지 이 인터페이스를
구현하는 것만으로 작성할 수 있습니다. 이 인터페이스에는 *getResourceId()*\ 라는 단
하나의 메소드만 포함되어 있습니다. 이 메소드에 의해, Zend_Acl는 그 객체가 자원인지
아닌지 여부를 판단합니다. 게다가, Zend_Acl는 개발자가 필요한 부분을 확장하여 자원을
작성하기 위한 기본 자원 도구로써 *Zend_Acl_Resource*\ 를 포함하고 있습니다.

Zend_Acl 은 복수의 자원(혹은 "접근이 제어되고 있는 영역들")을 추가할 수 있는 트리
구조를 제공하고 있습니다. 자원은 이와 같이 트리 구조로 저장되기 때문에,
상위(루트에 가까운 편)에서 하위(말단에 가까운 편)까지 조직될 수 있습니다. 특정
자원에 대해 질의를 행하면, 조상 자원들에 할당된 룰들을 살피며 자동적으로
자원들의 계층을 검색할 것입니다. 이것에 의해, 규칙을 계층화해서 관리할 수
있습니다.

또한, Zend_Acl는 자원에 대한 권한(예. "create","read","update","delete")도 지원하고 있어,
개발자는 자원에 대해 모든 권한 혹은 일부의 권한으로 영향을 미치는 규칙들을
부여할 수 있습니다.

.. _zend.acl.introduction.roles:

롤(Roles)에 대해
------------

자원과 같이, 롤을 작성하는 것도 간단합니다. Zend_Acl는 개발자가 롤을 작성하기 쉽게
*Zend_Acl_Role_Interface*\ 를 제공합니다. 롤 클래스는 단지 이 인터페이스를 구현하는
것만으로 작성할 수 있습니다. 이 인터페이스에는 *getRoleId()*\ 라는 단 하나의 메소드만
포함되어 있습니다. 이 메소드에 의해, Zend_Acl는 그 객체가 롤인지 아닌지 여부를
판단합니다. 게다가, Zend_Acl는 개발자가 필요한 부분을 확장하여 롤을 작성하기 위한
기본 롤 도구로써 *Zend_Acl_Role*\ 를 포함하고 있습니다.

Zend_Acl 에서 롤은 하나 혹은 그 이상의 롤들로부터 상속받을 수 있습니다. 이것은
각각의 롤들이 가지고 있는 규칙들을 상속받기 위한 것입니다. 예를 들어, "sally"와
같은 사용자 롤은, "editor" 및 "administrator"와 같이 복수의 부모 롤에 속하는 일도 있을 수
있습니다. 이 경우, 개발자는 "editor" 및 "administrator"에 각각 규칙을 정의하고, "sally"에
규칙을 직접 정의할 필요없이 "sally"가 그 양쪽으로부터 규칙들을 상속받습니다.

다중 롤로부터 상속받는 능력은 매우 유용하지만, 다중 상속은 다소 복잡성의 정도를
증가시키는 경우도 있습니다. 다음 예제는 애매한 조건에서 Zend_Acl로 처리하는 방법을
설명합니다.

.. _zend.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: 롤들 간의 다중 상속

다음 코드는 세 개의 기본 롤들 "*guest*", "*member*" 그리고 "*admin*"을 정의하고 있습니다.
다른 롤들은 이 기본 롤들로부터 상속받습니다. 다음으로, "*someUser*"라는 롤을 만들고,
세 개의 기본 롤들로부터 상속받습니다. 이들 롤이 $parent 배열에 선언된 순서가
중요합니다. 필요할 때, Zenc_Acl은 질의된 롤 (여기에서는 "*someUser*")뿐만 아니라, 질의된
롤이 상속받은 롤들 (여기에서는, "*guest*", "*member*", 그리고 "*admin*")로 정의된 접근
규칙들을 검색합니다.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl.php';
   $acl = new Zend_Acl();

   require_once 'Zend/Acl/Role.php';
   $acl->addRole(new Zend_Acl_Role('guest'))
       ->addRole(new Zend_Acl_Role('member'))
       ->addRole(new Zend_Acl_Role('admin'));

   $parents = array('guest', 'member', 'admin');
   $acl->addRole(new Zend_Acl_Role('someUser'), $parents);

   require_once 'Zend/Acl/Resource.php';
   $acl->add(new Zend_Acl_Resource('someResource'));

   $acl->deny('guest', 'someResource');
   $acl->allow('member', 'someResource');

   echo $acl->isAllowed('someUser', 'someResource') ? 'allowed' : 'denied';

"*someUser*"와 "*someResource*"에 특별히 정의된 규칙이 없기 때문에, Zend_Acl은 "*someUser*"가
상속받은 롤들에 대해 정의되었을 지도 모르는 규칙들을 검색해야만 합니다. 먼저,
"*admin*"롤을 방문하지만, "*someResource*"를 위해 정의된 접근 규칙이 없습니다. 다음으로
"*member*"롤을 방문합니다. Zend_Acl은 "*member*" 가 "*someResource*"에 접근이 허가되어 있는
규칙이 있다는 것을 발견합니다.

그러나, 만약 Zend_Acl이 다른 부모 롤들에 정의된 규칙들을 계속해서 검사한다면,
"*guest*"는 "*someResource*"에 접근이 거부되었다는 것을 알 수 있습니다. 이 사실이
모호성을 나타냅니다. 왜냐하면, 서로 다른 부모로부터 상속받은 롤들의 충돌로 인해,
"*someUser*"는 현재 "*someResource*"에 대한 접근 권한이 허가와 거부 둘 다 가지고 있습니다.

Zend_Acl은 직접적으로 질의에 적용가능한 첫번째 규칙을 발견했을 때, 질의를
완료함으로써 이러한 모호성을 해결합니다. 이 경우에는 "*member*" 롤이 "*guest*" 롤보다
먼저 검색되기 때문에, 이 예제 코드는 "allowed"를 출력합니다.

.. note::

   롤에 대해 다중 부모를 지정할 때, 배열 목록의 마지막 부모가 인증 질의에 유용한
   규칙을 찾기 위한 첫번째 부모 롤이 된다는 것을 명심하시기 바랍니다.

.. _zend.acl.introduction.creating:

접근 제어 목록(ACL)의 생성
-----------------

ACL 은 여러분이 원하는대로 물리적 또는 가상의 객체들의 어떠한 집합이라도 표현할
수 있습니다. 그러나 여기에서는, 설명용으로서 기본적인 컨텐츠 관리 시스템(CMS)의
ACL를 생각합니다. 이것은, 다양한 영역에서 복수 계층의 그룹을 관리하는 것입니다.
새로운 ACL 객체를 생성하려면, 매개변수를 지정하지 않고 ACL의 인스턴스를
생성합니다:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl.php';

   $acl = new Zend_Acl();

.. note::

   개발자가 "allow" 규칙을 지정하기 전까지, Zend_Acl은 모든 롤에 준거해 모든 자원상의
   권한으로의 접근을 거부합니다.

.. _zend.acl.introduction.role_registry:

롤의 등록
-----

콘텐츠 관리 시스템(CMS)에서는 사용자들의 편집 권한을 부여하기 위해 대개는 권한에
대한 계층적인 관리가 필요합니다. 예를 들어, 'Guest'그룹에 대해서는 데모용으로
제한적인 접근 권한만을 허가하고, 'Staff'그룹은 통상의 작업을 하는 대부분의 CMS
유저용으로 권한을 부여하고, 'Editor'그룹에는 콘텐츠의 공개, 리뷰, 보존, 삭제의
권한을 주고, 마지막으로 'Administrator'그룹에는 다른 그룹들의 모든 권한을 포함하고
기밀 정보의 관리, 유저 관리, 백엔드 환경설정 데이터, 데이터의 백업/내보내기
권한을 부여할 수 있습니다. 이러한 권한을 롤 레지스트리로 나타낼 수 있습니다. 각
그룹의 권한을 '부모'그룹으로부터 상속받고, 거기에 더해 그 그룹에 고유의 권한을
추가로 정의합니다. 이러한 권한을 다음과 같이 나타낼 수 있습니다.

.. _zend.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: Access Controls for an Example CMS

   +-------------+------------------------+------------------------+
   |Name         |Unique permissions      |Inherit permissions from|
   +=============+========================+========================+
   |Guest        |View                    |N/A                     |
   +-------------+------------------------+------------------------+
   |Staff        |Edit, Submit, Revise    |Guest                   |
   +-------------+------------------------+------------------------+
   |Editor       |Publish, Archive, Delete|Staff                   |
   +-------------+------------------------+------------------------+
   |Administrator|(Granted all access)    |N/A                     |
   +-------------+------------------------+------------------------+

이 예에서는, *Zend_Acl_Role*\ 을 이용하고 있지만, *Zend_Acl_Role_Interface*\ 를 구현하고 있는
객체라면 뭐든지 사용 가능합니다. 이러한 그룹들은 다음과 같이 롤 레지스트리에
추가합니다.:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl.php';

   $acl = new Zend_Acl();

   // Zend_Acl_Role를 사용하여 그룹을 롤 레지스트리에 추가합니다
   require_once 'Zend/Acl/Role.php';

   // guest는 접근 제어를 상속받지 않습니다
   $roleGuest = new Zend_Acl_Role('guest');
   $acl->addRole($roleGuest);

   // Staff는 guest부터 상속받습니다
   $acl->addRole(new Zend_Acl_Role('staff'), $roleGuest);

   /* 또는, 위의 내용은 다음과 같이 쓸 수도 있습니다:
   $acl->addRole(new Zend_Acl_Role('staff'), 'guest');
   //*/

   // Editor는 staff로부터 상속받습니다
   $acl->addRole(new Zend_Acl_Role('editor'), 'staff');

   // Administrator는 접근 제어를 상속받지 않습니다
   $acl->addRole(new Zend_Acl_Role('administrator'));

.. _zend.acl.introduction.defining:

접근 제어의 정의
---------

이 제 ACL에 적절한 롤이 포함되어, 어떻게 자원에 접근할 것인지에 대해 정의하는
규칙들을 설정할 수 있습니다. 이 예에서는 어떠한 특정의 자원도 정의하지 않았다는
것을 알아차렸을 지도 모릅니다. 이 경우, 모든 자원에 대해서 규칙은 적용됩니다.
Zend_Acl를 사용하면, 상위에서 하위까지 규칙을 적용하는 것만으로 정의할 수 있게
됩니다. 왜냐하면, 자원과 롤은 그들의 조상으로부터 정의된 규칙들을 상속받기
때문입니다.

따라서, 상당히 복잡한 규칙의 집합도 최소한의 코드로 정의할 수 있습니다. 위에서
정의한 기본적인 권한을 적용하려면, 다음과 같이 합니다:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl.php';

   $acl = new Zend_Acl();

   require_once 'Zend/Acl/Role.php';

   $roleGuest = new Zend_Acl_Role('guest');
   $acl->addRole($roleGuest);
   $acl->addRole(new Zend_Acl_Role('staff'), $roleGuest);
   $acl->addRole(new Zend_Acl_Role('editor'), 'staff');
   $acl->addRole(new Zend_Acl_Role('administrator'));

   // Guest는, 콘텐츠를 보는 것만 가능합니다
   $acl->allow($roleGuest, null, 'view');

   /* 위와 같은 내용을 다음과 같이 쓸 수도 있습니다:
   $acl->allow('guest', null, 'view');
   //*/

   // Staff는 guest의 권한을 모두 상속받고, 거기에 더해 추가의 권한을 필요로 합니다
   $acl->allow('staff', null, array('edit', 'submit', 'revise'));

   // Editor는, staff의 권한(보기, 편집, 제출(submit) 및 수정)을 상속받고,
   // 게다가 추가의 권한을 필요로 합니다
   $acl->allow('editor', null, array('publish', 'archive', 'delete'));

   // Administrator는 아무것도 상속받지 않지만, 모든 권한이 허용됩니다
   $acl->allow('administrator');

위의 *allow()*\ 의 콜에서 *null*\ 은, 규칙들을 모든 자원에 대해 적용하는 것을
의미합니다.

.. _zend.acl.introduction.querying:

ACL에의 질의
--------

이제 웹애플리케이션의 사용자가 어떤 기능을 사용하기 위해 필요한 권한을 가지고
있는지를 조사할 수 있는 ACL를 가지고 있습니다. 질의를 실행하는 것은 아주
간단합니다. 다음과 같이 *isAllowed()* 메소드를 사용하면 됩니다:

.. code-block::
   :linenos:
   <?php
   echo $acl->isAllowed('guest', null, 'view') ?
        "allowed" : "denied"; // allowed

   echo $acl->isAllowed('staff', null, 'publish') ?
        "allowed" : "denied"; // denied

   echo $acl->isAllowed('staff', null, 'revise') ?
        "allowed" : "denied"; // allowed

   echo $acl->isAllowed('editor', null, 'view') ?
        "allowed" : "denied"; // guest로부터 상속받고 있으므로 allowed

   echo $acl->isAllowed('editor', null, 'update') ?
        "allowed" : "denied"; // 'update' 규칙이 허가 되지 않았으므로 denied

   echo $acl->isAllowed('administrator', null, 'view') ?
        "allowed" : "denied"; // administrator는 모든 권한이 허가되고 있으므로 allowed

   echo $acl->isAllowed('administrator') ?
        "allowed" : "denied"; // administrator는 모든 권한이 허가되고 있으므로 allowed

   echo $acl->isAllowed('administrator', null, 'update') ?
        "allowed" : "denied"; // administrator는 모든 권한이 허가되고 있으므로 allowed


