
CREATE TABLE categories_tags (
	tag_id integer NOT NULL,
	category_id integer NOT NULL
);

ALTER TABLE categories_tags
	ADD CONSTRAINT categories_tags_category_id_fkey FOREIGN KEY (category_id) REFERENCES tags(id);

ALTER TABLE categories_tags
	ADD CONSTRAINT categories_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES tags(id);
