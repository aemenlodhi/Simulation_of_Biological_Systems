/***: Originally developed for the course Simulation of Biological System @ Georgia Tech, Spring 2011


This is a cellular automata simulator for the game of Life, originally create by John Horton Conway. Life is simulated on a square grid of cells. Each cell is either live (white) or dead (black). The rules for life are simple. At each simulation step, a cell changes its live/dead state according to its last state and the number of live cells adjacent to it. Each cell is said to have eight neighbors, that is, diagonal neighbors count. The rules are simple: a live cell continues to live if it has two or three live neighbors. A dead cell is turned into a live cell if it has exactly three live neighbors. All other cells will be dead.
Your program will display the state of the simulation in a window that contains black and white cells. Here are some of the characteristics of this window:

The grid will be 100 by 100 cells.
Each cell should be at least six by six pixels in size (thus the screen must be at least 600 by 600 pixels).
The grid of cells is toroidal, that is, cells on the far left edge are neighbors to the cells on the far right edge. The top and bottom rows are also adjacent.
You will write a Life simulator that allows a user to create cell patterns by mouse clicks. When the user clicks on a black cell, it is turned to white. Clicking on a white cell changes it to black. Your simulator will also run in either of two modes: single-step or continuous. Various keys will control the behavior of your simulator. Here are the key controls and their behavior:
C - Clear the grid to all black.
R - Randomize the state of the grid (each cell is black or white with equal probability).
G - Toggle between single-step and continuous update mode.
space bar - Switch to single-step mode and take one simulation step.

