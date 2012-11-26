////Begin Case.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Manages themes; each color has it's own theme

//Whether this is the front or back of the case
integer FRONT = TRUE;

//List of all images, for help
string TEX_LIST = "grate, green, circus, eagle, sky, moss, wood, cyclone, mud, funky, leopard";

default {
	link_message(integer sender_num, integer num, string str, key id){
		//Boot up the robot, and add help messages
		if(swDecodeCommand(str) == "BOOT" && FRONT) {
			swBroadcast("SETHELP", ["!tex [texture] - Change bot texture."]);
			swBroadcast("SETHELP", ["!texlist - List available textures."]);
		}
		
		//Set the texture
		if(swDecodeCommand(str) == "CMD_TEX") {
			if(llGetInventoryKey(llToLower(swA2S(str, 0)))) {
				llSetTexture(llToLower(swA2S(str, 0)), ALL_SIDES);
			}else{
				llSetTexture(TEXTURE_BLANK, ALL_SIDES);
			}
		}
		
		//List all the available textures
		if(swDecodeCommand(str) == "CMD_TEXLIST" && FRONT) {
			llSay(0, "Textures available: "+TEX_LIST);
		}
	}
	
	on_rez(integer param) {
		llResetScript();
	}
}

////End Case.lsl
