
-- ************************************** Region

CREATE TABLE IF NOT EXISTS Region
(
 region_id serial NOT NULL,
 region    varchar(7) NOT NULL,
 country   varchar(13) NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( region_id )
);

-- ************************************** "State"

CREATE TABLE IF NOT EXISTS "State"
(
 state_id  serial NOT NULL,
 "state"     varchar(20) NOT NULL,
 region_id serial NOT NULL,
 CONSTRAINT PK_9 PRIMARY KEY ( state_id ),
 CONSTRAINT FK_9 FOREIGN KEY ( region_id ) REFERENCES Region ( region_id )
);

CREATE INDEX FK_8 ON "State"
(
 region_id
);
-- ************************************** Address
drop table Address cascade;

CREATE TABLE IF NOT EXISTS Address
(
 address_id  serial NOT NULL,
 city        varchar(17) NOT NULL,
 postal_code integer NOT NULL,
 state_id    serial NOT NULL,
 CONSTRAINT PK_10 PRIMARY KEY ( address_id ),
 CONSTRAINT FK_8 FOREIGN KEY ( state_id ) REFERENCES "State" ( state_id )
);

CREATE INDEX FK_9 ON Address
(
 state_id
);


-- ************************************** Category

CREATE TABLE IF NOT EXISTS Category
(
 category_id   serial NOT NULL,
 category_name varchar(15) NOT NULL,
 CONSTRAINT PK_2 PRIMARY KEY ( category_id )
);

-- ************************************** Subcategory

CREATE TABLE IF NOT EXISTS Subcategory
(
 subcategory_id   varchar(15) NOT NULL,
 subcategory_name varchar(11) NOT NULL,
 category_id      serial NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY ( subcategory_id ),
 CONSTRAINT FK_3 FOREIGN KEY ( category_id ) REFERENCES Category ( category_id )
);

CREATE INDEX FK_1 ON Subcategory
(
 category_id
);

-- ************************************** Product

CREATE TABLE IF NOT EXISTS Product
(
 product_id     varchar(15) NOT NULL,
 product_name   varchar(127) NOT NULL,
 subcategory_id varchar(15) NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY ( product_id ),
 CONSTRAINT FK_2_1 FOREIGN KEY ( subcategory_id ) REFERENCES Subcategory ( subcategory_id )
);

CREATE INDEX FK_2 ON Product
(
 subcategory_id
);



-- ************************************** Segment

CREATE TABLE IF NOT EXISTS Segment
(
 segment_id   serial NOT NULL,
 segment_name varchar(11) NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( segment_id )
);



CREATE TABLE IF NOT EXISTS Customer
(
 customer_id   varchar(8) NOT NULL,
 customer_name varchar(22) NOT NULL,
 segment_id    serial NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY ( customer_id ),
 CONSTRAINT FK_6 FOREIGN KEY ( segment_id ) REFERENCES Segment ( segment_id )
);

CREATE INDEX FK_3 ON Customer
(
 segment_id
);

-- ************************************** Shipping

CREATE TABLE IF NOT EXISTS Shipping
(
 shipping_id   serial NOT NULL,
 shipping_name varchar(14) NOT NULL,
 CONSTRAINT PK_7 PRIMARY KEY ( shipping_id )
);




-- ************************************** "sales"

CREATE TABLE IF NOT EXISTS sales
(
 row_id      integer NOT NULL,
 order_id    varchar(14) NOT NULL,
 order_date  date NOT NULL,
 ship_date   date NOT NULL,
 sales       numeric(9,4) NOT NULL,
 quantity    integer NOT NULL,
 discount    numeric(4,2) NOT NULL,
 profit      numeric(21,16) NOT NULL,
 product_id  varchar(15) NOT NULL,
 customer_id varchar(8) NOT NULL,
 shipping_id serial NOT NULL,
 address_id  serial NOT NULL,
 CONSTRAINT PK_8 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_2 FOREIGN KEY ( product_id ) REFERENCES Product ( product_id ),
 CONSTRAINT FK_4 FOREIGN KEY ( address_id ) REFERENCES Address ( address_id ),
 CONSTRAINT FK_5 FOREIGN KEY ( customer_id ) REFERENCES Customer ( customer_id ),
 CONSTRAINT FK_7 FOREIGN KEY ( shipping_id ) REFERENCES Shipping ( shipping_id )
);


CREATE INDEX FK_4 ON sales
(
 product_id
);

CREATE INDEX FK_5 ON sales
(
 address_id
);

CREATE INDEX FK_6 ON sales
(
 customer_id
);

CREATE INDEX FK_7 ON sales 
(
 shipping_id
);

