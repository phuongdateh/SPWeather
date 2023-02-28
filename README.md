# SPWeather

 ### Checklist of items has done:

- [x] 1. Programming language: Swift
- [x] 2. Design app's architecture used MVVM
- [x] 3. Completed total 5 usecases
- [x] 4. Write UnitTests 
- [x] 5. Write UITest
- [x] 6. Readme file

 ### Structure Code 
 - Application: Manage started scene
 - Navigator: to manage navigation to another screen and manage Navigation Controller
 - Common: Include some class using common is ViewModel, ViewController
 - Configuration: Include some config for a network is appId for request API, Base URL, API_Key
 - Extension: Using to define some func using many places in a project.
 - Model: Contain some model of a project. For example: WeatherData, SearchData, .. 
 - Services: Including network serveice, CoreData service to save local data.
 - Modules: Including screen in application such as HomeScreen, WeatherDetailScreen
 - Resources: Including some default file when new create project and asset in application
 
 ### The software development principles, patterns & practices being applied
 * Singleton Design Parten: WeatherAPIService
 * Dependence Injection: WeatherAPIService, CoreDataManager,
 * MVVM Architecture and I addition one another layer is Interactor for each modules. The main task of interactor are try get data from server or local machine(CoreData). To bindings beetween ViewModel and View I use closures. The main reasons I added new layer Interactor because I want to viewmodel don't know how to get data, Interactor will do it.


