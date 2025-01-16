# Netflix Movie and TV Show Analysis with SQL

![Netflix Logo](./Netflix_logo1.jpg)

## Description
This project aims to analyze Netflix's vast collection of movies and TV shows using SQL. By answering specific questions, we gain insights into the distribution, content variety, and trends in Netflix's library. The dataset used for this analysis was downloaded from Kaggle, and PostgreSQL is used for executing SQL queries.

## Objectives
- To perform an in-depth analysis of Netflix's movie and TV show database.
- To answer key questions about the content in Netflix's library, such as identifying the most frequent ratings, counting the number of movies and TV shows, and exploring various metadata attributes like country, genre, and actors.
- To demonstrate SQL proficiency by creating and executing queries based on real-world data.

## Dataset
The dataset used for this analysis is the Netflix Movies and TV Shows dataset, which is available on Kaggle. You can access and download the dataset from the following link: [Dataset link](https://www.kaggle.com/datasets/shivamb/netflix-shows)

## Technologies Used
- PostgreSQL: Used for data manipulation and query execution.
- Kaggle Dataset: For raw data regarding Netflix's content.

### Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Business Problems and Solutions
### 1. Count the Number of Movies vs TV Shows
```sql
SELECT 
    type,
    COUNT(*)
FROM netflix
GROUP BY 1;
```
### 1. Count the Number of Movies vs TV Shows

