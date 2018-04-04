define(['eventEmitter'], function (EventEmitter) {
    /**
     * Message Queue module.
     *
     * @name Messaging
     * @constructor
     */
    function Messaging() {
        /**
         * Emulated jQuery object from the current module in order to use the trigger/on/unbind methods.
         *
         * @type {jQuery}
         * @private
         */

        //this._jqEmulated = jQuery();
    }

    jQuery.extend(Messaging.prototype, EventEmitter.eventEmitter);
    /**
     * Instance of the Messaging module.
     *
     * @type {Messaging}
     * @private
     */
    Messaging._instance = null;

    /**
     * Singleton get method for Messaging module.
     *
     * @returns {Messaging} the Messaging module instance
     * @static
     */
    Messaging.get = function () {
        return Messaging._instance ||
            (Messaging._instance = new Messaging());
    }

    /**
     * Publish message in Message Queue method.
     *
     * @param {String} title the title of the message published.
     * @param {Object} info the actual message published on the queue with the specific title.
     * @public
     */
    Messaging.prototype.messagePublish = function (title, info) {
        this.emit(title, info);
    };

    /**
     * Subscribe to a message in the queue method.
     *
     * @param {String} title the title of the message that you want to subscribe to.
     * @param {Function} handler the handling method for the message you subscribed to.
     * @public
     */
    Messaging.prototype.messageSubscribe = function (title, handler) {
        //this._jqEmulated.on(title, handler);
        this.on(title, handler);
    };

    /**
     * Unsubscribe from a message in the message queue.
     *
     * @param {String} title the title of the message that you want to unsubscribe.
     * @param {Function} handler the handling method used to handle the message.
     * @public
     */
    Messaging.prototype.messageUnSubscribe = function (title, handler) {
        //this._jqEmulated.unbind(title, handler);
        this.off(title, handler);
    };

    return Messaging;
})