-- FUNCTION: public.jsonb_test(bigint, bigint, integer, jsonb)

-- DROP FUNCTION public.jsonb_test(bigint, bigint, integer, jsonb);

CREATE OR REPLACE FUNCTION public.jsonb_test(
	var_original_id bigint,
	var_page_id bigint,
	var_from_type integer,
	var_page_posts_data_array jsonb)
    RETURNS boolean
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE
	def_original_id bigint;
	def_page_id bigint;
	def_post_id character varying;
	def_from_type integer;
	def_post_type integer;
	def_application_id bigint;
	def_application_name character varying;
	def_admin_creator_id bigint;
	def_admin_creator_name character varying;
	def_permalink_url character varying;
	def_created_time timestamp with time zone;
	def_updated_time timestamp with time zone;
	def_application jsonb;
	def_admin_creator jsonb;
	def_page_posts_data jsonb;
	text_var1 text;
	text_var2 text;
	text_var3 text;
	ext_var3 text;
--main start
BEGIN
  	FOR def_page_posts_data IN 
    	SELECT * FROM jsonb_array_elements(var_page_posts_data_array)
    LOOP
		def_original_id = var_original_id;
		def_page_id = var_page_id;
		def_post_id = (def_page_posts_data->>'id')::character varying;
		def_from_type = var_from_type;
		def_application = (def_page_posts_data->'application')::jsonb;
		IF def_application is null THEN
			def_application_id = null;
			def_application_name=null;
			def_post_type = 0;
		ELSE
			def_application_id = (def_application->>'id')::bigint;
			def_application_name = (def_application->>'name')::character varying;
			def_post_type = 1;
		END IF;
		def_admin_creator = (def_page_posts_data->'admin_creator')::jsonb;
		IF def_admin_creator is null THEN
			def_admin_creator_id = null;
			def_admin_creator_name = null;
		ELSE
			def_admin_creator_id = (def_admin_creator->>'id')::bigint;
			def_admin_creator_name = (def_admin_creator->>'name')::character varying;
		END IF;
		def_permalink_url = (def_page_posts_data->>'permalink_url')::character varying;
		def_created_time = (def_page_posts_data->>'created_time')::timestamp with time zone;
		def_updated_time = (def_page_posts_data->>'updated_time')::timestamp with time zone;
		--insert start
		BEGIN
			-- INSERT SQL --
		EXCEPTION WHEN unique_violation THEN
			GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
						  text_var2 = PG_EXCEPTION_DETAIL,
						  text_var3 = PG_EXCEPTION_HINT;
			INSERT INTO public.trigger_error_log(
			trigger_name, "MESSAGE_TEXT", "PG_EXCEPTION_DETAIL", "PG_EXCEPTION_HINT")
			VALUES ('jsonb_test', text_var1, text_var2, text_var3);	
		END; 
		--insert end
	END LOOP;
	RETURN TRUE;
END;	
--main end

$BODY$;
