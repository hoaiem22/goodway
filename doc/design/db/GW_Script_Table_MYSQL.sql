drop table if exists goodway_delivery_batch;
drop table if exists goodway_order_detail_product;
drop table if exists goodway_order_master;
drop table if exists goodway_customer;
drop table if exists goodway_address;
drop table if exists goodway_vehicle_status;
drop table if exists goodway_vehicle;
drop table if exists goodway_product;
drop table if exists goodway_question;

create table goodway_address (
      id int not null auto_increment
    , city varchar(50)
    , district nvarchar(20)
    , ward nvarchar(50)
    , unit nvarchar(50)
	, street nvarchar(128)
	, house_no nvarchar(50)
	, display_address nvarchar(512)
    , enabled boolean
	, latitude double
	, longitude double
    , created datetime not null
    , createdby_username varchar(50) not null
    , lastmodified datetime
    , lastmodifiedby_username varchar(50) 
    , primary key (id)
);

create table goodway_customer (
      id int not null auto_increment
    , cd varchar(64) not null		   -- mã khách hàng.
	, seq_no int not null              -- Số thứ tự tăng liên tục. Cho biết số thứ tự Khách hàng.
	, address_id int not null		   -- Địa chỉ 1
	, address_id1 int not null		   -- Địa chỉ 2
	, address_id2 int not null		   -- Địa chỉ 3
	, address_id3 int not null		   -- Địa chỉ 4
	, address_id4 int not null		   -- Địa chỉ 5
	, version int not null             -- support to change information of customer in order
    , name nvarchar(128) not null
	, short_name varchar(30)		   -- Tên viết tắt
    , addr nvarchar(256)
	, addr_id int					   -- Id của Address: hỗ trợ cho lúc nhập liệu
    , representative nvarchar(100)
	, role nvarchar(100)               -- role of representative of customer
	, tax_id varchar(20)			   -- tax identification number of customer
	, note nvarchar(256)			   -- For customer note what they want.
    , cell_phone varchar(20)
    , phone varchar(20)
    , fax varchar(20)
    , email varchar(64)
    , web varchar(128)
	, mandatory_chars varchar(30)     -- mandatory characters of customer Code: Prefix
	, business_type varchar(30)       -- What type of business of customers ?
	, business_line varchar(30)		  -- What line of business are customers in ?	
    , attachment1 LONGBLOB
    , filename1 varchar(255)
    , attachment2 LONGBLOB
    , filename2 varchar(255)
    , attachment3 LONGBLOB
    , filename3 varchar(255)
    , created datetime not null
    , createdby_username varchar(50) not null
    , lastmodified datetime
    , lastmodifiedby_username varchar(50)
    , primary key (id)
	, constraint noduplicate unique (cd, version)
	, FOREIGN KEY (address_id) REFERENCES goodway_address(id)
	, FOREIGN KEY (address_id1) REFERENCES goodway_address(id)
	, FOREIGN KEY (address_id2) REFERENCES goodway_address(id)
	, FOREIGN KEY (address_id3) REFERENCES goodway_address(id)
	, FOREIGN KEY (address_id4) REFERENCES goodway_address(id)
);

create table goodway_order_master (
      id int not null auto_increment
    , name nvarchar(32) not null
	, customer_id int not null              -- Khách hàng
	, customer_address_no int not null      -- 1 trong 5 địa chỉ giao hàng của khách hàng
	, address_id int not null               -- Địa chỉ giao hàng đặc biệt ngoài 5 địa chỉ trên.
	, delivery_date datetime not null		-- Ngày giờ giao
    , created datetime not null
    , createdby_username varchar(50) not null
    , lastmodified datetime
    , lastmodifiedby_username varchar(50)
    , primary key (id)
	, FOREIGN KEY (customer_id) REFERENCES goodway_customer(id)
	, FOREIGN KEY (address_id) REFERENCES goodway_address(id)
);

create table goodway_product (
      id int not null auto_increment
	, name nvarchar(128) not null
	, description nvarchar(1024) not null
	, height double
	, width double
	, length double
	, weight double
    , created datetime not null
    , createdby_username varchar(50) not null
    , lastmodified datetime
    , lastmodifiedby_username varchar(50)
    , primary key (id)
);

create table goodway_order_detail_product (
      id int not null auto_increment
	, order_detail_id int not null
	, product_id int not null
	, order_id int not null
	, product_name nvarchar(128) not null
	, price double
	, quantity int
    , created datetime not null
    , createdby_username varchar(50) not null
    , lastmodified datetime
    , lastmodifiedby_username varchar(50)
    , primary key (id)
	, FOREIGN KEY (product_id) REFERENCES goodway_product(id)
	, FOREIGN KEY (order_id) REFERENCES goodway_order_master(id)
);

create table goodway_vehicle (
      id int not null auto_increment
	, name nvarchar(128) not null
	, height double
	, width double
	, length double
	, capacity double
	, quantity int
	, enabled boolean
    , created datetime not null
    , createdby_username varchar(50) not null
    , lastmodified datetime
    , lastmodifiedby_username varchar(50)
    , primary key (id)
);

create table goodway_vehicle_status (
      id int not null auto_increment
	, vehicle_id int not null
	, start_time datetime
	, end_time datetime
	, status int									-- 0: available; 1: busy
    , created datetime not null
    , createdby_username varchar(50) not null
    , lastmodified datetime
    , lastmodifiedby_username varchar(50)
    , primary key (id)
	, FOREIGN KEY (vehicle_id) REFERENCES goodway_vehicle(id)
);

create table goodway_delivery_batch (
      id int not null auto_increment
    , name varchar(32) not null
	, seq_no int not null              				-- Số thứ tự.
	, order_id int not null			   				-- đơn hàng
	, start_time datetime							-- thời gian dự kiến
	, end_time datetime
	, from_latitude double							-- toạ độ của địa điểm giao hàng trước đó
	, from_longitude double
	, to_latitude double							-- toạ độ của địa điểm giao đơn hàng này
	, to_longitude double
	, distance double								-- Khoảng cách từ địa điểm giao hàng trước đó đến địa điểm giao đơn hàng này: km 
    , created datetime not null
    , createdby_username varchar(50) not null
    , lastmodified datetime
    , lastmodifiedby_username varchar(50)
    , primary key (id)
	, FOREIGN KEY (order_id) REFERENCES goodway_order_master(id)
);

CREATE TABLE goodway_question (
  id int NOT NULL AUTO_INCREMENT,
  category varchar(100),
  question varchar(1000) NOT NULL,
  ask_person varchar(100),
  ask_date date,
  answer varchar(1000),
  answer_person varchar(100),
  answer_date date,
  status tinyint(1),
  created datetime not null,
  createdby_username varchar(50) not null,
  lastmodified datetime,
  lastmodifiedby_username varchar(50),

  PRIMARY KEY(id)
)
