////Begin Games.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Fun stuff!

list FORTUNES = [
	"Good luck will shine upon you.",
	"Bad luck will discolour your day.",
	"You will feel threatened by a new foe.",
	"You will have a great loss today."
];

default {
	link_message(integer sender_num, integer num, string str, key id){
		if(swDecodeCommand(str) == "BOOT") {
			swBroadcast("SETHELP", ["!rolldie [sides] - Roll an up to 9 sided die."]);
			swBroadcast("SETHELP", ["!flip - Flips a coin."]);
			swBroadcast("SETHELP", ["!fortune - Tells you your fortune."]);
		}
		
		if(swDecodeCommand(str) == "CMD_FORTUNE") {
			llSay(0, "Fortune: " + llList2String(FORTUNES, (integer)llFrand(llGetListLength(FORTUNES)-1)));
		}
		
		if(swDecodeCommand(str) == "CMD_ROLLDIE") {
			if(swA2I(str, 0) < 10 && swA2I(str, 0) > 0) {
				sides = swA2I(str, 1);
			}else{
				sides = 6;
			}
			
			swBroadcast("IMG", [(string)(((integer)llFrand(sides))+1)]);
		}
		
		if(swDecodeCommand(str) == "CMD_FLIP") {
			if(llFrand(1) > 0.5) {
				swBroadcast("IMG", ["heads"]);
			}else{
				swBroadcast("IMG", ["tails"]);
			}
		}
	}
	
	on_rez(integer param) {
		llResetScript();
	}
}

////End Games.lsl
