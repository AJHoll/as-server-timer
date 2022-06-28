-- �������� ������ ������
------------------------
-- ���� ������������� --
------------------------
CREATE TABLE public.user_type (
  id numeric NOT NULL DEFAULT nextval('seq_user_type'::regclass), -- ���
  "name" varchar NOT NULL DEFAULT ''::character varying, -- ��������� ���
  caption varchar NULL, -- ������������
  "admin" bool NOT NULL DEFAULT false, -- ���������������� ����������?
  CONSTRAINT pk_user_type PRIMARY KEY (id)
);
COMMENT ON TABLE public.user_type IS '���� �������������';
-- Column comments
COMMENT ON COLUMN public.user_type.id IS '���';
COMMENT ON COLUMN public.user_type."name" IS '��������� ���';
COMMENT ON COLUMN public.user_type.caption IS '������������';
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
insert into user_type(name, caption, "admin") values('root', '��������� �������������', true);
insert into user_type(name, caption) values('competentionAdmin', '����������� �����������');
insert into user_type(name, caption) values('client', '�������� �����������');

------------------
-- ������������ --
------------------
CREATE TABLE public."user" (
  id numeric NOT NULL DEFAULT nextval('seq_user'::regclass), -- ���
  id_user_type numeric NOT NULL, -- ��� ���� ������������
  username varchar NOT NULL, -- �����
  caption varchar NOT NULL, -- ������������ ������������
  secret varchar NOT NULL, -- ������
  CONSTRAINT pk_user PRIMARY KEY (id),
  CONSTRAINT fk_user_id_user_type FOREIGN KEY (id_user_type) REFERENCES public.user_type(id)
);
CREATE INDEX idx_user_id_user_type ON public."user" USING btree (id_user_type);
-- Column comments
COMMENT ON COLUMN public."user".id IS '���';
COMMENT ON COLUMN public."user".id_user_type IS '��� ���� ������������';
COMMENT ON COLUMN public."user".username IS '�����';
COMMENT ON COLUMN public."user".caption IS '������������ ������������';
COMMENT ON COLUMN public."user".secret IS '������';
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
values((select ut.id from user_type ut where ut."name"='root'), 'root', '������� �� ��������', 'root-password');

-----------------
-- ����������� --
-----------------
