CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE location_enum AS ENUM ('on the way', 'in stock', 'on examination');
CREATE TYPE status_enum AS ENUM ('own', 'borrowed');
CREATE TYPE exhibition_zone_enum AS ENUM ('Zone A', 'Zone B', 'Zone C');
CREATE TYPE loan_status_enum AS ENUM ('planned', 'in progress', 'closed');
CREATE TYPE examination_result_enum AS ENUM ('damaged', 'broken', 'good');

CREATE TABLE Specimen (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    edited_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    location location_enum DEFAULT 'in stock' NOT NULL,
    status status_enum NOT NULL
);

CREATE TABLE Categories (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    edited_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);

CREATE TABLE Specimen_Categories (
    Categoriesid UUID NOT NULL,
    Specimenid UUID NOT NULL,
    PRIMARY KEY (Categoriesid, Specimenid),
    FOREIGN KEY (Specimenid) REFERENCES Specimen (id) ON DELETE RESTRICT,
    FOREIGN KEY (Categoriesid) REFERENCES Categories (id) ON DELETE RESTRICT
);

CREATE TABLE Institutions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Loans_borrows (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    institution_id UUID NOT NULL,
    specimen_id UUID NOT NULL,
    started_at TIMESTAMPTZ NOT NULL,
    duration INTERVAL NOT NULL,
    return_date TIMESTAMPTZ,
    status loan_status_enum NOT NULL,
    closed_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    edited_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    FOREIGN KEY (institution_id) REFERENCES Institutions (id) ON DELETE RESTRICT,
    FOREIGN KEY (specimen_id) REFERENCES Specimen (id) ON DELETE RESTRICT,
	CHECK (started_at < closed_date),
	CHECK (started_at < return_date)
);

CREATE TABLE Exhibitions (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    start_at TIMESTAMPTZ NOT NULL,
    end_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    edited_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
	CHECK (start_at < end_at)
);


CREATE TABLE Exhibitions_zones (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    exhibition_id UUID NOT NULL,
    zone_name exhibition_zone_enum NOT NULL,
    specimen_id UUID NOT NULL,
    edited_at TIMESTAMPTZ,
    FOREIGN KEY (exhibition_id) REFERENCES Exhibitions (id) ON DELETE CASCADE,
    FOREIGN KEY (specimen_id) REFERENCES Specimen (id) ON DELETE RESTRICT
);



CREATE TABLE Examinations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    specimen_id UUID NOT NULL,
    startdate TIMESTAMPTZ NOT NULL,
    enddate TIMESTAMPTZ NOT NULL,
    results examination_result_enum,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    edited_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    CHECK (startdate < enddate), 
    FOREIGN KEY (specimen_id) REFERENCES Specimen (id) ON DELETE RESTRICT
);
