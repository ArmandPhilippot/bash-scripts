# extractLinksAnchors

Extract all links & anchors from your website.

## Use

Run the script in a terminal using `sh filename.sh`.

The script will ask for your site URL before continuing.

It will recover all the URLs of your site before browsing them one by one to recover all the links present on the page with the associated anchor. This information will be stored in two different CSV files:

- `internal-links-list.csv`
- `external-links-list.csv`

The default separator is `§` but you can change it in the script. I made this choice because it is a character that is unlikely to be in a link or in the anchor.

## Changelog

| Date       | Notes            |
| :--------- | :--------------- |
| 2020-05-27 | Initial version. |

## License

This script is licensed under the MIT license. A copy of the license is included in the root of the script’s directory. The file is named LICENSE.
