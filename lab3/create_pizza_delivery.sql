-- Создание и использование БД
CREATE database `Pizza delivery`;
USE `Pizza delivery`;

-- Создание таблиц в БД
CREATE table `ingredients` (
	id_ingridient int not null auto_increment,
    Name varchar(45) not null,
    Category varchar(45) not null,
    primary key (id_ingridient)
);

CREATE table `structure` (
	id_structure int not null auto_increment,
    quantity tinyint not null,
    id_ingridient int not null,
    primary key (id_structure)
);

CREATE table `pizza` (
	id_pizza int not null auto_increment,
    Name varchar(45) not null,
    Price mediumint unsigned not null,
    id_structure int not null,
    id_ingridient int not null,
    foreign key (id_structure) references structure (id_structure),
    foreign key (id_ingridient) references ingredients (id_ingridient),
    primary key (id_pizza)
);

CREATE table `feedback` (
	id_feedback int not null auto_increment,
    Text_feedback text not null,
    Raiting tinyint not null,
    primary key (id_feedback)
);

CREATE table `client` (
	id_client int not null auto_increment,
    `Name` varchar(60) not null,
    Phone varchar(15) not null,
    primary key (id_client)
);

CREATE table `courier` (
	id_courier int not null auto_increment,
    `Name` varchar(60) not null,
    Number_TS int not null,
    primary key (id_courier)
);

CREATE table `payment` (
	id_payment int not null auto_increment,
    Payment_method varchar(60) not null,
    Cost int not null,
    primary key (id_payment)
);

CREATE table `status` (
	id_status int not null auto_increment,
    `Description` tinytext not null,
    `Name` varchar(30) not null,
    primary key (id_status)
);

CREATE table `delivery` (
	id_delivery int not null auto_increment,
    Delivery_method varchar(60) not null,
    `Time` timestamp not null,
    id_courier int not null,
    foreign key (id_courier) references courier (id_courier),
    primary key (id_delivery)
);

CREATE table `order` (
	id_order int not null auto_increment,
    Cost int not null,
    Order_date timestamp not null,
    id_client int not null,
    id_payment int not null,
    id_delivery int not null,
    id_status int not null,
    id_feedback int not null,
    id_pizza int not null,
    foreign key (id_client) references client (id_client),
    foreign key (id_payment) references payment (id_payment),
    foreign key (id_delivery) references delivery (id_delivery),
    foreign key (id_status) references status (id_status),
    foreign key (id_feedback) references feedback (id_feedback),
    foreign key (id_pizza) references pizza (id_pizza),
    primary key (id_order)
);