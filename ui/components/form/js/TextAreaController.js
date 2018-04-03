define([], function () {
    function TextAreaController() {}

    TextAreaController.prototype.init = function () {

    };

    TextAreaController.prototype.start = function () {
        this._root = this.context.getRoot();
        this._textAreaWrapper = this._root.find('.textarea-wrapper');
        this._validationType = this._textAreaWrapper.data('validationtype');
        this._textarea = this._root.find('textarea');
        this._label = this._root.find('.label');
        this._textarea.keypress(this._keyPress.bind(this));
    };

    TextAreaController.prototype._keyPress = function (event) {
        this.emit('keyPress', event);
    }

    TextAreaController.prototype.value = function (value) {
        if(typeof value == 'undefined') {
            return this._textarea.val();
        }

        this._textarea.val(value);
        return this;
    };

    TextAreaController.prototype.validationType = function (validationType) {
        if(typeof validationType == 'undefined') {
            return this._validationType;
        }

        this._validationType = validationType;
    };


    TextAreaController.prototype.destroy = function () {

    };

    return TextAreaController;
})