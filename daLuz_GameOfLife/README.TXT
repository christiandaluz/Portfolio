The Game of Life is a cellular automaton designed by John Conway, a British
mathematician, in 1970. The user creates an initial configuration and then
observes its evolution.

How to use this application:
Consider any white cell "off" or "dead" and consider any green cell "on"
or \"live.\" Clicking on any cell toggles it to its opposite state, either
"on/live" or "off/dead". The 8 cells surrounding each cell are its
neighbors.

The simulation progresses via generations; each step in time
triggers the next generation and the next generation is determined by a set
of rules:
1. Any live cell with fewer than two live neighbours dies, as if 
caused by underpopulation. 
2. Any live cell with two or three live neighbours lives on to the next 
generation.
3. Any live cell with more than three live neighbours dies, as if by 
overpopulation.
4. Any dead cell with exactly three live neighbours becomes a live cell, 
as if by reproduction.

Selecting "Next Generation" progresses to the next step in time.
Selecting "Start Simulation" runs the simulation automatically.
Selecting "Pause Simulation" stops the simulation if it is running.
Selecting "Reset Simulation" clears the grid so that every cell is off.
Selecting a higher speed value on the slider make the simulation run faster.
Configurations can be saved or loaded onto the grid using their corresponding
File menu items.