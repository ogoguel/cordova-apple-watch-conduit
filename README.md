## Apple Watch Conduit for Cordova

# Introduction
The goal of this plugin is to provide Cordova apps with an easy way to communicate between the Cordova Application and its Apple Watch Extension.

The conduit takes care of setting a reliable tunnel between your application and your extension (whether your application has been launched or not)

# Setup
Unfortunately, setting up an Apple Watch project requires quite a few steps 

### Step 0 :  Update your Cordova-Lib module

Unfortunately, plugins cannot be added to Cordova project with multiple targets yet.
A pull request has been prepared (https://github.com/apache/cordova-lib/pull/219), but while it is being approved, you need to manually upgrade your cordova installation :

Clone the cordova-lib with the fix
```sh
cd ~
git clone http://github.com/ogoguel/cordova-lib
```

Edit `/usr/local/lib/node_modules/cordova/package.json` to use that patched version by replacing
```json
"dependencies": {
    "cordova-lib": "5.0.0",
    ...
 ```
with
```json
"dependencies": {
    "cordova-lib": "file:~/cordova-lib/cordova-lib",
    ...
 ```
 Update your npm installation
 ```sh
 cd /usr/local/lib/node_modules/cordova
 sudo npm install
 ```

> Warning requires NPM > 2.0 to work

### Step 1 : Add the Cordova Watch Conduit to your application
```sh
cordova plugin add http://http://github.com/ogoguel/cordova-apple-watch-conduit.git
```
### Step 2 : Enable the WatchKit Extension
To support the Apple Watch, you need to add some additional targets to your XCode Project

> From XCode, File>New>Target>Apple Watch>Apple Watch Extension

This will create 2 new targets : *WatchKit App* and *WatchKit Extension*.

As there's an issue with XCode 6.3.1,

> You might need to change the iOS Deployement Target to 8.2 for the WatchKit Extension and the WatchKit App as it would fail otherwise

### Step 3 : Add files to the WatchKit Extension target
As the Cordova Plugin Manager cannot add files to the WatchKit Extension, you need to manually modify your project.

> For each file, select them and add your Watch Kit Extension as a target (in the Target Membership panel)
````
Plugins/MMWormhole.m
Plugins/AppleWatchConduitLibrary.m
```

### Step 4 : Add preprocessing Macros

You need to add to PREPROCESSOR to differentiate the Application from the Extnesion : thanks Apple for not providing such a basic features!

Use `APPLEWATCHCONDUIT_APPLICATION` for the Application, and `
APPLEWATCHCONDUIT_WATCHKITEXTENSION`for your extension
> A compile error will be thrown if none of those macros has been defined

### Step 5 : Declare a common App Group Id
To communicate, the Application and the WatchKit Extension must share the same group Id.

>In capabilities for each, turn on AppGroup and add group.<your bundle id>  for both the Application and the Extension
(You should have the same string for both apps)

Even if you can use any Id, it is recommened to use `group.<your application bundle id>` as this shared id as it will be automatically recognized by the plugin.

# How to integrate

### In your extension

In the `awakeWithContext` method, init the library and set up a listener to catch javascript message

```
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
  
   // 1 Init 
    awLibrary = [[AppleWatchConduitLibrary alloc]
                 initWithGroupId:nil ]; // using @"group.<your bundle id>"
            
   // 2 Receiver     
    [awLibrary onReceiveMessage:^(NSString* _message) {
        NSLog(@"Received message %@",_message);
        }
    ];
}
````

Once initialized, you can send message to the Javascript at any time. For example, to execute a command each time the application is activated
```
- (void)willActivate {
    // 3 send message each time the app is activated to retrieve info from your app
    [awLibrary sendCommand:@"willActivate"];
    // the answer will be received in the listener
    [super willActivate];
}
```

### In JS

The integration is pretty similar : once you've received the ready event, you can do the same : initialize the app, set a listener, and send message 

```js
  applewatchconduit.init(
      undefined, // by default "group.<your bundle id>",
      function success(_groupId){
    
        applewatchconduit.setCommandHandler(function(_command) {
              console.log("received :"+_command);
              applewatchconduit.sendMessage("pong "+_command);
            });

        applewatchconduit.sendMessage("ready");
        
      });
```
### Credit
* Coded by Olivier Goguel o@oguel.com
* Inspired by the Cordova Apple Watch Plugin (https://github.com/leecrossley/cordova-plugin-apple-watch)
* Using a fork of the MMWormHole Library by MutualMobile (https://github.com/ogoguel/MMWormhole)

### History
1.0.0 Initial Release







