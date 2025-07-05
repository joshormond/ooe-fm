# ooe-fm

## About

`ooe-fm` provies a sample FileMaker file with __One Of Everything__ (Ooe).

Ooe.fmp12 endeavors to have an example of one of every possible configuration of every kind of solution element.

- At least one table, field, layout, layout object, script, script step, value list, etc.
- For each kind of item, all variants, e.g. for layout objects: slide control, web viewer, button, etc.
- For each variant, all configuration permutations, e.g., a Send Mail script step that uses the default email client and another that sends via SMTP.

Achieving 100% coverage is not a realistic goal, but the hope is that over time we can accumulate examples of all of the different possible permutations to this file.

## Use case

Among other possible use cases, having these examples available makes it easier to explore the FileMaker Save-as-XML (SaXML) format.

## Credentials

Log in with admin / admin.

## SaXML encoding

- FileMaker generates XML files using UTF-16 LE encoding.
- The UTF-16 LE-encoded files are converted to UTF-8 as part of a post-processing step, so that they can be used by `diff` which requires UTF-8 to do text-based diffing.

## Keeping the SaXML files up to date

- The saxml_utf16le folder contains SaXML files generated using FileMaker clients from all versions since SaXML was first released.
- Generating the files is automated using the FMDeveloperTool which was released with SaXML v2.2.1.0 (FileMaker v20.3.2).
  - Gnerating the files using older FileMaker versions is a manual process (i.e. time consuming), so the older SaXML versions will not always be up to date.

## SaXML-FileMaker version map

| SaXML<br>version | FileMaker<br>version | FMDeveloperTool<br>available | -ddr_info<br>flag available | Available in<br>FMDeveloperTool |
|---------------|-------------------|---------------------------|---------------------|---------------------|
| 2.0.0.0 | 18.x | - | - | - |
| 2.1.0.0 | 19.0 | - | - | - |
| 2.1.0.0 | 19.1 | - | - | - |
| 2.1.0.0 | 19.2 | - | - | - |
| 2.1.0.0 | 19.3 | - | - | - |
| 2.1.0.0 | 19.4 | - | - | - |
| 2.2.0.0 | 19.5 | - | - | - |
| 2.2.0.0 | 19.6 | - | - | - |
| 2.2.1.0 | 20.x | ✅ | - | - |
| 2.2.2.0 | 21.x | ✅ | ✅ | - |
| 2.2.3.0 | 22.x | ✅ | ✅ | ✅ |
