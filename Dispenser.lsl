////Begin Dispenser.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Dispenses robots

dispenseRobot() {
	llRezObject("Bot", llGetPos(), <0.0, 0.0, 0.0>, <0.0, 0.0, 0.0, 0.0>, 0);
}

default {
	state_entry() {
		llListen(1, "", "", "Red");
		llListen(1, "", "", "Green");
		llListen(1, "", "", "Blue");
		llListen(1, "", "", "Yellow");
		llListen(1, "", "", "Cyan");
		llListen(1, "", "", "Magenta");
	}

	listen(integer channel, string name, key id, string message) {
		dispenseRobot();
		llSleep(4.0);
		llSay(1, "STARTUP\t"+(string)id+"\t"+name+"\t"+message);
	}
}

////End Dispenser.lsl
