-- Optimize geometry iterating over x pos. of vertical segment of chassis
-- 	and then shifting the chassis vertically

--simion.workbench_program()
--simion.import("SmallCodif.lua")

-- These values are INCLUSIVE
local xMin = 26		-- Lowest x value that the vertical segment can take
local yMin = 35	-- Lowest y value the RIGHT SIDE of bottom half of the chassis can take

local xMax = 36		-- Highest x value that the vertical segment can take
local yMax = 45		-- Highest y value the RIGHT SIDE of bottom half of the chassis can take

-- Looping parameters
local xLoops = 2-- xMax - xMin+1
local yLoops = 2--yMax - yMin+1
local xIter= 0
local yIter = 0

-- All GEM files are made here
while xIter < xLoops do
	while yIter < yLoops do
		-- File Stuff
		local filename = "adjusted_codif_chassis" .. tostring(xIter) .. "X" .. tostring(yIter) .. "Y.gem" 
		--io.output(filename)

		
		-- write geometry
		--io.write("PA_Define(140,210,1,Cyl,y,Electrostatic,1)\n")
		--io.write("electrode(10){fill{within{box(60,35,64,47)}}}", "\n")				-- Upper MCP that remains unchanged
		
		-- Chassis plus modifications
		--io.write("electrode(20){fill{ \n")
		--io.write("within{box(39,99,79,100)} \n") -- Outer shell of TOF
		--io.write("within{polyline(56,99,56,83.5,57,83,59,83,59,99)} \n") --Outer most chamfer
		--io.write("within{polyline(47,99,47,94.5,49,94.5,51,95.5,51,99)} \n")	 --top outer chamfer
		--io.write("within{polyline(58,83.5,58,61.5)} \n") -- grid
	
		-- Aperture that we want to stay the same
		--_______________________________
		--io.write("within{box(2,58,10,66)} \n within{polyline(2,65,6,71,6,65)} \n within{polyline(6,65,10,71,10,65)} \n") -- Inner Carbon foil holder

		--io.write("within{box(2,88,17,99)} \n within{polyline(2,88,6,84,6,88)} \n within{polyline(6,88,10,84,10,88)} \n") --Carbon foil holders:outer
		--_______________________________
		--io.write("within{polyline(6,70,6,86)} \n") -- grid
		--io.write("within{polyline(10,70,10,86)} \n") --Carbon Foil
		-- end -- 
		
		--io.write("within{box(60,62,64,83)} \n") -- SSD
		--;_______________________________

		--_______________________________
		--io.write("within{box(15,47,17,69.5)} \n") --structures under foils
		--io.write("within{box(10,65,17,69)} \n")

		--_______________________________
		--io.write("within{polyline(16,88,27,88)} \n")
		--io.write("within{polyline(13,87,9,87)} \n")
		--io.write("within{polyline(10,85,15,87.5,25,87.5,45,93.5,45,100,47,100,47,92.5,26,86.5,17,86.5,17,85,10,85)} \n")		--outer ring
		
		--io.write("within{polyline(17,",47-yIter,",57,30,55,31,21,",47-yIter, ",21,47.5,21,52,17,52,17,",47-yIter,")} \n")--;inner ring
 
		--io.write("within{box(",34-xIter,",52,",36-xIter,",",42-yIter,")} \n") --; rib on inner cone
 
		--io.write("within{polyline(44,",math.floor(11/34*(16-yIter)+31),",", 36-xIter, ",",math.floor((19+xIter)*(16-yIter)/34+31),",44,", math.floor((19+xIter)*(16-yIter)/34+31)+7,")} \n") --; triangle net to the inner rib
 

		--io.write("within{polyline(25,86.5,25,82.5,27,82.5,27,86.5)} \n") --first rib on outer cone
		--io.write("within{polyline(31,88,31,84,33,83,33,88.5)} \n") --second rib
		--io.write("within{polyline(37,89.5,37,85.5,39,84.5,39,90)} \n") --third rib
		--io.write("within{polyline(43,91.5,43,87.5,45,86.5,45,92)} \n") --forth rib
		--_______________________________
		--io.write("within{polyline(59,62,57,62,56,61.5,56,54.5,51,54.5,51,53.5,59,53.5)}}} \n \n") --middle chamfer		
		-- Pulling electrode, adjusted by cutting off the far right pixels
		--io.write("electrode(30){fill{within{polyline(35,56,21,56,21,67,23,68,23,60,27,60,27,65,29,66,29,60,",33-xIter,",60,",34-xIter,",62,",35-xIter,",63,",35-xIter,",56)}}}","\n")
		
		-- MCP
		--io.write("electrode(4){fill{within{polyline(59,47,57,47,57,50,44,50,44,53,46,53,46,51,59,51)} \n within{polyline(59,35,57,35,57,28.5,56,28.5,56,20,58,20,58,25.5,59,25.5)} \n within{polyline(58,47,58,35)}}} \n")
		
		-- //Grounding Shell
		--io.write("electrode(50){fill{within{box(1,0,100,207)} \n notin{box(2,0,99,206)}}} \n")
		--io.close()
		
		-- create fast adjust array
		local pasharp_filename = string.gsub(filename, ".gem", ".pa#")
		--io.output(pasharp_filename)
		--io.close()

		local temp = 'gem2pa ' .. filename .. ' ' .. pasharp_filename
		--simion.command(temp)

		-- refine PA# file.
		simion.command("refine " .. pasharp_filename)
		--os.execute("timeout 50")
		-- LET IT FLY
		simion.command("fly cotif.iob")
		
		
		
		-- Convert output file to an intelligible filename     unsure where to place this

		print("\n \n \n " .. xIter .. ", " .. yIter .. " \n \n \n")
		os.rename("testoutput.txt.","adjusted_codif_" .. tostring(xIter) .. "X" .. tostring(yIter) .. "Y.txt")
		
		yIter = yIter + 1
	end
	xIter = xIter + 1
	yIter = 0
end