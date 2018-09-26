# Token to download data
token=$1

#ms1 data download
mkdir -p ms1

ms1names=$(cut -d, -f1 params/sampleInfo.csv | tail -n +2)
prefix=X

#Loop through sample info file
for i in $ms1names
do 
echo "Downloading ms1 file $i"
curl -L https://www.ebi.ac.uk/metabolights/MTBLS558/files/${i#$prefix}?token=$token -o ms1/$i.zip
unzip ms1/$i.zip -d ./ms1/
done

rm -r ms1/*.zip
