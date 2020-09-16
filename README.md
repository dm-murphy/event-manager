# Event Manager #

from [The Odin Project](https://www.theodinproject.com/courses/ruby-programming/lessons/event-manager?ref=lnav), an Event Manager program with GoogleCivic API. Adapted from Jump Start Lab.

### Problem ###

Imagine that a friend of yours runs a non-profit org around political activism. A number of people have registered for an upcoming event. She has asked for your help in engaging these future attendees.

Our goal is to get in contact with our event attendees. It is not to define a CSV parser. This is often a hard concept to let go of when initially solving a problem with programming. An important rule to abide by while building software is:

Look for a Solution before Building a Solution

Additionally, the organization would like to know the best time of day to run Google and Facebook advertising. She would like us to report what hours and days of the week have had the most registrations. 

### Project ###

This Event Manager project utilizes [Google's Civic Information API](https://developers.google.com/civic-information/) to look up corresponding districts at each level of government along with names and social media properties for the elected officials in those districts.

This program takes in a CSV file of registration information, parses the content and then uses ERB (Embdedded Ruby) for templating and outputs form letters tailored for each registered person.





