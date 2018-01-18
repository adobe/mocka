`sudo luarocks make mocka-1.0-1.rockspec`

`sudo luarocks install luacov`

Optional:
`sudo luarocks install luacov-coveralls`

`lua -lluacov run_tests.lua`

`luacov`

`luacov-cobertura -o coverage_report.xml`

Sugest using 
GitHub Pull Request Coverage Status and Cobertura Plugin


## Usage inside testClasses

### mock(...) - Mocking

``` 
    local classToMock = mock("path.to.class", {"method1", "method2"})
```

#### Alter mock behaviour

```
    local classToMock = mock("path.to.class", {"method1", "method2"})
    classToMock.__method1.doReturn = function(arg1, arg2)
        return arg1
    end
```

The only method that you don't want to alter if you mock is the __new__ function.

### test(...) and xtest(...) - Running and Skipping

#### Running a test
```
    test('describe what you are testing', function()
        assertEquals(true, true)
    end)
```


#### Running a test that throws exception or you know it will fail
```
    test('describe what you are testing', function()
        assertEquals(true, false)
    end, true)
```

#### Skipping a test
```
    xtest('describe what you are testing', function()
        assertEquals(true, true)
    end)
```

### assertEquals 


```
    assertEquals(true, true)
```

```
    local one_object = {
        one = 1,
        two = 2
    }
    local second_object = {
        two = 2,
        one = 1
    }
    
    assertEquals(one_object, second_object)
```

```
    assertEqualse("string", "string")
```

```
    assertEquals(1,1)
```

```
    local first_array = {1, 2, 3}
    local second_array = {1, 2, 3}
    assertEquals(first_array, second_array)
```

### assertNotEquals

```
    local first_array = {1, 2, 3}
    local second_array = {2, 1, 3}
    assertNotEquals(first_array, second_array)
```

### assertNil

```
    assertNil(x)
```

### assertNotNil

```
    local x = "string"
    assertNotNil(x)
```

### calls(...) - verify a mock has been called

```
    local classToMock = mock("class", {"method"})
    calls(classToMock.__method, 1)
```

```
    local classToMock = mock("class", {"method"})
    calls(classToMock.__method, 1, arg2, arg1)
```

In order to ignore a test use `xtest(...)` instead of `test(...)`