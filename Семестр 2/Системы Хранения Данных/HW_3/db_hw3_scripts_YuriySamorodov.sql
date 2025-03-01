-- Вывести распределение (количество) клиентов по сферам деятельности, отсортировав результат по убыванию количества. — (1 балл)
	SELECT job_industry_category, COUNT(*) AS customer_count
	FROM customer
	GROUP BY job_industry_category
	ORDER BY customer_count DESC;

-- Найти сумму транзакций за каждый месяц по сферам деятельности, отсортировав по месяцам и по сфере деятельности. — (1 балл)
	SELECT 
	    TO_CHAR(TO_DATE(transaction_date, 'DD.MM.YYYY'), 'YYYY-MM') AS month,
	    c.job_industry_category,
	    SUM(t.list_price) AS total_transactions
	FROM transaction t
	JOIN customer c ON t.customer_id = c.customer_id
	GROUP BY month, c.job_industry_category
	ORDER BY month, c.job_industry_category;


-- Вывести количество онлайн-заказов для всех брендов в рамках подтвержденных заказов клиентов из сферы IT. — (1 балл)
	SELECT 
	    t.brand,
	    COUNT(*) AS online_order_count
	FROM transaction t
	JOIN customer c ON t.customer_id = c.customer_id
	WHERE c.job_industry_category = 'IT' AND t.order_status = 'Approved' AND t.online_order = 'TRUE'
	GROUP BY t.brand;


-- Найти по всем клиентам сумму всех транзакций (list_price), максимум, минимум и количество транзакций, отсортировав результат по убыванию суммы транзакций и количества клиентов. Выполните двумя способами: используя только group by и используя только оконные функции. Сравните результат. — (2 балла)
	
	---- GROUP BY
	SELECT 
	    customer_id,
	    SUM(list_price) AS total_transactions,
	    MAX(list_price) AS max_transaction,
	    MIN(list_price) AS min_transaction,
	    COUNT(*) AS transaction_count
	FROM transaction
	GROUP BY customer_id
	ORDER BY total_transactions DESC, transaction_count DESC;	
	---- Оконные функции
	SELECT 
	    customer_id,
	    SUM(list_price) OVER (PARTITION BY customer_id) AS total_transactions,
	    MAX(list_price) OVER (PARTITION BY customer_id) AS max_transaction,
	    MIN(list_price) OVER (PARTITION BY customer_id) AS min_transaction,
	    COUNT(*) OVER (PARTITION BY customer_id) AS transaction_count
	FROM transaction
	ORDER BY total_transactions DESC, transaction_count DESC;




-- Найти имена и фамилии клиентов с минимальной/максимальной суммой транзакций за весь период (сумма транзакций не может быть null). Напишите отдельные запросы для минимальной и максимальной суммы. — (2 балла)

	---- Минимальная сумма транзакций
		SELECT 
		    c.first_name,
		    c.last_name,
		    SUM(t.list_price) AS total_transactions
		FROM transaction t
		JOIN customer c ON t.customer_id = c.customer_id
		GROUP BY c.customer_id
		ORDER BY total_transactions ASC
		LIMIT 1;


	---- Максимальная сумма транзакций
		SELECT 
		    c.first_name,
		    c.last_name,
		    SUM(t.list_price) AS total_transactions
		FROM transaction t
		JOIN customer c ON t.customer_id = c.customer_id
		GROUP BY c.customer_id
		ORDER BY total_transactions DESC
		LIMIT 1;


-- Вывести только самые первые транзакции клиентов. Решить с помощью оконных функций. — (1 балл)
	select *
	FROM (
	    select
	    	*,
	        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY TO_DATE(transaction_date, 'DD.MM.YYYY')) AS row_number
	    FROM transaction
	) AS subquery
	WHERE row_number = 1;
	
	
	
-- Вывести имена, фамилии и профессии клиентов, между транзакциями которых был максимальный интервал (интервал вычисляется в днях) — (2 балла).

--- WHERE

	WITH TransactionIntervals AS (
	    SELECT 
	        c.customer_id,
	        c.first_name,
	        c.last_name,
	        c.job_title,
	        TO_DATE(t.transaction_date, 'DD.MM.YYYY') AS transaction_date,
	        LAG(TO_DATE(t.transaction_date, 'DD.MM.YYYY')) OVER (PARTITION BY c.customer_id ORDER BY TO_DATE(t.transaction_date, 'DD.MM.YYYY')) AS prev_transaction_date
	    FROM transaction t
	    JOIN customer c ON t.customer_id = c.customer_id
	)
	SELECT 
	    first_name,
	    last_name,
	    job_title,
	    MAX(transaction_date - prev_transaction_date) AS max_interval
	FROM TransactionIntervals
	/*
	 * нужно для исключения случаев, когда клиент совершил одну транзакцию/
	 * Для них max_interval всегда будет NULL, что искажает результаты.
	 * Если не использовать WHERE ... IS NOT NULL, в выборку попадут даже те, кто сделал покупку вчера, но это была единственная операция
	 */
	WHERE prev_transaction_date IS NOT null
	GROUP BY customer_id, first_name, last_name, job_title
	ORDER BY max_interval DESC
	LIMIT 1;



---- COALESCE
WITH TransactionIntervals AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.job_title,
        TO_DATE(t.transaction_date, 'DD.MM.YYYY') AS transaction_date,
        LAG(TO_DATE(t.transaction_date, 'DD.MM.YYYY')) OVER (PARTITION BY c.customer_id ORDER BY TO_DATE(t.transaction_date, 'DD.MM.YYYY')) AS prev_transaction_date
    FROM transaction t
    JOIN customer c ON t.customer_id = c.customer_id
)
SELECT 
    first_name,
    last_name,
    job_title,
    /*
     * COALESCE нужно для исключения случаев, когда клиент совершил одну транзакцию.
     * Для них max_interval всегда будет NULL, что искажает результаты.
     * Если не использовать COALESCE, в выборку попадут даже те, кто сделал покупку вчера, но это была единственная операция
     */
    MAX(COALESCE(transaction_date - prev_transaction_date, 0)) AS max_interval
FROM TransactionIntervals
GROUP BY customer_id, first_name, last_name, job_title
ORDER BY max_interval DESC
LIMIT 1;
