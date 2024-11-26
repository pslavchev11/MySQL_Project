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

[View Database Schema](https://scontent.fsof10-1.fna.fbcdn.net/v/t1.15752-9/462545440_1131648101704191_6180902365819924860_n.png?_nc_cat=102&ccb=1-7&_nc_sid=9f807c&_nc_ohc=Wloli6dxKtkQ7kNvgFAAcsO&_nc_zt=23&_nc_ht=scontent.fsof10-1.fna&oh=03_Q7cD1QHjwPFFqzL7cQkVKYE8zYDuGyDYVPxuBbhorMxXn7Zm2Q&oe=6763C1F7)

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/pslavchev11/MySQL_Project.git

