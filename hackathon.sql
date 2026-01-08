create database hackathon;
use hackathon;

-- 1. Tạo bảng (10 điểm) Tạo 4 bảng Customers, InsuranceAgents, Policies, ClaimPayments
create table Customers (
	customer_id varchar(10) primary key, 
    full_name varchar(100) not null,
    phone varchar(15) not null unique,
    address varchar(200) not null
);

create table InsuranceAgents (
	agent_id varchar(10) primary key,
    full_name varchar(100) not null,
    region varchar(50) not null,
    years_of_experience int,
    commission_rate decimal(5,2),
    
    check(years_of_experience >= 0),
    check(commission_rate >= 0)
);

create table Policies(
	policy_id int primary key auto_increment,
    customer_id varchar(10),
    agent_id varchar(10),
    start_date timestamp not null,
    end_date timestamp not null,
    status enum('Active', 'Expired','Cancelled'),
    
    foreign key (customer_id) references Customers(customer_id),
    foreign key (agent_id) references InsuranceAgents(agent_id)
);

create table ClaimPayments(
	payment_id int primary key auto_increment,
    policy_id int,
    payment_method varchar(50) not null,
    payment_date timestamp default current_timestamp,
    amount decimal(15,2),
    
    foreign key (policy_id) references Policies(policy_id),
    check (amount >= 0)
);

-- 2. Chèn dữ liệu: Thêm dữ liệu vào 4 bảng đã tạo
insert into Customers
values 
('C001', 'Nguyen Van An', '0912345678', 'Hanoi, Vietnam'),
('C002', 'Tran Thi Binh', '0923456789', 'Ho Chi Minh, Vietnam'),
('C003', 'Le Minh Chau', '0934567890', 'Da Nang, Vietnam'),
('C004', 'Pham Hoang Duc', '0945678901', 'Can Tho, Vietnam'),
('C005', 'Vu Thi Hoa', '0956789012', 'Hai Phong, Vietnam');

insert into InsuranceAgents
values 
('A001', 'Nguyen Van Minh', 'Mien Bac', 10, 5.5),
('A002', 'Tran Thi Lan', 'Mien Nam', 15, 7),
('A003', 'Le Hoang Nam', 'Mien Trung', 8, 4.5),
('A004', 'Pham Quang Huy', 'Mien Tay', 20, 8),
('A005', 'Vu Thi Mai', 'Mien Bac', 5, 3.5);

insert into Policies
values 
(1,'C001', 'A001', '2024-01-01 08:00:00','2025-01-01 08:00:00', 'Active'),
(2,'C002', 'A002', '2024-02-01 09:30:00','2025-02-01 09:30:00', 'Expired'),
(3,'C003', 'A003', '2023-03-02 10:00:00','2024-03-02 10:00:00', 'Cancelled'),
(4,'C004', 'A004', '2024-05-02 14:00:00','2025-05-02 14:00:00', 'Active'),
(5,'C005', 'A005', '2024-06-03 15:30:00','2025-06-03 15:30:00', 'Active');

insert into ClaimPayments
values 
(1, 1, 'Bank Transfer','2024-05-01 08:45:00', 5000000),
(2, 2, 'Bank Transfer','2024-06-01 10:00:00', 7500000),
(3, 3, 'Cash','2024-08-02 15:00:00', 2000000),
(4, 4, 'Bank Transfer','2024-09-04 11:00:00', 3000000),
(5, 5, 'Credit Card','2023-10-05 14:00:00', 1500000);

-- 3. Thay đổi địa chỉ của khách hàng có customer_id = 'C002' thành "District 1, Ho Chi Minh City".
update Customers
set address = 'District 1, Ho Chi Minh City'
where customer_id = 'C002';

-- 4. Thay đổi trạng thái nhân viên:. Nhân viên có mã A001 đạt thành tích tốt, hãy tăng years_of_experience thêm 2 năm và tăng commission_rate thêm 1.5%.
update InsuranceAgents
set years_of_experience = 12, commission_rate = 7
where agent_id = 'A001';

-- 5. Xóa tất cả các hợp đồng trong bảng Policies có trạng thái là "Cancelled" và ngày bắt đầu trước ngày "2024-06-15".
delete from Policies 
where status = 'Cancelled' and start_date < '2024-06-15';

