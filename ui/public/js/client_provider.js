define(['framework', 'promise'], function (Framework, Promise) {

    /**
     * The ClientProvider module, renders the component's css, asks the framework to process the components
     * configuration, invokes the lifeCycle of the component and inserts the component's HTML in place.
     *
     * @name ClientProvider
     * @constructor
     */
    function ClientProvider() {

    }

    ClientProvider._instance = null;

    ClientProvider.get = function () {
        return ClientProvider._instance ||
            (ClientProvider._instance = new ClientProvider());
    };

    /**
     * Renders the components css and asks the framework to process the components configuration.
     * If any error occurs it renders an error message inside the page.
     *
     * @param {Object} configuration the component's configuration
     * @public
     */
    ClientProvider.prototype.render = function (configuration) {
        this._renderCss(configuration, configuration.css, configuration.path);

        var invokeLifeCycle = function (controller) {
            return Promise.seq([controller.init.bind(controller),
                controller.start.bind(controller)
            ]);
        }

        var self = this;
        var loadingIndicator = $('<div class="loading overlay nobg"><div class="loader center"></div></div>');
        loadingIndicator.css('visibility', 'visible');
        $('#' + configuration.containerId).html(configuration.content);
        $('#' + configuration.containerId).append(loadingIndicator);
        $('#' + configuration.containerId).css('visibility', 'hidden');

        Framework.get().processComponent(configuration).then(function (data) {
            if (data.js) {
                configuration.cssLoaded.then(function () {
                    invokeLifeCycle(data.js).then(function () {
                        $('#' + configuration.containerId).css('visibility', 'inherit');
                        data.promisedController.resolve(data.js);
                        loadingIndicator.fadeOut();
                        loadingIndicator.remove();
                    });
                }, function (err) {
                    throw Error(err);
                    //TODO: do something here
                });
            } else {
                configuration.cssLoaded.then(function () {
                    $('#' + configuration.containerId).css('visibility', 'inherit');
                    data.promisedController.resolve();
                    loadingIndicator.fadeOut();
                    loadingIndicator.remove();
                }, function (err) {
                    throw Error(err);
                    //TODO: do something here
                });
            }
        }, function (err) {
            throw Error(err);
            //TODO: show an error
            //show an error box;
        });
    }

    /**
     * Renders the component's css in page.
     *
     * @param {Object} configuration the components configuration
     * @param {[String]} css an array of css paths for the current component
     * @param {String} location the component's location on the server
     * @private
     */
    ClientProvider.prototype._renderCss = function (configuration, css, location) {

        var deferrers = [];

        if (!css) {
            configuration.cssLoaded = Promise.all(deferrers);
            return Promise.all(deferrers);
        }

        var head = $("head"),
            linkElement;

        for (var i = 0, len = css.length; i < len; i++) {
            var cssPath = location + '/css/' + css[i],
                sameLinks = head.find('link[href="' + cssPath + '"]');


            if (sameLinks.length === 0) {
                var deferrer = Promise.defer();

                //deferrers.push(deferrer);
                linkElement = document.createElement('link');
                linkElement.rel = "stylesheet";
                linkElement.type = "text/css";
                linkElement.href = cssPath;
                linkElement.onload = function () {
                    deferrer.resolve();
                };
                head.append(linkElement);
            }
        }

        configuration.cssLoaded = Promise.all(deferrers);
        return Promise.all(deferrers);
    }

    return ClientProvider.get();
});
