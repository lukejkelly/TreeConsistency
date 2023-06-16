# install necessary packages for code in R/
# grep -oh '\w*::' R/* | sort -u | sed 's/:://g' > requirements.txt
while read PKG; do
    R -e "install.packages(\"$PKG\", repos = \"https://cloud.r-project.org\")"
done < requirements.txt
