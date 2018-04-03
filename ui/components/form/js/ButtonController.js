define([], function () {
    function ButtonController() {}

    ButtonController.prototype.init = function () {

    };

    ButtonController.prototype.start = function () {
        this._enabled = true;
        this._root = this.context.getRoot();
        this._button = this._root.find('.button');
        this._label = this._root.find('.button-label');
        this._icon = this._root.find('.icon');
        this._button.on('click', this.click.bind(this));
    };

    ButtonController.prototype.label = function (label) {
        if(typeof label == 'undefined') {
            return this._label.text();
        }

        this._label.text(label);
        return this;
    };

    ButtonController.prototype.value = function (value) {
        if(typeof value == 'undefined') {
            if(("" + this._button.attr('value')).length > 0) {
                return this._button.attr('value');
            } else {
                return undefined;
            }
        }

        this._button.attr('value', value);
        return this;
    };

    ButtonController.prototype.resetValue = function () {
        this._button.removeAttr('value');
    }


    ButtonController.prototype.click = function (event) {
        if(this._enabled) {
            this.emit('click');
            this.context.messaging.messagePublish(this._button.attr('type'),
                this._button.attr('value'));
        }

        return;
    };

    ButtonController.prototype.destroy = function () {
        ButtonController = null;
    };

    ButtonController.prototype.enable = function () {
        this._enabled = true;
        this._button.removeClass('disabled');
    }

    ButtonController.prototype.disable = function () {
        this._enabled = false;
        this._button.addClass('disabled');
    }

    ButtonController.prototype.addClass = function (className) {
        this._button.addClass(className);
    }

    ButtonController.prototype.removeClass = function(className) {
        this._button.removeClass(className);
    }

    ButtonController.prototype.hasClass = function (className) {
        return this._button.hasClass(className);
    }

    return ButtonController;
})