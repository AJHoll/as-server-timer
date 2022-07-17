-- �������� ������ ������
------------------------
-- ���� ������������� --
------------------------
-- Sequence
CREATE SEQUENCE seq_user_type
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1
  NO CYCLE;
ALTER SEQUENCE seq_user_type OWNER TO "timer-user";
GRANT ALL ON SEQUENCE seq_user_type TO "timer-user";
CREATE TABLE user_type (
  id numeric NOT NULL DEFAULT nextval('seq_user_type'::regclass), -- ���
  "name" varchar NOT NULL DEFAULT ''::character varying, -- ��������� ���
  caption varchar NULL, -- ������������
  "admin" bool NOT NULL DEFAULT false, -- ���������������� ����������?
  CONSTRAINT pk_user_type PRIMARY KEY (id)
);
COMMENT ON TABLE user_type IS '���� �������������';
-- Column comments
COMMENT ON COLUMN user_type.id IS '���';
COMMENT ON COLUMN user_type."name" IS '��������� ���';
COMMENT ON COLUMN user_type.caption IS '������������';
-- Permissions
ALTER TABLE user_type OWNER TO "timer-user";
GRANT ALL ON TABLE user_type TO "timer-user";
-- Data
insert into user_type(name, caption, "admin") values('root', '��������� �������������', true);
insert into user_type(name, caption) values('competentionAdmin', '����������� �����������');
insert into user_type(name, caption) values('client', '�������� �����������');

------------------
-- ������������ --
------------------
-- Sequence
CREATE SEQUENCE seq_user
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1
  NO CYCLE;
ALTER SEQUENCE seq_user OWNER TO "timer-user";
GRANT ALL ON SEQUENCE seq_user TO "timer-user";

CREATE TABLE "user" (
  id numeric NOT NULL DEFAULT nextval('seq_user'::regclass), -- ���
  id_user_type numeric NOT NULL, -- ��� ���� ������������
  username varchar NOT NULL, -- �����
  caption varchar NOT NULL, -- ������������ ������������
  secret varchar NOT NULL, -- ������
  CONSTRAINT pk_user PRIMARY KEY (id),
  CONSTRAINT fk_user_id_user_type FOREIGN KEY (id_user_type) REFERENCES user_type(id)
);
CREATE INDEX idx_user_id_user_type ON "user" USING btree (id_user_type);
-- Column comments
COMMENT ON COLUMN "user".id IS '���';
COMMENT ON COLUMN "user".id_user_type IS '��� ���� ������������';
COMMENT ON COLUMN "user".username IS '�����';
COMMENT ON COLUMN "user".caption IS '������������ ������������';
COMMENT ON COLUMN "user".secret IS '������';
-- Permissions
ALTER TABLE "user" OWNER TO "timer-user";
GRANT ALL ON TABLE "user" TO "timer-user";
-- Data
insert into "user"(id_user_type, username, caption, secret)
values((select ut.id from user_type ut where ut."name"='root'), 'root', '������� �� ��������', '5d3c54e0f3ef9542edbb9835c9afb77a0538d1b413b976071175ca4434d8ad44');

---------------------
-- ������ �������� --
---------------------
CREATE SEQUENCE seq_timer_group
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
ALTER SEQUENCE seq_timer_group OWNER TO "timer-user";
GRANT ALL ON SEQUENCE seq_timer_group TO "timer-user";

CREATE TABLE timer_group (
	id numeric NOT NULL DEFAULT nextval('seq_timer_group'::regclass), -- ���
	"name" varchar NOT NULL, -- ��������� ���
	caption varchar NULL, -- ������������
	CONSTRAINT pk_timer_group PRIMARY KEY (id)
);
CREATE INDEX idx_timer_group_caption ON timer_group USING btree (caption);
CREATE UNIQUE INDEX udx_timer_group_name ON timer_group USING btree (name);

COMMENT ON TABLE timer_group IS '������ ��������';
COMMENT ON COLUMN timer_group.id IS '���';
COMMENT ON COLUMN timer_group."name" IS '��������� ���';
COMMENT ON COLUMN timer_group.caption IS '������������';

ALTER TABLE timer_group OWNER TO "timer-user";
GRANT ALL ON TABLE timer_group TO "timer-user";

insert into timer_group(name, caption)
values('IT_Solution_for_business','����������� ������� ��� �������');

