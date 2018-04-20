/**
 * Created by atrifan on 10/28/2015.
 */
define(['modal'], function (Modal) {
    function Debugger() {

    }

    Debugger.prototype.init = function () {
        var self = this;
        this._socket = this.context.getSocketToServer("connect");
        this._socketSide = this.context.getSocketToServer("", "ws://mocka.tests.io:9333")


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
        var self = this;
        this._root = this.context.getRoot();

        this._socket.on('fs', this.insertFolders.bind(this));

        this._socket.on('file', function(data) {
            self._runningCode = data.path;
            self.injectCode(data.content);
        });

        this._socketSide.on('break_point_reached', function(message) {
            console.log(message);
        })

        setInterval(function() {
            self._socketSide.getClient().then(function(socket) {
              socket.emit('introspect')
            })
        }, 6000);


        this._socket.getClient().then(function(socket) {
            socket.emit('get_fs', {
                    path: '/usr/local/api-gateway/lualib'
                }
            )
        }, function(err) {

        })


        this._root.find('.left-container').resizable();
        this._root.find('.right-container .code pre').resizable();
        this._root.find('.button').on('click', function() {
            self._socketSide.getClient().then(function(socket) {
                socket.emit('continue')
            })
        })

    }

    Debugger.prototype.injectCode = function(code) {
        var self = this;
        var codeLocation = this._root.find('pre code');
        codeLocation.text(code);
        codeLocation.each(function(i, e) {
            hljs.highlightBlock(e);
            var current = $(this),
                lineStart = parseInt(current.data('line-start')),
                lineFocus = parseInt(current.data('line-focus')),
                items = current.html().split("\n"),
                total = items.length,
                result = '<ul ' + (!isNaN(lineStart) ? 'start="' + lineStart + '"' : '') + '>';
            for (var i = 0; i < total; i++) {
                if (i === (lineFocus - lineStart)) {
                    result += '<li data-nr="' + (i+1) +'">';
                } else {
                    result += '<li data-nr="' + (i+1) + '">';
                }
                result += items[i] + '</li>';
            }
            result += '</ul>';
            var items = current.empty().append(result);

            self._root.find('code li').on('click', function(ev) {
                var lineNumber = $(this).data('nr');
                self._socket.getClient().then(function(socket) {
                    socket.emit('break_point', {
                        enable: true,
                        file: self._runningCode,
                        line: lineNumber
                    })
                });
            })
        });


    }

    Debugger.prototype.insertFolders = function(fs) {
        var self = this;
        var context = {
            fs: [
                {
                    "type": "dir",
                    "isDir": true,
                    "path": "/usr/local/api-gateway/lualib",
                    "name": "/usr/local/api-gateway/lualib",
                    list: fs
                }
            ]
        };
        console.log("ssss ", fs);
        this.context.insert(this._root.find('.files_folders'), {
            component: {
                name: "debugger",
                view: "files_folders"
            },
            context : context
        }).then(function(Controller) {
            Controller.on('get_file', function(path) {
                self._socket.getClient().then(function(socket) {
                    socket.emit('get_file', {
                        path: path
                    })
                }, function(err) {

                })
            });
        });
    }

    return Debugger;
});
