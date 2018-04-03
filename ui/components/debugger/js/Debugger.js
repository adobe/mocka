/**
 * Created by atrifan on 10/28/2015.
 */
define(['modal'], function (Modal) {
    function Debugger() {

    }

    Debugger.prototype.init = function () {
        // var self = this;
        // this._socket = this.context.getSocketToServer('wordGame');
        // this._socket.on('registerSelf', function(okState) {
        //     if(okState) {
        //         self._showGame();
        //     }
        // });
        // this._socket.on('registerUser', function(user) {
        //     self._appendUser(user);
        // });
    };

    Debugger.prototype.start = function () {
        // this._root = this.context.getRoot();
        // this._gameWrapper = this._root.find('.wordGameWrapper');
        // this._usersContainer = this._root.find('.users-container');
        // this._chooseUserName();
        this._root = this.context.getRoot();

        this.context.insert(this._root.find('.files_folders'), {
            component: {
                name: "debugger",
                view: "files_folders"
            },
            context : {
                fs: [
                    {
                        "type": "dir",
                        "isDir": true,
                        "path": "/etc",
                        "name": "etc",
                        "list": [
                            {
                                "type": "file",
                                "path": "/etc/test.lua",
                                "name": "test.lua"
                            },
                            {
                                "type": "dir",
                                "isDir": true,
                                "path": "/etc/api-gateway",
                                "name": "api-gateway",
                                "list": [
                                    {
                                        "type": "file",
                                        "path": "/etc/api-gateway/init.lua",
                                        "name": "init.lua"
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
        }).then(function(Controller) {
            console.log(Controller);
        });

    }

    return Debugger;
});
