
Use the following definitions to customize the building process:   
- **BUILD_MP3LAME**: Docker images build options to libmp3lame. Current support value is `ON` to enable from the images or `OFF` to disable from the images. Default is ```ON```.
- **BUILD_FDKAAC**: Docker images build options to libfdk_aac. Current support value is `ON` to enable from the images or `OFF` to disable from the images. Default is ```ON```.


### Examples:   

**Keep default or existing config**
```
cd build
cmake ..
```

**Enable from the images**
```
cd build
cmake -DBUILD_MP3LAME=ON ..
```

```
cd build
cmake -DBUILD_MP3LAME=ON -DBUILD_FDKAAC=ON
```

**Disable from the images**
```
cd build
cmake -DBUILD_MP3LAME=OFF ..
```

```
cd build
cmake -DBUILD_MP3LAME=OFF -DBUILD_FDKAAC=OFF
```

