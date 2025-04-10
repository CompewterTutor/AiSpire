# Technical Implementation Details

## Technology Stack
This is where we detail the stack and libraries we will be using. Still testing to see if it will be helpful to include documentation links for up-to-date docs on major parts of the stack

## Libraries

## Models

Users
    username:String
    email: String
    password: String
    first_name: String
    last_name: String
    date_added: Datetime
    date_modified: Datetime
    avatar_url: String
    id: auto_increment int (index)
Roles
    type: enum ('admin', 'user')
    date_added: datetime
    date_modified: datetime
    id: autoincrement int (index)
UserRoles
    user_id: int (foreign key)
    roll_id: int (foreign key)
    id: autoincrement int

## Services

## Interfaces

## CI/CD