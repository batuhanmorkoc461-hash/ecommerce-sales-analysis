use ecommerce_db;

-- PROJE: E-Ticaret Veri Analizi 

-- 1. VIEW (GÖRÜNÜM) TANIMLAMALARI

-- vw_sales: Temizlenmis, iptal edilmemis ve musteri bilgisi olan satis verisi
CREATE OR REPLACE VIEW vw_sales AS
SELECT 
    InvoiceNo AS invoice_no,
    StockCode AS stock_code,
    Description AS description,
    Quantity AS quantity,
    InvoiceDate AS invoice_date,
    UnitPrice AS unit_price,
    CustomerID AS customer_id,
    Country AS country,
    (Quantity * UnitPrice) AS total_price
FROM raw_data
WHERE Quantity > 0 
  AND UnitPrice > 0 
  AND CustomerID IS NOT NULL;

-- vw_returns: Sadece iade ve iptal edilen islemleri barindiran veri
CREATE OR REPLACE VIEW vw_returns AS
SELECT 
    InvoiceNo AS invoice_no,
    StockCode AS stock_code,
    Description AS description,
    ABS(Quantity) AS return_quantity,
    InvoiceDate AS invoice_date,
    UnitPrice AS unit_price,
    CustomerID AS customer_id,
    Country AS country,
    ABS(Quantity * UnitPrice) AS return_amount
FROM raw_data
WHERE (Quantity < 0 
  OR UnitPrice < 0)
  AND Description IS NOT NULL;


-- 2. GELIR ANALIZI (Revenue Analysis)


-- Sirketin Toplam Cirosu
SELECT ROUND(SUM(total_price), 2) AS toplam_ciro 
FROM vw_sales;

-- Sirketin Aylik Ciro Trendi
SELECT 
    DATE_FORMAT(invoice_date, '%Y-%m') AS tarihler, 
    ROUND(SUM(total_price), 2) AS toplam_ciro 
FROM vw_sales 
GROUP BY tarihler 
ORDER BY tarihler;

-- Şirketin aylık ciro trendi genel olarak istikrarlı bir yükseliş ivmesine (Büyüme trendine) sahiptir.
-- Yılın en yüksek cirosuna 2011-11 (Kasım) ayında 106.2 Milyon $ ile ulaşılmıştır. Ekim ve Aralık ayları da bu yüksek hacmi desteklemektedir.
-- E-ticaret sektöründeki "Black Friday" ve yılbaşı alışverişi gibi küresel kampanya dönemleri bu patlamanın ana nedenidir.
-- Tedarik zinciri ve lojistik ekipleri, sonraki yılların son çeyreği için depo kapasitelerini ve kargo anlaşmalarını bu yoğunluğa göre %100 optimize etmelidir.
-- İlkbahar döneminde tüketicilerin harcama alışkanlıklarında genel bir durgunluk gözlenmektedir.
-- Pazarlama ekibi, Nisan ve Şubat gibi ölü sezonlardaki durgunluğu kırmak adına özel "Bahar Fırsatları" veya "Sevgililer Günü" gibi agresif kupon ve sadakat kampanyaları kurgulamalıdır.


-- Sirketin Ulkelere Gore Ortalama Siparis ve Miktar Degeri

SELECT 
    country, 
    ROUND(AVG(total_price), 2) AS ortalama_ciro, 
    ROUND(AVG(quantity), 2) AS ortalama_miktar 
FROM vw_sales
GROUP BY country 
ORDER BY ortalama_ciro DESC;

-- Bu veri Netherlands (Hollanda), Australia (Avustralya) ve Japan (Japonya) gibi ülkelerin toptan ticaret  odaklı çalıştığını net bir şekilde kanıtlamaktadır.
-- Şirket bu ülkelere yönelik kargo ve gümrük süreçlerinde bireysel kargo yerine toptan lojistik uygulamaları kurgulamalıdır. Bu durum operasyon maliyetlerini ciddi oranda düşürecektir.

