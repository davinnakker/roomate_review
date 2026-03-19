ALTER DATABASE rmr SET search_path TO rmr;

DROP TABLE IF EXISTS rmr.post_images CASCADE;
DROP TABLE IF EXISTS rmr.posts CASCADE;
DROP TABLE IF EXISTS rmr.buddy CASCADE;
DROP TABLE IF EXISTS rmr.users CASCADE;

-- THIS IS THE SQL USED TO CREATE THE USERS TABLE
CREATE TABLE rmr.users (
    id BIGSERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    pass TEXT NOT NULL,
    email TEXT NOT NULL,
    phone VARCHAR(15)
);

-- THIS IS THE SQL USED TO CREATE THE ROOMMATE TABLE
CREATE TABLE rmr.roommate (
    id BIGSERIAL PRIMARY KEY,
    fk_user BIGINT NOT NULL,
    fk_roommate BIGINT NOT NULL,
    CONSTRAINT fk_roommates_user FOREIGN KEY (fk_user) REFERENCES rmr.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_roommate FOREIGN KEY (fk_roommate) REFERENCES rmr.users(id) ON DELETE CASCADE,
    CONSTRAINT uq_roommate_pair UNIQUE (fk_user, fk_roommate),
    CONSTRAINT chk_not_self CHECK (fk_user <> fk_roommate),
    CONSTRAINT chk_order CHECK (fk_user < fk_roommate)
);
COMMENT ON TABLE rmr.buddy IS 'Stores symmetric buddy relationships: smaller id goes in fk_user, larger in fk_buddy.';

-- THIS IS THE SQL USED TO CREATE THE POSTS TABLE
-- CREATE TABLE rmr.posts (
--     id BIGSERIAL PRIMARY KEY,
--     fk_user BIGINT NOT NULL,
--     content TEXT NOT NULL,
--     created_at TIMESTAMP NOT NULL DEFAULT NOW(),
--     likes INT NOT NULL DEFAULT 0,
--     CONSTRAINT fk_posts_user FOREIGN KEY (fk_user) REFERENCES rmr.users(id) ON DELETE CASCADE
-- );
-- COMMENT ON TABLE rmr.posts IS 'Stores data about what user made what post(s), what the content was, a timestamp, and likes.';

-- THIS IS THE SQL USED TO CREATE THE POST_IMAGES TABLE
CREATE TABLE rmr.post_images (
    id BIGSERIAL PRIMARY KEY,
    fk_post BIGINT NOT NULL,
    image_url TEXT NOT NULL,
    caption TEXT,
    alt_text TEXT,
    position INT DEFAULT 0,
    file_size BIGINT,
    mime_type VARCHAR(50),
    width INT,
    height INT,
    uploaded_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_post_image_post FOREIGN KEY (fk_post) REFERENCES rmr.posts(id) ON DELETE CASCADE
);

-- THIS IS THE SQL USED TO CREATE THE PROFILES TABLE (Editing)
CREATE TABLE rmr.profiles (
    id BIGSERIAL PRIMARY KEY,
    fk_user BIGINT NOT NULL,
    fk_image_id BIGINT NOT NULL,
    biography TEXT,
    CONSTRAINT fk_user FOREIGN KEY (fk_user) REFERENCES rmr.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_image_id FOREIGN KEY (fk_image_id) REFERENCES rmr.post_images(id) ON DELETE CASCADE
);
COMMENT ON TABLE rmr.profiles IS 'Stores the data for all users information that will be used on the profile page.';

-- THIS IS THE SQL USED TO CREATE THE COMMENTS TABLE (Editing)
CREATE TABLE rmr.comments (
    id BIGSERIAL PRIMARY KEY,
    fk_post BIGINT NOT NULL,
    fk_user BIGINT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_comments_user FOREIGN KEY (fk_user) REFERENCES rmr.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_post FOREIGN KEY (fk_post) REFERENCES rmr.posts(id) ON DELETE CASCADE
);