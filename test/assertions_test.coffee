Janitor = require '../.'
Assertions = require '../src/assertions'
Utils = require '../src/utils'

module.exports = class AssertionsTest extends Janitor.TestCase
  setup: ->
    class Assertable
      store_assert: (type, succeeded, options) ->
        @last_assert = { type, succeeded, options}
      
    Utils.extend Assertable.prototype, Assertions
    @assertable = new Assertable
  
  'test passing equal assertion': ->
    @assertable.assertEqual 1, 1
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'equal', assert.type
    @assertEqual 1, assert.options.val1
    @assertEqual 1, assert.options.val2
    
  'test failing equal assertion': ->
    @assertable.assertEqual 2,3
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'equal', assert.type
    @assertEqual 2, assert.options.val1
    @assertEqual 3, assert.options.val2
    
  'test passing truth assertion': ->
    @assertable.assert true
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'true', assert.type
    @assertEqual true, assert.options.exp

  'test failing truth assertion': ->
    @assertable.assert false
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'true', assert.type
    @assertEqual false, assert.options.exp
  
  'test passing throws assertion': ->
    callback = -> throw 'me!'
    @assertable.assertThrows callback
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'throw', assert.type
    @assertEqual callback, assert.options.callback
  
  'test passing throws assertion with second argument being a function': ->
    callback = -> throw new Error 'wee'
    check = (e) -> e.message == 'wee'
    @assertable.assertThrows callback, check
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'throw', assert.type
    @assertEqual callback, assert.options.callback
  
  'test failing throws assertion': ->
    callback = -> "Forget it! I won't throw anything"
    @assertable.assertThrows callback
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'throw', assert.type
    @assertEqual callback, assert.options.callback
  
  'test throws assertion fails if second argument is a function that returns false': ->
    callback = -> throw new Error 'Secret!'
    check = (e) -> e.message == 'dunno'
    @assertable.assertThrows callback, check
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'throw', assert.type
    @assertEqual callback, assert.options.callback
  
  'test passing contains assertion': ->
    @assertable.assertContains [1,2,3], 1
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'contains', assert.type
    @assert Array.isArray(assert.options.container)
    @assertEqual 3, assert.options.container.length
    @assertEqual i, assert.options.container[i-1] for i in [1..3]
    @assertEqual 1, assert.options.value
  
  'test passing throws refutation': ->
    callback = -> 1+1
    @assertable.refuteThrows callback
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'refute_throw', assert.type
    @assertEqual callback, assert.options.callback
  
  'test failing throws refutation': ->
    callback = -> throw new Error 'Boom!'
    @assertable.refuteThrows callback
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'refute_throw', assert.type
    @assertEqual callback, assert.options.callback
    @assertEqual 'Boom!', assert.options.error.message

  'test passing all assertion': ->
    persons = [
      { name: 'Ras', age: 26 },
      { name: 'Jeff', age: 22 }
    ]
    isAdult = (item) -> item.age >= 20
    
    @assertable.assertAll persons, isAdult
    assert = @assertable.last_assert
    @assert assert.succeeded
    @assertEqual 'all', assert.type
    @assertEqual isAdult, assert.options.callback
  
  'test failing all assertion': ->
    persons = [
      { name: 'Ras', age: 26 },
      { name: 'Jeff', age: 14 }
    ]
    isAdult = (item) -> item.age >= 20
    
    @assertable.assertAll persons, isAdult
    assert = @assertable.last_assert
    @assert !assert.succeeded
    @assertEqual 'all', assert.type
    @assertEqual isAdult, assert.options.callback
