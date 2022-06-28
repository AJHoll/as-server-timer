-- Создание таблиц данных
------------------------
-- Типы пользователей --
------------------------
CREATE TABLE public.user_type (
  id numeric NOT NULL DEFAULT nextval('seq_user_type'::regclass), -- Код
  "name" varchar NOT NULL DEFAULT ''::character varying, -- Системное имя
  caption varchar NULL, -- Наименование
  "admin" bool NOT NULL DEFAULT false, -- Административные привилегии?
  CONSTRAINT pk_user_type PRIMARY KEY (id)
);
COMMENT ON TABLE public.user_type IS 'Типы пользователей';
-- Column comments
COMMENT ON COLUMN public.user_type.id IS 'Код';
COMMENT ON COLUMN public.user_type."name" IS 'Системное имя';
COMMENT ON COLUMN public.user_type.caption IS 'Наименование';
-- Permissions
ALTER TABLE public.user_type OWNER TO "timer-user";
GRANT ALL ON TABLE public.user_type TO "timer-user";
-- Sequence
CREATE SEQUENCE public.seq_user_type
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1
  NO CYCLE;
ALTER SEQUENCE public.seq_user_type OWNER TO "timer-user";
GRANT ALL ON SEQUENCE public.seq_user_type TO "timer-user";
-- Data
insert into user_type(name, caption, "admin") values('root', 'Системный администратор', true);
insert into user_type(name, caption) values('competentionAdmin', 'Организатор компетенции');
insert into user_type(name, caption) values('client', 'Участник компетенции');

------------------
-- Пользователи --
------------------
CREATE TABLE public."user" (
  id numeric NOT NULL DEFAULT nextval('seq_user'::regclass), -- Код
  id_user_type numeric NOT NULL, -- Код типа пользователя
  username varchar NOT NULL, -- Логин
  caption varchar NOT NULL, -- Наименование пользователя
  secret varchar NOT NULL, -- Пароль
  CONSTRAINT pk_user PRIMARY KEY (id),
  CONSTRAINT fk_user_id_user_type FOREIGN KEY (id_user_type) REFERENCES public.user_type(id)
);
CREATE INDEX idx_user_id_user_type ON public."user" USING btree (id_user_type);
-- Column comments
COMMENT ON COLUMN public."user".id IS 'Код';
COMMENT ON COLUMN public."user".id_user_type IS 'Код типа пользователя';
COMMENT ON COLUMN public."user".username IS 'Логин';
COMMENT ON COLUMN public."user".caption IS 'Наименование пользователя';
COMMENT ON COLUMN public."user".secret IS 'Пароль';
-- Permissions
ALTER TABLE public."user" OWNER TO "timer-user";
GRANT ALL ON TABLE public."user" TO "timer-user";
-- Sequence
CREATE SEQUENCE public.seq_user
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1
  NO CYCLE;
ALTER SEQUENCE public.seq_user OWNER TO "timer-user";
GRANT ALL ON SEQUENCE public.seq_user TO "timer-user";
-- Data
insert into "user"(id_user_type, username, caption, secret)
values((select ut.id from user_type ut where ut."name"='root'), 'root', 'Главный по таймерам', 'root-password');

-----------------
-- Компетенции --
-----------------
