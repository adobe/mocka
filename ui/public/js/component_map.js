define([], function () {
    /**
     * The client's component map.
     *
     * @name ComponentMap
     * @constructor
     */
    function ComponentMap () {
        /**
         * The componentMap property.
         *
         * @type {Object}
         * @private
         */
        this._componentMap = {};
    };

    /**
     * The instance of the ComponentMap module.
     *
     * @type {ComponentMap}
     * @private
     */
    ComponentMap._instance = null;

    /**
     * Singleton get method for the ComponentMap instance.
     *
     * @returns {ComponentMap}
     * @static
     */
    ComponentMap.get = function () {
        return ComponentMap._instance ||
            (ComponentMap._instance = new ComponentMap());
    }

    /**
     * Gets a component with a specific id.
     *
     * @param {String} id the id of the component
     * @returns {Object} the found component in the componentMap.
     * @public
     */
    ComponentMap.prototype.getComponent = function (id) {
        return this._componentMap[id];
    };

    /**
     * Gets the component map.
     *
     * @returns {Object} the client's component map.
     * @public
     */
    ComponentMap.prototype.getComponentMap = function () {
        return this._componentMap;
    };

    /**
     * Registers a component to the client's component map.
     *
     * @param {String} id the unique id of the component's entrance
     * @param {Object} configuration the configuration that you want to register for a component
     * @public
     */
    ComponentMap.prototype.registerComponent = function (id, configuration) {
        this._componentMap[id] = configuration;
        this._componentMap[id]['_deps'] = [];
    };


    /**
     * Removes a component with a specific id from the componentMap.
     *
     * @param {String} id the id for the component that has to be removed
     */
    ComponentMap.prototype.removeComponent = function (id) {
        var dependencies = this._getDeps(id),
            self = this;

        for (var i = 0, len = dependencies.length; i < len; i++) {
            this.removeComponent(dependencies[i]);
            delete self._componentMap[dependencies[i]];
        }

        delete this._componentMap[id];
    };

    ComponentMap.prototype._getDeps = function (id) {
       /* var children  = $('#' + id).find('.app-clifJs'),
            childrenIds = [];

        for(var i = 0, len = children.length; i < len; i++) {
            childrenIds.push($(children[i]).attr('id'));
        }

        return childrenIds;*/
        return this._componentMap[id]['_deps'];
    }

    ComponentMap.prototype.addDependency = function (id, childId) {
        if(id == -1) {
            return;
        }
        this._componentMap[id]['_deps'].push(childId);
    };

    /**
     * Empties the client componentMap.
     *
     * @public
     */
    ComponentMap.prototype.flushComponents = function () {
        delete this._componentMap;

        this._componentMap = {};
    }


    return ComponentMap;
});