-- Sirketin En Cok Ciro Getiren Ilk 10 Urunu
SELECT 
    description, 
    ROUND(SUM(total_price), 2) AS toplam_ciro
FROM vw_sales 
GROUP BY description 
ORDER BY toplam_ciro DESC 
LIMIT 10;

-- PAPER CRAFT ve REGENCY CAKESTAND ürünleri satışların büyük kısmını sırtlamaktadır. 
-- Bu iki lider ürünün stok süreçleri çok sıkı takip edilmeli, tedarik zincirinde aksama yaşanmaması için emniyet stokları yüksek tutulmalıdır.

-- Sirketin Cirosuna En Cok Katki Saglayan Ilk 10 Ulke
SELECT 
    country, 
    ROUND(SUM(total_price), 2) AS toplam_harcama 
FROM vw_sales 
GROUP BY country 
ORDER BY toplam_harcama DESC 
LIMIT 10;

-- United Kingdom (Birleşik Krallık) pazarının 674 Milyon $ ile toplam ciroyu tek başına sırtladığı ve ezici bir üstünlüğe sahip olduğu görülmektedir.
-- En yakın pazar olan Netherlands (27 Milyon $) ile aradaki farkın bu denli açılması, şirketin tek bir coğrafi pazara aşırı bağımlı olduğunu ortaya koymaktadır.
-- Birleşik krallık pazarında oluşabilecek olası bir kriz durumunda şirket finansal açıdan büyük bir zarar görecektir.
-- Şirket bu pazara bağımlılığını azaltmak için Netherlands(hollanda) ve EIRE gibi ülkelere önem derecesini arttırmalıdır.

-- Sirketin En Cok Satip En Az Gelir Getiren Urunleri (Verimsiz Urunler)
SELECT 
    description, 
    SUM(quantity) AS toplam_miktar, 
    ROUND(SUM(total_price), 2) AS toplam_ciro, 
    ROUND(AVG(unit_price), 2) AS ortalama_birim_fiyat 
FROM vw_sales 
GROUP BY description 
HAVING toplam_miktar > 10000
ORDER BY ortalama_birim_fiyat ASC, toplam_miktar DESC;

-- Bu tarz ucuz ve çok satılan ürünler depoda çok fazla hacim kaplar, paketleme/işçilik maliyetlerini artırır ve kargo süreçlerinde lojistik yük oluşturur.
-- Bu ürünlerin ortalama birim fiyatları kârlılık marjını korumak adına %10-%15 oranında yukarı çekilmelidir.

-- 3. MUSTERI ANALIZI (Customer Analysis)


-- Sirketin Toplam Tekil Musteri Sayisi
SELECT COUNT(DISTINCT customer_id) AS musteri_sayisi 
FROM vw_sales;

-- Sirketin Aktif Musteri Orani (Son 90 Gun Baz Alinmistir)
SELECT 
    COUNT(DISTINCT CASE WHEN DATEDIFF((SELECT MAX(invoice_date) FROM vw_sales), invoice_date) <= 90 THEN customer_id END) AS aktif_musteri_sayisi,
    COUNT(DISTINCT customer_id) AS toplam_musteri_sayisi,
    ROUND(COUNT(DISTINCT CASE WHEN DATEDIFF((SELECT MAX(invoice_date) FROM vw_sales), invoice_date) <= 90 THEN customer_id END) * 100.0 / COUNT(DISTINCT customer_id), 2) AS aktif_musteri_orani_yuzdesi 
FROM vw_sales;

-- Pazarlama ekibi, bu 90 gündür uğramayan pasif müşterileri tekrar siteye çekmek adına "Sizi Özledik" temalı kişiselleştirilmiş
-- e-posta kampanyaları ve özel indirim kuponları kurgulamalıdır.

