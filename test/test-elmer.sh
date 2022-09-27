cd ..
# release mfem src code
rm -rf tmp/elmer
tar xzvf ./downloads/elmerfem-scc20.tar.gz -C tmp/
# copy templates
cp -rf templates/elmer/8.4/data.elmer.amd.cpu.config ./
# switch to config
./jarvis -use data.elmer.amd.cpu.config
# install dependency
./jarvis -dp
# build
./jarvis -b
# run
./jarvis -r