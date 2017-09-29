--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.4
-- Dumped by pg_dump version 9.6.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: acts_as_bookable_bookings; Type: TABLE; Schema: public; Owner: room_booking9832
--

CREATE TABLE acts_as_bookable_bookings (
    id integer NOT NULL,
    bookable_type character varying,
    bookable_id integer,
    booker_type character varying,
    booker_id integer,
    project_id integer,
    title character varying,
    amount integer,
    schedule text,
    time_start timestamp without time zone,
    time_end timestamp without time zone,
    "time" timestamp without time zone,
    description text,
    created_at timestamp without time zone,
    daily boolean DEFAULT false,
    generate_for_id integer
);


ALTER TABLE acts_as_bookable_bookings OWNER TO room_booking9832;

--
-- Name: acts_as_bookable_bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: room_booking9832
--

CREATE SEQUENCE acts_as_bookable_bookings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE acts_as_bookable_bookings_id_seq OWNER TO room_booking9832;

--
-- Name: acts_as_bookable_bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: room_booking9832
--

ALTER SEQUENCE acts_as_bookable_bookings_id_seq OWNED BY acts_as_bookable_bookings.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: room_booking9832
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE ar_internal_metadata OWNER TO room_booking9832;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: room_booking9832
--

CREATE TABLE projects (
    id integer NOT NULL,
    name character varying,
    status integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE projects OWNER TO room_booking9832;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: room_booking9832
--

CREATE SEQUENCE projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE projects_id_seq OWNER TO room_booking9832;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: room_booking9832
--

ALTER SEQUENCE projects_id_seq OWNED BY projects.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: room_booking9832
--

CREATE TABLE rooms (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    schedule text,
    capacity integer
);


ALTER TABLE rooms OWNER TO room_booking9832;

--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: room_booking9832
--

CREATE SEQUENCE rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE rooms_id_seq OWNER TO room_booking9832;

--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: room_booking9832
--

ALTER SEQUENCE rooms_id_seq OWNED BY rooms.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: room_booking9832
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE schema_migrations OWNER TO room_booking9832;

--
-- Name: user_projects; Type: TABLE; Schema: public; Owner: room_booking9832
--

CREATE TABLE user_projects (
    id integer NOT NULL,
    user_id integer,
    project_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE user_projects OWNER TO room_booking9832;

--
-- Name: user_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: room_booking9832
--

CREATE SEQUENCE user_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_projects_id_seq OWNER TO room_booking9832;

--
-- Name: user_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: room_booking9832
--

ALTER SEQUENCE user_projects_id_seq OWNED BY user_projects.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: room_booking9832
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    name character varying,
    first_name character varying,
    last_name character varying,
    provider character varying DEFAULT ''::character varying NOT NULL,
    uid character varying DEFAULT ''::character varying NOT NULL,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role integer
);


ALTER TABLE users OWNER TO room_booking9832;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: room_booking9832
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_id_seq OWNER TO room_booking9832;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: room_booking9832
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: acts_as_bookable_bookings id; Type: DEFAULT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY acts_as_bookable_bookings ALTER COLUMN id SET DEFAULT nextval('acts_as_bookable_bookings_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY projects ALTER COLUMN id SET DEFAULT nextval('projects_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY rooms ALTER COLUMN id SET DEFAULT nextval('rooms_id_seq'::regclass);


--
-- Name: user_projects id; Type: DEFAULT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY user_projects ALTER COLUMN id SET DEFAULT nextval('user_projects_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: acts_as_bookable_bookings acts_as_bookable_bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY acts_as_bookable_bookings
    ADD CONSTRAINT acts_as_bookable_bookings_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: user_projects user_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY user_projects
    ADD CONSTRAINT user_projects_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_acts_as_bookable_bookings_bookable; Type: INDEX; Schema: public; Owner: room_booking9832
--

CREATE INDEX index_acts_as_bookable_bookings_bookable ON acts_as_bookable_bookings USING btree (bookable_type, bookable_id);


--
-- Name: index_acts_as_bookable_bookings_booker; Type: INDEX; Schema: public; Owner: room_booking9832
--

CREATE INDEX index_acts_as_bookable_bookings_booker ON acts_as_bookable_bookings USING btree (booker_type, booker_id);


--
-- Name: index_acts_as_bookable_bookings_project; Type: INDEX; Schema: public; Owner: room_booking9832
--

CREATE INDEX index_acts_as_bookable_bookings_project ON acts_as_bookable_bookings USING btree (project_id);


--
-- Name: index_user_projects_on_project_id; Type: INDEX; Schema: public; Owner: room_booking9832
--

CREATE INDEX index_user_projects_on_project_id ON user_projects USING btree (project_id);


--
-- Name: index_user_projects_on_user_id; Type: INDEX; Schema: public; Owner: room_booking9832
--

CREATE INDEX index_user_projects_on_user_id ON user_projects USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: room_booking9832
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: room_booking9832
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: user_projects fk_rails_d19c0da646; Type: FK CONSTRAINT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY user_projects
    ADD CONSTRAINT fk_rails_d19c0da646 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: user_projects fk_rails_f58e9073ce; Type: FK CONSTRAINT; Schema: public; Owner: room_booking9832
--

ALTER TABLE ONLY user_projects
    ADD CONSTRAINT fk_rails_f58e9073ce FOREIGN KEY (project_id) REFERENCES projects(id);


--
-- PostgreSQL database dump complete
--
