-- Optimize geometry iterating over x pos. of vertical segment of chassis
-- 	and then shifting the chassis vertically

-- These values are INCLUSIVE
local xMin = 6		-- Lowest x value that the vertical segment can take
local yMin = 10		-- Lowest y value the RIGHT SIDE of bottom half of the chassis can take

local xMax = 15		-- Highest x value that the vertical segment can take
local yMax = 30		-- Highest y value the RIGHT SIDE of bottom half of the chassis can take

-- Looping parameters
local xLoops = xMax - xMin
local yLoops = yMax - yMin
adjustable xIter = 0
adjustable yIter = 0

-- All GEM files are made here
while xIter <= xLoops do
	while yIter <= yLoops do
		-- File Stuff
		adjustable filename = "adjusted_codif_chassis" + tostring(xPosition) + "X" + tostring(yPosition) + "Y.GEM" 
		io.output(filename)
		
		-- write geometry
		io.write("PA_Define(140,210,1,Cyl,y,Electrostatic)","\n")
		io.write("electrode(10){fill{within{box(60,35,64,47)}}}", "\n")				-- Upper MCP that remains unchanged
		
		-- Chassis plus modifications
		io.write("electrode(20){fill{ \n")
		within{box(39,99,79,100)} -- Outer shell of TOF
		within{polyline(56,99,56,83.5,57,83,59,83,59,99)} --Outer most chamfer
		within{polyline(47,99,47,94.5,49,94.5,51,95.5,51,99)}	 --top outer chamfer
		within{polyline(58,83.5,58,61.5)}; -- grid
	
		-- Aperture that we want to stay the same
		--_______________________________
		io.write("within{box(2,58,10,66)} \n within{polyline(2,65,6,71,6,65)} \n within{polyline(6,65,10,71,10,65)} \n") -- Inner Carbon foil holder

		io.write("within{box(2,88,17,99)} \n within{polyline(2,88,6,84,6,88)} \n within{polyline(6,88,10,84,10,88)} \n") --Carbon foil holders:outer
		--_______________________________
		io.write("within{polyline(6,70,6,86)} \n") -- grid
		io.write("within{polyline(10,70,10,86)} \n") --Carbon Foil
		-- end -- 
		
		io.write("within{box(60,62,64,83)} \n") -- SSD
		--;_______________________________
		--;within{box(60,29,64,30)};inner shell
		--_______________________________
		within{box(15,47,17,69.5)} --structures under foils
		within{box(10,65,17,69)}
		--;within{polyline(10,70.5,12,70.5,14,69.5,10,69.5)}
		--;within{polyline(10,79,12,79,14,80,10,80)}
		--_______________________________
		within{polyline(16,88,27,88)}
		within{polyline(13,87,9,87)}
		within{polyline(10,85,15,87.5,25,87.5,45,93.5,45,100,47,100,47,92.5,26,86.5,17,86.5,17,85,10,85)} --outer ring
		within{polyline(17,47,57,30,57,25,55,31,21,47.5,21,52,17,52,17,47)} --inner ring
		within{polyline(34,42,34,52,36,52,36,41,44,41,44,37)} --veine on inner cone
		within{polyline(25,86.5,25,82.5,27,82.5,27,86.5)} --first rib on outer cone
		within{polyline(31,88,31,84,33,83,33,88.5)} --second rib
		within{polyline(37,89.5,37,85.5,39,84.5,39,90)} --third rib
		within{polyline(43,91.5,43,87.5,45,86.5,45,92)} --forth rib
		--_______________________________
		within{polyline(59,62,57,62,56,61.5,56,54.5,51,54.5,51,53.5,59,53.5)} --middle chamfer
		io.write("}} \n")
		
		-- Pulling electrode, adjusted by cutting off the far right pixels
		io.write("electrode(30){fill{within{polyline(35,56,21,56,21,67,23,68,23,60,27,60,27,65,29,66,29,60,",33-xIter,",60,",34-xIter,",62,",35-xIter,",63,",35-xIter,",56)}}}","\n")
		
		-- MCP
		io.write("electrode(4){fill{within{polyline(59,47,57,47,57,50,44,50,44,53,46,53,46,51,59,51)} \n within{polyline(59,35,57,35,57,28.5,56,28.5,56,20,58,20,58,25.5,59,25.5)} \n within{polyline(58,47,58,35)}}} \n")
		
		-- //Grounding Shell
		io.write("electrode(50){fill{within{box(1,0,100,207)}notin{box(2,0,99,206)}}} \n")
		
		yIter = yIter + 1
	end
	xIter = xIter + 1
end