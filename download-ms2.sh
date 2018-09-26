# Token to download data
token=$1

#ms2 data download
mkdir -p ms2

ms2names=$(tail -n +2 params/ms2.csv)

#Loop through sample info file
for i in $ms2names
do 
echo "Downloading ms2 file $i"
curl -L https://www.ebi.ac.uk/metabolights/MTBLS558/files/${i}?token=$token -o ms2/$i.zip
unzip ms2/$i.zip -d ./ms2/
done

rm -r ms2/*.zip
