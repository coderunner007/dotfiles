var ctrl = 'ctrl';
var shift = 'shift';
var cmd = 'cmd';
var alt = 'alt';
var focusToModifier = [ctrl, shift];
var moveToAndHalfScreenResizeModifier = [ ...focusToModifier, cmd ];
var right = 'l';
var left = 'h';
var up = 'k';
var down = 'j';

function centerWindow(window) {
  if (window) {
    window.setTopLeft({
      x: screen.x + (screen.width / 2) - (window.frame().width / 2),
      y: screen.y + (screen.height / 2) - (window.frame().height / 2)
    });
  }
}

function getCurrentContext() {
  // main: returns the screen containing the window with the keyboard focus
  // flippedVisibleFrame: Returns the visible frame for
  // the screen subtracting the Dock and Menu
  // from the frame when visible, top-left based origin
  var context = {};
  context.screen = Screen.main().flippedVisibleFrame();
  context.focusedWindow = Window.focused();
  return context;
}

Key.on('f', [ctrl, shift, cmd], function () {
  getCurrentContext().focusedWindow.maximise();
});

Key.on(left, moveToAndHalfScreenResizeModifier, function () {
  var currentContext = getCurrentContext();
  currentContext.focusedWindow.setTopLeft({
    x: 0,
    y: 0
  });
  currentContext.focusedWindow.setSize({
    width: currentContext.screen.width / 2,
    height: currentContext.screen.height
  });
});

Key.on(right, moveToAndHalfScreenResizeModifier, function () {
  var currentContext = getCurrentContext();
  currentContext.focusedWindow.setTopLeft({
    x: currentContext.screen.width / 2,
    y: 0
  });
  currentContext.focusedWindow.setSize({
    width: currentContext.screen.width / 2,
    height: currentContext.screen.height
  });
});

Key.on(up, moveToAndHalfScreenResizeModifier, function () {
  var currentContext = getCurrentContext();
  currentContext.focusedWindow.setTopLeft({
    x: 0,
    y: 0
  });
  currentContext.focusedWindow.setSize({
    width: currentContext.screen.width,
    height: currentContext.screen.height / 2
  });
});

Key.on(down, moveToAndHalfScreenResizeModifier, function () {
  var currentContext = getCurrentContext();
  currentContext.focusedWindow.setTopLeft({
    x: 0,
    y: currentContext.screen.height / 2
  });
  currentContext.focusedWindow.setSize({
    width: currentContext.screen.width,
    height: currentContext.screen.height / 2
  });
});

Key.on('b', focusToModifier, function(){
  App.launch('Firefox').focus();
})

Key.on('b', [ ...focusToModifier, alt ], function(){
  App.launch('Google Chrome').focus();
})

Key.on('x', focusToModifier, function(){
  App.launch('Microsoft Outlook').focus();
})

Key.on('c', focusToModifier, function(){
  App.launch('Amazon Chime').focus();
})

Key.on('e', focusToModifier, function(){
  App.launch('Finder').focus();
})

Key.on('s', focusToModifier, function(){
  App.launch('Slack').focus();
})

Key.on('g', focusToModifier, function(){
  App.launch('IntelliJ IDEA').focus();
})

Key.on('t', focusToModifier, function(){
  App.launch('iTerm').focus();
})

Key.on('q', focusToModifier, function(){
  App.launch('Quip').focus();
})

Key.on('f', focusToModifier, function(){
  App.launch('Figma').focus();
})

Key.on('z', focusToModifier, function(){
  App.launch('Insomnia').focus();
})
