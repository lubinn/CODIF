-- File: VoltageTuner.lua
--      This is a user workbench program for the _____ which tests the
--      configuration over multiple combinations of potentials
--
-- Authors: Phillip Diffley, 


simion.workbench_program()
--filecounter=1

-- intial (minimum) values for voltage parameters
PAC_INIT = -5000
V2SEPARATION_INIT = -2000
MCP_INIT = 2000

-- maximum values for voltage parameters
PAC_MAX = -15000
V2SEPARATION_MAX = 2000
MCP_MAX = 3500

-- step size for voltage parameters
PAC_STEP = -800
V2SEPARATION_STEP = 200
MCP_STEP = -200

-- detection box ranges in PA coordinates
detectionBoxXMin = 116
detectionBoxXMax = 128
detectionBoxYMin = 70
detectionBoxYMax = 94

-- counters for data recording
adjustable runNumber = 1 -- the current run
adjustable ionCount = 0 -- the total number of ions in a run (calculated later)
adjustable ionHits = 0 -- the number of ions to hit the detector (calculated later)

-- variables holding current values of voltage parameters
adjustable PAC = PAC_INIT
adjustable V2Separation = V2SEPARATION_INIT
adjustable MCP = MCP_INIT

function get_filename(name)
	filename = name
end

--file for recording data
local filename = "testoutput" .. tostring(filecounter) .. ".txt"
io.output(filename)
local f = assert(io.open(filename,"w"))
f:write("Run,PAC,Coefficient,MCP,Hits,Total,Proportion \n")

function segment.initialize()
	--This is a hacky way to get the number of ions that will be run.
	--Can we get this value as a parameter?
	
	if runNumber <= 1 then
		ionCount = ionCount + 1
	end
	
end


function segment.init_p_values()
	V1 = PAC
	V2 = V2Separation + V1
	V3 = V2 + MCP
	V4 = (V2 - V3)*250/270 + V3
	adj_elect01 = V2
	adj_elect02 = V1
	adj_elect03 = V4
	adj_elect04 = V2
end

function segment.terminate()
	--print(MCP .. "," .. V2Separation .. "," .. PAC)

	sim_rerun_flym = 1

    -- check if the ion has hit the detector
	if ion_px_gu > detectionBoxXMin and ion_px_gu < detectionBoxXMax and ion_py_gu > detectionBoxYMin and ion_py_gu < detectionBoxYMax then
        ionHits = ionHits + 1
    end


	-- After all ions are accounted for, record results and prepare for the next run
    if ion_number == ionCount then
    	--write to file
		--Calculates the coefficient from the MCP, PAC values
        f:write(runNumber .. "," .. PAC .. "," .. (1+V2Separation/PAC) .. "," .. MCP .. "," .. ionHits .. "," .. ionCount .. "," .. ionHits/ionCount .. "\n")

    	--set parameters for next run
        ionHits = 0
        runNumber = runNumber + 1

    	MCP = MCP + MCP_STEP
    	if MCP < MCP_MAX then
    		MCP = MCP_INIT
    		V2Separation = V2Separation + V2SEPARATION_STEP
            if V2Separation > V2SEPARATION_MAX then
    			V2Separation = V2SEPARATION_INIT
    			PAC = PAC + PAC_STEP
    		
            	if PAC < PAC_MAX then
    				sim_rerun_flym = 0 -- when all combinations have been tried, stop
    		
            	end
    		end
    	end
    end
end