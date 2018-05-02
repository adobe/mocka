/**
 * Created by alexandru.trifan on 27.06.2015.
 */
define([], function () {
    function DropDownController() {
    }

    DropDownController.prototype.init = function () {

    }

    DropDownController.prototype.start = function () {
        this._root = this.context.getRoot();
        this._dropDown = this._root.find('.dropdown');
        var self = this;
        this._dropDown.on('change', function() {
            self.emit('change');
        })
        console.log("STARTED");
    }

    DropDownController.prototype.setValues = function (data) {
        console.log("ADDING DATA", this._root);
        for (var i = 0; i < data.length; i++) {
            var option = $('<option></option>');
            option.attr('value', data[i].value);
            option.text(data[i].text);
            this._dropDown.append(option);
        }
        this.emit('valuesSet');
    }

    DropDownController.prototype.loadRemote = function (configuration) {
        var self = this;
        $.ajax({
            url: configuration.url,
            type: 'GET',
            dataType: 'json',
            success: function (response) {
                var aggregationData = [];
                for (var i = 0; i < response.length; i++) {
                    if(!(configuration["textKey"] instanceof Array)) {
                        var data = {
                            value: response[i][configuration["valueKey"]],
                            text: response[i][configuration["textKey"]]
                        };
                    } else {
                        var text = '';
                        var keys = configuration["textKey"];
                        console.log("THE KEEEYS ", keys);
                        text += response[i][keys[0]];
                        for(var j = 1; j < keys.length; j++) {
                            text += " " + response[i][keys[j]];
                        }
                        var data = {
                            value: response[i][configuration["valueKey"]],
                            text: text
                        };
                    }
                    aggregationData.push(data);
                }
                self.setValues(aggregationData);
            },
            error: function (error) {
                //deferred.reject();
                self.setValues([]);
            }
        });

    }


    DropDownController.prototype.value = function (value) {
        if(typeof value == 'undefined') {
            return this._dropDown.val();
        }

        this._dropDown.val(value);
        return;
    }

    DropDownController.prototype.text = function () {
        return this._dropDown.find('option:selected').text();
    }

    return DropDownController
})