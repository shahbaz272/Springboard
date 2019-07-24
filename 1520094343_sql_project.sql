/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

SELECT name, membercost
FROM  `Facilities` 
WHERE membercost > 0;

"Tennis Court 1","5.0"
"Tennis Court 2","5.0"
"Massage Room 1","9.9"
"Massage Room 2","9.9"
"Squash Court","3.5"


/* Q2: How many facilities do not charge a fee to members? */

SELECT COUNT( * ) AS NoFeeFacilityCount
FROM  `Facilities` 
WHERE membercost = 0;

"NoFeeFacilityCount"
"4"


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name AS  'Facility Name', membercost, monthlymaintenance
FROM  `Facilities` 
WHERE membercost / monthlymaintenance < 0.2;

"facid","Facility Name","membercost","monthlymaintenance"
"0","Tennis Court 1","5.0","200"
"1","Tennis Court 2","5.0","200"
"2","Badminton Court","0.0","50"
"3","Table Tennis","0.0","10"
"4","Massage Room 1","9.9","3000"
"5","Massage Room 2","9.9","3000"
"6","Squash Court","3.5","80"
"7","Snooker Table","0.0","15"
"8","Pool Table","0.0","15"


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SELECT * 
FROM Facilities
WHERE facid
IN ( 1, 5 );

"facid","name","membercost","guestcost","initialoutlay","monthlymaintenance"
"1","Tennis Court 2","5.0","25.0","8000","200"
"5","Massage Room 2","9.9","80.0","4000","3000"


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT name, monthlymaintenance, 
	CASE 	WHEN monthlymaintenance >100
		THEN  'expensive'
		ELSE  'cheap'
	END AS  'CheapOrExpensive'
FROM  `Facilities`;

"name","monthlymaintenance","CheapOrExpensive"
"Tennis Court 1","200","expensive"
"Tennis Court 2","200","expensive"
"Badminton Court","50","cheap"
"Table Tennis","10","cheap"
"Massage Room 1","3000","expensive"
"Massage Room 2","3000","expensive"
"Squash Court","80","cheap"
"Snooker Table","15","cheap"
"Pool Table","15","cheap"


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM  `Members` 
WHERE joindate = ( 
SELECT MAX( joindate ) 
FROM  `Members` );

"firstname","surname"
"Darren","Smith"

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT F.name AS FaciltiyName, CONCAT( M.firstname,  " ", M.surname ) AS FULLNAME
FROM  `Bookings` AS B
INNER JOIN  `Facilities` AS F ON B.facid = F.facid
INNER JOIN  `Members` AS M ON M.memid = B.memid
WHERE F.name LIKE (
'TENNIS COURT%'
)
ORDER BY 2;

"FaciltiyName","FULLNAME"
"Tennis Court 1","Anne Baker"
"Tennis Court 2","Anne Baker"
"Tennis Court 2","Burton Tracy"
"Tennis Court 1","Burton Tracy"
"Tennis Court 1","Charles Owen"
"Tennis Court 2","Charles Owen"
"Tennis Court 2","Darren Smith"
"Tennis Court 1","David Farrell"
"Tennis Court 2","David Farrell"
"Tennis Court 1","David Jones"
"Tennis Court 2","David Jones"
"Tennis Court 1","David Pinker"
"Tennis Court 1","Douglas Jones"
"Tennis Court 1","Erica Crumpet"
"Tennis Court 1","Florence Bader"
"Tennis Court 2","Florence Bader"
"Tennis Court 2","Gerald Butters"
"Tennis Court 1","Gerald Butters"
"Tennis Court 2","GUEST GUEST"
"Tennis Court 1","GUEST GUEST"
"Tennis Court 2","Henrietta Rumney"
"Tennis Court 2","Jack Smith"
"Tennis Court 1","Jack Smith"
"Tennis Court 2","Janice Joplette"
"Tennis Court 1","Janice Joplette"
"Tennis Court 2","Jemima Farrell"
"Tennis Court 1","Jemima Farrell"
"Tennis Court 1","Joan Coplin"
"Tennis Court 2","John Hunt"
"Tennis Court 1","John Hunt"
"Tennis Court 1","Matthew Genting"
"Tennis Court 2","Millicent Purview"
"Tennis Court 2","Nancy Dare"
"Tennis Court 1","Nancy Dare"
"Tennis Court 1","Ponder Stibbons"
"Tennis Court 2","Ponder Stibbons"
"Tennis Court 2","Ramnaresh Sarwin"
"Tennis Court 1","Ramnaresh Sarwin"
"Tennis Court 1","Tim Boothe"
"Tennis Court 2","Tim Boothe"
"Tennis Court 2","Tim Rownam"
"Tennis Court 1","Tim Rownam"
"Tennis Court 2","Timothy Baker"
"Tennis Court 1","Timothy Baker"
"Tennis Court 2","Tracy Smith"
"Tennis Court 1","Tracy Smith"


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT F.name AS FaciltiyName, CONCAT( M.firstname,  " ", M.surname ) AS FULLNAME, 
CASE WHEN B.memid =0
THEN B.slots * F.guestcost
ELSE B.slots * F.membercost
END AS Cost
FROM  `Bookings` AS B
INNER JOIN  `Facilities` AS F ON B.facid = F.facid
INNER JOIN  `Members` AS M ON M.memid = B.memid
WHERE starttime
BETWEEN  '2012-09-14'
AND  '2012-09-15'
HAVING Cost >30
ORDER BY 3 DESC;


