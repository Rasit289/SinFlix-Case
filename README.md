# SinFlix - Film Streaming Uygulaması

Modern Flutter teknolojileri ile geliştirilmiş, Clean Architecture prensiplerine uygun film streaming uygulaması. Kullanıcı deneyimi odaklı tasarım ve gelişmiş özelliklerle donatılmış profesyonel bir mobil uygulama.

## 🎬 Temel Özellikler

### 1. Kimlik Doğrulama Sistemi
- ✅ **Güvenli Giriş/Kayıt**: Kullanıcı kimlik doğrulama sistemi
- ✅ **Token Yönetimi**: JWT token'ların güvenli saklanması ve otomatik yenileme
- ✅ **Otomatik Yönlendirme**: Başarılı girişte ana sayfaya otomatik geçiş
- ✅ **Oturum Kontrolü**: Uygulama açılışında oturum durumu kontrolü

### 2. Ana Sayfa Özellikleri
- ✅ **Sonsuz Kaydırma**: Infinite scroll ile performanslı film listesi
- ✅ **Sayfalama**: Her sayfada 5 film gösterimi
- ✅ **Yükleme Göstergeleri**: Otomatik loading animasyonları
- ✅ **Pull-to-Refresh**: Aşağı çekerek yenileme özelliği
- ✅ **Anlık UI Güncellemesi**: Favori işlemlerinde anında görsel geri bildirim

### 3. Profil Yönetimi
- ✅ **Kullanıcı Bilgileri**: Detaylı profil görüntüleme
- ✅ **Favori Filmler**: Kullanıcının favori filmlerinin listesi
- ✅ **Fotoğraf Yükleme**: Profil fotoğrafı yükleme ve güncelleme
- ✅ **Profil Düzenleme**: Kullanıcı bilgilerini güncelleme

### 4. Navigasyon Sistemi
- ✅ **Bottom Navigation**: Modern tab bar navigasyonu
- ✅ **State Korunması**: Sayfa geçişlerinde state yönetimi
- ✅ **Smooth Transitions**: Akıcı sayfa geçişleri

## 🏗️ Mimari Yapı

### Clean Architecture


### State Management
- ✅ **BLoC Pattern**: Merkezi state yönetimi
- ✅ **MVVM**: Model-View-ViewModel mimarisi
- ✅ **Event-Driven**: Olay tabanlı state güncellemeleri

## 🛠️ Kullanılan Teknolojiler

### Core Technologies
- **Flutter 3.x**: Cross-platform mobil geliştirme
- **Dart 2.17+**: Modern programlama dili
- **BLoC**: State management pattern
- **Dio**: HTTP client ve API entegrasyonu

### UI/UX Technologies
- **Lottie**: Profesyonel animasyonlar
- **Custom Theme**: Özel tasarım sistemi
- **Material Design**: Modern UI bileşenleri
- **Responsive Design**: Farklı ekran boyutlarına uyum

### Development Tools
- **Dartz**: Functional programming utilities
- **Provider**: Dependency injection
- **Logger**: Gelişmiş loglama sistemi

## 🌟 Bonus Özellikler

### 1. Lokalizasyon Sistemi
- ✅ **Çoklu Dil Desteği**: Türkçe ve İngilizce
- ✅ **Dinamik Dil Değişimi**: Uygulama içi dil değiştirme
- ✅ **Kültürel Uyumluluk**: Bölgesel ayarlar

### 2. Animasyon Sistemi
- ✅ **Lottie Animasyonları**: Favori butonunda özel animasyonlar
- ✅ **Custom Snackbars**: Şık bildirim tasarımları
- ✅ **Smooth Transitions**: Akıcı geçiş animasyonları

### 3. Güvenlik Özellikleri
- ✅ **JWT Token Management**: Güvenli token yönetimi
- ✅ **Auth Interceptor**: Otomatik token yenileme
- ✅ **Secure Storage**: Güvenli veri saklama

### 4. Geliştirici Araçları
- ✅ **Logger Service**: Detaylı loglama sistemi
- ✅ **Error Handling**: Kapsamlı hata yönetimi
- ✅ **Debug Tools**: Geliştirme araçları

### 5. UX İyileştirmeleri
- ✅ **Splash Screen**: Profesyonel açılış ekranı
- ✅ **Loading States**: Yükleme durumları
- ✅ **Error States**: Hata durumları
- ✅ **Empty States**: Boş durum tasarımları

### 6. Firebase Crashlytics & Analytics
✅ Crashlytics: Uygulama çökme raporlarının otomatik toplanması ve analizi
✅ Analytics: Kullanıcı davranışları ve uygulama performansının detaylı takibi
✅ Real-time Monitoring: Gerçek zamanlı hata ve performans izleme
✅ Custom Events: Özel olayların (favori ekleme, film görüntüleme vb.) takibi
✅ User Journey Tracking: Kullanıcı yolculuğunun analizi ve optimizasyonu
✅ Performance Metrics: Uygulama hızı ve bellek kullanımının izlenmesi

Entegrasyon Özellikleri
-Otomatik Hata Yakalama: Try-catch blokları ile yakalanan hataların Firebase'e gönderilmesi
-Custom Error Reporting: Özel hata mesajları ve stack trace'lerin loglanması
-User Properties: Kullanıcı özelliklerinin (dil, tema, cihaz bilgisi) analitik verilerine dahil edilmesi
-Screen Tracking: Sayfa geçişlerinin ve kullanıcı etkileşimlerinin otomatik takibi
-Conversion Tracking: Önemli aksiyonların (giriş, favori ekleme) dönüşüm oranlarının izlenmesi

Geliştirici Avantajları
-Proactive Bug Detection: Çökme raporları ile proaktif hata tespiti
-User Experience Insights: Kullanıcı davranış analizi ile UX iyileştirmeleri
-Performance Optimization: Performans metrikleri ile optimizasyon fırsatları
-Data-Driven Decisions: Veri odaklı geliştirme kararları


## 📊 Performans Özellikleri

- ✅ **Lazy Loading**: Görüntülenen içeriklerin optimize yüklenmesi
- ✅ **Memory Management**: Bellek kullanımının optimize edilmesi
- ✅ **Network Optimization**: Ağ trafiğinin minimize edilmesi
- ✅ **Caching**: Akıllı önbellekleme sistemi

## 🎯 Değerlendirme Kriterleri

### ✅ Kod Kalitesi ve Organizasyon
- Clean Architecture prensiplerine uygunluk
- SOLID prensiplerinin uygulanması
- Kod okunabilirliği ve maintainability

### ✅ UI/UX Tasarımı
- Modern ve kullanıcı dostu arayüz
- Responsive tasarım
- Accessibility standartlarına uygunluk

### ✅ Performans Optimizasyonu
- Hızlı uygulama başlatma
- Smooth animasyonlar
- Düşük bellek kullanımı

### ✅ Best Practices
- Flutter best practices uygulanması
- State management best practices
- Error handling best practices



## 👨‍💻 Geliştirici

**Raşit Karabıyık

**Rasit289** - [GitHub Profili](https://github.com/Rasit289)


