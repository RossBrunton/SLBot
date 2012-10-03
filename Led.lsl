////Begin Led.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains functions and state definition needed for the LED display

//List of all the LED displays
list DISPLAYS = [
	"blank:0000000000000000000000000000000000000000000000000000000000000000",
	"borders:1111111100000000000000000000000000000000000000000000000011111111",
	"stripes:1010101010101010101010101010101010101010101010101010101010101010"
];

//Display an image
drawImage(string image) {
	//Loop through all images looking for one with the name we want
	integer d;
	for(d = llGetListLength(DISPLAYS)-1; d >= 0; d --) {
		//Break apart the string into a list, containing [name, data]
		list fragments = llParseString2List(llList2String(DISPLAYS, d), [":"], []);
		
		if(llList2String(fragments, 0) == image) {
			//Yes, we found one, now get it's data!
			string data = llList2String(fragments, 1);
			integer i;
			
			//And loop through all the prims and have them set their colour as appropriate
			for(i = 65; i > 1; i --) {
				if(llGetSubString(data, 65-i, 65-i) == "1") {
					llSetLinkColor(i, <1, 0, 0>, ALL_SIDES);
				}else{
					llSetLinkColor(i, <0, 0, 0>, ALL_SIDES);
				}
			}
		}
	}
}

//Much of this is placeholder stuff
default {
	state_entry() {
		drawImage("blank");
	}
}

////End Led.lsl
