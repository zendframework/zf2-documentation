.. _zend.permissions.acl.advanced:

고급 사용법
======

.. _zend.permissions.acl.advanced.storing:

ACL 데이터의 보존에 의한 영속성의 확보
-----------------------

Zend\Permissions\Acl는 ACL 데이터의 보존을 위해 데이타베이스나 캐쉬 서버와 같은 어떠한 특별한
백엔드 기술도 요구하지 않게 설계되었습니다. 전적으로 PHP 구현만으로
커스터마이즈된 관리툴에서 상대적으로 쉽고 유연성을 가진 Zend\Permissions\Acl을 작성할 수
있습니다. 다양한 상황들에 부딪히다 보면, ACL의 인터액티브한 관리를 필요로 하므로,
end_Acl는 어플리케이션의 접근 제어와 그에 대한 설정 및 질의를 할 수 있는 메소드를
제공합니다.

데이터의 사용법은 여러가지 상황에 따라 크게 달라지기 때문에, ACL 데이터의 저장은
개발자의 몫으로 남습니다. Zend\Permissions\Acl는 직렬화(serializable)가 가능해서, ACL 객체를 PHP의
`serialize()`_ 함수를 이용해서 직렬화 할 수 있습니다. 그 결과를, 파일 및 데이타베이스
또는 캐쉬 서버 등의 원하는 장소에 저장할 수 있습니다.

.. _zend.permissions.acl.advanced.assertions:

검증을 통한 조건부 ACL 규칙의 작성
---------------------

때때로 어떤 자원에 접근하는 롤의 허가나 거절을 위한 규칙은 절대적인 것이 아니라
다양한 기준에 따릅니다. 예를 들어, 접근을 허락하는 것은 오전 8시부터 오후 5시의
사이로 한정한다고 하는 경우나, 악플의 진원지로 밝혀진 특정의 IP주소로부터의
접근만을 거부하는 경우도 있습니다. Zend\Permissions\Acl는 개발자의 필요에 의한 어떤 조건을
근거로 규칙을 구현할 수 있도록 지원하고 있습니다.

Zend\Permissions\Acl는 조건부의 규칙을 *Zend\Permissions\Acl\Assert\AssertInterface*\ 로 지원하고 있습니다. 규칙의 검증용
인터페이스를 사용하기 위해, 개발자는 인터페이스의 *assert()* 메소드를 implements한
클래스를 작성합니다:

.. code-block::
   :linenos:
   <?php

   class CleanIPAssertion implements Zend\Permissions\Acl\Assert\AssertInterface
   {
       public function assert(Zend\Permissions\Acl $acl, Zend\Permissions\Acl\Role\RoleInterface $role = null,
                              Zend\Permissions\Acl\Resource\ResourceInterface $resource = null, $privilege = null)
       {
           return $this->_isCleanIP($_SERVER['REMOTE_ADDR']);
       }

       protected function _isCleanIP($ip)
       {
           // ...
       }
   }

검증 클래스를 작성하면, 조건부의 규칙을 할당할 때, 이 검증 클래스의 인스턴스를
지정해야만 합니다. 검증을 포함하고, 작성된 규칙은 검증 메소드(assert)가 true를
리턴할 때만 적용됩니다.

.. code-block::
   :linenos:
   <?php

   $acl = new Zend\Permissions\Acl\Acl();
   $acl->allow(null, null, null, new CleanIPAssertion());

위의 코드는 모두에게 모든 권한에 접근할 허가를 주지만, 접근 요청 IP가 "블랙
리스트에 올려진" 경우에는 접근을 거부하는 조건부 허가 규칙을 만듭니다. 만약
"깨끗하다"라고 간주되지 않는 IP로부터 요청이 들어오면, 접근 허가 규칙이 적용되지
않습니다. 왜냐하면, 규칙은 모든 롤, 모든 자원 그리고 모든 권한에 적용되기 때문에,
"깨끗하지 않은" IP로부터의 접근은 거부하게 됩니다. 그러나, 이것은 특수한
경우입니다. 보통은 (즉, 특정의 롤, 자원 또는 권한을 규칙의 대상으로 하는 경우),
검증에 실패해서 규칙이 적용되지 않는 경우에는, 접근이 가능한지의 여부를 다른
규칙들을 사용해서 결정합니다.

검증 객체의 *assert()* 메소드는, 인증 질의(즉, *isAllowed()* 메소드)가 적용되는 ACL, 롤,
자원 및 권한에게 넘겨집니다. 이것을 이용해서 필요로 하는 조건을 검증 클래스가
판단합니다.



.. _`serialize()`: http://php.net/serialize
