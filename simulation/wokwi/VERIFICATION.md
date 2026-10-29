# Verification record — 28 October 2026

- The supplied Wokwi sketch compiled and ran in the browser.
- Observed Standby: `AGUAMIEL READY`, estimate zero, red indicator on.
- START: `EXTRACTING`, increasing time-based estimate, green indicator on.
- Timed cutoff: `FULL / STOP`, `REPLACE + START`; serial output reported 10 L estimated and pump deactivated. This is software behavior, not a measured 10 L transfer.
- START after Full/Stop began a new estimate from zero.
- STOP during extraction returned to Standby and reset the estimate.
- Arduino IDE copy is byte-for-byte identical to the downloaded Wokwi sketch, with only its filename changed.
- Independent Nano compilation: Arduino AVR Boards 1.8.6, LiquidCrystal I2C 1.1.2 from the official Arduino library index. The library ZIP SHA-256 was checked against the index.
- Nano compile result: 9544 bytes flash (31% of 30720), 546 bytes static SRAM (26% of 2048).
- No upload to physical hardware, analog transistor/relay validation, hydraulic test or field measurement was performed during this check.

The indicator circuit and relay-module connections in Wokwi are simulation substitutes. Physical wiring is documented separately in Fritzing.
