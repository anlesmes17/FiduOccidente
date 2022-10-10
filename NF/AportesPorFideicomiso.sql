WITH


################################################ Arreglo Fechas ###################################################################
BaseConFechaIndividuales as (
SELECT right(left(FECHA_COMP,10),4) as FechaAdj,* FROM `favorable-mix-333022.FiduOccidente.20221007_Individuales` 
)

,FechaFinalIndividuales as(
  Select CASE
  WHEN FechaAdj="2017" OR FechaAdj="017 " Then 2017
  WHEN FechaAdj="2018" OR FechaAdj="018 " Then 2018
  WHEN FechaAdj="2019" OR FechaAdj="019 " Then 2019
  WHEN FechaAdj="2020" OR FechaAdj="020 " Then 2020
  WHEN FechaAdj="2021" Then 2021
  ELSE NULL END AS FechaAporte,*
  From BaseConFechaIndividuales
)


,BaseConFechaMasivos as (
SELECT right(left(FECHA_ARCH,10),4) as FechaAdj,* FROM `favorable-mix-333022.FiduOccidente.20221007_Masivos` 
)

,FechaFinalMasivos as(
  Select CASE
  WHEN FechaAdj="2017" OR FechaAdj="017 " Then 2017
  WHEN FechaAdj="2018" OR FechaAdj="018 " Then 2018
  WHEN FechaAdj="2019" OR FechaAdj="019 " Then 2019
  WHEN FechaAdj="2020" OR FechaAdj="020 " Then 2020
  WHEN FechaAdj="2021" Then 2021
  ELSE NULL END AS FechaAporte,*
  From BaseConFechaMasivos
)

,BaseConFechaNotasBancarias as (
SELECT right(left(FEC_REGISTRO,10),4) as FechaAdj,* FROM `favorable-mix-333022.FiduOccidente.20221007_NotasBancarias` 
)

,FechaFinalNotasBancarias as(
  Select CASE
  WHEN FechaAdj="2017" OR FechaAdj="017 " Then 2017
  WHEN FechaAdj="2018" OR FechaAdj="018 " Then 2018
  WHEN FechaAdj="2019" OR FechaAdj="019 " Then 2019
  WHEN FechaAdj="2020" OR FechaAdj="020 " Then 2020
  WHEN FechaAdj="2021" Then 2021
  ELSE 2021 END AS FechaAporte,*
  From BaseConFechaNotasBancarias
)


################################################# Todos los Fideicomisos ##############################################################
,Fideicomisos as(
SELECT distinct FechaAporte,Fideicomiso
FROM
(SELECT FechaAporte,Empresa as Fideicomiso FROM FechaFinalIndividuales
UNION ALL
SELECT FechaAporte,Fideicomiso FROM FechaFinalMasivos
UNION ALL
SELECT FechaAporte, Empresa as Fideicomiso FROM FechaFinalNotasBancarias
))

################################################## Aportes por fideicomiso #############################################################

,AportesIndividuales as(
  Select FechaAporte,Empresa,count(*) as AportIndividuales
  From FechaFinalIndividuales
  group by 1,2
  order by 3
)

,AportesMasivos as(
  Select FechaAporte,Fideicomiso,count(*) as AportMasivos
  From FechaFinalMasivos
  group by 1,2
  order by 3 
)

,AportesNotasBancarias as(
  Select FechaAporte,Empresa,count(*) as AportNotasBancarias
  From FechaFinalNotasBancarias
  group by 1,2
  order by 3 
)

,UnionIndividuales as(
  Select f.*,AportIndividuales, 
  From Fideicomisos f left join AportesIndividuales i
  ON f.FechaAporte=i.FechaAporte AND Fideicomiso=Empresa
)

,UnionMasivos as(
  Select f.*, AportMasivos
  From UnionIndividuales f left join AportesMasivos m
  ON f.FechaAporte=m.FechaAporte AND f.Fideicomiso=m.Fideicomiso
)

--,UnionNotasBancarias as(
  Select f.*, AportNotasBancarias
  From UnionMasivos f left join AportesNotasBancarias n
  ON f.FechaAporte=n.FechaAporte AND Fideicomiso=n.Empresa
--)

