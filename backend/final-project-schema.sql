CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    middle_name VARCHAR(30),
    email VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    street_number INT NOT NULL,
    street_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL, 
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE UserProfile (
    user_id INT PRIMARY KEY NOT NULL,
    description TEXT,
    family_info TEXT,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE Neighborhoods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    longitude FLOAT NOT NULL, 
    latitude FLOAT NOT NULL
);

CREATE TABLE Blocks (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    neighborhood_id INT NOT NULL,
    description TEXT NOT NULL,
    longitude FLOAT NOT NULL,
    latitude FLOAT NOT NULL,
    FOREIGN KEY (neighborhood_id) REFERENCES Neighborhoods(id)
);

CREATE TABLE MemberBlock (
    user_id INT NOT NULL,
    block_id INT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    PRIMARY KEY (user_id, block_id, created_at),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (block_id) REFERENCES Blocks(id)
);

CREATE TABLE Status (
    id INT SERIAL PRIMARY KEY,
    type VARCHAR(25) NOT NULL
); 

CREATE TABLE Application (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    status_id INT NOT NULL,
    block_id INT NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (block_id) REFERENCES Blocks(id),
    FOREIGN KEY (status_id) REFERENCES Status(id)
);

CREATE TABLE ApplicationResponse (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    application_id INT NOT NULL,
    status_id INT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (application_id) REFERENCES Application(id),
    FOREIGN KEY (status_id) REFERENCES Status(id)
);

CREATE TABLE Follow (
    user_id INT NOT NULL,
    block_id INT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, block_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (block_id) REFERENCES Blocks(id)
);

CREATE TABLE Friend (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (friend_id) REFERENCES Users(id)
);

CREATE TABLE FriendRequest (
    id SERIAL PRIMARY KEY,
    status_id INT NOT NULL,
    user_id INT NOT NULL,
    recipient_id INT NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (recipient_id) REFERENCES Users(id),
    FOREIGN KEY (status_id) REFERENCES Status(id)
);

CREATE TABLE Neighbor (
    user_id INT NOT NULL,
    neighbor_id INT NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, neighbor_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (neighbor_id) REFERENCES Users(id)
);

CREATE TABLE AccessLevel(
   id SERIAL PRIMARY KEY,
   access_type VARCHAR(25) NOT NULL
);

CREATE TABLE Thread (
    id SERIAL PRIMARY KEY,
    access_level_id INT NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    FOREIGN KEY (access_level_id) REFERENCES AccessLevel(id)
);

CREATE TABLE Message (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    created_by INT NOT NULL,
    modified_at TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    message TEXT NOT NULL,
    longitude FLOAT,
    latitude FLOAT,
    thread_id INT NOT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_initial_tread_message BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (created_by) REFERENCES Users(id),
    FOREIGN KEY (thread_id) REFERENCES Thread(id)
);

CREATE TABLE AllowedThreadAccess (
    id SERIAL PRIMARY KEY,
    thread_id INT NOT NULL,
    user_id INT,
    block_id INT,
    neighborhood_id INT,
    FOREIGN KEY (thread_id) REFERENCES Thread(id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (block_id) REFERENCES Blocks(id),
    FOREIGN KEY (neighborhood_id) REFERENCES Neighborhoods(id)
);

CREATE TABLE AccessTimeLog (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    login_time TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE ReadReceipt (
    user_id INT NOT NULL,
    message_id INT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_id, message_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (message_id) REFERENCES Message(id)
);
