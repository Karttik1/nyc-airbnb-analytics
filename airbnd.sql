SELECT * FROM airbnb;

# Q1 How many listings are in each neighbourhood group? Show the biggest first.

SELECT neighbourhood_group , COUNT(*) AS Total_Listing
FROM airbnb
GROUP BY neighbourhood_group 
ORDER BY Total_Listing DESC;

# Q2 List the 10 most expensive listings with their name, neighbourhood and price.

SELECT name,neighbourhood,price
FROM airbnb
ORDER BY price DESC
LIMIT 10;

# Q3  What is the average review rating for each room type, and how many listings does each have?

SELECT room_type,COUNT(*) AS Total_Listing, ROUND(AVG(review_rate_number),2) AS Avg_Review_Rating
FROM airbnb
GROUP BY room_type
ORDER BY Total_Listing DESC;

# Q4 How many listings are instant bookable and how many are not?

SELECT instant_bookable , COUNT(*) AS Total_Listing
FROM airbnb
GROUP BY instant_bookable
ORDER BY Total_Listing DESC;

# Q5 Which 10 neighbourhoods have the highest average review rating? Only include neighbourhoods with at least 50 listings.


SELECT neighbourhood ,COUNT(*) AS Total_Listing, ROUND(AVG(review_rate_number),2) AS Avg_Review
FROM airbnb
GROUP BY neighbourhood
HAVING COUNT(*)>=50
ORDER BY Avg_Review DESC
LIMIT 10;

# Q6 Do verified hosts have a higher average rating or more reviews than unverified hosts?

SELECT host_identity_verified,COUNT(*) AS Total_Listing ,ROUND(AVG (review_rate_number),2) AS Avg_Review,ROUND(AVG(number_of_reviews),2) AS Avg_Num_Reviews
FROM airbnb
GROUP BY host_identity_verified
ORDER BY Avg_Review DESC;

# Q7 Does cancellation policy relate to price? Show the average price and average rating for each policy.

SELECT cancellation_policy ,COUNT(*) AS Total_Listing, ROUND(AVG(price),2) AS Avg_Price , ROUND( AVG(review_rate_number),2) AS Avg_Review_Rating
FROM airbnb
GROUP BY cancellation_policy
ORDER BY Total_Listing DESC;

# Q8 Which neighbourhood groups have an average price above the overall average price?

SELECT neighbourhood_group , ROUND(AVG(price),2) AS Avg_Price
FROM airbnb
GROUP BY neighbourhood_group
HAVING AVG (price) > (SELECT AVG(price) FROM airbnb);

# Q9 Estimate an occupancy rate for each neighbourhood group as (365 - availability_365) / 365.

SELECT neighbourhood_group , ROUND( AVG ( (365 - availability_365 )/ 365 ), 2) AS Occupancy_Rate
FROM airbnb
GROUP BY neighbourhood_group
ORDER BY Occupancy_Rate DESC;

# Q10 Create three price categories (Budget under 300, Mid 300 to 800, Luxury over 800). Count the listings in each category for every neighbourhood group.

SELECT neighbourhood_group,
CASE 
WHEN price <300 THEN 'Budget'
WHEN price <=800 THEN 'Mid'
ELSE 'Luxury'
END AS Category,
COUNT(*) AS Total_Listing
FROM airbnb
GROUP BY  neighbourhood_group , Category
ORDER BY Total_Listing DESC;

# Q11 Which room type has the highest potential yearly revenue per listing, using price * (365 - availability_365)?

SELECT room_type , ROUND(AVG(price *(365 - availability_365)),2) AS Avg_Revenue
FROM airbnb
GROUP BY room_type
ORDER BY Avg_Revenue DESC;

# Q12 How many listings were last reviewed in each year?

SELECT YEAR(last_review) AS Review_Year, COUNT(*) AS Total_Listing
FROM airbnb
WHERE last_review IS NOT NULL
GROUP BY Review_Year
ORDER BY Review_Year;

# Q13 Show the top 3 most expensive listings in each neighbourhood group

SELECT neighbourhood_group,room_type,price
FROM (
SELECT neighbourhood_group,room_type,price,
ROW_NUMBER() OVER ( PARTITION BY neighbourhood_group ORDER BY price DESC) AS rn
FROM airbnb ) ranked
WHERE rn<=3;

# Q14 Which 10 hosts own the most listings, and what percentage of all listings does each one hold?

SELECT host_name,COUNT(*) AS Total_Listing,ROUND( COUNT(*)*100 / ( SELECT COUNT(*) FROM airbnb),2) AS Pct_Of_All
FROM airbnb
GROUP BY  host_name
ORDER BY Total_Listing DESC
LIMIT 10;

# Q15 For each neighbourhood group, show each room type’s share of that group’s listings as a percentage.

SELECT neighbourhood_group ,room_type,
SUM(COUNT(*)) OVER ( PARTITION BY neighbourhood_group) AS Grp_Listing,
COUNT(*) AS Room_Count,
ROUND(COUNT(*)*100 / SUM(COUNT(*)) OVER ( PARTITION BY neighbourhood_group),2) AS Pct_Of_Room_Type
FROM airbnb
GROUP BY neighbourhood_group , room_type
ORDER BY Grp_Listing DESC;