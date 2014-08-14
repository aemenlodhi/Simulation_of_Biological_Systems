/* Originally developed for Simulation of Biological Systems course @ Georgia Tech Spring 2011

Objective

The goal of this project was to learn about simulation based on particle systems. In particular, I implemented flocking, herding and schooling behaviour. The virtual creatures will group together similar to the way in which fish swim together in schools. 

This project is based on the simulated flocking work of Craig Reynolds.

Flocking Simulation

The flocking simulator was developed using Processing. When the program starts, we will have 10 creatures on the screen that have a tendency to group together according to Craig Reynolds' three rules of interaction.

Characteristics of the simulator:

The simulator has toroidal wrapping about its boundaries.
The simulator obeys simple mouse and keyboard commands. The interface will allow the mouse to be in one of two modes: attracting or repelling. When in attracting mode, holding down the mouse button will cause the creatures to follow the cursor. When in repelling mode, holding down the button will cause the creatures to move away from the cursor, as if it is a predator that they are trying to escape.
Your simulator should act on this group of keyboard commands:

a,A - Switch to attraction mode (for when mouse is held down).
r,R - Switch to repulsion mode (for when mouse is held down).
s,S - Cause all creatures to be instantly scattered to random positions in the window.
p,P - Toggle whether to have creatures leave a path, that is, whether the window is cleared each display step or not.
c,C - Clear the window (useful when creatures are leaving paths).
1 - Toggle the flock centering forces on/off.
2 - Toggle the velocity matching forces on/off.
3 - Toggle the collision avoidance forces on/off.
4 - Toggle the wandering force on/off.
=,+ - Add one new creature to the simulation. You should allow up to 100 creatures to be created.
- (minus sign) - Remove one new creature from the simulation (unless there are none already).
space bar - Start or stop the simulation (toggle between these).
When the user types 1, 2, 3, or 4, print out a line that describes which forces are on/off at the time, such as:
Centering: off Collisions: off Velocity matching: on Wandering: on

In addition to the three forces from Reynolds, each of your creatures should have a small randomness factor (wandering) added to their motion. There are two reasons for this. First, this will cause your creatures to look more natural in their motion. Second, when all of the other three forces have been turned off, this slight randomness will prevent them from moving in exactly a straight line. Also, you should have a minimum and maximum value that you use to clamp the velocity of each creature. This will keep your creatures from sitting still or zooming too fast across the window.


