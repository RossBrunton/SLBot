////Begin DispenseButton.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Controls robot dispensing

default {
	touch_start(integer stupid) {
		//Ask the user what colour robot they want
		llDialog(llDetectedKey(0), "Do you want a robot!? What colour!?", ["Yellow", "Cyan", "Magenta", "Red", "Green", "Blue"], 1);
	}
}

////End DispenseButton.lsl
