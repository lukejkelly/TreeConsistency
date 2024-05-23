# install requisite packages for code in R/
while read PKG; do
    R -e "install.packages(\"$PKG\", repos = \"https://cloud.r-project.org\")"
done < requirements.txt

# check and update package list
# diff requirements.txt <(grep -oh '\w*::' R/* | sort -u | sed 's/:://g')
# grep -oh '\w*::' R/* | sort -u | sed 's/:://g' > requirements.txt
