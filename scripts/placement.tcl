
# 6.Placement

#Validates the floorplan setup and reports current core utilization.
checkDesign -floorplan
checkFPlan -reportUtil


# Pre placement settings
#ENABLES ROUTE-AWARE DETAILS PLACEMENT CHECKS; CAPS MAXIMUM GLOBEL PLACEMENT.
setPlaceMode -place_detail_check_route true
setPlaceMode -place_global_max_density 0.7
setPlaceMode -place_global_uniform_density true


#ACTIVATES ALL ACTIVE CONSTRAINTS MODES FOR INTERACTIVE TIMING ANALYSIS
# SET THE MAX FANOUT LIMIT OF 12 ON THE TOP-LEVEL DESIGN.
set_interactive_constraint_modes [all_constraint_modes -active]
set_max_fanout 12 [dbGet top.name]

# Set min and  max routing layers 
setDesignMode -topRoutingLayer 7
setDesignMode -bottomRoutingLayer 1

# Read scan_def 
#defIn ./inputs/memory_scanDEF.scandef


#Specifies MMC anaysis views for setup )fun_ss) and hold(func_ff) timinig.
set_analysis_view -setup func_ss -hold func_ff


#post placement + globel placement + legalization.
place_design
  

#CHECKS LEGALITY OF THE CURRENT PLACEMENT.(overlaps,off-grid, row/site violetions).
checkPlace


#
refinePlace


# Placement + inplacement_opt + post Placement optimization + HFNS +  fixing DRV + set up voilation7
place_opt_design


#Generate a 	3d congestion map highlighting routhing overfliow regions across all layers.
reportCongestion -3d -overflow

######################################### Timing Check ########################
timeDesign -preCTS -outDir ./reports/placement -prefix prects

# Upsizing or downsizing or Vt swapping 
ecoChangeCell -inst Top_I18 -cell BUFX20
ecoChangeCell -inst  ch3/sub_chip3_Multiplier/FE_OFC15680_n_408 -cell BUFX8
check
saveDesign ./design/placement_new.enc

