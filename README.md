README
======

Introduction
------------
This is a Proof of Concept (PoC) for an Xcode source editor plugin focused on integrating IA. The plugin will allow developers to easily integrate their IA models into their Xcode projects and use them to generate code.

Pre-requisites
--------------
To run this PoC, you will need the following:
* Ollama or LLM Studio running
* Codellama as an LLM model (e.g., `ollama run codellama`)
* Web App / API for handling extensions requests installed and running. See https://github.com/morissonmaciel/react-ollama-chat-assistant.git
 
Installation
------------
To install the plugin, follow these steps:

1. Clone the repository:
```bash
    git clone https://github.com/morissonmaciel/swift-xcode-xiassistant.git
```

2. Open the project file using Xcode or terminal:
```bash
    open XIAssistant.xcodeproj
```

3. Open `XIAssistant` and `XIAssistantPlugin` targets configuration.
4. Sign both targets using a valid Apple ID developer Team.
5. Select or create scheme for XIAssistantPlugin in Xcode.
6. Run plugin schema and select Xcode for debug app.

Usage
-----
To use the plugin, follow these steps:

1. Open a Swift file in Xcode.

2. Write instructions using `// @IA` as prefix:
```swift
    // @IA generate a login view using SwiftUI
```

3. If you want to change existing code, select the code and instructions simultaneously.

4. Select `Editor` > `Local IA Assistant` > `Generate or Transform Code`

5. The plugin will generate the code based on your IA model and insert it into your Xcode project.

6. For documentation, select target source code and repeat the 4th step, but selecting `Document Selected Code`

Documentation
-------------
For more information about this PoC, please refer to the following documentation:
* [Ollama Documentation](https://docs.codellama.com/ollama/)
* [LLM Studio Documentation](https://docs.codellama.com/llm-studio/)
* [Codellama Documentation](https://docs.codellama.com/codellama/)

Troubleshooting
---------------
If you encounter any issues while using the plugin, please refer to the following troubleshooting guide:
* [Ollama Troubleshooting Guide](https://docs.codellama.com/ollama/troubleshooting/)
* [LLM Studio Troubleshooting Guide](https://docs.codellama.com/llm-studio/troubleshooting/)
* [Codellama Troubleshooting Guide](https://docs.codellama.com/codellama/troubleshooting/)

Conclusion
----------
This PoC demonstrates the ability to integrate IA models into Xcode projects and generate code based on those models. The plugin is designed to be easy to use and provides a simple way for developers to integrate their IA models into their Xcode projects.
