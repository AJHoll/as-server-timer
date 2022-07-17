-- Создание таблиц данных
------------------------
-- Типы пользователей --
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
  id numeric NOT NULL DEFAULT nextval('seq_user_type'::regclass), -- Код
  "name" varchar NOT NULL DEFAULT ''::character varying, -- Системное имя
  caption varchar NULL, -- Наименование
  "admin" bool NOT NULL DEFAULT false, -- Административные привилегии?
  CONSTRAINT pk_user_type PRIMARY KEY (id)
);
COMMENT ON TABLE user_type IS 'Типы пользователей';
-- Column comments
COMMENT ON COLUMN user_type.id IS 'Код';
COMMENT ON COLUMN user_type."name" IS 'Системное имя';
COMMENT ON COLUMN user_type.caption IS 'Наименование';
-- Permissions
ALTER TABLE user_type OWNER TO "timer-user";
GRANT ALL ON TABLE user_type TO "timer-user";
-- Data
insert into user_type(name, caption, "admin") values('root', 'Системный администратор', true);
insert into user_type(name, caption) values('competentionAdmin', 'Организатор компетенции');
insert into user_type(name, caption) values('client', 'Участник компетенции');

------------------
-- Пользователи --
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
  id numeric NOT NULL DEFAULT nextval('seq_user'::regclass), -- Код
  id_user_type numeric NOT NULL, -- Код типа пользователя
  username varchar NOT NULL, -- Логин
  caption varchar NOT NULL, -- Наименование пользователя
  secret varchar NOT NULL, -- Пароль
  CONSTRAINT pk_user PRIMARY KEY (id),
  CONSTRAINT fk_user_id_user_type FOREIGN KEY (id_user_type) REFERENCES user_type(id)
);
CREATE INDEX idx_user_id_user_type ON "user" USING btree (id_user_type);
-- Column comments
COMMENT ON COLUMN "user".id IS 'Код';
COMMENT ON COLUMN "user".id_user_type IS 'Код типа пользователя';
COMMENT ON COLUMN "user".username IS 'Логин';
COMMENT ON COLUMN "user".caption IS 'Наименование пользователя';
COMMENT ON COLUMN "user".secret IS 'Пароль';
-- Permissions
ALTER TABLE "user" OWNER TO "timer-user";
GRANT ALL ON TABLE "user" TO "timer-user";
-- Data
insert into "user"(id_user_type, username, caption, secret)
values((select ut.id from user_type ut where ut."name"='root'), 'root', 'Главный по таймерам', '5d3c54e0f3ef9542edbb9835c9afb77a0538d1b413b976071175ca4434d8ad44');

---------------------
-- Группы таймеров --
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
	id numeric NOT NULL DEFAULT nextval('seq_timer_group'::regclass), -- Код
	"name" varchar NOT NULL, -- Системное имя
	caption varchar NULL, -- Наименование
	CONSTRAINT pk_timer_group PRIMARY KEY (id)
);
CREATE INDEX idx_timer_group_caption ON timer_group USING btree (caption);
CREATE UNIQUE INDEX udx_timer_group_name ON timer_group USING btree (name);

COMMENT ON TABLE timer_group IS 'Группы таймеров';
COMMENT ON COLUMN timer_group.id IS 'Код';
COMMENT ON COLUMN timer_group."name" IS 'Системное имя';
COMMENT ON COLUMN timer_group.caption IS 'Наименование';

ALTER TABLE timer_group OWNER TO "timer-user";
GRANT ALL ON TABLE timer_group TO "timer-user";

insert into timer_group(name, caption)
values('IT_Solution_for_business','Программные решения для бизнеса');

-------------
-- Таймеры --
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
	id numeric NOT NULL DEFAULT nextval('seq_timer'::regclass), -- Код
	id_timer_group numeric NOT NULL, -- Код группы таймеров
	caption varchar NOT NULL, -- Наименование
	begin_timestamp timestamp NULL, -- Время начала таймера
	sec_count numeric NULL, -- Количество секунд таймера
	CONSTRAINT pk_timer PRIMARY KEY (id),
	CONSTRAINT fk_timer_id_timer_group FOREIGN KEY (id_timer_group) REFERENCES timer_group(id)
);
CREATE INDEX idx_timer_id_timer_group ON timer USING btree (id_timer_group);
CREATE UNIQUE INDEX udx_timer_caption ON timer USING btree (caption);

COMMENT ON TABLE timer IS 'Таймеры';
COMMENT ON COLUMN timer.id IS 'Код';
COMMENT ON COLUMN timer.id_timer_group IS 'Код группы таймеров';
COMMENT ON COLUMN timer.caption IS 'Наименование';

ALTER TABLE timer OWNER TO "timer-user";
GRANT ALL ON TABLE timer TO "timer-user";

insert into timer(id_timer_group, caption)
values((select group_in.id from timer_group group_in where group_in."name" = 'IT_Solution_for_business'), 'Команда 1')

--------------------------------
-- Типы операций над таймером --
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
	id numeric NOT NULL DEFAULT nextval('seq_timer_operation_type'::regclass), -- Код
	"name" varchar NOT NULL, -- Системное имя
	caption varchar NOT NULL, -- Наименование
	CONSTRAINT pk_timer_operation_type PRIMARY KEY (id)
);
CREATE UNIQUE INDEX udx_timer_operation_type_name ON timer_operation_type USING btree (name);

COMMENT ON TABLE timer_operation_type IS 'Типы операций над таймером';
COMMENT ON COLUMN timer_operation_type.id IS 'Код';
COMMENT ON COLUMN timer_operation_type."name" IS 'Системное имя';
COMMENT ON COLUMN timer_operation_type.caption IS 'Наименование';

