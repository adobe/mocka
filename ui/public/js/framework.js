define(['context',
        'componentMap',
        'eventEmitter',
        'promise'], function (Context, ComponentMap, EventEmitter, Promise) {

    /**
     * The Framework module that makes all the computations and registers components to the client component
     * map.
     *
     * @name Framework
     * @constructor
     */
    function Framework() {
        /**
         * Private property of Framework defining a serie of events, to be later
         * inherited by the controller of the component.
         *
         * @type {{_init: Function, emit: Function, once: Function, on: Function, off: Function}}
         * @private
         */
    }

    /**
     * The instance of the Framework module.
     *
     * @type {Framework}
     * @private
     */
    Framework._instance = null;

    /**
     * Singleton get method of the Framework module.
     *
     * @returns {Framework}
     * @static
     */
    Framework.get = function () {
        return Framework._instance ||
            (Framework._instance = new Framework());
    }

    /**
     * Process the components configuration, requires the controller of the component and it
     * extends it with the context module and the framework ``_events`` so they can be easily used
     * as default from the controller of the component and registers the component to the clientMap.
     *
     * Rejects the promise if the controller for the client was not found or if the somehow the uniqueId was
     * already generated(javascript's random is kind of dummy).
     *
     * @param {Object} config the components configuration
     * @returns {Promise} the required component's controller.
     * @public
     */
    Framework.prototype.processComponent = function (config) {

        var id = config.containerId,
            self = this,
            controllerToResolve;

        var deferred = Promise.defer();
        this._fetchTemplates(config).then(function() {
            if (ComponentMap.get().getComponent(id)) {
                //TODO: do something here cause it is wrong
                //return;
                var componentMap = ComponentMap.get().getComponentMap();
                componentMap[id].sid = config.sid;
            } else {
                var deferredController = Promise.defer();
                ComponentMap.get().registerComponent(id, {
                    sid: config.sid,
                    controller: deferredController
                });
            }

            var ids = ComponentMap.get()._getDeps(id);
            for (var i = 0; i < ids.length; i++) {
                var futureController = Promise.defer();
                ComponentMap.get().registerComponent(ids[i], {
                    controller: futureController
                });
            }

            controllerToResolve = ComponentMap.get().getComponent(id).controller;

            if (!config.clientController) {
                deferred.resolve({
                    promisedController: controllerToResolve
                });
            } else {
                require([config.path + '/js/' + config.clientController], function (controller, err) {
                    jQuery.extend(controller.prototype, EventEmitter.prototype);
                    var cnt = new controller(),
                        context = new Context(config);

                    cnt.context = context;
                    deferred.resolve({
                        js: cnt,
                        promisedController: controllerToResolve
                    });
                }, function (err) {
                    throw Error(err);
                    deferred.resolve();
                });
            }
        }, function(err) {
            throw Error(err);
        });

        return deferred.promise;
    }

    Framework.prototype._fetchTemplates = function(config) {
        var templates = config.templates || [],
            resolvedTemplates = [];


        var deferred = Promise.defer();
        for(var i = 0; i < templates.length; i++) {
            resolvedTemplates.push(this._fetchTemplate(config.path, templates[i]));
        }

        Promise.all(resolvedTemplates).then(function(data) {
            config["templateInfo"] = {};
            for(var i = 0; i < data.length; i++) {
                config["templateInfo"][data[i].id] = data[i].templateData;
            }
            deferred.resolve();
        }, function (err) {
            throw Error(err);
        });

        return deferred.promise;
    }

    Framework.prototype._fetchTemplate = function (path, templateInfo) {
        var deferred = Promise.defer();
        $.get(path + '/_templates/' + templateInfo).done(function (html) {
            var compiledTemplate = Handlebars.compile(html)();
            deferred.resolve(compiledTemplate);
        }).fail(function() {
            deferred.resolve()
        });

        return deferred.promise;
    };

    return Framework;
});
