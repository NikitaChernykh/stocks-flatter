# Stocks Flutter App

## Getting Started

Follow the steps below to run the project:

#### 1. Clone the Repository
In the terminal of vscode run this command
```bash
git clone https://github.com/NikitaChernykh/stocks-flatter.git
cd stocks-flatter
```

After navigating to the project directory install the required packages.

In the terminal of vscode run this command
```bash
flutter pub get
```

#### 2. Environment Variables Setup

This project uses flutter_dotenv to load environment variables from an .env file. You will need to create an .env file in the root of the project and add your API key to succesfully fetch stocks in the app.

Key can be abtained here for free: https://finnhub.io/

Example of .env file
```bash
# .env
API_KEY=paste_your_api_key_here
```

#### 4. Running the Project

In the terminal of vscode run this command
```bash
flutter run
```

#### 5. Project Structure
The project structure follows a simple layout with the following main folders:

* lib/: Contains all Dart code and application logic.
* test/: Contains unit tests for the project.


#### 6. Architecture Design Document

In the project directory PDF is uploaded named "Project Overview" for more details on desing decisions.

#### 7. Run Tests

In the terminal of vscode run this command
```bash
flutter test
```

#### 8. Project Images

![Alt text](https://i.imgur.com/cLD1Z13.jpeg "stock screen")
![Alt text](https://i.imgur.com/vBN01nj.jpeg "crypto screen")