-------------
-- ������� --
-------------
CREATE SEQUENCE seq_timer
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
ALTER SEQUENCE seq_timer OWNER TO "timer-user";
GRANT ALL ON SEQUENCE seq_timer TO "timer-user";

CREATE TABLE timer (
	id numeric NOT NULL DEFAULT nextval('seq_timer'::regclass), -- ���
	id_timer_group numeric NOT NULL, -- ��� ������ ��������
	caption varchar NOT NULL, -- ������������
	begin_timestamp timestamp NULL, -- ����� ������ �������
	sec_count numeric NULL, -- ���������� ������ �������
	CONSTRAINT pk_timer PRIMARY KEY (id),
	CONSTRAINT fk_timer_id_timer_group FOREIGN KEY (id_timer_group) REFERENCES timer_group(id)
);
CREATE INDEX idx_timer_id_timer_group ON timer USING btree (id_timer_group);
CREATE UNIQUE INDEX udx_timer_caption ON timer USING btree (caption);

COMMENT ON TABLE timer IS '�������';
COMMENT ON COLUMN timer.id IS '���';
COMMENT ON COLUMN timer.id_timer_group IS '��� ������ ��������';
COMMENT ON COLUMN timer.caption IS '������������';

ALTER TABLE timer OWNER TO "timer-user";
GRANT ALL ON TABLE timer TO "timer-user";

insert into timer(id_timer_group, caption)
values((select group_in.id from timer_group group_in where group_in."name" = 'IT_Solution_for_business'), '������� 1')

--------------------------------
-- ���� �������� ��� �������� --
--------------------------------
CREATE SEQUENCE seq_timer_operation_type
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
ALTER SEQUENCE seq_timer_operation OWNER TO "timer-user";
GRANT ALL ON SEQUENCE seq_timer_operation TO "timer-user";

CREATE TABLE timer_operation_type (
	id numeric NOT NULL DEFAULT nextval('seq_timer_operation_type'::regclass), -- ���
	"name" varchar NOT NULL, -- ��������� ���
	caption varchar NOT NULL, -- ������������
	CONSTRAINT pk_timer_operation_type PRIMARY KEY (id)
);
CREATE UNIQUE INDEX udx_timer_operation_type_name ON timer_operation_type USING btree (name);

COMMENT ON TABLE timer_operation_type IS '���� �������� ��� ��������';
COMMENT ON COLUMN timer_operation_type.id IS '���';
COMMENT ON COLUMN timer_operation_type."name" IS '��������� ���';
COMMENT ON COLUMN timer_operation_type.caption IS '������������';

ALTER TABLE timer_operation_type OWNER TO "timer-user";
GRANT ALL ON TABLE timer_operation_type TO "timer-user";

insert into timer_operation_type(name, caption) values('start','�����');
insert into timer_operation_type(name, caption) values('pause','�����');
insert into timer_operation_type(name, caption) values('continue','����������');
insert into timer_operation_type(name, caption) values('stop','����');

---------------------------
-- �������� ��� �������� --
---------------------------
CREATE SEQUENCE seq_timer_operation
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
ALTER SEQUENCE seq_timer_operation OWNER TO "timer-user";
GRANT ALL ON SEQUENCE seq_timer_operation TO "timer-user";

CREATE TABLE timer_operation (
	id numeric NOT NULL DEFAULT nextval('seq_timer_operation'::regclass), -- ���
	id_timer numeric NOT NULL, -- ��� �������
	id_operation_type numeric NOT NULL, -- ��� ���� ��������
	operation_timestamp timestamp NOT NULL, -- ��������� ����� ��������
	CONSTRAINT pk_timer_operation PRIMARY KEY (id),
	CONSTRAINT fk_timer_operation_id_operation_type FOREIGN KEY (id_operation_type) REFERENCES timer_operation_type(id),
	CONSTRAINT fk_timer_operation_id_timer FOREIGN KEY (id_timer) REFERENCES timer(id) ON DELETE CASCADE
);
CREATE INDEX idx_timer_operation_id_operation_type ON timer_operation USING btree (id_operation_type);
CREATE INDEX idx_timer_operation_id_timer ON timer_operation USING btree (id_timer);

COMMENT ON TABLE timer_operation IS '�������� ��� ��������';
COMMENT ON COLUMN timer_operation.id IS '���';
COMMENT ON COLUMN timer_operation.id_timer IS '��� �������';
COMMENT ON COLUMN timer_operation.id_operation_type IS '��� ���� ��������';
COMMENT ON COLUMN timer_operation.operation_timestamp IS '��������� ����� ��������';

