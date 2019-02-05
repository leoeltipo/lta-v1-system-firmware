System control for CCD_DAQ board.
DATE 	: 7/25/2018
AUTHOR 	: Leandro Stefanazzi

########################
### Re-build project ###
########################
1) Create new project in this directory.
2) Add sources (.vhd) located in hdl/ directory. Uncheck the option to copy sources into project.
3) Add constraints (.xdc) located in xdc directory. Uncheck the option to copy sources into project.
4) Add part number xc7a200tfbg484-2 (coud be -1 or -3 grade too). 
5) In project settings add ip/ directory as IP repository.
6) source bds/ublaze_subsystem-bd-2016-3.tcl to build Block Design.
7) Right-click on block design (sources tree) Create HDL wrapper.

Project is now ready for synthesis, implementation and bit-stream generation.

###########################
### Project description ###
###########################
CCD Controller Firmware integrating the following components:

* SPI LDO, GPIO LDO:
	Controls the digital potentiometers that regulate VDRAIN, VDD, VR and VSUB.
	The uBlaze driver is composed of files ad5293.h/.c.
	GPIOs control the enable signals of the associated LDO.

* SPI DAC, GPIO LDO:
	Controls the voltages of the clocks (high and low level) the drive the CCD.
	The uBlaze driver is on files ad5371.h/.c.
	GPIOs control clear, reset and ldac pins of AD5371 and general switch enable
	signal of the clocks (one shared enable signal for all output clock switches).

* SPI TELEMTRY, GPIO TELEMETRY:
	Controls the reading of telemetry values.
	uBlaze driver on files telemetry.h/.c.
	GPIOs control muxes for telemetry source selection.	

* SPI VOLT SW, GPIO VOLT SW:
	Controls the analog switch for enable/disable of VDD, VDRAIN, VSUB, VR, +15 and -15
	voltages.
	uBlaze driver max14802.h/.c.
	GPIOs control clr and le_n pins of MAX14802.
	
* UART:
	Used to communicate with uBlaze software (9600,8,N,1).
	Connect the serial port and a menu will prompt with options to control the board.
	uBlaze driver uart.h/.c.

* SEQUENCER:
	Block in charge of generating the sequence of the clocks to read the CCD.
	The sequence is hard-coded into the main.c file of uBlaze and transferred to the 
	sequencer after boot. Modification of the sequence requires modifying this file
	(only the array mySequence has to be modified. Size is automatically computed based
	on array contents).
	uBlaze controls the Start/Stop of the sequencer. See the menu printed on UART for more
	details.
	uBlaze driver sequencer.h/.c.
	
* Ethernet block:
	Block to interact with external world. Used in conjunction with OTS software.
	OTS must be initialized and configuration sent to be able to interact with the block.
	uBlaze driver eth.h/.c is under development to allow reading/writing configuration and board control
	state through OTS instead of serial UART.
	
* A/D 15 MHz
	Tested both Firmware and software. Due to an error in the layout, clock 
	inputs are not connected in the right position. This block solves this problem
	but requires a calibration procedure. The procedure is explained in the software
	driver of the block. Software drivers adc.h/.c.

* CDS-noncausal
	New cds core, noncausal, that allows acquisition and then accumulation of samples. The 
	detailed explanation is the software driver and the README file of the IP. Software
	drivers CDS_core.h/.c.

* Packer
	New packer block with 9 sources. This blocks allow sending 1 raw channel at a time,
	1 to 4 raw channels captured using the smart buffer block (automatically handled)
	1 CDS channel at a time, and all 4 CDS channels sequencially. Details can be found
	in the software driver and the corresponding README file of the IP. Software driver
	packer.h/.c.

* Smart Buffer.
	Block that allows capturing and storing raw data from A/D video channels to send later
	using a lower transfer speed. The block can capture 1, 2 or 4 video channels using the
	configuration registers. Software driver smart_buffer.h/.c.
	This block was modified and the memory had to be reduced (64 KSamples total buffer).

* Flash Memory
	A special SPI peripheral was added to access the on-board non-volatile flash memory.
	After the FPGA is programmed from this flash, the SPI block can access it and reads
	pre-loaded ID and IP information. This information is used to re-program the lower
	byte of both IP and MAC addresses.
	
