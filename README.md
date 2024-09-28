# **Events Manage System**

## **Overview**

In **September 10, 2024**, I embarked on creating a **cinema management system** that facilitates handling cinema operations efficiently. This application integrates a **Django REST framework API** with a **Flutter desktop application**, allowing for comprehensive management of films, guests, and reservations.

### **API Integration**

The backend of this application is powered by a simple **Django REST API**. As a beginner in **Django REST framework**, I focused on creating a straightforward API to handle essential operations such as:

- **GET**: Retrieve data for films, guests, and reservations.
- **POST**: Add new entries for films, guests, and reservations.
- **PUT**: Update existing records.
- **DELETE**: Remove unwanted entries.

You can find the API source code [**here**](https://github.com/hmoodaps/events_manage_api).

### **Firebase Utilization**

I also integrated **Firebase** as a database solution to demonstrate my ability to work with Google’s database services. Firebase is used for specific functionalities within the application, ensuring real-time data handling and enhanced user experience.

### **Application Features**

The desktop application is designed specifically for use by **managers and employees**. Here are some key features:

- **Role-based Access**:
    - **General Manager**: Has full access to create and manage employees, movies, guests, and reservations. They can also modify any aspect of the program.
    - **Employee**: Can access and manage guest data but does not have permissions to modify or create movies.

- **User Interface**:
    - The application features a user-friendly interface built with **Flutter**, utilizing various widgets such as **GridView** and **Table** for displaying information.
    - I employed the **Cubit** state management pattern to efficiently manage application states.

### **Technical Details**

- **Backend**: Django REST Framework for building the API.
- **Frontend**: Flutter for the desktop application.
- **Database**: Firebase for specific data management tasks.
- **State Management**: Cubit for managing application state effectively.

### **Future Enhancements**

While the current implementation works as intended, I recognize some areas for improvement:

- **Permissions Management**: I acknowledge the need for better role management, as the current setup allows both managers and employees to access certain features that could be restricted.
- **Testing and Documentation**: I plan to enhance my understanding of testing and documentation to improve the overall quality and maintainability of the code.

### **Conclusion**

This project showcases my skills in API development, database management, and front-end development. I look forward to further enhancing this application and expanding my knowledge in these technologies.
