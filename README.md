# SPWeather
SPWeather is a weather app for iOS that provides weather information for different cities around the world. It is built using Swift programming language and MVVM architecture.

### Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
* Xcode 14 or later
* Swift 5
* iOS 14 or later

### Features
- View weather information for different cities.
- Search for weather information of a specific city.
- View the current temperature, humidity, wind speed and weather conditions.

 ### Checklist of items has done:

- [x] 1. Programming language: Swift
- [x] 2. Design app's architecture used MVVM
- [x] 3. Completed total 5 usecases
- [x] 4. Write UnitTests 
- [x] 5. Write UITest
- [x] 6. Readme file

### Architecture
SPWeather uses MVVM (Model-View-ViewModel) architecture pattern. The project is organized into the following layers:

* Model: The data models that represent the weather information for a city and its forecast for the next five days.
* View: The user interface layer that displays the weather information to the user and handles user interactions.
* ViewModel: The intermediary layer between the model and the view. It fetches data from the API, processes it and exposes it to the view.

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

### API
SPWeather uses the OpenWeatherMap API to retrieve weather data for different cities. To use the app,need to sign up for an API key from the OpenWeatherMap website and replace the apiKey constant in `Configs.swift`.
 
 ### The software development principles, patterns & practices being applied
 * Singleton Design Parten: WeatherAPIService
 * Dependence Injection: WeatherAPIService, CoreDataManager,
 * MVVM Architecture and I addition one another layer is Interactor for each modules. The main task of interactor are try get data from server or local machine(CoreData). To bindings beetween ViewModel and View I use closures. The main reasons I added new layer Interactor because I want to viewmodel don't know how to get data, Interactor will do it.


