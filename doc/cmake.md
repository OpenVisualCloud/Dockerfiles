
### Customize the Build Process:

You can use the following build options to customize the build process:
- **BUILD_VERSION**: Specify the build version string.  
- **DOCKER_PREFIX**: Specify the docker image prefix string.  
- **BUILD_MP3LAME**: Set to ```ON``` (default) to build the ```libmp3lame``` in the docker images, or ```OFF``` to disable including ```libmp3lame``` in the docker images.
- **BUILD_FDKAAC**: Set to ```ON``` (default) to build the ```libfdk_aac``` in the docker images, or ```OFF``` to disable including ```libfdk_aac``` in the docker images.

Build examples:   

```bash
cd build
cmake -DBUILD_MP3LAME=ON ..
```

```bash
cd build
cmake -DBUILD_FDKAAC=ON -DBUILD_MP3LAME=OFF ..
```

### Command Make Targets

- **update_link**: Update the image links in the platform README.md.  
- **update_dockerfile**: Update the Dockerfiles. Do this after modifying any templates.  
- **generate_readme**: Generate the image README.md for dockerhub.   
- **upload_readme**: Upload the image README.md to dockerhub.  

Example: Generate the dockerhub READMEs  

```bash
cd build
cmake ..
make generate_readme
```

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
