# Janitor

Janitor lets you write unit test in coffeescript that resembles tests written with Ruby's Test::Unit. You can use it with node or in the browser.

## In the browser

Get [the most recent dist file](https://raw.github.com/rasmusrn/janitor/master/dist/janitor.js) and include it on your test page. Define your tests like so:

```coffeescript
class window.UserTest extends Janitor.TestCase
  'test mood': ->
    user = new User mood: 'happy'
    @assert user.isHappy()
```

Then, run your tests like this:

``` coffeescript
runner = new Janitor.BrowserRunner el: document.getElementById('js_test_results')
runner.run()
```

Test results will now be outputted to the #js_test_results element.

## In node

Install janitor via `npm install -g janitor` and create test files in test/* like so:

```coffeescript
MyLib = require '../.'

module.exports = class extends Janitor.TestCase
  'test something': ->
    obj = new MyLib
    @assert obj.allIsWell()
```

Run `janitor` to see test results in the terminal.

## Extras

Janitor supports `setup` (and `teardown`):

```coffeescript
MyLib = require '../.'

module.exports = class extends Janitor.TestCase
  setup: ->
    obj = new MyLib
    
  'test something': ->
    @assert obj.allIsWell()
    
  'test something': ->
    @assert obj.everythingOk()

```

You can also test asynchronously by using `async test` prefix instead of `test`:

```coffeescript
module.exports = class extends Janitor.TestCase
  'async test something': ->
    obj = new MyLib
    obj.doSomething =>
      @assert obj.allIsWell()
      @done()
```