# Wokwi control-logic simulation

**[Open and run Aguamiel v1.0 in Wokwi](https://wokwi.com/projects/479154932505587713)**

[Download the complete Wokwi project ZIP](Aguamiel_Wokwi.zip) · [Arduino IDE sketch](../../firmware/ExtractorAguamiel/)

This folder preserves `sketch.ino`, `diagram.json`, `libraries.txt` and `wokwi-project.txt` downloaded from the supplied project on 28 October 2026. The snapshot includes the editor's downloaded state; the live project may subsequently change. File hashes are recorded in `provenance.json`.

## Run

1. Open the project link and press the green simulation button.
2. Press **START** (keyboard **S**) to start extraction.
3. The green LED and `EXTRACTING` LCD message indicate the active command; the LCD displays time-estimated volume.
4. Press **STOP** (keyboard **X**) to stop and reset the estimate.
5. For the timed cutoff, let extraction run for approximately **120 simulated seconds**. The LCD then displays `FULL / STOP` and `REPLACE + START`.
6. START begins a new cycle with the estimate reset. Supervision of actual container filling remains necessary in the physical device.

For an editable copy, use Wokwi's **Save a copy**. The ZIP contains the source, diagram and library list for recreating the project. It is not an offline standalone simulator. Wokwi installs the dependency listed in `libraries.txt`; no custom Wokwi chips are required. The supplied list does not pin a library version. The identical Arduino sketch was separately compiled using LiquidCrystal I2C 1.1.2 and Arduino AVR Boards 1.8.6.

## Representation and limits

The Arduino Nano, buttons, LCD and status indicators support evaluation of the software sequence. The relay module is a **digital substitute** for the physical board with direct coil access and external 2N2222/resistor/diode. The blue LED is a **pump-command indicator**, not a 12 V pump model. Its simulated circuit uses 5 V, not the physical pump supply.

The supplied diagram retains its original `pnp` relay attribute and **NC** connection. Do not copy these relay-module connections as the physical extractor wiring; consult the Fritzing schematic, which documents the real NO/contact and external coil-driver arrangement. This snapshot does not model the converter, the 2N2222 base/collector currents, saturation, relay-coil transients, battery discharge, liquid transfer or delivered volume.

The source is reference software for documenting the control logic. No hardware measurements are inferred from these simulations.

Reference: [Wokwi relay module documentation](https://docs.wokwi.com/parts/wokwi-relay-module), [library handling](https://docs.wokwi.com/guides/libraries).
