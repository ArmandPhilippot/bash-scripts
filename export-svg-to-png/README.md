# exportSvgToPng

This Bash script exports all of your SVG files to PNG in different sizes using Inkscape.

## Use

Run the script in a terminal using `sh filename.sh`.

The script will ask you for more information before executing:

- the folder path to be processed,
- the path to the output folder,
- the number of sizes desired,
- the desired sizes.

## Instructions

This script is to be used for creating icons for example. The files must have a height equal to the width.

- The folder to be processed must follow the following structure:

```bash
folder
├── subdirectory1
|   ├── file1.svg
|   ├── file2.svg
|   ├── ...
├── subdirectory2
|   ├── file1.svg
|   ├── file2.svg
|   ├── ...
├── ...
```

- The sizes must be entered in pixels. If you want a file that is 48 pixels \* 48 pixels, you must enter 48.

- The result will have the following structure:

```bash
outputFolder
├──24x24
|   ├── subdirectory1
|   |   ├── file1.png
|   |   ├── file2.png
|   |   ├── ...
    ├── subdirectory2
|   |   ├── file1.png
|   |   ├── file2.png
|   |   ├── ...
├──48x48
|   ├── subdirectory1
|   |   ├── file1.png
|   |   ├── file2.png
|   |   ├── ...
    ├── subdirectory2
|   |   ├── file1.png
|   |   ├── file2.png
|   |   ├── ...
├── ...
```

## Changelog

| Date       | Notes                                                              |
| :--------- | :----------------------------------------------------------------- |
| 2020-05-27 | Translation of instructions in English, update of Inkscape command |
| 2020-02-19 | Initial version - No history, formerly a gist                      |

## License

This script is licensed under the MIT license. A copy of the license is included in the root of the script’s directory. The file is named LICENSE.