"FaciltiyName","FULLNAME","Cost"
"Massage Room 2","GUEST GUEST","320.0"
"Massage Room 1","GUEST GUEST","160.0"
"Massage Room 1","GUEST GUEST","160.0"
"Massage Room 1","GUEST GUEST","160.0"
"Tennis Court 2","GUEST GUEST","150.0"
"Tennis Court 1","GUEST GUEST","75.0"
"Tennis Court 1","GUEST GUEST","75.0"
"Tennis Court 2","GUEST GUEST","75.0"
"Squash Court","GUEST GUEST","70.0"
"Massage Room 1","Jemima Farrell","39.6"
"Squash Court","GUEST GUEST","35.0"
"Squash Court","GUEST GUEST","35.0"


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT F.name AS FaciltiyName, CONCAT( M.firstname,  " ", M.surname ) AS FULLNAME, 
CASE WHEN B.memid =0
THEN B.slots * F.guestcost
ELSE B.slots * F.membercost
END AS Cost
FROM  `Bookings` AS B
INNER JOIN  `Facilities` AS F ON B.facid = F.facid
INNER JOIN  `Members` AS M ON M.memid = B.memid
WHERE starttime
BETWEEN  '2012-09-14'
AND  '2012-09-15'
AND (

SELECT CASE WHEN B.memid =0
THEN B.slots * F.guestcost
ELSE B.slots * F.membercost
END

) >30
ORDER BY 3 DESC;

"FaciltiyName","FULLNAME","Cost"
"Massage Room 2","GUEST GUEST","320.0"
"Massage Room 1","GUEST GUEST","160.0"
"Massage Room 1","GUEST GUEST","160.0"
"Massage Room 1","GUEST GUEST","160.0"
"Tennis Court 2","GUEST GUEST","150.0"
"Tennis Court 1","GUEST GUEST","75.0"
"Tennis Court 2","GUEST GUEST","75.0"
"Tennis Court 1","GUEST GUEST","75.0"
"Squash Court","GUEST GUEST","70.0"
"Massage Room 1","Jemima Farrell","39.6"
"Squash Court","GUEST GUEST","35.0"
"Squash Court","GUEST GUEST","35.0"


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT F.name AS FaciltiyName, SUM( 
CASE WHEN B.memid =0
THEN B.slots * F.guestcost
ELSE B.slots * F.membercost
END ) REVENUE
FROM  `Bookings` AS B
INNER JOIN  `Facilities` AS F ON B.facid = F.facid
INNER JOIN  `Members` AS M ON M.memid = B.memid
GROUP BY 1 
HAVING REVENUE <1000
ORDER BY 2 DESC;


"FaciltiyName","REVENUE"
"Pool Table","270.0"
"Snooker Table","240.0"
"Table Tennis","180.0"

