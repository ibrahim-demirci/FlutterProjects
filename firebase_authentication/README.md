# firebase_authentication

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



Firebase backendine ihtiyaç duyuyoruz.
Uygulamada database olmasa bile firebase authentication kullanılabilir.
Kimlik Doğrulama Authhenticationdur 
Yerel ve Remote olarak ayrılır.
- Herbir api için yazmamıza gerek kalmadan firebase ile sağlayabiliyoruz.
- gerekli kurulumları adamlar anlatmış
- flutterfire sitesinden her şeye erişebilrisin.
- core paketi mutlaka olmalıdır.
- user credentials buna bakıyor ve girişi yönlendiriyor. 
- firebase araya girerek apileri bize sağlıyor.
- neden anonim giriş yaptırmak isteriz. ( istatistik ve güvenlik için iyi bir şeydir)
- gerçek kullanıcı olmayanları engellemek için kullanılabilir.
- çoğu uygulama buna ihtiyaç duymayabilir.
- servis neden oluşturuyoruz ? bağlantı var mı yok mu sonuçlar kontrollü olmalıdır. İşçi sınıflara biz servi diyoruz.
- provider paketi sayesinde bir servisi yayınlıyoruz. Widgetttan her yerinden ulaşılabilmesi için.
- stream yapısı : Bir kaynaktan veri akar. Bu verinin kaç tane ne zaman gelceğini bilemeyiz. 
- paket alıyoruz içeriğin durumuna göre işlem yapıyoruz.
- Streamları futurelardan oluşmuş liste gibi düşünebiliriz.
- Stream networkden api paketten gelebilir.
- Stream yayınlayan bir fonksiyon olabilir.
- StreamController ile oluşturup stream yönetebiliriz.
- Kullanıcının login logout durumunu firebase bize gönderir stream olarak.
- Bir kez çağırıldığı zaman kullanıcının durumunu bir kere yollar. Sonra stream durur.
- Daha sonra bir giriş çıkış olursa bilgi yollanır.
- Singleton sadece bir obje olması gerekiyorsa singleton olur.
- Stream builder ile setstate initstate durumlarını kullanmıyorsun.
- RexEx konusunu öğrenirsek girişi filtreleyebiliriz.
- Herhangi bir authentication isteği yapıldığında UserCredential objeci döner.
- Google ile iletişime geçip token alıyoruz. Daha sonra token firebasede kontrol edilip devam ediyor.
- Sign out olurken ise iki sistemden de signout olmamız gerekir. 
- Unhandled uncaught hata varsa tehlikelidir.
- Her şeyi fırlatabilir. obje fırlatır çünkü.





