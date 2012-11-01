.. EN-Revision: none
.. _zend.acl.introduction:

Въведение
=========

Zend_Acl предоставя гъвкава функционалност за прилагане на access
control list(ACL). и мениджмънт на привилегии. На кратко казано, една
програма може да използва такава функция за да контролира
достъпа до определен защитен обект, до който друг обект е
пожелал достъп.

Терминологя за целта на тази документация,



   - **Resource** е обект, до който достъпа е контролиран.

   - **Role** е обект, който може да поиска достъп до Resource.

Тъй че, **Role заявява достъп до Ресурс**. Например, ако човек заяви
достъп до автомобил, тогава човекът а в позицията на Role, а
колата Resource, тъй като достъпа до колата е контролиран.

Чрез употребата на access control list (ACL), една програма може да
контролира как на обекти правещ заявката (Resource), е предостаавен
достъп до защитен обект (Resource).

.. _zend.acl.introduction.resources:

Относно Resource
----------------

В Zend_Acl, създаването на Resource е много лесно. Zend_Acl предоставя
*Zend\Acl_Resource\Interface* за да се създаде Resources.Даден клас просто трябва
да наследява от този интерфейс , който се състои от единствения
метод, *getResourceId()*, тъй че Zend_Acl да счете този обект за Resource. Нещо
повече, *Zend\Acl\Resource* е включен със Zend_Acl като базов Resource от който
може да се онаследява, кодето е нужно.

Zend_Acl предоставя дървовидна структура към която множество
Resources (или система под контрол) може да бъде добавена. Тъй като
Ресърсите са съхраняване в такава структура , те могат да бъдат
организирани от общото (основата на дървото) към
специфичното/подробното (лисстата или клоновете на дървото).
Заявка до специфичен Ресурс ще предизвика автоамтично
претърсване на йерархията за правила закрепени към
предшестващия ресурс, позволявайки за по просто онаследяване
на правила. Например, ако едно правило в един град е приложено
за всяка сграда, тогава е смислено правилото да е прикрепено
към правилата за града, а не за всяка сграда по отделно. Но,
някои сгради може да бъдат изключения от общото правило. Това
изключение може да се постигне лесно чрез Zend_Acl, като към всяка
сграда изискваща изключение от общото правило се прикрепи
такова. Даден Ресурс може да наследи от само точно един Ресурс,
въпреки че то зи родител Ресурс от сво страна може да е
онаследил от друг такъв и т.н.

Чрез Zend_Acl също е възможно да се назнчат привилегии върху
Ресурса (например - "create", "read", "update", "delete"). По този начин
програмиста може да назначи правила, които да рефлектират
върху всички привилегии или само някои върху Ресурс.

.. _zend.acl.introduction.roles:

Относно Roles
-------------

Както и Ресурса така и създаването Рole е много лесно. Zend_Acl
излага *Zend\Acl_Role\Interface* за да подпомогне програмиста да създаде
Role. Даден клас тряба само да приложи този интерфейс, който се
състои от единствен метод, *getRoleId()*, за да се счете обекта за Role
от гледна точка на Zend_Acl. Нещо повече, *Zend\Acl\Role* е включен със
*Zend_Acl* като базово приложение на Role за да може програмиста да го
допълни където е нужно.

Във *Zend_Acl* Role може да наследи от една или повече Roles. Така се
предоставя начин да се поддържа онаследяване ан правила между
Roles. Например, нека имаме Role наречена Penka, която от своя страна
принадлежи на Role "редактор" и на друга Role - "администратор".
Програмиста може да назначи правила, на "редактор" и
"администратор" по отделно,а "Penka" от своя стран ще придобие по
наследство техните правила без да биват назначавани директно.

Въпреки че способността да се онаследява от множество Roles е
полезно, това довежда до някаква степен на усложняване от своя
страна. Следния пример илюстрира как Zend_Acl улеснява в подобни
ситуации.

.. _zend.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: Многократно онаследяване между Roles

