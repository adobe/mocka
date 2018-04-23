/**
 * Created  on 26.06.2015.
 */
define([], function () {
    function Grid() {

    }

    Grid.prototype.init = function() {

    }

    Grid.prototype.start = function() {

    }

    Grid.prototype.configure = function(configuration) {
        this._remoteAddress = configuration.remoteAddress;
        this._gridContainer = configuration.gridContainer;
        this._columns = configuration.columns;
        this._iconLocation = configuration.iconLocation || '/core/resources/grid/icon.png';
        this._tickLocation = configuration.tickLocation || '/core/resources/grid/tick.png';
        this._editIconLocation = typeof configuration.editIconLocation == 'undefined' ? '/core/resources/grid/edit.png' : configuration.editIconLocation;
        this._deleteIconLocation = typeof configuration.deleteIconLocation == 'undefined' ? '/core/resources/grid/delete.png' : configuration.deleteIconLocation;
        this._xLocation = configuration.xLocation || '/core/resources/grid/x.png';
        this._loadingIndicator = configuration.loadingIndicator || {
            show: function() {},
            fadeOut: function() {}
        };
        this._options = configuration.options || {
            editable: false,
            enableAddRow: false,
            enableCellNavigation: true,
            forceFitColumns: true,
            enableColumnReorder: false,
            multiColumnSort: true,
            asyncEditorLoading: true
        }
    }
    Grid.prototype.tickFormatter = function (row, cell, value, columnDef, dataContext) {
        if(value) {
            return '<img src="' + this._tickLocation +'" width="15px" height="15px"/>';
        }
        return '<img src="' + this._xLocation +'" width="15px" height="15px"/>';

    };

    Grid.prototype.formatDate = function(date) {
        var theDate = new Date(date);
        var month = theDate.getMonth() + 1;
        var day = theDate.getDate();
        if(month < 10) {
            month = "0" + month;
        }

        if(day < 10) {
            day = "0" + day;
        }
        return day + '/' + month + '/' + theDate.getFullYear();
    }

    Grid.prototype.iconFormatter = function(row, cell, value, columnDef, dataContext) {
        return '<img src="' + this._iconLocation + '" width="15px" height="15px"/>'
    };

    Grid.prototype.commands = function (row, cell, value, columnDef, dataContext) {
        if(this._deleteIconLocation && this._editIconLocation) {
            return '<img src="' + this._deleteIconLocation + '" class="command" data-type="delete" data-id="'+row+'" width="15px" height="15px"/>' +
                '<img src="' + this._editIconLocation + '" class="command" data-type="edit" data-id="'+row+'" width="15px" height="15px"/>';
        } else if(!this._deleteIconLocation) {
            return '<img src="' + this._editIconLocation + '" class="command" data-type="edit" data-id="'+row+'" width="15px" height="15px"/>';
        } else {
            return '<img src="' + this._deleteIconLocation + '" class="command" data-type="delete" data-id="'+row+'" width="15px" height="15px"/>';
        }

    }

    Grid.prototype.render = function () {
        this._initCommands();
        var data = [];
        this._grid = new Slick.Grid('#' + this._gridContainer.attr('id'), data, this._columns, this._options);
        var self = this;
        $(window).resize(function () {
            self._grid.resizeCanvas();
        });
        this._gridContainer.append(this._loadingIndicator);
        this._loadingIndicator.show();

        this._initData();

    };

    Grid.prototype._initCommands = function () {
        $('.command', this._gridContainer)
            .live('click', this._triggerCommand.bind(this));
    }

    Grid.prototype.dateFormatter = function (row, cell, value, columnDef, dataContext) {
        return this.formatDate(value);
    }

    Grid.prototype._triggerCommand = function (event) {
        var buttonPressed = $(event.target),
            type = buttonPressed.data('type'),
            id = buttonPressed.data('id');

        this.emit(type, {
            id: id,
            selectedRow: this._grid.getData(id)
        });
    }

    Grid.prototype._initData = function() {
        var self = this;
        var isAsc = true;
        var data = {};
        $.ajax({
            url: this._remoteAddress,
            type: 'GET',
            dataType: 'json',
            success: function (response) {
                console.log(response);
                response.name="GIGI";
                self._grid.setData(response, true);
                self._grid.invalidateAllRows();
                self._loadingIndicator.fadeOut();
                self._grid.render();
                self._makeGridSortable(response);
                self.emit('loaded', true);
            },
            error: function (error) {
                data = [];
                self._grid.setData(data, true);
                self._grid.invalidateAllRows();
                self._loadingIndicator.fadeOut();
                self._grid.render();
                self.emit('loaded', false);
            }
        });

    };

    Grid.prototype.refresh = function() {
        this._loadingIndicator.show();
        this._initData();
    };

    Grid.prototype._makeGridSortable = function (data) {
        var self = this;
        var isAsc = true;
        this._grid.onSort.subscribe(function (e, args) {
            var cols = args.sortCols;
            console.log(args);
            isAsc = !isAsc;
            data.sort(function (dataRow1, dataRow2) {
                if(isAsc)
                    return dataRow1 >= dataRow2;
                else
                    return dataRow1 <= dataRow2;
            });
            self._grid.invalidate();
            self._grid.render();
        });
    }

    return Grid;
});