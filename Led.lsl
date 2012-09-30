////Begin Pseudofile Led.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains functions and state definition needed for the LED display

list displays = [
	"blank:0000000000000000000000000000000000000000000000000000000000000000",
	"borders:1111111100000000000000000000000000000000000000000000000011111111",
	"stripes:1010101010101010101010101010101010101010101010101010101010101010"
];

drawImage(string image) {
	integer d;
	for(d = llGetListLength(displays)-1; d >= 0; d --) {
		list fragments = llParseString2List(llList2String(displays, d), [":"], []);
		
		if(llList2String(fragments, 0) == image) {
			string data = llList2String(fragments, 1);
			integer i;
			for(i = llGetObjectPrimCount(llGetKey()); i > 1; i --) {
				if(llGetSubString(data, 65-i, 65-i) == "1") {
					llSetLinkColor(i, <1, 0, 0>, ALL_SIDES);
				}else{
					llSetLinkColor(i, <0, 0, 0>, ALL_SIDES);
				}
			}
		}
	}
}

default {
	state_entry() {
		drawImage("checkers");
	}
}

////End Pseudofile Led.lsl
