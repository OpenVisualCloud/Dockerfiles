
Use the following definitions to customize the building process:   
- **SECURITY_STRICT**: Specify the security strict build options: ```Yes``` or ```No```. Default is ```No```. Currently security will disable building LAME from the images.   

### Examples:   

**Keep default or existing config**
```
cd build
cmake ..
```

**Disable security strict build**
```
cd build
cmake -DSECURITY_STRICT=No ..
```

**Enable security strict build**
```
cd build
cmake -DSECURITY_STRICT=Yes ..
```

