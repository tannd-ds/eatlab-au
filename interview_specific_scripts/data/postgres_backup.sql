--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Drop databases (except postgres and template1)
--

DROP DATABASE mlflow;




--
-- Drop roles
--

DROP ROLE mlflow;


--
-- Roles
--

CREATE ROLE mlflow;
ALTER ROLE mlflow WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'md590236272c3d6b112a6b12dce6a6503f2';






--
-- Databases
--

--
-- Database "template1" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.21 (Debian 13.21-1.pgdg120+1)
-- Dumped by pg_dump version 13.21 (Debian 13.21-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

UPDATE pg_catalog.pg_database SET datistemplate = false WHERE datname = 'template1';
DROP DATABASE template1;
--
-- Name: template1; Type: DATABASE; Schema: -; Owner: mlflow
--

CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE template1 OWNER TO mlflow;

\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: COMMENT; Schema: -; Owner: mlflow
--

COMMENT ON DATABASE template1 IS 'default template for new databases';


--
-- Name: template1; Type: DATABASE PROPERTIES; Schema: -; Owner: mlflow
--

ALTER DATABASE template1 IS_TEMPLATE = true;


\connect template1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE template1; Type: ACL; Schema: -; Owner: mlflow
--

REVOKE CONNECT,TEMPORARY ON DATABASE template1 FROM PUBLIC;
GRANT CONNECT ON DATABASE template1 TO PUBLIC;


--
-- PostgreSQL database dump complete
--

--
-- Database "mlflow" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.21 (Debian 13.21-1.pgdg120+1)
-- Dumped by pg_dump version 13.21 (Debian 13.21-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: mlflow; Type: DATABASE; Schema: -; Owner: mlflow
--

CREATE DATABASE mlflow WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE mlflow OWNER TO mlflow;

\connect mlflow

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO mlflow;

--
-- Name: datasets; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.datasets (
    dataset_uuid character varying(36) NOT NULL,
    experiment_id integer NOT NULL,
    name character varying(500) NOT NULL,
    digest character varying(36) NOT NULL,
    dataset_source_type character varying(36) NOT NULL,
    dataset_source text NOT NULL,
    dataset_schema text,
    dataset_profile text
);


ALTER TABLE public.datasets OWNER TO mlflow;

--
-- Name: experiment_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.experiment_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    experiment_id integer NOT NULL
);


ALTER TABLE public.experiment_tags OWNER TO mlflow;

--
-- Name: experiments; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.experiments (
    experiment_id integer NOT NULL,
    name character varying(256) NOT NULL,
    artifact_location character varying(256),
    lifecycle_stage character varying(32),
    creation_time bigint,
    last_update_time bigint,
    CONSTRAINT experiments_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY (ARRAY[('active'::character varying)::text, ('deleted'::character varying)::text])))
);


ALTER TABLE public.experiments OWNER TO mlflow;

--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE; Schema: public; Owner: mlflow
--

CREATE SEQUENCE public.experiments_experiment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.experiments_experiment_id_seq OWNER TO mlflow;

--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: mlflow
--

ALTER SEQUENCE public.experiments_experiment_id_seq OWNED BY public.experiments.experiment_id;


--
-- Name: input_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.input_tags (
    input_uuid character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(500) NOT NULL
);


ALTER TABLE public.input_tags OWNER TO mlflow;

--
-- Name: inputs; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.inputs (
    input_uuid character varying(36) NOT NULL,
    source_type character varying(36) NOT NULL,
    source_id character varying(36) NOT NULL,
    destination_type character varying(36) NOT NULL,
    destination_id character varying(36) NOT NULL,
    step bigint DEFAULT '0'::bigint NOT NULL
);


ALTER TABLE public.inputs OWNER TO mlflow;

--
-- Name: latest_metrics; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.latest_metrics (
    key character varying(250) NOT NULL,
    value double precision NOT NULL,
    "timestamp" bigint,
    step bigint NOT NULL,
    is_nan boolean NOT NULL,
    run_uuid character varying(32) NOT NULL
);


ALTER TABLE public.latest_metrics OWNER TO mlflow;

--
-- Name: logged_model_metrics; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.logged_model_metrics (
    model_id character varying(36) NOT NULL,
    metric_name character varying(500) NOT NULL,
    metric_timestamp_ms bigint NOT NULL,
    metric_step bigint NOT NULL,
    metric_value double precision,
    experiment_id integer NOT NULL,
    run_id character varying(32) NOT NULL,
    dataset_uuid character varying(36),
    dataset_name character varying(500),
    dataset_digest character varying(36)
);


ALTER TABLE public.logged_model_metrics OWNER TO mlflow;

--
-- Name: logged_model_params; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.logged_model_params (
    model_id character varying(36) NOT NULL,
    experiment_id integer NOT NULL,
    param_key character varying(255) NOT NULL,
    param_value text NOT NULL
);


ALTER TABLE public.logged_model_params OWNER TO mlflow;

--
-- Name: logged_model_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.logged_model_tags (
    model_id character varying(36) NOT NULL,
    experiment_id integer NOT NULL,
    tag_key character varying(255) NOT NULL,
    tag_value text NOT NULL
);


ALTER TABLE public.logged_model_tags OWNER TO mlflow;

--
-- Name: logged_models; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.logged_models (
    model_id character varying(36) NOT NULL,
    experiment_id integer NOT NULL,
    name character varying(500) NOT NULL,
    artifact_location character varying(1000) NOT NULL,
    creation_timestamp_ms bigint NOT NULL,
    last_updated_timestamp_ms bigint NOT NULL,
    status integer NOT NULL,
    lifecycle_stage character varying(32),
    model_type character varying(500),
    source_run_id character varying(32),
    status_message character varying(1000),
    CONSTRAINT logged_models_lifecycle_stage_check CHECK (((lifecycle_stage)::text = ANY (ARRAY[('active'::character varying)::text, ('deleted'::character varying)::text])))
);


ALTER TABLE public.logged_models OWNER TO mlflow;

--
-- Name: metrics; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.metrics (
    key character varying(250) NOT NULL,
    value double precision NOT NULL,
    "timestamp" bigint NOT NULL,
    run_uuid character varying(32) NOT NULL,
    step bigint DEFAULT '0'::bigint NOT NULL,
    is_nan boolean DEFAULT false NOT NULL
);


ALTER TABLE public.metrics OWNER TO mlflow;

--
-- Name: model_version_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.model_version_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    name character varying(256) NOT NULL,
    version integer NOT NULL
);


ALTER TABLE public.model_version_tags OWNER TO mlflow;

--
-- Name: model_versions; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.model_versions (
    name character varying(256) NOT NULL,
    version integer NOT NULL,
    creation_time bigint,
    last_updated_time bigint,
    description character varying(5000),
    user_id character varying(256),
    current_stage character varying(20),
    source character varying(500),
    run_id character varying(32),
    status character varying(20),
    status_message character varying(500),
    run_link character varying(500),
    storage_location character varying(500)
);


ALTER TABLE public.model_versions OWNER TO mlflow;

--
-- Name: params; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.params (
    key character varying(250) NOT NULL,
    value character varying(8000) NOT NULL,
    run_uuid character varying(32) NOT NULL
);


ALTER TABLE public.params OWNER TO mlflow;

--
-- Name: registered_model_aliases; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.registered_model_aliases (
    alias character varying(256) NOT NULL,
    version integer NOT NULL,
    name character varying(256) NOT NULL
);


ALTER TABLE public.registered_model_aliases OWNER TO mlflow;

--
-- Name: registered_model_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.registered_model_tags (
    key character varying(250) NOT NULL,
    value character varying(5000),
    name character varying(256) NOT NULL
);


ALTER TABLE public.registered_model_tags OWNER TO mlflow;

--
-- Name: registered_models; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.registered_models (
    name character varying(256) NOT NULL,
    creation_time bigint,
    last_updated_time bigint,
    description character varying(5000)
);


ALTER TABLE public.registered_models OWNER TO mlflow;

--
-- Name: runs; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.runs (
    run_uuid character varying(32) NOT NULL,
    name character varying(250),
    source_type character varying(20),
    source_name character varying(500),
    entry_point_name character varying(50),
    user_id character varying(256),
    status character varying(9),
    start_time bigint,
    end_time bigint,
    source_version character varying(50),
    lifecycle_stage character varying(20),
    artifact_uri character varying(200),
    experiment_id integer,
    deleted_time bigint,
    CONSTRAINT runs_lifecycle_stage CHECK (((lifecycle_stage)::text = ANY (ARRAY[('active'::character varying)::text, ('deleted'::character varying)::text]))),
    CONSTRAINT runs_status_check CHECK (((status)::text = ANY (ARRAY[('SCHEDULED'::character varying)::text, ('FAILED'::character varying)::text, ('FINISHED'::character varying)::text, ('RUNNING'::character varying)::text, ('KILLED'::character varying)::text]))),
    CONSTRAINT source_type CHECK (((source_type)::text = ANY (ARRAY[('NOTEBOOK'::character varying)::text, ('JOB'::character varying)::text, ('LOCAL'::character varying)::text, ('UNKNOWN'::character varying)::text, ('PROJECT'::character varying)::text])))
);


ALTER TABLE public.runs OWNER TO mlflow;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.tags (
    key character varying(250) NOT NULL,
    value character varying(8000),
    run_uuid character varying(32) NOT NULL
);


ALTER TABLE public.tags OWNER TO mlflow;

--
-- Name: trace_info; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.trace_info (
    request_id character varying(50) NOT NULL,
    experiment_id integer NOT NULL,
    timestamp_ms bigint NOT NULL,
    execution_time_ms bigint,
    status character varying(50) NOT NULL
);


ALTER TABLE public.trace_info OWNER TO mlflow;

--
-- Name: trace_request_metadata; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.trace_request_metadata (
    key character varying(250) NOT NULL,
    value character varying(8000),
    request_id character varying(50) NOT NULL
);


ALTER TABLE public.trace_request_metadata OWNER TO mlflow;

--
-- Name: trace_tags; Type: TABLE; Schema: public; Owner: mlflow
--

CREATE TABLE public.trace_tags (
    key character varying(250) NOT NULL,
    value character varying(8000),
    request_id character varying(50) NOT NULL
);


ALTER TABLE public.trace_tags OWNER TO mlflow;

