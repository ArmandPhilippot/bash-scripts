#! /bin/bash
# extractlinksanchors.sh
# Script to list all internal & external links with sources, destinations & anchors.
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

echo -e "This script generates a list of internal and external links with the source, destination and anchor.\n"

# We ask for the website to crawl
read -rp "Enter the site URL: " _site_url

# We create a spinner
# Thanks to Louis Marascio - http://fitnr.com/showing-a-bash-spinner.html
spinner() {
    local pid=$!
    local delay=0.75
    local spinstr='|/-\'
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
echo -e "We are browsing the site to retrieve the list of URLs. This can take time, especially if your site has a lot.\n"
echo -e "Veuillez patienter.\n"

# We store the output of wget (urls list) in a temporary text file.
wget --spider --no-check-certificate --force-html -nd --delete-after -r -l 0 "$_site_url" 2>&1 | grep '^--' | awk '{ print $3 }' | grep -v '\.\(css\|js\|png\|gif\|jpg\|ico\|webmanifest\|svg\|pdf\|txt\)$' | grep -v '\/feed\/\|selectpod\.php\|xmlrpc\.php\|matomo-proxy\.php' | sort | uniq >extractlinksanchors.txt &
spinner

# We define a separator for our CSV file.
_sep="§"

# We create our CSV files and write headers.
echo "Source${_sep}Destination${_sep}Ancre" >internal-links-list.csv
echo "Source${_sep}Destination${_sep}Ancre" >external-links-list.csv

# We display a warning message.
echo -e "We process URLs. It may take time.\n"
echo -e "Please wait."

# We read each entry, we extract links and we write values in CSV files.
while read -r _url; do
    _url_list_with_anchor="$(curl -s "$_url" | grep -o '<a .*href=.*>.*</a>' | grep -v '\.\(css\|js\|png\|gif\|jpg\|ico\|webmanifest\|svg\|pdf\|txt\)' | sed -e 's/<a/\n<a/g' | perl -pe 's/(.*?)<a .*?href=['"'"'"]([^'"'"'"]{1,})['"'"'"][^>]*?>(?:<[^>]*>){0,}([^<]*)(?:<.*>){0,}<\/a>(.*?)$/\2'"$_sep"'\3/g' | sed -e '/^$/ d')"

    # We read only internal links and we write the source and destination in CSV file.
    _int_links="$(echo "$_url_list_with_anchor" | grep -E "(${_site_url%/}|^[/#])")"
    while read -r _internal; do
        echo "${_url}${_sep}${_internal}"
    done <<<"${_int_links}" >>internal-links-list.csv &
    spinner

    # We read only external links and we write the source and destination in CSV file.
    _ext_links="$(echo "$_url_list_with_anchor" | grep -Ev "(${_site_url%/}|^[/#])")"
    while read -r _external; do
        echo "${_url}${_sep}${_external}"
    done <<<"${_ext_links}" >>external-links-list.csv &
    spinner
done <extractlinksanchors.txt &
spinner

# We delete our temporary file internal-external-links-list.txt
rm extractlinksanchors.txt

# End.
echo -e "The internal-links-list.csv and external-links-list.csv files were generated. End of script."
