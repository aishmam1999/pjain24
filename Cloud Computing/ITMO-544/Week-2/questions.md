### 1. What is distributed computing?
 Distributed computing are composed by hundred or thousand of machines working together to provide a service.


### 2. Describe the three major composition patterns in distributed computing.
* Load balancer with multiple backed replicas: Load balancer receive all requests and forward them to the accurate backend service. The load balancer manages very backend

* Server with multiple backends: A server receives the query and forward it to different backends (content servers). Then the server receives the backend's replies and compose them into a final reply.

* Server tree: This composition consists of one server with multiple backends. Here the request received by server will be divided into different tasks and each tasks is performed by different backends. Server will combine output of each backend to produce the final response for the request received.

### 3. What are the three patterns discussed for storing state? 
(Database System)
The state is sharden
* Storing the state on one machine
* Shardening the state and storing it on multiple machines.
* Master server receives the request. It replies to the client with a list of machines which have the data.

### 4. Sometimes a master server does not reply with an answer but instead replies with where the answer can be found. What are the benefits of this method?

The main benefit is the master server does not become overleaded due to receiving and relaying huge datasets.


### 5. Section 1.4 describes a distributed file system, including an example of how reading terabytes of data would work. How would writing terabytes of data work?

"There is a distributed file system with petabytes of data spread out over thousands of machines. Each file is split into gigabyte-sized chunks. Each chunk is stored on multiple machines for redundancy. A master server tracks the list of files and identiies where their chunks are."

Following the example of how reading terabytes of data would work, the writing process would be similar to the reading:
1. The master server receives the writing request
2. The master determines which machines have chunks of files
3. The master replies with a list of which machines have the data.

This process has been simplified. This writing process would involve:
- The client has to contact every machine who has any chunk of file, or at least those machines which have the chunk of files being modified.
- The client must be able to compose the file, avoiding replicated data.


### 6. Explain the CAP Principle. (If you think the CAP Principle is awesome, read “The Part-Time Parliament” (Lamport & Marzullo 1998) and “Paxos Made Simple” (Lamport 2001).)
CAP stands for consistency, availability and partition resistance. The CAP Principle states that only one or two of the CAP terms can be achieved by a distributed system.

* Consistency: commits are atomic across the entire distributed system
* Availability: the system remains accessible and operational at all times 
* Partitioning Tolerance:  only a total network failure can cause the system to respond incorrectly

### 7. What does it mean when a system is loosely coupled? What is the advantage of these systems?
Loosely coupled system is one in which each of its components has little or no knowledge of the definitions of other separate components.

When a system is loosely coupled means that each component of the system provides an interface so the other components have little or not knowledge of the internals of the former component.
The main advantage of these systems is their ease to evolve and change over time.

### 8. Give examples of loosely and tightly coupled systems you have experience with. What makes them loosely or tightly coupled? (if you haven't worked on any use a system you have seen or used)

A system which has a temperature sensor, depending on the importance of this sensor to the system, it would be a loosely or tightly coupled system.

For example if the information provided by a temperature sensor is required to activate some kind of mechanism, it would be a tightly coupled one because this sensor is necessary for the correct working of the system. However, if the componen which has the sensor provides other kind of functions that are not important for the system, it would be a loosely one.


### 9. How do we estimate how fast a system will be able to process a request such as retrieving an email message?
Illustrating all steps that the process requires and estimating the worst time each action can take, following a list of time and actions.
	

### 10. In Section 1.7 three design ideas are presented for how to process email deletion requests. Estimate how long the request will take for deleting an email message for each of the three designs. First outline the steps each would take, then break each one into individual operations until estimates can be created.
Example for the book (Retrieve a message from the message storage system and display it).
300 ms budget


  * Design 1: Delete the message from server and delete index.
     
     * Client sends delete request to server - 75 ms
     * Request authentication - 3ms
     * Delete request in server - 100 ms
     * Delete index - 30 ms to locate and delete time we can ignore as it will be in ns.
     * Response back to client - 75 ms

        Total: 283 ms


  * Design 2: Delete the index as deleted for a message and later remove index marked as delete to reduce index size.

     * Client sends delete request to server - 75 ms
     * Request authentication - 3 ms
     * Delete index - 30 ms to locate and delete time we can ignore as it will be in ns
     * Response back to client - 75 ms

        Total: 183 ms

  * Design 3: Client send a delete request to server and places a delete request in queue for deleting. Without waiting for queue process to happen client gets a success message about deletion of the message.

     * Client sends delete request to server - 75 ms
     * Request authentication - 3ms
     * Request placed in a queue - This time we can ignore as it will be in ns
     * Response back to client- 75 ms

       Total: 153 ms