--
-- Name: experiments experiment_id; Type: DEFAULT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiments ALTER COLUMN experiment_id SET DEFAULT nextval('public.experiments_experiment_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.alembic_version (version_num) FROM stdin;
6953534de441
\.


--
-- Data for Name: datasets; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.datasets (dataset_uuid, experiment_id, name, digest, dataset_source_type, dataset_source, dataset_schema, dataset_profile) FROM stdin;
\.


--
-- Data for Name: experiment_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.experiment_tags (key, value, experiment_id) FROM stdin;
mlflow.sharedViewState.bb56700ecaef4d19b55b5c60e5dea287a829783a04c63fed1e0aa0841d97d410	deflate;eJy1VVtv2jAU/iuVn9FGSEIS3iilGxpUE9BqUjVRxzkhVh078wXIKv77bAItveyFiqfI33fO8Xcu8XlCCrAkxTVlGiTqIdRCQmYgL+sfUNsz1lrS1GhQX5TGUi80LeHFqK8I6uWYKWihHT93dA/1x2NrxGgOpCYMnsP3iaYr559hjRVodWDuf7dQKTJgdyAVFfzFg7GLqeHK+ihgQDRkA8FMaZHe/bG8h5kwksCDNTxGJy6oeoteNdc7uAQLE4uNbSU45csLiTV8yCzeM0Kpr1piyl/BE8C8fzX8DzMStwfGZi1tcsNNhXkGGeo9bRvkJ+Xcne/3Ft9plgF3KXdwGiSddicLcRREnXaSBwT8ICaQ5knuRfY2P0+7IUk9HAadAEdpmpCgG6Rel0CSZ3HbmkRhh+CwHUeZZboeYC+PsR+EWeL7KST+QdkdVTSljOp6gqsXeY0cV1vbouvRdDZfeO3F9PZmZmMTUVZYgu3aoLAj4Rr1hIyhNh3kRUEShF43ju13ZeKaYYitj64rF2o8uhmi5oqBMFzPxaAJhnpe+1DGZjJftWs3bBxmpRC64KDsndZcEcxg3kR2NJbWbtPfUNWEUBoqtG19LK5aF491teSniXNzscLsDLr+REV3pRJ2kq7D+J1H2ga8TZD4jydLc//MeaSlumj7cV6c3s3dH3sGZeG6SuMEw6f6eS5xQYBrs15Vn+rop8XZt2hFYT3BG1rSv+5Z3K8cq2JMlT48jnuUqj4hdkHZNTKF3aI6cjEKvklhKsjuMDOgRs+PlJbG8gXNYFhWun4NL53PpZXEDWP745tnGxstppBLUMWQ45Q5fO/MRIrZ2Oa3CzoQPKdL6/Qu049rtF97v5zx5Ki+aLv9B19XlCc=	0
\.


--
-- Data for Name: experiments; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.experiments (experiment_id, name, artifact_location, lifecycle_stage, creation_time, last_update_time) FROM stdin;
0	Default	mlflow-artifacts:/0	active	1749979102301	1749979102301
1	dispatch_tracker	mlflow-artifacts:/1	active	1749979105611	1749979105611
2	dispatch_classifier	mlflow-artifacts:/2	active	1750053690337	1750053690337
\.


--
-- Data for Name: input_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.input_tags (input_uuid, name, value) FROM stdin;
\.


--
-- Data for Name: inputs; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.inputs (input_uuid, source_type, source_id, destination_type, destination_id, step) FROM stdin;
451aee93a5714405b9ce44ac9ee6cd55	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-42695bee041242b9bbfeb8784a3620a4	0
8cdad2ef66a443878c227d5811b843a0	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-b557f50e62fd4bef804e41ab47a51be5	0
74d30c5d1ff64f5da04b430fc23a3064	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-3048237f0c0b49e0832460bf8105d325	0
44d5db8ef74e49adbf163e5d2fd1c439	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-8adf1cd77add402ea3876ba625ad2bdc	0
cea350a96c804633b191d84a27edaa5c	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-1659c8c23499466e9d5d559b7f4428af	0
ca25b6bb35654a0f8a4ced74cad7f87a	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-8778946aa44144e4b8c90366c9c2212d	0
ee20c6e7f7664a6c8daed6402e8d3ec7	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-3d15db1d05474abbb022f42c1ff7323f	0
07e7d57456554ec2b006ece8204a9ad8	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-0af357825bd54b34b1e06b75e92daa5d	0
2be447dbc8ec42738e25f3f454901a90	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-20f291302191416fa36bb0a716b339b5	0
0bcabc4f11464749b389ce540abeb2c6	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-5367f19d3e8640a7ad4569f8dee8ed95	0
4879890fb63b48678e8fef109f71188a	RUN_OUTPUT	3490d112ca844a5397c0101acceb73b4	MODEL_OUTPUT	m-93b2dd7cd0324273a50ba7a17989143e	0
36700a6925464c18b7aea20a657e274a	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-7a289351aaac4f6eaff519568af5d07a	0
9fb69ff188644137bdfb5cc746f52566	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-326bf2aa96974d69909af36998518412	0
d70d44d5034e4e90aa12db17b2911b87	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-fdf8544f545d4b23a97091607e35e45e	0
8d3d28218e3044e3969f19b21cf553d2	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-4268983c670a4324853cf8edcdc0a9b8	0
b2348f4c1b274f4fb26eec59aa91a838	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-d6e4cbd9ddfd40d9a2360706954e6185	0
59fe3c4435c948e3a2678377777b3322	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-7f6988794a484d2db45280c929201f91	0
f504c253df3343ad8f4ee96a8e248494	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-e6bf27b0b19d49f1818299ae3bebe44d	0
1d2058e25dcf4e35b8b82a8f99cc2b3c	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-886219b5bd9c4d8dbc2dde634701a4db	0
181a677780954eda909eecccb5c84576	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-e875c8922bdb4ae6835b2ffbdf463470	0
860b8e4d9cfa4b07ace00d5e71d47a7f	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-7f0f971aa2c94544b98e414fc92c3c6a	0
5c27d5ea118247639d45f34043607011	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-1158c37275244c68bca06822e61ee4a6	0
22799176a2f6480aa2c552595b3691b8	RUN_OUTPUT	0c9be4ca093540d4ae9936b23e0ffec6	MODEL_OUTPUT	m-1673e47608e44e48801725e874dadee0	0
bf404397c6694ed1a95a6d73e1ab2f83	RUN_OUTPUT	80ac8416bf724a749b8e1ab7f7f36c8b	MODEL_OUTPUT	m-d8b25476a9534d93a737882519be85b2	0
ca1136f521524129974ab970e93a01ce	RUN_OUTPUT	80ac8416bf724a749b8e1ab7f7f36c8b	MODEL_OUTPUT	m-a3308ad1d81d47bdb0f10116b26d14ed	0
c87a2619949b4e5291b7dc685a8b27f3	RUN_OUTPUT	80ac8416bf724a749b8e1ab7f7f36c8b	MODEL_OUTPUT	m-71d95474659d4eb6aeedd3276996cc51	0
a5018f4e06f94872872c828de0b498ff	RUN_OUTPUT	80ac8416bf724a749b8e1ab7f7f36c8b	MODEL_OUTPUT	m-055c9c1261404550ab63941cff5b1766	0
1f65c92fe1dc42a98ab71cf59def2c24	RUN_OUTPUT	80ac8416bf724a749b8e1ab7f7f36c8b	MODEL_OUTPUT	m-ed0275c17165404697494b4a48e22613	0
1842f09f58264355a9a4f0d101a2b75b	RUN_OUTPUT	80ac8416bf724a749b8e1ab7f7f36c8b	MODEL_OUTPUT	m-7b7bfa269cf14d0e8b7b124293b68c3d	0
f14424ed0a0b43b6b04bc4cf175033e3	RUN_OUTPUT	80ac8416bf724a749b8e1ab7f7f36c8b	MODEL_OUTPUT	m-d8aba1e7905e4b7c86934f9284a54ca5	0
8f6de46b518f4676b504e10243b8e0b4	RUN_OUTPUT	80ac8416bf724a749b8e1ab7f7f36c8b	MODEL_OUTPUT	m-8e0db1ae29094b4c875e25cc125cfc0c	0
11ccb15da0494b91a65c559781c03ee9	RUN_OUTPUT	80ac8416bf724a749b8e1ab7f7f36c8b	MODEL_OUTPUT	m-1d3ece1c582e4445872b8116ed3fc8f7	0
a78fbc18326d4cbeb452718bb224bb37	RUN_OUTPUT	fc5a0a04a861447ca919bbd7c7a3b181	MODEL_OUTPUT	m-20a897fefe0a47d390fff8fc2c965fa2	0
0a2656d091f44b05bacfe7e6dcf2ea77	RUN_OUTPUT	fc5a0a04a861447ca919bbd7c7a3b181	MODEL_OUTPUT	m-d86ad5f77f9b4afbba97f409531e6fcd	0
fb87aab4d1d04247b5b1428abe028164	RUN_OUTPUT	fc5a0a04a861447ca919bbd7c7a3b181	MODEL_OUTPUT	m-a27e0aa8b2d94fd4aa6346fc9de8105e	0
32a3487be81148d0b12176108064e691	RUN_OUTPUT	fc5a0a04a861447ca919bbd7c7a3b181	MODEL_OUTPUT	m-4ea77050cb6c4ea5be60a8b8f92d3d99	0
3cf73cee4fe44ee98daf5df1c9b2b9e6	RUN_OUTPUT	fc5a0a04a861447ca919bbd7c7a3b181	MODEL_OUTPUT	m-ac746b9c0d5e438bbc63db76bf2d54ed	0
89d13df8c8d0437dad68057f55459a3f	RUN_OUTPUT	fc5a0a04a861447ca919bbd7c7a3b181	MODEL_OUTPUT	m-f124e86cfcba4a81ba0676a4d2892ded	0
ef456d8f654c44aeafd71573f334f887	RUN_OUTPUT	fc5a0a04a861447ca919bbd7c7a3b181	MODEL_OUTPUT	m-40a22cee8a3a4eee8fcae50e2c093499	0
\.


--
-- Data for Name: latest_metrics; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.latest_metrics (key, value, "timestamp", step, is_nan, run_uuid) FROM stdin;
lr/pg0	0.0005471179487179488	1749979153794	0	f	c1160e56f23849bdae1f9f385e49660b
lr/pg1	0.0005471179487179488	1749979153794	0	f	c1160e56f23849bdae1f9f385e49660b
lr/pg2	0.0005471179487179488	1749979153794	0	f	c1160e56f23849bdae1f9f385e49660b
train/box_loss	0.87696	1749979153794	0	f	c1160e56f23849bdae1f9f385e49660b
train/cls_loss	1.84732	1749979153794	0	f	c1160e56f23849bdae1f9f385e49660b
train/dfl_loss	1.13803	1749979153794	0	f	c1160e56f23849bdae1f9f385e49660b
val/box_loss	0.72112	1749979162490	0	f	c1160e56f23849bdae1f9f385e49660b
val/cls_loss	1.596	1749979162490	0	f	c1160e56f23849bdae1f9f385e49660b
val/dfl_loss	1.06067	1749979162490	0	f	c1160e56f23849bdae1f9f385e49660b
metrics/mAP50-95B	0.738729132346726	1749979170608	0	f	c1160e56f23849bdae1f9f385e49660b
metrics/mAP50B	0.9180259897624239	1749979170608	0	f	c1160e56f23849bdae1f9f385e49660b
metrics/precisionB	0.930542373981859	1749979170608	0	f	c1160e56f23849bdae1f9f385e49660b
metrics/recallB	0.7617449610414435	1749979170608	0	f	c1160e56f23849bdae1f9f385e49660b
train/box_loss	0.38764	1749981124303	49	f	f705565f4b2d42bb8ae252d7418395b9
train/cls_loss	0.2417	1749981124303	49	f	f705565f4b2d42bb8ae252d7418395b9
train/dfl_loss	0.87264	1749981124303	49	f	f705565f4b2d42bb8ae252d7418395b9
train_acc	0.8948948948948949	1750062318665	24	f	0c9be4ca093540d4ae9936b23e0ffec6
val_loss	0.20286950338983312	1750062321569	24	f	0c9be4ca093540d4ae9936b23e0ffec6
val_acc	0.9210977701543739	1750062321614	24	f	0c9be4ca093540d4ae9936b23e0ffec6
val/box_loss	0.40873	1749981129283	49	f	f705565f4b2d42bb8ae252d7418395b9
val/cls_loss	0.21555	1749981129283	49	f	f705565f4b2d42bb8ae252d7418395b9
val/dfl_loss	0.8571	1749981129283	49	f	f705565f4b2d42bb8ae252d7418395b9
metrics/mAP50-95B	0.9247510121650903	1749981137063	49	f	f705565f4b2d42bb8ae252d7418395b9
metrics/mAP50B	0.9912723183433296	1749981137063	49	f	f705565f4b2d42bb8ae252d7418395b9
metrics/precisionB	0.9937620578788806	1749981137063	49	f	f705565f4b2d42bb8ae252d7418395b9
metrics/recallB	0.9865610567494989	1749981137063	49	f	f705565f4b2d42bb8ae252d7418395b9
lr/pg0	0.0005471179487179488	1750053501862	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
lr/pg1	0.0005471179487179488	1750053501862	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
lr/pg2	0.0005471179487179488	1750053501862	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
train/box_loss	0.87696	1750053501862	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
train/cls_loss	1.84732	1750053501862	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
train/dfl_loss	1.13803	1750053501862	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
metrics/precisionB	0.93318	1750053508841	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
metrics/recallB	0.76143	1750053508841	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
metrics/mAP50B	0.9187	1750053508841	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
metrics/mAP50-95B	0.73903	1750053508841	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
val/box_loss	0.72112	1750053508841	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
val/cls_loss	1.596	1750053508841	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
val/dfl_loss	1.06067	1750053508841	0	f	90bbefe9b36e454fa0aef6fd8c8ef496
train_loss	0.2537989682263827	1750053982167	24	f	3490d112ca844a5397c0101acceb73b4
train_acc	0.9028077753779697	1750053982212	24	f	3490d112ca844a5397c0101acceb73b4
val_loss	0.15882891720567627	1750053984268	24	f	3490d112ca844a5397c0101acceb73b4
val_acc	0.9540229885057471	1750053984315	24	f	3490d112ca844a5397c0101acceb73b4
lr/pg0	4.967660000000004e-05	1749981124303	49	f	f705565f4b2d42bb8ae252d7418395b9
lr/pg1	4.967660000000004e-05	1749981124303	49	f	f705565f4b2d42bb8ae252d7418395b9
lr/pg2	4.967660000000004e-05	1749981124303	49	f	f705565f4b2d42bb8ae252d7418395b9
train_loss	0.2539412783788847	1750068089151	24	f	80ac8416bf724a749b8e1ab7f7f36c8b
train_acc	0.8931788931788932	1750068089201	24	f	80ac8416bf724a749b8e1ab7f7f36c8b
val_loss	0.18555015642483483	1750068092880	24	f	80ac8416bf724a749b8e1ab7f7f36c8b
train_loss	0.24645627597175102	1750062318619	24	f	0c9be4ca093540d4ae9936b23e0ffec6
val_acc	0.9262435677530017	1750068092929	24	f	80ac8416bf724a749b8e1ab7f7f36c8b
train_acc	0.8627198627198627	1750233671393	13	f	fc5a0a04a861447ca919bbd7c7a3b181
train_loss	0.32786012517950763	1750233671393	13	f	fc5a0a04a861447ca919bbd7c7a3b181
val_acc	0.8816466552315608	1750233674209	13	f	fc5a0a04a861447ca919bbd7c7a3b181
val_loss	0.26389801368040655	1750233674209	13	f	fc5a0a04a861447ca919bbd7c7a3b181
\.


--
-- Data for Name: logged_model_metrics; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.logged_model_metrics (model_id, metric_name, metric_timestamp_ms, metric_step, metric_value, experiment_id, run_id, dataset_uuid, dataset_name, dataset_digest) FROM stdin;
m-42695bee041242b9bbfeb8784a3620a4	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-42695bee041242b9bbfeb8784a3620a4	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-42695bee041242b9bbfeb8784a3620a4	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-42695bee041242b9bbfeb8784a3620a4	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-b557f50e62fd4bef804e41ab47a51be5	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-b557f50e62fd4bef804e41ab47a51be5	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-b557f50e62fd4bef804e41ab47a51be5	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-b557f50e62fd4bef804e41ab47a51be5	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-3048237f0c0b49e0832460bf8105d325	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-3048237f0c0b49e0832460bf8105d325	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-3048237f0c0b49e0832460bf8105d325	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-3048237f0c0b49e0832460bf8105d325	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-8adf1cd77add402ea3876ba625ad2bdc	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-8adf1cd77add402ea3876ba625ad2bdc	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-8adf1cd77add402ea3876ba625ad2bdc	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-8adf1cd77add402ea3876ba625ad2bdc	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-1659c8c23499466e9d5d559b7f4428af	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-1659c8c23499466e9d5d559b7f4428af	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-1659c8c23499466e9d5d559b7f4428af	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-1659c8c23499466e9d5d559b7f4428af	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-8778946aa44144e4b8c90366c9c2212d	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-8778946aa44144e4b8c90366c9c2212d	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-8778946aa44144e4b8c90366c9c2212d	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-8778946aa44144e4b8c90366c9c2212d	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-3d15db1d05474abbb022f42c1ff7323f	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-3d15db1d05474abbb022f42c1ff7323f	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-3d15db1d05474abbb022f42c1ff7323f	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-3d15db1d05474abbb022f42c1ff7323f	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-0af357825bd54b34b1e06b75e92daa5d	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-0af357825bd54b34b1e06b75e92daa5d	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-0af357825bd54b34b1e06b75e92daa5d	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-0af357825bd54b34b1e06b75e92daa5d	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-20f291302191416fa36bb0a716b339b5	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-20f291302191416fa36bb0a716b339b5	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-20f291302191416fa36bb0a716b339b5	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-20f291302191416fa36bb0a716b339b5	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-5367f19d3e8640a7ad4569f8dee8ed95	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-5367f19d3e8640a7ad4569f8dee8ed95	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-5367f19d3e8640a7ad4569f8dee8ed95	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-5367f19d3e8640a7ad4569f8dee8ed95	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-93b2dd7cd0324273a50ba7a17989143e	train_loss	1750053705768	0	0.8865105457834583	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-93b2dd7cd0324273a50ba7a17989143e	train_acc	1750053705819	0	0.5889128869690424	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-93b2dd7cd0324273a50ba7a17989143e	val_loss	1750053709181	0	0.6147527454913347	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-93b2dd7cd0324273a50ba7a17989143e	val_acc	1750053709224	0	0.7126436781609196	0	3490d112ca844a5397c0101acceb73b4	\N	\N	\N
m-7a289351aaac4f6eaff519568af5d07a	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7a289351aaac4f6eaff519568af5d07a	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7a289351aaac4f6eaff519568af5d07a	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7a289351aaac4f6eaff519568af5d07a	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-326bf2aa96974d69909af36998518412	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-326bf2aa96974d69909af36998518412	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-326bf2aa96974d69909af36998518412	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-326bf2aa96974d69909af36998518412	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-fdf8544f545d4b23a97091607e35e45e	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-fdf8544f545d4b23a97091607e35e45e	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-fdf8544f545d4b23a97091607e35e45e	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-fdf8544f545d4b23a97091607e35e45e	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-4268983c670a4324853cf8edcdc0a9b8	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-4268983c670a4324853cf8edcdc0a9b8	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-4268983c670a4324853cf8edcdc0a9b8	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-4268983c670a4324853cf8edcdc0a9b8	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-d6e4cbd9ddfd40d9a2360706954e6185	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-d6e4cbd9ddfd40d9a2360706954e6185	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-d6e4cbd9ddfd40d9a2360706954e6185	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-d6e4cbd9ddfd40d9a2360706954e6185	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7f6988794a484d2db45280c929201f91	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7f6988794a484d2db45280c929201f91	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7f6988794a484d2db45280c929201f91	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7f6988794a484d2db45280c929201f91	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-e6bf27b0b19d49f1818299ae3bebe44d	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-e6bf27b0b19d49f1818299ae3bebe44d	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-e6bf27b0b19d49f1818299ae3bebe44d	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-e6bf27b0b19d49f1818299ae3bebe44d	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-886219b5bd9c4d8dbc2dde634701a4db	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-886219b5bd9c4d8dbc2dde634701a4db	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-886219b5bd9c4d8dbc2dde634701a4db	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-886219b5bd9c4d8dbc2dde634701a4db	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-e875c8922bdb4ae6835b2ffbdf463470	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-e875c8922bdb4ae6835b2ffbdf463470	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-e875c8922bdb4ae6835b2ffbdf463470	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-e875c8922bdb4ae6835b2ffbdf463470	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7f0f971aa2c94544b98e414fc92c3c6a	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7f0f971aa2c94544b98e414fc92c3c6a	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7f0f971aa2c94544b98e414fc92c3c6a	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-7f0f971aa2c94544b98e414fc92c3c6a	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-1158c37275244c68bca06822e61ee4a6	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-1158c37275244c68bca06822e61ee4a6	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-1158c37275244c68bca06822e61ee4a6	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-1158c37275244c68bca06822e61ee4a6	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-1673e47608e44e48801725e874dadee0	train_loss	1750061898831	0	0.7659019036949678	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-1673e47608e44e48801725e874dadee0	train_acc	1750061898893	0	0.6370656370656371	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-1673e47608e44e48801725e874dadee0	val_loss	1750061903677	0	0.46171099305357366	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-1673e47608e44e48801725e874dadee0	val_acc	1750061903727	0	0.8181818181818181	0	0c9be4ca093540d4ae9936b23e0ffec6	\N	\N	\N
m-d8b25476a9534d93a737882519be85b2	train_loss	1750067675165	0	0.7987013854524293	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-d8b25476a9534d93a737882519be85b2	train_acc	1750067675231	0	0.6091806091806092	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-d8b25476a9534d93a737882519be85b2	val_loss	1750067678455	0	0.48801265909986674	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-d8b25476a9534d93a737882519be85b2	val_acc	1750067678497	0	0.7530017152658662	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-a3308ad1d81d47bdb0f10116b26d14ed	train_loss	1750067675165	0	0.7987013854524293	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-a3308ad1d81d47bdb0f10116b26d14ed	train_acc	1750067675231	0	0.6091806091806092	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-a3308ad1d81d47bdb0f10116b26d14ed	val_loss	1750067678455	0	0.48801265909986674	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-a3308ad1d81d47bdb0f10116b26d14ed	val_acc	1750067678497	0	0.7530017152658662	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-71d95474659d4eb6aeedd3276996cc51	train_loss	1750067675165	0	0.7987013854524293	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-71d95474659d4eb6aeedd3276996cc51	train_acc	1750067675231	0	0.6091806091806092	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-71d95474659d4eb6aeedd3276996cc51	val_loss	1750067678455	0	0.48801265909986674	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-71d95474659d4eb6aeedd3276996cc51	val_acc	1750067678497	0	0.7530017152658662	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-055c9c1261404550ab63941cff5b1766	train_loss	1750067675165	0	0.7987013854524293	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-055c9c1261404550ab63941cff5b1766	train_acc	1750067675231	0	0.6091806091806092	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-055c9c1261404550ab63941cff5b1766	val_loss	1750067678455	0	0.48801265909986674	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-055c9c1261404550ab63941cff5b1766	val_acc	1750067678497	0	0.7530017152658662	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-ed0275c17165404697494b4a48e22613	train_loss	1750067675165	0	0.7987013854524293	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-ed0275c17165404697494b4a48e22613	train_acc	1750067675231	0	0.6091806091806092	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-ed0275c17165404697494b4a48e22613	val_loss	1750067678455	0	0.48801265909986674	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-ed0275c17165404697494b4a48e22613	val_acc	1750067678497	0	0.7530017152658662	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-7b7bfa269cf14d0e8b7b124293b68c3d	train_loss	1750067675165	0	0.7987013854524293	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-7b7bfa269cf14d0e8b7b124293b68c3d	train_acc	1750067675231	0	0.6091806091806092	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-7b7bfa269cf14d0e8b7b124293b68c3d	val_loss	1750067678455	0	0.48801265909986674	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-7b7bfa269cf14d0e8b7b124293b68c3d	val_acc	1750067678497	0	0.7530017152658662	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-d8aba1e7905e4b7c86934f9284a54ca5	train_acc	1750067675231	0	0.6091806091806092	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-d8aba1e7905e4b7c86934f9284a54ca5	val_loss	1750067678455	0	0.48801265909986674	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-d8aba1e7905e4b7c86934f9284a54ca5	val_acc	1750067678497	0	0.7530017152658662	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-d8aba1e7905e4b7c86934f9284a54ca5	train_loss	1750067675165	0	0.7987013854524293	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-8e0db1ae29094b4c875e25cc125cfc0c	train_loss	1750067675165	0	0.7987013854524293	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-8e0db1ae29094b4c875e25cc125cfc0c	train_acc	1750067675231	0	0.6091806091806092	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-8e0db1ae29094b4c875e25cc125cfc0c	val_loss	1750067678455	0	0.48801265909986674	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-8e0db1ae29094b4c875e25cc125cfc0c	val_acc	1750067678497	0	0.7530017152658662	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-1d3ece1c582e4445872b8116ed3fc8f7	train_loss	1750067675165	0	0.7987013854524293	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-1d3ece1c582e4445872b8116ed3fc8f7	train_acc	1750067675231	0	0.6091806091806092	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-1d3ece1c582e4445872b8116ed3fc8f7	val_loss	1750067678455	0	0.48801265909986674	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-1d3ece1c582e4445872b8116ed3fc8f7	val_acc	1750067678497	0	0.7530017152658662	0	80ac8416bf724a749b8e1ab7f7f36c8b	\N	\N	\N
m-20a897fefe0a47d390fff8fc2c965fa2	train_loss	1750233441097	0	0.7426219841074606	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-20a897fefe0a47d390fff8fc2c965fa2	train_acc	1750233441097	0	0.6387816387816387	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-20a897fefe0a47d390fff8fc2c965fa2	val_loss	1750233445835	0	0.4913345296223413	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-20a897fefe0a47d390fff8fc2c965fa2	val_acc	1750233445835	0	0.7873070325900514	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-d86ad5f77f9b4afbba97f409531e6fcd	train_acc	1750233441097	0	0.6387816387816387	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-d86ad5f77f9b4afbba97f409531e6fcd	train_loss	1750233441097	0	0.7426219841074606	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-d86ad5f77f9b4afbba97f409531e6fcd	val_acc	1750233445835	0	0.7873070325900514	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-d86ad5f77f9b4afbba97f409531e6fcd	val_loss	1750233445835	0	0.4913345296223413	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-a27e0aa8b2d94fd4aa6346fc9de8105e	train_acc	1750233441097	0	0.6387816387816387	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-a27e0aa8b2d94fd4aa6346fc9de8105e	train_loss	1750233441097	0	0.7426219841074606	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-a27e0aa8b2d94fd4aa6346fc9de8105e	val_acc	1750233445835	0	0.7873070325900514	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-a27e0aa8b2d94fd4aa6346fc9de8105e	val_loss	1750233445835	0	0.4913345296223413	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-4ea77050cb6c4ea5be60a8b8f92d3d99	val_acc	1750233445835	0	0.7873070325900514	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-4ea77050cb6c4ea5be60a8b8f92d3d99	val_loss	1750233445835	0	0.4913345296223413	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-4ea77050cb6c4ea5be60a8b8f92d3d99	train_acc	1750233441097	0	0.6387816387816387	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-4ea77050cb6c4ea5be60a8b8f92d3d99	train_loss	1750233441097	0	0.7426219841074606	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-ac746b9c0d5e438bbc63db76bf2d54ed	train_acc	1750233441097	0	0.6387816387816387	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-ac746b9c0d5e438bbc63db76bf2d54ed	train_loss	1750233441097	0	0.7426219841074606	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-ac746b9c0d5e438bbc63db76bf2d54ed	val_acc	1750233445835	0	0.7873070325900514	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-ac746b9c0d5e438bbc63db76bf2d54ed	val_loss	1750233445835	0	0.4913345296223413	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-f124e86cfcba4a81ba0676a4d2892ded	train_acc	1750233441097	0	0.6387816387816387	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-f124e86cfcba4a81ba0676a4d2892ded	train_loss	1750233441097	0	0.7426219841074606	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-f124e86cfcba4a81ba0676a4d2892ded	val_acc	1750233445835	0	0.7873070325900514	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-f124e86cfcba4a81ba0676a4d2892ded	val_loss	1750233445835	0	0.4913345296223413	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-40a22cee8a3a4eee8fcae50e2c093499	train_acc	1750233441097	0	0.6387816387816387	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-40a22cee8a3a4eee8fcae50e2c093499	train_loss	1750233441097	0	0.7426219841074606	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-40a22cee8a3a4eee8fcae50e2c093499	val_acc	1750233445835	0	0.7873070325900514	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
m-40a22cee8a3a4eee8fcae50e2c093499	val_loss	1750233445835	0	0.4913345296223413	0	fc5a0a04a861447ca919bbd7c7a3b181	\N	\N	\N
\.


--
-- Data for Name: logged_model_params; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.logged_model_params (model_id, experiment_id, param_key, param_value) FROM stdin;
m-42695bee041242b9bbfeb8784a3620a4	2	learning_rate	0.001
m-42695bee041242b9bbfeb8784a3620a4	2	optimizer	SGD
m-42695bee041242b9bbfeb8784a3620a4	2	epochs	25
m-42695bee041242b9bbfeb8784a3620a4	2	batch_size	32
m-b557f50e62fd4bef804e41ab47a51be5	2	learning_rate	0.001
m-b557f50e62fd4bef804e41ab47a51be5	2	optimizer	SGD
m-b557f50e62fd4bef804e41ab47a51be5	2	epochs	25
m-b557f50e62fd4bef804e41ab47a51be5	2	batch_size	32
m-3048237f0c0b49e0832460bf8105d325	2	learning_rate	0.001
m-3048237f0c0b49e0832460bf8105d325	2	optimizer	SGD
m-3048237f0c0b49e0832460bf8105d325	2	epochs	25
m-3048237f0c0b49e0832460bf8105d325	2	batch_size	32
m-8adf1cd77add402ea3876ba625ad2bdc	2	learning_rate	0.001
m-8adf1cd77add402ea3876ba625ad2bdc	2	optimizer	SGD
m-8adf1cd77add402ea3876ba625ad2bdc	2	epochs	25
m-8adf1cd77add402ea3876ba625ad2bdc	2	batch_size	32
m-1659c8c23499466e9d5d559b7f4428af	2	learning_rate	0.001
m-1659c8c23499466e9d5d559b7f4428af	2	optimizer	SGD
m-1659c8c23499466e9d5d559b7f4428af	2	epochs	25
m-1659c8c23499466e9d5d559b7f4428af	2	batch_size	32
m-8778946aa44144e4b8c90366c9c2212d	2	learning_rate	0.001
m-8778946aa44144e4b8c90366c9c2212d	2	optimizer	SGD
m-8778946aa44144e4b8c90366c9c2212d	2	epochs	25
m-8778946aa44144e4b8c90366c9c2212d	2	batch_size	32
m-3d15db1d05474abbb022f42c1ff7323f	2	learning_rate	0.001
m-3d15db1d05474abbb022f42c1ff7323f	2	optimizer	SGD
m-3d15db1d05474abbb022f42c1ff7323f	2	epochs	25
m-3d15db1d05474abbb022f42c1ff7323f	2	batch_size	32
m-0af357825bd54b34b1e06b75e92daa5d	2	learning_rate	0.001
m-0af357825bd54b34b1e06b75e92daa5d	2	optimizer	SGD
m-0af357825bd54b34b1e06b75e92daa5d	2	epochs	25
m-0af357825bd54b34b1e06b75e92daa5d	2	batch_size	32
m-20f291302191416fa36bb0a716b339b5	2	learning_rate	0.001
m-20f291302191416fa36bb0a716b339b5	2	optimizer	SGD
m-20f291302191416fa36bb0a716b339b5	2	epochs	25
m-20f291302191416fa36bb0a716b339b5	2	batch_size	32
m-5367f19d3e8640a7ad4569f8dee8ed95	2	learning_rate	0.001
m-5367f19d3e8640a7ad4569f8dee8ed95	2	optimizer	SGD
m-5367f19d3e8640a7ad4569f8dee8ed95	2	epochs	25
m-5367f19d3e8640a7ad4569f8dee8ed95	2	batch_size	32
m-93b2dd7cd0324273a50ba7a17989143e	2	learning_rate	0.001
m-93b2dd7cd0324273a50ba7a17989143e	2	optimizer	SGD
m-93b2dd7cd0324273a50ba7a17989143e	2	epochs	25
m-93b2dd7cd0324273a50ba7a17989143e	2	batch_size	32
m-7a289351aaac4f6eaff519568af5d07a	2	learning_rate	0.001
m-7a289351aaac4f6eaff519568af5d07a	2	optimizer	SGD
m-7a289351aaac4f6eaff519568af5d07a	2	epochs	25
m-7a289351aaac4f6eaff519568af5d07a	2	batch_size	32
m-326bf2aa96974d69909af36998518412	2	learning_rate	0.001
m-326bf2aa96974d69909af36998518412	2	optimizer	SGD
m-326bf2aa96974d69909af36998518412	2	epochs	25
m-326bf2aa96974d69909af36998518412	2	batch_size	32
m-fdf8544f545d4b23a97091607e35e45e	2	learning_rate	0.001
m-fdf8544f545d4b23a97091607e35e45e	2	optimizer	SGD
m-fdf8544f545d4b23a97091607e35e45e	2	epochs	25
m-fdf8544f545d4b23a97091607e35e45e	2	batch_size	32
m-4268983c670a4324853cf8edcdc0a9b8	2	learning_rate	0.001
m-4268983c670a4324853cf8edcdc0a9b8	2	optimizer	SGD
m-4268983c670a4324853cf8edcdc0a9b8	2	epochs	25
m-4268983c670a4324853cf8edcdc0a9b8	2	batch_size	32
m-d6e4cbd9ddfd40d9a2360706954e6185	2	learning_rate	0.001
m-d6e4cbd9ddfd40d9a2360706954e6185	2	optimizer	SGD
m-d6e4cbd9ddfd40d9a2360706954e6185	2	epochs	25
m-d6e4cbd9ddfd40d9a2360706954e6185	2	batch_size	32
m-7f6988794a484d2db45280c929201f91	2	learning_rate	0.001
m-7f6988794a484d2db45280c929201f91	2	optimizer	SGD
m-7f6988794a484d2db45280c929201f91	2	epochs	25
m-7f6988794a484d2db45280c929201f91	2	batch_size	32
m-e6bf27b0b19d49f1818299ae3bebe44d	2	learning_rate	0.001
m-e6bf27b0b19d49f1818299ae3bebe44d	2	optimizer	SGD
m-e6bf27b0b19d49f1818299ae3bebe44d	2	epochs	25
m-e6bf27b0b19d49f1818299ae3bebe44d	2	batch_size	32
m-886219b5bd9c4d8dbc2dde634701a4db	2	learning_rate	0.001
m-886219b5bd9c4d8dbc2dde634701a4db	2	optimizer	SGD
m-886219b5bd9c4d8dbc2dde634701a4db	2	epochs	25
m-886219b5bd9c4d8dbc2dde634701a4db	2	batch_size	32
m-e875c8922bdb4ae6835b2ffbdf463470	2	learning_rate	0.001
m-e875c8922bdb4ae6835b2ffbdf463470	2	optimizer	SGD
m-e875c8922bdb4ae6835b2ffbdf463470	2	epochs	25
m-e875c8922bdb4ae6835b2ffbdf463470	2	batch_size	32
m-7f0f971aa2c94544b98e414fc92c3c6a	2	learning_rate	0.001
m-7f0f971aa2c94544b98e414fc92c3c6a	2	optimizer	SGD
m-7f0f971aa2c94544b98e414fc92c3c6a	2	epochs	25
m-7f0f971aa2c94544b98e414fc92c3c6a	2	batch_size	32
m-1158c37275244c68bca06822e61ee4a6	2	learning_rate	0.001
m-1158c37275244c68bca06822e61ee4a6	2	optimizer	SGD
m-1158c37275244c68bca06822e61ee4a6	2	epochs	25
m-1158c37275244c68bca06822e61ee4a6	2	batch_size	32
m-1673e47608e44e48801725e874dadee0	2	learning_rate	0.001
m-1673e47608e44e48801725e874dadee0	2	optimizer	SGD
m-1673e47608e44e48801725e874dadee0	2	epochs	25
m-1673e47608e44e48801725e874dadee0	2	batch_size	32
m-d8b25476a9534d93a737882519be85b2	2	learning_rate	0.001
m-d8b25476a9534d93a737882519be85b2	2	optimizer	SGD
m-d8b25476a9534d93a737882519be85b2	2	epochs	25
m-d8b25476a9534d93a737882519be85b2	2	batch_size	32
m-a3308ad1d81d47bdb0f10116b26d14ed	2	learning_rate	0.001
m-a3308ad1d81d47bdb0f10116b26d14ed	2	optimizer	SGD
m-a3308ad1d81d47bdb0f10116b26d14ed	2	epochs	25
m-a3308ad1d81d47bdb0f10116b26d14ed	2	batch_size	32
m-71d95474659d4eb6aeedd3276996cc51	2	learning_rate	0.001
m-71d95474659d4eb6aeedd3276996cc51	2	optimizer	SGD
m-71d95474659d4eb6aeedd3276996cc51	2	epochs	25
m-71d95474659d4eb6aeedd3276996cc51	2	batch_size	32
m-055c9c1261404550ab63941cff5b1766	2	learning_rate	0.001
m-055c9c1261404550ab63941cff5b1766	2	optimizer	SGD
m-055c9c1261404550ab63941cff5b1766	2	epochs	25
m-055c9c1261404550ab63941cff5b1766	2	batch_size	32
m-ed0275c17165404697494b4a48e22613	2	learning_rate	0.001
m-ed0275c17165404697494b4a48e22613	2	optimizer	SGD
m-ed0275c17165404697494b4a48e22613	2	epochs	25
m-ed0275c17165404697494b4a48e22613	2	batch_size	32
m-7b7bfa269cf14d0e8b7b124293b68c3d	2	learning_rate	0.001
m-7b7bfa269cf14d0e8b7b124293b68c3d	2	optimizer	SGD
m-7b7bfa269cf14d0e8b7b124293b68c3d	2	epochs	25
m-7b7bfa269cf14d0e8b7b124293b68c3d	2	batch_size	32
m-d8aba1e7905e4b7c86934f9284a54ca5	2	learning_rate	0.001
m-d8aba1e7905e4b7c86934f9284a54ca5	2	optimizer	SGD
m-d8aba1e7905e4b7c86934f9284a54ca5	2	epochs	25
m-d8aba1e7905e4b7c86934f9284a54ca5	2	batch_size	32
m-8e0db1ae29094b4c875e25cc125cfc0c	2	learning_rate	0.001
m-8e0db1ae29094b4c875e25cc125cfc0c	2	optimizer	SGD
m-8e0db1ae29094b4c875e25cc125cfc0c	2	epochs	25
m-8e0db1ae29094b4c875e25cc125cfc0c	2	batch_size	32
m-1d3ece1c582e4445872b8116ed3fc8f7	2	learning_rate	0.001
m-1d3ece1c582e4445872b8116ed3fc8f7	2	optimizer	SGD
m-1d3ece1c582e4445872b8116ed3fc8f7	2	epochs	25
m-1d3ece1c582e4445872b8116ed3fc8f7	2	batch_size	32
m-20a897fefe0a47d390fff8fc2c965fa2	2	learning_rate	0.001
m-20a897fefe0a47d390fff8fc2c965fa2	2	optimizer	SGD
m-20a897fefe0a47d390fff8fc2c965fa2	2	epochs	25
m-20a897fefe0a47d390fff8fc2c965fa2	2	batch_size	32
m-d86ad5f77f9b4afbba97f409531e6fcd	2	learning_rate	0.001
m-d86ad5f77f9b4afbba97f409531e6fcd	2	optimizer	SGD
m-d86ad5f77f9b4afbba97f409531e6fcd	2	epochs	25
m-d86ad5f77f9b4afbba97f409531e6fcd	2	batch_size	32
m-a27e0aa8b2d94fd4aa6346fc9de8105e	2	learning_rate	0.001
m-a27e0aa8b2d94fd4aa6346fc9de8105e	2	optimizer	SGD
m-a27e0aa8b2d94fd4aa6346fc9de8105e	2	epochs	25
m-a27e0aa8b2d94fd4aa6346fc9de8105e	2	batch_size	32
m-4ea77050cb6c4ea5be60a8b8f92d3d99	2	learning_rate	0.001
m-4ea77050cb6c4ea5be60a8b8f92d3d99	2	optimizer	SGD
m-4ea77050cb6c4ea5be60a8b8f92d3d99	2	epochs	25
m-4ea77050cb6c4ea5be60a8b8f92d3d99	2	batch_size	32
m-ac746b9c0d5e438bbc63db76bf2d54ed	2	learning_rate	0.001
m-ac746b9c0d5e438bbc63db76bf2d54ed	2	optimizer	SGD
m-ac746b9c0d5e438bbc63db76bf2d54ed	2	epochs	25
m-ac746b9c0d5e438bbc63db76bf2d54ed	2	batch_size	32
m-f124e86cfcba4a81ba0676a4d2892ded	2	learning_rate	0.001
m-f124e86cfcba4a81ba0676a4d2892ded	2	optimizer	SGD
m-f124e86cfcba4a81ba0676a4d2892ded	2	epochs	25
m-f124e86cfcba4a81ba0676a4d2892ded	2	batch_size	32
m-40a22cee8a3a4eee8fcae50e2c093499	2	learning_rate	0.001
m-40a22cee8a3a4eee8fcae50e2c093499	2	optimizer	SGD
m-40a22cee8a3a4eee8fcae50e2c093499	2	epochs	25
m-40a22cee8a3a4eee8fcae50e2c093499	2	batch_size	32
\.


--
-- Data for Name: logged_model_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.logged_model_tags (model_id, experiment_id, tag_key, tag_value) FROM stdin;
m-42695bee041242b9bbfeb8784a3620a4	2	mlflow.user	root
m-42695bee041242b9bbfeb8784a3620a4	2	mlflow.source.name	src/scripts/train_resnet.py
m-42695bee041242b9bbfeb8784a3620a4	2	mlflow.source.type	LOCAL
m-b557f50e62fd4bef804e41ab47a51be5	2	mlflow.user	root
m-b557f50e62fd4bef804e41ab47a51be5	2	mlflow.source.name	src/scripts/train_resnet.py
m-b557f50e62fd4bef804e41ab47a51be5	2	mlflow.source.type	LOCAL
m-3048237f0c0b49e0832460bf8105d325	2	mlflow.user	root
m-3048237f0c0b49e0832460bf8105d325	2	mlflow.source.name	src/scripts/train_resnet.py
m-3048237f0c0b49e0832460bf8105d325	2	mlflow.source.type	LOCAL
m-8adf1cd77add402ea3876ba625ad2bdc	2	mlflow.user	root
m-8adf1cd77add402ea3876ba625ad2bdc	2	mlflow.source.name	src/scripts/train_resnet.py
m-8adf1cd77add402ea3876ba625ad2bdc	2	mlflow.source.type	LOCAL
m-1659c8c23499466e9d5d559b7f4428af	2	mlflow.user	root
m-1659c8c23499466e9d5d559b7f4428af	2	mlflow.source.name	src/scripts/train_resnet.py
m-1659c8c23499466e9d5d559b7f4428af	2	mlflow.source.type	LOCAL
m-8778946aa44144e4b8c90366c9c2212d	2	mlflow.user	root
m-8778946aa44144e4b8c90366c9c2212d	2	mlflow.source.name	src/scripts/train_resnet.py
m-8778946aa44144e4b8c90366c9c2212d	2	mlflow.source.type	LOCAL
m-3d15db1d05474abbb022f42c1ff7323f	2	mlflow.user	root
m-3d15db1d05474abbb022f42c1ff7323f	2	mlflow.source.name	src/scripts/train_resnet.py
m-3d15db1d05474abbb022f42c1ff7323f	2	mlflow.source.type	LOCAL
m-0af357825bd54b34b1e06b75e92daa5d	2	mlflow.user	root
m-0af357825bd54b34b1e06b75e92daa5d	2	mlflow.source.name	src/scripts/train_resnet.py
m-0af357825bd54b34b1e06b75e92daa5d	2	mlflow.source.type	LOCAL
m-20f291302191416fa36bb0a716b339b5	2	mlflow.user	root
m-20f291302191416fa36bb0a716b339b5	2	mlflow.source.name	src/scripts/train_resnet.py
m-20f291302191416fa36bb0a716b339b5	2	mlflow.source.type	LOCAL
m-5367f19d3e8640a7ad4569f8dee8ed95	2	mlflow.user	root
m-5367f19d3e8640a7ad4569f8dee8ed95	2	mlflow.source.name	src/scripts/train_resnet.py
m-5367f19d3e8640a7ad4569f8dee8ed95	2	mlflow.source.type	LOCAL
m-93b2dd7cd0324273a50ba7a17989143e	2	mlflow.user	root
m-93b2dd7cd0324273a50ba7a17989143e	2	mlflow.source.name	src/scripts/train_resnet.py
m-93b2dd7cd0324273a50ba7a17989143e	2	mlflow.source.type	LOCAL
m-7a289351aaac4f6eaff519568af5d07a	2	mlflow.user	root
m-7a289351aaac4f6eaff519568af5d07a	2	mlflow.source.name	src/scripts/train_resnet.py
m-7a289351aaac4f6eaff519568af5d07a	2	mlflow.source.type	LOCAL
m-326bf2aa96974d69909af36998518412	2	mlflow.user	root
m-326bf2aa96974d69909af36998518412	2	mlflow.source.name	src/scripts/train_resnet.py
m-326bf2aa96974d69909af36998518412	2	mlflow.source.type	LOCAL
m-fdf8544f545d4b23a97091607e35e45e	2	mlflow.user	root
m-fdf8544f545d4b23a97091607e35e45e	2	mlflow.source.name	src/scripts/train_resnet.py
m-fdf8544f545d4b23a97091607e35e45e	2	mlflow.source.type	LOCAL
m-4268983c670a4324853cf8edcdc0a9b8	2	mlflow.user	root
m-4268983c670a4324853cf8edcdc0a9b8	2	mlflow.source.name	src/scripts/train_resnet.py
m-4268983c670a4324853cf8edcdc0a9b8	2	mlflow.source.type	LOCAL
m-d6e4cbd9ddfd40d9a2360706954e6185	2	mlflow.user	root
m-d6e4cbd9ddfd40d9a2360706954e6185	2	mlflow.source.name	src/scripts/train_resnet.py
m-d6e4cbd9ddfd40d9a2360706954e6185	2	mlflow.source.type	LOCAL
m-7f6988794a484d2db45280c929201f91	2	mlflow.user	root
m-7f6988794a484d2db45280c929201f91	2	mlflow.source.name	src/scripts/train_resnet.py
m-7f6988794a484d2db45280c929201f91	2	mlflow.source.type	LOCAL
m-e6bf27b0b19d49f1818299ae3bebe44d	2	mlflow.user	root
m-e6bf27b0b19d49f1818299ae3bebe44d	2	mlflow.source.name	src/scripts/train_resnet.py
m-e6bf27b0b19d49f1818299ae3bebe44d	2	mlflow.source.type	LOCAL
m-886219b5bd9c4d8dbc2dde634701a4db	2	mlflow.user	root
m-886219b5bd9c4d8dbc2dde634701a4db	2	mlflow.source.name	src/scripts/train_resnet.py
m-886219b5bd9c4d8dbc2dde634701a4db	2	mlflow.source.type	LOCAL
m-e875c8922bdb4ae6835b2ffbdf463470	2	mlflow.user	root
m-e875c8922bdb4ae6835b2ffbdf463470	2	mlflow.source.name	src/scripts/train_resnet.py
m-e875c8922bdb4ae6835b2ffbdf463470	2	mlflow.source.type	LOCAL
m-7f0f971aa2c94544b98e414fc92c3c6a	2	mlflow.user	root
m-7f0f971aa2c94544b98e414fc92c3c6a	2	mlflow.source.name	src/scripts/train_resnet.py
m-7f0f971aa2c94544b98e414fc92c3c6a	2	mlflow.source.type	LOCAL
m-1158c37275244c68bca06822e61ee4a6	2	mlflow.user	root
m-1158c37275244c68bca06822e61ee4a6	2	mlflow.source.name	src/scripts/train_resnet.py
m-1158c37275244c68bca06822e61ee4a6	2	mlflow.source.type	LOCAL
m-1673e47608e44e48801725e874dadee0	2	mlflow.user	root
m-1673e47608e44e48801725e874dadee0	2	mlflow.source.name	src/scripts/train_resnet.py
m-1673e47608e44e48801725e874dadee0	2	mlflow.source.type	LOCAL
m-d8b25476a9534d93a737882519be85b2	2	mlflow.user	root
m-d8b25476a9534d93a737882519be85b2	2	mlflow.source.name	src/scripts/train_resnet.py
m-d8b25476a9534d93a737882519be85b2	2	mlflow.source.type	LOCAL
m-a3308ad1d81d47bdb0f10116b26d14ed	2	mlflow.user	root
m-a3308ad1d81d47bdb0f10116b26d14ed	2	mlflow.source.name	src/scripts/train_resnet.py
m-a3308ad1d81d47bdb0f10116b26d14ed	2	mlflow.source.type	LOCAL
m-71d95474659d4eb6aeedd3276996cc51	2	mlflow.user	root
m-71d95474659d4eb6aeedd3276996cc51	2	mlflow.source.name	src/scripts/train_resnet.py
m-71d95474659d4eb6aeedd3276996cc51	2	mlflow.source.type	LOCAL
m-055c9c1261404550ab63941cff5b1766	2	mlflow.user	root
m-055c9c1261404550ab63941cff5b1766	2	mlflow.source.name	src/scripts/train_resnet.py
m-055c9c1261404550ab63941cff5b1766	2	mlflow.source.type	LOCAL
m-ed0275c17165404697494b4a48e22613	2	mlflow.user	root
m-ed0275c17165404697494b4a48e22613	2	mlflow.source.name	src/scripts/train_resnet.py
m-ed0275c17165404697494b4a48e22613	2	mlflow.source.type	LOCAL
m-7b7bfa269cf14d0e8b7b124293b68c3d	2	mlflow.user	root
m-7b7bfa269cf14d0e8b7b124293b68c3d	2	mlflow.source.name	src/scripts/train_resnet.py
m-7b7bfa269cf14d0e8b7b124293b68c3d	2	mlflow.source.type	LOCAL
m-d8aba1e7905e4b7c86934f9284a54ca5	2	mlflow.user	root
m-d8aba1e7905e4b7c86934f9284a54ca5	2	mlflow.source.name	src/scripts/train_resnet.py
m-d8aba1e7905e4b7c86934f9284a54ca5	2	mlflow.source.type	LOCAL
m-8e0db1ae29094b4c875e25cc125cfc0c	2	mlflow.user	root
m-8e0db1ae29094b4c875e25cc125cfc0c	2	mlflow.source.name	src/scripts/train_resnet.py
m-8e0db1ae29094b4c875e25cc125cfc0c	2	mlflow.source.type	LOCAL
m-1d3ece1c582e4445872b8116ed3fc8f7	2	mlflow.user	root
m-1d3ece1c582e4445872b8116ed3fc8f7	2	mlflow.source.name	src/scripts/train_resnet.py
m-1d3ece1c582e4445872b8116ed3fc8f7	2	mlflow.source.type	LOCAL
m-20a897fefe0a47d390fff8fc2c965fa2	2	mlflow.user	root
m-20a897fefe0a47d390fff8fc2c965fa2	2	mlflow.source.name	/app/src/train_resnet.py
m-20a897fefe0a47d390fff8fc2c965fa2	2	mlflow.source.type	LOCAL
m-d86ad5f77f9b4afbba97f409531e6fcd	2	mlflow.user	root
m-d86ad5f77f9b4afbba97f409531e6fcd	2	mlflow.source.name	/app/src/train_resnet.py
m-d86ad5f77f9b4afbba97f409531e6fcd	2	mlflow.source.type	LOCAL
m-a27e0aa8b2d94fd4aa6346fc9de8105e	2	mlflow.user	root
m-a27e0aa8b2d94fd4aa6346fc9de8105e	2	mlflow.source.name	/app/src/train_resnet.py
m-a27e0aa8b2d94fd4aa6346fc9de8105e	2	mlflow.source.type	LOCAL
m-4ea77050cb6c4ea5be60a8b8f92d3d99	2	mlflow.user	root
m-4ea77050cb6c4ea5be60a8b8f92d3d99	2	mlflow.source.name	/app/src/train_resnet.py
m-4ea77050cb6c4ea5be60a8b8f92d3d99	2	mlflow.source.type	LOCAL
m-ac746b9c0d5e438bbc63db76bf2d54ed	2	mlflow.user	root
m-ac746b9c0d5e438bbc63db76bf2d54ed	2	mlflow.source.name	/app/src/train_resnet.py
m-ac746b9c0d5e438bbc63db76bf2d54ed	2	mlflow.source.type	LOCAL
m-f124e86cfcba4a81ba0676a4d2892ded	2	mlflow.user	root
m-f124e86cfcba4a81ba0676a4d2892ded	2	mlflow.source.name	/app/src/train_resnet.py
m-f124e86cfcba4a81ba0676a4d2892ded	2	mlflow.source.type	LOCAL
m-40a22cee8a3a4eee8fcae50e2c093499	2	mlflow.user	root
m-40a22cee8a3a4eee8fcae50e2c093499	2	mlflow.source.name	/app/src/train_resnet.py
m-40a22cee8a3a4eee8fcae50e2c093499	2	mlflow.source.type	LOCAL
\.


--
-- Data for Name: logged_models; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.logged_models (model_id, experiment_id, name, artifact_location, creation_timestamp_ms, last_updated_timestamp_ms, status, lifecycle_stage, model_type, source_run_id, status_message) FROM stdin;
m-326bf2aa96974d69909af36998518412	2	best_model	mlflow-artifacts:/2/models/m-326bf2aa96974d69909af36998518412/artifacts	1750061924984	1750061931014	2	active		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-1d3ece1c582e4445872b8116ed3fc8f7	2	best_model	mlflow-artifacts:/2/models/m-1d3ece1c582e4445872b8116ed3fc8f7/artifacts	1750068011860	1750230980175	2	deleted		80ac8416bf724a749b8e1ab7f7f36c8b	\N
m-8e0db1ae29094b4c875e25cc125cfc0c	2	best_model	mlflow-artifacts:/2/models/m-8e0db1ae29094b4c875e25cc125cfc0c/artifacts	1750067990287	1750231000625	2	deleted		80ac8416bf724a749b8e1ab7f7f36c8b	\N
m-d8aba1e7905e4b7c86934f9284a54ca5	2	best_model	mlflow-artifacts:/2/models/m-d8aba1e7905e4b7c86934f9284a54ca5/artifacts	1750067968367	1750231005155	2	deleted		80ac8416bf724a749b8e1ab7f7f36c8b	\N
m-7b7bfa269cf14d0e8b7b124293b68c3d	2	best_model	mlflow-artifacts:/2/models/m-7b7bfa269cf14d0e8b7b124293b68c3d/artifacts	1750067857848	1750231130048	2	deleted		80ac8416bf724a749b8e1ab7f7f36c8b	\N
m-ed0275c17165404697494b4a48e22613	2	best_model	mlflow-artifacts:/2/models/m-ed0275c17165404697494b4a48e22613/artifacts	1750067836232	1750231133660	2	deleted		80ac8416bf724a749b8e1ab7f7f36c8b	\N
m-055c9c1261404550ab63941cff5b1766	2	best_model	mlflow-artifacts:/2/models/m-055c9c1261404550ab63941cff5b1766/artifacts	1750067787510	1750231136698	2	deleted		80ac8416bf724a749b8e1ab7f7f36c8b	\N
m-71d95474659d4eb6aeedd3276996cc51	2	best_model	mlflow-artifacts:/2/models/m-71d95474659d4eb6aeedd3276996cc51/artifacts	1750067723640	1750231140171	2	deleted		80ac8416bf724a749b8e1ab7f7f36c8b	\N
m-a3308ad1d81d47bdb0f10116b26d14ed	2	best_model	mlflow-artifacts:/2/models/m-a3308ad1d81d47bdb0f10116b26d14ed/artifacts	1750067701442	1750231143015	2	deleted		80ac8416bf724a749b8e1ab7f7f36c8b	\N
m-d8b25476a9534d93a737882519be85b2	2	best_model	mlflow-artifacts:/2/models/m-d8b25476a9534d93a737882519be85b2/artifacts	1750067678701	1750231146998	2	deleted		80ac8416bf724a749b8e1ab7f7f36c8b	\N
m-93b2dd7cd0324273a50ba7a17989143e	2	best_model	mlflow-artifacts:/2/models/m-93b2dd7cd0324273a50ba7a17989143e/artifacts	1750053984489	1750231152196	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-42695bee041242b9bbfeb8784a3620a4	2	best_model	mlflow-artifacts:/2/models/m-42695bee041242b9bbfeb8784a3620a4/artifacts	1750053709380	1750231169246	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-3048237f0c0b49e0832460bf8105d325	2	best_model	mlflow-artifacts:/2/models/m-3048237f0c0b49e0832460bf8105d325/artifacts	1750053741567	1750231172302	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-5367f19d3e8640a7ad4569f8dee8ed95	2	best_model	mlflow-artifacts:/2/models/m-5367f19d3e8640a7ad4569f8dee8ed95/artifacts	1750053916720	1750231175684	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-20f291302191416fa36bb0a716b339b5	2	best_model	mlflow-artifacts:/2/models/m-20f291302191416fa36bb0a716b339b5/artifacts	1750053857292	1750231179205	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-0af357825bd54b34b1e06b75e92daa5d	2	best_model	mlflow-artifacts:/2/models/m-0af357825bd54b34b1e06b75e92daa5d/artifacts	1750053833857	1750231182114	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-3d15db1d05474abbb022f42c1ff7323f	2	best_model	mlflow-artifacts:/2/models/m-3d15db1d05474abbb022f42c1ff7323f/artifacts	1750053819229	1750231184827	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-8778946aa44144e4b8c90366c9c2212d	2	best_model	mlflow-artifacts:/2/models/m-8778946aa44144e4b8c90366c9c2212d/artifacts	1750053804291	1750231187789	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-1659c8c23499466e9d5d559b7f4428af	2	best_model	mlflow-artifacts:/2/models/m-1659c8c23499466e9d5d559b7f4428af/artifacts	1750053781192	1750231191876	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-8adf1cd77add402ea3876ba625ad2bdc	2	best_model	mlflow-artifacts:/2/models/m-8adf1cd77add402ea3876ba625ad2bdc/artifacts	1750053756959	1750231201281	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-b557f50e62fd4bef804e41ab47a51be5	2	best_model	mlflow-artifacts:/2/models/m-b557f50e62fd4bef804e41ab47a51be5/artifacts	1750053726117	1750231204028	2	deleted		3490d112ca844a5397c0101acceb73b4	\N
m-7a289351aaac4f6eaff519568af5d07a	2	best_model	mlflow-artifacts:/2/models/m-7a289351aaac4f6eaff519568af5d07a/artifacts	1750061903889	1750232219716	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-d6e4cbd9ddfd40d9a2360706954e6185	2	best_model	mlflow-artifacts:/2/models/m-d6e4cbd9ddfd40d9a2360706954e6185/artifacts	1750061984752	1750232226499	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-1673e47608e44e48801725e874dadee0	2	best_model	mlflow-artifacts:/2/models/m-1673e47608e44e48801725e874dadee0/artifacts	1750062301698	1750232275248	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-1158c37275244c68bca06822e61ee4a6	2	best_model	mlflow-artifacts:/2/models/m-1158c37275244c68bca06822e61ee4a6/artifacts	1750062267199	1750232282249	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-7f0f971aa2c94544b98e414fc92c3c6a	2	best_model	mlflow-artifacts:/2/models/m-7f0f971aa2c94544b98e414fc92c3c6a/artifacts	1750062177199	1750232287650	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-e875c8922bdb4ae6835b2ffbdf463470	2	best_model	mlflow-artifacts:/2/models/m-e875c8922bdb4ae6835b2ffbdf463470/artifacts	1750062128820	1750232295829	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-886219b5bd9c4d8dbc2dde634701a4db	2	best_model	mlflow-artifacts:/2/models/m-886219b5bd9c4d8dbc2dde634701a4db/artifacts	1750062077987	1750232300546	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-e6bf27b0b19d49f1818299ae3bebe44d	2	best_model	mlflow-artifacts:/2/models/m-e6bf27b0b19d49f1818299ae3bebe44d/artifacts	1750062057562	1750232308001	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-7f6988794a484d2db45280c929201f91	2	best_model	mlflow-artifacts:/2/models/m-7f6988794a484d2db45280c929201f91/artifacts	1750062019072	1750232311682	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-4268983c670a4324853cf8edcdc0a9b8	2	best_model	mlflow-artifacts:/2/models/m-4268983c670a4324853cf8edcdc0a9b8/artifacts	1750061964796	1750232317482	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-fdf8544f545d4b23a97091607e35e45e	2	best_model	mlflow-artifacts:/2/models/m-fdf8544f545d4b23a97091607e35e45e/artifacts	1750061944875	1750232321625	2	deleted		0c9be4ca093540d4ae9936b23e0ffec6	\N
m-d86ad5f77f9b4afbba97f409531e6fcd	2	best_model	mlflow-artifacts:/2/models/m-d86ad5f77f9b4afbba97f409531e6fcd/artifacts	1750233467590	1750233791344	2	deleted		fc5a0a04a861447ca919bbd7c7a3b181	\N
m-20a897fefe0a47d390fff8fc2c965fa2	2	best_model	mlflow-artifacts:/2/models/m-20a897fefe0a47d390fff8fc2c965fa2/artifacts	1750233446007	1750233787233	2	deleted		fc5a0a04a861447ca919bbd7c7a3b181	\N
m-40a22cee8a3a4eee8fcae50e2c093499	2	best_model	mlflow-artifacts:/2/models/m-40a22cee8a3a4eee8fcae50e2c093499/artifacts	1750233613502	1750233620201	2	active		fc5a0a04a861447ca919bbd7c7a3b181	\N
m-a27e0aa8b2d94fd4aa6346fc9de8105e	2	best_model	mlflow-artifacts:/2/models/m-a27e0aa8b2d94fd4aa6346fc9de8105e/artifacts	1750233488332	1750233794953	2	deleted		fc5a0a04a861447ca919bbd7c7a3b181	\N
m-4ea77050cb6c4ea5be60a8b8f92d3d99	2	best_model	mlflow-artifacts:/2/models/m-4ea77050cb6c4ea5be60a8b8f92d3d99/artifacts	1750233523157	1750233799427	2	deleted		fc5a0a04a861447ca919bbd7c7a3b181	\N
m-ac746b9c0d5e438bbc63db76bf2d54ed	2	best_model	mlflow-artifacts:/2/models/m-ac746b9c0d5e438bbc63db76bf2d54ed/artifacts	1750233544856	1750233805351	2	deleted		fc5a0a04a861447ca919bbd7c7a3b181	\N
m-f124e86cfcba4a81ba0676a4d2892ded	2	best_model	mlflow-artifacts:/2/models/m-f124e86cfcba4a81ba0676a4d2892ded/artifacts	1750233592558	1750233811660	2	deleted		fc5a0a04a861447ca919bbd7c7a3b181	\N
\.


--
-- Data for Name: metrics; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.metrics (key, value, "timestamp", run_uuid, step, is_nan) FROM stdin;
lr/pg0	0.0005471179487179488	1749979153794	c1160e56f23849bdae1f9f385e49660b	0	f
lr/pg1	0.0005471179487179488	1749979153794	c1160e56f23849bdae1f9f385e49660b	0	f
lr/pg2	0.0005471179487179488	1749979153794	c1160e56f23849bdae1f9f385e49660b	0	f
train/box_loss	0.87696	1749979153794	c1160e56f23849bdae1f9f385e49660b	0	f
train/cls_loss	1.84732	1749979153794	c1160e56f23849bdae1f9f385e49660b	0	f
train/dfl_loss	1.13803	1749979153794	c1160e56f23849bdae1f9f385e49660b	0	f
metrics/precisionB	0.93318	1749979162490	c1160e56f23849bdae1f9f385e49660b	0	f
metrics/recallB	0.76143	1749979162490	c1160e56f23849bdae1f9f385e49660b	0	f
metrics/mAP50B	0.9187	1749979162490	c1160e56f23849bdae1f9f385e49660b	0	f
metrics/mAP50-95B	0.73903	1749979162490	c1160e56f23849bdae1f9f385e49660b	0	f
val/box_loss	0.72112	1749979162490	c1160e56f23849bdae1f9f385e49660b	0	f
val/cls_loss	1.596	1749979162490	c1160e56f23849bdae1f9f385e49660b	0	f
val/dfl_loss	1.06067	1749979162490	c1160e56f23849bdae1f9f385e49660b	0	f
metrics/precisionB	0.930542373981859	1749979170608	c1160e56f23849bdae1f9f385e49660b	0	f
metrics/recallB	0.7617449610414435	1749979170608	c1160e56f23849bdae1f9f385e49660b	0	f
metrics/mAP50B	0.9180259897624239	1749979170608	c1160e56f23849bdae1f9f385e49660b	0	f
metrics/mAP50-95B	0.738729132346726	1749979170608	c1160e56f23849bdae1f9f385e49660b	0	f
lr/pg0	0.0005471179487179488	1749979687145	f705565f4b2d42bb8ae252d7418395b9	0	f
lr/pg1	0.0005471179487179488	1749979687145	f705565f4b2d42bb8ae252d7418395b9	0	f
lr/pg2	0.0005471179487179488	1749979687145	f705565f4b2d42bb8ae252d7418395b9	0	f
train/box_loss	0.87696	1749979687145	f705565f4b2d42bb8ae252d7418395b9	0	f
train/cls_loss	1.84732	1749979687145	f705565f4b2d42bb8ae252d7418395b9	0	f
train/dfl_loss	1.13803	1749979687145	f705565f4b2d42bb8ae252d7418395b9	0	f
metrics/precisionB	0.93318	1749979693028	f705565f4b2d42bb8ae252d7418395b9	0	f
metrics/recallB	0.76143	1749979693028	f705565f4b2d42bb8ae252d7418395b9	0	f
metrics/mAP50B	0.9187	1749979693028	f705565f4b2d42bb8ae252d7418395b9	0	f
metrics/mAP50-95B	0.73903	1749979693028	f705565f4b2d42bb8ae252d7418395b9	0	f
val/box_loss	0.72112	1749979693028	f705565f4b2d42bb8ae252d7418395b9	0	f
val/cls_loss	1.596	1749979693028	f705565f4b2d42bb8ae252d7418395b9	0	f
val/dfl_loss	1.06067	1749979693028	f705565f4b2d42bb8ae252d7418395b9	0	f
lr/pg0	0.00108094948	1749979717813	f705565f4b2d42bb8ae252d7418395b9	1	f
lr/pg1	0.00108094948	1749979717813	f705565f4b2d42bb8ae252d7418395b9	1	f
lr/pg2	0.00108094948	1749979717813	f705565f4b2d42bb8ae252d7418395b9	1	f
train/box_loss	0.83151	1749979717813	f705565f4b2d42bb8ae252d7418395b9	1	f
train/cls_loss	1.16961	1749979717813	f705565f4b2d42bb8ae252d7418395b9	1	f
train/dfl_loss	1.09237	1749979717813	f705565f4b2d42bb8ae252d7418395b9	1	f
metrics/precisionB	0.86881	1749979722077	f705565f4b2d42bb8ae252d7418395b9	1	f
metrics/recallB	0.80899	1749979722077	f705565f4b2d42bb8ae252d7418395b9	1	f
metrics/mAP50B	0.92602	1749979722077	f705565f4b2d42bb8ae252d7418395b9	1	f
metrics/mAP50-95B	0.70867	1749979722077	f705565f4b2d42bb8ae252d7418395b9	1	f
val/box_loss	0.87775	1749979722077	f705565f4b2d42bb8ae252d7418395b9	1	f
val/cls_loss	1.33461	1749979722077	f705565f4b2d42bb8ae252d7418395b9	1	f
val/dfl_loss	1.17671	1749979722077	f705565f4b2d42bb8ae252d7418395b9	1	f
lr/pg0	0.0015927766112820512	1749979747175	f705565f4b2d42bb8ae252d7418395b9	2	f
lr/pg1	0.0015927766112820512	1749979747175	f705565f4b2d42bb8ae252d7418395b9	2	f
lr/pg2	0.0015927766112820512	1749979747175	f705565f4b2d42bb8ae252d7418395b9	2	f
train/box_loss	0.85757	1749979747175	f705565f4b2d42bb8ae252d7418395b9	2	f
train/cls_loss	1.09383	1749979747175	f705565f4b2d42bb8ae252d7418395b9	2	f
train/dfl_loss	1.10006	1749979747175	f705565f4b2d42bb8ae252d7418395b9	2	f
metrics/precisionB	0.84158	1749979751883	f705565f4b2d42bb8ae252d7418395b9	2	f
metrics/recallB	0.79141	1749979751883	f705565f4b2d42bb8ae252d7418395b9	2	f
metrics/mAP50B	0.86637	1749979751883	f705565f4b2d42bb8ae252d7418395b9	2	f
metrics/mAP50-95B	0.68542	1749979751883	f705565f4b2d42bb8ae252d7418395b9	2	f
val/box_loss	0.84434	1749979751883	f705565f4b2d42bb8ae252d7418395b9	2	f
val/cls_loss	1.24629	1749979751883	f705565f4b2d42bb8ae252d7418395b9	2	f
val/dfl_loss	1.14906	1749979751883	f705565f4b2d42bb8ae252d7418395b9	2	f
lr/pg0	0.0015679802000000001	1749979776188	f705565f4b2d42bb8ae252d7418395b9	3	f
lr/pg1	0.0015679802000000001	1749979776188	f705565f4b2d42bb8ae252d7418395b9	3	f
lr/pg2	0.0015679802000000001	1749979776188	f705565f4b2d42bb8ae252d7418395b9	3	f
train/box_loss	0.85468	1749979776188	f705565f4b2d42bb8ae252d7418395b9	3	f
train/cls_loss	0.9466	1749979776188	f705565f4b2d42bb8ae252d7418395b9	3	f
train/dfl_loss	1.10991	1749979776188	f705565f4b2d42bb8ae252d7418395b9	3	f
metrics/precisionB	0.89534	1749979780442	f705565f4b2d42bb8ae252d7418395b9	3	f
metrics/recallB	0.93469	1749979780442	f705565f4b2d42bb8ae252d7418395b9	3	f
metrics/mAP50B	0.9712	1749979780442	f705565f4b2d42bb8ae252d7418395b9	3	f
metrics/mAP50-95B	0.78735	1749979780442	f705565f4b2d42bb8ae252d7418395b9	3	f
val/box_loss	0.73717	1749979780442	f705565f4b2d42bb8ae252d7418395b9	3	f
val/cls_loss	0.87551	1749979780442	f705565f4b2d42bb8ae252d7418395b9	3	f
val/dfl_loss	1.04485	1749979780442	f705565f4b2d42bb8ae252d7418395b9	3	f
lr/pg0	0.0015349736000000002	1749979805158	f705565f4b2d42bb8ae252d7418395b9	4	f
lr/pg1	0.0015349736000000002	1749979805158	f705565f4b2d42bb8ae252d7418395b9	4	f
lr/pg2	0.0015349736000000002	1749979805158	f705565f4b2d42bb8ae252d7418395b9	4	f
train/box_loss	0.83119	1749979805158	f705565f4b2d42bb8ae252d7418395b9	4	f
train/cls_loss	0.85014	1749979805158	f705565f4b2d42bb8ae252d7418395b9	4	f
train/dfl_loss	1.08963	1749979805158	f705565f4b2d42bb8ae252d7418395b9	4	f
metrics/precisionB	0.89863	1749979809239	f705565f4b2d42bb8ae252d7418395b9	4	f
metrics/recallB	0.88494	1749979809239	f705565f4b2d42bb8ae252d7418395b9	4	f
metrics/mAP50B	0.96045	1749979809239	f705565f4b2d42bb8ae252d7418395b9	4	f
metrics/mAP50-95B	0.78424	1749979809239	f705565f4b2d42bb8ae252d7418395b9	4	f
val/box_loss	0.71167	1749979809239	f705565f4b2d42bb8ae252d7418395b9	4	f
val/cls_loss	0.8616	1749979809239	f705565f4b2d42bb8ae252d7418395b9	4	f
val/dfl_loss	1.04132	1749979809239	f705565f4b2d42bb8ae252d7418395b9	4	f
lr/pg0	0.001501967	1749979833348	f705565f4b2d42bb8ae252d7418395b9	5	f
lr/pg1	0.001501967	1749979833348	f705565f4b2d42bb8ae252d7418395b9	5	f
lr/pg2	0.001501967	1749979833348	f705565f4b2d42bb8ae252d7418395b9	5	f
train/box_loss	0.78814	1749979833348	f705565f4b2d42bb8ae252d7418395b9	5	f
train/cls_loss	0.77117	1749979833348	f705565f4b2d42bb8ae252d7418395b9	5	f
train/dfl_loss	1.06306	1749979833348	f705565f4b2d42bb8ae252d7418395b9	5	f
metrics/precisionB	0.94838	1749979837624	f705565f4b2d42bb8ae252d7418395b9	5	f
metrics/recallB	0.94837	1749979837624	f705565f4b2d42bb8ae252d7418395b9	5	f
metrics/mAP50B	0.97326	1749979837624	f705565f4b2d42bb8ae252d7418395b9	5	f
metrics/mAP50-95B	0.7942	1749979837624	f705565f4b2d42bb8ae252d7418395b9	5	f
val/box_loss	0.71069	1749979837624	f705565f4b2d42bb8ae252d7418395b9	5	f
val/cls_loss	0.58984	1749979837624	f705565f4b2d42bb8ae252d7418395b9	5	f
val/dfl_loss	1.05948	1749979837624	f705565f4b2d42bb8ae252d7418395b9	5	f
lr/pg0	0.0014689604	1749979863407	f705565f4b2d42bb8ae252d7418395b9	6	f
lr/pg1	0.0014689604	1749979863407	f705565f4b2d42bb8ae252d7418395b9	6	f
lr/pg2	0.0014689604	1749979863407	f705565f4b2d42bb8ae252d7418395b9	6	f
train/box_loss	0.7674	1749979863407	f705565f4b2d42bb8ae252d7418395b9	6	f
train/cls_loss	0.69215	1749979863407	f705565f4b2d42bb8ae252d7418395b9	6	f
train/dfl_loss	1.04194	1749979863407	f705565f4b2d42bb8ae252d7418395b9	6	f
metrics/precisionB	0.94329	1749979868601	f705565f4b2d42bb8ae252d7418395b9	6	f
metrics/recallB	0.91988	1749979868601	f705565f4b2d42bb8ae252d7418395b9	6	f
metrics/mAP50B	0.96838	1749979868601	f705565f4b2d42bb8ae252d7418395b9	6	f
metrics/mAP50-95B	0.80933	1749979868601	f705565f4b2d42bb8ae252d7418395b9	6	f
val/box_loss	0.65615	1749979868601	f705565f4b2d42bb8ae252d7418395b9	6	f
val/cls_loss	0.58012	1749979868601	f705565f4b2d42bb8ae252d7418395b9	6	f
val/dfl_loss	1.01762	1749979868601	f705565f4b2d42bb8ae252d7418395b9	6	f
lr/pg0	0.0014359538	1749979894867	f705565f4b2d42bb8ae252d7418395b9	7	f
lr/pg1	0.0014359538	1749979894867	f705565f4b2d42bb8ae252d7418395b9	7	f
lr/pg2	0.0014359538	1749979894867	f705565f4b2d42bb8ae252d7418395b9	7	f
train/box_loss	0.74283	1749979894867	f705565f4b2d42bb8ae252d7418395b9	7	f
train/cls_loss	0.6703	1749979894867	f705565f4b2d42bb8ae252d7418395b9	7	f
train/dfl_loss	1.0398	1749979894867	f705565f4b2d42bb8ae252d7418395b9	7	f
metrics/precisionB	0.98794	1749979899748	f705565f4b2d42bb8ae252d7418395b9	7	f
metrics/recallB	0.95842	1749979899748	f705565f4b2d42bb8ae252d7418395b9	7	f
metrics/mAP50B	0.98385	1749979899748	f705565f4b2d42bb8ae252d7418395b9	7	f
metrics/mAP50-95B	0.83363	1749979899748	f705565f4b2d42bb8ae252d7418395b9	7	f
val/box_loss	0.59812	1749979899748	f705565f4b2d42bb8ae252d7418395b9	7	f
val/cls_loss	0.50611	1749979899748	f705565f4b2d42bb8ae252d7418395b9	7	f
val/dfl_loss	0.93931	1749979899748	f705565f4b2d42bb8ae252d7418395b9	7	f
lr/pg0	0.0014029472000000002	1749979926604	f705565f4b2d42bb8ae252d7418395b9	8	f
lr/pg1	0.0014029472000000002	1749979926604	f705565f4b2d42bb8ae252d7418395b9	8	f
lr/pg2	0.0014029472000000002	1749979926604	f705565f4b2d42bb8ae252d7418395b9	8	f
train/box_loss	0.72432	1749979926604	f705565f4b2d42bb8ae252d7418395b9	8	f
train/cls_loss	0.64071	1749979926604	f705565f4b2d42bb8ae252d7418395b9	8	f
train/dfl_loss	1.02892	1749979926604	f705565f4b2d42bb8ae252d7418395b9	8	f
metrics/precisionB	0.97634	1749979931235	f705565f4b2d42bb8ae252d7418395b9	8	f
metrics/recallB	0.97887	1749979931235	f705565f4b2d42bb8ae252d7418395b9	8	f
metrics/mAP50B	0.98562	1749979931235	f705565f4b2d42bb8ae252d7418395b9	8	f
metrics/mAP50-95B	0.8377	1749979931235	f705565f4b2d42bb8ae252d7418395b9	8	f
val/box_loss	0.57107	1749979931235	f705565f4b2d42bb8ae252d7418395b9	8	f
val/cls_loss	0.43995	1749979931235	f705565f4b2d42bb8ae252d7418395b9	8	f
val/dfl_loss	0.96214	1749979931235	f705565f4b2d42bb8ae252d7418395b9	8	f
lr/pg0	0.0013699406000000003	1749979957814	f705565f4b2d42bb8ae252d7418395b9	9	f
lr/pg1	0.0013699406000000003	1749979957814	f705565f4b2d42bb8ae252d7418395b9	9	f
lr/pg2	0.0013699406000000003	1749979957814	f705565f4b2d42bb8ae252d7418395b9	9	f
train/box_loss	0.71123	1749979957814	f705565f4b2d42bb8ae252d7418395b9	9	f
train/cls_loss	0.61436	1749979957814	f705565f4b2d42bb8ae252d7418395b9	9	f
train/dfl_loss	1.02281	1749979957814	f705565f4b2d42bb8ae252d7418395b9	9	f
metrics/precisionB	0.94841	1749979962313	f705565f4b2d42bb8ae252d7418395b9	9	f
metrics/recallB	0.94151	1749979962313	f705565f4b2d42bb8ae252d7418395b9	9	f
metrics/mAP50B	0.98183	1749979962313	f705565f4b2d42bb8ae252d7418395b9	9	f
metrics/mAP50-95B	0.85733	1749979962313	f705565f4b2d42bb8ae252d7418395b9	9	f
val/box_loss	0.54844	1749979962313	f705565f4b2d42bb8ae252d7418395b9	9	f
val/cls_loss	0.47004	1749979962313	f705565f4b2d42bb8ae252d7418395b9	9	f
val/dfl_loss	0.92429	1749979962313	f705565f4b2d42bb8ae252d7418395b9	9	f
lr/pg0	0.0013369340000000001	1749979986979	f705565f4b2d42bb8ae252d7418395b9	10	f
lr/pg1	0.0013369340000000001	1749979986979	f705565f4b2d42bb8ae252d7418395b9	10	f
lr/pg2	0.0013369340000000001	1749979986979	f705565f4b2d42bb8ae252d7418395b9	10	f
train/box_loss	0.69131	1749979986979	f705565f4b2d42bb8ae252d7418395b9	10	f
train/cls_loss	0.57762	1749979986979	f705565f4b2d42bb8ae252d7418395b9	10	f
train/dfl_loss	1.02523	1749979986979	f705565f4b2d42bb8ae252d7418395b9	10	f
metrics/precisionB	0.97567	1749979991328	f705565f4b2d42bb8ae252d7418395b9	10	f
metrics/recallB	0.97445	1749979991328	f705565f4b2d42bb8ae252d7418395b9	10	f
metrics/mAP50B	0.98793	1749979991328	f705565f4b2d42bb8ae252d7418395b9	10	f
metrics/mAP50-95B	0.84387	1749979991328	f705565f4b2d42bb8ae252d7418395b9	10	f
val/box_loss	0.58252	1749979991328	f705565f4b2d42bb8ae252d7418395b9	10	f
val/cls_loss	0.43636	1749979991328	f705565f4b2d42bb8ae252d7418395b9	10	f
val/dfl_loss	0.95513	1749979991328	f705565f4b2d42bb8ae252d7418395b9	10	f
lr/pg0	0.0013039274	1749980015997	f705565f4b2d42bb8ae252d7418395b9	11	f
lr/pg1	0.0013039274	1749980015997	f705565f4b2d42bb8ae252d7418395b9	11	f
lr/pg2	0.0013039274	1749980015997	f705565f4b2d42bb8ae252d7418395b9	11	f
train/box_loss	0.68693	1749980015997	f705565f4b2d42bb8ae252d7418395b9	11	f
train/cls_loss	0.56025	1749980015997	f705565f4b2d42bb8ae252d7418395b9	11	f
train/dfl_loss	1.01584	1749980015997	f705565f4b2d42bb8ae252d7418395b9	11	f
metrics/precisionB	0.97861	1749980020494	f705565f4b2d42bb8ae252d7418395b9	11	f
metrics/recallB	0.951	1749980020494	f705565f4b2d42bb8ae252d7418395b9	11	f
metrics/mAP50B	0.98058	1749980020494	f705565f4b2d42bb8ae252d7418395b9	11	f
metrics/mAP50-95B	0.84788	1749980020494	f705565f4b2d42bb8ae252d7418395b9	11	f
val/box_loss	0.58192	1749980020494	f705565f4b2d42bb8ae252d7418395b9	11	f
val/cls_loss	0.44132	1749980020494	f705565f4b2d42bb8ae252d7418395b9	11	f
val/dfl_loss	0.95143	1749980020494	f705565f4b2d42bb8ae252d7418395b9	11	f
lr/pg0	0.0012709208	1749980045668	f705565f4b2d42bb8ae252d7418395b9	12	f
lr/pg1	0.0012709208	1749980045668	f705565f4b2d42bb8ae252d7418395b9	12	f
lr/pg2	0.0012709208	1749980045668	f705565f4b2d42bb8ae252d7418395b9	12	f
train/box_loss	0.68187	1749980045668	f705565f4b2d42bb8ae252d7418395b9	12	f
train/cls_loss	0.55902	1749980045668	f705565f4b2d42bb8ae252d7418395b9	12	f
train/dfl_loss	1.00765	1749980045668	f705565f4b2d42bb8ae252d7418395b9	12	f
lr/pg0	0.0012379142000000002	1749980073979	f705565f4b2d42bb8ae252d7418395b9	13	f
lr/pg1	0.0012379142000000002	1749980073979	f705565f4b2d42bb8ae252d7418395b9	13	f
lr/pg2	0.0012379142000000002	1749980073979	f705565f4b2d42bb8ae252d7418395b9	13	f
train/box_loss	0.67984	1749980073979	f705565f4b2d42bb8ae252d7418395b9	13	f
train/cls_loss	0.54616	1749980073979	f705565f4b2d42bb8ae252d7418395b9	13	f
train/dfl_loss	1.01263	1749980073979	f705565f4b2d42bb8ae252d7418395b9	13	f
metrics/precisionB	0.96659	1749980077983	f705565f4b2d42bb8ae252d7418395b9	13	f
metrics/recallB	0.96295	1749980077983	f705565f4b2d42bb8ae252d7418395b9	13	f
metrics/mAP50B	0.98884	1749980077983	f705565f4b2d42bb8ae252d7418395b9	13	f
metrics/mAP50-95B	0.86142	1749980077983	f705565f4b2d42bb8ae252d7418395b9	13	f
val/box_loss	0.54602	1749980077983	f705565f4b2d42bb8ae252d7418395b9	13	f
val/cls_loss	0.40948	1749980077983	f705565f4b2d42bb8ae252d7418395b9	13	f
val/dfl_loss	0.9426	1749980077983	f705565f4b2d42bb8ae252d7418395b9	13	f
metrics/precisionB	0.99047	1749980049674	f705565f4b2d42bb8ae252d7418395b9	12	f
metrics/recallB	0.98309	1749980049674	f705565f4b2d42bb8ae252d7418395b9	12	f
metrics/mAP50B	0.98902	1749980049674	f705565f4b2d42bb8ae252d7418395b9	12	f
metrics/mAP50-95B	0.87171	1749980049674	f705565f4b2d42bb8ae252d7418395b9	12	f
val/box_loss	0.55581	1749980049674	f705565f4b2d42bb8ae252d7418395b9	12	f
val/cls_loss	0.36987	1749980049674	f705565f4b2d42bb8ae252d7418395b9	12	f
val/dfl_loss	0.94386	1749980049674	f705565f4b2d42bb8ae252d7418395b9	12	f
lr/pg0	0.0012049076	1749980102089	f705565f4b2d42bb8ae252d7418395b9	14	f
lr/pg1	0.0012049076	1749980102089	f705565f4b2d42bb8ae252d7418395b9	14	f
lr/pg2	0.0012049076	1749980102089	f705565f4b2d42bb8ae252d7418395b9	14	f
train/box_loss	0.67045	1749980102089	f705565f4b2d42bb8ae252d7418395b9	14	f
train/cls_loss	0.52379	1749980102089	f705565f4b2d42bb8ae252d7418395b9	14	f
train/dfl_loss	1.00928	1749980102089	f705565f4b2d42bb8ae252d7418395b9	14	f
metrics/precisionB	0.97645	1749980106000	f705565f4b2d42bb8ae252d7418395b9	14	f
metrics/recallB	0.96633	1749980106000	f705565f4b2d42bb8ae252d7418395b9	14	f
metrics/mAP50B	0.98644	1749980106000	f705565f4b2d42bb8ae252d7418395b9	14	f
metrics/mAP50-95B	0.8589	1749980106000	f705565f4b2d42bb8ae252d7418395b9	14	f
val/box_loss	0.52307	1749980106000	f705565f4b2d42bb8ae252d7418395b9	14	f
val/cls_loss	0.44104	1749980106000	f705565f4b2d42bb8ae252d7418395b9	14	f
val/dfl_loss	0.90611	1749980106000	f705565f4b2d42bb8ae252d7418395b9	14	f
lr/pg0	0.001171901	1749980130525	f705565f4b2d42bb8ae252d7418395b9	15	f
lr/pg1	0.001171901	1749980130525	f705565f4b2d42bb8ae252d7418395b9	15	f
lr/pg2	0.001171901	1749980130525	f705565f4b2d42bb8ae252d7418395b9	15	f
train/box_loss	0.65103	1749980130525	f705565f4b2d42bb8ae252d7418395b9	15	f
train/cls_loss	0.52728	1749980130525	f705565f4b2d42bb8ae252d7418395b9	15	f
train/dfl_loss	0.9996	1749980130525	f705565f4b2d42bb8ae252d7418395b9	15	f
metrics/precisionB	0.98947	1749980134807	f705565f4b2d42bb8ae252d7418395b9	15	f
metrics/recallB	0.97713	1749980134807	f705565f4b2d42bb8ae252d7418395b9	15	f
metrics/mAP50B	0.98687	1749980134807	f705565f4b2d42bb8ae252d7418395b9	15	f
metrics/mAP50-95B	0.87018	1749980134807	f705565f4b2d42bb8ae252d7418395b9	15	f
val/box_loss	0.52333	1749980134807	f705565f4b2d42bb8ae252d7418395b9	15	f
val/cls_loss	0.36905	1749980134807	f705565f4b2d42bb8ae252d7418395b9	15	f
val/dfl_loss	0.90737	1749980134807	f705565f4b2d42bb8ae252d7418395b9	15	f
lr/pg0	0.0011388944	1749980159835	f705565f4b2d42bb8ae252d7418395b9	16	f
lr/pg1	0.0011388944	1749980159835	f705565f4b2d42bb8ae252d7418395b9	16	f
lr/pg2	0.0011388944	1749980159835	f705565f4b2d42bb8ae252d7418395b9	16	f
train/box_loss	0.6562	1749980159835	f705565f4b2d42bb8ae252d7418395b9	16	f
train/cls_loss	0.507	1749980159835	f705565f4b2d42bb8ae252d7418395b9	16	f
train/dfl_loss	1.00035	1749980159835	f705565f4b2d42bb8ae252d7418395b9	16	f
metrics/precisionB	0.99579	1749980163933	f705565f4b2d42bb8ae252d7418395b9	16	f
metrics/recallB	0.97635	1749980163933	f705565f4b2d42bb8ae252d7418395b9	16	f
metrics/mAP50B	0.98422	1749980163933	f705565f4b2d42bb8ae252d7418395b9	16	f
metrics/mAP50-95B	0.875	1749980163933	f705565f4b2d42bb8ae252d7418395b9	16	f
val/box_loss	0.51958	1749980163933	f705565f4b2d42bb8ae252d7418395b9	16	f
val/cls_loss	0.37139	1749980163933	f705565f4b2d42bb8ae252d7418395b9	16	f
val/dfl_loss	0.91736	1749980163933	f705565f4b2d42bb8ae252d7418395b9	16	f
lr/pg0	0.0011058878	1749980188648	f705565f4b2d42bb8ae252d7418395b9	17	f
lr/pg1	0.0011058878	1749980188648	f705565f4b2d42bb8ae252d7418395b9	17	f
lr/pg2	0.0011058878	1749980188648	f705565f4b2d42bb8ae252d7418395b9	17	f
train/box_loss	0.64222	1749980188648	f705565f4b2d42bb8ae252d7418395b9	17	f
train/cls_loss	0.48664	1749980188648	f705565f4b2d42bb8ae252d7418395b9	17	f
train/dfl_loss	0.98771	1749980188648	f705565f4b2d42bb8ae252d7418395b9	17	f
metrics/precisionB	0.98897	1749980192887	f705565f4b2d42bb8ae252d7418395b9	17	f
metrics/recallB	0.97969	1749980192887	f705565f4b2d42bb8ae252d7418395b9	17	f
metrics/mAP50B	0.99022	1749980192887	f705565f4b2d42bb8ae252d7418395b9	17	f
metrics/mAP50-95B	0.87222	1749980192887	f705565f4b2d42bb8ae252d7418395b9	17	f
val/box_loss	0.50855	1749980192887	f705565f4b2d42bb8ae252d7418395b9	17	f
val/cls_loss	0.33941	1749980192887	f705565f4b2d42bb8ae252d7418395b9	17	f
val/dfl_loss	0.90206	1749980192887	f705565f4b2d42bb8ae252d7418395b9	17	f
lr/pg0	0.0010728812000000002	1749980217517	f705565f4b2d42bb8ae252d7418395b9	18	f
lr/pg1	0.0010728812000000002	1749980217517	f705565f4b2d42bb8ae252d7418395b9	18	f
lr/pg2	0.0010728812000000002	1749980217517	f705565f4b2d42bb8ae252d7418395b9	18	f
train/box_loss	0.62447	1749980217517	f705565f4b2d42bb8ae252d7418395b9	18	f
train/cls_loss	0.47246	1749980217517	f705565f4b2d42bb8ae252d7418395b9	18	f
train/dfl_loss	0.98878	1749980217517	f705565f4b2d42bb8ae252d7418395b9	18	f
metrics/precisionB	0.99146	1749980221976	f705565f4b2d42bb8ae252d7418395b9	18	f
metrics/recallB	0.97561	1749980221976	f705565f4b2d42bb8ae252d7418395b9	18	f
metrics/mAP50B	0.98572	1749980221976	f705565f4b2d42bb8ae252d7418395b9	18	f
metrics/mAP50-95B	0.87569	1749980221976	f705565f4b2d42bb8ae252d7418395b9	18	f
val/box_loss	0.5067	1749980221976	f705565f4b2d42bb8ae252d7418395b9	18	f
val/cls_loss	0.33382	1749980221976	f705565f4b2d42bb8ae252d7418395b9	18	f
val/dfl_loss	0.90055	1749980221976	f705565f4b2d42bb8ae252d7418395b9	18	f
lr/pg0	0.0009738614000000002	1749980306299	f705565f4b2d42bb8ae252d7418395b9	21	f
lr/pg1	0.0009738614000000002	1749980306299	f705565f4b2d42bb8ae252d7418395b9	21	f
lr/pg2	0.0009738614000000002	1749980306299	f705565f4b2d42bb8ae252d7418395b9	21	f
train/box_loss	0.61249	1749980306299	f705565f4b2d42bb8ae252d7418395b9	21	f
train/cls_loss	0.4669	1749980306299	f705565f4b2d42bb8ae252d7418395b9	21	f
train/dfl_loss	0.97467	1749980306299	f705565f4b2d42bb8ae252d7418395b9	21	f
lr/pg0	0.0010398746	1749980247312	f705565f4b2d42bb8ae252d7418395b9	19	f
lr/pg1	0.0010398746	1749980247312	f705565f4b2d42bb8ae252d7418395b9	19	f
lr/pg2	0.0010398746	1749980247312	f705565f4b2d42bb8ae252d7418395b9	19	f
train/box_loss	0.63755	1749980247312	f705565f4b2d42bb8ae252d7418395b9	19	f
train/cls_loss	0.47044	1749980247312	f705565f4b2d42bb8ae252d7418395b9	19	f
train/dfl_loss	0.9912	1749980247312	f705565f4b2d42bb8ae252d7418395b9	19	f
metrics/precisionB	0.98043	1749980310660	f705565f4b2d42bb8ae252d7418395b9	21	f
metrics/recallB	0.98138	1749980310660	f705565f4b2d42bb8ae252d7418395b9	21	f
metrics/mAP50B	0.98767	1749980310660	f705565f4b2d42bb8ae252d7418395b9	21	f
metrics/mAP50-95B	0.87971	1749980310660	f705565f4b2d42bb8ae252d7418395b9	21	f
val/box_loss	0.49349	1749980310660	f705565f4b2d42bb8ae252d7418395b9	21	f
val/cls_loss	0.32299	1749980310660	f705565f4b2d42bb8ae252d7418395b9	21	f
val/dfl_loss	0.89572	1749980310660	f705565f4b2d42bb8ae252d7418395b9	21	f
metrics/precisionB	0.99411	1749980251701	f705565f4b2d42bb8ae252d7418395b9	19	f
metrics/recallB	0.95808	1749980251701	f705565f4b2d42bb8ae252d7418395b9	19	f
metrics/mAP50B	0.98492	1749980251701	f705565f4b2d42bb8ae252d7418395b9	19	f
metrics/mAP50-95B	0.8711	1749980251701	f705565f4b2d42bb8ae252d7418395b9	19	f
val/box_loss	0.50153	1749980251701	f705565f4b2d42bb8ae252d7418395b9	19	f
val/cls_loss	0.3693	1749980251701	f705565f4b2d42bb8ae252d7418395b9	19	f
val/dfl_loss	0.89174	1749980251701	f705565f4b2d42bb8ae252d7418395b9	19	f
lr/pg0	0.001006868	1749980277040	f705565f4b2d42bb8ae252d7418395b9	20	f
lr/pg1	0.001006868	1749980277040	f705565f4b2d42bb8ae252d7418395b9	20	f
lr/pg2	0.001006868	1749980277040	f705565f4b2d42bb8ae252d7418395b9	20	f
train/box_loss	0.63241	1749980277040	f705565f4b2d42bb8ae252d7418395b9	20	f
train/cls_loss	0.47168	1749980277040	f705565f4b2d42bb8ae252d7418395b9	20	f
train/dfl_loss	0.99494	1749980277040	f705565f4b2d42bb8ae252d7418395b9	20	f
metrics/precisionB	0.98839	1749980281498	f705565f4b2d42bb8ae252d7418395b9	20	f
metrics/recallB	0.97566	1749980281498	f705565f4b2d42bb8ae252d7418395b9	20	f
metrics/mAP50B	0.98555	1749980281498	f705565f4b2d42bb8ae252d7418395b9	20	f
metrics/mAP50-95B	0.86909	1749980281498	f705565f4b2d42bb8ae252d7418395b9	20	f
val/box_loss	0.51337	1749980281498	f705565f4b2d42bb8ae252d7418395b9	20	f
val/cls_loss	0.40274	1749980281498	f705565f4b2d42bb8ae252d7418395b9	20	f
val/dfl_loss	0.90034	1749980281498	f705565f4b2d42bb8ae252d7418395b9	20	f
lr/pg0	0.0009408548	1749980337512	f705565f4b2d42bb8ae252d7418395b9	22	f
lr/pg1	0.0009408548	1749980337512	f705565f4b2d42bb8ae252d7418395b9	22	f
lr/pg2	0.0009408548	1749980337512	f705565f4b2d42bb8ae252d7418395b9	22	f
train/box_loss	0.60786	1749980337512	f705565f4b2d42bb8ae252d7418395b9	22	f
train/cls_loss	0.44021	1749980337512	f705565f4b2d42bb8ae252d7418395b9	22	f
train/dfl_loss	0.97478	1749980337512	f705565f4b2d42bb8ae252d7418395b9	22	f
metrics/precisionB	0.99637	1749980342309	f705565f4b2d42bb8ae252d7418395b9	22	f
metrics/recallB	0.97403	1749980342309	f705565f4b2d42bb8ae252d7418395b9	22	f
metrics/mAP50B	0.98879	1749980342309	f705565f4b2d42bb8ae252d7418395b9	22	f
metrics/mAP50-95B	0.87029	1749980342309	f705565f4b2d42bb8ae252d7418395b9	22	f
val/box_loss	0.51881	1749980342309	f705565f4b2d42bb8ae252d7418395b9	22	f
val/cls_loss	0.33664	1749980342309	f705565f4b2d42bb8ae252d7418395b9	22	f
val/dfl_loss	0.91583	1749980342309	f705565f4b2d42bb8ae252d7418395b9	22	f
lr/pg0	0.0009078482000000002	1749980368402	f705565f4b2d42bb8ae252d7418395b9	23	f
lr/pg1	0.0009078482000000002	1749980368402	f705565f4b2d42bb8ae252d7418395b9	23	f
lr/pg2	0.0009078482000000002	1749980368402	f705565f4b2d42bb8ae252d7418395b9	23	f
train/box_loss	0.61856	1749980368402	f705565f4b2d42bb8ae252d7418395b9	23	f
train/cls_loss	0.45322	1749980368402	f705565f4b2d42bb8ae252d7418395b9	23	f
train/dfl_loss	0.98797	1749980368402	f705565f4b2d42bb8ae252d7418395b9	23	f
metrics/precisionB	0.98625	1749980372835	f705565f4b2d42bb8ae252d7418395b9	23	f
metrics/recallB	0.98424	1749980372835	f705565f4b2d42bb8ae252d7418395b9	23	f
metrics/mAP50B	0.99061	1749980372835	f705565f4b2d42bb8ae252d7418395b9	23	f
metrics/mAP50-95B	0.88104	1749980372835	f705565f4b2d42bb8ae252d7418395b9	23	f
val/box_loss	0.47938	1749980372835	f705565f4b2d42bb8ae252d7418395b9	23	f
val/cls_loss	0.31263	1749980372835	f705565f4b2d42bb8ae252d7418395b9	23	f
val/dfl_loss	0.88669	1749980372835	f705565f4b2d42bb8ae252d7418395b9	23	f
lr/pg0	0.0008748416000000001	1749980398310	f705565f4b2d42bb8ae252d7418395b9	24	f
lr/pg1	0.0008748416000000001	1749980398310	f705565f4b2d42bb8ae252d7418395b9	24	f
lr/pg2	0.0008748416000000001	1749980398310	f705565f4b2d42bb8ae252d7418395b9	24	f
train/box_loss	0.60086	1749980398310	f705565f4b2d42bb8ae252d7418395b9	24	f
train/cls_loss	0.4219	1749980398310	f705565f4b2d42bb8ae252d7418395b9	24	f
train/dfl_loss	0.97246	1749980398310	f705565f4b2d42bb8ae252d7418395b9	24	f
metrics/precisionB	0.99255	1749980403046	f705565f4b2d42bb8ae252d7418395b9	24	f
metrics/recallB	0.97928	1749980403046	f705565f4b2d42bb8ae252d7418395b9	24	f
metrics/mAP50B	0.98977	1749980403046	f705565f4b2d42bb8ae252d7418395b9	24	f
metrics/mAP50-95B	0.87395	1749980403046	f705565f4b2d42bb8ae252d7418395b9	24	f
val/box_loss	0.51355	1749980403046	f705565f4b2d42bb8ae252d7418395b9	24	f
val/cls_loss	0.31762	1749980403046	f705565f4b2d42bb8ae252d7418395b9	24	f
val/dfl_loss	0.89846	1749980403046	f705565f4b2d42bb8ae252d7418395b9	24	f
lr/pg0	0.0008418350000000001	1749980429918	f705565f4b2d42bb8ae252d7418395b9	25	f
lr/pg1	0.0008418350000000001	1749980429918	f705565f4b2d42bb8ae252d7418395b9	25	f
lr/pg2	0.0008418350000000001	1749980429918	f705565f4b2d42bb8ae252d7418395b9	25	f
train/box_loss	0.59122	1749980429918	f705565f4b2d42bb8ae252d7418395b9	25	f
train/cls_loss	0.42418	1749980429918	f705565f4b2d42bb8ae252d7418395b9	25	f
train/dfl_loss	0.96783	1749980429918	f705565f4b2d42bb8ae252d7418395b9	25	f
metrics/precisionB	0.98364	1749980434290	f705565f4b2d42bb8ae252d7418395b9	25	f
metrics/recallB	0.97921	1749980434290	f705565f4b2d42bb8ae252d7418395b9	25	f
metrics/mAP50B	0.9891	1749980434290	f705565f4b2d42bb8ae252d7418395b9	25	f
metrics/mAP50-95B	0.86826	1749980434290	f705565f4b2d42bb8ae252d7418395b9	25	f
val/box_loss	0.52368	1749980434290	f705565f4b2d42bb8ae252d7418395b9	25	f
val/cls_loss	0.31295	1749980434290	f705565f4b2d42bb8ae252d7418395b9	25	f
val/dfl_loss	0.92185	1749980434290	f705565f4b2d42bb8ae252d7418395b9	25	f
lr/pg0	0.0008088284	1749980460706	f705565f4b2d42bb8ae252d7418395b9	26	f
lr/pg1	0.0008088284	1749980460706	f705565f4b2d42bb8ae252d7418395b9	26	f
lr/pg2	0.0008088284	1749980460706	f705565f4b2d42bb8ae252d7418395b9	26	f
train/box_loss	0.59562	1749980460706	f705565f4b2d42bb8ae252d7418395b9	26	f
train/cls_loss	0.41484	1749980460706	f705565f4b2d42bb8ae252d7418395b9	26	f
train/dfl_loss	0.97017	1749980460706	f705565f4b2d42bb8ae252d7418395b9	26	f
metrics/precisionB	0.99297	1749980464972	f705565f4b2d42bb8ae252d7418395b9	26	f
metrics/recallB	0.98172	1749980464972	f705565f4b2d42bb8ae252d7418395b9	26	f
metrics/mAP50B	0.98826	1749980464972	f705565f4b2d42bb8ae252d7418395b9	26	f
metrics/mAP50-95B	0.89064	1749980464972	f705565f4b2d42bb8ae252d7418395b9	26	f
val/box_loss	0.50135	1749980464972	f705565f4b2d42bb8ae252d7418395b9	26	f
val/cls_loss	0.28348	1749980464972	f705565f4b2d42bb8ae252d7418395b9	26	f
val/dfl_loss	0.91316	1749980464972	f705565f4b2d42bb8ae252d7418395b9	26	f
lr/pg0	0.0007758218	1749980491086	f705565f4b2d42bb8ae252d7418395b9	27	f
lr/pg1	0.0007758218	1749980491086	f705565f4b2d42bb8ae252d7418395b9	27	f
lr/pg2	0.0007758218	1749980491086	f705565f4b2d42bb8ae252d7418395b9	27	f
train/box_loss	0.5914	1749980491086	f705565f4b2d42bb8ae252d7418395b9	27	f
train/cls_loss	0.4074	1749980491086	f705565f4b2d42bb8ae252d7418395b9	27	f
train/dfl_loss	0.97531	1749980491086	f705565f4b2d42bb8ae252d7418395b9	27	f
metrics/precisionB	0.99165	1749980495298	f705565f4b2d42bb8ae252d7418395b9	27	f
metrics/recallB	0.98138	1749980495298	f705565f4b2d42bb8ae252d7418395b9	27	f
metrics/mAP50B	0.98949	1749980495298	f705565f4b2d42bb8ae252d7418395b9	27	f
metrics/mAP50-95B	0.89329	1749980495298	f705565f4b2d42bb8ae252d7418395b9	27	f
val/box_loss	0.47089	1749980495298	f705565f4b2d42bb8ae252d7418395b9	27	f
val/cls_loss	0.28143	1749980495298	f705565f4b2d42bb8ae252d7418395b9	27	f
val/dfl_loss	0.8785	1749980495298	f705565f4b2d42bb8ae252d7418395b9	27	f
lr/pg0	0.0007428151999999999	1749980520957	f705565f4b2d42bb8ae252d7418395b9	28	f
lr/pg1	0.0007428151999999999	1749980520957	f705565f4b2d42bb8ae252d7418395b9	28	f
lr/pg2	0.0007428151999999999	1749980520957	f705565f4b2d42bb8ae252d7418395b9	28	f
train/box_loss	0.58801	1749980520957	f705565f4b2d42bb8ae252d7418395b9	28	f
train/cls_loss	0.40619	1749980520957	f705565f4b2d42bb8ae252d7418395b9	28	f
train/dfl_loss	0.97411	1749980520957	f705565f4b2d42bb8ae252d7418395b9	28	f
metrics/precisionB	0.98589	1749980525560	f705565f4b2d42bb8ae252d7418395b9	28	f
metrics/recallB	0.97887	1749980525560	f705565f4b2d42bb8ae252d7418395b9	28	f
metrics/mAP50B	0.98863	1749980525560	f705565f4b2d42bb8ae252d7418395b9	28	f
metrics/mAP50-95B	0.89071	1749980525560	f705565f4b2d42bb8ae252d7418395b9	28	f
val/box_loss	0.46617	1749980525560	f705565f4b2d42bb8ae252d7418395b9	28	f
val/cls_loss	0.28746	1749980525560	f705565f4b2d42bb8ae252d7418395b9	28	f
val/dfl_loss	0.87228	1749980525560	f705565f4b2d42bb8ae252d7418395b9	28	f
lr/pg0	0.0007098086000000001	1749980552545	f705565f4b2d42bb8ae252d7418395b9	29	f
lr/pg1	0.0007098086000000001	1749980552545	f705565f4b2d42bb8ae252d7418395b9	29	f
lr/pg2	0.0007098086000000001	1749980552545	f705565f4b2d42bb8ae252d7418395b9	29	f
train/box_loss	0.57461	1749980552545	f705565f4b2d42bb8ae252d7418395b9	29	f
train/cls_loss	0.40908	1749980552545	f705565f4b2d42bb8ae252d7418395b9	29	f
train/dfl_loss	0.96444	1749980552545	f705565f4b2d42bb8ae252d7418395b9	29	f
metrics/precisionB	0.98897	1749980556451	f705565f4b2d42bb8ae252d7418395b9	29	f
metrics/recallB	0.97887	1749980556451	f705565f4b2d42bb8ae252d7418395b9	29	f
metrics/mAP50B	0.98553	1749980556451	f705565f4b2d42bb8ae252d7418395b9	29	f
metrics/mAP50-95B	0.88033	1749980556451	f705565f4b2d42bb8ae252d7418395b9	29	f
val/box_loss	0.49669	1749980556451	f705565f4b2d42bb8ae252d7418395b9	29	f
val/cls_loss	0.29869	1749980556451	f705565f4b2d42bb8ae252d7418395b9	29	f
val/dfl_loss	0.89908	1749980556451	f705565f4b2d42bb8ae252d7418395b9	29	f
lr/pg0	0.0006768020000000001	1749980581542	f705565f4b2d42bb8ae252d7418395b9	30	f
lr/pg1	0.0006768020000000001	1749980581542	f705565f4b2d42bb8ae252d7418395b9	30	f
lr/pg2	0.0006768020000000001	1749980581542	f705565f4b2d42bb8ae252d7418395b9	30	f
train/box_loss	0.59605	1749980581542	f705565f4b2d42bb8ae252d7418395b9	30	f
train/cls_loss	0.4067	1749980581542	f705565f4b2d42bb8ae252d7418395b9	30	f
train/dfl_loss	0.97384	1749980581542	f705565f4b2d42bb8ae252d7418395b9	30	f
metrics/precisionB	0.98995	1749980585797	f705565f4b2d42bb8ae252d7418395b9	30	f
metrics/recallB	0.97064	1749980585797	f705565f4b2d42bb8ae252d7418395b9	30	f
metrics/mAP50B	0.98943	1749980585797	f705565f4b2d42bb8ae252d7418395b9	30	f
metrics/mAP50-95B	0.89862	1749980585797	f705565f4b2d42bb8ae252d7418395b9	30	f
val/box_loss	0.47948	1749980585797	f705565f4b2d42bb8ae252d7418395b9	30	f
val/cls_loss	0.29449	1749980585797	f705565f4b2d42bb8ae252d7418395b9	30	f
val/dfl_loss	0.89198	1749980585797	f705565f4b2d42bb8ae252d7418395b9	30	f
lr/pg0	0.0006437954	1749980610771	f705565f4b2d42bb8ae252d7418395b9	31	f
lr/pg1	0.0006437954	1749980610771	f705565f4b2d42bb8ae252d7418395b9	31	f
lr/pg2	0.0006437954	1749980610771	f705565f4b2d42bb8ae252d7418395b9	31	f
train/box_loss	0.55985	1749980610771	f705565f4b2d42bb8ae252d7418395b9	31	f
train/cls_loss	0.38607	1749980610771	f705565f4b2d42bb8ae252d7418395b9	31	f
train/dfl_loss	0.96413	1749980610771	f705565f4b2d42bb8ae252d7418395b9	31	f
metrics/precisionB	0.98709	1749980614715	f705565f4b2d42bb8ae252d7418395b9	31	f
metrics/recallB	0.98262	1749980614715	f705565f4b2d42bb8ae252d7418395b9	31	f
metrics/mAP50B	0.9914	1749980614715	f705565f4b2d42bb8ae252d7418395b9	31	f
metrics/mAP50-95B	0.89823	1749980614715	f705565f4b2d42bb8ae252d7418395b9	31	f
val/box_loss	0.46776	1749980614715	f705565f4b2d42bb8ae252d7418395b9	31	f
val/cls_loss	0.28284	1749980614715	f705565f4b2d42bb8ae252d7418395b9	31	f
val/dfl_loss	0.87607	1749980614715	f705565f4b2d42bb8ae252d7418395b9	31	f
lr/pg0	0.0006107888000000001	1749980638941	f705565f4b2d42bb8ae252d7418395b9	32	f
lr/pg1	0.0006107888000000001	1749980638941	f705565f4b2d42bb8ae252d7418395b9	32	f
lr/pg2	0.0006107888000000001	1749980638941	f705565f4b2d42bb8ae252d7418395b9	32	f
train/box_loss	0.55838	1749980638941	f705565f4b2d42bb8ae252d7418395b9	32	f
train/cls_loss	0.3796	1749980638941	f705565f4b2d42bb8ae252d7418395b9	32	f
train/dfl_loss	0.95907	1749980638941	f705565f4b2d42bb8ae252d7418395b9	32	f
metrics/precisionB	0.98422	1749980643033	f705565f4b2d42bb8ae252d7418395b9	32	f
metrics/recallB	0.98675	1749980643033	f705565f4b2d42bb8ae252d7418395b9	32	f
metrics/mAP50B	0.99055	1749980643033	f705565f4b2d42bb8ae252d7418395b9	32	f
metrics/mAP50-95B	0.89952	1749980643033	f705565f4b2d42bb8ae252d7418395b9	32	f
val/box_loss	0.46618	1749980643033	f705565f4b2d42bb8ae252d7418395b9	32	f
val/cls_loss	0.26663	1749980643033	f705565f4b2d42bb8ae252d7418395b9	32	f
val/dfl_loss	0.88133	1749980643033	f705565f4b2d42bb8ae252d7418395b9	32	f
metrics/precisionB	0.99067	1749980672394	f705565f4b2d42bb8ae252d7418395b9	33	f
metrics/recallB	0.98103	1749980672394	f705565f4b2d42bb8ae252d7418395b9	33	f
metrics/mAP50B	0.99037	1749980672394	f705565f4b2d42bb8ae252d7418395b9	33	f
metrics/mAP50-95B	0.89684	1749980672394	f705565f4b2d42bb8ae252d7418395b9	33	f
val/box_loss	0.44492	1749980672394	f705565f4b2d42bb8ae252d7418395b9	33	f
val/cls_loss	0.26593	1749980672394	f705565f4b2d42bb8ae252d7418395b9	33	f
val/dfl_loss	0.87499	1749980672394	f705565f4b2d42bb8ae252d7418395b9	33	f
lr/pg0	0.0005777822	1749980668109	f705565f4b2d42bb8ae252d7418395b9	33	f
lr/pg1	0.0005777822	1749980668109	f705565f4b2d42bb8ae252d7418395b9	33	f
lr/pg2	0.0005777822	1749980668109	f705565f4b2d42bb8ae252d7418395b9	33	f
train/box_loss	0.55812	1749980668109	f705565f4b2d42bb8ae252d7418395b9	33	f
train/cls_loss	0.37695	1749980668109	f705565f4b2d42bb8ae252d7418395b9	33	f
train/dfl_loss	0.95373	1749980668109	f705565f4b2d42bb8ae252d7418395b9	33	f
lr/pg0	0.0005117690000000001	1749980726028	f705565f4b2d42bb8ae252d7418395b9	35	f
lr/pg1	0.0005117690000000001	1749980726028	f705565f4b2d42bb8ae252d7418395b9	35	f
lr/pg2	0.0005117690000000001	1749980726028	f705565f4b2d42bb8ae252d7418395b9	35	f
train/box_loss	0.54746	1749980726028	f705565f4b2d42bb8ae252d7418395b9	35	f
train/cls_loss	0.37078	1749980726028	f705565f4b2d42bb8ae252d7418395b9	35	f
train/dfl_loss	0.95034	1749980726028	f705565f4b2d42bb8ae252d7418395b9	35	f
lr/pg0	0.0005447756	1749980697323	f705565f4b2d42bb8ae252d7418395b9	34	f
lr/pg1	0.0005447756	1749980697323	f705565f4b2d42bb8ae252d7418395b9	34	f
lr/pg2	0.0005447756	1749980697323	f705565f4b2d42bb8ae252d7418395b9	34	f
train/box_loss	0.54789	1749980697323	f705565f4b2d42bb8ae252d7418395b9	34	f
train/cls_loss	0.36556	1749980697323	f705565f4b2d42bb8ae252d7418395b9	34	f
train/dfl_loss	0.95272	1749980697323	f705565f4b2d42bb8ae252d7418395b9	34	f
metrics/precisionB	0.99842	1749980701382	f705565f4b2d42bb8ae252d7418395b9	34	f
metrics/recallB	0.98034	1749980701382	f705565f4b2d42bb8ae252d7418395b9	34	f
metrics/mAP50B	0.99223	1749980701382	f705565f4b2d42bb8ae252d7418395b9	34	f
metrics/mAP50-95B	0.90054	1749980701382	f705565f4b2d42bb8ae252d7418395b9	34	f
val/box_loss	0.47224	1749980701382	f705565f4b2d42bb8ae252d7418395b9	34	f
val/cls_loss	0.28104	1749980701382	f705565f4b2d42bb8ae252d7418395b9	34	f
val/dfl_loss	0.88016	1749980701382	f705565f4b2d42bb8ae252d7418395b9	34	f
metrics/precisionB	0.99188	1749980729969	f705565f4b2d42bb8ae252d7418395b9	35	f
metrics/recallB	0.98359	1749980729969	f705565f4b2d42bb8ae252d7418395b9	35	f
metrics/mAP50B	0.98958	1749980729969	f705565f4b2d42bb8ae252d7418395b9	35	f
metrics/mAP50-95B	0.90236	1749980729969	f705565f4b2d42bb8ae252d7418395b9	35	f
val/box_loss	0.44694	1749980729969	f705565f4b2d42bb8ae252d7418395b9	35	f
val/cls_loss	0.26929	1749980729969	f705565f4b2d42bb8ae252d7418395b9	35	f
val/dfl_loss	0.86447	1749980729969	f705565f4b2d42bb8ae252d7418395b9	35	f
lr/pg0	0.00047876240000000006	1749980754781	f705565f4b2d42bb8ae252d7418395b9	36	f
lr/pg1	0.00047876240000000006	1749980754781	f705565f4b2d42bb8ae252d7418395b9	36	f
lr/pg2	0.00047876240000000006	1749980754781	f705565f4b2d42bb8ae252d7418395b9	36	f
train/box_loss	0.54782	1749980754781	f705565f4b2d42bb8ae252d7418395b9	36	f
train/cls_loss	0.36085	1749980754781	f705565f4b2d42bb8ae252d7418395b9	36	f
train/dfl_loss	0.95726	1749980754781	f705565f4b2d42bb8ae252d7418395b9	36	f
metrics/precisionB	0.9963	1749980758686	f705565f4b2d42bb8ae252d7418395b9	36	f
metrics/recallB	0.97829	1749980758686	f705565f4b2d42bb8ae252d7418395b9	36	f
metrics/mAP50B	0.99079	1749980758686	f705565f4b2d42bb8ae252d7418395b9	36	f
metrics/mAP50-95B	0.90737	1749980758686	f705565f4b2d42bb8ae252d7418395b9	36	f
val/box_loss	0.45899	1749980758686	f705565f4b2d42bb8ae252d7418395b9	36	f
val/cls_loss	0.26865	1749980758686	f705565f4b2d42bb8ae252d7418395b9	36	f
val/dfl_loss	0.87936	1749980758686	f705565f4b2d42bb8ae252d7418395b9	36	f
lr/pg0	0.00044575580000000005	1749980784489	f705565f4b2d42bb8ae252d7418395b9	37	f
lr/pg1	0.00044575580000000005	1749980784489	f705565f4b2d42bb8ae252d7418395b9	37	f
lr/pg2	0.00044575580000000005	1749980784489	f705565f4b2d42bb8ae252d7418395b9	37	f
train/box_loss	0.53772	1749980784489	f705565f4b2d42bb8ae252d7418395b9	37	f
train/cls_loss	0.35633	1749980784489	f705565f4b2d42bb8ae252d7418395b9	37	f
train/dfl_loss	0.95033	1749980784489	f705565f4b2d42bb8ae252d7418395b9	37	f
metrics/precisionB	0.98619	1749980788668	f705565f4b2d42bb8ae252d7418395b9	37	f
metrics/recallB	0.98099	1749980788668	f705565f4b2d42bb8ae252d7418395b9	37	f
metrics/mAP50B	0.99064	1749980788668	f705565f4b2d42bb8ae252d7418395b9	37	f
metrics/mAP50-95B	0.91089	1749980788668	f705565f4b2d42bb8ae252d7418395b9	37	f
val/box_loss	0.44216	1749980788668	f705565f4b2d42bb8ae252d7418395b9	37	f
val/cls_loss	0.26104	1749980788668	f705565f4b2d42bb8ae252d7418395b9	37	f
val/dfl_loss	0.87358	1749980788668	f705565f4b2d42bb8ae252d7418395b9	37	f
lr/pg0	0.0004127492	1749980814045	f705565f4b2d42bb8ae252d7418395b9	38	f
lr/pg1	0.0004127492	1749980814045	f705565f4b2d42bb8ae252d7418395b9	38	f
lr/pg2	0.0004127492	1749980814045	f705565f4b2d42bb8ae252d7418395b9	38	f
train/box_loss	0.52378	1749980814045	f705565f4b2d42bb8ae252d7418395b9	38	f
train/cls_loss	0.35672	1749980814045	f705565f4b2d42bb8ae252d7418395b9	38	f
train/dfl_loss	0.94392	1749980814045	f705565f4b2d42bb8ae252d7418395b9	38	f
metrics/precisionB	0.99676	1749980818287	f705565f4b2d42bb8ae252d7418395b9	38	f
metrics/recallB	0.98424	1749980818287	f705565f4b2d42bb8ae252d7418395b9	38	f
metrics/mAP50B	0.99117	1749980818287	f705565f4b2d42bb8ae252d7418395b9	38	f
metrics/mAP50-95B	0.91318	1749980818287	f705565f4b2d42bb8ae252d7418395b9	38	f
val/box_loss	0.43919	1749980818287	f705565f4b2d42bb8ae252d7418395b9	38	f
val/cls_loss	0.24247	1749980818287	f705565f4b2d42bb8ae252d7418395b9	38	f
val/dfl_loss	0.87395	1749980818287	f705565f4b2d42bb8ae252d7418395b9	38	f
lr/pg0	0.00037974259999999996	1749980844370	f705565f4b2d42bb8ae252d7418395b9	39	f
lr/pg1	0.00037974259999999996	1749980844370	f705565f4b2d42bb8ae252d7418395b9	39	f
lr/pg2	0.00037974259999999996	1749980844370	f705565f4b2d42bb8ae252d7418395b9	39	f
train/box_loss	0.53788	1749980844370	f705565f4b2d42bb8ae252d7418395b9	39	f
train/cls_loss	0.35333	1749980844370	f705565f4b2d42bb8ae252d7418395b9	39	f
train/dfl_loss	0.96227	1749980844370	f705565f4b2d42bb8ae252d7418395b9	39	f
metrics/precisionB	0.99449	1749980848907	f705565f4b2d42bb8ae252d7418395b9	39	f
metrics/recallB	0.98664	1749980848907	f705565f4b2d42bb8ae252d7418395b9	39	f
metrics/mAP50B	0.99127	1749980848907	f705565f4b2d42bb8ae252d7418395b9	39	f
metrics/mAP50-95B	0.90876	1749980848907	f705565f4b2d42bb8ae252d7418395b9	39	f
val/box_loss	0.43963	1749980848907	f705565f4b2d42bb8ae252d7418395b9	39	f
val/cls_loss	0.24171	1749980848907	f705565f4b2d42bb8ae252d7418395b9	39	f
val/dfl_loss	0.86603	1749980848907	f705565f4b2d42bb8ae252d7418395b9	39	f
lr/pg0	0.00034673599999999994	1749980872384	f705565f4b2d42bb8ae252d7418395b9	40	f
lr/pg1	0.00034673599999999994	1749980872384	f705565f4b2d42bb8ae252d7418395b9	40	f
lr/pg2	0.00034673599999999994	1749980872384	f705565f4b2d42bb8ae252d7418395b9	40	f
train/box_loss	0.43784	1749980872384	f705565f4b2d42bb8ae252d7418395b9	40	f
train/cls_loss	0.28567	1749980872384	f705565f4b2d42bb8ae252d7418395b9	40	f
train/dfl_loss	0.90479	1749980872384	f705565f4b2d42bb8ae252d7418395b9	40	f
metrics/precisionB	0.9934	1749980876436	f705565f4b2d42bb8ae252d7418395b9	40	f
metrics/recallB	0.98629	1749980876436	f705565f4b2d42bb8ae252d7418395b9	40	f
metrics/mAP50B	0.99089	1749980876436	f705565f4b2d42bb8ae252d7418395b9	40	f
metrics/mAP50-95B	0.91404	1749980876436	f705565f4b2d42bb8ae252d7418395b9	40	f
val/box_loss	0.42191	1749980876436	f705565f4b2d42bb8ae252d7418395b9	40	f
val/cls_loss	0.23475	1749980876436	f705565f4b2d42bb8ae252d7418395b9	40	f
val/dfl_loss	0.85429	1749980876436	f705565f4b2d42bb8ae252d7418395b9	40	f
lr/pg0	0.00031372940000000014	1749980899749	f705565f4b2d42bb8ae252d7418395b9	41	f
lr/pg1	0.00031372940000000014	1749980899749	f705565f4b2d42bb8ae252d7418395b9	41	f
lr/pg2	0.00031372940000000014	1749980899749	f705565f4b2d42bb8ae252d7418395b9	41	f
train/box_loss	0.43225	1749980899749	f705565f4b2d42bb8ae252d7418395b9	41	f
train/cls_loss	0.2815	1749980899749	f705565f4b2d42bb8ae252d7418395b9	41	f
train/dfl_loss	0.90286	1749980899749	f705565f4b2d42bb8ae252d7418395b9	41	f
metrics/precisionB	0.98916	1749980903878	f705565f4b2d42bb8ae252d7418395b9	41	f
metrics/recallB	0.98172	1749980903878	f705565f4b2d42bb8ae252d7418395b9	41	f
metrics/mAP50B	0.99133	1749980903878	f705565f4b2d42bb8ae252d7418395b9	41	f
metrics/mAP50-95B	0.91005	1749980903878	f705565f4b2d42bb8ae252d7418395b9	41	f
val/box_loss	0.44879	1749980903878	f705565f4b2d42bb8ae252d7418395b9	41	f
val/cls_loss	0.23594	1749980903878	f705565f4b2d42bb8ae252d7418395b9	41	f
val/dfl_loss	0.87821	1749980903878	f705565f4b2d42bb8ae252d7418395b9	41	f
metrics/precisionB	0.9912	1749980931535	f705565f4b2d42bb8ae252d7418395b9	42	f
metrics/recallB	0.98961	1749980931535	f705565f4b2d42bb8ae252d7418395b9	42	f
metrics/mAP50B	0.99114	1749980931535	f705565f4b2d42bb8ae252d7418395b9	42	f
metrics/mAP50-95B	0.9072	1749980931535	f705565f4b2d42bb8ae252d7418395b9	42	f
val/box_loss	0.45476	1749980931535	f705565f4b2d42bb8ae252d7418395b9	42	f
val/cls_loss	0.25045	1749980931535	f705565f4b2d42bb8ae252d7418395b9	42	f
val/dfl_loss	0.88134	1749980931535	f705565f4b2d42bb8ae252d7418395b9	42	f
lr/pg0	0.0002147096	1749980982923	f705565f4b2d42bb8ae252d7418395b9	44	f
lr/pg1	0.0002147096	1749980982923	f705565f4b2d42bb8ae252d7418395b9	44	f
lr/pg2	0.0002147096	1749980982923	f705565f4b2d42bb8ae252d7418395b9	44	f
train/box_loss	0.41892	1749980982923	f705565f4b2d42bb8ae252d7418395b9	44	f
train/cls_loss	0.26596	1749980982923	f705565f4b2d42bb8ae252d7418395b9	44	f
train/dfl_loss	0.88943	1749980982923	f705565f4b2d42bb8ae252d7418395b9	44	f
metrics/precisionB	0.99217	1749980987580	f705565f4b2d42bb8ae252d7418395b9	44	f
metrics/recallB	0.98816	1749980987580	f705565f4b2d42bb8ae252d7418395b9	44	f
metrics/mAP50B	0.99139	1749980987580	f705565f4b2d42bb8ae252d7418395b9	44	f
metrics/mAP50-95B	0.92111	1749980987580	f705565f4b2d42bb8ae252d7418395b9	44	f
val/box_loss	0.41533	1749980987580	f705565f4b2d42bb8ae252d7418395b9	44	f
val/cls_loss	0.22883	1749980987580	f705565f4b2d42bb8ae252d7418395b9	44	f
val/dfl_loss	0.85831	1749980987580	f705565f4b2d42bb8ae252d7418395b9	44	f
lr/pg0	0.00028072280000000007	1749980927560	f705565f4b2d42bb8ae252d7418395b9	42	f
lr/pg1	0.00028072280000000007	1749980927560	f705565f4b2d42bb8ae252d7418395b9	42	f
lr/pg2	0.00028072280000000007	1749980927560	f705565f4b2d42bb8ae252d7418395b9	42	f
train/box_loss	0.41463	1749980927560	f705565f4b2d42bb8ae252d7418395b9	42	f
train/cls_loss	0.2736	1749980927560	f705565f4b2d42bb8ae252d7418395b9	42	f
train/dfl_loss	0.89582	1749980927560	f705565f4b2d42bb8ae252d7418395b9	42	f
lr/pg0	0.00024771620000000005	1749980954967	f705565f4b2d42bb8ae252d7418395b9	43	f
lr/pg1	0.00024771620000000005	1749980954967	f705565f4b2d42bb8ae252d7418395b9	43	f
lr/pg2	0.00024771620000000005	1749980954967	f705565f4b2d42bb8ae252d7418395b9	43	f
train/box_loss	0.42428	1749980954967	f705565f4b2d42bb8ae252d7418395b9	43	f
train/cls_loss	0.26915	1749980954967	f705565f4b2d42bb8ae252d7418395b9	43	f
train/dfl_loss	0.89315	1749980954967	f705565f4b2d42bb8ae252d7418395b9	43	f
metrics/precisionB	0.9938	1749980958925	f705565f4b2d42bb8ae252d7418395b9	43	f
metrics/recallB	0.98921	1749980958925	f705565f4b2d42bb8ae252d7418395b9	43	f
metrics/mAP50B	0.99159	1749980958925	f705565f4b2d42bb8ae252d7418395b9	43	f
metrics/mAP50-95B	0.91831	1749980958925	f705565f4b2d42bb8ae252d7418395b9	43	f
val/box_loss	0.41624	1749980958925	f705565f4b2d42bb8ae252d7418395b9	43	f
val/cls_loss	0.22734	1749980958925	f705565f4b2d42bb8ae252d7418395b9	43	f
val/dfl_loss	0.86022	1749980958925	f705565f4b2d42bb8ae252d7418395b9	43	f
lr/pg0	0.00018170299999999996	1749981010922	f705565f4b2d42bb8ae252d7418395b9	45	f
lr/pg1	0.00018170299999999996	1749981010922	f705565f4b2d42bb8ae252d7418395b9	45	f
lr/pg2	0.00018170299999999996	1749981010922	f705565f4b2d42bb8ae252d7418395b9	45	f
train/box_loss	0.40512	1749981010922	f705565f4b2d42bb8ae252d7418395b9	45	f
train/cls_loss	0.26118	1749981010922	f705565f4b2d42bb8ae252d7418395b9	45	f
train/dfl_loss	0.89112	1749981010922	f705565f4b2d42bb8ae252d7418395b9	45	f
metrics/precisionB	0.9943	1749981014985	f705565f4b2d42bb8ae252d7418395b9	45	f
metrics/recallB	0.98675	1749981014985	f705565f4b2d42bb8ae252d7418395b9	45	f
metrics/mAP50B	0.99109	1749981014985	f705565f4b2d42bb8ae252d7418395b9	45	f
metrics/mAP50-95B	0.91888	1749981014985	f705565f4b2d42bb8ae252d7418395b9	45	f
val/box_loss	0.42223	1749981014985	f705565f4b2d42bb8ae252d7418395b9	45	f
val/cls_loss	0.22873	1749981014985	f705565f4b2d42bb8ae252d7418395b9	45	f
val/dfl_loss	0.86512	1749981014985	f705565f4b2d42bb8ae252d7418395b9	45	f
lr/pg0	0.00014869639999999995	1749981038731	f705565f4b2d42bb8ae252d7418395b9	46	f
lr/pg1	0.00014869639999999995	1749981038731	f705565f4b2d42bb8ae252d7418395b9	46	f
lr/pg2	0.00014869639999999995	1749981038731	f705565f4b2d42bb8ae252d7418395b9	46	f
train/box_loss	0.40584	1749981038731	f705565f4b2d42bb8ae252d7418395b9	46	f
train/cls_loss	0.25227	1749981038731	f705565f4b2d42bb8ae252d7418395b9	46	f
train/dfl_loss	0.89186	1749981038731	f705565f4b2d42bb8ae252d7418395b9	46	f
metrics/precisionB	0.99446	1749981042672	f705565f4b2d42bb8ae252d7418395b9	46	f
metrics/recallB	0.98366	1749981042672	f705565f4b2d42bb8ae252d7418395b9	46	f
metrics/mAP50B	0.99157	1749981042672	f705565f4b2d42bb8ae252d7418395b9	46	f
metrics/mAP50-95B	0.91915	1749981042672	f705565f4b2d42bb8ae252d7418395b9	46	f
val/box_loss	0.41914	1749981042672	f705565f4b2d42bb8ae252d7418395b9	46	f
val/cls_loss	0.22393	1749981042672	f705565f4b2d42bb8ae252d7418395b9	46	f
val/dfl_loss	0.86335	1749981042672	f705565f4b2d42bb8ae252d7418395b9	46	f
lr/pg0	0.00011568980000000008	1749981066642	f705565f4b2d42bb8ae252d7418395b9	47	f
lr/pg1	0.00011568980000000008	1749981066642	f705565f4b2d42bb8ae252d7418395b9	47	f
lr/pg2	0.00011568980000000008	1749981066642	f705565f4b2d42bb8ae252d7418395b9	47	f
train/box_loss	0.3959	1749981066642	f705565f4b2d42bb8ae252d7418395b9	47	f
train/cls_loss	0.24539	1749981066642	f705565f4b2d42bb8ae252d7418395b9	47	f
train/dfl_loss	0.88233	1749981066642	f705565f4b2d42bb8ae252d7418395b9	47	f
metrics/precisionB	0.99689	1749981070699	f705565f4b2d42bb8ae252d7418395b9	47	f
metrics/recallB	0.98341	1749981070699	f705565f4b2d42bb8ae252d7418395b9	47	f
metrics/mAP50B	0.99174	1749981070699	f705565f4b2d42bb8ae252d7418395b9	47	f
metrics/mAP50-95B	0.91781	1749981070699	f705565f4b2d42bb8ae252d7418395b9	47	f
val/box_loss	0.41233	1749981070699	f705565f4b2d42bb8ae252d7418395b9	47	f
val/cls_loss	0.2191	1749981070699	f705565f4b2d42bb8ae252d7418395b9	47	f
val/dfl_loss	0.85442	1749981070699	f705565f4b2d42bb8ae252d7418395b9	47	f
lr/pg0	8.268320000000008e-05	1749981094865	f705565f4b2d42bb8ae252d7418395b9	48	f
lr/pg1	8.268320000000008e-05	1749981094865	f705565f4b2d42bb8ae252d7418395b9	48	f
lr/pg2	8.268320000000008e-05	1749981094865	f705565f4b2d42bb8ae252d7418395b9	48	f
train/box_loss	0.39977	1749981094865	f705565f4b2d42bb8ae252d7418395b9	48	f
train/cls_loss	0.24344	1749981094865	f705565f4b2d42bb8ae252d7418395b9	48	f
train/dfl_loss	0.88301	1749981094865	f705565f4b2d42bb8ae252d7418395b9	48	f
metrics/precisionB	0.99272	1749981099353	f705565f4b2d42bb8ae252d7418395b9	48	f
metrics/recallB	0.98675	1749981099353	f705565f4b2d42bb8ae252d7418395b9	48	f
metrics/mAP50B	0.99136	1749981099353	f705565f4b2d42bb8ae252d7418395b9	48	f
metrics/mAP50-95B	0.92171	1749981099353	f705565f4b2d42bb8ae252d7418395b9	48	f
val/box_loss	0.41061	1749981099353	f705565f4b2d42bb8ae252d7418395b9	48	f
val/cls_loss	0.21904	1749981099353	f705565f4b2d42bb8ae252d7418395b9	48	f
val/dfl_loss	0.85838	1749981099353	f705565f4b2d42bb8ae252d7418395b9	48	f
lr/pg0	4.967660000000004e-05	1749981124303	f705565f4b2d42bb8ae252d7418395b9	49	f
lr/pg1	4.967660000000004e-05	1749981124303	f705565f4b2d42bb8ae252d7418395b9	49	f
lr/pg2	4.967660000000004e-05	1749981124303	f705565f4b2d42bb8ae252d7418395b9	49	f
train/box_loss	0.38764	1749981124303	f705565f4b2d42bb8ae252d7418395b9	49	f
train/cls_loss	0.2417	1749981124303	f705565f4b2d42bb8ae252d7418395b9	49	f
train/dfl_loss	0.87264	1749981124303	f705565f4b2d42bb8ae252d7418395b9	49	f
metrics/precisionB	0.99377	1749981129283	f705565f4b2d42bb8ae252d7418395b9	49	f
metrics/recallB	0.98644	1749981129283	f705565f4b2d42bb8ae252d7418395b9	49	f
metrics/mAP50B	0.99127	1749981129283	f705565f4b2d42bb8ae252d7418395b9	49	f
metrics/mAP50-95B	0.92365	1749981129283	f705565f4b2d42bb8ae252d7418395b9	49	f
val/box_loss	0.40873	1749981129283	f705565f4b2d42bb8ae252d7418395b9	49	f
val/cls_loss	0.21555	1749981129283	f705565f4b2d42bb8ae252d7418395b9	49	f
val/dfl_loss	0.8571	1749981129283	f705565f4b2d42bb8ae252d7418395b9	49	f
metrics/precisionB	0.9937620578788806	1749981137063	f705565f4b2d42bb8ae252d7418395b9	49	f
metrics/recallB	0.9865610567494989	1749981137063	f705565f4b2d42bb8ae252d7418395b9	49	f
metrics/mAP50B	0.9912723183433296	1749981137063	f705565f4b2d42bb8ae252d7418395b9	49	f
metrics/mAP50-95B	0.9247510121650903	1749981137063	f705565f4b2d42bb8ae252d7418395b9	49	f
lr/pg0	0.0005471179487179488	1750053501862	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
lr/pg1	0.0005471179487179488	1750053501862	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
lr/pg2	0.0005471179487179488	1750053501862	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
train/box_loss	0.87696	1750053501862	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
train/cls_loss	1.84732	1750053501862	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
train/dfl_loss	1.13803	1750053501862	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
metrics/precisionB	0.93318	1750053508841	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
metrics/recallB	0.76143	1750053508841	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
metrics/mAP50B	0.9187	1750053508841	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
metrics/mAP50-95B	0.73903	1750053508841	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
val/box_loss	0.72112	1750053508841	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
val/cls_loss	1.596	1750053508841	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
val/dfl_loss	1.06067	1750053508841	90bbefe9b36e454fa0aef6fd8c8ef496	0	f
train_loss	0.8865105457834583	1750053705768	3490d112ca844a5397c0101acceb73b4	0	f
train_acc	0.5889128869690424	1750053705819	3490d112ca844a5397c0101acceb73b4	0	f
val_loss	0.6147527454913347	1750053709181	3490d112ca844a5397c0101acceb73b4	0	f
val_acc	0.7126436781609196	1750053709224	3490d112ca844a5397c0101acceb73b4	0	f
train_loss	0.6042784921894664	1750053723557	3490d112ca844a5397c0101acceb73b4	1	f
train_acc	0.7544996400287977	1750053723621	3490d112ca844a5397c0101acceb73b4	1	f
val_loss	0.4058256731636223	1750053725902	3490d112ca844a5397c0101acceb73b4	1	f
val_acc	0.8477011494252873	1750053725946	3490d112ca844a5397c0101acceb73b4	1	f
train_loss	0.5181025295827438	1750053739268	3490d112ca844a5397c0101acceb73b4	2	f
train_acc	0.7804175665946724	1750053739318	3490d112ca844a5397c0101acceb73b4	2	f
val_loss	0.36390832614624635	1750053741345	3490d112ca844a5397c0101acceb73b4	2	f
val_acc	0.8620689655172413	1750053741391	3490d112ca844a5397c0101acceb73b4	2	f
train_loss	0.48931282923923625	1750053754548	3490d112ca844a5397c0101acceb73b4	3	f
train_acc	0.8020158387329014	1750053754622	3490d112ca844a5397c0101acceb73b4	3	f
val_loss	0.3214672226672885	1750053756729	3490d112ca844a5397c0101acceb73b4	3	f
val_acc	0.8908045977011494	1750053756786	3490d112ca844a5397c0101acceb73b4	3	f
train_loss	0.4399900010286088	1750053770381	3490d112ca844a5397c0101acceb73b4	4	f
train_acc	0.8106551475881929	1750053770437	3490d112ca844a5397c0101acceb73b4	4	f
val_loss	0.30076382009462377	1750053772526	3490d112ca844a5397c0101acceb73b4	4	f
val_acc	0.8793103448275862	1750053772573	3490d112ca844a5397c0101acceb73b4	4	f
train_loss	0.4156629762004141	1750053778841	3490d112ca844a5397c0101acceb73b4	5	f
train_acc	0.83585313174946	1750053778889	3490d112ca844a5397c0101acceb73b4	5	f
val_loss	0.26309844988516007	1750053780960	3490d112ca844a5397c0101acceb73b4	5	f
val_acc	0.9022988505747126	1750053781005	3490d112ca844a5397c0101acceb73b4	5	f
train_loss	0.4051222095092996	1750053793526	3490d112ca844a5397c0101acceb73b4	6	f
train_acc	0.843772498200144	1750053793571	3490d112ca844a5397c0101acceb73b4	6	f
val_loss	0.31100717666505395	1750053795544	3490d112ca844a5397c0101acceb73b4	6	f
val_acc	0.882183908045977	1750053795588	3490d112ca844a5397c0101acceb73b4	6	f
train_loss	0.3527471844544078	1750053802026	3490d112ca844a5397c0101acceb73b4	7	f
train_acc	0.8567314614830813	1750053802069	3490d112ca844a5397c0101acceb73b4	7	f
val_loss	0.2619470972781894	1750053804072	3490d112ca844a5397c0101acceb73b4	7	f
val_acc	0.9051724137931034	1750053804117	3490d112ca844a5397c0101acceb73b4	7	f
train_loss	0.3717244875954586	1750053816937	3490d112ca844a5397c0101acceb73b4	8	f
train_acc	0.8459323254139669	1750053816982	3490d112ca844a5397c0101acceb73b4	8	f
val_loss	0.24693002783018966	1750053818997	3490d112ca844a5397c0101acceb73b4	8	f
val_acc	0.9195402298850575	1750053819042	3490d112ca844a5397c0101acceb73b4	8	f
train_loss	0.3499487141768138	1750053831534	3490d112ca844a5397c0101acceb73b4	9	f
train_acc	0.8603311735061194	1750053831588	3490d112ca844a5397c0101acceb73b4	9	f
val_loss	0.23644955113701438	1750053833636	3490d112ca844a5397c0101acceb73b4	9	f
val_acc	0.9224137931034483	1750053833684	3490d112ca844a5397c0101acceb73b4	9	f
train_loss	0.3271268329618645	1750053846231	3490d112ca844a5397c0101acceb73b4	10	f
train_acc	0.8617710583153347	1750053846277	3490d112ca844a5397c0101acceb73b4	10	f
val_loss	0.266528042911113	1750053848392	3490d112ca844a5397c0101acceb73b4	10	f
val_acc	0.9137931034482758	1750053848440	3490d112ca844a5397c0101acceb73b4	10	f
train_loss	0.36828697822006423	1750053854999	3490d112ca844a5397c0101acceb73b4	11	f
train_acc	0.8538516918646508	1750053855045	3490d112ca844a5397c0101acceb73b4	11	f
val_loss	0.2119988583285233	1750053857071	3490d112ca844a5397c0101acceb73b4	11	f
train_loss	0.3530642364504013	1750053870093	3490d112ca844a5397c0101acceb73b4	12	f
val_acc	0.8764367816091954	1750053880945	3490d112ca844a5397c0101acceb73b4	13	f
train_acc	0.8747300215982721	1750053887645	3490d112ca844a5397c0101acceb73b4	14	f
val_loss	0.18780673038342904	1750053916502	3490d112ca844a5397c0101acceb73b4	17	f
train_loss	0.3144754758728246	1750053929490	3490d112ca844a5397c0101acceb73b4	18	f
train_loss	0.2537989682263827	1750053982167	3490d112ca844a5397c0101acceb73b4	24	f
val_acc	0.9540229885057471	1750053984315	3490d112ca844a5397c0101acceb73b4	24	f
val_acc	0.9367816091954023	1750053857116	3490d112ca844a5397c0101acceb73b4	11	f
train_loss	0.33868821485596995	1750053878821	3490d112ca844a5397c0101acceb73b4	13	f
val_acc	0.8994252873563219	1750053898818	3490d112ca844a5397c0101acceb73b4	15	f
train_acc	0.9006479481641468	1750053914455	3490d112ca844a5397c0101acceb73b4	17	f
val_acc	0.939655172413793	1750053916550	3490d112ca844a5397c0101acceb73b4	17	f
train_acc	0.8812095032397408	1750053938618	3490d112ca844a5397c0101acceb73b4	19	f
val_acc	0.9224137931034483	1750053940664	3490d112ca844a5397c0101acceb73b4	19	f
train_acc	0.8970482361411086	1750053964633	3490d112ca844a5397c0101acceb73b4	22	f
val_acc	0.9195402298850575	1750053966666	3490d112ca844a5397c0101acceb73b4	22	f
val_loss	0.1826402660159544	1750053975556	3490d112ca844a5397c0101acceb73b4	23	f
train_acc	0.855291576673866	1750053870144	3490d112ca844a5397c0101acceb73b4	12	f
train_acc	0.8610511159107271	1750053878866	3490d112ca844a5397c0101acceb73b4	13	f
val_loss	0.25694248148764687	1750053898770	3490d112ca844a5397c0101acceb73b4	15	f
train_loss	0.2698198112547183	1750053914406	3490d112ca844a5397c0101acceb73b4	17	f
train_loss	0.2935822989719218	1750053938569	3490d112ca844a5397c0101acceb73b4	19	f
val_loss	0.22848283799215294	1750053940619	3490d112ca844a5397c0101acceb73b4	19	f
train_loss	0.27384513725987264	1750053964585	3490d112ca844a5397c0101acceb73b4	22	f
val_loss	0.22043436945512376	1750053966620	3490d112ca844a5397c0101acceb73b4	22	f
train_acc	0.9035277177825773	1750053973592	3490d112ca844a5397c0101acceb73b4	23	f
val_acc	0.939655172413793	1750053975605	3490d112ca844a5397c0101acceb73b4	23	f
val_loss	0.21300375752750483	1750053872213	3490d112ca844a5397c0101acceb73b4	12	f
val_loss	0.2509020352843164	1750053889777	3490d112ca844a5397c0101acceb73b4	14	f
train_acc	0.8783297336213103	1750053896710	3490d112ca844a5397c0101acceb73b4	15	f
train_acc	0.8855291576673866	1750053905389	3490d112ca844a5397c0101acceb73b4	16	f
val_acc	0.9080459770114943	1750053907683	3490d112ca844a5397c0101acceb73b4	16	f
val_loss	0.21854976042248736	1750053931582	3490d112ca844a5397c0101acceb73b4	18	f
train_loss	0.26841650762688435	1750053947380	3490d112ca844a5397c0101acceb73b4	20	f
val_loss	0.21536464963493676	1750053949460	3490d112ca844a5397c0101acceb73b4	20	f
train_loss	0.24600390940797337	1750053955965	3490d112ca844a5397c0101acceb73b4	21	f
val_loss	0.21409599405938182	1750053958056	3490d112ca844a5397c0101acceb73b4	21	f
val_acc	0.9281609195402298	1750053872259	3490d112ca844a5397c0101acceb73b4	12	f
train_loss	0.307869308335134	1750053896658	3490d112ca844a5397c0101acceb73b4	15	f
train_loss	0.28924578108574694	1750053905342	3490d112ca844a5397c0101acceb73b4	16	f
val_acc	0.9339080459770115	1750053931628	3490d112ca844a5397c0101acceb73b4	18	f
train_acc	0.9028077753779697	1750053947425	3490d112ca844a5397c0101acceb73b4	20	f
val_acc	0.9339080459770115	1750053949506	3490d112ca844a5397c0101acceb73b4	20	f
train_acc	0.9078473722102232	1750053956012	3490d112ca844a5397c0101acceb73b4	21	f
val_acc	0.9339080459770115	1750053958100	3490d112ca844a5397c0101acceb73b4	21	f
val_loss	0.3603094497631336	1750053880894	3490d112ca844a5397c0101acceb73b4	13	f
train_loss	0.313055685392123	1750053887596	3490d112ca844a5397c0101acceb73b4	14	f
val_acc	0.9109195402298851	1750053889830	3490d112ca844a5397c0101acceb73b4	14	f
train_acc	0.8761699064074874	1750053929536	3490d112ca844a5397c0101acceb73b4	18	f
train_acc	0.9028077753779697	1750053982212	3490d112ca844a5397c0101acceb73b4	24	f
val_loss	0.15882891720567627	1750053984268	3490d112ca844a5397c0101acceb73b4	24	f
val_loss	0.2548679954361642	1750053907632	3490d112ca844a5397c0101acceb73b4	16	f
train_loss	0.25133485670481076	1750053973542	3490d112ca844a5397c0101acceb73b4	23	f
train_loss	0.7659019036949678	1750061898831	0c9be4ca093540d4ae9936b23e0ffec6	0	f
train_acc	0.6370656370656371	1750061898893	0c9be4ca093540d4ae9936b23e0ffec6	0	f
val_loss	0.46171099305357366	1750061903677	0c9be4ca093540d4ae9936b23e0ffec6	0	f
val_acc	0.8181818181818181	1750061903727	0c9be4ca093540d4ae9936b23e0ffec6	0	f
train_loss	0.5277357694418428	1750061921806	0c9be4ca093540d4ae9936b23e0ffec6	1	f
train_acc	0.7627627627627628	1750061921855	0c9be4ca093540d4ae9936b23e0ffec6	1	f
val_loss	0.4096003535170089	1750061924746	0c9be4ca093540d4ae9936b23e0ffec6	1	f
val_acc	0.8216123499142367	1750061924796	0c9be4ca093540d4ae9936b23e0ffec6	1	f
train_loss	0.4646277599890106	1750061941508	0c9be4ca093540d4ae9936b23e0ffec6	2	f
train_acc	0.7910767910767911	1750061941565	0c9be4ca093540d4ae9936b23e0ffec6	2	f
val_loss	0.3860243131018421	1750061944642	0c9be4ca093540d4ae9936b23e0ffec6	2	f
val_acc	0.8387650085763293	1750061944700	0c9be4ca093540d4ae9936b23e0ffec6	2	f
train_loss	0.4395113145139073	1750061961625	0c9be4ca093540d4ae9936b23e0ffec6	3	f
train_acc	0.8030888030888031	1750061961670	0c9be4ca093540d4ae9936b23e0ffec6	3	f
val_loss	0.3172511481144825	1750061964568	0c9be4ca093540d4ae9936b23e0ffec6	3	f
val_acc	0.8524871355060034	1750061964613	0c9be4ca093540d4ae9936b23e0ffec6	3	f
train_loss	0.407713030679499	1750061981569	0c9be4ca093540d4ae9936b23e0ffec6	4	f
train_acc	0.8309738309738309	1750061981615	0c9be4ca093540d4ae9936b23e0ffec6	4	f
val_loss	0.26672479900088975	1750061984519	0c9be4ca093540d4ae9936b23e0ffec6	4	f
val_acc	0.8850771869639794	1750061984567	0c9be4ca093540d4ae9936b23e0ffec6	4	f
train_loss	0.3864148219784459	1750062001503	0c9be4ca093540d4ae9936b23e0ffec6	5	f
train_acc	0.8322608322608323	1750062001557	0c9be4ca093540d4ae9936b23e0ffec6	5	f
val_loss	0.2801227597567679	1750062004542	0c9be4ca093540d4ae9936b23e0ffec6	5	f
val_acc	0.8747855917667239	1750062004588	0c9be4ca093540d4ae9936b23e0ffec6	5	f
train_loss	0.4229139879454568	1750062015731	0c9be4ca093540d4ae9936b23e0ffec6	6	f
train_acc	0.8193908193908194	1750062015777	0c9be4ca093540d4ae9936b23e0ffec6	6	f
val_loss	0.28076152656847164	1750062018851	0c9be4ca093540d4ae9936b23e0ffec6	6	f
val_acc	0.8970840480274442	1750062018898	0c9be4ca093540d4ae9936b23e0ffec6	6	f
train_loss	0.3769594530392389	1750062039278	0c9be4ca093540d4ae9936b23e0ffec6	7	f
train_acc	0.8425568425568426	1750062039342	0c9be4ca093540d4ae9936b23e0ffec6	7	f
val_loss	0.27630877356790967	1750062042865	0c9be4ca093540d4ae9936b23e0ffec6	7	f
val_acc	0.8867924528301887	1750062042915	0c9be4ca093540d4ae9936b23e0ffec6	7	f
train_loss	0.3561546345385601	1750062054097	0c9be4ca093540d4ae9936b23e0ffec6	8	f
train_acc	0.8477048477048477	1750062054147	0c9be4ca093540d4ae9936b23e0ffec6	8	f
val_loss	0.2320245355623255	1750062057339	0c9be4ca093540d4ae9936b23e0ffec6	8	f
val_acc	0.8987993138936535	1750062057389	0c9be4ca093540d4ae9936b23e0ffec6	8	f
train_loss	0.36541428575184354	1750062074726	0c9be4ca093540d4ae9936b23e0ffec6	9	f
train_acc	0.8447018447018447	1750062074777	0c9be4ca093540d4ae9936b23e0ffec6	9	f
val_loss	0.24464647333883707	1750062077767	0c9be4ca093540d4ae9936b23e0ffec6	9	f
val_acc	0.9056603773584906	1750062077814	0c9be4ca093540d4ae9936b23e0ffec6	9	f
train_loss	0.3445348741413953	1750062096119	0c9be4ca093540d4ae9936b23e0ffec6	10	f
train_acc	0.8558558558558559	1750062096171	0c9be4ca093540d4ae9936b23e0ffec6	10	f
val_loss	0.21360391756682617	1750062099387	0c9be4ca093540d4ae9936b23e0ffec6	10	f
val_acc	0.9039451114922813	1750062099434	0c9be4ca093540d4ae9936b23e0ffec6	10	f
train_loss	0.34385355757265734	1750062110902	0c9be4ca093540d4ae9936b23e0ffec6	11	f
train_acc	0.8567138567138567	1750062110955	0c9be4ca093540d4ae9936b23e0ffec6	11	f
val_loss	0.23505217900202574	1750062113989	0c9be4ca093540d4ae9936b23e0ffec6	11	f
val_acc	0.8987993138936535	1750062114158	0c9be4ca093540d4ae9936b23e0ffec6	11	f
train_loss	0.32033588954278297	1750062125288	0c9be4ca093540d4ae9936b23e0ffec6	12	f
train_acc	0.8657228657228657	1750062125336	0c9be4ca093540d4ae9936b23e0ffec6	12	f
val_loss	0.2258740008950847	1750062128598	0c9be4ca093540d4ae9936b23e0ffec6	12	f
val_acc	0.9125214408233276	1750062128647	0c9be4ca093540d4ae9936b23e0ffec6	12	f
train_loss	0.30569721370334535	1750062146027	0c9be4ca093540d4ae9936b23e0ffec6	13	f
train_acc	0.8691548691548692	1750062146071	0c9be4ca093540d4ae9936b23e0ffec6	13	f
val_loss	0.23731339046824243	1750062148960	0c9be4ca093540d4ae9936b23e0ffec6	13	f
val_acc	0.9056603773584906	1750062149008	0c9be4ca093540d4ae9936b23e0ffec6	13	f
train_loss	0.3024987271930567	1750062160032	0c9be4ca093540d4ae9936b23e0ffec6	14	f
train_acc	0.8794508794508794	1750062160080	0c9be4ca093540d4ae9936b23e0ffec6	14	f
val_loss	0.20011832235352253	1750062163268	0c9be4ca093540d4ae9936b23e0ffec6	14	f
val_acc	0.9108061749571184	1750062163314	0c9be4ca093540d4ae9936b23e0ffec6	14	f
train_loss	0.298553747278792	1750062174054	0c9be4ca093540d4ae9936b23e0ffec6	15	f
train_acc	0.8712998712998713	1750062174101	0c9be4ca093540d4ae9936b23e0ffec6	15	f
val_loss	0.18986349690251858	1750062176988	0c9be4ca093540d4ae9936b23e0ffec6	15	f
val_acc	0.9193825042881647	1750062177034	0c9be4ca093540d4ae9936b23e0ffec6	15	f
train_loss	0.2767942858990146	1750062194129	0c9be4ca093540d4ae9936b23e0ffec6	16	f
train_acc	0.882024882024882	1750062194176	0c9be4ca093540d4ae9936b23e0ffec6	16	f
val_loss	0.2037693283825755	1750062197248	0c9be4ca093540d4ae9936b23e0ffec6	16	f
val_acc	0.9108061749571184	1750062197295	0c9be4ca093540d4ae9936b23e0ffec6	16	f
train_loss	0.3072184259315664	1750062208065	0c9be4ca093540d4ae9936b23e0ffec6	17	f
train_acc	0.8725868725868726	1750062208113	0c9be4ca093540d4ae9936b23e0ffec6	17	f
val_loss	0.19531339086835012	1750062211020	0c9be4ca093540d4ae9936b23e0ffec6	17	f
val_acc	0.9159519725557461	1750062211066	0c9be4ca093540d4ae9936b23e0ffec6	17	f
train_loss	0.2727789557425058	1750062222224	0c9be4ca093540d4ae9936b23e0ffec6	18	f
train_acc	0.8884598884598884	1750062222275	0c9be4ca093540d4ae9936b23e0ffec6	18	f
val_loss	0.20840896716529878	1750062225229	0c9be4ca093540d4ae9936b23e0ffec6	18	f
val_acc	0.9159519725557461	1750062225276	0c9be4ca093540d4ae9936b23e0ffec6	18	f
train_loss	0.2789727686966299	1750062235877	0c9be4ca093540d4ae9936b23e0ffec6	19	f
train_acc	0.8824538824538825	1750062235924	0c9be4ca093540d4ae9936b23e0ffec6	19	f
val_loss	0.2079956247303539	1750062238893	0c9be4ca093540d4ae9936b23e0ffec6	19	f
val_acc	0.9108061749571184	1750062238941	0c9be4ca093540d4ae9936b23e0ffec6	19	f
train_loss	0.2610221150759104	1750062250202	0c9be4ca093540d4ae9936b23e0ffec6	20	f
train_acc	0.888888888888889	1750062250247	0c9be4ca093540d4ae9936b23e0ffec6	20	f
val_loss	0.21159271762976312	1750062253310	0c9be4ca093540d4ae9936b23e0ffec6	20	f
val_acc	0.9176672384219554	1750062253358	0c9be4ca093540d4ae9936b23e0ffec6	20	f
train_loss	0.2653144149310289	1750062264037	0c9be4ca093540d4ae9936b23e0ffec6	21	f
train_acc	0.8914628914628915	1750062264083	0c9be4ca093540d4ae9936b23e0ffec6	21	f
val_loss	0.18406361282050712	1750062266987	0c9be4ca093540d4ae9936b23e0ffec6	21	f
val_acc	0.9210977701543739	1750062267032	0c9be4ca093540d4ae9936b23e0ffec6	21	f
train_loss	0.25965078026120214	1750062284602	0c9be4ca093540d4ae9936b23e0ffec6	22	f
train_acc	0.8910338910338911	1750062284651	0c9be4ca093540d4ae9936b23e0ffec6	22	f
val_loss	0.19464669230922826	1750062287602	0c9be4ca093540d4ae9936b23e0ffec6	22	f
val_acc	0.9090909090909091	1750062287656	0c9be4ca093540d4ae9936b23e0ffec6	22	f
train_loss	0.2471002030275452	1750062298531	0c9be4ca093540d4ae9936b23e0ffec6	23	f
train_acc	0.8966108966108967	1750062298578	0c9be4ca093540d4ae9936b23e0ffec6	23	f
val_loss	0.16508382216645454	1750062301466	0c9be4ca093540d4ae9936b23e0ffec6	23	f
val_acc	0.9313893653516295	1750062301513	0c9be4ca093540d4ae9936b23e0ffec6	23	f
train_loss	0.24645627597175102	1750062318619	0c9be4ca093540d4ae9936b23e0ffec6	24	f
train_acc	0.8948948948948949	1750062318665	0c9be4ca093540d4ae9936b23e0ffec6	24	f
val_loss	0.20286950338983312	1750062321569	0c9be4ca093540d4ae9936b23e0ffec6	24	f
val_acc	0.9210977701543739	1750062321614	0c9be4ca093540d4ae9936b23e0ffec6	24	f
train_loss	0.7987013854524293	1750067675165	80ac8416bf724a749b8e1ab7f7f36c8b	0	f
train_acc	0.6091806091806092	1750067675231	80ac8416bf724a749b8e1ab7f7f36c8b	0	f
val_loss	0.48801265909986674	1750067678455	80ac8416bf724a749b8e1ab7f7f36c8b	0	f
val_acc	0.7530017152658662	1750067678497	80ac8416bf724a749b8e1ab7f7f36c8b	0	f
train_loss	0.5717193237807504	1750067698232	80ac8416bf724a749b8e1ab7f7f36c8b	1	f
train_acc	0.7318747318747318	1750067698278	80ac8416bf724a749b8e1ab7f7f36c8b	1	f
val_loss	0.3475869250440679	1750067701218	80ac8416bf724a749b8e1ab7f7f36c8b	1	f
val_acc	0.8490566037735849	1750067701269	80ac8416bf724a749b8e1ab7f7f36c8b	1	f
train_loss	0.5026513930811283	1750067720356	80ac8416bf724a749b8e1ab7f7f36c8b	2	f
train_acc	0.7863577863577864	1750067720414	80ac8416bf724a749b8e1ab7f7f36c8b	2	f
val_loss	0.2667798949964664	1750067723414	80ac8416bf724a749b8e1ab7f7f36c8b	2	f
val_acc	0.902229845626072	1750067723463	80ac8416bf724a749b8e1ab7f7f36c8b	2	f
train_loss	0.4285718648027627	1750067741826	80ac8416bf724a749b8e1ab7f7f36c8b	3	f
train_acc	0.8215358215358215	1750067741883	80ac8416bf724a749b8e1ab7f7f36c8b	3	f
val_loss	0.2809692876314422	1750067745086	80ac8416bf724a749b8e1ab7f7f36c8b	3	f
val_acc	0.8713550600343053	1750067745137	80ac8416bf724a749b8e1ab7f7f36c8b	3	f
train_loss	0.4328221904264914	1750067756598	80ac8416bf724a749b8e1ab7f7f36c8b	4	f
train_acc	0.8082368082368082	1750067756645	80ac8416bf724a749b8e1ab7f7f36c8b	4	f
val_loss	0.25222435777633107	1750067759579	80ac8416bf724a749b8e1ab7f7f36c8b	4	f
val_acc	0.8953687821612349	1750067759627	80ac8416bf724a749b8e1ab7f7f36c8b	4	f
train_loss	0.40061209546757687	1750067770463	80ac8416bf724a749b8e1ab7f7f36c8b	5	f
train_acc	0.8232518232518232	1750067770894	80ac8416bf724a749b8e1ab7f7f36c8b	5	f
val_loss	0.2570904183551337	1750067773804	80ac8416bf724a749b8e1ab7f7f36c8b	5	f
val_acc	0.8953687821612349	1750067773849	80ac8416bf724a749b8e1ab7f7f36c8b	5	f
train_loss	0.37969066949936003	1750067784172	80ac8416bf724a749b8e1ab7f7f36c8b	6	f
train_acc	0.8352638352638353	1750067784236	80ac8416bf724a749b8e1ab7f7f36c8b	6	f
val_loss	0.24232386724822108	1750067787276	80ac8416bf724a749b8e1ab7f7f36c8b	6	f
val_loss	0.27666875325769547	1750067808766	80ac8416bf724a749b8e1ab7f7f36c8b	7	f
train_loss	0.36892326065574477	1750067819347	80ac8416bf724a749b8e1ab7f7f36c8b	8	f
val_loss	0.1873649158363277	1750067857624	80ac8416bf724a749b8e1ab7f7f36c8b	10	f
val_acc	0.9159519725557461	1750067894108	80ac8416bf724a749b8e1ab7f7f36c8b	12	f
val_acc	0.9262435677530017	1750067953337	80ac8416bf724a749b8e1ab7f7f36c8b	16	f
train_acc	0.882024882024882	1750067986885	80ac8416bf724a749b8e1ab7f7f36c8b	18	f
val_acc	0.934819897084048	1750068011690	80ac8416bf724a749b8e1ab7f7f36c8b	19	f
train_acc	0.8987558987558988	1750068044904	80ac8416bf724a749b8e1ab7f7f36c8b	21	f
train_acc	0.8966108966108967	1750068074855	80ac8416bf724a749b8e1ab7f7f36c8b	23	f
val_acc	0.9039451114922813	1750067787324	80ac8416bf724a749b8e1ab7f7f36c8b	6	f
train_loss	0.348923345764836	1750067854606	80ac8416bf724a749b8e1ab7f7f36c8b	10	f
train_acc	0.8665808665808666	1750067876367	80ac8416bf724a749b8e1ab7f7f36c8b	11	f
train_loss	0.3066922853697221	1750067890749	80ac8416bf724a749b8e1ab7f7f36c8b	12	f
train_loss	0.320412036279198	1750067935986	80ac8416bf724a749b8e1ab7f7f36c8b	15	f
val_acc	0.9210977701543739	1750067939063	80ac8416bf724a749b8e1ab7f7f36c8b	15	f
val_loss	0.17352160724522114	1750067990060	80ac8416bf724a749b8e1ab7f7f36c8b	18	f
val_acc	0.9228130360205832	1750068048184	80ac8416bf724a749b8e1ab7f7f36c8b	21	f
val_acc	0.9331046312178387	1750068063496	80ac8416bf724a749b8e1ab7f7f36c8b	22	f
train_loss	0.2539412783788847	1750068089151	80ac8416bf724a749b8e1ab7f7f36c8b	24	f
train_loss	0.3249157442779615	1750067876322	80ac8416bf724a749b8e1ab7f7f36c8b	11	f
train_acc	0.8747318747318747	1750067936036	80ac8416bf724a749b8e1ab7f7f36c8b	15	f
val_acc	0.9296740994854202	1750067990109	80ac8416bf724a749b8e1ab7f7f36c8b	18	f
train_acc	0.8871728871728872	1750068030339	80ac8416bf724a749b8e1ab7f7f36c8b	20	f
val_loss	0.17958515381526782	1750068033337	80ac8416bf724a749b8e1ab7f7f36c8b	20	f
val_loss	0.18958708020262613	1750068048134	80ac8416bf724a749b8e1ab7f7f36c8b	21	f
train_loss	0.24907442095682683	1750068060209	80ac8416bf724a749b8e1ab7f7f36c8b	22	f
val_loss	0.16446897760672594	1750068077903	80ac8416bf724a749b8e1ab7f7f36c8b	23	f
train_loss	0.38362705308651524	1750067805512	80ac8416bf724a749b8e1ab7f7f36c8b	7	f
val_loss	0.2275046940324237	1750067879283	80ac8416bf724a749b8e1ab7f7f36c8b	11	f
train_acc	0.8674388674388674	1750067905458	80ac8416bf724a749b8e1ab7f7f36c8b	13	f
val_acc	0.9262435677530017	1750067923131	80ac8416bf724a749b8e1ab7f7f36c8b	14	f
train_acc	0.8828828828828829	1750067964998	80ac8416bf724a749b8e1ab7f7f36c8b	17	f
train_loss	0.2739084952893251	1750068008507	80ac8416bf724a749b8e1ab7f7f36c8b	19	f
train_loss	0.28090403167948813	1750068030286	80ac8416bf724a749b8e1ab7f7f36c8b	20	f
train_loss	0.24692120362458336	1750068074806	80ac8416bf724a749b8e1ab7f7f36c8b	23	f
val_loss	0.18555015642483483	1750068092880	80ac8416bf724a749b8e1ab7f7f36c8b	24	f
train_acc	0.8382668382668382	1750067805581	80ac8416bf724a749b8e1ab7f7f36c8b	7	f
val_loss	0.20017568480804895	1750067908608	80ac8416bf724a749b8e1ab7f7f36c8b	13	f
val_acc	0.9176672384219554	1750067908656	80ac8416bf724a749b8e1ab7f7f36c8b	13	f
train_loss	0.29243061318514124	1750067919962	80ac8416bf724a749b8e1ab7f7f36c8b	14	f
val_loss	0.1830771745375867	1750067923086	80ac8416bf724a749b8e1ab7f7f36c8b	14	f
train_loss	0.29060092317807423	1750067964953	80ac8416bf724a749b8e1ab7f7f36c8b	17	f
train_acc	0.8867438867438867	1750068008553	80ac8416bf724a749b8e1ab7f7f36c8b	19	f
val_acc	0.9262435677530017	1750068033385	80ac8416bf724a749b8e1ab7f7f36c8b	20	f
val_acc	0.934819897084048	1750068077954	80ac8416bf724a749b8e1ab7f7f36c8b	23	f
val_acc	0.9262435677530017	1750068092929	80ac8416bf724a749b8e1ab7f7f36c8b	24	f
val_acc	0.8833619210977701	1750067808812	80ac8416bf724a749b8e1ab7f7f36c8b	7	f
train_acc	0.848991848991849	1750067819399	80ac8416bf724a749b8e1ab7f7f36c8b	8	f
val_acc	0.9262435677530017	1750067857674	80ac8416bf724a749b8e1ab7f7f36c8b	10	f
val_acc	0.9039451114922813	1750067879331	80ac8416bf724a749b8e1ab7f7f36c8b	11	f
train_acc	0.8755898755898756	1750067890795	80ac8416bf724a749b8e1ab7f7f36c8b	12	f
val_loss	0.19288772830218842	1750067894060	80ac8416bf724a749b8e1ab7f7f36c8b	12	f
val_loss	0.17130429063816627	1750067953290	80ac8416bf724a749b8e1ab7f7f36c8b	16	f
train_loss	0.28323101414369956	1750067986832	80ac8416bf724a749b8e1ab7f7f36c8b	18	f
val_loss	0.16513325562812453	1750068011640	80ac8416bf724a749b8e1ab7f7f36c8b	19	f
train_loss	0.24303930382879954	1750068044857	80ac8416bf724a749b8e1ab7f7f36c8b	21	f
train_acc	0.8931788931788932	1750068089201	80ac8416bf724a749b8e1ab7f7f36c8b	24	f
val_loss	0.24318337389371816	1750067822358	80ac8416bf724a749b8e1ab7f7f36c8b	8	f
train_loss	0.3753128755647499	1750067833013	80ac8416bf724a749b8e1ab7f7f36c8b	9	f
val_loss	0.2031887561645148	1750067835993	80ac8416bf724a749b8e1ab7f7f36c8b	9	f
train_loss	0.30144121250795325	1750067950212	80ac8416bf724a749b8e1ab7f7f36c8b	16	f
val_acc	0.9279588336192109	1750067968192	80ac8416bf724a749b8e1ab7f7f36c8b	17	f
train_acc	0.9017589017589017	1750068060257	80ac8416bf724a749b8e1ab7f7f36c8b	22	f
val_acc	0.8885077186963979	1750067822406	80ac8416bf724a749b8e1ab7f7f36c8b	8	f
train_acc	0.8451308451308451	1750067833060	80ac8416bf724a749b8e1ab7f7f36c8b	9	f
val_acc	0.9125214408233276	1750067836040	80ac8416bf724a749b8e1ab7f7f36c8b	9	f
train_acc	0.8485628485628486	1750067854654	80ac8416bf724a749b8e1ab7f7f36c8b	10	f
train_loss	0.30530150253237803	1750067905405	80ac8416bf724a749b8e1ab7f7f36c8b	13	f
train_acc	0.8751608751608752	1750067920012	80ac8416bf724a749b8e1ab7f7f36c8b	14	f
val_loss	0.17846177203986494	1750067939016	80ac8416bf724a749b8e1ab7f7f36c8b	15	f
train_acc	0.8665808665808666	1750067950259	80ac8416bf724a749b8e1ab7f7f36c8b	16	f
val_loss	0.18529816782086014	1750067968144	80ac8416bf724a749b8e1ab7f7f36c8b	17	f
val_loss	0.1710884397271158	1750068063447	80ac8416bf724a749b8e1ab7f7f36c8b	22	f
train_loss	0.7426219841074606	1750233441097	fc5a0a04a861447ca919bbd7c7a3b181	0	f
train_acc	0.6387816387816387	1750233441097	fc5a0a04a861447ca919bbd7c7a3b181	0	f
val_loss	0.4913345296223413	1750233445835	fc5a0a04a861447ca919bbd7c7a3b181	0	f
val_acc	0.7873070325900514	1750233445835	fc5a0a04a861447ca919bbd7c7a3b181	0	f
train_loss	0.5338687293778055	1750233464373	fc5a0a04a861447ca919bbd7c7a3b181	1	f
train_acc	0.7533247533247533	1750233464373	fc5a0a04a861447ca919bbd7c7a3b181	1	f
val_loss	0.3779107506033896	1750233467410	fc5a0a04a861447ca919bbd7c7a3b181	1	f
val_acc	0.8490566037735849	1750233467410	fc5a0a04a861447ca919bbd7c7a3b181	1	f
train_loss	0.48984846656847186	1750233485244	fc5a0a04a861447ca919bbd7c7a3b181	2	f
train_acc	0.7859287859287859	1750233485244	fc5a0a04a861447ca919bbd7c7a3b181	2	f
val_loss	0.33799272540503056	1750233488146	fc5a0a04a861447ca919bbd7c7a3b181	2	f
val_acc	0.8765008576329331	1750233488146	fc5a0a04a861447ca919bbd7c7a3b181	2	f
train_loss	0.46614999302668103	1750233505521	fc5a0a04a861447ca919bbd7c7a3b181	3	f
train_acc	0.7953667953667953	1750233505521	fc5a0a04a861447ca919bbd7c7a3b181	3	f
val_loss	0.3131494889511866	1750233508439	fc5a0a04a861447ca919bbd7c7a3b181	3	f
val_acc	0.8679245283018868	1750233508439	fc5a0a04a861447ca919bbd7c7a3b181	3	f
train_loss	0.41690894773414544	1750233520060	fc5a0a04a861447ca919bbd7c7a3b181	4	f
train_acc	0.8198198198198198	1750233520060	fc5a0a04a861447ca919bbd7c7a3b181	4	f
val_loss	0.2872284950870592	1750233522981	fc5a0a04a861447ca919bbd7c7a3b181	4	f
val_acc	0.8782161234991424	1750233522981	fc5a0a04a861447ca919bbd7c7a3b181	4	f
train_loss	0.39663435527051993	1750233541206	fc5a0a04a861447ca919bbd7c7a3b181	5	f
train_acc	0.8344058344058344	1750233541206	fc5a0a04a861447ca919bbd7c7a3b181	5	f
val_loss	0.27681624112366404	1750233544680	fc5a0a04a861447ca919bbd7c7a3b181	5	f
val_acc	0.8850771869639794	1750233544680	fc5a0a04a861447ca919bbd7c7a3b181	5	f
train_loss	0.38436711706454435	1750233561546	fc5a0a04a861447ca919bbd7c7a3b181	6	f
train_acc	0.8356928356928357	1750233561546	fc5a0a04a861447ca919bbd7c7a3b181	6	f
val_loss	0.26427403869391713	1750233564613	fc5a0a04a861447ca919bbd7c7a3b181	6	f
val_acc	0.8782161234991424	1750233564613	fc5a0a04a861447ca919bbd7c7a3b181	6	f
train_loss	0.35957431283083047	1750233575330	fc5a0a04a861447ca919bbd7c7a3b181	7	f
train_acc	0.8386958386958387	1750233575330	fc5a0a04a861447ca919bbd7c7a3b181	7	f
val_loss	0.2619530942233513	1750233578390	fc5a0a04a861447ca919bbd7c7a3b181	7	f
val_acc	0.8850771869639794	1750233578390	fc5a0a04a861447ca919bbd7c7a3b181	7	f
train_loss	0.38037218875201767	1750233589200	fc5a0a04a861447ca919bbd7c7a3b181	8	f
train_acc	0.8374088374088374	1750233589200	fc5a0a04a861447ca919bbd7c7a3b181	8	f
val_loss	0.2553250457113848	1750233592352	fc5a0a04a861447ca919bbd7c7a3b181	8	f
val_acc	0.8885077186963979	1750233592352	fc5a0a04a861447ca919bbd7c7a3b181	8	f
train_loss	0.34776834484488606	1750233610178	fc5a0a04a861447ca919bbd7c7a3b181	9	f
train_acc	0.8545688545688546	1750233610178	fc5a0a04a861447ca919bbd7c7a3b181	9	f
val_loss	0.2193743070494863	1750233613189	fc5a0a04a861447ca919bbd7c7a3b181	9	f
val_acc	0.9228130360205832	1750233613189	fc5a0a04a861447ca919bbd7c7a3b181	9	f
train_loss	0.3120748667387633	1750233630727	fc5a0a04a861447ca919bbd7c7a3b181	10	f
train_acc	0.8704418704418705	1750233630727	fc5a0a04a861447ca919bbd7c7a3b181	10	f
val_loss	0.2441364403040904	1750233633564	fc5a0a04a861447ca919bbd7c7a3b181	10	f
val_acc	0.8867924528301887	1750233633564	fc5a0a04a861447ca919bbd7c7a3b181	10	f
train_loss	0.32472156700991806	1750233644037	fc5a0a04a861447ca919bbd7c7a3b181	11	f
train_acc	0.8674388674388674	1750233644037	fc5a0a04a861447ca919bbd7c7a3b181	11	f
val_loss	0.2612023066032812	1750233646968	fc5a0a04a861447ca919bbd7c7a3b181	11	f
val_acc	0.8850771869639794	1750233646968	fc5a0a04a861447ca919bbd7c7a3b181	11	f
train_loss	0.29669739714460486	1750233657726	fc5a0a04a861447ca919bbd7c7a3b181	12	f
train_acc	0.8712998712998713	1750233657726	fc5a0a04a861447ca919bbd7c7a3b181	12	f
val_loss	0.25038894003905726	1750233660827	fc5a0a04a861447ca919bbd7c7a3b181	12	f
val_acc	0.8885077186963979	1750233660827	fc5a0a04a861447ca919bbd7c7a3b181	12	f
train_loss	0.32786012517950763	1750233671393	fc5a0a04a861447ca919bbd7c7a3b181	13	f
train_acc	0.8627198627198627	1750233671393	fc5a0a04a861447ca919bbd7c7a3b181	13	f
val_loss	0.26389801368040655	1750233674209	fc5a0a04a861447ca919bbd7c7a3b181	13	f
val_acc	0.8816466552315608	1750233674209	fc5a0a04a861447ca919bbd7c7a3b181	13	f
\.


--
-- Data for Name: model_version_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.model_version_tags (key, value, name, version) FROM stdin;
\.


--
-- Data for Name: model_versions; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.model_versions (name, version, creation_time, last_updated_time, description, user_id, current_stage, source, run_id, status, status_message, run_link, storage_location) FROM stdin;
dispatch_tracker_yolov8n	1	1749979172990	1749979172990		\N	None	mlflow-artifacts:/c1160e56f23849bdae1f9f385e49660b/artifacts/weights/best.pt		READY	\N		mlflow-artifacts:/c1160e56f23849bdae1f9f385e49660b/artifacts/weights/best.pt
dispatch_tracker_yolov8n	2	1749981139678	1749981139678		\N	None	mlflow-artifacts:/f705565f4b2d42bb8ae252d7418395b9/artifacts/weights/best.pt		READY	\N		mlflow-artifacts:/f705565f4b2d42bb8ae252d7418395b9/artifacts/weights/best.pt
\.


--
-- Data for Name: params; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.params (key, value, run_uuid) FROM stdin;
data_config	dispatch_data.yaml	c1160e56f23849bdae1f9f385e49660b
epochs	1	c1160e56f23849bdae1f9f385e49660b
batch_size	16	c1160e56f23849bdae1f9f385e49660b
weights	yolov8n.pt	c1160e56f23849bdae1f9f385e49660b
task	detect	c1160e56f23849bdae1f9f385e49660b
mode	train	c1160e56f23849bdae1f9f385e49660b
model	yolov8n.pt	c1160e56f23849bdae1f9f385e49660b
data	dispatch_data.yaml	c1160e56f23849bdae1f9f385e49660b
time	None	c1160e56f23849bdae1f9f385e49660b
patience	100	c1160e56f23849bdae1f9f385e49660b
batch	16	c1160e56f23849bdae1f9f385e49660b
imgsz	640	c1160e56f23849bdae1f9f385e49660b
save	True	c1160e56f23849bdae1f9f385e49660b
save_period	-1	c1160e56f23849bdae1f9f385e49660b
cache	False	c1160e56f23849bdae1f9f385e49660b
device	None	c1160e56f23849bdae1f9f385e49660b
workers	0	c1160e56f23849bdae1f9f385e49660b
project	dispatch_tracker	c1160e56f23849bdae1f9f385e49660b
name	initial_model	c1160e56f23849bdae1f9f385e49660b
exist_ok	True	c1160e56f23849bdae1f9f385e49660b
pretrained	True	c1160e56f23849bdae1f9f385e49660b
optimizer	auto	c1160e56f23849bdae1f9f385e49660b
verbose	True	c1160e56f23849bdae1f9f385e49660b
seed	0	c1160e56f23849bdae1f9f385e49660b
deterministic	True	c1160e56f23849bdae1f9f385e49660b
single_cls	False	c1160e56f23849bdae1f9f385e49660b
rect	False	c1160e56f23849bdae1f9f385e49660b
cos_lr	False	c1160e56f23849bdae1f9f385e49660b
close_mosaic	10	c1160e56f23849bdae1f9f385e49660b
resume	False	c1160e56f23849bdae1f9f385e49660b
amp	True	c1160e56f23849bdae1f9f385e49660b
fraction	1.0	c1160e56f23849bdae1f9f385e49660b
profile	False	c1160e56f23849bdae1f9f385e49660b
freeze	None	c1160e56f23849bdae1f9f385e49660b
multi_scale	False	c1160e56f23849bdae1f9f385e49660b
overlap_mask	True	c1160e56f23849bdae1f9f385e49660b
mask_ratio	4	c1160e56f23849bdae1f9f385e49660b
dropout	0.0	c1160e56f23849bdae1f9f385e49660b
val	True	c1160e56f23849bdae1f9f385e49660b
split	val	c1160e56f23849bdae1f9f385e49660b
save_json	False	c1160e56f23849bdae1f9f385e49660b
conf	None	c1160e56f23849bdae1f9f385e49660b
iou	0.7	c1160e56f23849bdae1f9f385e49660b
max_det	300	c1160e56f23849bdae1f9f385e49660b
half	False	c1160e56f23849bdae1f9f385e49660b
dnn	False	c1160e56f23849bdae1f9f385e49660b
plots	True	c1160e56f23849bdae1f9f385e49660b
source	None	c1160e56f23849bdae1f9f385e49660b
vid_stride	1	c1160e56f23849bdae1f9f385e49660b
stream_buffer	False	c1160e56f23849bdae1f9f385e49660b
visualize	False	c1160e56f23849bdae1f9f385e49660b
augment	False	c1160e56f23849bdae1f9f385e49660b
agnostic_nms	False	c1160e56f23849bdae1f9f385e49660b
classes	None	c1160e56f23849bdae1f9f385e49660b
retina_masks	False	c1160e56f23849bdae1f9f385e49660b
embed	None	c1160e56f23849bdae1f9f385e49660b
show	False	c1160e56f23849bdae1f9f385e49660b
save_frames	False	c1160e56f23849bdae1f9f385e49660b
save_txt	False	c1160e56f23849bdae1f9f385e49660b
save_conf	False	c1160e56f23849bdae1f9f385e49660b
save_crop	False	c1160e56f23849bdae1f9f385e49660b
show_labels	True	c1160e56f23849bdae1f9f385e49660b
show_conf	True	c1160e56f23849bdae1f9f385e49660b
show_boxes	True	c1160e56f23849bdae1f9f385e49660b
line_width	None	c1160e56f23849bdae1f9f385e49660b
format	torchscript	c1160e56f23849bdae1f9f385e49660b
keras	False	c1160e56f23849bdae1f9f385e49660b
optimize	False	c1160e56f23849bdae1f9f385e49660b
int8	False	c1160e56f23849bdae1f9f385e49660b
dynamic	False	c1160e56f23849bdae1f9f385e49660b
simplify	True	c1160e56f23849bdae1f9f385e49660b
opset	None	c1160e56f23849bdae1f9f385e49660b
workspace	None	c1160e56f23849bdae1f9f385e49660b
nms	False	c1160e56f23849bdae1f9f385e49660b
lr0	0.01	c1160e56f23849bdae1f9f385e49660b
lrf	0.01	c1160e56f23849bdae1f9f385e49660b
momentum	0.937	c1160e56f23849bdae1f9f385e49660b
weight_decay	0.0005	c1160e56f23849bdae1f9f385e49660b
warmup_epochs	3.0	c1160e56f23849bdae1f9f385e49660b
warmup_momentum	0.8	c1160e56f23849bdae1f9f385e49660b
warmup_bias_lr	0.0	c1160e56f23849bdae1f9f385e49660b
box	7.5	c1160e56f23849bdae1f9f385e49660b
cls	0.5	c1160e56f23849bdae1f9f385e49660b
dfl	1.5	c1160e56f23849bdae1f9f385e49660b
pose	12.0	c1160e56f23849bdae1f9f385e49660b
kobj	1.0	c1160e56f23849bdae1f9f385e49660b
nbs	64	c1160e56f23849bdae1f9f385e49660b
hsv_h	0.015	c1160e56f23849bdae1f9f385e49660b
hsv_s	0.7	c1160e56f23849bdae1f9f385e49660b
hsv_v	0.4	c1160e56f23849bdae1f9f385e49660b
degrees	0.0	c1160e56f23849bdae1f9f385e49660b
translate	0.1	c1160e56f23849bdae1f9f385e49660b
scale	0.5	c1160e56f23849bdae1f9f385e49660b
shear	0.0	c1160e56f23849bdae1f9f385e49660b
perspective	0.0	c1160e56f23849bdae1f9f385e49660b
flipud	0.0	c1160e56f23849bdae1f9f385e49660b
fliplr	0.5	c1160e56f23849bdae1f9f385e49660b
bgr	0.0	c1160e56f23849bdae1f9f385e49660b
mosaic	1.0	c1160e56f23849bdae1f9f385e49660b
mixup	0.0	c1160e56f23849bdae1f9f385e49660b
cutmix	0.0	c1160e56f23849bdae1f9f385e49660b
copy_paste	0.0	c1160e56f23849bdae1f9f385e49660b
copy_paste_mode	flip	c1160e56f23849bdae1f9f385e49660b
auto_augment	randaugment	c1160e56f23849bdae1f9f385e49660b
erasing	0.4	c1160e56f23849bdae1f9f385e49660b
cfg	None	c1160e56f23849bdae1f9f385e49660b
tracker	botsort.yaml	c1160e56f23849bdae1f9f385e49660b
save_dir	dispatch_tracker/initial_model	c1160e56f23849bdae1f9f385e49660b
data_config	dispatch_data.yaml	90cdf52da7774146b845f3a73b9b1984
epochs	1	90cdf52da7774146b845f3a73b9b1984
batch_size	16	90cdf52da7774146b845f3a73b9b1984
weights	yolov8n.pt	90cdf52da7774146b845f3a73b9b1984
task	detect	90cdf52da7774146b845f3a73b9b1984
mode	train	90cdf52da7774146b845f3a73b9b1984
model	yolov8n.pt	90cdf52da7774146b845f3a73b9b1984
data	dispatch_data.yaml	90cdf52da7774146b845f3a73b9b1984
time	None	90cdf52da7774146b845f3a73b9b1984
patience	100	90cdf52da7774146b845f3a73b9b1984
batch	16	90cdf52da7774146b845f3a73b9b1984
imgsz	640	90cdf52da7774146b845f3a73b9b1984
save	True	90cdf52da7774146b845f3a73b9b1984
save_period	-1	90cdf52da7774146b845f3a73b9b1984
cache	False	90cdf52da7774146b845f3a73b9b1984
device	None	90cdf52da7774146b845f3a73b9b1984
workers	0	90cdf52da7774146b845f3a73b9b1984
project	dispatch_tracker	90cdf52da7774146b845f3a73b9b1984
name	initial_model	90cdf52da7774146b845f3a73b9b1984
exist_ok	True	90cdf52da7774146b845f3a73b9b1984
pretrained	True	90cdf52da7774146b845f3a73b9b1984
optimizer	auto	90cdf52da7774146b845f3a73b9b1984
verbose	True	90cdf52da7774146b845f3a73b9b1984
seed	0	90cdf52da7774146b845f3a73b9b1984
deterministic	True	90cdf52da7774146b845f3a73b9b1984
single_cls	False	90cdf52da7774146b845f3a73b9b1984
rect	False	90cdf52da7774146b845f3a73b9b1984
cos_lr	False	90cdf52da7774146b845f3a73b9b1984
close_mosaic	10	90cdf52da7774146b845f3a73b9b1984
resume	False	90cdf52da7774146b845f3a73b9b1984
amp	True	90cdf52da7774146b845f3a73b9b1984
fraction	1.0	90cdf52da7774146b845f3a73b9b1984
profile	False	90cdf52da7774146b845f3a73b9b1984
freeze	None	90cdf52da7774146b845f3a73b9b1984
multi_scale	False	90cdf52da7774146b845f3a73b9b1984
overlap_mask	True	90cdf52da7774146b845f3a73b9b1984
mask_ratio	4	90cdf52da7774146b845f3a73b9b1984
dropout	0.0	90cdf52da7774146b845f3a73b9b1984
val	True	90cdf52da7774146b845f3a73b9b1984
split	val	90cdf52da7774146b845f3a73b9b1984
save_json	False	90cdf52da7774146b845f3a73b9b1984
conf	None	90cdf52da7774146b845f3a73b9b1984
iou	0.7	90cdf52da7774146b845f3a73b9b1984
max_det	300	90cdf52da7774146b845f3a73b9b1984
half	False	90cdf52da7774146b845f3a73b9b1984
dnn	False	90cdf52da7774146b845f3a73b9b1984
plots	True	90cdf52da7774146b845f3a73b9b1984
source	None	90cdf52da7774146b845f3a73b9b1984
vid_stride	1	90cdf52da7774146b845f3a73b9b1984
stream_buffer	False	90cdf52da7774146b845f3a73b9b1984
visualize	False	90cdf52da7774146b845f3a73b9b1984
augment	False	90cdf52da7774146b845f3a73b9b1984
agnostic_nms	False	90cdf52da7774146b845f3a73b9b1984
classes	None	90cdf52da7774146b845f3a73b9b1984
retina_masks	False	90cdf52da7774146b845f3a73b9b1984
embed	None	90cdf52da7774146b845f3a73b9b1984
show	False	90cdf52da7774146b845f3a73b9b1984
save_frames	False	90cdf52da7774146b845f3a73b9b1984
save_txt	False	90cdf52da7774146b845f3a73b9b1984
save_conf	False	90cdf52da7774146b845f3a73b9b1984
save_crop	False	90cdf52da7774146b845f3a73b9b1984
show_labels	True	90cdf52da7774146b845f3a73b9b1984
show_conf	True	90cdf52da7774146b845f3a73b9b1984
show_boxes	True	90cdf52da7774146b845f3a73b9b1984
line_width	None	90cdf52da7774146b845f3a73b9b1984
format	torchscript	90cdf52da7774146b845f3a73b9b1984
keras	False	90cdf52da7774146b845f3a73b9b1984
optimize	False	90cdf52da7774146b845f3a73b9b1984
int8	False	90cdf52da7774146b845f3a73b9b1984
dynamic	False	90cdf52da7774146b845f3a73b9b1984
simplify	True	90cdf52da7774146b845f3a73b9b1984
opset	None	90cdf52da7774146b845f3a73b9b1984
workspace	None	90cdf52da7774146b845f3a73b9b1984
nms	False	90cdf52da7774146b845f3a73b9b1984
lr0	0.01	90cdf52da7774146b845f3a73b9b1984
lrf	0.01	90cdf52da7774146b845f3a73b9b1984
momentum	0.937	90cdf52da7774146b845f3a73b9b1984
weight_decay	0.0005	90cdf52da7774146b845f3a73b9b1984
warmup_epochs	3.0	90cdf52da7774146b845f3a73b9b1984
warmup_momentum	0.8	90cdf52da7774146b845f3a73b9b1984
warmup_bias_lr	0.0	90cdf52da7774146b845f3a73b9b1984
box	7.5	90cdf52da7774146b845f3a73b9b1984
cls	0.5	90cdf52da7774146b845f3a73b9b1984
dfl	1.5	90cdf52da7774146b845f3a73b9b1984
pose	12.0	90cdf52da7774146b845f3a73b9b1984
kobj	1.0	90cdf52da7774146b845f3a73b9b1984
nbs	64	90cdf52da7774146b845f3a73b9b1984
hsv_h	0.015	90cdf52da7774146b845f3a73b9b1984
hsv_s	0.7	90cdf52da7774146b845f3a73b9b1984
hsv_v	0.4	90cdf52da7774146b845f3a73b9b1984
degrees	0.0	90cdf52da7774146b845f3a73b9b1984
translate	0.1	90cdf52da7774146b845f3a73b9b1984
scale	0.5	90cdf52da7774146b845f3a73b9b1984
shear	0.0	90cdf52da7774146b845f3a73b9b1984
perspective	0.0	90cdf52da7774146b845f3a73b9b1984
flipud	0.0	90cdf52da7774146b845f3a73b9b1984
fliplr	0.5	90cdf52da7774146b845f3a73b9b1984
bgr	0.0	90cdf52da7774146b845f3a73b9b1984
mosaic	1.0	90cdf52da7774146b845f3a73b9b1984
mixup	0.0	90cdf52da7774146b845f3a73b9b1984
cutmix	0.0	90cdf52da7774146b845f3a73b9b1984
copy_paste	0.0	90cdf52da7774146b845f3a73b9b1984
copy_paste_mode	flip	90cdf52da7774146b845f3a73b9b1984
auto_augment	randaugment	90cdf52da7774146b845f3a73b9b1984
erasing	0.4	90cdf52da7774146b845f3a73b9b1984
cfg	None	90cdf52da7774146b845f3a73b9b1984
tracker	botsort.yaml	90cdf52da7774146b845f3a73b9b1984
save_dir	dispatch_tracker/initial_model	90cdf52da7774146b845f3a73b9b1984
data_config	dispatch_data.yaml	f705565f4b2d42bb8ae252d7418395b9
epochs	50	f705565f4b2d42bb8ae252d7418395b9
batch_size	16	f705565f4b2d42bb8ae252d7418395b9
weights	yolov8n.pt	f705565f4b2d42bb8ae252d7418395b9
task	detect	f705565f4b2d42bb8ae252d7418395b9
mode	train	f705565f4b2d42bb8ae252d7418395b9
model	yolov8n.pt	f705565f4b2d42bb8ae252d7418395b9
data	dispatch_data.yaml	f705565f4b2d42bb8ae252d7418395b9
time	None	f705565f4b2d42bb8ae252d7418395b9
patience	100	f705565f4b2d42bb8ae252d7418395b9
batch	16	f705565f4b2d42bb8ae252d7418395b9
imgsz	640	f705565f4b2d42bb8ae252d7418395b9
save	True	f705565f4b2d42bb8ae252d7418395b9
save_period	-1	f705565f4b2d42bb8ae252d7418395b9
cache	False	f705565f4b2d42bb8ae252d7418395b9
device	None	f705565f4b2d42bb8ae252d7418395b9
workers	0	f705565f4b2d42bb8ae252d7418395b9
project	dispatch_tracker	f705565f4b2d42bb8ae252d7418395b9
name	initial_model	f705565f4b2d42bb8ae252d7418395b9
exist_ok	True	f705565f4b2d42bb8ae252d7418395b9
pretrained	True	f705565f4b2d42bb8ae252d7418395b9
optimizer	auto	f705565f4b2d42bb8ae252d7418395b9
verbose	True	f705565f4b2d42bb8ae252d7418395b9
seed	0	f705565f4b2d42bb8ae252d7418395b9
deterministic	True	f705565f4b2d42bb8ae252d7418395b9
single_cls	False	f705565f4b2d42bb8ae252d7418395b9
rect	False	f705565f4b2d42bb8ae252d7418395b9
cos_lr	False	f705565f4b2d42bb8ae252d7418395b9
close_mosaic	10	f705565f4b2d42bb8ae252d7418395b9
resume	False	f705565f4b2d42bb8ae252d7418395b9
amp	True	f705565f4b2d42bb8ae252d7418395b9
fraction	1.0	f705565f4b2d42bb8ae252d7418395b9
profile	False	f705565f4b2d42bb8ae252d7418395b9
freeze	None	f705565f4b2d42bb8ae252d7418395b9
multi_scale	False	f705565f4b2d42bb8ae252d7418395b9
overlap_mask	True	f705565f4b2d42bb8ae252d7418395b9
mask_ratio	4	f705565f4b2d42bb8ae252d7418395b9
dropout	0.0	f705565f4b2d42bb8ae252d7418395b9
val	True	f705565f4b2d42bb8ae252d7418395b9
split	val	f705565f4b2d42bb8ae252d7418395b9
save_json	False	f705565f4b2d42bb8ae252d7418395b9
conf	None	f705565f4b2d42bb8ae252d7418395b9
iou	0.7	f705565f4b2d42bb8ae252d7418395b9
max_det	300	f705565f4b2d42bb8ae252d7418395b9
half	False	f705565f4b2d42bb8ae252d7418395b9
dnn	False	f705565f4b2d42bb8ae252d7418395b9
plots	True	f705565f4b2d42bb8ae252d7418395b9
source	None	f705565f4b2d42bb8ae252d7418395b9
vid_stride	1	f705565f4b2d42bb8ae252d7418395b9
stream_buffer	False	f705565f4b2d42bb8ae252d7418395b9
visualize	False	f705565f4b2d42bb8ae252d7418395b9
augment	False	f705565f4b2d42bb8ae252d7418395b9
agnostic_nms	False	f705565f4b2d42bb8ae252d7418395b9
classes	None	f705565f4b2d42bb8ae252d7418395b9
retina_masks	False	f705565f4b2d42bb8ae252d7418395b9
embed	None	f705565f4b2d42bb8ae252d7418395b9
show	False	f705565f4b2d42bb8ae252d7418395b9
save_frames	False	f705565f4b2d42bb8ae252d7418395b9
save_txt	False	f705565f4b2d42bb8ae252d7418395b9
save_conf	False	f705565f4b2d42bb8ae252d7418395b9
save_crop	False	f705565f4b2d42bb8ae252d7418395b9
show_labels	True	f705565f4b2d42bb8ae252d7418395b9
show_conf	True	f705565f4b2d42bb8ae252d7418395b9
show_boxes	True	f705565f4b2d42bb8ae252d7418395b9
line_width	None	f705565f4b2d42bb8ae252d7418395b9
format	torchscript	f705565f4b2d42bb8ae252d7418395b9
keras	False	f705565f4b2d42bb8ae252d7418395b9
optimize	False	f705565f4b2d42bb8ae252d7418395b9
int8	False	f705565f4b2d42bb8ae252d7418395b9
dynamic	False	f705565f4b2d42bb8ae252d7418395b9
simplify	True	f705565f4b2d42bb8ae252d7418395b9
opset	None	f705565f4b2d42bb8ae252d7418395b9
workspace	None	f705565f4b2d42bb8ae252d7418395b9
nms	False	f705565f4b2d42bb8ae252d7418395b9
lr0	0.01	f705565f4b2d42bb8ae252d7418395b9
lrf	0.01	f705565f4b2d42bb8ae252d7418395b9
momentum	0.937	f705565f4b2d42bb8ae252d7418395b9
weight_decay	0.0005	f705565f4b2d42bb8ae252d7418395b9
warmup_epochs	3.0	f705565f4b2d42bb8ae252d7418395b9
warmup_momentum	0.8	f705565f4b2d42bb8ae252d7418395b9
warmup_bias_lr	0.0	f705565f4b2d42bb8ae252d7418395b9
box	7.5	f705565f4b2d42bb8ae252d7418395b9
cls	0.5	f705565f4b2d42bb8ae252d7418395b9
dfl	1.5	f705565f4b2d42bb8ae252d7418395b9
pose	12.0	f705565f4b2d42bb8ae252d7418395b9
kobj	1.0	f705565f4b2d42bb8ae252d7418395b9
nbs	64	f705565f4b2d42bb8ae252d7418395b9
hsv_h	0.015	f705565f4b2d42bb8ae252d7418395b9
hsv_s	0.7	f705565f4b2d42bb8ae252d7418395b9
hsv_v	0.4	f705565f4b2d42bb8ae252d7418395b9
degrees	0.0	f705565f4b2d42bb8ae252d7418395b9
translate	0.1	f705565f4b2d42bb8ae252d7418395b9
scale	0.5	f705565f4b2d42bb8ae252d7418395b9
shear	0.0	f705565f4b2d42bb8ae252d7418395b9
perspective	0.0	f705565f4b2d42bb8ae252d7418395b9
flipud	0.0	f705565f4b2d42bb8ae252d7418395b9
fliplr	0.5	f705565f4b2d42bb8ae252d7418395b9
bgr	0.0	f705565f4b2d42bb8ae252d7418395b9
mosaic	1.0	f705565f4b2d42bb8ae252d7418395b9
mixup	0.0	f705565f4b2d42bb8ae252d7418395b9
cutmix	0.0	f705565f4b2d42bb8ae252d7418395b9
copy_paste	0.0	f705565f4b2d42bb8ae252d7418395b9
copy_paste_mode	flip	f705565f4b2d42bb8ae252d7418395b9
auto_augment	randaugment	f705565f4b2d42bb8ae252d7418395b9
erasing	0.4	f705565f4b2d42bb8ae252d7418395b9
cfg	None	f705565f4b2d42bb8ae252d7418395b9
tracker	botsort.yaml	f705565f4b2d42bb8ae252d7418395b9
save_dir	dispatch_tracker/initial_model	f705565f4b2d42bb8ae252d7418395b9
data_config	dispatch_data.yaml	67848caae72e4ab9a29dd0b423e0a8e2
epochs	50	67848caae72e4ab9a29dd0b423e0a8e2
batch_size	16	67848caae72e4ab9a29dd0b423e0a8e2
weights	yolov8n.pt	67848caae72e4ab9a29dd0b423e0a8e2
data_config	dispatch_data.yaml	a09d3c7df02f404d8c3d6dc4ba5fb17e
epochs	50	a09d3c7df02f404d8c3d6dc4ba5fb17e
batch_size	16	a09d3c7df02f404d8c3d6dc4ba5fb17e
weights	yolov8n.pt	a09d3c7df02f404d8c3d6dc4ba5fb17e
task	detect	a09d3c7df02f404d8c3d6dc4ba5fb17e
mode	train	a09d3c7df02f404d8c3d6dc4ba5fb17e
model	yolov8n.pt	a09d3c7df02f404d8c3d6dc4ba5fb17e
data	dispatch_data.yaml	a09d3c7df02f404d8c3d6dc4ba5fb17e
time	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
patience	100	a09d3c7df02f404d8c3d6dc4ba5fb17e
batch	16	a09d3c7df02f404d8c3d6dc4ba5fb17e
imgsz	640	a09d3c7df02f404d8c3d6dc4ba5fb17e
save	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
save_period	-1	a09d3c7df02f404d8c3d6dc4ba5fb17e
cache	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
device	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
workers	0	a09d3c7df02f404d8c3d6dc4ba5fb17e
project	dispatch_tracker	a09d3c7df02f404d8c3d6dc4ba5fb17e
name	initial_model	a09d3c7df02f404d8c3d6dc4ba5fb17e
exist_ok	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
pretrained	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
optimizer	auto	a09d3c7df02f404d8c3d6dc4ba5fb17e
verbose	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
seed	0	a09d3c7df02f404d8c3d6dc4ba5fb17e
deterministic	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
single_cls	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
rect	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
cos_lr	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
close_mosaic	10	a09d3c7df02f404d8c3d6dc4ba5fb17e
resume	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
amp	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
fraction	1.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
profile	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
freeze	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
multi_scale	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
overlap_mask	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
mask_ratio	4	a09d3c7df02f404d8c3d6dc4ba5fb17e
dropout	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
val	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
split	val	a09d3c7df02f404d8c3d6dc4ba5fb17e
save_json	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
conf	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
iou	0.7	a09d3c7df02f404d8c3d6dc4ba5fb17e
max_det	300	a09d3c7df02f404d8c3d6dc4ba5fb17e
half	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
dnn	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
plots	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
source	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
vid_stride	1	a09d3c7df02f404d8c3d6dc4ba5fb17e
stream_buffer	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
visualize	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
augment	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
agnostic_nms	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
classes	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
retina_masks	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
embed	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
show	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
save_frames	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
save_txt	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
save_conf	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
save_crop	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
show_labels	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
show_conf	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
show_boxes	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
line_width	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
format	torchscript	a09d3c7df02f404d8c3d6dc4ba5fb17e
keras	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
optimize	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
int8	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
dynamic	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
simplify	True	a09d3c7df02f404d8c3d6dc4ba5fb17e
opset	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
workspace	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
nms	False	a09d3c7df02f404d8c3d6dc4ba5fb17e
lr0	0.01	a09d3c7df02f404d8c3d6dc4ba5fb17e
lrf	0.01	a09d3c7df02f404d8c3d6dc4ba5fb17e
momentum	0.937	a09d3c7df02f404d8c3d6dc4ba5fb17e
weight_decay	0.0005	a09d3c7df02f404d8c3d6dc4ba5fb17e
warmup_epochs	3.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
warmup_momentum	0.8	a09d3c7df02f404d8c3d6dc4ba5fb17e
warmup_bias_lr	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
box	7.5	a09d3c7df02f404d8c3d6dc4ba5fb17e
cls	0.5	a09d3c7df02f404d8c3d6dc4ba5fb17e
dfl	1.5	a09d3c7df02f404d8c3d6dc4ba5fb17e
pose	12.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
kobj	1.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
nbs	64	a09d3c7df02f404d8c3d6dc4ba5fb17e
hsv_h	0.015	a09d3c7df02f404d8c3d6dc4ba5fb17e
hsv_s	0.7	a09d3c7df02f404d8c3d6dc4ba5fb17e
hsv_v	0.4	a09d3c7df02f404d8c3d6dc4ba5fb17e
degrees	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
translate	0.1	a09d3c7df02f404d8c3d6dc4ba5fb17e
scale	0.5	a09d3c7df02f404d8c3d6dc4ba5fb17e
shear	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
perspective	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
flipud	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
fliplr	0.5	a09d3c7df02f404d8c3d6dc4ba5fb17e
bgr	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
mosaic	1.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
mixup	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
cutmix	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
copy_paste	0.0	a09d3c7df02f404d8c3d6dc4ba5fb17e
copy_paste_mode	flip	a09d3c7df02f404d8c3d6dc4ba5fb17e
auto_augment	randaugment	a09d3c7df02f404d8c3d6dc4ba5fb17e
erasing	0.4	a09d3c7df02f404d8c3d6dc4ba5fb17e
cfg	None	a09d3c7df02f404d8c3d6dc4ba5fb17e
tracker	botsort.yaml	a09d3c7df02f404d8c3d6dc4ba5fb17e
save_dir	dispatch_tracker/initial_model	a09d3c7df02f404d8c3d6dc4ba5fb17e
data_config	dispatch_data.yaml	0f9d0ae6b94d4052b926c321a67f4872
epochs	50	0f9d0ae6b94d4052b926c321a67f4872
batch_size	16	0f9d0ae6b94d4052b926c321a67f4872
weights	yolov8n.pt	0f9d0ae6b94d4052b926c321a67f4872
data_config	dispatch_data.yaml	321a157e98ee488f8d3160d1f3eb4ab0
epochs	50	321a157e98ee488f8d3160d1f3eb4ab0
batch_size	16	321a157e98ee488f8d3160d1f3eb4ab0
weights	yolov8n.pt	321a157e98ee488f8d3160d1f3eb4ab0
data_config	dispatch_data.yaml	3d87cb449a754c129baa66c2026c1fb3
epochs	50	3d87cb449a754c129baa66c2026c1fb3
batch_size	16	3d87cb449a754c129baa66c2026c1fb3
weights	yolov8n.pt	3d87cb449a754c129baa66c2026c1fb3
task	detect	3d87cb449a754c129baa66c2026c1fb3
mode	train	3d87cb449a754c129baa66c2026c1fb3
model	yolov8n.pt	3d87cb449a754c129baa66c2026c1fb3
data	dispatch_data.yaml	3d87cb449a754c129baa66c2026c1fb3
time	None	3d87cb449a754c129baa66c2026c1fb3
patience	100	3d87cb449a754c129baa66c2026c1fb3
batch	16	3d87cb449a754c129baa66c2026c1fb3
imgsz	640	3d87cb449a754c129baa66c2026c1fb3
save	True	3d87cb449a754c129baa66c2026c1fb3
save_period	-1	3d87cb449a754c129baa66c2026c1fb3
cache	False	3d87cb449a754c129baa66c2026c1fb3
device	None	3d87cb449a754c129baa66c2026c1fb3
workers	0	3d87cb449a754c129baa66c2026c1fb3
project	dispatch_tracker	3d87cb449a754c129baa66c2026c1fb3
name	initial_model	3d87cb449a754c129baa66c2026c1fb3
exist_ok	True	3d87cb449a754c129baa66c2026c1fb3
pretrained	True	3d87cb449a754c129baa66c2026c1fb3
optimizer	auto	3d87cb449a754c129baa66c2026c1fb3
verbose	True	3d87cb449a754c129baa66c2026c1fb3
seed	0	3d87cb449a754c129baa66c2026c1fb3
deterministic	True	3d87cb449a754c129baa66c2026c1fb3
single_cls	False	3d87cb449a754c129baa66c2026c1fb3
rect	False	3d87cb449a754c129baa66c2026c1fb3
cos_lr	False	3d87cb449a754c129baa66c2026c1fb3
close_mosaic	10	3d87cb449a754c129baa66c2026c1fb3
resume	False	3d87cb449a754c129baa66c2026c1fb3
amp	True	3d87cb449a754c129baa66c2026c1fb3
fraction	1.0	3d87cb449a754c129baa66c2026c1fb3
profile	False	3d87cb449a754c129baa66c2026c1fb3
freeze	None	3d87cb449a754c129baa66c2026c1fb3
multi_scale	False	3d87cb449a754c129baa66c2026c1fb3
overlap_mask	True	3d87cb449a754c129baa66c2026c1fb3
mask_ratio	4	3d87cb449a754c129baa66c2026c1fb3
dropout	0.0	3d87cb449a754c129baa66c2026c1fb3
val	True	3d87cb449a754c129baa66c2026c1fb3
split	val	3d87cb449a754c129baa66c2026c1fb3
save_json	False	3d87cb449a754c129baa66c2026c1fb3
conf	None	3d87cb449a754c129baa66c2026c1fb3
iou	0.7	3d87cb449a754c129baa66c2026c1fb3
max_det	300	3d87cb449a754c129baa66c2026c1fb3
half	False	3d87cb449a754c129baa66c2026c1fb3
dnn	False	3d87cb449a754c129baa66c2026c1fb3
plots	True	3d87cb449a754c129baa66c2026c1fb3
source	None	3d87cb449a754c129baa66c2026c1fb3
vid_stride	1	3d87cb449a754c129baa66c2026c1fb3
stream_buffer	False	3d87cb449a754c129baa66c2026c1fb3
visualize	False	3d87cb449a754c129baa66c2026c1fb3
augment	False	3d87cb449a754c129baa66c2026c1fb3
agnostic_nms	False	3d87cb449a754c129baa66c2026c1fb3
classes	None	3d87cb449a754c129baa66c2026c1fb3
retina_masks	False	3d87cb449a754c129baa66c2026c1fb3
embed	None	3d87cb449a754c129baa66c2026c1fb3
show	False	3d87cb449a754c129baa66c2026c1fb3
save_frames	False	3d87cb449a754c129baa66c2026c1fb3
save_txt	False	3d87cb449a754c129baa66c2026c1fb3
save_conf	False	3d87cb449a754c129baa66c2026c1fb3
save_crop	False	3d87cb449a754c129baa66c2026c1fb3
show_labels	True	3d87cb449a754c129baa66c2026c1fb3
show_conf	True	3d87cb449a754c129baa66c2026c1fb3
show_boxes	True	3d87cb449a754c129baa66c2026c1fb3
line_width	None	3d87cb449a754c129baa66c2026c1fb3
format	torchscript	3d87cb449a754c129baa66c2026c1fb3
keras	False	3d87cb449a754c129baa66c2026c1fb3
optimize	False	3d87cb449a754c129baa66c2026c1fb3
int8	False	3d87cb449a754c129baa66c2026c1fb3
dynamic	False	3d87cb449a754c129baa66c2026c1fb3
simplify	True	3d87cb449a754c129baa66c2026c1fb3
opset	None	3d87cb449a754c129baa66c2026c1fb3
workspace	None	3d87cb449a754c129baa66c2026c1fb3
nms	False	3d87cb449a754c129baa66c2026c1fb3
lr0	0.01	3d87cb449a754c129baa66c2026c1fb3
lrf	0.01	3d87cb449a754c129baa66c2026c1fb3
momentum	0.937	3d87cb449a754c129baa66c2026c1fb3
weight_decay	0.0005	3d87cb449a754c129baa66c2026c1fb3
warmup_epochs	3.0	3d87cb449a754c129baa66c2026c1fb3
warmup_momentum	0.8	3d87cb449a754c129baa66c2026c1fb3
warmup_bias_lr	0.0	3d87cb449a754c129baa66c2026c1fb3
box	7.5	3d87cb449a754c129baa66c2026c1fb3
cls	0.5	3d87cb449a754c129baa66c2026c1fb3
dfl	1.5	3d87cb449a754c129baa66c2026c1fb3
pose	12.0	3d87cb449a754c129baa66c2026c1fb3
kobj	1.0	3d87cb449a754c129baa66c2026c1fb3
nbs	64	3d87cb449a754c129baa66c2026c1fb3
hsv_h	0.015	3d87cb449a754c129baa66c2026c1fb3
hsv_s	0.7	3d87cb449a754c129baa66c2026c1fb3
hsv_v	0.4	3d87cb449a754c129baa66c2026c1fb3
degrees	0.0	3d87cb449a754c129baa66c2026c1fb3
translate	0.1	3d87cb449a754c129baa66c2026c1fb3
scale	0.5	3d87cb449a754c129baa66c2026c1fb3
shear	0.0	3d87cb449a754c129baa66c2026c1fb3
perspective	0.0	3d87cb449a754c129baa66c2026c1fb3
flipud	0.0	3d87cb449a754c129baa66c2026c1fb3
fliplr	0.5	3d87cb449a754c129baa66c2026c1fb3
bgr	0.0	3d87cb449a754c129baa66c2026c1fb3
mosaic	1.0	3d87cb449a754c129baa66c2026c1fb3
mixup	0.0	3d87cb449a754c129baa66c2026c1fb3
cutmix	0.0	3d87cb449a754c129baa66c2026c1fb3
copy_paste	0.0	3d87cb449a754c129baa66c2026c1fb3
copy_paste_mode	flip	3d87cb449a754c129baa66c2026c1fb3
auto_augment	randaugment	3d87cb449a754c129baa66c2026c1fb3
erasing	0.4	3d87cb449a754c129baa66c2026c1fb3
cfg	None	3d87cb449a754c129baa66c2026c1fb3
tracker	botsort.yaml	3d87cb449a754c129baa66c2026c1fb3
save_dir	dispatch_tracker/initial_model	3d87cb449a754c129baa66c2026c1fb3
data_config	dispatch_data.yaml	90fec5d2c1b941e2b298340ab628ae1a
epochs	50	90fec5d2c1b941e2b298340ab628ae1a
batch_size	16	90fec5d2c1b941e2b298340ab628ae1a
weights	yolov8n.pt	90fec5d2c1b941e2b298340ab628ae1a
data_config	dispatch_data.yaml	ee9b01ad30874357ad534ae40ab232bf
epochs	50	ee9b01ad30874357ad534ae40ab232bf
batch_size	16	ee9b01ad30874357ad534ae40ab232bf
weights	yolov8n.pt	ee9b01ad30874357ad534ae40ab232bf
task	detect	ee9b01ad30874357ad534ae40ab232bf
mode	train	ee9b01ad30874357ad534ae40ab232bf
model	yolov8n.pt	ee9b01ad30874357ad534ae40ab232bf
data	dispatch_data.yaml	ee9b01ad30874357ad534ae40ab232bf
time	None	ee9b01ad30874357ad534ae40ab232bf
patience	100	ee9b01ad30874357ad534ae40ab232bf
batch	16	ee9b01ad30874357ad534ae40ab232bf
imgsz	640	ee9b01ad30874357ad534ae40ab232bf
save	True	ee9b01ad30874357ad534ae40ab232bf
save_period	-1	ee9b01ad30874357ad534ae40ab232bf
cache	False	ee9b01ad30874357ad534ae40ab232bf
device	None	ee9b01ad30874357ad534ae40ab232bf
workers	0	ee9b01ad30874357ad534ae40ab232bf
project	dispatch_tracker	ee9b01ad30874357ad534ae40ab232bf
name	initial_model	ee9b01ad30874357ad534ae40ab232bf
exist_ok	True	ee9b01ad30874357ad534ae40ab232bf
pretrained	True	ee9b01ad30874357ad534ae40ab232bf
optimizer	auto	ee9b01ad30874357ad534ae40ab232bf
verbose	True	ee9b01ad30874357ad534ae40ab232bf
seed	0	ee9b01ad30874357ad534ae40ab232bf
deterministic	True	ee9b01ad30874357ad534ae40ab232bf
single_cls	False	ee9b01ad30874357ad534ae40ab232bf
rect	False	ee9b01ad30874357ad534ae40ab232bf
cos_lr	False	ee9b01ad30874357ad534ae40ab232bf
close_mosaic	10	ee9b01ad30874357ad534ae40ab232bf
resume	False	ee9b01ad30874357ad534ae40ab232bf
amp	True	ee9b01ad30874357ad534ae40ab232bf
fraction	1.0	ee9b01ad30874357ad534ae40ab232bf
profile	False	ee9b01ad30874357ad534ae40ab232bf
freeze	None	ee9b01ad30874357ad534ae40ab232bf
multi_scale	False	ee9b01ad30874357ad534ae40ab232bf
overlap_mask	True	ee9b01ad30874357ad534ae40ab232bf
mask_ratio	4	ee9b01ad30874357ad534ae40ab232bf
dropout	0.0	ee9b01ad30874357ad534ae40ab232bf
val	True	ee9b01ad30874357ad534ae40ab232bf
split	val	ee9b01ad30874357ad534ae40ab232bf
save_json	False	ee9b01ad30874357ad534ae40ab232bf
conf	None	ee9b01ad30874357ad534ae40ab232bf
iou	0.7	ee9b01ad30874357ad534ae40ab232bf
max_det	300	ee9b01ad30874357ad534ae40ab232bf
half	False	ee9b01ad30874357ad534ae40ab232bf
dnn	False	ee9b01ad30874357ad534ae40ab232bf
plots	True	ee9b01ad30874357ad534ae40ab232bf
source	None	ee9b01ad30874357ad534ae40ab232bf
vid_stride	1	ee9b01ad30874357ad534ae40ab232bf
stream_buffer	False	ee9b01ad30874357ad534ae40ab232bf
visualize	False	ee9b01ad30874357ad534ae40ab232bf
augment	False	ee9b01ad30874357ad534ae40ab232bf
agnostic_nms	False	ee9b01ad30874357ad534ae40ab232bf
classes	None	ee9b01ad30874357ad534ae40ab232bf
retina_masks	False	ee9b01ad30874357ad534ae40ab232bf
embed	None	ee9b01ad30874357ad534ae40ab232bf
show	False	ee9b01ad30874357ad534ae40ab232bf
save_frames	False	ee9b01ad30874357ad534ae40ab232bf
save_txt	False	ee9b01ad30874357ad534ae40ab232bf
save_conf	False	ee9b01ad30874357ad534ae40ab232bf
save_crop	False	ee9b01ad30874357ad534ae40ab232bf
show_labels	True	ee9b01ad30874357ad534ae40ab232bf
show_conf	True	ee9b01ad30874357ad534ae40ab232bf
show_boxes	True	ee9b01ad30874357ad534ae40ab232bf
line_width	None	ee9b01ad30874357ad534ae40ab232bf
format	torchscript	ee9b01ad30874357ad534ae40ab232bf
keras	False	ee9b01ad30874357ad534ae40ab232bf
optimize	False	ee9b01ad30874357ad534ae40ab232bf
int8	False	ee9b01ad30874357ad534ae40ab232bf
dynamic	False	ee9b01ad30874357ad534ae40ab232bf
simplify	True	ee9b01ad30874357ad534ae40ab232bf
opset	None	ee9b01ad30874357ad534ae40ab232bf
workspace	None	ee9b01ad30874357ad534ae40ab232bf
nms	False	ee9b01ad30874357ad534ae40ab232bf
lr0	0.01	ee9b01ad30874357ad534ae40ab232bf
lrf	0.01	ee9b01ad30874357ad534ae40ab232bf
momentum	0.937	ee9b01ad30874357ad534ae40ab232bf
weight_decay	0.0005	ee9b01ad30874357ad534ae40ab232bf
warmup_epochs	3.0	ee9b01ad30874357ad534ae40ab232bf
warmup_momentum	0.8	ee9b01ad30874357ad534ae40ab232bf
warmup_bias_lr	0.0	ee9b01ad30874357ad534ae40ab232bf
box	7.5	ee9b01ad30874357ad534ae40ab232bf
cls	0.5	ee9b01ad30874357ad534ae40ab232bf
dfl	1.5	ee9b01ad30874357ad534ae40ab232bf
pose	12.0	ee9b01ad30874357ad534ae40ab232bf
kobj	1.0	ee9b01ad30874357ad534ae40ab232bf
nbs	64	ee9b01ad30874357ad534ae40ab232bf
hsv_h	0.015	ee9b01ad30874357ad534ae40ab232bf
hsv_s	0.7	ee9b01ad30874357ad534ae40ab232bf
hsv_v	0.4	ee9b01ad30874357ad534ae40ab232bf
degrees	0.0	ee9b01ad30874357ad534ae40ab232bf
translate	0.1	ee9b01ad30874357ad534ae40ab232bf
scale	0.5	ee9b01ad30874357ad534ae40ab232bf
shear	0.0	ee9b01ad30874357ad534ae40ab232bf
perspective	0.0	ee9b01ad30874357ad534ae40ab232bf
flipud	0.0	ee9b01ad30874357ad534ae40ab232bf
fliplr	0.5	ee9b01ad30874357ad534ae40ab232bf
bgr	0.0	ee9b01ad30874357ad534ae40ab232bf
mosaic	1.0	ee9b01ad30874357ad534ae40ab232bf
mixup	0.0	ee9b01ad30874357ad534ae40ab232bf
cutmix	0.0	ee9b01ad30874357ad534ae40ab232bf
copy_paste	0.0	ee9b01ad30874357ad534ae40ab232bf
copy_paste_mode	flip	ee9b01ad30874357ad534ae40ab232bf
auto_augment	randaugment	ee9b01ad30874357ad534ae40ab232bf
erasing	0.4	ee9b01ad30874357ad534ae40ab232bf
cfg	None	ee9b01ad30874357ad534ae40ab232bf
tracker	botsort.yaml	ee9b01ad30874357ad534ae40ab232bf
save_dir	dispatch_tracker/initial_model	ee9b01ad30874357ad534ae40ab232bf
data_config	dispatch_data.yaml	3614eae808e4435ba235b05e86375ac7
epochs	50	3614eae808e4435ba235b05e86375ac7
batch_size	16	3614eae808e4435ba235b05e86375ac7
weights	yolov8n.pt	3614eae808e4435ba235b05e86375ac7
data_config	dispatch_data.yaml	90bbefe9b36e454fa0aef6fd8c8ef496
epochs	50	90bbefe9b36e454fa0aef6fd8c8ef496
batch_size	16	90bbefe9b36e454fa0aef6fd8c8ef496
weights	yolov8n.pt	90bbefe9b36e454fa0aef6fd8c8ef496
task	detect	90bbefe9b36e454fa0aef6fd8c8ef496
mode	train	90bbefe9b36e454fa0aef6fd8c8ef496
model	yolov8n.pt	90bbefe9b36e454fa0aef6fd8c8ef496
data	dispatch_data.yaml	90bbefe9b36e454fa0aef6fd8c8ef496
time	None	90bbefe9b36e454fa0aef6fd8c8ef496
patience	100	90bbefe9b36e454fa0aef6fd8c8ef496
batch	16	90bbefe9b36e454fa0aef6fd8c8ef496
imgsz	640	90bbefe9b36e454fa0aef6fd8c8ef496
save	True	90bbefe9b36e454fa0aef6fd8c8ef496
save_period	-1	90bbefe9b36e454fa0aef6fd8c8ef496
cache	False	90bbefe9b36e454fa0aef6fd8c8ef496
device	None	90bbefe9b36e454fa0aef6fd8c8ef496
workers	0	90bbefe9b36e454fa0aef6fd8c8ef496
project	dispatch_tracker	90bbefe9b36e454fa0aef6fd8c8ef496
name	initial_model	90bbefe9b36e454fa0aef6fd8c8ef496
exist_ok	True	90bbefe9b36e454fa0aef6fd8c8ef496
pretrained	True	90bbefe9b36e454fa0aef6fd8c8ef496
optimizer	auto	90bbefe9b36e454fa0aef6fd8c8ef496
verbose	True	90bbefe9b36e454fa0aef6fd8c8ef496
seed	0	90bbefe9b36e454fa0aef6fd8c8ef496
deterministic	True	90bbefe9b36e454fa0aef6fd8c8ef496
single_cls	False	90bbefe9b36e454fa0aef6fd8c8ef496
rect	False	90bbefe9b36e454fa0aef6fd8c8ef496
cos_lr	False	90bbefe9b36e454fa0aef6fd8c8ef496
close_mosaic	10	90bbefe9b36e454fa0aef6fd8c8ef496
resume	False	90bbefe9b36e454fa0aef6fd8c8ef496
amp	True	90bbefe9b36e454fa0aef6fd8c8ef496
fraction	1.0	90bbefe9b36e454fa0aef6fd8c8ef496
profile	False	90bbefe9b36e454fa0aef6fd8c8ef496
freeze	None	90bbefe9b36e454fa0aef6fd8c8ef496
multi_scale	False	90bbefe9b36e454fa0aef6fd8c8ef496
overlap_mask	True	90bbefe9b36e454fa0aef6fd8c8ef496
mask_ratio	4	90bbefe9b36e454fa0aef6fd8c8ef496
dropout	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
val	True	90bbefe9b36e454fa0aef6fd8c8ef496
split	val	90bbefe9b36e454fa0aef6fd8c8ef496
save_json	False	90bbefe9b36e454fa0aef6fd8c8ef496
conf	None	90bbefe9b36e454fa0aef6fd8c8ef496
iou	0.7	90bbefe9b36e454fa0aef6fd8c8ef496
max_det	300	90bbefe9b36e454fa0aef6fd8c8ef496
half	False	90bbefe9b36e454fa0aef6fd8c8ef496
dnn	False	90bbefe9b36e454fa0aef6fd8c8ef496
plots	True	90bbefe9b36e454fa0aef6fd8c8ef496
source	None	90bbefe9b36e454fa0aef6fd8c8ef496
vid_stride	1	90bbefe9b36e454fa0aef6fd8c8ef496
stream_buffer	False	90bbefe9b36e454fa0aef6fd8c8ef496
visualize	False	90bbefe9b36e454fa0aef6fd8c8ef496
augment	False	90bbefe9b36e454fa0aef6fd8c8ef496
agnostic_nms	False	90bbefe9b36e454fa0aef6fd8c8ef496
classes	None	90bbefe9b36e454fa0aef6fd8c8ef496
retina_masks	False	90bbefe9b36e454fa0aef6fd8c8ef496
embed	None	90bbefe9b36e454fa0aef6fd8c8ef496
show	False	90bbefe9b36e454fa0aef6fd8c8ef496
save_frames	False	90bbefe9b36e454fa0aef6fd8c8ef496
save_txt	False	90bbefe9b36e454fa0aef6fd8c8ef496
save_conf	False	90bbefe9b36e454fa0aef6fd8c8ef496
save_crop	False	90bbefe9b36e454fa0aef6fd8c8ef496
show_labels	True	90bbefe9b36e454fa0aef6fd8c8ef496
show_conf	True	90bbefe9b36e454fa0aef6fd8c8ef496
show_boxes	True	90bbefe9b36e454fa0aef6fd8c8ef496
line_width	None	90bbefe9b36e454fa0aef6fd8c8ef496
format	torchscript	90bbefe9b36e454fa0aef6fd8c8ef496
keras	False	90bbefe9b36e454fa0aef6fd8c8ef496
optimize	False	90bbefe9b36e454fa0aef6fd8c8ef496
int8	False	90bbefe9b36e454fa0aef6fd8c8ef496
dynamic	False	90bbefe9b36e454fa0aef6fd8c8ef496
simplify	True	90bbefe9b36e454fa0aef6fd8c8ef496
opset	None	90bbefe9b36e454fa0aef6fd8c8ef496
workspace	None	90bbefe9b36e454fa0aef6fd8c8ef496
nms	False	90bbefe9b36e454fa0aef6fd8c8ef496
lr0	0.01	90bbefe9b36e454fa0aef6fd8c8ef496
lrf	0.01	90bbefe9b36e454fa0aef6fd8c8ef496
momentum	0.937	90bbefe9b36e454fa0aef6fd8c8ef496
weight_decay	0.0005	90bbefe9b36e454fa0aef6fd8c8ef496
warmup_epochs	3.0	90bbefe9b36e454fa0aef6fd8c8ef496
warmup_momentum	0.8	90bbefe9b36e454fa0aef6fd8c8ef496
warmup_bias_lr	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
box	7.5	90bbefe9b36e454fa0aef6fd8c8ef496
cls	0.5	90bbefe9b36e454fa0aef6fd8c8ef496
dfl	1.5	90bbefe9b36e454fa0aef6fd8c8ef496
pose	12.0	90bbefe9b36e454fa0aef6fd8c8ef496
kobj	1.0	90bbefe9b36e454fa0aef6fd8c8ef496
nbs	64	90bbefe9b36e454fa0aef6fd8c8ef496
hsv_h	0.015	90bbefe9b36e454fa0aef6fd8c8ef496
hsv_s	0.7	90bbefe9b36e454fa0aef6fd8c8ef496
hsv_v	0.4	90bbefe9b36e454fa0aef6fd8c8ef496
degrees	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
translate	0.1	90bbefe9b36e454fa0aef6fd8c8ef496
scale	0.5	90bbefe9b36e454fa0aef6fd8c8ef496
shear	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
perspective	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
flipud	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
fliplr	0.5	90bbefe9b36e454fa0aef6fd8c8ef496
bgr	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
mosaic	1.0	90bbefe9b36e454fa0aef6fd8c8ef496
mixup	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
cutmix	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
copy_paste	0.0	90bbefe9b36e454fa0aef6fd8c8ef496
copy_paste_mode	flip	90bbefe9b36e454fa0aef6fd8c8ef496
auto_augment	randaugment	90bbefe9b36e454fa0aef6fd8c8ef496
erasing	0.4	90bbefe9b36e454fa0aef6fd8c8ef496
cfg	None	90bbefe9b36e454fa0aef6fd8c8ef496
tracker	botsort.yaml	90bbefe9b36e454fa0aef6fd8c8ef496
save_dir	dispatch_tracker/initial_model	90bbefe9b36e454fa0aef6fd8c8ef496
learning_rate	0.001	3490d112ca844a5397c0101acceb73b4
optimizer	SGD	3490d112ca844a5397c0101acceb73b4
epochs	25	3490d112ca844a5397c0101acceb73b4
batch_size	32	3490d112ca844a5397c0101acceb73b4
data_config	dispatch_data.yaml	bd850db7a49f41ea9149aa08e437f18e
epochs	50	bd850db7a49f41ea9149aa08e437f18e
batch_size	16	bd850db7a49f41ea9149aa08e437f18e
weights	yolov8n.pt	bd850db7a49f41ea9149aa08e437f18e
task	detect	bd850db7a49f41ea9149aa08e437f18e
mode	train	bd850db7a49f41ea9149aa08e437f18e
model	yolov8n.pt	bd850db7a49f41ea9149aa08e437f18e
data	dispatch_data.yaml	bd850db7a49f41ea9149aa08e437f18e
time	None	bd850db7a49f41ea9149aa08e437f18e
patience	100	bd850db7a49f41ea9149aa08e437f18e
batch	16	bd850db7a49f41ea9149aa08e437f18e
imgsz	640	bd850db7a49f41ea9149aa08e437f18e
save	True	bd850db7a49f41ea9149aa08e437f18e
save_period	-1	bd850db7a49f41ea9149aa08e437f18e
cache	False	bd850db7a49f41ea9149aa08e437f18e
device	None	bd850db7a49f41ea9149aa08e437f18e
workers	0	bd850db7a49f41ea9149aa08e437f18e
project	dispatch_tracker	bd850db7a49f41ea9149aa08e437f18e
name	initial_model	bd850db7a49f41ea9149aa08e437f18e
exist_ok	True	bd850db7a49f41ea9149aa08e437f18e
pretrained	True	bd850db7a49f41ea9149aa08e437f18e
optimizer	auto	bd850db7a49f41ea9149aa08e437f18e
verbose	True	bd850db7a49f41ea9149aa08e437f18e
seed	0	bd850db7a49f41ea9149aa08e437f18e
deterministic	True	bd850db7a49f41ea9149aa08e437f18e
single_cls	False	bd850db7a49f41ea9149aa08e437f18e
rect	False	bd850db7a49f41ea9149aa08e437f18e
cos_lr	False	bd850db7a49f41ea9149aa08e437f18e
close_mosaic	10	bd850db7a49f41ea9149aa08e437f18e
resume	False	bd850db7a49f41ea9149aa08e437f18e
amp	True	bd850db7a49f41ea9149aa08e437f18e
fraction	1.0	bd850db7a49f41ea9149aa08e437f18e
profile	False	bd850db7a49f41ea9149aa08e437f18e
freeze	None	bd850db7a49f41ea9149aa08e437f18e
multi_scale	False	bd850db7a49f41ea9149aa08e437f18e
overlap_mask	True	bd850db7a49f41ea9149aa08e437f18e
mask_ratio	4	bd850db7a49f41ea9149aa08e437f18e
dropout	0.0	bd850db7a49f41ea9149aa08e437f18e
val	True	bd850db7a49f41ea9149aa08e437f18e
split	val	bd850db7a49f41ea9149aa08e437f18e
save_json	False	bd850db7a49f41ea9149aa08e437f18e
conf	None	bd850db7a49f41ea9149aa08e437f18e
iou	0.7	bd850db7a49f41ea9149aa08e437f18e
max_det	300	bd850db7a49f41ea9149aa08e437f18e
half	False	bd850db7a49f41ea9149aa08e437f18e
dnn	False	bd850db7a49f41ea9149aa08e437f18e
plots	True	bd850db7a49f41ea9149aa08e437f18e
source	None	bd850db7a49f41ea9149aa08e437f18e
vid_stride	1	bd850db7a49f41ea9149aa08e437f18e
stream_buffer	False	bd850db7a49f41ea9149aa08e437f18e
visualize	False	bd850db7a49f41ea9149aa08e437f18e
augment	False	bd850db7a49f41ea9149aa08e437f18e
agnostic_nms	False	bd850db7a49f41ea9149aa08e437f18e
classes	None	bd850db7a49f41ea9149aa08e437f18e
retina_masks	False	bd850db7a49f41ea9149aa08e437f18e
embed	None	bd850db7a49f41ea9149aa08e437f18e
show	False	bd850db7a49f41ea9149aa08e437f18e
save_frames	False	bd850db7a49f41ea9149aa08e437f18e
save_txt	False	bd850db7a49f41ea9149aa08e437f18e
save_conf	False	bd850db7a49f41ea9149aa08e437f18e
save_crop	False	bd850db7a49f41ea9149aa08e437f18e
show_labels	True	bd850db7a49f41ea9149aa08e437f18e
show_conf	True	bd850db7a49f41ea9149aa08e437f18e
show_boxes	True	bd850db7a49f41ea9149aa08e437f18e
line_width	None	bd850db7a49f41ea9149aa08e437f18e
format	torchscript	bd850db7a49f41ea9149aa08e437f18e
keras	False	bd850db7a49f41ea9149aa08e437f18e
optimize	False	bd850db7a49f41ea9149aa08e437f18e
int8	False	bd850db7a49f41ea9149aa08e437f18e
dynamic	False	bd850db7a49f41ea9149aa08e437f18e
simplify	True	bd850db7a49f41ea9149aa08e437f18e
opset	None	bd850db7a49f41ea9149aa08e437f18e
workspace	None	bd850db7a49f41ea9149aa08e437f18e
nms	False	bd850db7a49f41ea9149aa08e437f18e
lr0	0.01	bd850db7a49f41ea9149aa08e437f18e
lrf	0.01	bd850db7a49f41ea9149aa08e437f18e
momentum	0.937	bd850db7a49f41ea9149aa08e437f18e
weight_decay	0.0005	bd850db7a49f41ea9149aa08e437f18e
warmup_epochs	3.0	bd850db7a49f41ea9149aa08e437f18e
warmup_momentum	0.8	bd850db7a49f41ea9149aa08e437f18e
warmup_bias_lr	0.0	bd850db7a49f41ea9149aa08e437f18e
box	7.5	bd850db7a49f41ea9149aa08e437f18e
cls	0.5	bd850db7a49f41ea9149aa08e437f18e
dfl	1.5	bd850db7a49f41ea9149aa08e437f18e
pose	12.0	bd850db7a49f41ea9149aa08e437f18e
kobj	1.0	bd850db7a49f41ea9149aa08e437f18e
nbs	64	bd850db7a49f41ea9149aa08e437f18e
hsv_h	0.015	bd850db7a49f41ea9149aa08e437f18e
hsv_s	0.7	bd850db7a49f41ea9149aa08e437f18e
hsv_v	0.4	bd850db7a49f41ea9149aa08e437f18e
degrees	0.0	bd850db7a49f41ea9149aa08e437f18e
translate	0.1	bd850db7a49f41ea9149aa08e437f18e
scale	0.5	bd850db7a49f41ea9149aa08e437f18e
shear	0.0	bd850db7a49f41ea9149aa08e437f18e
perspective	0.0	bd850db7a49f41ea9149aa08e437f18e
flipud	0.0	bd850db7a49f41ea9149aa08e437f18e
fliplr	0.5	bd850db7a49f41ea9149aa08e437f18e
bgr	0.0	bd850db7a49f41ea9149aa08e437f18e
mosaic	1.0	bd850db7a49f41ea9149aa08e437f18e
mixup	0.0	bd850db7a49f41ea9149aa08e437f18e
cutmix	0.0	bd850db7a49f41ea9149aa08e437f18e
copy_paste	0.0	bd850db7a49f41ea9149aa08e437f18e
copy_paste_mode	flip	bd850db7a49f41ea9149aa08e437f18e
auto_augment	randaugment	bd850db7a49f41ea9149aa08e437f18e
erasing	0.4	bd850db7a49f41ea9149aa08e437f18e
cfg	None	bd850db7a49f41ea9149aa08e437f18e
tracker	botsort.yaml	bd850db7a49f41ea9149aa08e437f18e
save_dir	dispatch_tracker/initial_model	bd850db7a49f41ea9149aa08e437f18e
learning_rate	0.001	0c9be4ca093540d4ae9936b23e0ffec6
optimizer	SGD	0c9be4ca093540d4ae9936b23e0ffec6
epochs	25	0c9be4ca093540d4ae9936b23e0ffec6
batch_size	32	0c9be4ca093540d4ae9936b23e0ffec6
learning_rate	0.001	80ac8416bf724a749b8e1ab7f7f36c8b
optimizer	SGD	80ac8416bf724a749b8e1ab7f7f36c8b
epochs	25	80ac8416bf724a749b8e1ab7f7f36c8b
batch_size	32	80ac8416bf724a749b8e1ab7f7f36c8b
learning_rate	0.001	fc5a0a04a861447ca919bbd7c7a3b181
optimizer	SGD	fc5a0a04a861447ca919bbd7c7a3b181
epochs	25	fc5a0a04a861447ca919bbd7c7a3b181
batch_size	32	fc5a0a04a861447ca919bbd7c7a3b181
\.


--
-- Data for Name: registered_model_aliases; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.registered_model_aliases (alias, version, name) FROM stdin;
\.


--
-- Data for Name: registered_model_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.registered_model_tags (key, value, name) FROM stdin;
\.


--
-- Data for Name: registered_models; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.registered_models (name, creation_time, last_updated_time, description) FROM stdin;
dispatch_tracker_yolov8n	1749979172974	1749981139678	
\.


--
-- Data for Name: runs; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.runs (run_uuid, name, source_type, source_name, entry_point_name, user_id, status, start_time, end_time, source_version, lifecycle_stage, artifact_uri, experiment_id, deleted_time) FROM stdin;
c1160e56f23849bdae1f9f385e49660b	initial_model	UNKNOWN			root	FINISHED	1749979105779	1749979172684		active	mlflow-artifacts:/1/c1160e56f23849bdae1f9f385e49660b/artifacts	1	\N
f705565f4b2d42bb8ae252d7418395b9	initial_model_50	UNKNOWN			root	FINISHED	1749979643926	1749981139290		active	mlflow-artifacts:/1/f705565f4b2d42bb8ae252d7418395b9/artifacts	1	\N
321a157e98ee488f8d3160d1f3eb4ab0	initial_model	UNKNOWN			root	RUNNING	1750011935136	\N		deleted	mlflow-artifacts:/1/321a157e98ee488f8d3160d1f3eb4ab0/artifacts	1	1750011948984
0f9d0ae6b94d4052b926c321a67f4872	initial_model	UNKNOWN			root	RUNNING	1750010196253	\N		deleted	mlflow-artifacts:/1/0f9d0ae6b94d4052b926c321a67f4872/artifacts	1	1750011949483
90bbefe9b36e454fa0aef6fd8c8ef496	initial_model	UNKNOWN			root	RUNNING	1750053447057	\N		deleted	mlflow-artifacts:/1/90bbefe9b36e454fa0aef6fd8c8ef496/artifacts	1	1750053535020
ee9b01ad30874357ad534ae40ab232bf	initial_model	UNKNOWN			root	RUNNING	1750041684540	\N		deleted	mlflow-artifacts:/1/ee9b01ad30874357ad534ae40ab232bf/artifacts	1	1750053535020
3614eae808e4435ba235b05e86375ac7	initial_model	UNKNOWN			root	RUNNING	1750042042033	\N		deleted	mlflow-artifacts:/1/3614eae808e4435ba235b05e86375ac7/artifacts	1	1750053535023
0c9be4ca093540d4ae9936b23e0ffec6	upset-skunk-874	UNKNOWN			root	FINISHED	1750061879846	1750062321648		active	mlflow-artifacts:/2/0c9be4ca093540d4ae9936b23e0ffec6/artifacts	2	\N
80ac8416bf724a749b8e1ab7f7f36c8b	intelligent-pug-412	UNKNOWN			root	FINISHED	1750067662763	1750068092965		deleted	mlflow-artifacts:/2/80ac8416bf724a749b8e1ab7f7f36c8b/artifacts	2	1750230942994
3490d112ca844a5397c0101acceb73b4	painted-grouse-322	UNKNOWN			root	FINISHED	1750053693705	1750053990650		deleted	mlflow-artifacts:/2/3490d112ca844a5397c0101acceb73b4/artifacts	2	1750230942993
90fec5d2c1b941e2b298340ab628ae1a	initial_model	UNKNOWN			root	RUNNING	1750012193545	\N		deleted	mlflow-artifacts:/1/90fec5d2c1b941e2b298340ab628ae1a/artifacts	1	1750231322012
bd850db7a49f41ea9149aa08e437f18e	initial_model	UNKNOWN			root	RUNNING	1750059628749	\N		deleted	mlflow-artifacts:/1/bd850db7a49f41ea9149aa08e437f18e/artifacts	1	1750231322012
3d87cb449a754c129baa66c2026c1fb3	initial_model	UNKNOWN			root	RUNNING	1750012065707	\N		deleted	mlflow-artifacts:/1/3d87cb449a754c129baa66c2026c1fb3/artifacts	1	1750231322015
a09d3c7df02f404d8c3d6dc4ba5fb17e	initial_model	UNKNOWN			root	RUNNING	1749984413592	\N		deleted	mlflow-artifacts:/1/a09d3c7df02f404d8c3d6dc4ba5fb17e/artifacts	1	1750231322016
67848caae72e4ab9a29dd0b423e0a8e2	initial_model	UNKNOWN			root	RUNNING	1749982304800	\N		deleted	mlflow-artifacts:/1/67848caae72e4ab9a29dd0b423e0a8e2/artifacts	1	1750231322019
90cdf52da7774146b845f3a73b9b1984	initial_model	UNKNOWN			root	RUNNING	1749979590328	\N		deleted	mlflow-artifacts:/1/90cdf52da7774146b845f3a73b9b1984/artifacts	1	1750231322020
fc5a0a04a861447ca919bbd7c7a3b181	resnet_run	UNKNOWN			root	FAILED	1750233422551	1750233675721		active	mlflow-artifacts:/2/fc5a0a04a861447ca919bbd7c7a3b181/artifacts	2	\N
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.tags (key, value, run_uuid) FROM stdin;
mlflow.user	root	c1160e56f23849bdae1f9f385e49660b
mlflow.source.name	src/train.py	c1160e56f23849bdae1f9f385e49660b
mlflow.source.type	LOCAL	c1160e56f23849bdae1f9f385e49660b
mlflow.runName	initial_model	c1160e56f23849bdae1f9f385e49660b
mlflow.user	root	90cdf52da7774146b845f3a73b9b1984
mlflow.source.name	src/train.py	90cdf52da7774146b845f3a73b9b1984
mlflow.source.type	LOCAL	90cdf52da7774146b845f3a73b9b1984
mlflow.runName	initial_model	90cdf52da7774146b845f3a73b9b1984
mlflow.user	root	f705565f4b2d42bb8ae252d7418395b9
mlflow.source.name	src/train.py	f705565f4b2d42bb8ae252d7418395b9
mlflow.source.type	LOCAL	f705565f4b2d42bb8ae252d7418395b9
mlflow.user	root	67848caae72e4ab9a29dd0b423e0a8e2
mlflow.source.name	src/train.py	67848caae72e4ab9a29dd0b423e0a8e2
mlflow.source.type	LOCAL	67848caae72e4ab9a29dd0b423e0a8e2
mlflow.runName	initial_model	67848caae72e4ab9a29dd0b423e0a8e2
mlflow.user	root	a09d3c7df02f404d8c3d6dc4ba5fb17e
mlflow.source.name	src/train.py	a09d3c7df02f404d8c3d6dc4ba5fb17e
mlflow.source.type	LOCAL	a09d3c7df02f404d8c3d6dc4ba5fb17e
mlflow.runName	initial_model	a09d3c7df02f404d8c3d6dc4ba5fb17e
mlflow.runName	initial_model_50	f705565f4b2d42bb8ae252d7418395b9
mlflow.user	root	0f9d0ae6b94d4052b926c321a67f4872
mlflow.source.name	src/train.py	0f9d0ae6b94d4052b926c321a67f4872
mlflow.source.type	LOCAL	0f9d0ae6b94d4052b926c321a67f4872
mlflow.runName	initial_model	0f9d0ae6b94d4052b926c321a67f4872
mlflow.user	root	321a157e98ee488f8d3160d1f3eb4ab0
mlflow.source.name	src/train.py	321a157e98ee488f8d3160d1f3eb4ab0
mlflow.source.type	LOCAL	321a157e98ee488f8d3160d1f3eb4ab0
mlflow.runName	initial_model	321a157e98ee488f8d3160d1f3eb4ab0
mlflow.user	root	3d87cb449a754c129baa66c2026c1fb3
mlflow.source.name	src/train.py	3d87cb449a754c129baa66c2026c1fb3
mlflow.source.type	LOCAL	3d87cb449a754c129baa66c2026c1fb3
mlflow.runName	initial_model	3d87cb449a754c129baa66c2026c1fb3
mlflow.user	root	90fec5d2c1b941e2b298340ab628ae1a
mlflow.source.name	src/train.py	90fec5d2c1b941e2b298340ab628ae1a
mlflow.source.type	LOCAL	90fec5d2c1b941e2b298340ab628ae1a
mlflow.runName	initial_model	90fec5d2c1b941e2b298340ab628ae1a
mlflow.user	root	ee9b01ad30874357ad534ae40ab232bf
mlflow.source.name	src/train.py	ee9b01ad30874357ad534ae40ab232bf
mlflow.source.type	LOCAL	ee9b01ad30874357ad534ae40ab232bf
mlflow.runName	initial_model	ee9b01ad30874357ad534ae40ab232bf
mlflow.user	root	3614eae808e4435ba235b05e86375ac7
mlflow.source.name	src/train.py	3614eae808e4435ba235b05e86375ac7
mlflow.source.type	LOCAL	3614eae808e4435ba235b05e86375ac7
mlflow.runName	initial_model	3614eae808e4435ba235b05e86375ac7
mlflow.user	root	90bbefe9b36e454fa0aef6fd8c8ef496
mlflow.source.name	src/train.py	90bbefe9b36e454fa0aef6fd8c8ef496
mlflow.source.type	LOCAL	90bbefe9b36e454fa0aef6fd8c8ef496
mlflow.runName	initial_model	90bbefe9b36e454fa0aef6fd8c8ef496
mlflow.user	root	3490d112ca844a5397c0101acceb73b4
mlflow.source.name	src/scripts/train_resnet.py	3490d112ca844a5397c0101acceb73b4
mlflow.source.type	LOCAL	3490d112ca844a5397c0101acceb73b4
mlflow.runName	painted-grouse-322	3490d112ca844a5397c0101acceb73b4
mlflow.user	root	bd850db7a49f41ea9149aa08e437f18e
mlflow.source.name	src/train.py	bd850db7a49f41ea9149aa08e437f18e
mlflow.source.type	LOCAL	bd850db7a49f41ea9149aa08e437f18e
mlflow.runName	initial_model	bd850db7a49f41ea9149aa08e437f18e
mlflow.user	root	0c9be4ca093540d4ae9936b23e0ffec6
mlflow.source.name	src/scripts/train_resnet.py	0c9be4ca093540d4ae9936b23e0ffec6
mlflow.source.type	LOCAL	0c9be4ca093540d4ae9936b23e0ffec6
mlflow.runName	upset-skunk-874	0c9be4ca093540d4ae9936b23e0ffec6
mlflow.user	root	80ac8416bf724a749b8e1ab7f7f36c8b
mlflow.source.name	src/scripts/train_resnet.py	80ac8416bf724a749b8e1ab7f7f36c8b
mlflow.source.type	LOCAL	80ac8416bf724a749b8e1ab7f7f36c8b
mlflow.runName	intelligent-pug-412	80ac8416bf724a749b8e1ab7f7f36c8b
mlflow.user	root	fc5a0a04a861447ca919bbd7c7a3b181
mlflow.source.name	/app/src/train_resnet.py	fc5a0a04a861447ca919bbd7c7a3b181
mlflow.source.type	LOCAL	fc5a0a04a861447ca919bbd7c7a3b181
mlflow.runName	resnet_run	fc5a0a04a861447ca919bbd7c7a3b181
\.


--
-- Data for Name: trace_info; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.trace_info (request_id, experiment_id, timestamp_ms, execution_time_ms, status) FROM stdin;
\.


--
-- Data for Name: trace_request_metadata; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.trace_request_metadata (key, value, request_id) FROM stdin;
\.


--
-- Data for Name: trace_tags; Type: TABLE DATA; Schema: public; Owner: mlflow
--

COPY public.trace_tags (key, value, request_id) FROM stdin;
\.


--
-- Name: experiments_experiment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: mlflow
--

SELECT pg_catalog.setval('public.experiments_experiment_id_seq', 2, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: datasets dataset_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT dataset_pk PRIMARY KEY (experiment_id, name, digest);


--
-- Name: experiments experiment_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiment_pk PRIMARY KEY (experiment_id);


--
-- Name: experiment_tags experiment_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiment_tags
    ADD CONSTRAINT experiment_tag_pk PRIMARY KEY (key, experiment_id);


--
-- Name: experiments experiments_name_key; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiments
    ADD CONSTRAINT experiments_name_key UNIQUE (name);


--
-- Name: input_tags input_tags_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.input_tags
    ADD CONSTRAINT input_tags_pk PRIMARY KEY (input_uuid, name);


--
-- Name: inputs inputs_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.inputs
    ADD CONSTRAINT inputs_pk PRIMARY KEY (source_type, source_id, destination_type, destination_id);


--
-- Name: latest_metrics latest_metric_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.latest_metrics
    ADD CONSTRAINT latest_metric_pk PRIMARY KEY (key, run_uuid);


--
-- Name: logged_model_metrics logged_model_metrics_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_metrics
    ADD CONSTRAINT logged_model_metrics_pk PRIMARY KEY (model_id, metric_name, metric_timestamp_ms, metric_step, run_id);


--
-- Name: logged_model_params logged_model_params_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_params
    ADD CONSTRAINT logged_model_params_pk PRIMARY KEY (model_id, param_key);


--
-- Name: logged_model_tags logged_model_tags_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_tags
    ADD CONSTRAINT logged_model_tags_pk PRIMARY KEY (model_id, tag_key);


--
-- Name: logged_models logged_models_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_models
    ADD CONSTRAINT logged_models_pk PRIMARY KEY (model_id);


--
-- Name: metrics metric_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metric_pk PRIMARY KEY (key, "timestamp", step, run_uuid, value, is_nan);


--
-- Name: model_versions model_version_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_version_pk PRIMARY KEY (name, version);


--
-- Name: model_version_tags model_version_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.model_version_tags
    ADD CONSTRAINT model_version_tag_pk PRIMARY KEY (key, name, version);


--
-- Name: params param_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT param_pk PRIMARY KEY (key, run_uuid);


--
-- Name: registered_model_aliases registered_model_alias_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_pk PRIMARY KEY (name, alias);


--
-- Name: registered_models registered_model_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_models
    ADD CONSTRAINT registered_model_pk PRIMARY KEY (name);


--
-- Name: registered_model_tags registered_model_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tag_pk PRIMARY KEY (key, name);


--
-- Name: runs run_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.runs
    ADD CONSTRAINT run_pk PRIMARY KEY (run_uuid);


--
-- Name: tags tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tag_pk PRIMARY KEY (key, run_uuid);


--
-- Name: trace_info trace_info_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_info
    ADD CONSTRAINT trace_info_pk PRIMARY KEY (request_id);


--
-- Name: trace_request_metadata trace_request_metadata_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_request_metadata
    ADD CONSTRAINT trace_request_metadata_pk PRIMARY KEY (key, request_id);


--
-- Name: trace_tags trace_tag_pk; Type: CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_tags
    ADD CONSTRAINT trace_tag_pk PRIMARY KEY (key, request_id);


--
-- Name: index_datasets_dataset_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_datasets_dataset_uuid ON public.datasets USING btree (dataset_uuid);


--
-- Name: index_datasets_experiment_id_dataset_source_type; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_datasets_experiment_id_dataset_source_type ON public.datasets USING btree (experiment_id, dataset_source_type);


--
-- Name: index_inputs_destination_type_destination_id_source_type; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_inputs_destination_type_destination_id_source_type ON public.inputs USING btree (destination_type, destination_id, source_type);


--
-- Name: index_inputs_input_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_inputs_input_uuid ON public.inputs USING btree (input_uuid);


--
-- Name: index_latest_metrics_run_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_latest_metrics_run_uuid ON public.latest_metrics USING btree (run_uuid);


--
-- Name: index_logged_model_metrics_model_id; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_logged_model_metrics_model_id ON public.logged_model_metrics USING btree (model_id);


--
-- Name: index_metrics_run_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_metrics_run_uuid ON public.metrics USING btree (run_uuid);


--
-- Name: index_params_run_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_params_run_uuid ON public.params USING btree (run_uuid);


--
-- Name: index_tags_run_uuid; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_tags_run_uuid ON public.tags USING btree (run_uuid);


--
-- Name: index_trace_info_experiment_id_timestamp_ms; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_trace_info_experiment_id_timestamp_ms ON public.trace_info USING btree (experiment_id, timestamp_ms);


--
-- Name: index_trace_request_metadata_request_id; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_trace_request_metadata_request_id ON public.trace_request_metadata USING btree (request_id);


--
-- Name: index_trace_tags_request_id; Type: INDEX; Schema: public; Owner: mlflow
--

CREATE INDEX index_trace_tags_request_id ON public.trace_tags USING btree (request_id);


--
-- Name: experiment_tags experiment_tags_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.experiment_tags
    ADD CONSTRAINT experiment_tags_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: datasets fk_datasets_experiment_id_experiments; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT fk_datasets_experiment_id_experiments FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id) ON DELETE CASCADE;


--
-- Name: logged_model_metrics fk_logged_model_metrics_experiment_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_metrics
    ADD CONSTRAINT fk_logged_model_metrics_experiment_id FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: logged_model_metrics fk_logged_model_metrics_model_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_metrics
    ADD CONSTRAINT fk_logged_model_metrics_model_id FOREIGN KEY (model_id) REFERENCES public.logged_models(model_id) ON DELETE CASCADE;


--
-- Name: logged_model_metrics fk_logged_model_metrics_run_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_metrics
    ADD CONSTRAINT fk_logged_model_metrics_run_id FOREIGN KEY (run_id) REFERENCES public.runs(run_uuid) ON DELETE CASCADE;


--
-- Name: logged_model_params fk_logged_model_params_experiment_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_params
    ADD CONSTRAINT fk_logged_model_params_experiment_id FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: logged_model_params fk_logged_model_params_model_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_params
    ADD CONSTRAINT fk_logged_model_params_model_id FOREIGN KEY (model_id) REFERENCES public.logged_models(model_id) ON DELETE CASCADE;


--
-- Name: logged_model_tags fk_logged_model_tags_experiment_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_tags
    ADD CONSTRAINT fk_logged_model_tags_experiment_id FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: logged_model_tags fk_logged_model_tags_model_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_model_tags
    ADD CONSTRAINT fk_logged_model_tags_model_id FOREIGN KEY (model_id) REFERENCES public.logged_models(model_id) ON DELETE CASCADE;


--
-- Name: logged_models fk_logged_models_experiment_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.logged_models
    ADD CONSTRAINT fk_logged_models_experiment_id FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id) ON DELETE CASCADE;


