CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE location_enum AS ENUM ('on the way', 'in stock', 'on examination');
CREATE TYPE status_enum AS ENUM ('own', 'borrowed');
CREATE TYPE exhibition_zone_enum AS ENUM ('Zone A', 'Zone B', 'Zone C');
CREATE TYPE loan_status_enum AS ENUM ('planned', 'in progress', 'closed');
CREATE TYPE examination_result_enum AS ENUM ('damaged', 'broken', 'good');

CREATE TABLE Specimen (
                          id uuid NOT NULL,
                          name varchar(255) NOT NULL,
                          description text,
                          created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
                          edited_at timestamp with time zone,
                          deleted_at timestamp with time zone,
                          location location_enum DEFAULT 'in stock' NOT NULL CHECK (location IN ('on the way', 'in stock', 'on examination')),
                          status status_enum DEFAULT 'own' NOT NULL CHECK (status IN ('own', 'borrowed')),
                          PRIMARY KEY (id)
);

CREATE TABLE Categories (
                            id uuid NOT NULL,
                            name varchar(255) NOT NULL,
                            created_at timestamp with time zone NOT NULL,
                            edited_at timestamp with time zone,
                            deleted_at timestamp with time zone,
                            PRIMARY KEY (id)
);

CREATE TABLE Specimen_Categories (
                                     Categoriesid uuid NOT NULL,
                                     Specimenid uuid NOT NULL,
                                     PRIMARY KEY (Categoriesid, Specimenid),
                                     FOREIGN KEY (Specimenid) REFERENCES Specimen (id) ON DELETE RESTRICT,
                                     FOREIGN KEY (Categoriesid) REFERENCES Categories (id) ON DELETE RESTRICT
);

CREATE TABLE Institutions (
                              id uuid NOT NULL,
                              name varchar(255) NOT NULL,
                              address varchar(255) NOT NULL,
                              type varchar(255) NOT NULL,
                              created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
                              PRIMARY KEY (id)
);

CREATE TABLE Loans_borrows (
                               id uuid NOT NULL,
                               institution_id uuid NOT NULL,
                               specimen_id uuid NOT NULL,
                               started_at timestamp with time zone NOT NULL,
                               duration interval NOT NULL,
                               return_date timestamp with time zone,
                               status loan_status_enum NOT NULL CHECK (status IN ('planned', 'in progress', 'closed')),
                               closed_date timestamp with time zone,
                               created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               edited_at timestamp with time zone,
                               deleted_at timestamp with time zone,
                               PRIMARY KEY (id),
                               FOREIGN KEY (institution_id) REFERENCES Institutions (id) ON DELETE RESTRICT,
                               FOREIGN KEY (specimen_id) REFERENCES Specimen (id) ON DELETE RESTRICT
);

CREATE TABLE Exhibitions (
                             id uuid NOT NULL,
                             name varchar(255) NOT NULL,
                             description text,
                             start_at timestamp with time zone NOT NULL,
                             end_at timestamp with time zone NOT NULL,
                             created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             edited_at timestamp with time zone,
                             deleted_at timestamp with time zone,
                             PRIMARY KEY (id)
);

CREATE TABLE Exhibitions_zones (
                                   id uuid NOT NULL,
                                   exhibition_id uuid NOT NULL,
                                   zone_name exhibition_zone_enum NOT NULL CHECK (zone_name IN ('Zone A', 'Zone B', 'Zone C')),
                                   specimen_id uuid NOT NULL,
                                   edited_at timestamp with time zone,
                                   PRIMARY KEY (id),
                                   FOREIGN KEY (exhibition_id) REFERENCES Exhibitions (id) ON DELETE CASCADE,
                                   FOREIGN KEY (specimen_id) REFERENCES Specimen (id) ON DELETE RESTRICT
);

CREATE TABLE Examinations (
                              id uuid NOT NULL,
                              specimen_id uuid NOT NULL,
                              startdate timestamp with time zone NOT NULL,
                              enddate timestamp with time zone NOT NULL,
                              results examination_result_enum NOT NULL CHECK (results IN ('damaged', 'broken', 'good')),
                              description text,
                              created_at timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
                              edited_at timestamp with time zone,
                              deleted_at timestamp with time zone,
                              PRIMARY KEY (id),
                              FOREIGN KEY (specimen_id) REFERENCES Specimen (id) ON DELETE RESTRICT
);

ALTER TABLE Specimen_Categories ADD CONSTRAINT FKSpecimen_C997512 FOREIGN KEY (Specimenid) REFERENCES Specimen (id);
ALTER TABLE Specimen_Categories ADD CONSTRAINT FKSpecimen_C146712 FOREIGN KEY (Categoriesid) REFERENCES Categories (id);
ALTER TABLE Loans_borrows ADD CONSTRAINT FKLoans_borr383957 FOREIGN KEY (institution_id) REFERENCES Institutions (id);
ALTER TABLE Exhibitions_zones ADD CONSTRAINT FKExhibition608316 FOREIGN KEY (exhibition_id) REFERENCES Exhibitions (id);
ALTER TABLE Examinations ADD CONSTRAINT FKExaminatio782187 FOREIGN KEY (specimen_id) REFERENCES Specimen (id);
ALTER TABLE Loans_borrows ADD CONSTRAINT FKLoans_borr494078 FOREIGN KEY (specimen_id) REFERENCES Specimen (id);
ALTER TABLE Exhibitions_zones ADD CONSTRAINT FKExhibition470926 FOREIGN KEY (specimen_id) REFERENCES Specimen (id);