ALTER TABLE timer_operation OWNER TO "timer-user";
GRANT ALL ON TABLE timer_operation TO "timer-user";

------------------------------------
-- ������ ������������� � ������� --
------------------------------------
CREATE SEQUENCE seq_user_access_group
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
ALTER SEQUENCE seq_user_access_group OWNER TO "timer-user";
GRANT ALL ON SEQUENCE seq_user_access_group TO "timer-user";

CREATE TABLE user_access_group (
	id numeric NOT NULL DEFAULT nextval('seq_user_access_group'::regclass), -- ���
	id_user numeric NOT NULL, -- ��� ������������
	id_group numeric NOT NULL, -- ��� ������
	view_group bool NOT NULL DEFAULT false, -- ������������ ����� ������
	view_group_timers bool NOT NULL DEFAULT false, -- ������������ ����� ������� ������
	edit_group_timers bool NOT NULL DEFAULT false, -- ������������ ����� �������� ������� ������
	CONSTRAINT pk_user_access_group PRIMARY KEY (id),
	CONSTRAINT fk_user_access_group_id_timer_group FOREIGN KEY (id_group) REFERENCES timer_group(id) ON DELETE CASCADE,
	CONSTRAINT fk_user_access_group_id_user FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE
);
CREATE INDEX idx_user_access_group_id_group ON user_access_group USING btree (id_group);
CREATE INDEX idx_user_access_group_id_user ON user_access_group USING btree (id_user);
CREATE UNIQUE INDEX udx_user_access_group_id_user_id_group ON user_access_group USING btree (id_user, id_group);

COMMENT ON TABLE user_access_group IS '������ ������������� � �������';
COMMENT ON COLUMN user_access_group.id IS '���';
COMMENT ON COLUMN user_access_group.id_user IS '��� ������������';
COMMENT ON COLUMN user_access_group.id_group IS '��� ������';
COMMENT ON COLUMN user_access_group.view_group IS '������������ ����� ������';
COMMENT ON COLUMN user_access_group.view_group_timers IS '������������ ����� ������� ������';
COMMENT ON COLUMN user_access_group.edit_group_timers IS '������������ ����� �������� ������� ������';

ALTER TABLE user_access_group OWNER TO "timer-user";
GRANT ALL ON TABLE user_access_group TO "timer-user";

--------------------------------------
-- ������ ������������� �� �������� --
--------------------------------------
CREATE SEQUENCE seq_user_access_timer
	INCREMENT BY 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1
	NO CYCLE;
ALTER SEQUENCE seq_user_access_timer OWNER TO "timer-user";
GRANT ALL ON SEQUENCE seq_user_access_timer TO "timer-user";

CREATE TABLE user_access_timer (
	id numeric NOT NULL DEFAULT nextval('seq_user_access_timer'::regclass), -- ���
	id_user numeric NOT NULL, -- ��� ������������
	id_timer numeric NOT NULL, -- ��� �������
	view_timer bool NOT NULL DEFAULT false, -- ����������� ������ ������
	edit_timer bool NOT NULL DEFAULT false, -- ����������� ��������� �������� ��� ��������
	CONSTRAINT pk_user_access_timer PRIMARY KEY (id),
	CONSTRAINT fk_user_access_timer_id_timer FOREIGN KEY (id_timer) REFERENCES timer(id) ON DELETE CASCADE,
	CONSTRAINT fk_user_access_timer_id_user FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE
);
CREATE INDEX idx_user_access_timer_id_timer ON user_access_timer USING btree (id_timer);
CREATE INDEX idx_user_access_timer_id_user ON user_access_timer USING btree (id_user);
CREATE UNIQUE INDEX udx_user_access_timer_id_timer_id_user ON user_access_timer USING btree (id_timer, id_user);

COMMENT ON TABLE user_access_timer IS '������ ������������� �� ��������';
COMMENT ON COLUMN user_access_timer.id IS '���';
COMMENT ON COLUMN user_access_timer.id_user IS '��� ������������';
COMMENT ON COLUMN user_access_timer.id_timer IS '��� �������';
COMMENT ON COLUMN user_access_timer.view_timer IS '����������� ������ ������';
COMMENT ON COLUMN user_access_timer.edit_timer IS '����������� ��������� �������� ��� ��������';

ALTER TABLE user_access_timer OWNER TO "timer-user";
GRANT ALL ON TABLE user_access_timer TO "timer-user";
