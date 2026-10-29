# Portable Fritzing project

[Download Extractor_Aguamiel_Portable.fzz](https://github.com/erickaxelpadillagarcia/aguamiel-extractor/raw/refs/heads/main/electronics/fritzing/Extractor_Aguamiel_Portable.fzz)

## Open the diagrams

1. Install Fritzing (tested with version 1.0.6).
2. Download **Extractor_Aguamiel_Portable.fzz** using the download/raw button on GitHub. Do not download the file preview as HTML.
3. In Fritzing, choose **File > Open** and select the `.fzz` file.
4. Select **Breadboard** for the component representation or **Schematic** for the connected circuit.

All **17 custom parts and their SVG graphics are embedded**. No separate part-library download or manual component installation is required. Keep the `.fzz` extension; extracting its contents is unnecessary.

The final supplied project was repaired by embedding the missing parts and replacing computer-specific references. Breadboard/schematic positions, wire geometry and connections were preserved. Opening both views and saving/reopening a separate copy were checked in Fritzing 1.0.6; the saved copy retained all 17 parts. Invisible PCB-view placeholders allow this version of Fritzing to retain the diagram parts when saving. **There are no manufacturing footprints or a validated PCB layout.** Other Fritzing versions have not been tested.

## Circuit represented

- 12 V battery powers the pump through the relay contacts and a 12-to-5 V converter supplies the electronics.
- Regulated 5 V feeds the Nano **5V pin** (not VIN), LCD and relay coil; grounds are shared.
- D5 drives an **external** 2N2222 through a 1 kΩ base resistor. The emitter connects to ground and collector to the relay coil negative terminal.
- External 1N4004 across the coil: cathode to +5 V, anode to coil negative.
- The relay-board drawing represents access to coil/contact connections. It is not a generic IN/VCC/GND driver module.
- START D4 and STOP D3 switch to ground; the included reference program uses internal pull-ups. LEDs use D6/D7; LCD uses A4 SDA and A5 SCL.

## Program and verification scope

The bundled `.ino` and `.h` files are an earlier two-file reference implementation; the standalone Arduino folder contains the program matching the supplied Wokwi project. Viewing/editing the diagrams requires no Arduino libraries. Compiling the reference firmware separately requires an Arduino toolchain and its LCD library dependency (`LiquidCrystal_I2C`).

Fritzing is used here to document the hardware connections. This file does not demonstrate Arduino execution, pump hydraulics, transistor saturation or electrical performance. Wokwi provides a separate control-logic simulation.

## Attribution

Existing part artwork attribution is retained inside the embedded component definitions. Distribution of this project does not replace the licenses applicable to third-party artwork, nor establish a new license for the research materials.