Следня код дефинира три басови Роли "*guest*", "*member*", и "*admin*", от
които други Роли може да онаследяват. Тогава, Ролята "*someUser*"
може да се установи като онаследи от всички три предишни Роли.
Реда в който Ролите са подредени в *$parents* array е важен. Когато е
необходимо Zend_Acl търси правилата за достъп не само за
определената Роля, а имменно "*someUser*", но също и правилата върху
Ролите от които е наследила (а иммено "*guest*", "*member*", и "*admin*"):

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl.php';
   $acl = new Zend\Acl\Acl();

   require_once 'Zend/Acl/Role.php';
   $acl->addRole(new Zend\Acl\Role('guest'))
       ->addRole(new Zend\Acl\Role('member'))
       ->addRole(new Zend\Acl\Role('admin'));

   $parents = array('guest', 'member', 'admin');
   $acl->addRole(new Zend\Acl\Role('someUser'), $parents);

   require_once 'Zend/Acl/Resource.php';
   $acl->add(new Zend\Acl\Resource('someResource'));

   $acl->deny('guest', 'someResource');
   $acl->allow('member', 'someResource');

   echo $acl->isAllowed('someUser', 'someResource') ? 'allowed' : 'denied';

Тъй като няма правила специално дефинирани за "*someUser*" и
"*someResource*", Zend_Acl ще трябва да търси за правила, които може да са
дефинирани за Роли от които "*someUser*" онаследява. Първо проверка
е направена за "*admin*" и няма правила за достъп определени за нея.
След това,Ролята "*member*" бива проверена и Zend_Acl установява че има
дефинирано правило, което казва,че на "*member*" е позволено да има
достъп до "*someResource*".

Ако Zend_Acl продължи да проверява правилата за другите Роли по
установената йерархия ще се установи, че за "*guest*" достъпа до
"*someResource*" е забранен. Този факт допринася за неясността в
правилата които са описани в кода, защото сега "*someUser*" има
забрана и в сащото време разрешение за достъп до "*someResource*"
(поради онаследяване от Роля по високо).

Zend_Acl разрешава този проблем като завърши операциата веднага
когато намери първото правило,което е дирецтно приложимо. В
този случй, тъй като "*member*" Role е разгледана преди "*guest*", тогава
примерния код ще отпринтира "*allowed*".

.. note::

   Когато се декларират множество родители за една роля, трябв
   да се има в предвид че последния родител е първиа който бива
   проверяван за прилагане на правилата за оторизация.

.. _zend.acl.introduction.creating:

Създаван на Access Control List (ACL)
-------------------------------------

An ACL can represent any set of physical or virtual objects that you wish. For the purposes of demonstration,
however, we will create a basic Content Management System ACL that maintains several tiers of groups over a wide
variety of areas. To create a new ACL object, we instantiate the ACL with no parameters:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl.php';

   $acl = new Zend\Acl\Acl();

.. note::

   Докато изрично не е обозначено правило "allow" , Zend_Acl ще отказва
   достъп до всяка привилегия върху Ресурс на всяка Роля.

.. _zend.acl.introduction.role_registry:

Регистриране на Роли
--------------------

Content Management Systems почти винаги ще изискват йерархия от нива на
достъп за да се определят правата за манипулациите, които
могат да бъдат изваршвани от един Потребител. Може да има група
"Гост", която да има огранияен достъп - за демонстрации
например. Би могло да им група "Персонал", за тези които
извършват ежедневни операции, група "Редактор" за тези
отговорни за публикуване, редактиране, архивиране и изтриване
на съдържание. И последно, може да има група 'Администратор",
която може да включва всички гореспоментаи дейности плюс
поддръжка и опериране с чувствителна информация, backup и
конфигуриране на бек енда. Тази поредица от привилегии може да
бъде представена в Role registry, което да позволи на всяка група да
онаследява привилегии от група родител (по-високо в
йерархията), а съсщо така и да определи привилегии уникални за
всяка група. Различните нива на достъп могат да се представят
така:

.. _zend.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: Access Controls за Example CMS

   +-------------+------------------------+-----------------+
   |Name         |Unique permissions      |Наследи достъп от|
   +=============+========================+=================+
   |Guest        |View                    |N/A              |
   +-------------+------------------------+-----------------+
   |Staff        |Edit, Submit, Revise    |Guest            |
   +-------------+------------------------+-----------------+
   |Editor       |Publish, Archive, Delete|Staff            |
   +-------------+------------------------+-----------------+
   |Administrator|(Granted all access)    |N/A              |
   +-------------+------------------------+-----------------+

