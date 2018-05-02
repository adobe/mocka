define(['componentMap',
        'promise',
        'componentRequester',
        'sockets',
        'eventEmitter'
        ], function (ComponentMap, Promise, ComponentRequester, Socket, EventEmitter) {

    /**
     * The component's controller execution context this module is being injected in the controller
     * of the component so that it methods can easily be used from the component's controller.
     *
     * @param {Object} config the component's configuration.
     * @name Context
     * @constructor
     */
    function Context(config) {
        /**
         * The component's containerId
         *
         * @type {String}
         * @private
         */
        this._parentId = config.containerId;

        /**
         * The messaging queue module so the components can easily use it for communication.
         *
         * @type {Messaging}
         * @public
         */
        this.messaging = eventingQueue;

        this._templates = config.templateInfo;

        /**
         * The Storage module
         * @type {Firebase}
         * @public
         */
        this.storrage = new Firebase("https://sweltering-fire-6062.firebaseio.com");

        /**
         * The loading indicator
         * @public
         */

        this.loadingIndicator = $('<div class="loading overlay"><div class="loader center"></div></div>');
        this.loadingIndicator.css('display', 'none');
        $('#' + this._parentId).append(this.loadingIndicator);


    }

    /**
     * Retrieves the container of the component.
     *
     * @returns {jQuery|HTMLElement}
     * @public
     */
    Context.prototype.getRoot = function () {
        return $('#' + this._parentId);
    };

    /**
     * Connects to server via webSockets on a channel inputed by the developer
     * @param channel
     * @returns {*}
     */
    Context.prototype.getSocketToServer = function (channel, baseUrl) {
        return Socket.get().registerSocket(channel, baseUrl)
    };

    /**
     * Get a component's controller depending on there ``sid`` (Singular ID).
     *
     * @param {String} sid the Singular ID passed in the sid parameter in the component's helper.
     * @returns {Promise} the controller for that component.
     * @public
     */
    Context.prototype.getComponent = function (sid) {
        var componentMap = ComponentMap.get().getComponentMap();
        for (var component in componentMap) {
            if (componentMap[component].sid === sid) {
                return componentMap[component].controller.promise;
            }
        }
    }

    Context.prototype.getChildren = function() {
        var self = this;
        var componentMap = ComponentMap.get().getComponentMap();
        var children = ComponentMap.get()._getDeps(this._parentId);
        var theChildren = {};
        for(var i = 0; i < children.length; i++) {
            if(componentMap[children[i]]) {
                theChildren[children[i]] = componentMap[children[i]].controller.promise;
            }
        }

        var deferred = Promise.defer();
        Promise.allKeys(theChildren).then(function(data) {
            var ids = Object.keys(data);
            var resolvedChildren = {};
            for(var i = 0; i < ids.length; i++) {
                resolvedChildren[ComponentMap.get().getComponent(ids[i]).sid] = data[ids[i]];
            }
            deferred.resolve(resolvedChildren);
        }, function (err) {
            throw Error(err);
        });
        return deferred.promise;
    };


    Context.prototype.delete = function (sid) {
        var componentMap = ComponentMap.get().getComponentMap();
        for (var component in componentMap) {
            if (componentMap[component].sid === sid || component === sid) {
                sid = componentMap[component].sid;
                this.getComponent(sid).then(function (Controller) {
                    Controller.destroy();
                });
                //ComponentMap.get().removeComponent(component);
                //must remove CSS
                ComponentMap.get().removeComponent(component);
                var domElement = $('#' + component);
                var results = ComponentMap.get()._getDeps(component);
                for (var i = 0, len = results.length; i < len; i++) {
                    this.delete(results[i]);
                }
                domElement.remove();

            }
        }


    }

    Context.prototype.replace = function (sid, componentConfig) {
        //implement replace functionality
        var componentMap = ComponentMap.get().getComponentMap(),
            domElement;
        for (var component in componentMap) {
            if (componentMap[component].sid === sid) {
                domElement = $('#' + component).parent();
            }
        }

        this.delete(sid);
        //register an put stuff her
        var content = ComponentRequester.render(componentConfig.component, componentConfig.context);
        var componentMap = ComponentMap.get();
        var domObject = $(content.string);
        domElement.html(content.string);
        return this.getComponent(componentMap.getComponent(domObject.attr('id'))['sid']);
    }


    Context.prototype.insert = function(element, componentConfig) {

        componentConfig.component['parentId'] = this._parentId;
        var content = ComponentRequester.render(componentConfig.component, componentConfig.context),
            componentMap = ComponentMap.get();
        var domObject = $(content.string);
        element.html(content.string);
        return this.getComponent(componentMap.getComponent(domObject.attr('id'))['sid']);

    };

    Context.prototype.appendTemplate = function(templateId, templateContext, location) {
        var domElement = $.parseHTML(unescapeHTML(this._templates[templateId](templateContext).trim()));
        location.append(domElement);
        return domElement;
    };

    Context.prototype.insertTemplate = function(templateId, templateContext, location) {
        var domElement = $.parseHTML(unescapeHTML(this._templates[templateId](templateContext).trim()));
        location.html('');
        location.append(domElement);
        return domElement;
    };

    function unescapeHTML(p_string)
    {
        if ((typeof p_string === "string") && (new RegExp(/&amp;|&lt;|&gt;|&quot;|&#39;/).test(p_string)))
        {
            return p_string.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&quot;/g, "\"").replace(/&#39;/g, "'");
        }

        return p_string;
    }
    return Context;
});
