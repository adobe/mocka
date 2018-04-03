define([], function () {
    function InputController() {}

    InputController.prototype.init = function () {

    };

    InputController.prototype.start = function () {
        this._root = this.context.getRoot();
        this._inputWrapper = this._root.find('.input-wrapper');
        this._validationType = this._inputWrapper.data('validationtype');
        this._input = this._root.find('input');
        this._label = this._root.find('.label');
        this._input.on('click', this._click.bind(this));
        this._input.on('focus', this._click.bind(this));
        this._input.keypress(this._keyPress.bind(this));
        this._firstTime = true;
    };

    InputController.prototype._keyPress = function (event) {
        this.emit('keyPress', event);
    }

    InputController.prototype.validationType = function (validationType) {
        if(typeof validationType == 'undefined') {
            return this._validationType;
        }

        this._validationType = validationType;
    };

    InputController.prototype._click = function (event) {
        console.log("CLICK");
        if(this._firstTime) {
            this._input.val("");
            this._firstTime = false;
            console.log("OK");
        }
    }

    InputController.prototype.disable = function () {
        this._input.attr('disabled', 'disabled');
    }

    InputController.prototype.enable = function () {
        this._input.removeAttr('disabled');
    }



    InputController.prototype.value = function (value) {
        if(typeof value == 'undefined') {
            if(this._firstTime) {
                return;
            }

            if(this._input.val().length == 0) {
                return;
            }

            return this._input.val();
        }

        this._firstTime = false;
        if(("" + value).length == 0) {
            this._firstTime = true;
        }
        return this;
    };


    InputController.prototype.destroy = function () {

    };

    return InputController;
})