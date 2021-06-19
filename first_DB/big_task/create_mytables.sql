CREATE TABLE adress (
    adress_id SERIAL,
    region VARCHAR(10) NOT NULL,
    city VARCHAR(10) NOT NULL,
    street VARCHAR(10) NOT NULL,
    building INT NOT NULL,
    PRIMARY KEY (adress_id)
);
CREATE TABLE models (
    model_id SERIAL,
    model VARCHAR(10) NOT NULL,
    price INT NOT NULL CHECK (price > 0),
    PRIMARY KEY (model_id)
);
CREATE TABLE branches (
    branch_id SERIAL,
    branch_name VARCHAR(10) NOT NULL,
    branch_tel VARCHAR(20) NOT NULL CHECK (
        branch_tel LIKE '380%'
        OR branch_tel LIKE '0%'
    ),
    adress_id INT NOT NULL,
    PRIMARY KEY (branch_id),
    FOREIGN KEY (adress_id) REFERENCES adress(adress_id)
);
CREATE TABLE cars (
    cars_id SERIAL,
    branch_id INT NOT NULL,
    model_id INT NOT NULL,
    cars_number VARCHAR(20),
    PRIMARY KEY (cars_id),
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    FOREIGN KEY (model_id) REFERENCES models(model_id)
);
CREATE TABLE clients (
    clients_id SERIAL,
    clients_name VARCHAR(50) NOT NULL,
    clients_tel VARCHAR(20) NOT NULL CHECK (
        clients_tel LIKE '380%'
        OR clients_tel LIKE '0%'
    ),
    adress_id INT NOT NULL,
    PRIMARY KEY (clients_id),
    FOREIGN KEY (adress_id) REFERENCES adress(adress_id)
);
CREATE TABLE rent(
    order_id SERIAL,
    date_of_renting DATE DEFAULT date(now() + interval '1 day'),
    period_of_renting INT DEFAULT 1,
    cars_id INT NOT NULL,
    clients_id INT NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (cars_id) REFERENCES cars(cars_id),
    FOREIGN KEY (clients_id) REFERENCES clients(clients_id)
);