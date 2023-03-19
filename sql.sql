CREATE TABLE faktury (
    id int(10) unsigned NOT NULL AUTO_INCREMENT,
    created_at timestamp DEFAULT current_timestamp(),
    pracownik varchar(255)NOT NULL,
    dostajacy varchar(255)NOT NULL,
    kwota varchar(255)NOT NULL,
    powod varchar(255)NOT NULL,
    pracownik_steamid varchar(255)NOT NULL,
  	PRIMARY KEY (id)
);