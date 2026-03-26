ALTER DATABASE rmr SET search_path TO rmr;

DROP TABLE IF EXISTS rmr.roommate CASCADE;
DROP TABLE IF EXISTS rmr.users CASCADE;

-- THIS IS THE SQL USED TO CREATE THE USERS TABLE
CREATE TABLE rmr.users (
    id BIGSERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    pass TEXT NOT NULL,
    email TEXT NOT NULL,
    image_url TEXT,
    phone VARCHAR(15),
    manager BOOLEAN DEFAULT FALSE,
    
    -- Bio (250 char string)
    bio VARCHAR(250)
);
COMMENT ON TABLE rmr.users IS 'Stores information about users, including their username, password, email, profile image URL, phone number, and bio.';


CREATE TABLE rmr.attributes (
    -- Attributes from image (Ratings 0-9)
    id BIGSERIAL PRIMARY KEY,
    fk_user BIGINT NOT NULL,

    cleanliness SMALLINT CHECK (cleanliness >= 0 AND cleanliness <= 9),
    noise SMALLINT CHECK (noise >= 0 AND noise <= 9),
    considerate SMALLINT CHECK (considerate >= 0 AND considerate <= 9),
    sociability SMALLINT CHECK (sociability >= 0 AND sociability <= 9),
    communication SMALLINT CHECK (communication >= 0 AND communication <= 9),
    CONSTRAINT fk_attributes FOREIGN KEY (fk_user) REFERENCES rmr.users(id) ON DELETE CASCADE
);
COMMENT ON TABLE rmr.attributes IS 'Stores ratings for each attribute left by other users';

CREATE TABLE rmr.comments (
    id BIGSERIAL PRIMARY KEY,
    fk_user BIGINT NOT NULL,
    fk_commenter BIGINT NOT NULL,
    comment TEXT NOT NULL,
    CONSTRAINT fk_comments_user FOREIGN KEY (fk_user) REFERENCES rmr.users(id) ON DELETE CASCADE,
    CONSTRAINT fk_comments_commenter FOREIGN KEY (fk_commenter) REFERENCES rmr.users(id) ON DELETE CASCADE
);
COMMENT ON TABLE rmr.comments IS 'Stores comments from other roomates';

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
COMMENT ON TABLE rmr.roommate IS 'Stores symmetric roommate relationships: smaller id goes in fk_user, larger in fk_roommate.';

-- CREATE TABLE rmr.apartment (
--     id BIGSERIAL PRIMARY KEY,
--     name TEXT NOT NULL,
--     address TEXT NOT NULL,
--     city TEXT NOT NULL,
--     state TEXT NOT NULL,
--     zip_code VARCHAR(10) NOT NULL,
--     apt_num SMALLINT NOT NULL,
-- );