## Chapter 02 - Designing for Operations

### 1. Why is design for operations so important?
Because the majority of the life cycle of the service is spent operating the service. Design for operating from the begining is required to enhace the system against future features


### 2. How is automated configuration typically supported?
It is usually supported by using a text file with a well-defined format. Reading and updating the state can be done through an API or the configuration file.


### 3. List the important factors for redundancy through replication.
- It improves the speed of replies. There are more read access than write access.
- It supports database scaling 
- It provides a backup
- Efficient against database overload


### 4. Give an example of a partially implemented process in your current environment. What would you do to fully implement it?
To imrpove a process I would apply ISO 9001 (simplifying i.e Plan-Do-Check-Act). Always there must be a continuous review of the process to detect errors and lacks and to improve it.


### 5. Why might you not want to solve an issue by coding the solution yourself?
For so many reasons:
- Every company has its own coding standard, internal infrastructure and overall vision of the future software architecture.
- The code can have bugs or imply bugs to the overall system.
- Developers may not need to care about operational features 


### 6. Which type of problems should appear first on your priority list?
Those with higher impact should be first, starting with those who are easier to implement.


### 7. Which factors can you bring to an outside vendor to get the vendor to take your issue seriously?
- Being constructive: vendors are sensitive to criticism of their products
- Use the vendor's software actively