-- Sirketin Tek Seferlik Musteri Orani (Churn Riski)
SELECT 
    COUNT(CASE WHEN siparis_sayisi = 1 THEN 1 END) AS tek_seferlik_musteri_sayisi,
    COUNT(*) AS toplam_musteri_sayisi, 
    ROUND(COUNT(CASE WHEN siparis_sayisi = 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS tek_seferlik_orani_yuzdesi 
FROM (
    SELECT customer_id, COUNT(DISTINCT invoice_no) AS siparis_sayisi
    FROM vw_sales
    GROUP BY customer_id
) AS musteri_siparis_ozeti;

-- İlk siparişini tamamlayan müşterilere 2. siparişleri için özel indirim kuponu uygulanmalı.
-- Bu müşterilerin neden tek seferde kaldığını anlamak adına, ilk alışveriş sonrası kargo süresi, ürün kalitesi veya müşteri memnuniyeti 
-- anketleri incelenmeli, operasyonel bir kırılma olup olmadığı kontrol edilmelidir.

-- Sirketin En Cok Harcama Yapan Ilk 20 Musterisi
SELECT 
    customer_id, 
    ROUND(SUM(total_price), 2) AS toplam_harcama 
FROM vw_sales 
GROUP BY customer_id 
ORDER BY toplam_harcama DESC 
LIMIT 20;

-- Gelirin tek bir kişiye bağımlı olmadığı aksine oldukça dengeli bir dağılım sergilediği görülmektedir.
-- Bir müşterinin kaybedilmesi durumunda toplam ciroda devasa bir çöküş yaşanma riski düşüktür. Risk bu elit müşteri grubu arasında başarıyla dağılmıştır.


-- Sirketin En Sık Alisveris Yapan Ilk 20 Musterisi
SELECT 
    customer_id, 
    COUNT(DISTINCT invoice_no) AS siparis_sayisi 
FROM vw_sales 
GROUP BY customer_id 
ORDER BY siparis_sayisi DESC 
LIMIT 20;

-- Bu derece sık alışveriş yapan müşteriler için "Düzenli Sipariş / Abonelik (Subscription)" modeli kurgulanarak süreçleri daha da kolaylaştırılabilir.
-- 

-- Sirketin Ortalama Musteri Degeri (Siparis Basina Degil, Musteri Basina Toplam Harcama)
SELECT 
    ROUND(SUM(total_price) / COUNT(DISTINCT customer_id), 2) AS ortalama_musteri_degeri 
FROM vw_sales;


-- 4. MUSTERI DEGERI & PARETO ANALIZI (CLTV & Pareto)


-- Yillik Tahmini CLTV Hesabi
WITH musteri_metrig AS (
    SELECT 
        customer_id, 
        SUM(total_price) AS toplam_harcama,
        COUNT(DISTINCT invoice_no) AS toplam_siparis,
        DATEDIFF(MAX(invoice_date), MIN(invoice_date)) + 1 AS musteri_omru
    FROM vw_sales 
    GROUP BY customer_id
)
SELECT 
    customer_id,
    ROUND(toplam_harcama, 2) AS toplam_harcama, 
    toplam_siparis, 
    musteri_omru, 
    ROUND((toplam_harcama / toplam_siparis) * (toplam_siparis / musteri_omru) * 365, 2) AS yillik_tahmini_cltv
FROM musteri_metrig
ORDER BY yillik_tahmini_cltv DESC;

-- Sirketin Musteri Gelirine Gore NTILE Segmentleri
SELECT 
    customer_id, 
    ROUND(SUM(total_price), 2) AS toplam_harcama, 
    NTILE(5) OVER (ORDER BY SUM(total_price) DESC) AS gelir_segmenti
FROM vw_sales 
GROUP BY customer_id;

-- Sirketin En Dusuk Degerli ve Kaybedilmis Ilk 10 Musterisi
SELECT 
    customer_id, 
    ROUND(SUM(total_price), 2) AS toplam_harcama,
    COUNT(DISTINCT invoice_no) AS toplam_siparis,
    DATEDIFF((SELECT MAX(invoice_date) FROM vw_sales), MAX(invoice_date)) AS son_gorulme_gun_farki
FROM vw_sales 
GROUP BY customer_id 
HAVING toplam_harcama < 10000 AND son_gorulme_gun_farki > 100
ORDER BY toplam_harcama ASC 
LIMIT 10;

-- Bu kitle hem düşük değerli hem de çok uzun süredir pasif olduğu için, onları geri kazanmak adına agresif ve maliyetli reklam (retargeting) bütçeleri harcanmamalıdır.
-- Çünkü geri kazanma maliyeti, bu müşterilerin getireceği ömür boyu değerden (CLV) daha yüksek olacaktır.


-- 5. DAVRANIS ANALIZI (Behavior Analysis)



-- Sirketin Musterileri Ortalama Kac Siparis Veriyor?
SELECT ROUND(COUNT(DISTINCT invoice_no) / COUNT(DISTINCT customer_id), 2) AS ortalama_siparis_sayisi 
FROM vw_sales;

-- Sirketin Musterilerinin Siparis Basina Ortalama Urun Sayisi
SELECT 
    customer_id, 
    ROUND(SUM(quantity) / COUNT(DISTINCT invoice_no), 0) AS ortalama_urun_sayisi 
FROM vw_sales 
GROUP BY customer_id 
ORDER BY ortalama_urun_sayisi DESC;

-- Sirketin Musterileri Ne Siklikla Alisveris Yapiyor? (Tekrar Eden Musteriler Icin Ortalama Siparis Araligi)
SELECT 
    customer_id, 
    DATEDIFF(MAX(invoice_date), MIN(invoice_date)) AS toplam_gun_farki,
    COUNT(DISTINCT invoice_no) AS toplam_siparis,
    ROUND(DATEDIFF(MAX(invoice_date), MIN(invoice_date)) / (COUNT(DISTINCT invoice_no) - 1), 2) AS ortalama_gelme_sikligi 
FROM vw_sales
GROUP BY customer_id
HAVING toplam_siparis > 1 
ORDER BY ortalama_gelme_sikligi ASC;

-- Farkli Faturalarda En Sık Gorulen Ilk 10 Urun
SELECT 
    description, 
    COUNT(DISTINCT invoice_no) AS faturada_gorulme_sikligi, 
    SUM(quantity) AS toplam_satilan_adet
FROM vw_sales 
GROUP BY description 
ORDER BY faturada_gorulme_sikligi DESC
LIMIT 10;



-- 6. IADE & PROBLEM ANALIZI (Returns Analysis)



-- Sirketin Urunlerinin Toplam Iade Orani (Miktar Bazli)
SELECT 
    (SELECT SUM(quantity) FROM vw_sales) AS toplam_satis_miktari,
    (SELECT SUM(return_quantity) FROM vw_returns) AS toplam_iade_miktari,
    ROUND((SELECT SUM(return_quantity) FROM vw_returns) * 100.0 / (SELECT SUM(quantity) FROM vw_sales), 2) AS iade_orani_yuzdesi;

-- %8.48 iade oranı küçümsenemeyecek bir orandır. 438.377 adet ürünün iade alınması kargo maliyetleri, depodaki yeniden kalite kontrol mesaileri, 
-- hasarlı/kusurlu ürünlerin yarattığı doğrudan zarar ve müşteri memnuniyeti kaybı anlamına gelir.
-- en çok iade edilen ürün grupları tespit edilip ona göre aksiyon alınmalı.


-- Sirketin Urunlerinin Ulkelere Gore Iade Orani Yuzdesi
SELECT 
    s.country, 
    SUM(s.quantity) AS toplam_satis,
    COALESCE(SUM(r.return_quantity), 0) AS toplam_iade,
    ROUND(COALESCE(SUM(r.return_quantity), 0) * 100.0 / SUM(s.quantity), 2) AS iade_orani_yuzdesi
FROM vw_sales s
LEFT JOIN vw_returns r ON s.customer_id = r.customer_id AND s.stock_code = r.stock_code
GROUP BY s.country
HAVING toplam_satis > 100 
ORDER BY iade_orani_yuzdesi DESC;

-- USA (amerika) e giden ürünlerin yarısından fazlası iade oluyor. o bölgedeki iade sorunu tespit edilip düzeltilene kadar USA e reklam harcamaları dondurulmalıdır.

-- Sirketin En Cok Iade Edilen Ilk 10 Urunu
SELECT 
    description, 
    SUM(return_quantity) AS iade_edilen_miktar 
FROM vw_returns 
GROUP BY description 
ORDER BY iade_edilen_miktar DESC 
LIMIT 10;

-- Iade Edilen Urunlerin Toplam Ciroya Zarar Orani
SELECT 
    ROUND((SELECT SUM(return_amount) FROM vw_returns) * 100.0 / (SELECT SUM(total_price) FROM vw_sales), 2) AS iade_ciro_zarar_orani_yuzdesi;



-- 7. COGRAFI ANALIZ (Geographical Analysis)



-- Ulkelere Gore Toplam Gelir Dagilimi
SELECT 
    country, 
    ROUND(SUM(total_price), 0) AS toplam_gelir 
FROM vw_sales 
GROUP BY country 
ORDER BY toplam_gelir DESC;

-- Musteri Sayisi Yuksek Ama Cirosu Dusuk Potansiyel Ulke Analizi
WITH gruplanmis_sorgu AS (
    SELECT 
        country, 
        COUNT(DISTINCT customer_id) AS musteri_sayisi, 
        SUM(total_price) AS toplam_fiyat 
    FROM vw_sales 
    WHERE country <> 'United Kingdom' 
    GROUP BY country
)
SELECT 
    country, 
    musteri_sayisi, 
    ROUND(toplam_fiyat, 2) AS toplam_fiyat -- Raporlama için yuvarlama ekledik
FROM gruplanmis_sorgu 
WHERE musteri_sayisi > (SELECT AVG(musteri_sayisi) FROM gruplanmis_sorgu) 
  AND toplam_fiyat < (SELECT AVG(toplam_fiyat) FROM gruplanmis_sorgu);


-- 8. RFM SEGMENTASYONU (RFM Segmentation)



-- Sirketin Musteri Segmentasyonu 
WITH rfm_skorlar AS ( 
    SELECT 
        customer_id, 
        NTILE(5) OVER (ORDER BY MAX(invoice_date) ASC) AS r,
        NTILE(5) OVER (ORDER BY COUNT(DISTINCT invoice_no) ASC) AS f,
        NTILE(5) OVER (ORDER BY SUM(total_price) ASC) AS m
    FROM vw_sales 
    GROUP BY customer_id 
)
SELECT 
    customer_id, 
    r, f, m,
    CONCAT(r, f, m) AS rfm_skoru,
    CASE 
        WHEN (r = 5 AND f IN (4,5)) THEN 'Champions'
        WHEN (r IN (3,4) AND f IN (4,5)) THEN 'Loyal Customers'
        WHEN (r IN (4,5) AND f IN (2,3)) THEN 'Potential Loyalists'
        WHEN (r = 5 AND f = 1) THEN 'New Customers'
        WHEN (r = 4 AND f = 1) THEN 'Promising'
        WHEN (r = 3 AND f = 3) THEN 'Need Attention'
        WHEN (r IN (1,2) AND f = 5) THEN 'Cant Lose Them'
        WHEN (r IN (1,2) AND f IN (3,4)) THEN 'At Risk'
        WHEN (r IN (1,2) AND f IN (1,2)) THEN 'Hibernating'
        WHEN (r = 3 AND f IN (1,2)) THEN 'About to Sleep'
        ELSE 'Others' 
    END AS segment 
FROM rfm_skorlar 
ORDER BY r DESC, f DESC;

-- Tekrar Alisveris Yapan Musteri Orani (Retention Rate)
SELECT 
    ROUND(COUNT(CASE WHEN toplam_siparis > 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS tekrar_alisveris_yapan_musteri_orani_yuzdesi 
FROM ( 
    SELECT customer_id, COUNT(DISTINCT invoice_no) AS toplam_siparis 
    FROM vw_sales
    GROUP BY customer_id
) AS musteri_tablosu;