# Sinatra Mailroom

A simple Sinatra application which can be used to send emails for your (probably) static website. Its simple. Post to the "/mail" endpoint, and your message goes somewhere. HTTP BasicAuth is good enough for my anti-spam needs, but your mileage may vary if your site(s) are actually atacked regularly. Replace the BasicAuth with something more robust as you see fit.

Designed for deployment on Heroku or another similar host. Since continually poking your free-tier hosted app to keep it from idling is rude to the host, 
the "/ping" endpoint lets you prewarm the application as needed (perhaps you have Javascript on your contact form which only pings the app to pull it out of idle
when someone begins typing in your form) to ensure a speedy form submission.
