/**
 * Created by atrifan on 10/28/2015.
 */
define(['modal'], function (Modal) {
    function FilesFolders() {
    }
    FilesFolders.prototype.init = function () {
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

    FilesFolders.prototype.start = function () {
        this._root = this.context.getRoot();
        var self = this;
        this._root.find('.folder').on('click', function(e) {
            self._folderClick(e, this)
        });
        this._root.find('.file').on('click', function(e) {
            self._fileClick(e, this)
        })
        // this._gameWrapper = this._root.find('.wordGameWrapper');
        // this._usersContainer = this._root.find('.users-container');
        // this._chooseUserName();

    }

    FilesFolders.prototype._folderClick = function(e, context) {
        e.stopPropagation();
        e.preventDefault();
        console.log($(context))
        console.log("good", $(context).data('path'));
    };

    FilesFolders.prototype._fileClick = function(e, context) {
        e.stopPropagation();
        e.preventDefault();
        this.emit('get_file', $(context).data('path'))
    };


    return FilesFolders;
});
