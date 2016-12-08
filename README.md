# Fraiche

## Possible defects

*When you log in for the first time, please log out and log back in as the user is will not be set on creation. this is a slight problem that I tried to fix by re-authenticating the user everytime the ProfileViewController viewWillAppear is called.

*When you click to contact a seller, activity indicator will appear, once it appears click on the page again for the results to appear, I don't know why this is happening, the data loads and is suppoused to setoff an alert view immedietly

## Changes to frameworks suppoused

*Per the project proposal, I was suppoused to use LLSimpleCamera as a 3rd party open source library for AVFoundation camera implementation, I am not doing photos for posts, and never really planned to, not sure why it was there. I used Google Maps instead for reverse geocoding locations from phone to addresses to display on the profile

## Networking issues
*Problem getting user posts from server for now, running on local host works fine and was demonstrated in class
