# Arduino Nano firmware

[Download the Arduino sketch folder](ExtractorAguamiel_Arduino.zip) · [Run the Wokwi project](https://wokwi.com/projects/479154932505587713) · [Simulation source and diagram](../../simulation/wokwi/)

`ExtractorAguamiel.ino` is byte-for-byte identical to the `sketch.ino` downloaded from the supplied Wokwi project on 28 October 2026. This is the repository's reference program. It documents the control sequence. The older two-file reference program bundled in the Fritzing package is a separate earlier implementation; use this folder to reproduce the linked Wokwi program.

## Arduino IDE

1. Download and extract `ExtractorAguamiel_Arduino.zip`. Keep the folder named **ExtractorAguamiel** with **ExtractorAguamiel.ino** inside.
2. Open `ExtractorAguamiel.ino` in Arduino IDE.
3. Install **Arduino AVR Boards** and select **Arduino Nano / ATmega328P**. If uploading to an older Nano clone, its bootloader selection may differ.
4. Install **LiquidCrystal I2C by Frank de Brabander**, version **1.1.2**, through Library Manager. `Wire` is included with the Arduino core.
5. Verify/compile. Select the actual board's port before uploading. Compilation was checked with Arduino AVR Boards 1.8.6 and LiquidCrystal I2C 1.1.2; uploading to physical hardware was not performed during this repository preparation.

## Pins and behavior

| Function | Nano pin / setting |
| --- | --- |
| START button | D4 to GND, INPUT_PULLUP |
| STOP button | D3 to GND, INPUT_PULLUP |
| Pump command | D5, HIGH = ON, LOW = OFF |
| Green status LED | D6 through 1 kΩ |
| Red status LED | D7 through 1 kΩ |
| LCD SDA / SCL | A4 / A5 |
| LCD | 16 × 2 I²C, address 0x27 |

The program starts in Standby with D5 LOW. START begins extraction and latches the command after release. START while extracting does not reset the estimate. STOP has priority and returns to Standby, resetting the estimate. At an assumed **5 L/min**, the estimate reaches **10 L after approximately 120 s** of commanded pumping and enters Full/Stop. A subsequent START resets the estimate for a new cycle. The operator must supervise the actual container level and stop manually as needed; the estimate is not a measurement of collected volume.

There is no flow or level sensor. The LCD's `EST` value is calculated from elapsed time and the assumed flow. The displayed capacity text is fixed at 10 L; changing the capacity constant also requires updating those messages.

## Physical switching stage

Use the Fritzing schematic for the physical relay-board coil/contact connections, external 2N2222, 1 kΩ base resistor and 1N4004. The Wokwi relay is a digital substitute for that stage. The legacy source comment mentioning a "bare coil" refers to direct coil driving; it does not specify a conventional IN/VCC/GND relay module as the physical hardware. Regulated 5 V enters the Nano's **5V pin**, not VIN, in the documented final circuit.

Compilation and logical simulation do not establish transistor saturation, actual motor current, hydraulic performance or volumetric accuracy.
