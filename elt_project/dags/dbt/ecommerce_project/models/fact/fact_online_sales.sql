SELECT 
    os.transaction_id,
    os.customer_id,
    os.product_id,
    os.transaction_date,
    os.delivery_charges,  
    os.price,
    os.quantity,
    os.coupon_status,
    -- Jika status kupon 'Used', ambil kode kupon dari tabel discount_coupon, jika tidak, isi 'not used'
    CASE 
        WHEN os.coupon_status = 'Used' THEN dc.coupon_code
        ELSE 'not used'
    END AS coupon_code,
    -- Ambil goods_services_tax dari tabel dim_tax_amount
    dta.goods_services_tax,
    -- Jika kupon digunakan, ambil discount_pct dari tabel discount_coupon, jika tidak, isi 0
    CASE 
        WHEN os.coupon_status = 'Used' THEN dc.discount_pct
        ELSE 0
    END AS discount_pct,
    -- Perhitungan total_amount
    (
        (os.price * os.quantity) * (1 + dta.goods_services_tax) 
        + os.delivery_charges  
        - (os.price * os.quantity * (CASE WHEN os.coupon_status = 'Used' THEN dc.discount_pct ELSE 0 END) / 100)
    ) AS total_amount
FROM 
    {{ ref('int_online_sales') }} os
-- Join ke tabel dim_date untuk mendapatkan bulan berdasarkan transaction_date
JOIN 
    {{ ref('dim_date') }} dd ON os.transaction_date = dd.transaction_date
-- Join ke tabel dim_tax_amount untuk mendapatkan goods_services_tax berdasarkan kategori produk
JOIN 
    {{ ref('dim_tax_amount') }} dta ON os.product_category = dta.product_category
-- Left join ke tabel discount_coupon berdasarkan bulan dan kategori produk, jika ada kupon
LEFT JOIN 
    {{ ref('dim_discount_coupon') }} dc 
    ON dd.month = dc.month 
    AND os.product_category = dc.product_category


