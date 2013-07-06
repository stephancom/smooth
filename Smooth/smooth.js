//
//  Smooth.js
//  Smooth
//
//  Created by Neil Burchfield on 6/25/13.
//  Copyright (c) 2013 Smooth.IO. All rights reserved.
//

;(function () {
  
    var host = window.location.host;
	var SmoothDispatcher = {
		callbacks: {},

		send: function(envelope, complete) {
			this.dispatchMessage("event", envelope, complete);
		},
		sendCallback: function(messageId) {
			var envelope = Smooth.createEnvelope(messageId);

			this.dispatchMessage("callback", envelope, function() {});
		},
		triggerCallback: function(id) {
			var dispatcher = this;
			setTimeout(function() {
				dispatcher.callbacks[id]();
			}, 0);
		},
		dispatchMessage: function(type, envelope, complete) {
			var dispatcher = this;
			this.callbacks[envelope.id] = function() {
				complete();
				delete dispatcher.callbacks[envelope.id];
			};

			window.location.href = "smooth://" + type + "/" + envelope.id + "?" + encodeURIComponent(JSON.stringify(envelope));
		}
	};

	var Smooth = {
		listeners: {},
		dispatcher: null,
		messageCount: 0,
		on: function(type, fn) {
			if (!this.listeners.hasOwnProperty(type) || !this.listeners[type] instanceof Array) {
				this.listeners[type] = [];
			}

			this.listeners[type].push(fn);
		},
		off: function(type) {
			if (!this.listeners.hasOwnProperty(type) || !this.listeners[type] instanceof Array) {
				this.listeners[type] = [];
			}

			this.listeners[type] = [];
		},
		send: function(type, payload, complete) {
			if (payload instanceof Function) {
				complete = payload;
				payload = null;
			}

			payload = payload || {};
			complete = complete || function() {};

			var envelope = this.createEnvelope(this.messageCount, type, payload);

			this.dispatcher.send(envelope, complete);

			this.messageCount += 1;
		},
		trigger: function(type, messageId, json) {
			var self = this;

			var listenerList = this.listeners[type] || [];

			var executedCount = 0;

			var complete = function() {
				executedCount += 1;

				if (executedCount >= listenerList.length) {
					self.dispatcher.sendCallback(messageId);
				}
			};

			for (var index = 0; index < listenerList.length; index++) {
				var listener = listenerList[index];
				if (listener.length <= 1) {
					listener(json);
					complete();
				} else {
					listener(json, complete);
				}
			}

		},
		triggerCallback: function(id) {
			this.dispatcher.triggerCallback(id);
		},

		createEnvelope: function(id, type, payload) {
			return {
				id: id,
				type: type,
				host: host,
				payload: payload
			};
		}
	};
	var nullDispatcher = {
		send: function() {},
		triggerCallback: function() {},
		sendCallback: function() {}
	};
	var i = 0,
		is_iOS = false,
		iDevice = ['iPad', 'iPhone', 'iPod'];

	for ( ; i < iDevice.length ; i++ ) {
		if (navigator.platform.indexOf(iDevice[i]) >= 0) {
			is_iOS = true;
			break;
		}
	}
    var UIWebView = /(iPhone|iPod|iPad).*AppleWebKit(?!.*Safari)/i.test(navigator.userAgent);

	if (is_iOS && UIWebView) {
		Smooth.dispatcher = SmoothDispatcher;
	} else {
		Smooth.dispatcher = nullDispatcher;
	}

	Smooth.SmoothDispatcher = SmoothDispatcher;
	Smooth.nullDispatcher = nullDispatcher;

	window.Smooth = Smooth;
})();
