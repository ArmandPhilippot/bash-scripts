#! /bin/bash
# extract-website-info.sh
# Script to extract some data for all website pages: header status, title, meta description, meta robots, links number and external links number.
# Originally written by Armand Philippot <contact@armandphilippot.com>.

###############################################################################
#
# MIT License

# Copyright (c) 2020 Armand Philippot

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
###############################################################################

echo -e "This script allows you to extract the content of title, meta description and meta robots elements, header status and links number.\n"

# We are testing whether Lynx is installed. If it is not, we stop the script.
if command -v lynx &>/dev/null; then
    echo -e "Lynx is installed, let's continue.\n"
else
    echo -e "Lynx is not installed. Please install it to use this script.\n"
    exit 2
fi

# We ask for the website to crawl
read -rp "Enter the website URL: " _site_url

# We create a spinner
# Thanks to Louis Marascio - http://fitnr.com/showing-a-bash-spinner.html
spinner() {
    local pid=$!
    local delay=0.75
    local spinstr='-\|/'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# We display a warning message.
echo -e "We are browsing the website to retrieve the URL list. It may take time, especially if your website has a lot.\n"
echo -e "Please wait.\n"

# We store the output of wget (urls list) in a temporary text file.
wget --spider --no-check-certificate --force-html -nd --delete-after -r -l 0 "$_site_url" 2>&1 | grep '^--' | awk '{ print $3 }' | grep -v '\.\(css\|js\|png\|gif\|jpg\|ico\|webmanifest\|svg\|pdf\|txt\)$' | grep -v '\/feed\/\|selectpod\.php\|xmlrpc\.php\|matomo-proxy\.php' | sort | uniq >extract-website-info.txt &
spinner

# We define a separator for our CSV file.
_sep=";"

# We create our CSV file and write headers.
echo "URL${_sep}Header Status${_sep}Title${_sep}Meta description${_sep}Meta robots${_sep}Links number${_sep}External links number" >extract-website-info.csv

# We display a warning message.
echo -e "We process URLs. It may take time.\n"
echo -e "Please wait."

# We read each entry, we extract title and meta description and we write values in CSV file.
while read -r _url; do
    _header="$(curl -s -o /dev/null -w '%{http_code}' -I "$_url")"
    _curl_output="$(curl -s "$_url")"
    _title="$(echo "$_curl_output" | awk 'BEGIN{IGNORECASE=1;FS="<title>|</title>";RS=EOF} {print $2}' | sed -e '/^$/ d')"
    _description="$(echo "$_curl_output" | sed -n 's/.*<meta name="description" content="\([^"]*\)".*/\1/p')"
    _robots="$(echo "$_curl_output" | sed -n 's/.*<meta name="robots" content="\([^"]*\)".*/\1/p')"
    _lynx_output="$(lynx -dump -listonly -nonumbers "$_url")"
    _links="$(echo "$_lynx_output" | wc -l)"
    _ext_links="$(echo "$_lynx_output" | grep -vc "${_url}")"
    echo "${_url}${_sep}${_header}${_sep}\"${_title}\"${_sep}\"${_description}\"${_sep}\"${_robots}\"${_sep}${_links}${_sep}${_ext_links}"
done <extract-website-info.txt >>extract-website-info.csv &
spinner

# We delete our temporary file extract-website-info.txt
rm extract-website-info.txt

# End.
echo -e "The file extract-website-info.csv was generated. End of script."