-- 6. Liệt kê danh sách các nhân viên bảo hiểm gồm: agent_id, full_name, region có số năm kinh nghiệm (years_of_experience) trên 8 năm.
select agent_id, full_name, region 
from InsuranceAgents
where years_of_experience > 8;

-- 7. Lấy thông tin customer_id, full_name, phone của những khách hàng có tên chứa từ khóa "Nguyen".
select customer_id, full_name, phone 
from Customers
where full_name like '%Nguyen%';

-- 8. Hiển thị danh sách tất cả các hợp đồng gồm: policy_id, start_date, status, sắp xếp theo ngày bắt đầu (start_date) giảm dần.
select policy_id, start_date, status
from Policies
order by start_date DESC;

-- 9. Lấy thông tin 3 bản ghi đầu tiên trong bảng ClaimPayments có phương thức thanh toán là 'Bank Transfer'.
select * 
from ClaimPayments
where payment_method = 'Bank Transfer'
limit 3;

-- 10. Hiển thị thông tin gồm mã nhân viên (agent_id) và tên nhân viên (full_name) từ bảng InsuranceAgents, bỏ qua 2 bản ghi đầu tiên và lấy 3 bản ghi tiếp theo (LIMIT và OFFSET).
select agent_id, full_name
from InsuranceAgents
limit 3 offset 2;

-- 11. Hiển thị danh sách hợp đồng gồm: policy_id, customer_name (từ bảng Customers), agent_name (từ bảng InsuranceAgents) và status. Chỉ lấy những hợp đồng có trạng thái là 'Active'.
select p.policy_id, c.full_name as customer_name, ia.full_name as agent_name, p.status
from Policies p
join InsuranceAgents ia on p.agent_id = ia.agent_id
join Customers c on p.customer_id = c.customer_id;

-- 12. Liệt kê tất cả các nhân viên trong hệ thống gồm: agent_id, full_name và policy_id tương ứng. Kết quả phải bao gồm cả những nhân viên chưa từng ký hợp đồng nào (Sử dụng LEFT JOIN).
select ia.agent_id, ia.full_name, p.policy_id
from InsuranceAgents ia
left join Policies p on p.agent_id = ia.agent_id;

-- 13. Tính tổng tiền bồi thường (SUM(amount)) theo từng phương thức thanh toán (payment_method). Kết quả hiển thị 2 cột: payment_method và Total_Payout.
select payment_method, sum(amount) as Total_Payout
from ClaimPayments
group by payment_method;

-- 14. Thống kê số lượng hợp đồng mà mỗi nhân viên đã ký. Hiển thị agent_id, full_name và Total_Policies. Chỉ hiện những nhân viên có từ 1 hợp đồng trở lên.
select ia.agent_id, ia.full_name, count(p.agent_id)
from InsuranceAgents ia
join Policies p on p.agent_id = ia.agent_id
group by ia.agent_id;

-- 15. Lấy thông tin chi tiết các nhân viên (agent_id, full_name, commission_rate) có mức hoa hồng cao hơn mức hoa hồng trung bình của tất cả các nhân viên.
select agent_id, full_name, commission_rate
from InsuranceAgents
where commission_rate > (select avg(commission_rate) from InsuranceAgents);

-- 16. Hiển thị customer_id và full_name của những khách hàng đã từng có yêu cầu bồi thường (Claim) với số tiền lớn hơn 5.000.000 (Gợi ý: Dùng JOIN giữa Customers, Policies và ClaimPayments).
select c.customer_id, c.full_name 
from Customers c
join Policies p on p.customer_id = c.customer_id
join ClaimPayments cp on cp.policy_id = p.policy_id 
where amount > 5000000;

-- 17. Hiển thị thông tin tổng hợp gồm: policy_id, customer_name, agent_name, payment_method và amount của tất cả các đợt chi trả bồi thường.
select p.policy_id, c.full_name as customer_name, ia.full_name as agent_name, cp.payment_method, cp.amount
from Customers c
join Policies p on p.customer_id = c.customer_id
join InsuranceAgents ia on ia.agent_id = p.agent_id
join ClaimPayments cp on cp.policy_id = p.policy_id;



