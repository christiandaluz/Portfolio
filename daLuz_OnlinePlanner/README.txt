Completed 17 May 2018 for Senior Seminar course
Final Grade for Course: A

This project was completed for Adelphi University's semester-long Senior Seminar course in preparation
for graduation. 

An original implementation of an online planning application was created using PostgreSQL, PHP, HTML, and CSS.

Users of the application were able to access the planner at the (now defunct) website http://compsci.adelphi.edu/~ssplanner. 
Users would first make an account and then login in, from which point they were able to create categories and add activities
to those categories. Both categories and activities could be modified or deleted at a later time.

A secure login system was created in which the browser would hash the user's password input using the SHA-256 cryptographic 
hash algorithm which would then be compared to the user's password hash stored in the database, i.e. the database 
would never store the user's password in plaintext.
