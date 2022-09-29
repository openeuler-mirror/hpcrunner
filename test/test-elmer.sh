cd ..
# release elmer src code
rm -rf tmp/elmerfem-scc20
tar xzvf ./downloads/elmerfem-scc20.tar.gz -C tmp/
tar xzvf ./downloads/ElmerTutorialsFiles_nonGUI.tar.gz -C tmp/elmerfem-scc20
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