/**
 * RegisterComponent method. Registers the component helper in the Handlebars module.
 */
define(['componentRequester'], function(ComponentRequester) {

    function _registerEventHandler(event, options) {
        eventingQueue.messageSubscribe(event, function (data) {
            var info = options.fn(data.context || {});
            var idInject;
            var element;
            if(data.injectLocation) {
                idInject = data.injectLocation;
                element = $('#' + idInject);
                element.html(info);
            } else {
                element = $('#' + id);
                element.html(info);
            }

            if(data.callback) {
                data.callback();
            }
        });
    };

    var registerComponent = function() {
        Handlebars.registerHelper('component', function (options) {

            var componentData = {
                    name: options.hash.name,
                    view: options.hash.view || "index",
                    sid: options.hash.sid,
                    parentId: options.hash.parentId
                },
                context = options.hash;


            return ComponentRequester.render(componentData, context);
        });

        Handlebars.registerHelper('onEvent', function (options) {
            var eventName = options.hash.name,
                injectLocation = options.hash.injectLocation;
            var id = Math.floor(Date.now() / (Math.random() * 1001) * Math.floor(Math.random() * 1001));

            _registerEventHandler(eventName, options);

            if(!injectLocation) {
                return new Handlebars.SafeString('<div class="app-clifJs-event"' + 'id="' + id + '"></div>');
            }
        });

        Handlebars.registerHelper('template', function (options) {
            var id = options.hash.id;
            templateEngine[id] = options.fn;
            return {
                id: id,
                templateData: options.fn
            };
        });

        Handlebars.registerHelper('template_insert', function(options) {
            var id = options.hash.id,
                data = options.hash.data;
            return templateEngine[id](data);
        });
    };
    return registerComponent;
});
