
Use the following definitions to customize the building process:   
- **SECURITY_STRICT**: Specify the secuirty strict build options: ```Yes``` or ```No```. Default is ```No```. Currently secuirity strict build disable LAME from the images.   

### Examples:   
**Disable security strict build**
```
cd build
cmake ..
```
or

```
cd build
cmake -DSECURITY_STRICT=No ..
```

**Enable security strict build**
```
cd build
cmake -DSECURITY_STRICT=Yes ..
```

