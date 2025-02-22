
-- Удаляем данные
/*
Обратил внимание, что значения в поле list_price содержат запятые. Из-за этого при импорте данных через скрипт вылетает ошибка:
ERROR:  invalid input syntax for type real: "71,49"
CONTEXT:  COPY transaction, line 2, column list_price: "71,49"

При импорте в UI меняется положение запятой, а, следовательно, искажаются данные.
 */

	truncate table customer;
	truncate table transaction;

/*
float(4) aka real требует точку в качестве разделителя.
Потому нужно либо поменять тип полей list_price и standrard_cost с FLOAT4 (REAL) на NUMERIC или DECIMAL,
но это не удовлетворяет условиям задачи
Либо поменять разделитель прямо в файле, но это неинтересно, так как изменит датасет.
Либо, нужна кастомная функция для преобразования запятых в точки, 
но она требует создания временной таблицы
Поэтому будем импортировать при помощи sed с заменой запятых на точки в режиме реального времени
 */
	
	/*
	 * Строки, где standard_price - пустое значение удалил, так как нулевой себестоимоси быть не может
	 * Строки, где online_order - пустое значение так же удалил, так как невозможно определить тип транзакции по другим полям
	 * Разделитель в новом файле transaction_cleared - запятая (отличается от оригинального файла)
	 * 	 
	 */
	
	COPY transaction
	FROM PROGRAM 'sed ''s/,/\./g'' ''/Users/yuriy.samorodov/Documents/МФТИ/Семестр 2/Системы Хранения Данных/HW_2/transaction_csv_clear.csv'''
	WITH (FORMAT csv, DELIMITER ';',  header);
	
	/*
	\COPY transaction FROM PROGRAM 'sed -i 's/,/./g' /Users/yuriy.samorodov/Documents/МФТИ/Семестр 2/Системы Хранения Данных/HW_2/transaction.csv'
	*/



-- Импортируем данные
	-- в таблицу customer
		COPY customer
		FROM '/Users/yuriy.samorodov/Documents/МФТИ/Семестр 2/Системы Хранения Данных/HW_2/customer.csv' 
		DELIMITER ';' 
		CSV HEADER;

	-- в таблицу transaction
		insert into transaction
		select
			transaction_id,
		    product_id,
		    customer_id,
		    transaction_date,
		    online_order,
		    order_status,
		    brand,
		    product_line,
		    product_class,
		    product_size,
		    format_decimal(list_price),
		    format_decimal(standard_cost)
		FROM '/Users/yuriy.samorodov/Documents/МФТИ/Семестр 2/Системы Хранения Данных/HW_2/transaction.csv' 
		DELIMITER ';' 
		CSV HEADER;

	-- в таблицу transaction
		COPY transaction
		FROM '/Users/yuriy.samorodov/Documents/МФТИ/Семестр 2/Системы Хранения Данных/HW_2/transaction.csv' 
		DELIMITER ';' 
		CSV HEADER;

