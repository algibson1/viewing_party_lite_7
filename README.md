# Viewing Party

This is built from the [Viewing Party Lite project](https://backend.turing.edu/module3/projects/viewing_party_lite) used for Turing's Backend Module 3.

### About this Project

Viewing Party Lite is an application in which users can explore movie options and create a viewing party event for themselves and other users of the application.

Example wireframes for the project are found [here](https://backend.turing.edu/module3/projects/viewing_party_lite/wireframes)

## Project Timeline
Project originally assigned Monday, August 21st as a pair project. Most of the functionality was built in a 5-day sprint as a pair, and turned in Friday, August 25th.

Additional functionality and refactoring has been a solo project.
#### Solo Additions 
- Refactor: Created MoviesController, rearranged methods, views, routes, and files to improve overall RESTfulness of app
- Bug Fix: Viewing Party can correctly validate it is not scheduled in the past
- Implemented Basic Authentication: Users have passwords and can log in. Routes were all refactored appropriately to no longer include user id in the url.

## Ideas For Further Work
- Refactor error handling
- Viewing Parties can automatically expire/be deleted after their scheduled time has passed
- Users can update their personal information (change name, email, and password)
- Users can update or delete viewing parties
- Users can have profile images. The logged-in user's image appears in the heading on all pages. All other users' images appear
- Users can search for other users and add them as a friend. Then only friends are listed in the options to invite people to a party, instead of displaying every user in system
- On a user's dashboard, parties that are "happening today", "starting soon", and/or "happening now" are in their own section at the top, or have some other indicator 
- Front-end work to improve visuals of application
- Users can create a list of favorite movies
- Users can create a list of movies they eventually want to watch
- If a list is on 2+ users' to-watch list, it appears for each user with the message "(Other users) also want to watch this movie! Want to schedule a viewing party?"