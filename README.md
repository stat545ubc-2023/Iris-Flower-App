# Iris Flower App

## **___App Developments and versions___**
Currently, we have two versions of Iris Flower App, the differences between two versions are described in the Introduction and Features of App section. 

[Link of Iris Flower App ver 1](https://khanhnguyen11.shinyapps.io/Iris_Flower_App/)

[Link of Iris Flower App ver 2](https://khanhnguyen11.shinyapps.io/IrisFlowerApp2/)

## **___Introduction and Features of App___**

The Iris Flower Shiny App is a web-based interactive tool designed for exploring and visualizing the relationship between 4 variables (sepal length, sepal width, petal length, and petal width) of three different species of Iris flowers (setosa, versicolor, and virginica) in `iris` dataset. 

For version 1, the app is built using the Shiny framework in R and has several features below: 

1. Users can interactively adjust sliders to define ranges for Petal Length and Petal Width, effectively narrowing down the dataset based on their preferences.

2. Additionally, a species filter allows users to focus on specific types of iris flowers or explore the entire dataset.

3. The main panel of the app presents a scatter plot that  represents the relationship between Petal Length and Petal Width, with points color-coded by species. 

4. A dynamic table is also provided below the plot, showcasing the filtered results and enabling users to explore the dataset in a tabular format.

5. The app further enhances user experience by displaying the number of results found based on the selected filters, providing immediate feedback on the scope of their exploration.

6. A download button is included for added utility, allowing users to save the filtered dataset as a CSV file for offline analysis. 

For version 2, we improved some features in version 1 and offered additional features: 
1. A theme was added to make the app more appealing 

2. Users can customize the x and y axes, selecting from a min-max range of variables. Version 1 only allows choosing Petal.Length and Petal. Width as x and y variables. 

3. The app dynamically adjusts slider ranges based on user variable selections.

4. A checkbox group allows users to filter data by one or more species simultaneously.

5. A new tab of introduction to give users information about iris data and how to use the app. 

6. A new tab of the scatter plot visually represents the selected variables, assigning distinct colors to each iris species.

7. A new tab of table displays detailed results, with an option to download data as a CSV file.

8. A new tab of the Summary Statistics tab provides key statistics for the selected variables.


## **___Dataset___**

The `iris` dataset, introduced by Ronald A. Fisher in 1936, is a foundational dataset in machine learning and statistics.  With 150 observations of iris flowers categorized into three species and featuring measurements for four key attributes, the `iris` dataset is widely used for educational purposes and is a benchmark for practicing data analysis and classification techniques.

The Iris dataset is included in the R programming language as part of the `datasets` package so you can access the data with datasets::iris. 

[More information about iris dataset](https://archive.ics.uci.edu/dataset/53/iris) 




