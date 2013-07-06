$(document).ready(function() {
                  $("#toggle-toolbar").on("click", function() {
                      Smooth.send("toggle-toolbar");
                  });
                  $("#toggle-fullscreen-slow").on("click", function() {
                      Smooth.send("toggle-fullscreen-with-callback", { duration: 1.0 },
                                  function() { alert("[Smooth iOS Callback] -to-> Delegated Javascript"); });
                      });
                  $("#log").on("click", function() {
                         Smooth.send("log", {
                                color: $(document.body).css("background-color")
                         });
                  });
                  Smooth.on("color-change", function(payload) {
                            $(document.body).css("background", payload.color);
                  });
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