/*
  Panda encoder software for Arduino.  Written by Graham Pegg and Isaac Smirle.
  V .05 ALPHA, 2/15, 2015

************************************************************************************************************************************************************************************************* 
                                    READ THE README FILE FOR PROPER SETUP AND VARIABLES, AUTHORS ARE NOT RESPONSIBLE FOR ANY DAMAGE TO YOUR ARDUINO BOARDS
                THE ASSOCIATED COMPUTER INTERFACE PROGRAM IS NESSICARY FOR COMMUNICATION, IS INCLUDED IN THE "SOFTWARE" FOLDER OF THE DOWLOAD AND HAS A DEDICATED INSTRUCTION FILE
************************************************************************************************************************************************************************************************* 


 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 This is a linear serial communication encryptor.  It can take in a 1024 byte string of data, encrypt it, and send it to a second reciver board.  It uses a Diffie-Hellman key exchange to setup
 an encryption key, then a series of mathmatical operation on the key to determin a scrambler operation and then encrypts the scrambled data.  It then sends the data to the second arduino
 board where it is decrypted and outputed as the original data. The Diffie-Hellman exchange then re-occures with different keys, and the next 1024 bytes of data are encrypted and sent.
 There are two levels of encryption and they both change every 1024 bytes of data, or about every second.  By the time a single 1024 byte data packet is decrypted, hundreds of thousands
 more could be sent.  One package would take around a week to decrypt by a standard supercomputer.
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 This program is currently in the test and development stage.  Currently the prime modulous and primitive root are very small and weak, resulting in weak encryption.  Do not attempt to use
 this program as a secure network, it can be easily cracked.  This problem will be resolved when the program is stable and in 

 This encoding software was designed for the Arduino Due, allthough it can work with any arduino board that has multiple serial communication channels
 This software was made as an extention of Panda, a Diffie-Hellman key exchange program written by Graham Pegg, available from Github under the GNU General Public License.
 This encryption device is designed for recreational use; the use of this software in no way reflects the intent, beliefs or want of the programmers.
 This software is licensed under the GNU General Public License, a copy of witch can be found in the INFORMATION folder of this download, along with the README and SETUP documents. 



*/

int serialMode = 0;              // Tells what is being sent and recived between the computer and the board
int serial1Mode = 0;             // Tells what is being sent and recived between the computer and the board
int computerCall = 0;            // Counts the attemps made to retrive data from the computer
long encryption2 = 0;             // This is the second layer encryption key
long encryption1 = 0;             // This is the first layer encryption key
long Keystart = 45000;           // The starting key; is arbatrary
long randNumber = 0;             // Where the random secret number is stored
long publicKey = 0;              // Where the public key is stored
long sharedKey = 0;              // Where the second board's public key is stored
long sharedsecret = 0;           // Where the encryption base it stored
String encryptedIn = "";         // Where the recived encrypted data is stored
String encryptedOut = "";        // Where the encrypted data to be sent is stored
String input = "";               // Where the data to be encrypted is stored
String output = "";              // Where the decrypted data is stored
boolean Send = false;            // Sets if the computer - board serial is sending
boolean Recive = false;          // Sets if the computer - board serial is reciving
boolean encryptedSend = false;   // Sets if the board - board serial is sending
boolean encryptedRecive = false; // Sets if the board - board serial is reciving
boolean boardOut = false;        // Tells if the encrypted data is ready to be sent
boolean computerIn = false;      // Tells if the board is ready to accept a new 1024 byte data packet to be encrypted
boolean computerOut = false;     // Tells if the board is ready to output a decrypted 1024 byte data packet
boolean changeKey = false;       // Controls when the secret numbers need to be changed
boolean changeKeyprog = false;   // Tells if the key is in the process of being updated
boolean dataEncrypt = false;     // Tells if there is data that needs to be encrypted
boolean dataDecrypt = false;     // Tells if there is data that needs to be decrypted
boolean error = false;           // Tells if the program has had an error

void setup() {
  input.reserve(1024);         // The maximum input package is 1024 bytes
  output.reserve(1024);        // Sets the output size to be 1024 bytes
  encryptedIn.reserve(1024);   // Sets the string to recive 1024 bytes of encrypted data
  encryptedOut.reserve(1024);  // Sets the string to hold 1024 bytes of encrypted data to be sent
  Serial.begin(9600);          // The serial communication with the input is initilized at 9600 bps on the first serial port, can be increased
  Serial1.begin(9600);         // The serial communication between the arduinos is initilized at 9600 bps
} 
  
void loop() {                   
  if(boardOut = true){
    while(encryptedSend = true){
    }
    while(encryptedRecive = true){
    }
    Serial1.write("ecryptedOut");
    changeKey = true;
  }
  
  if(computerOut = true){
    while(Send = true){
    }
    while(Recive = true){
    }
    Serial.write("output");
  }
  
  if(computerIn = true){
    Serial.write(01);
    if (Serial.available( > 0)){
      input = Serial.read();
      goto encryption;
    }
    while(Serial.available(= 0)){
      waiting:
      delay(1000);
      computerCall+1;
      if(computerCall>10) error = true;
      if (error = true) goto errorCorrection;
      goto waiting;
    }
  }
  
  if(Serial1.available(>0)){
    encryptedIn = Serial1.read();
    goto decryption;
  
  if(changeKey = true){
    changeKeyprog = true;                         
    randNumber = random(10, 99999); 
    publicKey = 3^randNumber % 17;                //  --CURRENTLY IN ALPHA STAGE, CHANGE PRIME MODULOUS AND PRIMITIVE ROOT--
  }
  
  errorCorrection:  
  

  encryption:     
/* Currently has two levels of encryption, can be layered based on the shared secret key number.  The 
   first level is a digital version of a twenty-three rotor enigma machine, and the second
   layer again scambles the secret key and encrypts the scrambled message to a string of characters. */
   
   
  
  decryption:
  
  
}    
