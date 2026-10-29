# Extractor mechanical CAD

## Assembly checked in Onshape

Document: [Extractor aguamiel - CAD depurado para repositorio](https://cad.onshape.com/documents/8d63edc8556e8467e15e8813/w/f6cf07018f7e5b17799cff25/e/69101facf2e8677662560864). Anyone with this link can view the assembly without editing. Anonymous view-only access was checked on 28 October 2026. Onshape export through the shared link is not enabled; use the downloadable CAD files in this repository.

The original SOLIDWORKS assembly was imported with its saved component positions, not manually rebuilt with guessed placements. A reduced native package was then imported into a second document and retained the 40 top-level instances and visible extractor geometry. Onshape reports zero mate features: this is a static imported assembly, not a rebuilt kinematic mechanism.

## Files

- `Ensamblaje1.zip`: contains the top-level original `Ensamblaje1.SLDASM` and all selected references.
- Inside the ZIP: 33 original SLDPRT files and 4 SLDASM files. Extract them together and preserve their filenames.
- The ZIP contains exactly the 37 selected native files, packaged flat for Onshape. Its name matches the top-level assembly as required by the importer.
- `Aguamiel_Extractor_Assembly.step`: assembled neutral export from Onshape, including hidden instances.
- Files alongside this README: native BOM exports, file-selection decisions, STEP check and screenshot.

The 4 native assemblies are `Ensamblaje1.SLDASM`, `Ensamblaje de mando.SLDASM`, `Ensamblaje 4.SLDASM` and `Ensamblaje3.SLDASM`.

## Selection and counts

The supplied archive contained 75 entries: one .DS_Store, one exact duplicate of the container model, and 73 unique files. The selected 37 native files are referenced by the active assembly hierarchy. The other 36 unique files were retained separately in the local working archive; absence from this assembly does not prove they are unrelated to the wider project. Alternate designs, unused subassemblies and unreferenced models were not added to the repository CAD package.

The flattened Onshape BOM has 58 rows and 73 total body instances. Several source part files contain multiple bodies (for example the repeated `pincha`, `modulo`, and `LCD3` names), so BOM rows are not equivalent to distinct native files or physical purchased components.

## Verification scope

- Correct reconstruction of the saved static assembly in Onshape.
- Native file selection based on the structured BOM.
- Successful reimport of the reduced 37-file package.
- STEP geometry: 73 solids; topology check passed.
- Bounding box of STEP: 370.00 x 786.01 x 906.93 mm in the exported orientation.

No strength, tolerance, interference, assembly-motion, food-contact, hydraulic or electrical validation is inferred from these checks. This historical CAD is supplied as design documentation; component envelopes do not independently certify actual manufacturer models or ratings. Original file timestamps are predominantly from 2021. No geometry was modified during this curation.

## Import

In Onshape, import `Ensamblaje1.zip` as a single document, retaining the assembly rather than combining everything into a Part Studio. For other CAD viewers, open the neutral STEP. The native SOLIDWORKS feature files are preserved unchanged.

Onshape import instructions: https://cad.onshape.com/help/Content/Document/importing_files.htm
BOM instructions: https://cad.onshape.com/help/Content/Assembly/working_with_the_bom_table.htm
