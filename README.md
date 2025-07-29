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
```
lib/
├── presentation/     # UI Katmanı
│   ├── features/    # Özellik bazlı sayfalar
│   └── shared/      # Ortak widget'lar
├── domain/          # İş Mantığı Katmanı
│   ├── entities/    # Varlık sınıfları
│   ├── repositories/# Repository arayüzleri
│   └── usecases/    # İş mantığı use case'leri
└── data/            # Veri Katmanı
    ├── datasources/ # Veri kaynakları
    ├── models/      # Veri modelleri
    └── repositories/# Repository implementasyonları
```

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

## 📱 Ekran Görüntüleri

- **Ana Sayfa**: Film grid görünümü ve favori sistemi
- **Giriş/Kayıt**: Modern kimlik doğrulama ekranları
- **Profil**: Kullanıcı profili ve fotoğraf yükleme
- **Navigasyon**: Bottom tab bar ile sayfa geçişleri

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
- Flutter SDK 3.0.0 veya üzeri
- Dart 2.17.0 veya üzeri
- Android Studio / VS Code
- Git

### Kurulum Adımları

1. **Repository'yi klonlayın:**
```bash
git clone https://github.com/Rasit289/SinFlix-Case.git
cd SinFlix-Case
```

2. **Bağımlılıkları yükleyin:**
```bash
flutter pub get
```

3. **Uygulamayı çalıştırın:**
```bash
flutter run
```

### Platform Desteği
- ✅ **Android**: API Level 21+
- ✅ **iOS**: iOS 11.0+
- ✅ **Web**: Modern tarayıcılar

## 🔧 Konfigürasyon

### API Ayarları
Uygulamayı çalıştırmadan önce API endpoint'lerini yapılandırın:
```dart
// lib/data/datasources/ dosyalarında API URL'lerini güncelleyin
```

### Environment Variables
Gerekli environment değişkenlerini ayarlayın:
- API Base URL
- API Keys (gerekirse)

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

## 📄 Lisans

Bu proje NodeLabs case study olarak geliştirilmiştir.

## 👨‍💻 Geliştirici

**Rasit289** - [GitHub Profili](https://github.com/Rasit289)

---

<div align="center">

**SinFlix** ile film dünyasını keşfedin! 🎬✨

*Flutter ile ❤️ ile geliştirildi*

</div>
