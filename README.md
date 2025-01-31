# Predicting Avocado Prices with Machine Learning

Sarah Brittle and Ceasar Saldivar

## Overview
The purpose of this project is to build a Machine Learning model that can predict the average price of avocados.

*`Our goal is to build a model with a high predictive accuracy, aiming for an R² value of at least 0.80.`*

## Data Source
The dataset used in this project originates from the Hass Avocado Board (HAB).

The Hass Avocado Board is a non-profit organization that supports the U.S. avocado industry 
by providing data on avocado prices, supply, demand, and market trends to help promote growth and consumption of Hass avocados.

The Hass Avocado Board collects data on avocado prices, supply and demand, consumer behavior, seasonal trends, 
and market dynamics to support the avocado industry and inform decision-making.

This made it a natural choice for our project.

However, we sourced our data from Kaggle, where it was uploaded by user 'VakhariaPujan'. This dataset is an updated version 
of two earlier datasets from users 'Justin Kiggins' and 'Valentin Joseph', all of which are based on the original data from the HAB.

## Cleaning
The first step was to normalize the data into its 3rd normal form. Here's the process we followed:

### Initial Review and Cleaning:

Downloaded the CSV file from Kaggle and loaded it into a notebook.
Converted the date column from an object to datetime format.
Dropped rows with values for 'California', 'GreatLakes', 'Midsouth', 'Northeast', 'Plains', 'SouthCentral', 'Southeast', 'West', and 'TotalUS' 
as they represented total market values for each year, which would skew the year-over-year data analysis.

### Mapping Regions to Markets:

Created a dictionary (country_map) to define which regions belong to each market, based on the Hass Avocado Board's Market Mapping.
Reversed the dictionary to map regions (keys) to their corresponding markets (values).
Added a new market column to the dataframe by mapping each region to its respective market.

### Creating Supporting Tables for SQL Import:

Extracted unique values from key columns (type, region, market) to create separate dataframes:
type_df: Contains unique type values (conventional, organic), saved as type_index.csv.
region_df: Contains unique region names, saved as region_index.csv.
market_df: Contains unique market names, saved as market_index.csv.
Replaced string values in type, region, and market columns in avocado_df with their respective indices from these supporting tables.

### Final Normalized Dataframe:

Saved the updated avocado_df, with type, region, and market columns converted to numerical indices, as avocados_index.csv.
These indices establish relationships with their respective tables (type_df, region_df, market_df) for integration into a PostgreSQL database.

## Database Design and Implementation
After normalizing and cleaning the data, the next step was to structure it into a relational database using PostgreSQL, as illustrated 
in the Entity Relationship Diagram (ERD) below.

### Entity-Relationship Diagram (ERD)

![avocado_ERD](https://github.com/user-attachments/assets/fc26dfd6-56ee-4327-b0bb-202a15325598)

### PostgreSQL Database Setup

The schema consists of four tables: type, region, market, and avocados.

Type, region, and market are lookup tables containing descriptive data (e.g., avocado types, regions, and markets).
The avocados table holds sales data, including price, volume, and bag types, linking to the other tables through foreign keys.
Foreign keys in the avocados table connect to the type, region, and market tables by their respective index values, establishing clear 
relationships between the data.

## Preprocessing
Using SQLAlchemy, we created an engine and reflected our Avocado database into classes, resulting in four classes representing each table.

We then used read_sql to perform a series of joins on these classes, creating the avocado_df dataframe.
During this process, we removed unnecessary columns from the joins: 'type_', 'region_', 'market_', 'index_1', 'index_2', and 'index_3'.

Next, we converted the date column to a datetime format to extract the month.
The extracted month was binned into quarters (Q1, Q2, Q3, and Q4) and cast as a string to ensure compatibility with our model.

Finally, we dropped the index column as it contained unique information that could interfere with the model's accuracy.

## Training
We used scikit-learn's StandardScaler to scale the features 'plu4046', 'plu4225', 'plu4770', and 'totalbags'.
The scaled data was then transformed and labeled as scaled_data. The target variable (y) was defined as 'averageprice', 
while the feature set (X) included 'plu4046', 'plu4225', 'plu4770', 'totalbags', 'region', 'market', 'type', and 'quarter'.

*`Since every region belongs to a market, and every market contains regions,
one of these features must be excluded from X to prevent duplicate or redundant data.`*

Next, we converted all object-type columns into dummy variables using get_dummies.
It's important to scale the numerical data before applying get_dummies to avoid scaling the generated dummy variables.

We then split the dataset into training and testing sets using scikit-learn's train_test_split.

Finally, the model was trained on the training set, and predictions were made using the test data.

## Results
Random Forest Regressor

        The mean absolute value is: 0.1158009761226277
        The mean square error is: 0.026179730858605355
        The root mean square error is: 0.16180151686126232
        The R squared is: 0.836470979103074
  
Decision Tree Regression

        The mean absolute value is: 0.15221504740241626
        The mean square error is: 0.05284956701195434
        The root mean square error is: 0.22989033692600988
        The R squared is: 0.6698805654279453

Linear Regression

        The mean absolute value is: 0.19533338519756038
        The mean square error is: 0.06597543561334976
        The root mean square error is: 0.2568568387513748
        The R squared is: 0.5878911648339988

Neural Network

        Loss: 0.3475993573665619, R2 Score: -1.1712255477905273

## Summary
Over the course of this project, we found that the Random Forest Regressor produced the highest R² score of 0.84, 
making it the most accurate model for predicting avocado prices.

This model can be effectively used to forecast avocado market prices, providing valuable insights for pricing strategies in the industry.

To enhance prediction accuracy in the future, we could consider the following approaches:

* Hyperparameter Tuning: Fine-tune the model’s parameters to improve accuracy and performance.
* Adding More Data and Features: Include additional data, such as weather or market trends, to capture factors influencing prices.
* Using Time-Series Models: Apply models designed for analyzing time-based data to better understand trends and seasonality.

## References

**Data Source:**

* Kaggle Dataset:

    https://www.kaggle.com/datasets/vakhariapujan/avocado-prices-and-sales-volume-2015-2023

* Hass Avocado Board:

    https://hassavocadoboard.com/

**Cleaning Notebook:**

* Drop Values Reference:

    https://www.youtube.com/watch?v=xCax4DLOKPA
 
* HAB Market Mapping:

    https://hassavocadoboard.com/category-data/

* Binning String Values:

    https://stackoverflow.com/questions/59757095/how-to-bin-string-values-according-to-list-of-strings

**Preprocessing:**

* Connecting PostgreSQL with SQLAlchemy:

    https://www.geeksforgeeks.org/connecting-postgresql-with-sqlalchemy-in-python/
