# 📊 Uçtan Uca E-Ticaret Veri Analitiği ve Stratejik İş Zekası Projesi

Bu proje; ham bir e-ticaret veri setinin baştan sona işlenerek, şirketin finansal sağlığını, operasyonel verimliliğini ve müşteri sadakatini optimize etmek amacıyla geliştirilmiş bir **İş Zekası (Business Intelligence) ve Stratejik Analiz** çalışmasıdır.

Projenin temel amacı; departmanlar (Pazarlama, Lojistik, CRM, Tedarik) arası koordinasyonu güçlendirecek veri odaklı kararlar üretmek ve şirketin gizli kâr sızıntılarını tespit etmektir.

---

## 🔄 Proje Yaşam Döngüsü & Metodoloji (Genel Gidişat)

Proje, modern bir veri analitiği departmanının işleyişine uygun olarak 4 temel aşamada yürütülmüştür:

1. **Veri Keşfi ve Modelleme (SQL):** Ham veri tabanından ilişkisel yapılar konuşturularak makro ve mikro düzeyde iş sorularına yanıt arayan gelişmiş analitik sorgular kurgulanmıştır.
2. **Veri Temizliği ve Rafinasyon (Python):** Veri setindeki eksik, hatalı ve manipülatif kayıtlar filtrelenerek analizin "gürültüsüz" ve en doğru sonuçları vermesi sağlanmıştır.
3. **Mali ve Operasyonel Teşhis:** Şirketin ciro trendleri, pazar payları, ürün performansları ve müşteri yaşam döngüleri metrikleştirilmiştir.
4. **İş Zekası Entegrasyonu (Power BI):** Çıkarılan tüm stratejik metrikler, üst yönetimin anlık karar alabilmesini kolaylaştırmak adına dinamik panellere (dashboard) dönüştürülmüştür.

---

## 🚀 Büyük Resim: Stratejik İş İçgörüleri (Executive Summary)

### 📈 1. Makro Ciro ve Mevsimsellik Dengesi
* **Durum Tespiti:** Şirket genel hatlarıyla yukarı yönlü istikrarlı bir büyüme ivmesine sahiptir. Yılın ikinci yarısındaki hacim, ilk yarısına oranla %50 daha büyüktür. Ancak e-ticaretin doğası gereği sert bir mevsimsellik (seasonality) hakimdir; ciro Kasım ayında zirve yaparken, Nisan ayında dip noktayı görmektedir.
* **Stratejik Aksiyon:** Lojistik ve tedarik zinciri ekiplerinin yılın son çeyreğindeki (Q4) talep patlamasına göre konumlanması, Pazarlama ekibinin ise Nisan ayındaki ölü sezonu canlandıracak özel kampanyalara odaklanması kararlaştırılmıştır.

### 🌍 2. Pazarların Doğası ve Toptan Satış (B2B) Keşfi
* **Durum Tespiti:** Toplam ciro hacminde Birleşik Krallık (UK) pazarı lider olsa da, ülke bazlı "ortalama sepet büyüklükleri" incelendiğinde Hollanda, Avustralya ve Japonya'nın sipariş başına binlerce dolarlık hacimlerle öne çıktığı görülmüştür. Bu durum, bu ülkelerde bireysel tüketiciden ziyade kurumsal (B2B) alıcıların dominant olduğunu kanıtlamıştır.
* **Stratejik Aksiyon:** Bu ülkeler için bireysel kargo süreçleri yerine toptan navlun anlaşmaları kurgulanarak operasyonel lojistik maliyetleri düşürülmelidir.

### ⚠️ 3. Risk Yönetimi: Tek Pazar Bağımlılığı
* **Durum Tespiti:** Şirket gelirlerinin ezici bir çoğunluğu tek bir coğrafi pazara (Birleşik Krallık) bağımlıdır. Bu durum finansal sürdürülebilirlik açısından makro bir risk taşımaktadır.
* **Stratejik Aksiyon:** Finansal riskin coğrafi olarak dağıtılması (diversification) amacıyla, halihazırda büyüme potansiyeli gösteren Hollanda ve İrlanda gibi alternatif Avrupa pazarlarına bütçe ve operasyonel ağırlık verilmelidir.

### 🚨 4. Operasyonel Sızıntı: Uluslararası İade Krizi
* **Durum Tespiti:** Şirketin genel iade oranı %8.48 ile sağlıklı görünse de, pazar kırılımına inildiğinde Amerika (USA) pazarında %57.93, İrlanda (EIRE) pazarında ise %24.88 gibi şok edici iade oranları yakalanmıştır. Uluslararası iadelerin getirdiği tersine lojistik maliyetleri, bu pazarlardaki kâr marjını tamamen eritmektedir.
* **Stratejik Aksiyon:** USA ve İrlanda'daki yüksek iade oranlarının kök nedeni (kargo hasarı, gümrük takılması veya yanlış ürün tanımı) tespit edilip operasyon düzeltilene kadar bu bölgelerdeki agresif reklam harcamaları dondurulmalıdır.

### 👥 5. Müşteri Sağlığı ve Tutundurma (Retention) Performansı
* **Müşteri Bağlılığı:** Toplam müşteri tabanının %66.60'ı son 90 günde aktif olarak alışverişe devam etmektedir. Bu, markaya olan güvenin ve kemik kitlenin gücünü gösterir.
* **Tek Seferlik Alıcı Problemi:** Müşterilerin %34.42'si sitemizden sadece 1 kez alışveriş yapmış ve ardından pasifleşmiştir (Churn riski). Bu kitle, müşteri edinme maliyetinin (CAC) verimsiz yönetildiğine işaret eder. İlk alışverişini tamamlayan müşterilere otomatik "2. Siparişe Özel" teşvik mekanizmaları kurgulanarak bu sızıntının önüne geçilmesi önerilmiştir.


