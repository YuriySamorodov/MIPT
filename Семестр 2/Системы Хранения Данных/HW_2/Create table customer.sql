-- Удаляем таблицу, если существует
DROP TABLE IF EXISTS customer;

--  Создаем таблицу заново
CREATE TABLE customer (
    -- Базовая информация о клиенте
    customer_id INT4 PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    
    -- Персональная информация
    gender VARCHAR(30),
    dob VARCHAR(50),  -- Дата рождения клиента
    
    -- Информация о профессии
    job_title VARCHAR(50),
    job_industry_category VARCHAR(50),
    
    -- Финансовое положение клиента
    wealth_segment VARCHAR(50),
    deceased_indicator VARCHAR(50),
    owns_car VARCHAR(30),
    
    -- Место проживания клиента
    address VARCHAR(50),
    postcode VARCHAR(30),
    state VARCHAR(30),
    country VARCHAR(30),
    
    -- Оценка собственности
    property_valuation INT4
);

-- Добавим комментари к таблице
COMMENT ON TABLE customer IS 'Таблица с информацией о клиентах';

-- Add column comments
COMMENT ON COLUMN customer.customer_id IS 'id клиента';
COMMENT ON COLUMN customer.first_name IS 'имя клиента';
COMMENT ON COLUMN customer.last_name IS 'фамилия клиента';
COMMENT ON COLUMN customer.gender IS 'пол';
COMMENT ON COLUMN customer.dob IS 'дата рождения';
COMMENT ON COLUMN customer.job_title IS 'профессия';
COMMENT ON COLUMN customer.job_industry_category IS 'сфера деятельности';
COMMENT ON COLUMN customer.wealth_segment IS 'сегмент благосостояния';
COMMENT ON COLUMN customer.deceased_indicator IS 'флаг актуального клиента';
COMMENT ON COLUMN customer.owns_car IS 'флаг наличия автомобиля';
COMMENT ON COLUMN customer.address IS 'адрес проживания';
COMMENT ON COLUMN customer.postcode IS 'почтовый индекс';
COMMENT ON COLUMN customer.state IS 'штаты';
COMMENT ON COLUMN customer.country IS 'страна проживания';
COMMENT ON COLUMN customer.property_valuation IS 'оценка имущества';