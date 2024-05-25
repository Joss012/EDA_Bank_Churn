<img src="Images/Banner.png" width="1000" height="350"/>

# Exploratory Data Analysis in SQL

The purpose of this project is to analyze churn trends for the bank and identify key areas for potential improvement. By examining customer data, the project aims to uncover insights that can help reduce the churn rate, ultimately enhancing customer retention and satisfaction.

## Dataset Used

 - [Bank Customer Churn](https://www.kaggle.com/datasets/radheshyamkollipara/bank-customer-churn/data)

## Environment Used

- ```PostgreSQL```

- VS Code running ```SQL```

## Research Questions & Answers
 
1. What is the **churn rate of the bank**?
    - ``20.4%`` 

2. What is the **churn rate of the bank for each country**?
    - Spain:   ``16.7%`` 
    - France:  ``16.2%``
    - Germany: ``32.4%``

3. What is the **churn rate between Male and Females**?
    - Male:	  ``16.5%``
	- Female: ``25.1%``

4. What is the **churn rate between different age groups**?
    - Under 20: 	``6.1%``
	- 20-29: 		``7.6%``
	- 30-39: 		``10.9%``
	- 40-49: 		``30.8%``
	- 50-59: 		``56.0%``
	- 60 and above: ``27.9%`` 

5. What is the **churn rate between different tenures**?
    - 0: ``23.0%``&emsp; 6: ``20.3%``
	- 1: ``22.4%``&emsp; 7: ``17.2%``
	- 2: ``19.2%``&emsp; 8: ``19.2%``
	- 3: ``21.1%``&emsp; 9: ``21.8%``
	- 4: ``20.5%``&emsp; 10: ``20.6%``
	- 5: ``20.7%``

6. What is the **churn rate between different balance groups($)**?
    - 0-24,999: 	    ``13.9%``&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;	125,000-149,999: 	``24.3%``
	- 25,000-49,999: 	``31.9%``&emsp;&emsp;&emsp;		                150,000-174,999: 	``21.1%``
	- 50,000-74,999:	``21.5%``&emsp;&emsp;&emsp;                 	175,000-199,999:	``24.9%``
    - 75,000-99,999: 	``19.5%``&emsp;&emsp;&emsp;                 	200,000-224,999:	``53.1%``
	- 100,000-124,999:  ``26.9%``&emsp;&emsp;	                        225,000 and above:	``100.0%``

7. What is the **churn rate between customers who have a different number of products**?
    - 1: ``27.7%``
	- 2: ``7.6%``
	- 3: ``82.7%``
	- 4: ``100.0%``

8. What is the **churn rate between customers who do and don't have a credit card**?
    - DO: 	 ``20.2%``
	- DON'T: ``20.9%``

9. What is the **churn rate between customers who are active and not**?
    - ACTIVE: 	  ``14.3%``
	- NOT ACTIVE: ``26.9%``

10. What is the **churn rate between different Salary groups($)**?
    - 0-25,000:       ``19.9%``&emsp;&emsp;&emsp;	100,001-125,000: ``20.1%``
	- 25,001-50,000:  ``19.9%``&emsp;	125,001-150,000: ``20.4%``
	- 50,001-75,000:  ``20.9%``&emsp;	150,001-175,000: ``21.3%``
	- 75,001-100,000: ``18.8%``&emsp;	175,001-200,000: ``21.7%``

11. What is the **churn rate between customers who have and have not filed a complaint**?
    - HAVE: 	``99.5%``
	- HAVE NOT: ``0.05%``

12. What is the **churn rate between customers who have a different satisfaction scores(1-5)**?
    - 1: ``20.03%``
	- 2: ``21.8%``
    - 3: ``19.6%``
	- 4: ``20.6%``
	- 5: ``19.8%``

13. What is the **churn rate between customers who have different card types**?
    - Diamond:  ``21.8%``
	- Platinum: ``20.4%``
	- Gold: 	``19.3%``
	- Silver: 	``20.1%``

14. What is the **churn rate between customers who have different amounts of points earned**?
    - 100-200: ``50.0%``&emsp;	601-700:  ``20.9%``
	- 201-300: ``21.6%``&emsp;	701-800:  ``21.9%``
	- 301-400: ``20.5%``&emsp;	801-900:  ``20.4%``
	- 401-500: ``18.9%``&emsp;	901-1000: ``19.2%``
	- 501-600: ``19.8%``

## Summary

Based on the analysis, we can conclude that the features with the highest impact on the bank's churn rate are: ``Geography``, ``Gender``, ``Age``, ``Balance``, ``Number of Products``, ``Activity Status``, and ``Complaint Status``. 
