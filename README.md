# SwiftLog

SwiftLog wraps unwieldy use of os_log calls into prettier syntax! 

Begone days of Obj-C-style string interpolation! `"%@", value` -> `"\(value)"`

#### There are three ways of using SwiftLog, to allow for some flexibility in usage.

##### 1. Log(self)

```
struct UserFlowCoordinator { 
    func login() {
        os_log("User %{public}@ logged in", log: OSLog.UserFlowCoordinator, type: .info, username)
    }
}
```
Can become
```
struct UserFlowCoordinator { 
    func login() {
        Log(self).info("User \(username) logged in")
    }
}
```

##### 2. Loggable
If performing a lot of logging from within one type, and you want to change the category for that type, you can have it conform to `Loggable`:
```
struct UserFlowCoordinator: Loggable { 

    var logCategory: String {
        "UserFlow" // Log(self) will now use the category "UserFlow" instead of "UserFlowCoordinator"
    }

    func login() {
        Log(self).info("User \(username) logged in")
    }
}
```

##### 3. Log("Category")
You can simply specify the category as a string:
```
Log("Category").info("User \(username) logged in")
```


#### PII Note:
In order to support string interpolation in the message parameter of Log, `%public` is used in the underlying call to `os_log`. Therefore, sensitive information should not be included in the message parameter of any logging functions.`
