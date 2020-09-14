# libpasconfig
libPasConfig is object pascal wrapper around [libconfig library](https://github.com/hyperrealm/libconfig). libconfig is library for processing structured configuration files.


### Table of contents

  * [Requirements](#requirements)
  * [Installation](#installation)
  * [Usage](#usage)
  * [Testing](#testing)
  * [Bindings](#bindings)
    * [Usage example](#usage-example)
  * [Object wrapper](#object-wrapper)
    * [Usage example](#usage-example-1)



### Requirements

* [Free Pascal Compiler](http://freepascal.org)
* [Lazarus IDE](http://www.lazarus.freepascal.org/) (optional)

Library is tested with latest stable FreePascal Compiler (currently 3.2.0) and Lazarus IDE (currently 2.0.10).



### Installation

Get the sources and add the *source* directory to the *fpc.cfg* file.



### Usage

Clone the repository `git clone https://github.com/isemenkov/libpasconfig`.

Add the unit you want to use to the `uses` clause.



### Testing

A testing framework consists of the following ingredients:
1. Test runner project located in `unit-tests` directory.
2. Test cases (FPCUnit based) for config class.



### Bindings

[libpasconfig.pas](https://github.com/isemenkov/libpasconfig/blob/master/source/libpasconfig.pas) file contains the libconfig translated headers to use this library in pascal programs.

#### Usage example

```pascal
  uses
    libpasconfig;

  var
   config : config_t; 
   root, setting, arr, group : pconfig_setting_t;
 
  begin
    config_init(@config);
    root := config_root_setting(@config);

    group := config_setting_add(root, 'config_group', CONFIG_TYPE_GROUP);
    setting := config_setting_add(group, 'option1', CONFIG_TYPE_INT);
    config_setting_set_int(setting, 123);

    setting := config_setting_add(group, 'option2', CONFIG_TYPE_STRING);
    config_setting_set_string(setting, PChar('string value'));

    group := config_setting_add(root, 'config_array', CONFIG_TYPE_GROUP);
    arr := config_setting_add(group, 'array', CONFIG_TYPE_ARRAY);
    
    setting := config_setting_add(arr, nil, CONFIG_TYPE_INT64);
    config_setting_set_int64(setting, 1000000000);
    
    setting := config_setting_add(arr, nil, CONFIG_TYPE_INT64);
    config_setting_set_int64(setting, 1000000001);

    config_destroy(@config);
  end;
```

### Object wrapper

[pasconfig.pas](https://github.com/isemenkov/libpasconfig/blob/master/source/pasconfig.pas) file contains the libconfig object wrapper.

#### Usage example

```pascal
  uses
    pasconfig;

  var
    config : TConfig;
  

  begin
    config := TConfig.Create;
    
    with config.CreateSection['config_group'] do
    begin
      SetInteger['option1'] := 123;
      SetString['option2'] := 'string value';
    end;

    with config.CreateArray['config_array'] do
    begin
      SetInt64 := 1000000000;
      SetInt64 := 1000000001;
    end;

    FreeAndNil(config);
  end;
```

