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
		float chance = llFrand(1);
		
		if(swDecodeCommand(str) == "BOOT") {
			swBroadcast("SETHELP", ["!rolldie [sides] - Roll an up to 9 sided die."]);
			swBroadcast("SETHELP", ["!flip - Flips a coin."]);
			swBroadcast("SETHELP", ["!fortune - Tells you your fortune."]);
		}
		
		if(swDecodeCommand(str) == "CMD_FORTUNE") {
			llSay(0, "Fortune: " + llList2String(FORTUNES, (integer)llFrand(llGetListLength(FORTUNES)-1)));
		}
		
		if(swDecodeCommand(str) == "CMD_ROLLDIE") {
			integer sides = 6;
			if(swA2I(str, 0) < 10 && swA2I(str, 0) > 0) {
				sides = swA2I(str, 1);
			}
			
			swBroadcast("IMG", [(string)(((integer)llFrand(sides))+1)]);
		}
		
		if(swDecodeCommand(str) == "CMD_FLIP") {
			if(chance > 0.5) {
				swBroadcast("IMG", ["heads"]);
			}else{
				swBroadcast("IMG", ["tails"]);
			}
		}
		
		if(swDecodeCommand(str) == "CMD_ROCK") {
			if(chance > 0.666666666666) {
				swBroadcast("IMG", ["rock"]);
				llSay(0, "It's a draw!");
			}else if(chance < 0.3333333333) {
				swBroadcast("IMG", ["paper"]);
				llSay(0, "I win!");
			}else{
				swBroadcast("IMG", ["scissors"]);
				llSay(0, "I lose!");
			}
		}
		
		if(swDecodeCommand(str) == "CMD_PAPER") {
			if(chance > 0.666666666666) {
				swBroadcast("IMG", ["rock"]);
				llSay(0, "I lose!");
			}else if(chance < 0.3333333333) {
				swBroadcast("IMG", ["paper"]);
				llSay(0, "It's a draw!");
			}else{
				swBroadcast("IMG", ["scissors"]);
				llSay(0, "I win!");
			}
		}
		
		if(swDecodeCommand(str) == "CMD_SCISSORS") {
			if(chance > 0.666666666666) {
				swBroadcast("IMG", ["rock"]);
				llSay(0, "I win!");
			}else if(chance < 0.3333333333) {
				swBroadcast("IMG", ["paper"]);
				llSay(0, "I lose!");
			}else{
				swBroadcast("IMG", ["scissors"]);
				llSay(0, "It's a draw!");
			}
		}
	}
	
	on_rez(integer param) {
		llResetScript();
	}
}

////End Games.lsl
