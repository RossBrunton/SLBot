////Begin Led.lsl
// Ross Brunton <rb221@hw.ac.uk>
// Part of bot pet thing.
// Contains functions and state definition needed for the LED display

//From: http://wiki.secondlife.com/wiki/StringReverse
string uStringReverse( string vStrSrc ){
    integer vIntCnt = llStringLength( vStrSrc );
    while (vIntCnt){
        vStrSrc += llGetSubString( vStrSrc, (vIntCnt = ~-vIntCnt), vIntCnt );
    }
    return llGetSubString( vStrSrc, llStringLength( vStrSrc ) >> 1, 0xFFFFFFFF );
}
/*//--                       Anti-License Text                         --//*/
/*//     Contributed Freely to the Public Domain without limitation.     //*/
/*//   2009 (CC0) [ http://creativecommons.org/publicdomain/zero/1.0 ]   //*/
/*//  Void Singer [ https://wiki.secondlife.com/wiki/User:Void_Singer ]  //*/
/*//--                                                                 --//*/

//List of all the LED displays
list DISPLAYS = [
	"blank:0000000000000000000000000000000000000000000000000000000000000000",
	"borders:1111111100000000000000000000000000000000000000000000000011111111",
	"stripes:1010101010101010101010101010101010101010101010101010101010101010",
	"creeper:0000000001100110011001100001100000111100001111000010010000000000",
	"boot:0000000001000010000110000011110000111100000110000100001000000000",
	"checker:1010101001010101101010100101010110101010010101011010101001010101",
	"square:0000000000000000001111000011110000111100001111000000000000000000",
	"1:0000000000011000001110000001100000011000000110000011110000000000",
	"2:0000000000011000001001000000010000001000000100000011110000000000",
	"3:0000000000011000000001000001100000000100000001000001100000000000",
	"4:0000000000000100000011000001010000100100001111100000010000000000",
	"5:0000000000111100001000000011100000000100001001000001100000000000",
	"6:0000000000011000001000000011100000100100001001000001100000000000",
	"7:0000000000111000000010000000100000010000000100000001000000000000",
	"8:0000000000011000001001000001100000100100001001000001100000000000",
	"9:0000000000011000001001000001110000000100001001000001100000000000",
	"0:0000000000011000001001000010010000100100001001000001100000000000",
	"heads:0000000000111100010000100101101001011010010000100011110000000000",
	"tails:0000000000111100010000100100001001000010010000100011110000000000",
	"rock:0000000000000000000110000011110001111110001111000000000000000000",
	"paper:0000000001111110010000100100001001000010010001100111110000000000",
	"scissors:0000000000100100001001000010010000011000001001000110011000000000"
];

//List of all images, for help
string IMAGE_LIST = "blank, borders, stripes, square, checker, creeper, heads, tails, rock, paper, scissors, 0-9";

//Start index
integer START = 86;

//Invert mode
integer invert;

//Current image
string curImage;

//Display an image
drawImage(string image) {
	//Set the image
	curImage = image;
	
    //Loop through all images looking for one with the name we want
    integer d;
    for(d = llGetListLength(DISPLAYS)-1; d >= 0; d --) {
        //Break apart the string into a list, containing [name, data]
        list fragments = llParseString2List(llList2String(DISPLAYS, d), [":"], []);
        
        if(llList2String(fragments, 0) == image) {
            //Yes, we found one, now get it's data!
            string data = uStringReverse(llList2String(fragments, 1));
            integer i;
            
            //And loop through all the prims and have them set their colour as appropriate
            for(i = 65; i >= 0; i --) {
                if((llGetSubString(data, 65-i, 65-i) == "1" && !invert) || (llGetSubString(data, 65-i, 65-i) == "0" && invert)) {
                    llSetLinkColor(START-i, <1, 0, 0>, ALL_SIDES);
                }else{
                    llSetLinkColor(START-i, <0, 0, 0>, ALL_SIDES);
                }
            }
        }
    }
}


default {
	link_message(integer sender_num, integer num, string str, key id){
		//Set the image
		if(swDecodeCommand(str) == "CMD_IMG" || swDecodeCommand(str) == "IMG") {
			drawImage(swA2S(str, 0));
		}
		
		//List all the available images
		if(swDecodeCommand(str) == "CMD_IMGLIST") {
			llSay(0, "Images available: "+IMAGE_LIST);
		}
		
		//Set invert
		if(swDecodeCommand(str) == "CMD_INVERT") {
			if(invert) {
				invert = FALSE;
			}else{
				invert = TRUE;
			}
			
			drawImage(curImage);
		}
		
		//On bot startup
		if(swDecodeCommand(str) == "BOOT") {
			//Set the user help
			swBroadcast("SETHELP", ["!img [image] - Display an image."]);
			swBroadcast("SETHELP", ["!imglist - List all available images."]);
			swBroadcast("SETHELP", ["!invert - Invert the colours on the screen."]);
			
			//Draw a blank image
			drawImage("blank");
		}
	}
	
	on_rez(integer param) {
		llResetScript();
	}
}

////End Led.lsl
