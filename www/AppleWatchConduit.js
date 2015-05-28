
/*
 * Copyright (c) Olivier Goguel.  All rights reserved.
 * Licensed under the Apache License, Version 2.0. See License.txt in the project root for license information.
 */

 module.exports = {
  
    pluginName : "AppleWatchConduit",
    pluginVersion : "1.0.0",
    commandHandler : undefined,

    onReceiveCommand : function(_handler) {
     
      this.commandHandler = _handler;
      var _this = this;
        cordova.exec(function( _commands) {
      
        if (_commands)
          for(var c in _commands)
            _this.onCommand(_commands[c]);
        }, undefined, _this.pluginName, 'checkCommand', [] );
    },

    onCommand: function(_command) {
      if (this.commandHandler)
        this.commandHandler(_command);
    },

    sendMessage : function(_data,_success,_error) {
        var data = JSON.stringify(_data);
        cordova.exec(_success, _error, this.pluginName,"sendMessage", [ _data ]);
    },

    init : function (_groupId,_success,_error) {
      cordova.exec(_success, _error, this.pluginName,"init", [ _groupId || "" ]);
    }

};

