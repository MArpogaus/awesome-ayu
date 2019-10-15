--------------------------------------------------------------------------------
-- @File:   config.lua
-- @Author: Marcel Arpogaus
-- @Date:   2019-07-02 09:49:44
-- [ description ] -------------------------------------------------------------
-- configure the theme here
-- [ changelog ] ---------------------------------------------------------------
-- @Last Modified by:   Marcel Arpogaus
-- @Last Modified time: 2019-09-29 23:17:20
-- @Changes: 
-- 		- newly written
-- 		- ...
--------------------------------------------------------------------------------

local module = {}

-- Your city for the weather forcast widget
module.city_id = 2658372
-- Load color schemes from xresources
module.use_xresources = true
-- number of cpu cores
module.num_cpus = 8

return module