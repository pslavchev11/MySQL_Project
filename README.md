# MySQL_Project
A University Project: Forum Database with User Roles, Authentication, and Chronological Comment Tracking

## About
This project is a database design for a forum system, created as part of a MySQL course project. The database supports user authentication, role-based permissions (regular users and administrators), and allows administrators to post articles. Both user types can add comments, with chronological tracking of interactions.

## Features
- Role-based users: Regular users and administrators
- User authentication with usernames and passwords
- Administrators can post articles
- Both user types can post comments
- Comments are tracked chronologically

## Database Schema
### Tables
1. **Users**: Stores user information (username, password, role)
2. **Articles**: Stores articles posted by administrators
3. **Comments**: Stores comments with chronological tracking

### Relationships
- Each article is linked to an administrator in the **Users** table.
- Each comment is linked to a user and an article.

## Database Schema

To view the database schema, click the link below:

[View Database Schema](https://github.com/user-attachments/assets/f9346885-781b-4892-b427-b7794835edaa)

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/pslavchev11/MySQL_Project.git

