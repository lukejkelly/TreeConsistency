while read PKG; do
    R -e "install.packages(\"$PKG\", repos = \"https://cloud.r-project.org\")"
done < requirements.txt
