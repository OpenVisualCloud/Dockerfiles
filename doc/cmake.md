
### Customize Build Process:

You can use the following build options to customize the build process:
- **BUILD_MP3LAME**: Set to ```ON``` (default) to build the ```libmp3lame``` in the docker images, or ```OFF``` to disable including ```libmp3lame``` in the docker images.
- **BUILD_FDKAAC**: Set to ```ON``` (default) to build the ```libfdk_aac``` in the docker images, or ```OFF``` to disable including ```libfdk_aac``` in the docker images.
- **UPDATE_DOCKERFILES**: Set to ```ON``` to update the Dockerfiles only without actually building them, or ```OFF``` (default) to update and build the Dockerfiles.
- **UPDATE_IMAGELIST**: Set to ```ON``` to update the image list in each platform README.md.
- **UPDATE_IMAGE_README**: Set to ```ON``` to update/generate the README file for all Dockerfiles.
- **UPDATE_DOCKERHUB_README**: Set to ```ON``` to upload image README.md to docker hub. Install `jq` if it is not available on your platform. 

Build examples:   

```
cd build
cmake -DBUILD_MP3LAME=ON ..
```

```
cd build
cmake -DBUILD_FDKAAC=ON -DBUILD_MP3LAME=OFF ..
```
#### Generate README files:
`python3` is required on the host system to use this.

    cd build
    cmake -UPDATE_IMAGE_README=ON ..

### Use Alternative Repo:

Certain source repo might be blocked in certain network. You can specify alternative repos before the build command as follows:

```bash
export AOM_REPO=...
export VPX_REPO=...
make
```

For a list of all REPOs and their versions, run the following command:

```bash
grep -E '_(REPO|VER)=' template/*.m4
```
~


