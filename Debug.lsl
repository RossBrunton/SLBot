////Begin Debug.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// When attached to robot broadcasts debugging stuff

default {
	link_message(integer sender_num, integer num, string str, key id){
		//Send debugging messages
		llWhisper(DEBUG_CHANNEL, (string)sender_num+" > "+str);
	}
}

////End Debug.lsl
