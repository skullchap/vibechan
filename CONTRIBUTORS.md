# Contributors Guide

Welcome to **VibeChan**! This guide explains our app's architecture in basic terms so that new contributors can quickly understand how everything fits together.

---

## Overview

**VibeChan** is built in Flutter using **Clean Architecture** principles. The project is divided into layers and feature modules, each with its own responsibilities. Here’s a breakdown:

---

## Architecture Layers

### 1. Core
- **Domain**
  - **Models/Entities:** Contains pure data classes (e.g., `Board`, `Thread`, `Post`) that represent our business logic.
  - **Repository Interfaces:** Defines the abstract methods (e.g., `BoardRepository`, `ThreadRepository`) that our data layer must implement.
- **Data**
  - **Data Sources:** Contains classes responsible for fetching data (from APIs, local storage, etc.). For example, the FourChan API is accessed here.
  - **Repository Implementations:** Implements the repository interfaces from the Domain layer (e.g., `FourChanRepository`) by using the data sources.
- **Dependency Injection (DI)**
  - Manages and provides app-wide dependencies using libraries like `get_it` and `injectable`.
- **Presentation**
  - **Providers & State Management:** Uses Riverpod to manage state and provide data to the UI.
  
### 2. Features
- **Board Feature:** Contains screens and widgets related to board display and interaction.
- **Thread Feature:** Contains screens and widgets for viewing threads and posts.
- **Search Feature:** (Planned) Will contain functionality to search through boards or threads.
  
### 3. Additional Folders
- **Config:** Contains configuration files such as app settings and routing definitions.
- **Shared:** Contains common widgets and utilities used across multiple parts of the app.

---

## How It Works Together

1. **User Interaction:** The user navigates the app (using screens in the features modules).
2. **Presentation Layer:** UI components use Riverpod providers (located in the `presentation/providers` folder) to request data.
3. **Domain Layer:** Providers call repository methods defined in the domain (abstract interfaces).
4. **Data Layer:** Repository implementations (like `FourChanRepository`) fetch and process data from the data sources.
5. **Dependency Injection:** DI automatically wires up the correct implementations throughout the app.

---

## Vibecoding Philosophy

- **AI-Generated Code Only:** All contributions must be generated using AI tools.
- **No Manual Logic:** You interact with LLMs to add or modify features.
- **Prompt-Driven Development:** Check out the [`prompts.txt`](prompts.txt) file for examples of how to instruct your AI tools.

---

## Getting Started as a Contributor

1. **Read This Guide:** Understand the structure and flow of the app.
2. **Explore the Code:** Look into each layer (Domain, Data, Presentation) to see how they interact.
3. **Use the Prompts:** Refer to the prompts in `prompts.txt` for guidance on how to contribute.
4. **Ask Questions:** If anything is unclear, reach out on our communication channels.

Happy vibecoding!
