.. _user-guide-forms-and-actions:

####################
Formlar ve Actionlar
####################

Yeni albümler eklemek
---------------------

Artık yeni albüm ekleme fonksiyonelliğini kodlayabiliriz. Bu bölümde iki işlem
var:

* Ayrıntıları sağlamak için kullanıcıya form sağlamak
* Gönderilen formu işle ve veritabanında saklamak

Bunları yapabilmek için ``Zend\Form`` kullanacağız. ``Zend\Form`` komponenti
formları yönetir ve doğrulama için ``Album`` entity’sine ``Zend\InputFilter``
ekleyeceğiz. ``Album\Form\AlbumForm`` sınıfını ``Zend\Form\Form`` sınıfından
genişletip formumuzu tanımlayarak başlayacağız. Bu sınıf,
``module/Album/src/Album/Form`` dizini içinde ``AlbumForm.php`` dosyasında
saklanmalı.

Bu dosyayı şimdi oluşturalım:

.. code-block:: php

    // module/Album/src/Album/Form/AlbumForm.php:
    namespace Album\Form;

    use Zend\Form\Form;

    class AlbumForm extends Form
    {
        public function __construct($name = null)
        {
            // aktarılan isimi görmezden geliyoruz.
            parent::__construct('album');
            $this->setAttribute('method', 'post');
            $this->add(array(
                'name' => 'id',
                'type' => 'Hidden',
            ));
            $this->add(array(
                'name' => 'artist',
                'type' => 'Text',
                'options' => array(
                    'label' => 'Sanatçı',
                ),
            ));
            $this->add(array(
                'name' => 'title',
                'type' => 'Text',
                'options' => array(
                    'label' => 'Başlık',
                ),
            ));
            $this->add(array(
                'name' => 'submit',
                'type' => 'Submit',
                'attributes' => array(
                    'value' => 'Git',
                    'id' => 'submitbutton',
                ),
            ));
        }
    }

``AlbumForm``’un yapıcısında (constructor), ebeveynin yapıcısını çağırırken
ismi tanımlıyoruz sonra formun metodunu ayarlıyoruz ve sonra id, artist, title
ve gönder butonu için elementleri tanımlıyoruz. Her element için çeşitli
öznitelikleri ve opsiyonları, görüntülecek etiketleri ile birlikte tanımlıyoruz.

Ayrıca bu form için doğrulama kurulumu yapmamız gerekiyor. Zend Framework 2’de
bu işlem bir girdi filitresi (input filter) kullanılarak yapılır. Bu komponent
standalone olabilir ya da ``InputFilterAwareInterface`` arayüzünü uygulayan
herhangi bir sınıfa aktarılabilir. Biz girdi filitresini ``Album`` entity'imize
ekleyeceğiz.

We also need to set up validation for this form. In Zend Framework 2 this is
done using an input filter which can either be standalone or within any class
that implements ``InputFilterAwareInterface``, such as a model entity. We are
going to add the input filter to our ``Album`` entity:

.. code-block:: php

    // module/Album/src/Album/Model/Album.php:
    namespace Album\Model;

    use Zend\InputFilter\Factory as InputFactory;
    use Zend\InputFilter\InputFilter;
    use Zend\InputFilter\InputFilterAwareInterface;
    use Zend\InputFilter\InputFilterInterface;

    class Album implements InputFilterAwareInterface
    {
        public $id;
        public $artist;
        public $title;
        protected $inputFilter;

        public function exchangeArray($data)
        {
            $this->id     = (isset($data['id']))     ? $data['id']     : null;
            $this->artist = (isset($data['artist'])) ? $data['artist'] : null;
            $this->title  = (isset($data['title']))  ? $data['title']  : null;
        }

        public function setInputFilter(InputFilterInterface $inputFilter)
        {
            throw new \Exception("Not used");
        }

        public function getInputFilter()
        {
            if (!$this->inputFilter) {
                $inputFilter = new InputFilter();
                $factory     = new InputFactory();

                $inputFilter->add($factory->createInput(array(
                    'name'     => 'id',
                    'required' => true,
                    'filters'  => array(
                        array('name' => 'Int'),
                    ),
                )));

                $inputFilter->add($factory->createInput(array(
                    'name'     => 'artist',
                    'required' => true,
                    'filters'  => array(
                        array('name' => 'StripTags'),
                        array('name' => 'StringTrim'),
                    ),
                    'validators' => array(
                        array(
                            'name'    => 'StringLength',
                            'options' => array(
                                'encoding' => 'UTF-8',
                                'min'      => 1,
                                'max'      => 100,
                            ),
                        ),
                    ),
                )));

                $inputFilter->add($factory->createInput(array(
                    'name'     => 'title',
                    'required' => true,
                    'filters'  => array(
                        array('name' => 'StripTags'),
                        array('name' => 'StringTrim'),
                    ),
                    'validators' => array(
                        array(
                            'name'    => 'StringLength',
                            'options' => array(
                                'encoding' => 'UTF-8',
                                'min'      => 1,
                                'max'      => 100,
                            ),
                        ),
                    ),
                )));

                $this->inputFilter = $inputFilter;
            }

            return $this->inputFilter;
        }
    }

