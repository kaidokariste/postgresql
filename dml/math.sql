-- Calculate the percentage of successful loads compared to all loads
select round(count(1) filter (where load_status = 'SUCCESS') / count(1)::DECIMAL * 100,2) from mySchema.myDataLoad;

