## Chapter 04 - Application Architectures

### 1. Describe the single-machine, three-tier, and four-tier web application architectures.

       *Single Machine: In this architecture a single machine serves as a web server.This single machine is self sufficient that it uses HTTP protocal, receives input requests, process them and send response back.The major advantage of this architecture is that it does not involve huge cost to setup this system.. However, it has scalability, configurability and limited resource capacity issues. 
       *Three-tier: This architecture is composed by 3 layers: load balancer, web server and data server.Load balancer will receive requests and then it pass on this requests to web server layer for processing of requests. The web server may or may not interact with the database layer depending upon the request and send responses back to load balancer and then to request originator from there. This type of architectures are usually scalable to meet future demands by adding multiple load balancers, adding more replicas of web servers.
       *Four-tier: This architecture is composed by 4 layers: Load balancer, frontend web, app server and data server.The difference between four-tier and three-tier architecture is that the web server layer is divided in Frontend web and App server.Better encryption and certificate management. There are no limitations of the system but rather such systems require high level of planning of organizing such architecture systems.


### 2. Describe how a single-machine web server, which uses a database to generate content, might evolve to a three-tier web server. How would this be done with minimal downtime?
       To upscale from single mchine web server within minimal down time can be achieved by implementing steps as below:
       *A load balancer must exist. To do this with minimal downtime, the load balancer should be well configured and the web server (and also de data server depending on different parameters and need) should be replicated.  
       *Design a database layer for three-tier and configure it.
       * Data synchronization activitiy between both databases.
       * start routing requests to new web server instead of old server.

### 3. Describe the common web service architectures, in order from smallest to largest.
      * Common web service architectures: Single Machine < three tier < 4 tier

### 4. Describe how different local load balancer types work and what their pros and cons are. You may choose to make a comparison chart.
       *The book introduces 3 types of load balancers: DNS round robin, layer 3 and 4 load balancer, and layer 7 load balancer.
       *DNS Round robbin: Web browser will pick one of the web servers to try at random. This is how load is distributed, It is easy to implement and free. No hardware involved. 
       *Layer 3 and 4 Load Balancer: It receives TCP session and redirects to one of the replicas. It works on network and session layer. Load balancers track ip addresses of source and destination at layer three and tracks ports at layer four. 
       *Layer 7 Load Balancer: It works similar to layer 3 and layer 4 load balancer but works at application level. They can analyze HTTP requets such as cookies, URL and headers etc. and decide where to route such requests. 

### 5. What is �shared state� and how is it maintained between replicas?
       Shared state is information about the requester that is stored somewhere that all web servers can access.
        * Make use of database table on database server where every replica has access. 
        * Design the system to hold the data in RAM e.g. Memcached and Redis.

### 6. What are the services that a four-tier architecture provides in the first tier?
   * Load balancer can handle act as a gateway to receive all requests and route them based on the load balancer configuration to handle requests.
   * Load balancers provide a flexibility to scale the system as per needed. E.g. if there is a need to have more webserves then they can be easily added and removed.
   * Load balancers restricts outside systems to access internal systems directly and implement a security.
   * Load balancers ensure that each request will have a response no matter what. If one web server is down it will route all requests to new server.

### 7. What does a reverse proxy do? When is it needed?
    *A reverse proxy is a user-transparent system that provides web server content from different web servers.
    *The browser feels as if the request was received from a single server but in actual it was sent by reverse proxy server.
    *When we want to isolate original server and its idendity from outside network.
    *Multiple servers can be accessed by single ip address. E.g. more than one server can be access with just one reverse proxy ip.

### 8. Suppose you wanted to build a simple image-sharing web site. How would you design it if the site was intended to serve people in one region of the world? How would you then expand it to work globally?
    *I would try to build a three-tier architecture having a database with high capacity with replication. 
    *To work globally, multiple datacenters should be built in specific areas around the world and also consider replication. In addition a global load balancer must be configured to control the request and forward to the nearest datacenter.

### 9. What is a message bus architecture and how might one be used?
     *Message bus architecture is a many-to-many communication mechanism between servers. It is something like a channel in which one server passes message and all intended servers receives the message.
     *It can be used when a server need to know some changes in another server. Instead of doing a polling, when a change happens the publisher server sends a notification to the subscriber server.

### 10. What is an SOA?
     *SOA stands for service oriented architectures. In general terms SOA is dividing a huge system into small systems where each small system provides a feature or service. 
     *In SOA verious services communicate with each other via API calls. The benfit of SOA is that large services can be managed more easily.

### 11. Why are SOAs loosely coupled?
       * In SOA all services publish themselves as high level of abstraction. That means one service does not know any internals or implementations about another service. It just know the way to make an API call to that service, sending a request and, expected response from that service.

### 12. How would you design an email system as an SOA?
     *Send Email Service: Client browser or application can call this service to send an email.
     *Delete Email Service: If there is a need to delete an email this service will be called.
     *Retrieve Emails Service: Client application will call this service and receive all latest emails using this service.
     *Purge Email Service: Old emails will be purged after this service call.

### 13. Who was Christopher Alexander and what was his contribution to architecture?
      *Christopher Alexander was an architect and desing theorist. His works has influenced the development of agile software development, on programming language design, modular programming, object-oriented programming and software engineering.