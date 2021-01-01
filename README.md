# libpasconfig
libPasConfig is delphi and object pascal wrapper around [libconfig library](https://github.com/hyperrealm/libconfig). libconfig is library for processing structured configuration files.


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

* [Embarcadero (R) Rad Studio](https://www.embarcadero.com)
* [Free Pascal Compiler](http://freepascal.org)
* [Lazarus IDE](http://www.lazarus.freepascal.org/) (optional)



Library is tested for 

- Embarcadero (R) Delphi 10.3 on Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)
- FreePascal Compiler (3.2.0) and Lazarus IDE (2.0.10) on Ubuntu Linux 5.8.0-33-generic x86_64



### Installation

Get the sources and add the *source* directory to the project search path. For FPC add the *source* directory to the *fpc.cfg* file.



### Usage

Clone the repository `git clone https://github.com/isemenkov/libpasconfig`.

Add the unit you want to use to the `uses` clause.



### Testing

A testing framework consists of the following ingredients:
1. Test runner project located in `unit-tests` directory.
2. Test cases (DUnit for Delphi and FPCUnit for FPC based) for all containers classes. 



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

    group := config_setting_add(root, PAnsiChar({$IFNDEF FPC}Utf8Encode{$ENDIF}
      ('config_group')), CONFIG_TYPE_GROUP);
    setting := config_setting_add(group, PAnsiChar({$IFNDEF FPC}Utf8Encode
      {$ENDIF}('option1')), CONFIG_TYPE_INT);
    config_setting_set_int(setting, 123);

    setting := config_setting_add(group, PAnsiChar({$IFNDEF FPC}Utf8Encode
      {$ENDIF}('option2')), CONFIG_TYPE_STRING);
    config_setting_set_string(setting, PAnsiChar({$IFNDEF FPC}Utf8Encode{$ENDIF}
      ('string value')));

    group := config_setting_add(root, PAnsiChar({$IFNDEF FPC}Utf8Encode{$ENDIF}
      ('config_array')), CONFIG_TYPE_GROUP);
    arr := config_setting_add(group, PAnsiChar({$IFNDEF FPC}Utf8Encode{$ENDIF}
      ('array')), CONFIG_TYPE_ARRAY);
    
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

