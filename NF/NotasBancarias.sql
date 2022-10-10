With

BaseConFechaNotasBancarias as (
SELECT distinct right(left(FEC_REGISTRO,10),4) as FechaAdj,* FROM `favorable-mix-333022.FiduOccidente.20221007_NotasBancarias` 
)

--,FechaFinalNotasBancarias as(
  Select distinct CASE
  WHEN FechaAdj="2017" OR FechaAdj="017 " Then 2017
  WHEN FechaAdj="2018" OR FechaAdj="018 " Then 2018
  WHEN FechaAdj="2019" OR FechaAdj="019 " Then 2019
  WHEN FechaAdj="2020" OR FechaAdj="020 " Then 2020
  WHEN FechaAdj="2021" Then 2021
  ELSE 2021 END AS FechaAporte,*
  From BaseConFechaNotasBancarias
--)
