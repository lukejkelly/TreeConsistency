# install requisite packages for code in R/
while read PKG; do
    R -e "install.packages(\"$PKG\", repos = \"https://cloud.r-project.org\")"
done < requirements.txt

# check and update package list
shopt -s globstar
diff requirements.txt <(grep -oh '\w*::' code/**/*.R | sort -u | sed 's/:://g')
grep -oh '\w*::' code/**/*.R | sort -u | sed 's/:://g' > requirements.txt

# print package version numbers
while read PKG; do
    R -e "packageVersion(\"$PKG\")"
done < requirements.txt