``InputFilterAwareInterface`` iki metod tanımlar: ``setInputFilter()`` ve
``getInputFilter()``. Biz sadece ``getInputFilter()``’ı kullanıyor olacağız. Bu
yüzden ``setInputFilter()`` metodunda Exception fırlatıyoruz.

``getInputFilter()`` içinde, bir ``InputFilter`` oturumu başlatıyoruz ve
ihtiyacımız olan girdileri ekliyoruz. Her özellik için filitrelemek ya da
doğrulamak istediğimiz ayrı bir girdi ekliyoruz. ``id`` boşluğu için sadece sayı
istediğimiz için ``Int`` filitresi ekliyoruz. Yazı elementlerinde, istenmeyen
HTML taglarından ve boşluklardan kurtulmak için iki filitre ekliyoruz:
``StripTags`` ve ``StringTrim``. Ayrıca *required* (gerekli) olarak işaretliyoruz
ve kullanıcının veritabanında tutabileceğimizden daha fazla karakter girmemesi
için ``StringLength`` doğrulaması ekliyoruz.

Şimdi formu gösterim için hazırlamamız, gönderi olduğunda da işlememiz gerekiyor.
Bu işlem ``AlbumController``’ın ``addAction()``’unda yapılır:

.. code-block:: php
    :emphasize-lines: 6-7,10-31

    // module/Album/src/Album/Controller/AlbumController.php:

    //...
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;
    use Album\Model\Album;          // <-- Bu import deyimini ekleyin
    use Album\Form\AlbumForm;       // <-- Bu import deyimini ekleyin
    //...

        // Bu metoda içerik ekleyin:
        public function addAction()
        {
            $form = new AlbumForm();
            $form->get('submit')->setValue('Ekle');

            $request = $this->getRequest();
            if ($request->isPost()) {
                $album = new Album();
                $form->setInputFilter($album->getInputFilter());
                $form->setData($request->getPost());

                if ($form->isValid()) {
                    $album->exchangeArray($form->getData());
                    $this->getAlbumTable()->saveAlbum($album);

                    // Albüm listesine yönlendir.
                    return $this->redirect()->toRoute('album');
                }
            }
            return array('form' => $form);
        }
    //...

``AlbumForm``’unu ``use`` listesine ekledikten sonra ``addAction()``’u
güncelliyoruz. Şimdi ``addAction()`` koduna daha ayrıntılı bir şekilde bakalım:

.. code-block:: php

    $form = new AlbumForm();
    $form->get('submit')->setValue('Ekle');

``AlbumForm``’u için yeni bir oturum başlatıyor ve gönder butonunun etiketini
“Ekle” olarak değiştiriyoruz. Bunu yapma amacımız, düzenleme işleminde aynı formu
kullanabilmemizdir. Düzenle işleminde farklı bir etiketle değiştireceğiz.

