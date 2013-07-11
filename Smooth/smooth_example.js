$(document).ready(function() {
                  
                  /************************************************************/
                  // Application Variable Accessors
                  /************************************************************/

                  /************************************************************/
                  // Send to client
                  /************************************************************/
                  
                  //////////////////////////////////////////////////////////////
                  // User Defaults
                  $("#setUserDefault").on("click", function() {
                      Smooth.send("setUserDefault", {
                            object: "object1",
                            key: "key1"
                      });
                  });

                  $("#getUserDefault").on("click", function() {
                        Smooth.send("getUserDefault", {
                                key: "key1"
                        });
                  });

                  Smooth.on("getUserDefault", function(payload) {
                        var object = payload.object;
                        alert("NSUserDefaults: " + object);
                  });
                  
                  $("#removeUserDefault").on("click", function() {
                          Smooth.send("removeUserDefault", {
                                key: "key1"
                          });
                  });
                  //////////////////////////////////////////////////////////////
                  // Toggle Toolbar
                  $("#toggle-toolbar").on("click", function() {
                      Smooth.send("toggle-toolbar");
                  });
                  //////////////////////////////////////////////////////////////
                  // Toggle Full Screen w/ Callback
                  $("#toggle-fullscreen-slow").on("click", function() {
                      Smooth.send("toggle-fullscreen-with-callback", { duration: 1.0 },
                        function() {
                              alert("[Smooth iOS Callback] -to-> Delegated Javascript");
                        });
                  });
                  //////////////////////////////////////////////////////////////
                  // LLDB/GDB NSLog
                  $("#log").on("click", function() {
                         Smooth.send("log", {
                                color: $(document.body).css("background-color")
                         });
                  });
                  //////////////////////////////////////////////////////////////
                  // Get Camera
                  $("#getcamera").on("click", function() {
                        Smooth.send("getcamera");
                  });
                  //////////////////////////////////////////////////////////////
                  // Get Camera Callback
                  Smooth.on("getcamera", function(payload) {
                        var img = new Image();
                        var div = document.getElementById('myImage');
                        
                        img.onload = function() {
                            div.appendChild(img);
                        };
                        
                        img.src = payload.file;
                  });
                  //////////////////////////////////////////////////////////////
                  // Get Contacts
                  $("#getContacts").on("click", function() {
                        Smooth.send("getContacts");
                  });
                  //////////////////////////////////////////////////////////////
                  // Get Contacts Callback
                  Smooth.on("getContacts", function(payload) {
                    for (var i = 0; i < payload.array.length; i++) {
                        var object = payload.array[i];
                        for (var property in object) {
                            alert('item ' + i + ': ' + property + '=' + object[property]);
                        }
                    }
                  });
                  //////////////////////////////////////////////////////////////
                  // Post Status Bar Message
                  $("#statusMessage").on("click", function() {
                        Smooth.send("statusMessage", {
                                 message: "Hello World. I'm a message!",
                                 duration: 2
                         });
                  });
                  //////////////////////////////////////////////////////////////
                  // Alert View
                  $("#presentAlert").on("click", function() {
                         Smooth.send("presentAlert", {
                            title: "This is my title",
                            message: "This is a message",
                            firstIndex: "firstIndex",
                            secondIndex: "secondIndex",
                            thirdIndex: "thirdIndex",
                            cancelTitle: "cancelTitle"
                     });
                  });
                  //////////////////////////////////////////////////////////////
                  // Alert View Callback
                  Smooth.on("presentAlert", function(payload) {
                            alert("You Selected: " + payload.index);
                  });
                  //////////////////////////////////////////////////////////////
                  // Status Bar Message Callback
                  Smooth.on("statusMessage", function(payload) {

                  });
                  //////////////////////////////////////////////////////////////
                  // Change Background
                  Smooth.on("color-change", function(payload) {
                        $(document.body).css("background", payload.color);
                  });
                  //////////////////////////////////////////////////////////////
                  // Display Image from RSS feed
                  Smooth.on("show-image", function(payload, complete) {
                    $.get(payload.feed, function (data) {
                          $("img").remove();
                          
                          var items = $(data).find("item");
                          
                          var index = Math.round(Math.random() * items.length);
                          var description = $(items.get(index)).find("description");
                          
                          var offscreen = $(document.createElement("div"));
                          offscreen.addClass("offscreen");
                          offscreen.append(description.text());
                          
                          $(document.body).append(offscreen);
                          var brokenImage = $(offscreen.find("img").get(0));
                          var image = $(document.createElement("img"));
                          image.attr("src", "http://" + brokenImage.attr("src"));
                          
                          image.load(function() {
                            complete();
                          });
                          
                          offscreen.remove();
                          
                          $(document.body).append(image);
                      });
                        return false;
                    });
                  
});