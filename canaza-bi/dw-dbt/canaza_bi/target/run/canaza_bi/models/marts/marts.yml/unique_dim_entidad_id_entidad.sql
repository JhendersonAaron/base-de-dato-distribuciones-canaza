
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    id_entidad as unique_field,
    count(*) as n_records

from "canaza_dw"."marts"."dim_entidad"
where id_entidad is not null
group by id_entidad
having count(*) > 1



  
  
      
    ) dbt_internal_test