# extract-website-info

This Bash script extracts some information from a website: internal URLs, header status, title, meta description, meta robots, links number, external links number.

## Introduction

This Bash script allows you to monitor your website. It generates a list of internal URLs. For each page, the script extracts:

- the header status
- the content of the title element
- the content of the meta description element
- the content of the meta robots element
- the number of links on the page
- the number of external links on the page

## Requirements

- [Lynx](https://lynx.browser.org/)

## Usage

Download the file extract-website-info.sh, then in a terminal :

```
sh extract-website-info.sh
```

Now, you have to wait until the script has finished its work. If your site is large, it may take a while.

A CSV file will be generated with all of the information listed above.

## Customization

- The default separator is `;`. You can change it.
- I excluded some URLs in the script (images, CSS, PDF, ...), but it may be insufficient for your website. If you know what you're doing, you can add more.
- You can add new columns if you know Bash.

## Disclaimer

The script isn't perfect, I'm still beginning with Bash. It is possible that the script doesn't work for your website and that it needs some adaptations:

- If the meta description or the meta robots doesn't exist, the script doesn't work. The generated file will contain some code rather than the needed information. These elements can be empty but they must exist.
- If the title element contains additional content, the script will not work. It must be `<title>` and not `<title dataSomething>`.
- Some cache plugins remove double quotes from meta description and meta robots. The script will not work.

To use this script, Lynx must be installed. It may be possible to do otherwise, but since I use Lynx, I haven't looked.

The larger your site are, the longer the processing will take. Maybe Bash isn't the best option for you.

## Changelog

| Date       | Notes                 |
| :--------- | :-------------------- |
| 2020-05-27 | Change of repository. |
| 2020-03-24 | Initial version.      |

## License

This script is licensed under the MIT license. A copy of the license is included in the root of the script’s directory. The file is named LICENSE.