.. code-block:: php

    $request = $this->getRequest();
    if ($request->isPost()) {
        $album = new Album();
        $form->setInputFilter($album->getInputFilter());
        $form->setData($request->getPost());
        if ($form->isValid()) {

Eğer ``Request`` (Talep) nesnesinin ``isPost()`` metodu true (doğru) ise, form
kullanıcı tarafından gönderilmiş ve biz formun girdi filitresini ayarlayabiliriz
demektir. Bu işlemi yaptıktan sonra kullanıcıdan gelen bilgileri form nesnesine
aktarıyoruz ve ``isValid()`` metodunu kullanarak bu girdiler üzerinde gerekli
filitreleme ve doğrulama işlemlerini sınıf bizim için yapıyor.

.. code-block:: php

    $album->exchangeArray($form->getData());
    $this->getAlbumTable()->saveAlbum($album);

Eğer form geçerliyse, Formdan filitrelenmiş veriyi alıp, modelimizin
```saveAlbum()`` metoduna aktarıyoruz.

.. code-block:: php

    // Albüm listesine yönlendir.
    return $this->redirect()->toRoute('album');

Albümü yeni satır olarak ekledikten sonra ``Redirect`` controller eklentisini
(plugin) kullanarak albümleri listelediğimiz sayfaya yönlendiriyoruz.

.. code-block:: php

    return array('form' => $form);

Son olarak, view scriptinde tanımlı olmasını istediğimiz değişkenleri
döndürüyoruz. Bu senaryoda sadece form nesnesi. Dikkat ettiğiniz üzere Zend
Framework 2, view scriptine değişkenleri aktarabilmeniz için sadece dizi değişken
döndürmenize izin verir. ``ViewModel``’i sizin için arkaplanda oluşturur.
Bu, birkaç satır yazmaktan kurtarır.

Şimdi ``add.phtml`` dosyasında formu göstermemiz gerekiyor:

.. code-block:: php

    <?php
    // module/Album/view/album/album/add.phtml:

    $title = 'Yeni Albüm Ekle';
    $this->headTitle($title);
    ?>
    <h1><?php echo $this->escapeHtml($title); ?></h1>
    <?php
    $form = $this->form;
    $form->setAttribute('action', $this->url('album', array('action' => 'add')));
    $form->prepare();

    echo $this->form()->openTag($form);
    echo $this->formHidden($form->get('id'));
    echo $this->formRow($form->get('title'));
    echo $this->formRow($form->get('artist'));
    echo $this->formSubmit($form->get('submit'));
    echo $this->form()->closeTag();

Yine, daha önce yaptığımız gibi bir başlık tanımlıyoruz ve sonrasında form’u
ekrana yazdırıyoruz. Zend Framework bu işlemi biraz basitleştirmek için bazı
view yardımcıları sağlar. ``form()`` view yardımcısı formu açıp kapatabilmemiz
için ``openTag()`` ve ``closeTag()`` metoduna sahiptir. Etiketi olan her
element için, ``formRow()``’u kullanıyoruz fakat standalone iki element için
``formHidden()`` ve ``formSubmit()`` metodunu kullanıyoruz.

.. image:: ../images/user-guide.forms-and-actions.add-album-form.png
    :width: 940 px

Alternatif olarak, ürünlerin gösterim için düzenlenmesi için ``formCollection``
view yardımcısı kullanılabilir. Mesela yukarıdaki view scriptteki bütün form
yazdırma deyimlerini aşağıdaki ile değiştirebilirsiniz:

.. code-block:: php

    echo $this->formCollection($form);

Bu işlem form yapısını yineliyerek, her element için ilgili etiket, element ve
hata view yardımcılarını çağıracaktır. Fakat hala açma ve kapatma etiketleri ile
``formCollection($form)``’u çevrelemek zorundasınız. Bu durum view scriptlerinizin,
normal HTML çıktısının yeterli olduğu durumlarda view scriptinizin karmaşıklığını
azaltmak için kullanılabilir.

Artık uygulamanızın “Yeni albüm ekle” linkini kullanarak, yeni albümler ekleyebiliyor
olmalısınız.

Albüm düzenleme
---------------

Albüm düzenlemek, yeni albüm eklemekle hemen hemen aynı, yani kodu çok benzer.
Bu defa ``AlbumController``’ın ``editAction()``’unu kullanıyoruz:

.. code-block:: php

    // module/Album/src/Album/Controller/AlbumController.php:
    //...

        // Add content to this method:
        public function editAction()
        {
            $id = (int) $this->params()->fromRoute('id', 0);
            if (!$id) {
                return $this->redirect()->toRoute('album', array(
                    'action' => 'add'
                ));
            }
            $album = $this->getAlbumTable()->getAlbum($id);

            $form  = new AlbumForm();
            $form->bind($album);
            $form->get('submit')->setAttribute('value', 'Düzenle');

            $request = $this->getRequest();
            if ($request->isPost()) {
                $form->setInputFilter($album->getInputFilter());
                $form->setData($request->getPost());

                if ($form->isValid()) {
                    $this->getAlbumTable()->saveAlbum($form->getData());

                    // Redirect to list of albums
                    return $this->redirect()->toRoute('album');
                }
            }

            return array(
                'id' => $id,
                'form' => $form,
            );
        }
    //...

Bu kod, size tanıdık gelmeli. Şimdi yeni albüm ekleme işlemi ile farklılıklarını
inceleyelim. İlk önce eşleşen route’un ``id`` parametresini düzenleyeceğimiz
albümü bulmak için alıyoruz.

.. code-block:: php

    $id = (int) $this->params()->fromRoute('id', 0);
    if (!$id) {
        return $this->redirect()->toRoute('album', array(
            'action' => 'add'
        ));
    }
    $album = $this->getAlbumTable()->getAlbum($id);

``params()``, eşleşen route’dan parametreleri alabilmek için kullanılan
controller eklentisidir (plugin). Bu eklentiyi ``module.config.php`` dosyasında
tanımlı olan route’dan ``id`` parametresini çekmek için kullanıyoruz. Eğer
``id`` sıfır (0) ise ekle action’una yönlendiriyoruz. Değilse işlemlere
devam ediyoruz ve veritabanından ilgili albüm entity’sini çekiyoruz.

.. code-block:: php

    $form = new AlbumForm();
    $form->bind($album);
    $form->get('submit')->setAttribute('value', 'Edit');

Formun ``bind()`` metodu modeli, forma bağlıyor. Bu işlem iki yol için kullanılır:

# Form gösterilirken, her elementin modelden çıkarılmış değerinin formda
  gösterilmesini sağlamak.
# ``isValid()`` metodundaki doğrulamanın başarılı olmasından sonra formdaki
  veriyi modele geri aktarmak.

Bu operasyonlar hydrator (sulayıcı) nesnesi kullanılarak yapılır. Birkaç çeşit
hydrator mevcut fakat varsayılan olanı ``Zend\Stdlib\Hydrator\ArraySerializable``’dir.
Bu hydrator model içinde iki metod arar: ``getArrayCopy()`` ve ``exchangeArray()``.
Biz zaten ``exchangeArray()`` olanı ``Album`` entity’miz içinde yazmıştık. Şimdi
sadece ``getArrayCopy()`` olanı yazmamız gerekiyor:

.. code-block:: php
    :emphasize-lines: 10-14

    // module/Album/src/Album/Model/Album.php:
    // ...
        public function exchangeArray($data)
        {
            $this->id     = (isset($data['id']))     ? $data['id']     : null;
            $this->artist = (isset($data['artist'])) ? $data['artist'] : null;
            $this->title  = (isset($data['title']))  ? $data['title']  : null;
        }

        // Add the following method:
        public function getArrayCopy()
        {
            return get_object_vars($this);
        }
    // ...

Hydrator’unu ``bind()`` metoduyla kullanmanın sonucu olarak, zaten otomatik
olarak hallolduğu için formun verisini ``$album`` değişkenine geri almamıza
gerek yok. Böylelikle sadece yönlendiricimizin ``saveAlbum()`` metodunu
kullanarak değişiklikleri veritabanımıza geri alabiliriz.

``edit.phtml`` view scripti, albüm ekle view scripti ile çok benzer:

.. code-block:: php

    <?php
    // module/Album/view/album/album/edit.phtml:

    $title = 'Albüm Düzenle';
    $this->headTitle($title);
    ?>
    <h1><?php echo $this->escapeHtml($title); ?></h1>

    <?php
    $form = $this->form;
    $form->setAttribute('action', $this->url(
        'album',
        array(
            'action' => 'edit',
            'id'     => $this->id,
        )
    ));
    $form->prepare();

    echo $this->form()->openTag($form);
    echo $this->formHidden($form->get('id'));
    echo $this->formRow($form->get('title'));
    echo $this->formRow($form->get('artist'));
    echo $this->formSubmit($form->get('submit'));
    echo $this->form()->closeTag();

Tek değişenler, sayba başlığının ‘Albüm Ekle’ olarak değiştirilmiş olması ve
formun action’unun değiştirilmiş olması.

Artık albümlerinizi düzenleyebilmeniz gerekiyor.

Albüm silmek
------------

Uygulamamızı toparlamak için, albüm silme işlemini eklememiz gerekiyor. Albüm
listesinde her albümün yanında sil linki bulunmakta. Acemi yaklaşım, sil linkine
tıkladığınızda albümü silmek olacak. Bu yanlış olacaktır. HTTP spec’imizi
hatırlayarak, GET metodu ile geri alınamaz bir işlem yapmamalısınız. POST
metodu kullanmak daha doğru olacaktır.

Kullanıcıya, silmek isteyip istemediğini onaylamak için bir form göstermeli ve
“evet” tıklandığında silme işlemini yapmalıyız. Form çok ufak birşey olduğu için
direkt olarak view dosyamıza kodlayacağız (sonuçta ``Zend\Form`` opsiyonel!).

Şimdi action kodu ile başlayalım ``AlbumController::deleteAction()``:

.. code-block:: php

    // module/Album/src/Album/Controller/AlbumController.php:
    //...
        // içeriği aşağıdaki metoda ekleyin:
        public function deleteAction()
        {
            $id = (int) $this->params()->fromRoute('id', 0);
            if (!$id) {
                return $this->redirect()->toRoute('album');
            }

            $request = $this->getRequest();
            if ($request->isPost()) {
                $del = $request->getPost('del', 'Hayır');

                if ($del == 'Evet') {
                    $id = (int) $request->getPost('id');
                    $this->getAlbumTable()->deleteAlbum($id);
                }

                // Albüm listesine yönlendir.
                return $this->redirect()->toRoute('album');
            }

            return array(
                'id'    => $id,
                'album' => $this->getAlbumTable()->getAlbum($id)
            );
        }
    //...

Daha önceki gibi eşleşen route’dan ``id``’yi alıyoruz ve konfirmasyonu
göstermemiz mi gerekiyor yoksa albümü silmek mi gerekiyor anlamak için ``isPost()``
metodunu kullanıyoruz. Tablo nesnesini ``deleteAlbum()`` metodunu kullanarak
satırı silmek ve albüm listesine geri yönlendirmek için kullanıyoruz. Eğer
talep (request) POST değilse, doğru veritabanını kaydını alarak ``id`` değeri
ile birlikte view scriptine aktarıyoruz.

View scripti basit bir form içeriyor:

.. code-block:: php

    <?php
    // module/Album/view/album/album/delete.phtml:

    $title = 'Delete album';
    $this->headTitle($title);
    ?>
    <h1><?php echo $this->escapeHtml($title); ?></h1>

    <p>
        '<?php echo $this->escapeHtml($album->artist) ?>'
        isimli sanatçının
        '<?php echo $this->escapeHtml($album->title) ?>'
        albümünü silmek istediğinizden emi misiniz?
    </p>
    <?php
    $url = $this->url('album', array(
        'action' => 'delete',
        'id'     => $this->id,
    ));
    ?>
    <form action="<?php echo $url; ?>" method="post">
    <div>
        <input type="hidden" name="id" value="<?php echo (int) $album->id; ?>" />
        <input type="submit" name="del" value="Evet" />
        <input type="submit" name="del" value="Hayır" />
    </div>
    </form>

Bu scriptte, kullanıcıya onay mesajını gösterip form içinde “Evet” ve “Hayır”
butonlarını gösteriyoruz. Action’da, albümü silmeden önce özellikle “Evet”
değerini kontrol ediyoruz.

Ana sayfanın albüm listesini gösterdiğinden emin olmak
------------------------------------------------------

Son bir final nokta. Şu an, ana sayfa http://zf2-tutorial.localhost/ adresi
albüm listesini göstermiyor.

Bunun sebebi, ``Application`` modülündeki route düzenlemesi. Değiştirmek için
``module/Application/config/module.config.php`` dosyasını açın ve ``home``
route’unu bulun:

.. code-block:: php

    'home' => array(
        'type' => 'Zend\Mvc\Router\Http\Literal',
        'options' => array(
            'route'    => '/',
            'defaults' => array(
                'controller' => 'Application\Controller\Index',
                'action'     => 'index',
            ),
        ),
    ),

``controller`` değerinin karşılığını ``Application\Controller\Index``’ten
``Album\Controller\Album``’e değiştirin

.. code-block:: php
    :emphasize-lines: 6

    'home' => array(
        'type' => 'Zend\Mvc\Router\Http\Literal',
        'options' => array(
            'route'    => '/',
            'defaults' => array(
                'controller' => 'Album\Controller\Album', // <-- burayı değiştirin
                'action'     => 'index',
            ),
        ),
    ),

Hepsi bu kadar. Artık tamamiyle çalışan bir uygulamanız var!
