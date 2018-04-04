/**
 * Created by atrifan on 10/28/2015.
 */
define(['promise'], function (Promise) {
    function SocketRegistry() {

        var protocol = 'ws://',
            hostname = window.location.host;

        this._shouldReconnect = false;

        this._baseUrl = protocol + hostname;
    };

    SocketRegistry._instance = null;
    SocketRegistry.get = function () {
        return SocketRegistry._instance ||
            (SocketRegistry._instance = new SocketRegistry());
    };

    SocketRegistry.prototype.registerSocket = function (channel) {
        var self = this;
        if(channel.charAt(0) != "/") {
            channel = "/" + channel;
        }


        var socket = new WebSocket(this._baseUrl + channel);

        socket.emit = function(event, data) {
            var data = {
                event: event,
                data: data
            };
            socket.send(JSON.stringify(data));
        };

        socket._isDisconnected = true;
        socket._listeners = {};

        socket.on = function(event, fn) {
            socket._listeners[event] = fn;
        }

        var deferred = Promise.defer();
        socket.onopen = function(ev) {
            deferred.resolve(socket);
            socket.onmessage = function(message) {
                try {
                    message = JSON.parse(message.data);
                    if (socket._listeners[message.event]) {
                        socket._listeners[message.event](message.data);
                    }
                } catch (ex) {
                    if (socket._listeners[message.event]) {
                        socket._listeners[message.event](message.data);
                    }
                }
            }
        }

        socket.getClient = function() {
            return deferred.promise;
        }

        return socket;

    };

    return SocketRegistry;

});
