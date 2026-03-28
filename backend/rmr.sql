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
    phone VARCHAR(15)

    -- Attributes from image (Ratings 0-9)
    cleanliness SMALLINT CHECK (cleanliness >= 0 AND cleanliness <= 9),
    noise SMALLINT CHECK (noise >= 0 AND noise <= 9),
    considerate SMALLINT CHECK (considerate >= 0 AND considerate <= 9),
    sociability SMALLINT CHECK (sociability >= 0 AND sociability <= 9),
    communication SMALLINT CHECK (communication >= 0 AND communication <= 9),
    
    -- Bio (250 char string)
    bio VARCHAR(250)
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
COMMENT ON TABLE rmr.roommate IS 'Stores symmetric roommate relationships: smaller id goes in fk_user, larger in fk_roommate.';