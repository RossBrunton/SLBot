////Begin Dispenser.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Dispenses robots

default {
	state_entry() {
		Listen for all the colours on channel 1
		llListen(1, "", "", "Red");
		llListen(1, "", "", "Green");
		llListen(1, "", "", "Blue");
		llListen(1, "", "", "Yellow");
		llListen(1, "", "", "Cyan");
		llListen(1, "", "", "Magenta");
	}

	listen(integer channel, string name, key id, string message) {
		//Create and init a robot of the colour, and init it
		llRezObject("Bot", llGetPos(), <0.0, 0.0, 0.0>, <0.0, 0.0, 0.0, 0.0>, 0);
		llSleep(4.0);
		llSay(1, "STARTUP\t"+(string)id+"\t"+name+"\t"+message);
	}
}

////End Dispenser.lsl