ALTER TABLE timer_operation_type OWNER TO "timer-user";
GRANT ALL ON TABLE timer_operation_type TO "timer-user";

insert into timer_operation_type(name, caption) values('start','Старт');
insert into timer_operation_type(name, caption) values('pause','Пауза');
insert into timer_operation_type(name, caption) values('continue','Продолжить');
insert into timer_operation_type(name, caption) values('stop','Стоп');

---------------------------
-- Операции над таймером --
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
	id numeric NOT NULL DEFAULT nextval('seq_timer_operation'::regclass), -- Код
	id_timer numeric NOT NULL, -- Код таймера
	id_operation_type numeric NOT NULL, -- Код типа операции
	operation_timestamp timestamp NOT NULL, -- Временная метка операции
	CONSTRAINT pk_timer_operation PRIMARY KEY (id),
	CONSTRAINT fk_timer_operation_id_operation_type FOREIGN KEY (id_operation_type) REFERENCES timer_operation_type(id),
	CONSTRAINT fk_timer_operation_id_timer FOREIGN KEY (id_timer) REFERENCES timer(id) ON DELETE CASCADE
);
CREATE INDEX idx_timer_operation_id_operation_type ON timer_operation USING btree (id_operation_type);
CREATE INDEX idx_timer_operation_id_timer ON timer_operation USING btree (id_timer);

COMMENT ON TABLE timer_operation IS 'Операции над таймером';
COMMENT ON COLUMN timer_operation.id IS 'Код';
COMMENT ON COLUMN timer_operation.id_timer IS 'Код таймера';
COMMENT ON COLUMN timer_operation.id_operation_type IS 'Код типа операции';
COMMENT ON COLUMN timer_operation.operation_timestamp IS 'Временная метка операции';

ALTER TABLE timer_operation OWNER TO "timer-user";
GRANT ALL ON TABLE timer_operation TO "timer-user";

------------------------------------
-- Доступ пользователей к группам --
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
	id numeric NOT NULL DEFAULT nextval('seq_user_access_group'::regclass), -- Код
	id_user numeric NOT NULL, -- Код пользователя
	id_group numeric NOT NULL, -- Код группы
	view_group bool NOT NULL DEFAULT false, -- Пользователь видит группу
	view_group_timers bool NOT NULL DEFAULT false, -- Пользователь видит таймеры группы
	edit_group_timers bool NOT NULL DEFAULT false, -- Пользователь может изменять таймеры группы
	CONSTRAINT pk_user_access_group PRIMARY KEY (id),
	CONSTRAINT fk_user_access_group_id_timer_group FOREIGN KEY (id_group) REFERENCES timer_group(id) ON DELETE CASCADE,
	CONSTRAINT fk_user_access_group_id_user FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE
);
CREATE INDEX idx_user_access_group_id_group ON user_access_group USING btree (id_group);
CREATE INDEX idx_user_access_group_id_user ON user_access_group USING btree (id_user);
CREATE UNIQUE INDEX udx_user_access_group_id_user_id_group ON user_access_group USING btree (id_user, id_group);

COMMENT ON TABLE user_access_group IS 'Доступ пользователей к группам';
COMMENT ON COLUMN user_access_group.id IS 'Код';
COMMENT ON COLUMN user_access_group.id_user IS 'Код пользователя';
COMMENT ON COLUMN user_access_group.id_group IS 'Код группы';
COMMENT ON COLUMN user_access_group.view_group IS 'Пользователь видит группу';
COMMENT ON COLUMN user_access_group.view_group_timers IS 'Пользователь видит таймеры группы';
COMMENT ON COLUMN user_access_group.edit_group_timers IS 'Пользователь может изменять таймеры группы';

ALTER TABLE user_access_group OWNER TO "timer-user";
GRANT ALL ON TABLE user_access_group TO "timer-user";

--------------------------------------
-- Доступ пользователей до таймеров --
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
	id numeric NOT NULL DEFAULT nextval('seq_user_access_timer'::regclass), -- Код
	id_user numeric NOT NULL, -- Код пользователя
	id_timer numeric NOT NULL, -- Код таймера
	view_timer bool NOT NULL DEFAULT false, -- Возможность видеть таймер
	edit_timer bool NOT NULL DEFAULT false, -- Возможность выполнять операции над таймером
	CONSTRAINT pk_user_access_timer PRIMARY KEY (id),
	CONSTRAINT fk_user_access_timer_id_timer FOREIGN KEY (id_timer) REFERENCES timer(id) ON DELETE CASCADE,
	CONSTRAINT fk_user_access_timer_id_user FOREIGN KEY (id_user) REFERENCES "user"(id) ON DELETE CASCADE
);
CREATE INDEX idx_user_access_timer_id_timer ON user_access_timer USING btree (id_timer);
CREATE INDEX idx_user_access_timer_id_user ON user_access_timer USING btree (id_user);
CREATE UNIQUE INDEX udx_user_access_timer_id_timer_id_user ON user_access_timer USING btree (id_timer, id_user);

COMMENT ON TABLE user_access_timer IS 'Доступ пользователей до таймеров';
COMMENT ON COLUMN user_access_timer.id IS 'Код';
COMMENT ON COLUMN user_access_timer.id_user IS 'Код пользователя';
COMMENT ON COLUMN user_access_timer.id_timer IS 'Код таймера';
COMMENT ON COLUMN user_access_timer.view_timer IS 'Возможность видеть таймер';
COMMENT ON COLUMN user_access_timer.edit_timer IS 'Возможность выполнять операции над таймером';

ALTER TABLE user_access_timer OWNER TO "timer-user";
GRANT ALL ON TABLE user_access_timer TO "timer-user";
