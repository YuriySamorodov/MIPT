-- Удаляем таблицу, если существует
DROP TABLE IF EXISTS transaction;

-- Создание таблицы transaction
CREATE TABLE transaction (
    transaction_id INT4,         -- Уникальный идентификатор транзакции
    product_id INT4,            -- Идентификатор продукта
    customer_id INT4,           -- Идентификатор клиента
    transaction_date VARCHAR(30),-- Дата совершения транзакции
    online_order VARCHAR(30),   -- Признак онлайн-заказа
    order_status VARCHAR(30),   -- Статус заказа
    brand VARCHAR(30),          -- Бренд продукта
    product_line VARCHAR(30),   -- Линейка продуктов
    product_class VARCHAR(30),  -- Класс продукта
    product_size VARCHAR(30),   -- Размер продукта
    list_price FLOAT4,         -- Цена по прайс-листу
    standard_cost FLOAT4        -- Стандартная себестоимость продукта
);


-- Добавим комментарий к таблице
COMMENT ON TABLE transaction IS 'Таблица с информацией о транзакциях';

-- Добавим комментарии к столбцам
COMMENT ON COLUMN transaction.transaction_id IS 'Уникальный идентификатор транзакции';
COMMENT ON COLUMN transaction.product_id IS 'Идентификатор продукта';
COMMENT ON COLUMN transaction.customer_id IS 'Идентификатор клиента';
COMMENT ON COLUMN transaction.transaction_date IS 'Дата совершения транзакции';
COMMENT ON COLUMN transaction.online_order IS 'Признак онлайн-заказа';
COMMENT ON COLUMN transaction.order_status IS 'Статус заказа';
COMMENT ON COLUMN transaction.brand IS 'Бренд продукта';
COMMENT ON COLUMN transaction.product_line IS 'Линейка продуктов';
COMMENT ON COLUMN transaction.product_class IS 'Класс продукта';
COMMENT ON COLUMN transaction.product_size IS 'Размер продукта';
COMMENT ON COLUMN transaction.list_price IS 'Цена по прайс-листу';
COMMENT ON COLUMN transaction.standard_cost IS 'Стандартная себестоимость продукта';