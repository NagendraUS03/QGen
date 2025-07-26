
use myDB;
CREATE TABLE Subjects (
    Subject_ID INT AUTO_INCREMENT PRIMARY KEY,
    Sub_Name VARCHAR(255) NOT NULL,
    Scheme int,
    Sub_Code VARCHAR(50),
    Semester INT NOT NULL,
    Credits INT,
    Learning_Hours INT,
    Total_Marks INT
);
CREATE TABLE Modules (
    Mod_ID INT AUTO_INCREMENT PRIMARY KEY,
    Subject_ID INT NOT NULL,
    Module_Name VARCHAR(255) NOT NULL,
    Module_Number INT NOT NULL,
    Total_Marks INT,
    FOREIGN KEY (Subject_ID) REFERENCES Subjects(Subject_ID) ON DELETE CASCADE
);
CREATE TABLE Questions (
    Question_ID INT AUTO_INCREMENT PRIMARY KEY,
    Mod_ID INT NOT NULL,
    Question_Text TEXT NOT NULL,
    Marks INT NOT NULL,
    Difficulty ENUM('Easy', 'Medium', 'Hard') NOT NULL,
    Bloom_Taxonomy ENUM('L1', 'L2', 'L3') NOT NULL,
    FOREIGN KEY (Mod_ID) REFERENCES Modules(Mod_ID) ON DELETE CASCADE
);

CREATE TABLE Generated_Papers (
    Gp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Sub_ID INT NOT NULL,
    Date_Created DATETIME DEFAULT CURRENT_TIMESTAMP,
    Marks_Distribution JSON,
    Fitness_Score FLOAT,
    FOREIGN KEY (Sub_ID) REFERENCES Subjects(Subject_ID) ON DELETE CASCADE
);

CREATE TABLE Paper_Questions (
    Pq_ID INT AUTO_INCREMENT PRIMARY KEY,
    Paper_ID INT NOT NULL,
    Question_ID INT NOT NULL,
    FOREIGN KEY (Paper_ID) REFERENCES Generated_Papers(Gp_ID) ON DELETE CASCADE,
    FOREIGN KEY (Question_ID) REFERENCES Questions(Question_ID) ON DELETE CASCADE
);

