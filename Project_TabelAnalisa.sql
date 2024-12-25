WITH tabel_general AS(
  SELECT 
  tr.transaction_id,
  tr.date,
  tr.branch_id,
  kc.branch_name,
  kc.kota,
  kc.provinsi,
  kc.rating AS rating_cabang,
  tr.customer_name,
  tr.product_id,
  pr.product_name,
  pr.price AS actual_price,
  tr.discount_percentage,
  CASE
    WHEN pr.price <= 50000 THEN 0.10
    WHEN pr.price > 50000 AND pr.price <= 100000 THEN 0.15
    WHEN pr.price > 100000 AND pr.price <= 300000 THEN 0.20
    WHEN pr.price > 300000 AND pr.price <= 500000 THEN 0.25
    WHEN pr.price > 500000 THEN 0.30
  END AS persentase_gross_laba,
  (pr.price - (pr.price * tr.discount_percentage)) AS nett_sales,
  tr.rating AS rating_transaksi
  FROM `Project_KimiaFarma.kf_final_transaction` AS tr
  LEFT JOIN `Project_KimiaFarma.kf_kantor_cabang` AS kc
  ON tr.branch_id = kc.branch_id
  LEFT JOIN `Project_KimiaFarma.kf_product` AS pr
  ON tr.product_id = pr.product_id
),

tabel_nett_profit AS(
  SELECT
  *,
  (actual_price * persentase_gross_laba) AS gross_profit,
  (actual_price - (actual_price * persentase_gross_laba)) AS biaya_produksi,
  (nett_sales - (actual_price - (actual_price * persentase_gross_laba))) AS nett_profit
  FROM tabel_general
)

SELECT 
transaction_id,
date,
branch_id,
branch_name,
kota,
provinsi,
rating_cabang,
customer_name,
product_id,
product_name,
actual_price,
discount_percentage,
persentase_gross_laba,
nett_sales,
nett_profit,
rating_transaksi,
FROM tabel_nett_profit
ORDER BY date ASC;
