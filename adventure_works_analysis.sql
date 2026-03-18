-- create database project;
use project;

-- select * from dimcustomer;
-- select * from dimdate;
-- select * from dimproduct;
-- select * from dimproductcategory;
-- select * from dimproductsubcategory;
-- select * from dimsalesterritory;
-- select * from factinternetsales;
-- select * from factinternetsalesnew;

select * from FactInternetSales
union all
select * from FactInternetSalesNew;


--------- Sales Amount -----------
select concat(round(sum(salesamount)/1000000,2),'M') as `Total Sales Amount` from ( 
select salesamount from FactInternetSales
union all
select salesamount from FactInternetSalesNew
) as combined_sales;

--------- Total Product Cost ------------
select concat(round(sum(totalproductcost)/1000000,2),'M') as `Total Product Cost` from (
select totalproductcost from FactInternetSales
union all
select totalproductcost from FactInternetSalesNew
) as combined_cost;

------------- Total Orders -------------
select concat(round(
((select count(*) from FactInternetSales) 
+ 
(select count(*) from FactInternetSalesNew)) / 1000,1),' k') 
as `Total Orders`;

------------ Profit ---------
select concat(round(sum(SalesAmount - totalproductcost)/1000000,2),'M') as Profit from (
select salesamount,totalproductcost from FactInternetSales
union all
select salesamount,totalproductcost from FactInternetSalesNew
) as Profit;

------------ Region wise Sales ------------
select t.SalesTerritoryRegion as Region,
    concat(round(sum(SalesAmount) / 1000000, 2), ' M') as TotalSales
from (select * from FactInternetSales
union all
select * from FactInternetSalesNew) s
join dimsalesterritory t
    on s.SalesTerritoryKey = t.SalesTerritoryKey
group by Region
order by TotalSales desc;

------------ Profit margin % ---------
select
   concat(round(
        (sum(salesamount - totalproductcost) / sum(SalesAmount)) * 100, 2
    ), '%') as `Profit Margin %`
from (select * from FactInternetSales
union all
select * from FactInternetSalesNew) as Profit_margin;

---------- customername wise sales ------------
select
    concat(c.FirstName, ' ', c.LastName) as CustomerName,
    concat(round(sum(SalesAmount) / 1000, 2), ' K') as TotalSales
from (select * from FactInternetSales
union all
select * from FactInternetSalesNew) s
join dimcustomer c
    on s.CustomerKey = c.CustomerKey
group by CustomerName
order by TotalSales desc
limit 10;