CREATE TABLE Used_Questions (
    Uq_ID INT AUTO_INCREMENT PRIMARY KEY,
    Question_ID INT NOT NULL,
    Subject_ID INT NOT NULL,
    Semester INT NOT NULL,
    Exam_Cycle VARCHAR(20) NOT NULL,
   FOREIGN KEY (Question_ID) REFERENCES Questions(Question_ID) ON DELETE CASCADE,
    FOREIGN KEY (Subject_ID) REFERENCES Subjects(Subject_ID) ON DELETE CASCADE
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
use myDB;
INSERT INTO Subjects (Subject_ID, Sub_Name, Scheme, Sub_Code, Semester, Credits, Learning_Hours, Total_Marks) VALUES
(1, 'Applied Physics for CSE stream', 2022, 'BPHYS102', 1, 4, 50, 100),
(2, 'Principles of Programming Using C', 2022, 'BPOPS103', 1, 3, 40, 100),
(3, 'Introduction to Electronics  Communication', 2022, 'BESCK204C', 2, 3, 40, 100),
(4, 'Applied Chemistry for CSE Stream', 2022, 'BCHES202', 2, 4, 50, 100),
(5, 'Data Structures and Applications', 2022, 'BCS304', 3, 3, 40, 100),
(6, 'Operating Systems', 2022, 'BCS303', 3, 4, 60, 100),
(7, 'Microcontroller and Embedded Systems', 2021, '21CS43', 4, 4, 60, 100),
(8, 'Operating Systems', 2021, '21CS44', 4, 3, 40, 100),
(9, 'Computer Networks', 2021, '21CS52', 5, 4, 60, 100),
(10, 'Database Management System', 2021, '21CS53', 5, 3, 40, 100),
(11, 'Full Stack Development', 2021, '21CS62', 6, 4, 60, 100),
(12, 'Software Engineering & Project Management', 2021, '21CS61', 6, 3, 40, 100);

SELECT * FROM Subjects;

INSERT INTO Modules(Subject_ID, Module_Name, Module_Number,Total_Marks) VALUES('7','Micro-processor versus Micro-controllers,ARM Embedded systems,ARM processor fundamentals','1','20'),('7','Introduction to ARM instruction set, C compilers and optimisation','2','20'),('7','Ccompiler and Optimisation, ARM programming using assembly languages','3','20'),('7','Embedded system components','4','20'),('7','RTOS and IDE for embedded system designs', '5','20');
INSERT INTO Modules(Subject_ID, Module_Name, Module_Number,Total_Marks) VALUES('8','Introduction to operating system,System structures, operating system services, process management','1','20'),('8','Multi threaded programming, process synchronisation','2','20'),('8','Deadlocks, Memory management','3','20'),('8','Virtual memory management, file system, implementation of file system','4','20'),('8','Secondary storage structures, protection, Case study: The Linux OS', '5','20');
INSERT INTO Modules(Subject_ID, Module_Name, Module_Number,Total_Marks) VALUES('9','Introduction to Networks,Physical layer','1','20'),('9','The datalink layer, The medium access control sublayer','2','20'),('9','The Network layer','3','20'),('9','The transport layer','4','20'),('9','Application layer', '5','20');
INSERT INTO Modules(Subject_ID, Module_Name, Module_Number,Total_Marks) VALUES('10','Introduction to Databases, Overview of database languages and architecture,Conceptual data modelling using entity and relationships','1','20'),('10','Relatiional model, Relational algebra,Mapping conceptual design into a logical design','2','20'),('10','SQL,Advanced query,Application development','3','20'),('10','Normalisation: Database design theory,Normalisation Algorithms','4','20'),('10','Transaction processing, Concurrancy control in databases', '5','20');
INSERT INTO Modules(Subject_ID, Module_Name, Module_Number,Total_Marks) VALUES('11','MVC based web designing','1','20'),('11','Django templates and models','2','20'),('11','Django admin interfaces and model forms','3','20'),('11','Generic views and Django state persistance','4','20'),('11','JQuery and AJAX integration in Django', '5','20');
INSERT INTO Modules(Subject_ID, Module_Name, Module_Number,Total_Marks) VALUES('12','Introduction of Software Engineering, process models, Requirements Engineering','1','20'),('12','Modelling concepts and Class modelling, Building the analysis models','2','20'),('12','Software testing, Ajile methodology and Devops','3','20'),('12','Introduction to project management','4','20'),('12','Activity planning, Software quality', '5','20');

SELECT * from Modules;

-- Physics: Module 1--

INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(1, 'Define LASER and Discuss the interaction of radiation with matter.', 6, 'Easy', 'L1'),  
(1, 'Define the Acceptance angle and Numerical Aperture and, hence, derive an expression for NA in terms of RIs core, cladding, and surrounding.', 8, 'Medium', 'L2'),  
(1, 'A LASER source has a power output of 10-3 W. Calculate the number of photons emitted per second given the wavelength of LASER 692.8 nanometer.', 6, 'Medium', 'L2'),  
(1, 'Illustrate the construction and operation of a Semiconductor LASER with a neat sketch and energy level diagram, and also mention its applications.', 10, 'Hard', 'L3'),  
(1, 'Discuss the types of optical fibres based on Modes of Propagation and RI profile.', 7, 'Medium', 'L2'),  
(1, 'Obtain the attenuation coefficient of the given fibre of length 1500 m given the input and output power 100 mW and 70 mW.', 8, 'Medium', 'L2'),  
(1, 'Obtain the expression for Energy Density using Einstein’s A and B coefficients and thus conclude on B12=B21.', 10, 'Hard', 'L3'),  
(1, 'Describe attenuation and explain the various fibre losses.', 7, 'Medium', 'L2'),  
(1, 'Given the Numerical Aperture 0.30 and RI of core 1.49 Calculate the critical angle for the core-cladding interface.', 6, 'Easy', 'L1'),  
(1, 'Discuss the applications of LASER in bar-code scanners and LASER Cooling.', 8, 'Medium', 'L2'),  
(1, 'Discuss Point-to-point communication using optical fibers.', 7, 'Medium', 'L2'),  
(1, 'Calculate the ratio of population for a given pair of energy levels corresponding to the emission of radiation 694.3 nm at a temperature of 300K.', 10, 'Hard', 'L3');  

-- Physics: Module 2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(2, 'Setup SchrÖdinger time independent wave equation in one dimension.', 6, 'Medium', 'L2'),  
(2, 'State and Explain Heisenberg’s Uncertainty principle and Principle of Complementarity.', 6, 'Easy', 'L1'),  
(2, 'An electron has kinetic energy 500 keV in vacuum. Calculate the group velocity and de Broglie wavelength assuming the mass of the moving electron is equal to the rest mass of electron.', 10, 'Hard', 'L3'),  
(2, 'Discuss the motion of a quantum particle in a one-dimensional infinite potential well of width ‘a’ and also obtain the eigen functions and energy eigen states.', 10, 'Hard', 'L3'),  
(2, 'Explain the physical significance of the Wave Function.', 4, 'Easy', 'L1'),  
(2, 'The speed of an electron is measured within an uncertainty of 2 × 10^4 ms−1 in one dimension. What is the minimum width required by the electron to be confined in an atom?', 8, 'Medium', 'L2'),  
(2, 'Derive an expression for de Broglie wavelength by analogy and hence discuss the significance of de Broglie waves.', 7, 'Medium', 'L2'),  
(2, 'Explain the Wave function with mathematical form and discuss its physical significance.', 6, 'Medium', 'L2'),  
(2, 'Calculate the energy of the first three states for an electron in a one-dimensional potential well of width 0.1 nm.', 10, 'Hard', 'L3'),  
(2, 'Explain Eigen functions and Eigen Values and derive the eigen function of a particle inside an infinite potential well of width ‘a’ using the method of normalization.', 10, 'Hard', 'L3'),  
(2, 'Show that an electron does not exist inside the nucleus using Heisenberg’s uncertainty principle.', 8, 'Medium', 'L2'),  
(2, 'An electron is associated with a de Broglie wavelength of 1 nm. Calculate the energy and the corresponding momentum of the electron.', 7, 'Medium', 'L2');

-- Physics: Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES 
(3, 'Discuss the working of phase gate mentioning its matrix representation and truth table.', 10, 'Hard', 3),
(3, 'Explain Orthogonality and Orthonormality with an example for each.', 8, 'Medium', 2),
(3, 'Explain the representation of qubit using Bloch Sphere.', 6, 'Easy', 1),
(3, 'Explain Single qubit gate and multiple qubit gate with an example for each.', 10, 'Hard', 3),
(3, 'Explain the Matrix representation of 0 and 1 States and apply identity operator I to | 0 and | 1 states.', 7, 'Medium', 2),
(3, 'Define a bit and qubit and explain the properties of qubit.', 6, 'Easy', 1),
(3, 'Discuss the CNOT gate and its operation on four different input states.', 8, 'Medium', 2),
(3, 'A Linear Operator X operates such that X |0 = |1 and X |1 = |0. Find the matrix representation of X.', 7, 'Medium', 2),
(3, 'State the Pauli matrices and apply Pauli matrices on the states |0⟩ and |1⟩.', 6, 'Easy', 1),
(3, 'Elucidate the differences between classical and quantum computing.', 10, 'Hard', 3),
(3, 'Describe the working of controlled-Z gate mentioning its matrix representation and truth-table.', 12, 'Hard', 3);

-- Physics: Module 4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(4, 'Enumerate the failures of classical free electro theory and assumptions of quantum free electron theory of metals.', 6, 'Medium', 'L2'),  
(4, 'Explain Meissner’s Effect and the variation of critical field with temperature.', 8, 'Hard', 'L3'),  
(4, 'A superconducting tin has a critical temperature of 3.7 K at zero magnetic field and a critical field of 0.0306 Tesla at 0 K. Find the critical field at 2 K.', 7, 'Medium', 'L2'),  
(4, 'Explain the phenomenon of superconductivity and Discuss qualitatively the BCS theory of superconductivity for negligible resistance of metal at temperatures close to absolute zero.', 10, 'Hard', 'L3'),  
(4, 'Give the qualitative explanation of RF Squid with the help of a neat sketch.', 6, 'Medium', 'L2'),  
(4, 'Find the temperature at which there is 1% probability that a state with an energy 0.5 eV above Fermi energy is occupied.', 8, 'Hard', 'L3'),  
(4, 'Define Fermi Factor and Discuss the variation of Fermi factor with temperature and energy.', 6, 'Medium', 'L2'),  
(4, 'Explain DC and AC Josephson effects and mention the applications of superconductivity in quantum computing.', 10, 'Hard', 'L3'),  
(4, 'Calculate the probability of occupation of an energy level 0.2 eV above fermi level at temperature 27°C.', 7, 'Medium', 'L2'),  
(4, 'Describe Meissner’s Effect and hence classify superconductors into Soft and Hard superconductors using M-H graphs.', 8, 'Hard', 'L3'),  
(4, 'Enumerate the assumptions of Quantum free Electron Theory of Metals.', 6, 'Medium', 'L2'),  
(4, 'Lead has superconducting transition temperature of 7.26 K. If the initial field at 0K is 50 × 103 Am-1, Calculate the critical field at 6K.', 8, 'Hard', 'L3');

-- Physics: Module 5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(5, 'Elucidate the importance of size & scale and weight and strength in animations.', 6, 'Medium', 'L2'),  
(5, 'Mention the general pattern of Monte Carlo method and hence determine the value of π.', 10, 'Hard', 'L3'),  
(5, 'Describe the calculation of Push time and stop time with examples.', 6, 'Medium', 'L2'),  
(5, 'Sketch and explain the motion graphs for linear, easy ease, easy ease in and easy ease out cases of animation.', 8, 'Hard', 'L3'),  
(5, 'Discuss modeling the probability for proton decay.', 8, 'Hard', 'L3'),  
(5, 'A slowing-in object in an animation has a first frame distance 0.5m and the first slow-in frame 0.35m. Calculate the base distance and the number of frames in sequence.', 7, 'Medium', 'L2'),  
(5, 'Discuss timing in Linear motion, Uniform motion, slow in and slow out.', 6, 'Medium', 'L2'),  
(5, 'Distinguish between descriptive and inferential statistics.', 4, 'Easy', 'L1'),  
(5, 'Illustrate the odd rule and odd rule multipliers with a suitable example.', 6, 'Medium', 'L2'),  
(5, 'Describe Jumping and parts of jump.', 4, 'Easy', 'L1'),  
(5, 'Discuss the salient features of Normal distribution using bell curves.', 8, 'Hard', 'L3'),  
(5, 'The number of particles emitted per second by a random radioactive source has a Poisson\'s distribution with λ = 4. Calculate the probability of P(X = 0) and P(X = 1).', 10, 'Hard', 'L3');

SELECT * FROM Questions;

-- POP: Module 1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(6, 'Define computer. Describe the various types of computers based on speed, memory and cost.', 6, 'Easy', 'L1'),  
(6, 'Develop an algorithm to find the area and perimeter of a circle. Also define an algorithm.', 8, 'Medium', 'L2'),  
(6, 'Write a short note on the characteristics of a computer.', 4, 'Easy', 'L1'),  
(6, 'What is a variable? What are the rules to construct a variable? Classify the following as valid/invalid Identifiers: num2, $num1, +add, a_2, 199_space, _apple, #12.', 6, 'Medium', 'L2'),  
(6, 'Draw a flowchart and C program which takes as input p, t, r. Compute the simple interest and display the result.', 10, 'Hard', 'L3'),  
(6, 'Write a note on the following operators: Relational, Logical, Conditional.', 6, 'Medium', 'L2'),  
(6, 'Define a computer and explain its components in detail.', 6, 'Easy', 'L1'),  
(6, 'Write an algorithm to find the largest of three numbers and explain its steps.', 8, 'Medium', 'L2'),  
(6, 'List and describe the basic characteristics of a computer.', 4, 'Easy', 'L1'),  
(6, 'Define a variable and explain the rules for naming variables. Classify the following as valid or invalid identifiers: data_1, @num, 1value, _start, value#12, __name.', 6, 'Medium', 'L2'),  
(6, 'Write a flowchart and a C program to calculate the area of a rectangle given its length and breadth.', 10, 'Hard', 'L3'),  
(6, 'Explain with examples the usage of different types of operators in C: Arithmetic, Bitwise, Assignment.', 8, 'Medium', 'L2');

-- POP: Module 2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(7, 'Write a C program to solve a quadratic equation by computing its roots. Handle all cases for real and complex roots.', 10, 'Hard', 'L3'),  
(7, 'Explain the concept of a `goto` statement with syntax and an example program.', 6, 'Medium', 'L2'),  
(7, 'Describe the syntax of the `switch` statement and provide an example illustrating its use.', 6, 'Medium', 'L2'),  
(7, 'Write a simple C program to create a menu-driven calculator using the `switch` statement.', 8, 'Hard', 'L3'),  
(7, 'Explain the concept of formatted input and output functions (`scanf` and `printf`) with suitable examples.', 6, 'Medium', 'L2'),  
(7, 'Illustrate the working of `if` and `if-else` statements in C with syntax and examples.', 6, 'Medium', 'L2'),  
(7, 'Develop a C program that takes three coefficients (a, b, and c) of a quadratic equation (ax²+bx + c) as input and compute all possible roots and print them with appropriate messages.', 10, 'Hard', 'L3'),  
(7, 'Explain the working of goto statement in C with example.', 6, 'Medium', 'L2'),  
(7, 'Explain switch statement with syntax and example.', 6, 'Medium', 'L2'),  
(7, 'Develop a simple calculator program in C language to do simple operations like addition, subtraction, multiplication and division. Use switch statement in your program.', 8, 'Hard', 'L3'),  
(7, 'Explain with examples formatted input output statements in C.', 6, 'Medium', 'L2'),  
(7, 'Explain with syntax, if and if-else statements in C program.', 6, 'Medium', 'L2');

-- POP: Module 3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(8, 'Develop a program in C to swap two numbers using both call by value and call by reference methods.', 7, 'Medium', 'L2'),  
(8, 'Describe how user-defined functions are implemented in C, with an example.', 6, 'Medium', 'L2'),  
(8, 'Write a C program to multiply two matrices and display the result.', 10, 'Hard', 'L3'),  
(8, 'Explain the concept of recursion with a suitable example program.', 8, 'Hard', 'L3'),  
(8, 'Provide the syntax and examples for declaring and initializing one-dimensional and two-dimensional arrays in C.', 6, 'Medium', 'L2'),  
(8, 'Define an Array. Explain with example. How to declare and initialize 2D array.', 6, 'Medium', 'L2'),  
(8, 'Write a C program to search an element using binary search technique.', 8, 'Hard', 'L3'),  
(8, 'Write a C program to perform addition of 2-dimensional matrix(3x3 ordered matrices A and B).', 8, 'Hard', 'L3'),  
(8, 'Define function. Explain the type of functions based on parameters.', 6, 'Medium', 'L2'),  
(8, 'Write a C program to sort the elements using bubble sort technique by passing array as function argument.', 10, 'Hard', 'L3');

-- POP: Module 4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(9, 'Write a program to concatenate two strings in C without using any library function.', 8, 'Hard', 'L3'),  
(9, 'Define strings in C and explain any four string handling functions with examples.', 6, 'Medium', 'L2'),  
(9, 'Compare the `scanf` and `gets()` functions in terms of usage and limitations.', 4, 'Easy', 'L1'),  
(9, 'Write a C program to find the largest of three numbers using pointers.', 6, 'Medium', 'L2'),  
(9, 'Define pointers in C. Discuss how pointer variables are declared and initialized with an example.', 6, 'Medium', 'L2'),  
(9, 'Differentiate between null pointers and void pointers, giving suitable examples.', 4, 'Easy', 'L1'),  
(9, 'Define a string. List the string manipulation functions. Explain any two with examples.', 6, 'Medium', 'L2'),  
(9, 'Write a C program to find the length of a given string without using built-in function.', 8, 'Hard', 'L3'),  
(9, 'Write a C program to check whether the given string is palindrome or not without using built-in function.', 8, 'Hard', 'L3'),  
(9, 'Write a C program using pointers to compute the sum, mean and standard deviation of all elements stored in an array of ‘n’ real numbers.', 10, 'Hard', 'L3'),  
(9, 'Write a C program to replace each consonant in a string with the next letter except after ‘z’, ‘Z’, ‘a’, and ’A’. For example, the string “Corona Virus” should be modified as “DpSpoa Wjsvt”.', 12, 'Hard', 'L3');

-- POP: Module 5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(10, 'Discuss the syntax for defining and declaring a structure to store details of a student (e.g., name, age, and marks).', 6, 'Medium', 'L2'),  
(10, 'Differentiate between structures and unions in C.', 6, 'Medium', 'L2'),  
(10, 'Write a program in C to create a file to store employee data. Then, read the details of a specific employee based on input and calculate their bonus.', 10, 'Hard', 'L3'),  
(10, 'Explain the different file operation modes in C with examples.', 6, 'Medium', 'L2'),  
(10, 'Compare the `gets()` and `fgets()` functions, and explain their usage with examples.', 7, 'Medium', 'L2'),  
(10, 'Write a C program using structures to compute and display the average marks of N students. List the students scoring above and below the average.', 10, 'Hard', 'L3'),  
(10, 'Differentiate between Structure and Union.', 6, 'Medium', 'L2'),  
(10, 'Write a C program to implement structures to read and write Book-Title, Book-Author, and Book-Id of n books.', 8, 'Hard', 'L3'),  
(10, 'Write a note on files.', 4, 'Easy', 'L1'),  
(10, 'List and explain any four file operations in C.', 6, 'Medium', 'L2'),  
(10, 'Write a C program to store and print Name, USN, Subject, and IA marks of students using Structure.', 10, 'Hard', 'L3'),  
(10, 'Write a note on enumerated data type.', 4, 'Easy', 'L1');

SELECT * FROM Questions;

-- EC: Module 1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(11, 'What is a regulated power supply? With a neat block diagram, summarize the working of a DC power supply. Also, mention the principal components used in each block.', 8, 'Medium', 'L2'),  
(11, 'Discuss the need of a filter circuit. With a circuit diagram and waveforms, briefly explain the operation of a smoothing filter for full-wave rectifiers.', 10, 'Hard', 'L3'),  
(11, 'With a neat diagram, summarize the working principle of the voltage divider bias CE amplifier with feedback.', 8, 'Medium', 'L2'),  
(11, 'A 5V zener diode has a maximum rated power dissipation of 500mW. If the diode is to be used in a simple regulator circuit to supply a regulated 5V to a load having a resistance of 500 Ω, determine a suitable value of series resistor for operation in conjunction with a supply of 9V.', 10, 'Hard', 'L3'),  
(11, 'What is a voltage multiplier and mention its applications? With a circuit diagram, explain the operation of a voltage Tripler circuit.', 8, 'Medium', 'L2'),  
(11, 'Illustrate how BJT is used as a switch.', 6, 'Medium', 'L2'),  
(11, 'With an appropriate circuit diagram, explain the working of a half-wave rectifier.', 6, 'Medium', 'L2'),  
(11, 'A mains transformer having a turns ratio of 44:1 is connected to a 220V r.m.s. mains supply. If the secondary output is applied to a half-wave rectifier, determine the peak voltage that will appear across a load.', 10, 'Hard', 'L3'),  
(11, 'What is the need for reservoir and smoothing circuits? Explain.', 6, 'Medium', 'L2'),  
(11, 'Explain the working of a half-wave rectifier with a reservoir capacitor along with relevant waveforms.', 8, 'Medium', 'L2');

-- EC: Module 2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(12, 'Sketch the circuits of each of the following based on use of Operational Amplifier a) Differentiator. b) Integrator.', 8, 'Hard', 'L3'),  
(12, 'Write a note on Ideal characteristics of Op-Amp.', 6, 'Medium', 'L2'),  
(12, 'Explain the operation of Single stage Astable Oscillator with its circuit diagram.', 8, 'Hard', 'L3'),  
(12, 'Mention the condition of sustained oscillations. Determine the frequency of oscillations of a three-stage ladder network in which C=10nF and R=10KΩ.', 10, 'Hard', 'L3'),  
(12, 'With a neat circuit diagram and waveforms, describe the operation of Crystal controlled Oscillator.', 7, 'Medium', 'L2'),  
(12, 'With a neat circuit diagram explain single stage Multivibrators.', 6, 'Medium', 'L2'),  
(12, 'A phase-shift oscillator is to operate with an output at 1 kHz. If the oscillator is based on a three-stage ladder network, determine the required values of resistance if three capacitors of 10 nF are to be used.', 10, 'Hard', 'L3'),  
(12, 'With circuit diagram, explain the operation of a Wien bridge oscillator.', 8, 'Hard', 'L3'),  
(12, 'An operational amplifier operating with negative feedback produces an output voltage of 2 V when supplied with an input of 400 μV. Determine the value of closed-loop voltage gain.', 7, 'Medium', 'L2'),  
(12, 'With a neat circuit diagram and waveforms, describe the operation of crystal controlled oscillator.', 6, 'Medium', 'L2');

-- EC : Module 3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(13, 'With the help of truth table explain the operation of Full Adder with its circuit diagram and reduce the expression for Sum and carry.', 10, 'Hard', 'L3'),  
(13, 'Mention the different theorems and Postulates of Boolean Algebra and Prove each of them with truth table.', 8, 'Hard', 'L3'),  
(13, 'Subtract using (r-1)’s complement method: 1. 4456(10) - 34234(10) 2. 101010(2) - 1000100(2).', 7, 'Medium', 'L2'),  
(13, 'Convert the following: 1. 3A6.C58D(16) to Octal, 2. 0.6875(10) to Binary, 3. Compute the 9’s complement of 25.639(10), 4. Compute the 1’s complement of 11101.0110(2).', 8, 'Medium', 'L2'),  
(13, 'State and prove De-Morgan’s Theorem with its truth table.', 6, 'Medium', 'L2'),  
(13, 'Minimize the following function: F(x,y,z) = xy+x’z+yz.', 6, 'Medium', 'L2'),  
(13, 'Find the complement of the function F1 and F2. F1(x,y,z) = x’yz’+x’y’z and F2(x,y,z)=x(y’z’+yz’).', 8, 'Hard', 'L3'),  
(13, 'Perform the following operations: 1. 1101 − 0101 using 2’s complement method, 2. 0110 − 0010 using 2’s complement method, 3. 924 − 126 using 9’s complement method, 4. 265 − 424 using 10’s complement method.', 7, 'Medium', 'L2'),  
(13, 'Mention any 3 theorems of Boolean algebra and prove each of them.', 6, 'Medium', 'L2'),  
(13, 'Mention the postulates and theorems of Boolean algebra.', 4, 'Easy', 'L1');

-- EC: Module 4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(14, 'Compare Embedded Systems and General Computing Systems, also provide the applications of Embedded systems.', 10, 'Hard', 'L3'),  
(14, 'Write a note on core of an Embedded system with its block diagram.', 6, 'Medium', 'L2'),  
(14, 'Write a note on Transducers? Explain one type of Sensor and Actuator with its operation.', 8, 'Medium', 'L2'),  
(14, 'Explain how a 7-segment display can be used to display data and write a brief note on the operation of LED.', 7, 'Medium', 'L2'),  
(14, 'What is an Embedded system? Brief about the different elements of an Embedded system.', 6, 'Medium', 'L2'),  
(14, 'Write a note on classification of Embedded systems.', 4, 'Easy', 'L1'),  
(14, 'Mention the classification of embedded systems based on complexity and performance.', 6, 'Medium', 'L2'),  
(14, 'Explain the classification of embedded systems based on generation.', 7, 'Medium', 'L2'),  
(14, 'Explain major application areas of embedded systems.', 8, 'Hard', 'L3'),  
(14, 'Write a short note on Sensors, Actuators, and 7-segment LED display.', 6, 'Medium', 'L2');

-- EC: Module 5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(15, 'Draw the block diagram of a basic communication system and briefly explain the individual blocks.', 6, 'Medium', 'L2'),  
(15, 'With a neat block diagram of a basic communication system, explain the modern communication system scheme.', 8, 'Hard', 'L3'),  
(15, 'Brief about modern communication system with its block diagram.', 6, 'Medium', 'L2'),  
(15, 'Write a note on Amplitude Modulation, Frequency Modulation, and Phase Modulation.', 7, 'Medium', 'L2'),  
(15, 'Write a note on different types of modulation and briefly describe each in detail.', 8, 'Hard', 'L3'),  
(15, 'Define Amplitude Modulation. Explain amplitude modulation (AM) with necessary waveforms.', 6, 'Medium', 'L2'),  
(15, 'What is modulation? Explain amplitude modulation (AM) and frequency modulation (FM) with neat diagrams.', 10, 'Hard', 'L3'),  
(15, 'Define amplitude and frequency modulation. Sketch AM and FM waveforms.', 6, 'Medium', 'L2'),  
(15, 'Describe the blocks of the basic communication system.', 4, 'Easy', 'L1'),  
(15, 'Explain with a neat diagram, the concept of radio wave propagation and its different types.', 8, 'Hard', 'L3'),  
(15, 'Describe radio signal transmission and multiple access techniques.', 10, 'Hard', 'L3');

SELECT * FROM Questions;

-- CHEM: Module1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(16, 'What are chemical fuels? Explain the determination of calorific value of fuel using a Bomb calorimeter.', 6, 'Medium', 'L2'),  
(16, '0.945g of a fuel on complete combustion in excess of oxygen increased temperature of water in a calorimeter from 13.25° C to 19.2° C. The mass of water in the calorimeter was 1458 g. Calculate GCV if the water equivalent of the calorimeter is 144g.', 10, 'Hard', 'L3'),  
(16, 'Explain the construction and working of a Lithium-ion battery along with its applications.', 6, 'Medium', 'L2'),  
(16, 'Explain the production of hydrogen by the electrolysis method, and mention its advantages.', 6, 'Medium', 'L2'),  
(16, 'Explain the construction and working of a photovoltaic cell along with its advantages.', 7, 'Medium', 'L2'),  
(16, 'Explain the construction and working of a Methanol-oxygen fuel cell with acid electrolyte.', 8, 'Hard', 'L3'),  
(16, 'Explain the working principle of potentiometry sensors and thermal sensors (Flame photometer).', 6, 'Medium', 'L2'),  
(16, 'Write a note on Disposable Sensors. Explain their advantages over classical sensors.', 6, 'Medium', 'L2'),  
(16, 'Describe the construction, working, and applications of Sodium-ion batteries and mention any four applications.', 8, 'Hard', 'L3'),  
(16, 'Explain the working principle of Electrochemical sensors and mention their applications.', 7, 'Medium', 'L2'),  
(16, 'What are Actuators & Transducers? Explain the detection of Glyphosate with electrochemical oxidation.', 10, 'Hard', 'L3'),  
(16, 'What are batteries? Explain the working principle, properties, and applications of Quantum Dot-sensitized solar cells.', 8, 'Hard', 'L3');

-- CHEM: Module2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(17, 'Define metallic corrosion? Describe the electrochemical theory of corrosion taking iron as an example.', 8, 'Medium', 'L2'),  
(17, 'Explain: Differential metal corrosion and Water-line corrosion.', 6, 'Medium', 'L2'),  
(17, 'Describe galvanizing and mention its applications.', 6, 'Medium', 'L2'),  
(17, 'What is CPR? A thick brass sheet of area 400 inch² is exposed to moist air. After 2 years, it was found to experience a weight loss of 375 g due to corrosion. If the density of brass is 8.73 g/cm³, calculate CPR in mpy and mmpy.', 10, 'Hard', 'L3'),  
(17, 'What is metal finishing? Mention any five of its technological importance.', 6, 'Medium', 'L2'),  
(17, 'Mention any four properties and applications of QLED.', 4, 'Easy', 'L1'),  
(17, 'Explain the types of organic memory devices by taking p-type and n-type semiconductor materials.', 8, 'Hard', 'L3'),  
(17, 'What are Memory Devices? Explain the Classification of electronic memory devices with examples.', 8, 'Medium', 'L2'),  
(17, 'What are nanomaterials? Explain any four properties of Poly[9-vinylcarbazole] (PVK) suitable for optoelectronic devices.', 10, 'Hard', 'L3'),  
(17, 'Explain the types of organic memory devices by taking p-type and n-type semiconductor materials.', 8, 'Hard', 'L3'),  
(17, 'Mention any four properties and applications of LCD-displays.', 4, 'Easy', 'L1'),  
(17, 'Mention any four properties and applications of OLED.', 4, 'Easy', 'L1');

-- CHEM: Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(18, 'Explain the synthesis of Polyvinylchloride and mention its applications.', 6, 'Medium', 'L2'),  
(18, 'A polydisperse sample of polystyrene is prepared by mixing three monodisperse samples in the following proportions. With effect from 2022 of 10000 molecular weight, 2g of 50000 molecular weight and 2g of 100000 molecular weight. Determine number average and weight average molecular weight.', 10, 'Hard', 'L3'),  
(18, 'Explain the synthesis of Teflon and mention its applications.', 6, 'Medium', 'L2'),  
(18, 'Explain the synthesis of Polystyrene and mention its applications.', 6, 'Medium', 'L2'),  
(18, 'Explain the Condensation method of polymerisation with an example.', 8, 'Hard', 'L3'),  
(18, 'Describe properties and applications of Lubricants.', 6, 'Medium', 'L2'),  
(18, 'Define corrosion? Mention at least six implications of corrosion.', 6, 'Medium', 'L2'),  
(18, 'Explain Differential metal corrosion and Water-line corrosion.', 7, 'Medium', 'L2'),  
(18, 'Explain the construction and working of a glass electrode.', 8, 'Hard', 'L3'),  
(18, 'Explain the application of conductometric electrode in estimation of weak acid.', 8, 'Hard', 'L3'),  
(18, 'Explain corrosion control by Anodization and Sacrificial anodic method.', 7, 'Medium', 'L2'),  
(18, 'What is CPR? A thick brass sheet of area 100 inch² is exposed to moist air. After 1 year, it was found to experience a weight loss of 75 g due to corrosion. If the density of brass is 2.52 g/cm³, calculate CPR in mpy and mmpy.', 10, 'Hard', 'L3');

-- CHEM: Module4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(19, 'Define phase, components & degree of freedom.', 4, 'Easy', 'L1'),  
(19, 'Explain the principle, instrumentation and working of potentiometric sensor.', 8, 'Hard', 'L3'),  
(19, 'Explain the process of estimation of copper in industrial waste by using optical sensor.', 7, 'Medium', 'L2'),  
(19, 'Explain along with diagram Lead-silver two component system.', 6, 'Medium', 'L2'),  
(19, 'Explain the principle, instrumentation and working of Glass electrode.', 8, 'Hard', 'L3'),  
(19, 'Explain the principle, instrumentation and working of colorimetry.', 6, 'Medium', 'L2'),  
(19, 'A polydisperse sample of polystyrene is prepared by mixing three monodisperse samples in the following proportions: 1g of 10000 molecular weight, 2g of 50000 molecular weight, and 2g of 100000 molecular weight. Determine number average and weight average molecular weight. Find the index of polydispersity.', 10, 'Hard', 'L3'),  
(19, 'Explain the preparation, properties, and commercial applications of Kevlar.', 8, 'Hard', 'L3'),  
(19, 'Describe the hydrogen production by photo catalytic water splitting method.', 7, 'Medium', 'L2'),  
(19, 'Describe the hydrogen production by photo catalytic water splitting method.', 7, 'Medium', 'L2'),  
(19, 'Mention the properties of hydrogen pertaining to fuel and its advantages in production of energy.', 6, 'Medium', 'L2'),  
(19, 'What are green fuels? Explain the advantages & disadvantages of photovoltaic cells.', 10, 'Hard', 'L3');

-- CHEM: Module5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(20, 'Define Alloys. Explain the composition along with properties of Brass.', 6, 'Medium', 'L2'),  
(20, 'Explain the synthesis of Nanomaterials by Sol-gel method.', 8, 'Hard', 'L3'),  
(20, 'Explain size-dependent properties of nanomaterials with respect to surface area, catalytic and thermal.', 10, 'Hard', 'L3'),  
(20, 'Define Alloys. Explain the composition along with properties of AlNiCo.', 6, 'Medium', 'L2'),  
(20, 'Explain the chemical composition, properties, and applications of perovskites.', 8, 'Hard', 'L3'),  
(20, 'Explain the properties and applications of carbon nanotubes and graphene.', 10, 'Hard', 'L3'),  
(20, 'What is e-waste? Explain the need for e-waste management.', 6, 'Medium', 'L2'),  
(20, 'Explain the health hazards due to exposure to e-waste.', 7, 'Medium', 'L2'),  
(20, 'Write a brief note on the role of stakeholders (producers, consumers, recyclers, and statutory bodies).', 6, 'Medium', 'L2'),  
(20, 'List the toxic materials used in manufacturing electrical and electronic products and explain their effects on the environment.', 8, 'Hard', 'L3'),  
(20, 'Explain the advantages of recycling and recovery in e-waste.', 6, 'Medium', 'L2'),  
(20, 'Explain the sources, composition, and characteristics of e-waste.', 8, 'Hard', 'L3');

SELECT * FROM Questions;

-- DSA: Module1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(21, 'Define data structures. With a neat diagram, explain the classification of data structures with examples.', 6, 'Medium', 'L2'),  
(21, 'What do you mean by pattern matching? Outline the Knuth Morris Pratt (KMP) algorithm and illustrate it to find the occurrences of the pattern: P: ABCDABD, S: ABC ABCDAB ABCDABCDABDE.', 8, 'Hard', 'L3'),  
(21, 'Write a program in C to implement push, pop, and display operations for stacks using arrays.', 10, 'Hard', 'L3'),  
(21, 'Explain in brief the different functions of dynamic memory allocation.', 6, 'Medium', 'L2'),  
(21, 'Write functions in C for the following operations without using built-in functions: Compare two strings, Concatenate two strings, Reverse a string.', 8, 'Hard', 'L3'),  
(21, 'Write a function to evaluate the postfix expression. Illustrate the same for the given postfix expression: ABC-D*+E$F+ (A=6, B=3, C=2, D=5, E=1, F=7).', 10, 'Hard', 'L3'),  
(21, 'Differentiate between structures and unions. Provide examples for both.', 6, 'Medium', 'L2'),  
(21, 'What do you mean by pattern matching? Outline the Knuth-Morris-Pratt pattern matching algorithm.', 8, 'Hard', 'L3'),  
(21, 'Define stack. Give the implementation of Push(), Pop(), and Display() functions, considering their empty and full conditions.', 7, 'Medium', 'L2'),  
(21, 'Write an algorithm to evaluate a postfix expression and apply it to the given postfix expression: 6 2 / 3 - 4 2 * +.', 8, 'Hard', 'L3'),  
(21, 'Write the postfix form of the following using a stack: A*(B*C+D*E)+F.', 6, 'Medium', 'L2'),  
(21, 'Write the postfix form of the following using a stack: (a+(b∗c)/(d−e)).', 6, 'Medium', 'L2');

-- DSA: Module2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(22, 'Develop a C program to implement insertion, deletion and display operations on Linear queue.', 10, 'Hard', 'L3'),  
(22, 'Write a program in C to implement a stack of integers using a singly linked list.', 10, 'Hard', 'L3'),  
(22, 'Write a C program to implement insertion, deletion and display operations on a circular queue.', 10, 'Hard', 'L3'),  
(22, 'Write the C function to add two polynomials. Show the linked representation of the below two polynomials and their addition using a circular singly linked list.', 12, 'Hard', 'L3'),  
(22, 'What are the disadvantages of an ordinary queue? Discuss the implementation of a circular queue.', 6, 'Medium', 'L2'),  
(22, 'Write a note on multiple stacks and priority queues.', 6, 'Medium', 'L2'),  
(22, 'Define Queue. Discuss how to represent a queue using dynamic arrays.', 7, 'Medium', 'L2'),  
(22, 'What is a linked list? Explain the different types of linked lists with neat diagrams.', 8, 'Hard', 'L3'),  
(22, 'Give the structure definition for a singly linked list (SLL). Write a C function to Insert an element at the end of SLL and Delete a node at the beginning of SLL.', 10, 'Hard', 'L3');

-- DSA: Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(23, 'Write recursive C functions for in-order, pre-order, and post-order traversals of a binary tree. Also, find all the traversals for the given tree.', 10, 'Hard', 'L3'),  
(23, 'Write C functions for searching an element in a singly linked list and concatenating two singly linked lists.', 8, 'Medium', 'L2'),  
(23, 'Define the Sparse matrix. For the given sparse matrix, give the linked list representation.', 7, 'Medium', 'L2'),  
(23, 'Write C functions for inserting a node at the beginning of a doubly linked list and deleting a node at the end of a doubly linked list.', 8, 'Medium', 'L2'),  
(23, 'Define Binary tree. Explain the representation of a binary tree with a suitable example.', 6, 'Medium', 'L2'),  
(23, 'Define the Threaded binary tree. Construct a Threaded binary tree for the following elements: A, B, C, D, E, F, G, H, I.', 10, 'Hard', 'L3'),  
(23, 'Write a C function for the addition of an element at a specific position and deletion of a node in a doubly linked list (DLL).', 8, 'Medium', 'L2'),  
(23, 'Explain binary trees. Write a C program for the pre-order traversal of a binary tree.', 7, 'Medium', 'L2'),  
(23, 'Define binary search trees (BST). Write a C function to insert and delete an element in BST.', 10, 'Hard', 'L3'),  
(23, 'Discuss the applications of binary trees with examples.', 6, 'Medium', 'L2');

-- DSA: Module4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(24, 'Design an algorithm to traverse a graph using Depth First Search (DFS). Apply DFS for the given graph.', 10, 'Hard', 'L3'),  
(24, 'Construct a binary tree from the given Post-order and In-order sequence: In-order: GDHBAEICF, Post-order: GHDBIEFCA.', 10, 'Hard', 'L3'),  
(24, 'Define selection tree. Construct a min-winner tree for the runs of a game and find the first 5 winners.', 8, 'Hard', 'L3'),  
(24, 'Define Binary Search Tree (BST). Construct a BST for the given elements: 100, 85, 45, 55, 120, 20, 70, 90, 115, 65, 130, 145. Perform in-order, pre-order, and post-order traversal.', 10, 'Hard', 'L3'),  
(24, 'Define Forest. Transform the given forest into a Binary Tree and traverse using in-order, pre-order, and post-order traversal.', 8, 'Hard', 'L3'),  
(24, 'Define the Disjoint Set. Consider the tree created by the weighted union function with the given sequence of unions. Process the simple find and collapsing find on eight finds and compare their efficiency.', 8, 'Hard', 'L3'),  
(24, 'What is hashing? Explain the concept of collision and collision resolution techniques.', 6, 'Medium', 'L2'),  
(24, 'Write a C function to implement linear probing.', 7, 'Medium', 'L2'),  
(24, 'Define AVL trees. Explain the rotations used to balance an AVL tree.', 8, 'Hard', 'L3'),  
(24, 'Write a C program to search for an element in a Binary Search Tree (BST).', 7, 'Medium', 'L2'),  
(24, 'Compare AVL trees and Binary Search Trees. Discuss their advantages and disadvantages.', 6, 'Medium', 'L2'),  
(24, 'Explain B-trees with their properties. How are keys inserted and deleted in a B-tree?', 10, 'Hard', 'L3');

-- DSA: Module5-- 
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(25, 'What is chained hashing? Discuss its pros and cons. Construct the hash table to insert the keys: 7, 24, 18, 52, 36, 54, 11, 23 in a chained hash table of 9 memory locations. Use h(k) = k mod m.', 10, 'Hard', 'L3'),  
(25, 'Define the leftist tree. Give its declaration in C. Check whether the given binary tree is a leftist tree or not. Explain your answer.', 8, 'Hard', 'L3'),  
(25, 'What is dynamic hashing? Explain the following techniques with examples: Dynamic hashing using directories, Directory-less dynamic hashing.', 8, 'Hard', 'L3'),  
(25, 'What is a Priority queue? Demonstrate functions in C to implement the Max Priority queue with an example. Insert, Delete, and Display the Max priority queue.', 10, 'Hard', 'L3'),  
(25, 'Define hashing. Explain different hashing functions with examples.', 6, 'Medium', 'L2'),  
(25, 'Discuss the properties of a good hash function.', 6, 'Medium', 'L2'),  
(25, 'Explain Dijkstra’s algorithm with an example.', 8, 'Hard', 'L3'),  
(25, 'Define graph traversal. Write a C program to perform Breadth-First Search (BFS).', 10, 'Hard', 'L3'),  
(25, 'Explain Depth-First Search (DFS) and its applications with an example.', 8, 'Hard', 'L3'),  
(25, 'Discuss Kruskal’s algorithm for finding the minimum spanning tree with an example.', 8, 'Hard', 'L3'),  
(25, 'What are adjacency matrices and adjacency lists? Compare their advantages and disadvantages.', 6, 'Medium', 'L2'),  
(25, 'Explain Prim’s algorithm. How does it differ from Kruskal’s algorithm?', 7, 'Medium', 'L2');

SELECT * FROM Questions;

-- OS: Module1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(26, 'Explain layered approach. Mention its advantages and disadvantages.', 6, 'Medium', 'L2'),  
(26, 'Explain microkernel approach. What are its benefits?', 6, 'Medium', 'L2'),  
(26, 'Explain the concept of graceful degradation and fault tolerance in a multiprocessor system.', 8, 'Hard', 'L3'),  
(26, 'Define virtual machine. With a neat diagram, explain the working of a virtual machine.', 8, 'Hard', 'L3'),  
(26, 'What are the benefits of a virtual machine?', 6, 'Medium', 'L2'),  
(26, 'Define the essential properties of the following types of operating systems: time-sharing, distributed, real-time, and multiprogramming.', 7, 'Medium', 'L2'),  
(26, 'What is the difference between ha rd real-time and soft real-time systems?', 6, 'Medium', 'L2'),  
(26, 'Explain the different services that an operating system provides.', 6, 'Medium', 'L2'),  
(26, 'What are the five major activities of an operating system with regard to process management?', 8, 'Hard', 'L3'),  
(26, 'Explain the multiprocessor system.', 6, 'Medium', 'L2'),  
(26, 'Describe the difference between symmetric and asymmetric multiprocessing.', 7, 'Medium', 'L2'),  
(26, 'Explain the distinguishing features of real-time systems and multiprocessor systems.', 7, 'Medium', 'L2'),  
(26, 'Explain the function of memory management.', 6, 'Medium', 'L2'),  
(26, 'What is the purpose of system calls management?', 6, 'Medium', 'L2'),  
(26, 'What are the main purposes of an operating system?', 4, 'Easy', 'L1');
 
-- OS: Module2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(27, 'Describe the structure of PCB.', 6, 'Medium', 'L2'),  
(27, 'Explain the following: short-term, medium-term, and long-term scheduler.', 6, 'Medium', 'L2'),  
(27, 'Explain the Shortest Job First (SJF) algorithm.', 8, 'Hard', 'L3'),  
(27, 'Explain priority scheduling algorithm.', 8, 'Hard', 'L3'),  
(27, 'What is a process? With a state diagram, explain the states of a process. Also, write the structure of a Process Control Block.', 10, 'Hard', 'L3'),  
(27, 'Explain the CPU scheduling criteria.', 6, 'Medium', 'L2'),  
(27, 'Explain the Round Robin scheduling algorithm.', 7, 'Medium', 'L2'),  
(27, 'What are the benefits of multithreaded programming?', 6, 'Medium', 'L2'),  
(27, 'Four batch jobs P1, P2, P3, P4 arrive at the computer center at almost the same time. The estimated running times are 10, 8, 2, 4 ms. The priorities are 3, 4, 1, 2. The time quantum is 2ms. Draw the Gantt chart and compute the average waiting time and average turnaround time using the following scheduling algorithms: FCFS, SJF (non-preemptive), Priority, and Round Robin.', 12, 'Hard', 'L3'),  
(27, 'Compare the user-level thread and kernel-level thread.', 6, 'Medium', 'L2'),  
(27, 'Explain the multithreading model.', 6, 'Medium', 'L2');

-- OS: Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(28, 'Explain semaphores. State the dining philosopher problem and give the solution for the same using semaphores.', 10, 'Hard', 'L3'),  
(28, 'Describe the bounded buffer problem and give the solution for the same using semaphores. Write the structure of producer and consumer process.', 10, 'Hard', 'L3'),  
(28, 'Explain in brief race condition.', 6, 'Medium', 'L2'),  
(28, 'Define the term critical section? What are the requirements for critical section problems.', 6, 'Medium', 'L2'),  
(28, 'Give the solution for readers/writers problem using semaphore.', 10, 'Hard', 'L3'),  
(28, 'Explain Peterson’s algorithm.', 7, 'Medium', 'L2'),  
(28, 'Explain deadlock prevention methods in detail.', 8, 'Hard', 'L3'),  
(28, 'Answer the following questions using Banker’s algorithm: What is the content of need matrix, determine if the system is in a safe state, and check if a request from process P1 for (0,4,2,0) can be granted immediately.', 12, 'Hard', 'L3'),  
(28, 'Explain deadlock detection and deadlock recovery in detail.', 8, 'Hard', 'L3'),  
(28, 'Describe the Banker’s algorithm for deadlock avoidance.', 8, 'Hard', 'L3'),  
(28, 'What are the necessary conditions for deadlock to occur?', 6, 'Medium', 'L2'),  
(28, 'Explain the resource allocation graph.', 6, 'Medium', 'L2'),  
(28, 'State the dining philosopher problem and give the solution for the same using monitors.', 10, 'Hard', 'L3');

-- OS: Module4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(29, 'Explain shared pages?', 4, 'Easy', 'L1'),  
(29, 'Explain hashed page table.', 6, 'Medium', 'L2'),  
(29, 'Explain segmentation. Compare paging and segmentation.', 8, 'Hard', 'L3'),  
(29, 'Explain the concept of swapping. Why is it required?', 6, 'Medium', 'L2'),  
(29, 'Explain best fit and first fit algorithm for dynamic partitioned memory management.', 7, 'Medium', 'L2'),  
(29, 'Explain internal and external fragmentation with a neat diagram.', 8, 'Hard', 'L3'),  
(29, 'What is paging? Explain with a neat diagram.', 6, 'Medium', 'L2'),  
(29, 'Explain Translation Lookaside Buffer (TLB) with a neat diagram.', 7, 'Medium', 'L2'),  
(29, 'Explain inverted page table with a diagram.', 8, 'Hard', 'L3'),  
(29, 'Explain segmentation with a neat diagram.', 6, 'Medium', 'L2'),  
(29, 'Describe the following allocation algorithms: First Fit, Best Fit, Worst Fit.', 8, 'Hard', 'L3'),  
(29, 'With a diagram, discuss the steps involved in handling a page fault.', 8, 'Hard', 'L3'),  
(29, 'Explain thrashing.', 6, 'Medium', 'L2'),  
(29, 'Consider the following page reference string: 2,3,2,1,5,2,4,5,3,2,5,2. How many page faults would occur in case of LRU, FIFO, and Optimal page replacement algorithms assuming 3 frames (initially empty)?', 10, 'Hard', 'L3'),  
(29, 'Explain the different page replacement algorithms.', 8, 'Hard', 'L3'),  
(29, 'Explain demand paging. Give advantage and disadvantage of demand paging.', 6, 'Medium', 'L2'),  
(29, 'Write a note on virtual memory.', 4, 'Easy', 'L1');

-- OS:Module5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(30, 'Explain different file access methods.', 6, 'Medium', 'L2'),  
(30, 'Describe the working of the following allocation methods: Contiguous and Linked.', 7, 'Medium', 'L2'),  
(30, 'With a neat diagram, describe: Tree-structured directory and Acyclic graph directory.', 8, 'Hard', 'L3'),  
(30, 'What do you mean by a free space list? With suitable examples, explain any two methods of implementing a free space list.', 6, 'Medium', 'L2'),  
(30, 'With suitable examples, explain different methods of implementing a free space list.', 7, 'Medium', 'L2'),  
(30, 'List the common file types along with their extensions and functions.', 4, 'Easy', 'L1'),  
(30, 'Explain in detail file attributes.', 6, 'Medium', 'L2'),  
(30, 'Describe the working of the following allocation methods: Contiguous and Indexed.', 7, 'Medium', 'L2'),  
(30, 'Explain the various directory structures.', 6, 'Medium', 'L2'),  
(30, 'What are the operations possible on a file?', 4, 'Easy', 'L1'),  
(30, 'Explain the access matrix method of system protection with domain as objects and its implementation.', 10, 'Hard', 'L3'),  
(30, 'Consider a disk queue with requests for I/O to blocks on cylinder 98, 183, 37, 122, 14, 124, 65, 67. If the disk head starts at 53, calculate the total head movement for FCFS, SSTF, SCAN, C-SCAN, and LOOK scheduling.', 10, 'Hard', 'L3'),  
(30, 'Suppose that a disk drive has 5000 cylinders, numbered 0 through 4999. The drive is serving a request at cylinder 143. The queue of pending requests in FIFO order is: 86, 1470, 913, 1774, 948, 1509, 1022, 1750, 130. Calculate the total distance (in cylinders) that the disk arm moves to satisfy all the pending requests for each of the following scheduling algorithms: FCFS, SSTF, SCAN, LOOK, C-SCAN, C-LOOK.', 12, 'Hard', 'L3'),  
(30, 'Explain in detail about an overview of mass storage structure.', 8, 'Hard', 'L3'),  
(30, 'Explain SCAN, C-SCAN, and LOOK scheduling techniques.', 8, 'Hard', 'L3'),  
(30, 'Explain the various disk scheduling algorithms with examples.', 8, 'Hard', 'L3');

SELECT * FROM Questions;

-- MCES: Module1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(31, 'Explain with a neat diagram, about the ARM core data flow model.', 8, 'Hard', 'L3'),  
(31, 'Define RISC architecture. Compare with CISC processors.', 6, 'Medium', 'L2'),  
(31, 'Define pipelining. Explain how it helps the program execution.', 6, 'Medium', 'L2'),  
(31, 'Explain the major design rules related to the implementation of the RISC philosophy.', 7, 'Medium', 'L2'),  
(31, 'Explain the ARM core dataflow model and mention the different registers of ARM processors.', 8, 'Hard', 'L3'),  
(31, 'Differentiate between CISC and RISC. Explain the four major rules of RISC design.', 7, 'Medium', 'L2'),  
(31, 'With the help of a basic layout diagram, explain the current program status register.', 8, 'Hard', 'L3'),  
(31, 'Explain the different operating modes of ARM processors.', 6, 'Medium', 'L2'),  
(31, 'What is a pipeline in the ARM? Explain the different pipeline stages of the ARM9 processor.', 10, 'Hard', 'L3'),  
(31, 'With a basic layout of a generic program status register, briefly explain the various fields.', 6, 'Medium', 'L2');

-- MCES: Module2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(32, 'Write a program to find the factorial of a number.', 6, 'Medium', 'L2'),  
(32, 'Write a program to find the largest and smallest number in an array of 16 numbers.', 7, 'Medium', 'L2'),  
(32, 'Write a program to find the sum of the first 20 integer numbers.', 6, 'Medium', 'L2'),  
(32, 'Explain load-store instructions in the ARM with examples.', 8, 'Hard', 'L3'),  
(32, 'Explain the different Data Processing Instructions in ARM.', 8, 'Hard', 'L3'),  
(32, 'Briefly explain the different load-store instruction categories used with ARM.', 7, 'Medium', 'L2'),  
(32, 'Write a program for forward and backward branches by considering an example.', 10, 'Hard', 'L3'),  
(32, 'Explain the Co-Processor Instructions of the ARM processor.', 8, 'Hard', 'L3'),  
(32, 'Write a note on Profiling and Cycle counting.', 6, 'Medium', 'L2'),  
(32, 'Explain the different barrel shifter operations with suitable examples.', 10, 'Hard', 'L3');

-- MCES: Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(33, 'Explain the various purposes of embedded systems in detail.', 6, 'Medium', 'L2'),  
(33, 'Explain the role of different types of memories used in embedded systems.', 6, 'Medium', 'L2'),  
(33, 'Explain Little Endian and Big Endian architecture.', 6, 'Medium', 'L2'),  
(33, 'With a neat Interface diagram, illustrate the connection of master and slave devices on the I2C bus.', 8, 'Hard', 'L3'),  
(33, 'With a neat diagram, explain the interfacing of the stepper motor through the driver circuit to the microcontroller.', 8, 'Hard', 'L3'),  
(33, 'Explain the classification of embedded systems based on generation and based on complexity and performance requirements.', 7, 'Medium', 'L2'),  
(33, 'What are embedded systems? Differentiate between purpose computing systems and embedded systems.', 6, 'Medium', 'L2'),  
(33, 'List any four purposes of an Embedded system with examples.', 4, 'Easy', 'L1'),  
(33, 'Write short notes on: Real-time clock and Watchdog timer.', 6, 'Medium', 'L2'),  
(33, 'Explain the following: I2C Bus, SPI Bus, Reset circuit, and I-Wire interface.', 10, 'Hard', 'L3');

-- MCES: Module4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(34, 'Explain the classification of embedded systems.', 6, 'Medium', 'L2'),  
(34, 'Write a program and explain the interface of the DC motor.', 10, 'Hard', 'L3'),  
(34, 'Explain the characteristics of embedded systems.', 6, 'Medium', 'L2'),  
(34, 'Write a program to demonstrate the use of an external interrupt to toggle an LED.', 10, 'Hard', 'L3'),  
(34, 'What are the operational and Non-Operational quality attributes of an Embedded system?', 6, 'Medium', 'L2'),  
(34, 'Explain the different communication buses used in Automotive applications.', 8, 'Hard', 'L3'),  
(34, 'Design an FSM model for a Tea/Coffee vending machine.', 10, 'Hard', 'L3'),  
(34, 'Explain the fundamental issues in Hardware-software Co-design.', 8, 'Hard', 'L3'),  
(34, 'Explain the assembly language-based embedded firmware development with a diagram.', 7, 'Medium', 'L2'),  
(34, 'With a neat block diagram, explain how source file to object file translation takes place in high-level language-based firmware development.', 8, 'Hard', 'L3');

-- MCES: Module5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(35, 'With a neat diagram, Explain the Operating system Architecture.', 8, 'Hard', 'L3'),  
(35, 'Explain Multithreading.', 6, 'Medium', 'L2'),  
(35, 'Explain the concept of Binary Semaphore.', 6, 'Medium', 'L2'),  
(35, 'Explain the role of an Integrated Development Environment (IDE) for embedded software development.', 7, 'Medium', 'L2'),  
(35, 'Write a note on Message passing.', 4, 'Easy', 'L1'),  
(35, 'Explain the concept of deadlock with a neat diagram.', 10, 'Hard', 'L3'),  
(35, 'Write a note on Boundary Scan and Simulators.', 6, 'Medium', 'L2'),  
(35, 'Explain the functional and non-functional requirements for selecting RTOS for an embedded system.', 8, 'Hard', 'L3'),  
(35, 'Differentiate between Multiprocessing and Multitasking.', 6, 'Medium', 'L2'),  
(35, 'Define Task, Process and Thread. Explain the process structure, process states and transitions.', 10, 'Hard', 'L3');

SELECT * FROM Questions;
-- OS:Module 1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(36, 'Explain the dual-mode operation of operating systems.', 6, 'Medium', 'L2'),  
(36, 'Explain the layered approach structure of operating systems with a diagram.', 8, 'Hard', 'L3'),  
(36, 'Differentiate client-server computing and peer-to-peer computing.', 6, 'Medium', 'L2'),  
(36, 'Explain operating system services with respect to user and system with a figure.', 7, 'Medium', 'L2'),  
(36, 'What is a Process? Explain different states of a process with a state diagram.', 8, 'Hard', 'L3'),  
(36, 'With a neat diagram, explain the concept of virtual machines.', 10, 'Hard', 'L3'),  
(36, 'Distinguish between Multiprogramming and Multitasking, and Multiprocessor systems and Clustered systems.', 6, 'Medium', 'L2'),  
(36, 'Analyze the modular kernel approach with a layered approach using a neat sketch.', 10, 'Hard', 'L3'),  
(36, 'List and explain the services provided by an OS for the user and efficient operation of the system.', 6, 'Medium', 'L2'),  
(36, 'Discuss the methods to implement message passing IPC in detail.', 8, 'Hard', 'L3');

-- OS:Module2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(37, 'Discuss the benefits of multithreading programming.', 6, 'Medium', 'L2'),  
(37, 'Illustrate with examples Peterson’s solution for critical section problems and prove that the mutual exclusion property is preserved.', 10, 'Hard', 'L3'),  
(37, 'Show how semaphore provides solutions to reader-writers’ problems.', 8, 'Hard', 'L3'),  
(37, 'Explain different types of Multithreading models.', 7, 'Medium', 'L2'),  
(37, 'Explain the Dining Philosopher’s problem using monitors.', 10, 'Hard', 'L3'),  
(37, 'Explain the critical section problem. What are the requirements that critical section problems must satisfy?', 8, 'Hard', 'L3'),  
(37, 'Discuss the Threading issues that come with a multithreaded program.', 6, 'Medium', 'L2'),  
(37, 'Explain Multithreading models.', 6, 'Medium', 'L2'),  
(37, 'What are monitors? Explain the Dining Philosopher’s solution using monitors.', 8, 'Hard', 'L3'),  
(37, 'Define semaphores. Explain their usage and implementation.', 7, 'Medium', 'L2');

-- OS:Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(38, 'Describe the resource allocation graph: (1) With deadlock, (2) With a cycle but no deadlock.', 8, 'Hard', 'L3'),  
(38, 'Illustrate the internal and external fragmentation problem with an example.', 7, 'Medium', 'L2'),  
(38, 'What is a Translation Lookaside Buffer (TLB)? Explain TLB in detail with a simple system and a neat diagram.', 10, 'Hard', 'L3'),  
(38, 'What is a deadlock? What are the necessary conditions for deadlock?', 6, 'Medium', 'L2'),  
(38, 'With the help of a neat diagram, explain the various steps of address binding.', 8, 'Hard', 'L3'),  
(38, 'Define deadlock. Write short notes on the 4 necessary conditions that raise deadlocks.', 6, 'Medium', 'L2'),  
(38, 'Apply Banker’s algorithm to answer the following: (1) What is the content of the need matrix? (2) Is the system in a safe state? (3) If a request from a process P1(0,4,2,0) arrives, can it be granted?', 12, 'Hard', 'L3'),  
(38, 'Write short notes on: (1) External and internal Fragmentation, (2) Dynamic loading and linking.', 6, 'Medium', 'L2'),  
(38, 'Analyze the problem in a simple paging technique and show how TLB is used to solve the problem.', 8, 'Hard', 'L3'),  
(38, 'Given the memory partitions of 200K, 700K, 500K, 300K, 100K, and 400K, apply First Fit and Best Fit to place 315K, 427K, 250K, and 550K.', 10, 'Hard', 'L3');

-- OS:Module4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(39, 'For the following page reference string 1, 2, 3, 4, 1, 2, 5, 1, 2, 3, 4, 5. Calculate the page faults using FIFO and LRU for memory with 3 and 4 frames.', 10, 'Hard', 'L3'),  
(39, 'Explain the demand paging in detail.', 6, 'Medium', 'L2'),  
(39, 'What do you mean by a free space list? With a suitable example, explain any 3 methods of free space list implementations.', 8, 'Hard', 'L3'),  
(39, 'Write short notes on linked and indexed allocation methods with a neat diagram.', 6, 'Medium', 'L2'),  
(39, 'Consider the following page reference stream: 7, 0, 1, 2, 0, 3, 0, 4, 2, 3, 0, 3, 2, 1, 2, 0, 1, 7, 0, 1. How many page faults would occur for LRU and FIFO replacement algorithms assuming 3 frames? Which one of the above is most efficient?', 12, 'Hard', 'L3'),  
(39, 'Explain the demand paging system.', 6, 'Medium', 'L2'),  
(39, 'What is thrashing? How can it be controlled?', 7, 'Medium', 'L2'),  
(39, 'Explain briefly the various operations performed on files.', 4, 'Easy', 'L1'),  
(39, 'Explain the various access methods of files.', 6, 'Medium', 'L2'),  
(39, 'Explain various allocation methods in implementing file systems.', 8, 'Hard', 'L3');

-- OS:Module5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(40, 'Explain the various Disk Scheduling algorithms with examples.', 10, 'Hard', 'L3'),  
(40, 'Explain the access matrix method of system protection.', 8, 'Hard', 'L3'),  
(40, 'With a neat diagram, detail components of Linux systems.', 6, 'Medium', 'L2'),  
(40, 'Explain the different IPC mechanisms available in Linux.', 8, 'Hard', 'L3'),  
(40, 'Explain process scheduling in Linux systems.', 7, 'Medium', 'L2'),  
(40, 'Explain the components of the Linux system with a neat diagram.', 6, 'Medium', 'L2'),  
(40, 'Describe briefly Linux Kernel modules.', 6, 'Medium', 'L2'),  
(40, 'Describe the different Linux Kernel modules.', 6, 'Medium', 'L2'),  
(40, 'Explain the file system implementation in Linux.', 8, 'Hard', 'L3'),  
(40, 'Explain the various disk scheduling algorithms with an example.', 10, 'Hard', 'L3');

-- CN: Module1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(41, 'Explain MAN with a neat labelled diagram.', 6, 'Medium', 'L2'),  
(41, 'List and explain design issues for layers.', 7, 'Medium', 'L2'),  
(41, 'What are guided transmission media? Explain twisted pair cable in detail.', 8, 'Hard', 'L3'),  
(41, 'Explain TCP/IP reference model with a neat labelled diagram.', 10, 'Hard', 'L3'),  
(41, 'Briefly discuss virtual private networks.', 6, 'Medium', 'L2'),  
(41, 'Explain LAN, WAN, PAN with a neat diagram.', 8, 'Hard', 'L3'),  
(41, 'Explain Network Hardware.', 6, 'Medium', 'L2'),  
(41, 'Distinguish between Connection-Oriented and Connectionless Service.', 6, 'Medium', 'L2'),  
(41, 'Explain OSI Reference Model and TCP/IP with a neat diagram.', 10, 'Hard', 'L3'),  
(41, 'Compare OSI and TCP/IP.', 8, 'Hard', 'L3'),  
(41, 'Write a note on the following: Coaxial Cable, Fiber Optics.', 6, 'Medium', 'L2');

-- CN:Module2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(42, 'List and explain any two data link layer design issues.', 6, 'Medium', 'L2'),  
(42, 'Explain the significance of sliding window protocol in data link layer. How does it improve efficiency?', 8, 'Hard', 'L3'),  
(42, 'Explain Go-Back-N protocol working.', 7, 'Medium', 'L2'),  
(42, 'Briefly explain the static channel and dynamic channel allocation problems.', 6, 'Medium', 'L2'),  
(42, 'Describe how the mechanism of error correction and detection is handled by the Data link layer in detail.', 10, 'Hard', 'L3'),  
(42, 'Write a note on Data link layer design issues.', 4, 'Easy', 'L1'),  
(42, 'Explain A Simplex Stop-and-Wait Protocol for an Error-Free Channel and A Simplex Stop-and-Wait Protocol for a Noisy Channel.', 8, 'Hard', 'L3'),  
(42, 'Explain Selective Repeat in detail.', 8, 'Hard', 'L3'),  
(42, 'Compare pure and slotted ALOHA.', 6, 'Medium', 'L2'),  
(42, 'Solve problems on Parity, checksum, CRC, and Hamming code.', 10, 'Hard', 'L3');

-- OS:Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(43, 'Write Dijkstras algorithm to compute the shortest path through a graph. Explain with an example.', 10, 'Hard', 'L3'),  
(43, 'Illustrate the working of OSPF and BGP.', 8, 'Hard', 'L3'),  
(43, 'What is congestion control? List and explain various approaches to congestion control.', 7, 'Medium', 'L2'),  
(43, 'What is a packet scheduling algorithm? Explain the FIFO algorithm.', 6, 'Medium', 'L2'),  
(43, 'Explain Network layer design issues.', 6, 'Medium', 'L2'),  
(43, 'Explain Store and Forward Packet Switching.', 6, 'Medium', 'L2'),  
(43, 'Comparison of Virtual Circuit and Datagram Networks.', 6, 'Medium', 'L2'),  
(43, 'What is a Routing Algorithm? Explain Non-Adaptive algorithm and Adaptive algorithm with a diagram.', 8, 'Hard', 'L3'),  
(43, 'Explain the Distance Vector Routing algorithm.', 8, 'Hard', 'L3'),  
(43, 'Discuss the Link State algorithm.', 8, 'Hard', 'L3'),  
(43, 'Explain Quality of Services.', 6, 'Medium', 'L2');

-- OS:Module4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(44, 'Write a program for congestion control using leaky bucket algorithm.', 10, 'Hard', 'L3'),  
(44, 'Briefly explain about transport service primitives.', 6, 'Medium', 'L2'),  
(44, 'With a neat labeled diagram, explain TCP segment structure.', 8, 'Hard', 'L3'),  
(44, 'Explain TCP connection management with TCP connection management FSM diagram.', 10, 'Hard', 'L3'),  
(44, 'Explain the services provided by transport layer.', 6, 'Medium', 'L2'),  
(44, 'List the Hypothetical primitives in transport layer and using a diagram explain connection establishment and connection release for the same.', 8, 'Hard', 'L3'),  
(44, 'With all the functions, explain Berkley sockets and write a socket program.', 10, 'Hard', 'L3'),  
(44, 'Explain the elements of transport protocol.', 6, 'Medium', 'L2'),  
(44, 'With a neat diagram explain the steps in making an RPC.', 8, 'Hard', 'L3'),  
(44, 'With a neat diagram explain TCP header format.', 8, 'Hard', 'L3'),  
(44, 'With a neat diagram explain UDP header format.', 7, 'Medium', 'L2');

-- OS:Module5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(45, 'Explain client/server and P-P architecture with a neat labelled diagram.', 8, 'Hard', 'L3'),  
(45, 'Explain user and server interaction with a neat diagram.', 6, 'Medium', 'L2'),  
(45, 'Explain persistent and non-persistent HTTP in detail.', 7, 'Medium', 'L2'),  
(45, 'Explain design issues of the Application layer.', 8, 'Hard', 'L3'),  
(45, 'Write notes on: E-mail in the internet and Distributed DNS architecture.', 6, 'Medium', 'L2'),  
(45, 'Explain HTTP Request and Response Message Format.', 8, 'Hard', 'L3'),  
(45, 'Explain SMTP.', 6, 'Medium', 'L2'),  
(45, 'Explain how DNS works and the Services Provided by DNS.', 8, 'Hard', 'L3'),  
(45, 'Write notes on the following: Web Caching and Cookies.', 6, 'Medium', 'L2'),  
(45, 'Describe the key components of an email system and their functions.', 6, 'Medium', 'L2'),  
(45, 'Describe the process of establishing a TCP connection for HTTP communication.', 10, 'Hard', 'L3');

-- DBMS:Module1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(46, 'Discuss the main characteristics of the database approach and how it differs from traditional file systems.', 8, 'Hard', 'L3'),  
(46, 'What are the responsibilities of the DBA and the database designers?', 6, 'Medium', 'L2'),  
(46, 'What are the different types of database end users? Discuss the main activities of each.', 7, 'Medium', 'L2'),  
(46, 'Define the following terms: DBMS, Data model, Database, Database system, Metadata, Database schema, Data state, Application program, Transaction, DDL, DML, SDL, VDL, Query language, Host language.', 10, 'Hard', 'L3'),  
(46, 'What’s the difference between a database schema and a database state?', 6, 'Medium', 'L2'),  
(46, 'Describe the three-schema architecture. How do different schema definition languages support this architecture?', 8, 'Hard', 'L3'),  
(46, 'What do you mean by data independence? Differentiate between logical and physical data independence.', 7, 'Medium', 'L2'),  
(46, 'What’s the difference between procedural and non-procedural DML?', 6, 'Medium', 'L2'),  
(46, 'Discuss the different types of user-friendly interfaces and the types of users who typically use them.', 6, 'Medium', 'L2'),  
(46, 'List and explain different types of attributes with examples.', 8, 'Hard', 'L3');

-- DBMS:Module2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(47, 'What is the difference between the two-tier and three-tier client-server architectures?', 6, 'Medium', 'L2'),  
(47, 'With suitable examples, explain different types of attributes.', 6, 'Medium', 'L2'),  
(47, 'With suitable examples, define the following: Entity type, Entity, Entity set, Relationship type, Relationship set, Relationship instance.', 8, 'Hard', 'L3'),  
(47, 'Explain different cardinality ratios and participation roles with examples.', 7, 'Medium', 'L2'),  
(47, 'Explain the difference between an attribute and a value set.', 6, 'Medium', 'L2'),  
(47, 'Describe recursive relationship types with examples.', 6, 'Medium', 'L2'),  
(47, 'Draw an ER diagram to represent the CAR entity type with key attributes like registration number and vehicle ID.', 10, 'Hard', 'L3'),  
(47, 'Design an ER diagram for: Movie database schema with at least five entities, AIRLINES database schema with at least five entities, Banking database schema with at least five entities.', 12, 'Hard', 'L3'),  
(47, 'Define the following with examples: Super Key, Primary Key, Candidate Key, Foreign Key.', 6, 'Medium', 'L2'),  
(47, 'Summarize the steps involved in converting ER constructs to relational schemas.', 8, 'Hard', 'L3');

-- DBMS:Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(48, 'Discuss the history and features of SQL. Why is SQL called a declarative language?', 6, 'Medium', 'L2'),  
(48, 'What are the different SQL statements/commands used for data definition?', 6, 'Medium', 'L2'),  
(48, 'What do you mean by base relations and virtual relations?', 4, 'Easy', 'L1'),  
(48, 'List and explain different data types available in SQL.', 6, 'Medium', 'L2'),  
(48, 'Explain key and referential integrity constraints with examples. What are the referential triggered actions in SQL?', 8, 'Hard', 'L3'),  
(48, 'Explain basic retrieval statements in SQL with syntax and examples.', 6, 'Medium', 'L2'),  
(48, 'Explain pattern matching in SQL using symbols like `%` and `_`.', 6, 'Medium', 'L2'),  
(48, 'Explain SQL commands: INSERT, UPDATE, ALTER, and DELETE with examples.', 8, 'Hard', 'L3'),  
(48, 'Explain the use of EXISTS and NOT EXISTS in SQL with examples.', 7, 'Medium', 'L2'),  
(48, 'List and explain different aggregate functions available in SQL.', 6, 'Medium', 'L2'),  
(48, 'Explain GROUP BY and HAVING clauses with syntax and examples.', 8, 'Hard', 'L3'),  
(48, 'Explain the concept of views in SQL with examples.', 8, 'Hard', 'L3');

-- DBMS:Module4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(49, 'What are the implicit goals of database schema design? Describe them.', 6, 'Medium', 'L2'),  
(49, 'What are the informal guidelines for database schema design?', 6, 'Medium', 'L2'),  
(49, 'Explain different update anomalies with examples.', 8, 'Hard', 'L3'),  
(49, 'What is functional dependency? Explain inference rules, Armstrongs axioms, and properties of functional dependency with proof.', 10, 'Hard', 'L3'),  
(49, 'Explain different types of functional dependencies with examples.', 8, 'Hard', 'L3'),  
(49, 'What do you mean by lossy and lossless join decompositions? Give examples.', 7, 'Medium', 'L2'),  
(49, 'What do you mean by normalization of a relation? Explain 1NF, 2NF, and 3NF with examples.', 10, 'Hard', 'L3'),  
(49, 'Explain BCNF with suitable examples.', 8, 'Hard', 'L3'),  
(49, 'Explain first, second, and third normal forms with examples.', 8, 'Hard', 'L3'),  
(49, 'Define Multivalued dependency. Explain 4NF with examples.', 10, 'Hard', 'L3');

-- DBMS:Module5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(50, 'What are anomalies occurring due to interleaved execution? Explain with examples.', 8, 'Hard', 'L3'),  
(50, 'Explain different states of transaction execution with a neat state transition diagram.', 7, 'Medium', 'L2'),  
(50, 'Why is concurrency control needed? Explain with an example.', 6, 'Medium', 'L2'),  
(50, 'Explain different types of locks used in concurrency control.', 7, 'Medium', 'L2'),  
(50, 'How does shadow paging help in recovering from transaction failure? Explain.', 8, 'Hard', 'L3'),  
(50, 'Explain the ACID properties of transactions and system logs.', 6, 'Medium', 'L2'),  
(50, 'Explain transaction support in SQL.', 6, 'Medium', 'L2'),  
(50, 'When do deadlock and starvation problems occur? How can these problems be resolved?', 8, 'Hard', 'L3'),  
(50, 'Explain the ARIES recovery algorithm with examples.', 10, 'Hard', 'L3'),  
(50, 'What is a schedule? Explain conflict and view serializability with examples.', 8, 'Hard', 'L3'),  
(50, 'Discuss the two-phase locking protocol used in concurrency control.', 8, 'Hard', 'L3'),  
(50, 'Discuss the REDO and UNDO operations used in recovery techniques.', 8, 'Hard', 'L3');

-- FSD:Module1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(51, 'Define Web Framework? Explain with an example of the design of a Web application written using the Common Gateway Interface (CGI) standard with its disadvantages.', 8, 'Hard', 'L3'),  
(51, 'Explain how Django Processes a Request.', 7, 'Medium', 'L2'),  
(51, 'Explain Wildcard URL patterns and Django’s Pretty Error Pages.', 6, 'Medium', 'L2'),  
(51, 'Write a Django app that displays date and time four hours ahead and four hours before as an offset of the current date and time in the server.', 10, 'Hard', 'L3'),  
(51, 'Explain features of Django.', 6, 'Medium', 'L2'),  
(51, 'Explain MVC Architecture.', 7, 'Medium', 'L2');

-- FSD:Module2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(52, 'Explain Basic Template Tags and Filters.', 6, 'Medium', 'L2'),  
(52, 'Explain MTV Development Pattern.', 7, 'Medium', 'L2'),  
(52, 'Explain Template Inheritance with an example.', 8, 'Hard', 'L3'),  
(52, 'Explain Making Changes to a Database Schema.', 6, 'Medium', 'L2'),  
(52, 'Explain MVT Architecture.', 6, 'Medium', 'L2'),  
(52, 'Develop a simple Django app that displays an unordered list of fruits and an ordered list of selected students for an event.', 10, 'Hard', 'L3');

-- FSD:Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(53, 'Explain Customizing the Admin Interface.', 6, 'Medium', 'L2'),  
(53, 'Explain Creating a Feedback Form and Processing the Submission.', 7, 'Medium', 'L2'),  
(53, 'Develop a Model form for a student that contains his topic chosen for a project, languages used, and duration with a model called project.', 10, 'Hard', 'L3'),  
(53, 'List and Explain URLconf Tricks.', 6, 'Medium', 'L2'),  
(53, 'Discuss Migration of Database with an example.', 8, 'Hard', 'L3'),  
(53, 'Discuss Django Form Submission.', 8, 'Hard', 'L3');

-- FSD:Module4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(54, 'Define Generic Views and explain its types.', 6, 'Medium', 'L2'),  
(54, 'Explain Extending Generic Views.', 6, 'Medium', 'L2'),  
(54, 'For student’s enrolment, create a generic class view which displays a list of students and a detail view that displays student details for any selected student in the list.', 10, 'Hard', 'L3'),  
(54, 'Write a note on the following: Cookies, Users, and Authentications.', 6, 'Medium', 'L2'),  
(54, 'What is MIME and discuss its types.', 6, 'Medium', 'L2'),  
(54, 'Explain Dynamic CSV using a database.', 8, 'Hard', 'L3');

-- FSD:Module5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(55, 'List and explain the technologies Ajax is overlaid on.', 6, 'Medium', 'L2'),  
(55, 'Explain XHTML Http Request and Response.', 7, 'Medium', 'L2'),  
(55, 'List and explain the jQuery Ajax facilities.', 6, 'Medium', 'L2'),  
(55, 'Write a program to develop a search application in Django using AJAX that displays courses enrolled by a student being searched.', 10, 'Hard', 'L3'),  
(55, 'Develop a registration page for student enrolment without page refresh using AJAX.', 8, 'Hard', 'L3'),  
(55, 'Develop a search application in Django using AJAX that displays courses enrolled by a student being searched.', 10, 'Hard', 'L3');

-- SE:Module1--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(56, 'Define software engineering and explain its process.', 6, 'Medium', 'L2'),  
(56, 'With a neat diagram, explain Prescriptive and Waterfall model.', 8, 'Hard', 'L3'),  
(56, 'Explain Software Myths with examples.', 6, 'Medium', 'L2'),  
(56, 'With a neat diagram, explain Incremental process models and Evolutionary process models.', 8, 'Hard', 'L3'),  
(56, 'Discuss David Hooker’s seven principles of software engineering practice.', 7, 'Medium', 'L2'),  
(56, 'Describe the five activities that a generic process framework for software engineering encompasses.', 8, 'Hard', 'L3');

-- SE:Module2--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(57, 'What are the nature of Software systems and explain their characteristics.', 6, 'Medium', 'L2'),  
(57, 'How does Requirement Engineering work? Explain in detail.', 8, 'Hard', 'L3'),  
(57, 'Explain three types of QFD with examples.', 7, 'Medium', 'L2'),  
(57, 'Explain the scenario-based model with an example.', 8, 'Hard', 'L3'),  
(57, 'Develop a UML use case diagram for home security function.', 10, 'Hard', 'L3'),  
(57, 'Explain the activities and steps involved in Negotiating Software Requirements.', 8, 'Hard', 'L3');

-- SE:Module3--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(58, 'Define Agile Process and explain agility principle.', 6, 'Medium', 'L2'),  
(58, 'With a neat diagram, explain Extreme Programming (XP).', 8, 'Hard', 'L3'),  
(58, 'Write a short note on Scrum and Crystal.', 6, 'Medium', 'L2'),  
(58, 'Explain Communication Practice principle.', 6, 'Medium', 'L2'),  
(58, 'Explain Adaptive Software Development (ASD) Model with a sketch.', 8, 'Hard', 'L3'),  
(58, 'Explain the key traits that must exist among the people on an agile team and the team itself.', 7, 'Medium', 'L2');

-- SE:Module4--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(59, 'What is software project management? Explain the project management life cycle.', 8, 'Hard', 'L3'),  
(59, 'List and explain categorizing software projects.', 6, 'Medium', 'L2'),  
(59, 'Explain traditional vs project management practices.', 7, 'Medium', 'L2'),  
(59, 'How to assess Project Success and Failure in Software Project Management?', 8, 'Hard', 'L3'),  
(59, 'Elucidate the concepts in activity planning in software project management.', 10, 'Hard', 'L3'),  
(59, 'Write short notes on: SMART objectives and Management control with project control cycle.', 6, 'Medium', 'L2');

-- SE:Module5--
INSERT INTO Questions (Mod_ID, Question_Text, Marks, Difficulty, Bloom_Taxonomy) VALUES  
(60, 'Define software quality and explain the place of software quality in project management.', 6, 'Medium', 'L2'),  
(60, 'Explain capability process model and CMM key areas.', 7, 'Medium', 'L2'),  
(60, 'Explain product vs process quality management.', 6, 'Medium', 'L2'),  
(60, 'Explain in detail the techniques to enhance software quality.', 8, 'Hard', 'L3'),  
(60, 'What are the advantages of carrying out inspection? List the general principles to be followed during inspection.', 8, 'Hard', 'L3');

SELECT * FROM Questions;