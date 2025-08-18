### **1\. Project Overview**

This document marks our first major milestone in the project. It covers everything outlined in the course requirements: the user interface design, database integration, basic create/read/update/delete (CRUD) functionality, a landing page, and a working ListView. All of these components have been implemented as part of Deliverable 1\.

## **2\. Completion Checklist**

| Task | Status |
| :---- | :---- |
| UI Interface (Material Design, activity flow) | ✅ Completed |
| Database connection (backend connection) | ✅ Completed |
| CRUD operations | ✅ Completed |
| Landing page (Home screen) | ✅ Completed |
| ListView implementation (displaying the data) | ✅ Completed  |

## **3\. Task Distribution**

The project tasks were distributed among team members as follows:

\- **Manar Najem**: Responsible for the first 4 screens (Welcome, Login, Register, and Main Menu), along with everything related to these pages.

 \- **Melissa**: Worked on screens 5, 6, and 7, along with everything related to these pages.

 \- **Rishard**: Handled screens 8, 9, and 10, along with everything related to these pages.

**Project Progress Summary**

**Manar Najem:**

**1\. Initial Project Setup**

* Created **screens/ folder** and added all initial screens.  
* Added **assets/ folder** with the app logo and custom fonts.  
* Implemented **WelcomeScreen**:  
  * Gradient background  
  * Circular logo with frosted glass effect  
  * Title using Pacifico \+ NunitoSans fonts  
  * Navigation buttons for **Sign in** and **Register**  
* Set up **main.dart** with initial routing between screens.

**2\. Main Menu Integration**

* Added **Main Menu Screen (04\_main\_menu\_screen.dart)**:  
  * Teal button style with NunitoSans text styling.  
  * Menu options: **Add Ingredients, Recipe Mixer, Magic Recommendations, NutriPal, Groceries Around You, Settings**.  
  * Matching icons for each menu entry.  
* Registered **/main-menu route** in main.dart.  
* Added a temporary **“Test Main Menu” button** in WelcomeScreen for development navigation.

**3\. Login Screen Enhancements**

* Updated **02\_login\_screen.dart**:  
  * Frosted-glass circular logo container with white border & shadow.  
  * “Login” title in Pacifico font and subtitle in NunitoSans.  
  * Rounded, semi-transparent input fields for email & password.  
  * Teal, pill-shaped “Sign in” button with bold NunitoSans text.  
  * Added **“Don’t have an account? Sign up” link** and **divider for future social login**.  
  * Added **TODO** for Firebase authentication & social login.

**4\. Register Screen Implementation**

* Implemented **RegisterScreen**:  
  * Full-screen vertical gradient.  
  * Logo embedded in frosted-glass circle.  
  * Input fields for **Name, Email, Password**.  
  * Teal “Sign Up” button.  
  * **“Log in here” link** to redirect to login.  
  * Added SafeArea \+ scroll for better layout.  
  * Added **TODO** for Firebase signup integration.

**5\. Authentication Integration**

* **Firebase Authentication \+ Google Sign-in** added:  
  * Set up **user registration & sign-in flows** with Firebase Auth.  
  * Integrated **Google login** support.  
  * Enhanced **Main Menu** with:  
    * User personalization (welcome with username).  
    * Logout functionality.  
* Updated pubspec.yaml with firebase\_auth and google\_sign\_in dependencies.

**6\. Cleanup & Polish**

* Removed temporary **“Test Main Menu” button** from WelcomeScreen.  
* Simplified UI to keep only **Sign in** and **Register** buttons

---

**Melissa Louise Bangloy**  
**Worked on:** 

**1\. User Account Management System**

* Created **Settings Screen (05\_settings\_screen.dart)**:  
  * **Profile Editing**: Toggle-based edit mode for name, email and password  
  * **Account Security**: Two-step account deletion with password confirmation and Firebase cleanup  
  * **Firebase Integration**: Direct integration with FirebaseAuth for profile updates and session management

**2\. Pantry Management System**

* Built **Add Ingredients Screen (06\_add\_ingredients\_screen.dart)**:  
  * **Smart Selection Grid**: 3-column responsive layout with visual state indicators and long-press editing  
  * **Custom Ingredient Input**: Text field with duplicate prevention and keyboard submission support  
  * **Pantry Display**: Fixed-height scrollable container with chip-style ingredients and remove buttons for better ui experience  
  * **Navigation Integration**: Passes pantry ingredients to Recipe Mixer via route arguments

**3\. Recipe Discovery Engine**

* Developed **Recipe Mixer Screen (07\_recipe\_mixer\_screen.dart)**:  
  * **TheMealDB API Integration**: HTTP requests with ingredient-based search using filter endpoints  
  * **Smart Matching Algorithm**: Bidirectional string comparison between user pantry and recipe ingredients  
  * **Recipe Deduplication**: Map-based removal of duplicate recipes by idMeal with 6-recipe limit  
  * **Dietary Preferences**: FilterChip UI implementation (with TODO for actual filtering logic)

**4\. Recipe Presentation System**

* Implemented **Recipe Viewer Screen (07.5\_recipe\_viewer\_screen.dart)**:  
  * **Instruction Processing**: Multi-stage text parsing using RegEx for step-by-step display  
  * **Rich Visual Layout**: Hero images, category badges, numbered steps  
  * **Error Handling**: Comprehensive network error management with user-friendly fallback screens  
  * **Navigation Flow**: Seamless integration with Recipe Mixer for complete user journey

 

---

**Rishard Mohamed**   
**Worked on:** 

**1\. Firebase Integration & Deployment System**

* Created Complete Firebase Backend Setup:  
  * Project Foundation: Set up Firebase as the main backend service for the app, including all necessary configuration files and hosting setup for deploying the app to the web  
  * Real-time Database: Connected Firebase Realtime Database to store and sync user data instantly across devices, ensuring data is always up-to-date  
  * App Deployment: Successfully deployed the entire application to Firebase hosting, making it accessible online  
  * Deployment Pipeline: Automated Firebase hosting deployment with a git Action
  

**2\. NutriPal Chat Interface System**

**Implemented NutriPal Screen (nutripal_screen.dart)**:

* **AI Integration**: DeepSeek API integration with HTTP requests for real-time nutrition advice
* **Chat Message System**: Custom ChatMessage model with timestamp tracking and user/AI message differentiation
* **Dynamic UI Components**: Gradient background design, circular avatar container, and responsive message bubbles
* **Auto-Scroll Functionality**: Automatic scroll-to-bottom behavior using ScrollController for seamless chat experience
* **Loading States**: Real-time loading indicators with "NutriPal is thinking..." message during API calls
* **Error Handling**: Comprehensive network error management with user-friendly fallback messages
* **Input Validation**: Message trim validation and empty message prevention
* **Responsive Design**: Constraint-based message width (70% screen width) with proper alignment for user vs AI messaging 

**3\. Shop Around Location**

**Implemented Shop Around Screen (shop_around_screen.dart)**:

* **Google Maps API Integration**: Dual API calls for postal code geocoding and nearby places search with radius-based filtering
* **Dynamic Search Filters**: Checkbox toggles for groceries/restaurants and dropdown radius selection (1-10km)
* **Location Services**: Canadian postal code validation and coordinate conversion using Google Geocoding API
* **Results Management**: Limited results display (15 per category) with comprehensive place data including ratings, vicinity, and price levels
* **Error Handling**: Robust network error management with user-friendly validation messages and loading states
* **Rich Card Display**: Custom ListTile layout with category icons, star ratings, price indicators, and location details
* **Responsive UI Design**: Gradient background, white-overlay input fields, and organized filter controls for optimal user experience

