data_raw = LOAD '/user/data/data2.csv' USING PigStorage(',') AS (
    branch_addr:chararray, 
    branch_type:chararray, 
    taken:int, 
    target:chararray
);

data = FILTER data_raw BY branch_addr != 'branch_addr';


filtered_data = FILTER data BY taken == 1;
grouped_by_type = GROUP filtered_data BY branch_type;
counts_by_type = FOREACH grouped_by_type GENERATE group AS type, COUNT(filtered_data) AS count_taken_1;
STORE counts_by_type INTO '/sal_comp/taken' USING PigStorage(',');

-- Contar cuántos 'taken' son 1 y 0 para cada 'branch_type'
branch_type_taken = GROUP data BY branch_type;
branch_type_taken_count = FOREACH branch_type_taken {
    taken_0 = FILTER data BY taken == 0;
    taken_1 = FILTER data BY taken == 1;
    GENERATE group AS branch_type, COUNT(taken_0) AS count_taken_0, COUNT(taken_1) AS count_taken_1;
}
STORE branch_type_taken_count INTO '/sal_comp/tipostaken' USING PigStorage(',');

-- Identificar patrones de 'target' cuando 'taken' es 1
target_grouped = GROUP filtered_data BY target;
target_analysis = FOREACH target_grouped GENERATE group AS target, COUNT(filtered_data) AS frequency;
STORE target_analysis INTO '/sal_comp/target' USING PigStorage(',');

-- Identificar patrones en 'branch_addr' cuando 'taken' es 1
filtered_data = FILTER data BY taken == 1;
addr_patterns = GROUP filtered_data BY branch_addr;
addr_pattern_counts = FOREACH addr_patterns GENERATE group AS branch_addr, COUNT(filtered_data) AS count_taken_1;
STORE addr_pattern_counts INTO '/sal_comp/taken1' USING PigStorage(',');

-- Establecer relación entre branch_type y target
type_target_group = GROUP data BY (branch_type, target);
type_target_count = FOREACH type_target_group GENERATE FLATTEN(group) AS (type, target), COUNT(data) AS count;
STORE type_target_count INTO '/sal_comp/relacion' USING PigStorage(',');