--
-- Name: trace_info fk_trace_info_experiment_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_info
    ADD CONSTRAINT fk_trace_info_experiment_id FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: trace_request_metadata fk_trace_request_metadata_request_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_request_metadata
    ADD CONSTRAINT fk_trace_request_metadata_request_id FOREIGN KEY (request_id) REFERENCES public.trace_info(request_id) ON DELETE CASCADE;


--
-- Name: trace_tags fk_trace_tags_request_id; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.trace_tags
    ADD CONSTRAINT fk_trace_tags_request_id FOREIGN KEY (request_id) REFERENCES public.trace_info(request_id) ON DELETE CASCADE;


--
-- Name: latest_metrics latest_metrics_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.latest_metrics
    ADD CONSTRAINT latest_metrics_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: metrics metrics_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: model_version_tags model_version_tags_name_version_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.model_version_tags
    ADD CONSTRAINT model_version_tags_name_version_fkey FOREIGN KEY (name, version) REFERENCES public.model_versions(name, version) ON UPDATE CASCADE;


--
-- Name: model_versions model_versions_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.model_versions
    ADD CONSTRAINT model_versions_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;


--
-- Name: params params_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.params
    ADD CONSTRAINT params_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- Name: registered_model_aliases registered_model_alias_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_model_aliases
    ADD CONSTRAINT registered_model_alias_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: registered_model_tags registered_model_tags_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.registered_model_tags
    ADD CONSTRAINT registered_model_tags_name_fkey FOREIGN KEY (name) REFERENCES public.registered_models(name) ON UPDATE CASCADE;


--
-- Name: runs runs_experiment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.runs
    ADD CONSTRAINT runs_experiment_id_fkey FOREIGN KEY (experiment_id) REFERENCES public.experiments(experiment_id);


--
-- Name: tags tags_run_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: mlflow
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_run_uuid_fkey FOREIGN KEY (run_uuid) REFERENCES public.runs(run_uuid);


--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 13.21 (Debian 13.21-1.pgdg120+1)
-- Dumped by pg_dump version 13.21 (Debian 13.21-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: mlflow
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO mlflow;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: mlflow
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

