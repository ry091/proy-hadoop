data_raw = LOAD '/user/data/prueba.csv' USING PigStorage(',') AS (
    branch_addr:chararray, 
    branch_type:chararray, 
    taken:int, 
    target:chararray
);

-- Filtrar la primera línea si es un encabezado
data = FILTER data_raw BY branch_addr != 'branch_addr';
STORE data INTO '/sal/data' USING PigStorage(',');

-- Contar el número total de registros
records_count = FOREACH (GROUP data ALL) GENERATE 'Total records: ', COUNT(data);
STORE records_count INTO '/sal/cnt' USING PigStorage(',');

-- Analizar la distribución de 'branch_type'
branch_types = GROUP data BY branch_type;
type_counts = FOREACH branch_types GENERATE 'Type: ', group, 'Count: ', COUNT(data);

-- Guardar la distribución de 'branch_type'
STORE type_counts INTO '/sal/type' USING PigStorage(',');

-- Calcular la frecuencia de 'taken'
taken_counts = GROUP data BY taken;
taken_frequency = FOREACH taken_counts GENERATE 'Taken status: ', group, 'Frequency: ', COUNT(data);
STORE taken_frequency INTO '/sal/frec' USING PigStorage(',');
