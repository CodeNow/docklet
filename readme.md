![Alt text](https://circleci.com/gh/CodeNow/docklet.png?circle-token=bef3ad7daf52ec9c1a9e9b6294fc471713700ed2)

Docklet
=======

* Basically this service interacts with a service table where each available service is defined by a row.
* Its job is to listen for service requests (new rows that are added with state == 'request')
* The docklet always wants to run the service if it can do so (until we have some other defined constraints)
* The docklet checks to see if its capable of running the service (the image is cached)
* If the image isn't cached, it pulls it from the main runnable image repo first 
* It tries to run the image (if it was spending time fetching the image, chances are it lost the race)
* If it wins the race, it runs the container and updates the service row to indicate where the service is running
* harbourmaster is listening for where the service becomes available and updates hipache when the service starts
* harbourmaster also responds to the api service request after the front door has been configured to know about it
* we may be able to respond to api server right away and stall on subsequent accesses until the service is ready
* front-door would listen for new rows to be created in the service table and attach front door handlers immediately
* from that point on front door would be listening for changes to the service row and updating redis config