За този пример, *Zend\Acl\Role* е използван, но всеки обект прилагащ
*Zend\Acl_Role\Interface* може да се ползва. Тези групи могат да се добавят
до регитъра по следния начин.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl.php';

   $acl = new Zend\Acl\Acl();

   // Add groups to the Role registry using Zend\Acl\Role
   require_once 'Zend/Acl/Role.php';

   // Guest does not inherit access controls
   $roleGuest = new Zend\Acl\Role('guest');
   $acl->addRole($roleGuest);

   // Staff онаследява от  guest
   $acl->addRole(new Zend\Acl\Role('staff'), $roleGuest);

   /* последното може да бъде написано и по този начин:
   $roleGuest = $acl->addRole(new Zend\Acl\Role('staff'), 'guest');
   //*/

   // Editor онаследява от staff
   $acl->addRole(new Zend\Acl\Role('editor'), 'staff');

   // Администратора не онаследява
   $acl->addRole(new Zend\Acl\Role('administrator'));

.. _zend.acl.introduction.defining:

Дефиниране на Access Controls
-----------------------------

Сеаг вече когато ACL съдържа съответните роли, правилата могат
да бъдат установени относно това как Ролите могат да ползват
Ресурси. може би сте забелязали, че не сме дефинирали нито един
специфичен Ресурс за този пример, който е опростен за да се
илюстрира че правилата се отнасят до всички Ресурси. Zend_Acl
предоставя модел в който правилата трябва да бъдат назначени
от общото към специфичното, минимизирайки по този начин броя
на нужните правилам, тъй като Ресурсите и Ролите онаследяват
правила онаследени от техните предшественици (родители).

Следователно, можем да дефинираме разумно сложна система от
правила с минимум код. За да приложим основните нива на достъп
дефинирани по-горе:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Acl.php';

   $acl = new Zend\Acl\Acl();

   require_once 'Zend/Acl/Role.php';

   $roleGuest = new Zend\Acl\Role('guest');
   $acl->addRole($roleGuest);
   $acl->addRole(new Zend\Acl\Role('staff'), $roleGuest);
   $acl->addRole(new Zend\Acl\Role('editor'), 'staff');
   $acl->addRole(new Zend\Acl\Role('administrator'));

   // Guest може само да вижда съдържание
   $acl->allow($roleGuest, null, 'view');

   /* горното може да се напише и така:
   $acl->allow('guest', null, 'view');
   //*/

   // Staff онаследява view приилегии от guest, но също има нужда от други привилегии
   $acl->allow('staff', null, array('edit', 'submit', 'revise'));

   // Editor онаследява view, edit, submit, and revise прижилегии от staff,
   // но също има нужда от други привилегии
   $acl->allow('editor', null, array('publish', 'archive', 'delete'));

   // Administrator не онаследява,но има всички привилегии
   $acl->allow('administrator');

Стойностите *null* при *allow()* са изповани за да се покаже че
позволените правила са приложени за сички ресурси.

.. _zend.acl.introduction.querying:

Допит до ACL
------------

Сега ние имаме гъвкав ACL , който може да се използва за да се
определи дали поискващите обекти имат разрешение да
изпълняват дейности във уеб приложението. Изпълнението на queries
е доста просто като ползваме *isAllowed()* метод:

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
        "allowed" : "denied"; // allowed because of inheritance from guest

   echo $acl->isAllowed('editor', null, 'update') ?
        "allowed" : "denied"; // denied because no allow rule for 'update'

   echo $acl->isAllowed('administrator', null, 'view') ?
        "allowed" : "denied"; // allowed because administrator is allowed all privileges

   echo $acl->isAllowed('administrator') ?
        "allowed" : "denied"; // allowed because administrator is allowed all privileges

   echo $acl->isAllowed('administrator', null, 'update') ?
        "allowed" : "denied"; // allowed because administrator is allowed all privileges


